//
//  TTTRtcManager.m
//  TTTLive
//
//  Created by yanzhen on 2018/8/21.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

#import "TTTRtcManager.h"

@implementation TTTRtcManager
static id _manager;
+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //输入申请的AppId
        _rtcEngine = [TTTRtcEngineKit sharedEngineWithAppId:<#AppId#> delegate:nil];
        _me = [[TTTUser alloc] initWith:0];
        _localProfile = TTTRtc_VideoProfile_Default;
        _cdnProfile = TTTRtc_VideoProfile_Default;
    }
    return self;
}

- (UIImage *)getVoiceImage:(NSUInteger)level {
    UIImage *image = nil;
    if (level < 4) {
        image = [UIImage imageNamed:@"volume_1"];
    } else if (level < 7) {
        image = [UIImage imageNamed:@"volume_2"];
    } else {
        image = [UIImage imageNamed:@"volume_3"];
    }
    return image;
}

- (NSArray<NSString *> *)getVideoInfo:(TTTRtcVideoProfile)profile {
    switch (profile) {
        case TTTRtc_VideoProfile_120P:
            return @[@"65", @"160x120", @"15", @"0"];
            break;
        case TTTRtc_VideoProfile_180P:
            return @[@"140", @"320x180", @"15", @"1"];
            break;
        case TTTRtc_VideoProfile_240P:
            return @[@"200", @"320x240", @"15", @"2"];
            break;
        case TTTRtc_VideoProfile_480P:
            return @[@"1000", @"848x480", @"15", @"4"];
            break;
        case TTTRtc_VideoProfile_640x480:
            return @[@"800", @"640x480", @"15", @"5"];
            break;
        case TTTRtc_VideoProfile_960x540:
            return @[@"1600", @"960x540", @"24", @"6"];
            break;
        case TTTRtc_VideoProfile_720P:
            return @[@"2400", @"1280x720", @"30", @"7"];
            break;
        case TTTRtc_VideoProfile_1080P:
            return @[@"3000", @"1920x1080", @"30", @"8"];
            break;
        default:
            return @[@"600", @"640x360", @"15", @"3"];
            break;
    }
}

- (TTTRtcVideoProfile)getProfileIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return TTTRtc_VideoProfile_120P;
            break;
        case 1:
            return TTTRtc_VideoProfile_180P;
            break;
        case 2:
            return TTTRtc_VideoProfile_240P;
            break;
        case 4:
            return TTTRtc_VideoProfile_480P;
            break;
        case 5:
            return TTTRtc_VideoProfile_640x480;
            break;
        case 6:
            return TTTRtc_VideoProfile_960x540;
            break;
        case 7:
            return TTTRtc_VideoProfile_720P;
            break;
        case 8:
            return TTTRtc_VideoProfile_1080P;
            break;
        default:
            return TTTRtc_VideoProfile_360P;
            break;
    }
}
@end
