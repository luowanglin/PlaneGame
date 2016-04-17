//
//  SmallEnemyPlane.m
//  planGame
//
//  Created by luowanglin on 3/24/16.
//  Copyright © 2016 com.luowanglin. All rights reserved.
//

#import "SmallEnemyPlane.h"
#import <AVFoundation/AVFoundation.h>

@interface SmallEnemyPlane ()
{
    NSMutableArray *smallEnemyImags;
    AVPlayer *plays;
    NSURL *url;
}
@end

@implementation SmallEnemyPlane

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.islife = YES;
        smallEnemyImags = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            NSString *str = [NSString stringWithFormat:@"enemy1_blowup_%d",i];
            UIImage *imag = [UIImage imageNamed:str];
            [smallEnemyImags addObject:imag];
        }

    }
    
    return self;
}

- (void)blowUPSmall{
    
    self.animationImages = smallEnemyImags;
    self.animationDuration = 0.5;
    self.animationRepeatCount = 1;
    [self startAnimating];
//    [self performSelectorInBackground:@selector(playBackgrounSound) withObject:nil];
    dispatch_queue_t concurrnt = dispatch_queue_create("concurrnt_audio_smallEnemy", DISPATCH_QUEUE_CONCURRENT);
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
