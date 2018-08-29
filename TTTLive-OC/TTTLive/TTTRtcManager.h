//
//  TTTRtcManager.h
//  TTTLive
//
//  Created by yanzhen on 2018/8/21.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TTTRtcEngineKit/TTTRtcEngineKit.h>
#import "TTTUser.h"

typedef struct {
    BOOL mix;
    CGSize videoSize; //default is 360x640
    NSUInteger fps;
    BOOL h265;
    NSUInteger videoBitRate;
    BOOL channels;//是否双声道
}TTTMixSettings;

static CGSize TTTVideoMixSize[] = {
    [TTTRtc_VideoProfile_120P] = {160, 120},
    [TTTRtc_VideoProfile_180P] = {320, 180},
    [TTTRtc_VideoProfile_240P] = {320, 240},
    [TTTRtc_VideoProfile_360P] = {640, 360},
    [TTTRtc_VideoProfile_480P] = {640, 480},
    [TTTRtc_VideoProfile_720P] = {1280, 720},
    [TTTRtc_VideoProfile_1080P] = {1920, 1080},
};

@interface TTTRtcManager : NSObject
@property (nonatomic, strong) TTTRtcEngineKit *rtcEngine;
@property (nonatomic, strong) TTTUser *me;
@property (nonatomic, assign) int64_t roomID;
@property (nonatomic, assign) TTTMixSettings mixSettings;

+ (instancetype)manager;
- (void)originCdn;
@end
