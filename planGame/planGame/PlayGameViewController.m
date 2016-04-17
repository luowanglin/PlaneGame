//
//  PlayGameViewController.m
//  planGame
//
//  Created by luowanglin on 3/24/16.
//  Copyright © 2016 com.luowanglin. All rights reserved.
//

#import "PlayGameViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "SmallEnemyPlane.h"
#import "BigEnemyPlane.h"

#define kUpdateInterval (1.0f/10.0f)


@interface PlayGameViewController ()
{
//    UIImageView *imagView;
    CADisplayLink *displayLink;
    BOOL isTap;
    int timeRcoder;
    UIImageView *airPlan;
    NSTimer *timer;
    CMMotionManager *motionManger;
    NSOperationQueue *queue;
    double x;
    double y;

    NSMutableArray *EnemyArry;
    NSMutableArray *bulletArry;
        
    
    UIButton *startBtn;
    int flagValue;//子弹发射频率标志
    
    AVAudioPlayer *audio;
    CGPoint point;
    
    UILabel *scoreLabel;//等分标签
    int score;
}

@end

@implementation PlayGameViewController

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.76 green:0.78 blue:0.79 alpha:1];
    isTap = YES;
    timeRcoder = 240;
    flagValue = 3;
    score = 0;
    
    point = CGPointMake(160, 400);
    
//    imagView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    imagView.image = [UIImage imageNamed:@"background_2"];
//    [self.view addSubview:imagView];
    
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(backImagMove)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    displayLink.paused = NO;
    
    
    startBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    startBtn.frame = CGRectMake(10, 10, 40, 40);
    [startBtn setBackgroundImage:[UIImage imageNamed:@"BurstAircraftPause@2x"] forState:(UIControlStateNormal)];
    [startBtn addTarget:self action:@selector(startBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:startBtn];
    
    //英雄号飞机初始化
    airPlan = [[UIImageView alloc]initWithFrame:CGRectMake(160, 468, 60, 50)];
//    airPlan.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-80);
    airPlan.animationImages = @[[UIImage imageNamed:@"hero_fly_1"],[UIImage imageNamed:@"hero_fly_2"]];
    airPlan.animationDuration = 1.f;
    airPlan.animationRepeatCount = 0;
    [airPlan startAnimating];
    [self.view addSubview:airPlan];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(imagePositionTest) userInfo:nil repeats:YES];
    [timer fire];
    
    
    
    //重力感应方向的实现
    motionManger = [[CMMotionManager alloc]init];
    queue = [[NSOperationQueue alloc]init];
    motionManger.accelerometerUpdateInterval = kUpdateInterval;
    [motionManger startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        
        x = accelerometerData.acceleration.x*500+130;
        y = accelerometerData.acceleration.y*400+400;
    }];
    
    EnemyArry = [NSMutableArray array];
    bulletArry = [NSMutableArray array];
    
    scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(startBtn.frame)+10, 10, 80, 40)];
    scoreLabel.text = @"0";
    scoreLabel.font = [UIFont systemFontOfSize:30];
    scoreLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:scoreLabel];
}

//计时调用方法的实现
- (void)backImagMove{
    
    if (timeRcoder % 30 == 0) {
        int width = arc4random() % 10;
        UIImageView *temImage = [[UIImageView alloc]initWithFrame:CGRectMake(arc4random() % (320-width), -60, 40+width, 40+width)];
        temImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",arc4random()%6]];
        [self.view insertSubview:temImage atIndex:0];
        
        //移动背景动画
        [UIView animateWithDuration:7.f animations:^{
            temImage.center = CGPointMake(temImage.center.x, [UIScreen mainScreen].bounds.size.height+60);
        } completion:^(BOOL finished) {
            [temImage removeFromSuperview];
        }];

    }
   
    if (timeRcoder % 60 == 0) {
        //添加敌机对象
        if (timeRcoder % 180 == 0) {
            BigEnemyPlane *enemyPlan = [[BigEnemyPlane alloc]initWithFrame:CGRectMake(arc4random()%260, -80, 60, 50)];
            [enemyPlan statusAnimation];
            enemyPlan.tag = 2;
            [self.view addSubview:enemyPlan];
            [self.view insertSubview:enemyPlan belowSubview:startBtn];
            [EnemyArry addObject:enemyPlan];
        }
        
        SmallEnemyPlane *smalleEnemy = [[SmallEnemyPlane alloc]initWithFrame:CGRectMake(arc4random()%280, -40, 40, 30)];
        smalleEnemy.tag = 3;
        smalleEnemy.image = [UIImage imageNamed:@"enemy1_fly_1"];
        [self.view addSubview:smalleEnemy];
        [self.view insertSubview:smalleEnemy belowSubview:startBtn];
        [EnemyArry addObject:smalleEnemy];

        
    }
    
    timeRcoder++;
    
    //检测是否击中，及其
    [self checkColliction];
    
}

//检测是否击中，及其
- (void)checkColliction{
    for(int i = 0; i < EnemyArry.count;i++){
        UIImageView *enemy = EnemyArry[i];
        for (int b = 0; b < bulletArry.count; b++) {
            UIImageView *bullet = bulletArry[b];
            if (bullet.center.x > enemy.frame.origin.x && bullet.center.x < enemy.frame.origin.x+60 && bullet.center.y > enemy.center.y-25 && bullet.center.y < enemy.center.y+25) {
                NSLog(@"zhidazhongle ");
                if (enemy.tag == 3) {
                    SmallEnemyPlane *small = (SmallEnemyPlane*)enemy;
                    small.islife = NO;
                    [small blowUPSmall];
//                    [small performSelectorInBackground:@selector(blowUPSmall) withObject:nil];
                }else if(enemy.tag == 2){
                    BigEnemyPlane *big = (BigEnemyPlane*)enemy;
                    big.isLife = NO;
                    [big blowUpBig];
//                    [big performSelectorInBackground:@selector(blowUpBig) withObject:nil];
                }
                [self performSelector:@selector(removeAirPlan) withObject:nil afterDelay:0.5];
                [bullet removeFromSuperview];
                [bulletArry removeObject:bullet];
                score++;
                scoreLabel.text = [NSString stringWithFormat:@"%d",score];
            }else if (bullet.center.y < 20){
                NSLog(@"zhixingle");
                [bullet removeFromSuperview];
                [bulletArry removeObject:bullet];
            }
        }
        if (enemy.center.y > 600||enemy.hidden == YES) {
            NSLog(@"yichuenemy");
            [enemy removeFromSuperview];
            [EnemyArry removeObject:enemy];
//        }else if (enemy.center.y > 600){
//            displayLink.paused = YES;
//            UIAlertController *alertVt = [UIAlertController alertControllerWithTitle:@"game over" message:[NSString stringWithFormat:@"总等分：%d",score] preferredStyle:(UIAlertControllerStyleAlert)];
//            UIAlertAction *gono = [UIAlertAction actionWithTitle:@"继续" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
//                for (UIImageView *imagV in EnemyArry) {
//                    [imagV removeFromSuperview];
//                    [EnemyArry removeObject:imagV];
//                }
////                [EnemyArry removeAllObjects];
//            }];
//            [alertVt addAction:gono];
//            [self presentViewController:alertVt animated:YES completion:^{
//                score = 0;
//                displayLink.paused = NO;
//            }];
        }
    }

}

//延时移除飞机
- (void)removeAirPlan{
    for (UIImageView *enemy in EnemyArry) {
        if (enemy.tag == 2) {
            BigEnemyPlane *big = (BigEnemyPlane*)enemy;
            if (big.isLife == NO) {
                [enemy removeFromSuperview];
                enemy.hidden = YES;
            }
        }if (enemy.tag == 3) {
            SmallEnemyPlane *small = (SmallEnemyPlane*)enemy;
            if (small.islife == NO) {
                [enemy removeFromSuperview];
                enemy.hidden = YES;
            }
        }
    }
}

//开始按钮响应的实现
- (void)startBtnAction:(UIButton*)sender{
    isTap = !isTap;
    if (isTap) {
        [sender setBackgroundImage:[UIImage imageNamed:@"BurstAircraftPause@2x"] forState:(UIControlStateNormal)];
        displayLink.paused = NO;
    }else{
        [sender setBackgroundImage:[UIImage imageNamed:@"BurstAircraftStart@2x"] forState:(UIControlStateNormal)];
        displayLink.paused = YES;
    }
}


//轮循位置检测
- (void)imagePositionTest{
    for (UIImageView *obj in bulletArry) {
        [UIView animateWithDuration:1/60 animations:^{
            obj.center = CGPointMake(obj.center.x, obj.center.y-5);
        }];
    }
    for (UIImageView *obj in EnemyArry){
        [UIView animateWithDuration:1/60 animations:^{
            obj.center = CGPointMake(obj.center.x, obj.center.y+0.5);
        }];
    }
    [UIView animateWithDuration:1/60 animations:^{
        airPlan.center = CGPointMake(x+airPlan.bounds.size.width/2, y+airPlan.bounds.size.height/2);//重力感应
//        airPlan.center = CGPointMake(point.x, point.y);//触摸移动
    }];
    
    if (flagValue % 15 == 0) {
        [self shootAction];
    }
    flagValue++;
    
}

//发射子弹
- (void)shootAction{
    UIImageView *bullet = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 20)];
    bullet.center = airPlan.center;
    bullet.image = [UIImage imageNamed:@"bullet1"];
    [self.view insertSubview:bullet belowSubview:airPlan];
    [bulletArry addObject:bullet];
    
    dispatch_queue_t concurrent = dispatch_queue_create("shoot_audio", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrent, ^{
        NSURL *url = [[NSBundle mainBundle]URLForResource:@"shoot" withExtension:@"mp3"];
        audio = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        [audio play];
        
    });
    
}



//触摸移动获取位置
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    point = [touch locationInView:self.view];
}

@end
