//
//  TTTLoginViewController.m
//  TTTLive
//
//  Created by yanzhen on 2018/8/21.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

#import "TTTLoginViewController.h"

static NSString *const TTTH265 = @"?trans=1";

@interface TTTLoginViewController ()<TTTRtcEngineDelegate>
@property (weak, nonatomic) IBOutlet UIButton *anchorBtn;
@property (weak, nonatomic) IBOutlet UIButton *cdnBtn;
@property (weak, nonatomic) IBOutlet UITextField *roomIDTF;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;

@property (nonatomic, weak) UIButton *roleSelectedBtn;
@property (nonatomic, assign) int64_t uid;
@end

@implementation TTTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _roleSelectedBtn = _anchorBtn;
    NSString *dateStr = NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"];
    _websiteLabel.text = [TTTRtcEngineKit.getSdkVersion stringByAppendingFormat:@"__%@", dateStr];
    _uid = arc4random() % 100000 + 1;
    int64_t roomID = [[NSUserDefaults standardUserDefaults] stringForKey:@"ENTERROOMID"].integerValue;
    if (roomID == 0) {
        roomID = arc4random() % 1000000 + 1;
    }
    _roomIDTF.text = [NSString stringWithFormat:@"%lld", roomID];
}

- (IBAction)roleBtnsAction:(UIButton *)sender {
    if (sender.isSelected) { return; }
    _roleSelectedBtn.selected = NO;
    _roleSelectedBtn.backgroundColor = [UIColor colorWithRed:139 / 255.0 green:39 / 255.0 blue:54 / 255.0 alpha:1];
    sender.selected = YES;
    sender.backgroundColor = [UIColor colorWithRed:1 green:245 / 255.0 blue:11 / 255.0 alpha:1];
    _roleSelectedBtn = sender;
    _cdnBtn.hidden = sender != _anchorBtn;
}

- (IBAction)enterChannel:(id)sender {
    if (_roomIDTF.text.integerValue == 0 || _roomIDTF.text.length >= 19) {
        [self showToast:@"请输入大于0，19位以内的房间ID"];
        return;
    }
    int64_t rid = _roomIDTF.text.longLongValue;
    [NSUserDefaults.standardUserDefaults setValue:_roomIDTF.text forKey:@"ENTERROOMID"];
    [NSUserDefaults.standardUserDefaults synchronize];
    [TTProgressHud showHud:self.view];
    TTTRtcClientRole clientRole = _roleSelectedBtn.tag - 100;
    TTManager.me.clientRole = clientRole;
    TTManager.me.uid = _uid;
    TTManager.roomID = rid;
    TTManager.me.mutedSelf = false;
    TTTRtcEngineKit *rtcEngine = TTManager.rtcEngine;
    rtcEngine.delegate = self;
    [rtcEngine setChannelProfile:TTTRtc_ChannelProfile_LiveBroadcasting];
    [rtcEngine setClientRole:clientRole];
    [rtcEngine enableAudioVolumeIndication:200 smooth:3];
//    [rtcEngine setLogFilter:TTTRtc_LogFilter_Debug];
    BOOL swapWH = UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation);
    if (clientRole == TTTRtc_ClientRole_Anchor) {
        if (TTManager.isCustom) {//自定义设置
            [self customEnterChannel];
            [rtcEngine startPreview];
        } else {
            [rtcEngine enableVideo];
            [rtcEngine startPreview];
            [rtcEngine muteLocalAudioStream:NO];
            TTTPublisherConfiguration *config = [[TTTPublisherConfiguration alloc] init];
            config.publishUrl = [@"rtmp://push.3ttest.cn/sdk2/" stringByAppendingFormat:@"%@", _roomIDTF.text];
            [rtcEngine configPublisher:config];
            [rtcEngine setVideoProfile:TTTRtc_VideoProfile_360P swapWidthAndHeight:swapWH];
        }
    } else if (clientRole == TTTRtc_ClientRole_Broadcaster) {
        [rtcEngine enableVideo];
        [rtcEngine startPreview];
        [rtcEngine muteLocalAudioStream:NO];
        [rtcEngine setVideoProfile:TTTRtc_VideoProfile_120P swapWidthAndHeight:swapWH];
    } else {
        [rtcEngine enableLocalVideo:NO];
        [rtcEngine muteLocalAudioStream:YES];
    }

    [rtcEngine joinChannelByKey:nil channelName:_roomIDTF.text uid:_uid joinSuccess:nil];
}

- (void)customEnterChannel {
    TTTRtcEngineKit *rtcEngine = TTManager.rtcEngine;
    [rtcEngine enableVideo];
    [rtcEngine muteLocalAudioStream:NO];
    TTTPublisherConfiguration *config = [[TTTPublisherConfiguration alloc] init];
    NSString *pushURL = [@"rtmp://push.3ttest.cn/sdk2/" stringByAppendingString:_roomIDTF.text];
    //h265
    if (TTManager.h265) {
        pushURL = [pushURL stringByAppendingString:TTTH265];
    }
    config.publishUrl = pushURL;
    //local
    BOOL swapWH = UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation);
    if (TTManager.localCustomProfile.isCustom) {
        TTTCustomVideoProfile custom = TTManager.localCustomProfile;
        CGSize videoSize = custom.videoSize;
        if (swapWH) {
            videoSize = CGSizeMake(videoSize.height, videoSize.width);
        }
        [rtcEngine setVideoProfile:videoSize frameRate:custom.fps bitRate:custom.videoBitRate];
    } else {
        [rtcEngine setVideoProfile:TTManager.localProfile swapWidthAndHeight:swapWH];
    }
    //高音质
    if (TTManager.isHighQualityAudio) {
        [rtcEngine setPreferAudioCodec:TTTRtc_AudioCodec_AAC bitrate:96 channels:1];
    }
    //cdn
    TTTCustomVideoProfile custom = TTManager.cdnCustom;
    config.videoFrameRate = custom.fps;
    config.videoBitrate = custom.videoBitRate;
    if (TTManager.doubleChannel) {
        config.samplerate = 44100;
        config.channels = 2;
    } 
    [rtcEngine configPublisher:config];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - TTTRtcEngineDelegate
-(void)rtcEngine:(TTTRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(int64_t)uid elapsed:(NSInteger)elapsed {
    [TTProgressHud hideHud:self.view];
    [self performSegueWithIdentifier:@"Live" sender:nil];
}

-(void)rtcEngine:(TTTRtcEngineKit *)engine didOccurError:(TTTRtcErrorCode)errorCode {
    NSString *errorInfo = @"";
    switch (errorCode) {
        case TTTRtc_Error_Enter_TimeOut:
            errorInfo = @"超时,10秒未收到服务器返回结果";
            break;
        case TTTRtc_Error_Enter_Failed:
            errorInfo = @"该直播间不存在";
            break;
        case TTTRtc_Error_Enter_BadVersion:
            errorInfo = @"版本错误";
            break;
        case TTTRtc_Error_InvalidChannelName:
            errorInfo = @"Invalid channel name";
            break;
        case TTTRtc_Error_Enter_NoAnchor:
            errorInfo = @"房间内无主播";
            break;
        default:
            errorInfo = [NSString stringWithFormat:@"未知错误：%zd",errorCode];
            break;
    }
    [TTProgressHud hideHud:self.view];
    [self showToast:errorInfo];
}
@end
