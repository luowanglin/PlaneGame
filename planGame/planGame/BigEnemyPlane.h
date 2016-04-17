//
//  BigEnemyPlane.h
//  planGame
//
//  Created by luowanglin on 3/24/16.
//  Copyright © 2016 com.luowanglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigEnemyPlane : UIImageView
@property BOOL isLife;

-(void)blowUpBig;
- (void)statusAnimation;
@end
