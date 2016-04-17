//
//  BigEnemyPlane.m
//  planGame
//
//  Created by luowanglin on 3/24/16.
//  Copyright © 2016 com.luowanglin. All rights reserved.
//

#import "BigEnemyPlane.h"
#import <AVFoundation/AVFoundation.h>

@interface BigEnemyPlane ()
{
    NSMutableArray *enemyBlowUpImags;
    NSArray *enemyImgs;
    AVPlayer *plays;
    NSURL *url;
}
@end

@implementation BigEnemyPlane

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.isLife = YES;
        enemyBlowUpImags = [NSMutableArray array];
        for (int i = 1; i < 8; i++) {
            NSString *str = [NSString stringWithFormat:@"enemy2_blowup_%d",i];
            UIImage *imag = [UIImage imageNamed:str];
            [enemyBlowUpImags addObject:imag];
        }
        enemyImgs = @[[UIImage imageNamed:@"enemy2_fly_1"],[UIImage imageNamed:@"enemy2_fly_2"]];
    }
    return self;
}

- (void)statusAnimation{
    self.animationImages = enemyImgs;
    self.animationDuration = 0.5;
    self.animationRepeatCount = 0;
    [self startAnimating];
}
//爆炸动画
-(void)blowUpBig{
    
    self.animationImages = enemyBlowUpImags;
    self.animationDuration = 0.5;
    self.animationRepeatCount = 0;
    [self startAnimating];
    
    dispatch_queue_t concurrnt = dispatch_queue_create("concurrnt_audio_bigEnemy", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrnt, ^{
        [self playBackgrounSound];
    });

}

- (void)playBackgrounSound{
    //播放声音
    url = [[NSBundle mainBundle]URLForResource:@"explosion" withExtension:@"mp3"];
    plays = [AVPlayer playerWithURL:url];
    [plays play];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
