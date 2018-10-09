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
        _rtcEngine = [TTTRtcEngineKit sharedEngineWithAppId:@"a967ac491e3acf92eed5e1b5ba641ab7" delegate:nil];
        _me = [[TTTUser alloc] initWith:0];
        _localProfile = TTTRtc_VideoProfile_Default;
        _cdnProfile = TTTRtc_VideoProfile_Default;
    }
    return self;
}


@end
