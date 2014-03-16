//
//  SoundSong.m
//  GameGroup
//
//  Created by wangxr on 14-3-16.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "SoundSong.h"
@interface SoundSong()
@property (nonatomic,retain)NSTimer * timer;
@property (nonatomic,assign)BOOL sound;
@end
@implementation SoundSong
static SoundSong *sharedInstance=nil;
+(void)soundSong
{
    @synchronized(self)
    {
        if(!sharedInstance)
        {
            sharedInstance=[[self alloc] init];
            sharedInstance.sound = YES;
        }
    }
    if (sharedInstance.sound) {
        AudioServicesPlayAlertSound(1007);
        sharedInstance.sound = NO;
    }
    if (sharedInstance.timer) {
        [sharedInstance.timer invalidate];
    }
    sharedInstance.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:sharedInstance selector:@selector(timerDown) userInfo:nil repeats:YES];
}
- (void)timerDown
{
    self.sound = YES;
    [sharedInstance.timer invalidate];
}
@end
