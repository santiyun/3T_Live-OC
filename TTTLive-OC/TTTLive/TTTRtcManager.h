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
    BOOL isCustom;
    CGSize videoSize;
    NSUInteger videoBitRate;
    NSUInteger fps;
} TTTCustomVideoProfile;

@interface TTTRtcManager : NSObject
@property (nonatomic, strong) TTTRtcEngineKit *rtcEngine;
@property (nonatomic, strong) TTTUser *me;
@property (nonatomic, assign) int64_t roomID;
//settings
@property (nonatomic, assign) BOOL isCustom;
//-local
@property (nonatomic, assign) BOOL isHighQualityAudio;
@property (nonatomic, assign) TTTRtcVideoProfile localProfile;//set default is 360P
@property (nonatomic, assign) TTTCustomVideoProfile localCustomProfile;
//cdn
@property (nonatomic, assign) BOOL h265;
@property (nonatomic, assign) BOOL doubleChannel;
@property (nonatomic, assign) TTTRtcVideoProfile cdnProfile;
@property (nonatomic, assign) TTTCustomVideoProfile cdnCustom;

+ (instancetype)manager;
- (UIImage *)getVoiceImage:(NSUInteger)level;
- (NSArray<NSString *> *)getVideoInfo:(TTTRtcVideoProfile)profile;
- (TTTRtcVideoProfile)getProfileIndex:(NSInteger)index;
@end
