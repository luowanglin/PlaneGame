//
//  ViewController.m
//  planGame
//
//  Created by luowanglin on 3/23/16.
//  Copyright © 2016 com.luowanglin. All rights reserved.
//

#import "ViewController.h"
#import "PlayGameViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation ViewController

-(BOOL)prefersStatusBarHidden{
    return YES;
}

//重写此方法 ，以免在使用动作传感器时屏幕发生旋转
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.startBtn.titleLabel setFont:[UIFont systemFontOfSize:30]];
    self.startBtn.layer.borderWidth = 2.f;
    self.startBtn.layer.borderColor = [[UIColor grayColor]CGColor];
    self.startBtn.layer.cornerRadius = 5.f;
    self.startBtn.layer.masksToBounds = YES;
    
//    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    btn.frame = CGRectMake(1, 0, 80, 40);
//    btn.center = CGPointMake(160, 400);
//    [btn setTitle:@"大爷" forState:(UIControlStateNormal)];
//    [btn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
//    [self.view addSubview:btn];
//    [btn.titleLabel setFont:[UIFont fontWithName:@"汉仪清雅体简" size:30.f]];
}
//- (IBAction)startAction:(UIButton *)sender {
//    PlayGameViewController *playView = [PlayGameViewController new];
//    [self presentViewController:playView animated:YES completion:nil];
//    
//}


@end
