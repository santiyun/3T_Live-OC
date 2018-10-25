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
    NSString *websitePrefix = @"http://www.3ttech.cn  version  ";
    _websiteLabel.text = [websitePrefix stringByAppendingString:TTTRtcEngineKit.getSdkVersion];
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
    _roleSelectedBtn.backgroundColor = UIColor.blackColor;
    sender.selected = YES;
    sender.backgroundColor = UIColor.cyanColor;
    _roleSelectedBtn = sender;
    _cdnBtn.hidden = sender != _anchorBtn;
}

- (IBAction)enterChannel:(id)sender {
    if (_roomIDTF.text.integerValue == 0 || _roomIDTF.text.length >= 19) {
        [self showToast:@"请输入19位以内的房间ID"];
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
    [rtcEngine setClientRole:clientRole withKey:nil];
    [rtcEngine enableAudioVolumeIndication:200 smooth:3];
    BOOL swapWH = UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation);
    if (clientRole == TTTRtc_ClientRole_Anchor) {
        if (TTManager.isCustom) {//自定义设置
            [self customEnterChannel];
        } else {
            [rtcEngine enableVideo];
            [rtcEngine muteLocalAudioStream:NO];
            TTTPublisherConfigurationBuilder *builder = [[TTTPublisherConfigurationBuilder alloc] init];
            NSString *pushURL = [@"http://push.3ttech.cn/sdk/" stringByAppendingFormat:@"%@", _roomIDTF.text];
            //pull -- rtmp://pull.3ttech.cn/sdk/_roomIDTF.text
            [builder setPublisherUrl:pushURL];
            [rtcEngine configPublisher:builder.build];
            [rtcEngine setVideoProfile:TTTRtc_VideoProfile_360P swapWidthAndHeight:swapWH];
        }
    } else if (clientRole == TTTRtc_ClientRole_Broadcaster) {
        [rtcEngine enableVideo];
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
    TTTPublisherConfigurationBuilder *builder = [[TTTPublisherConfigurationBuilder alloc] init];
    NSString *pushURL = [@"rtmp://push.3ttech.cn/sdk/" stringByAppendingString:_roomIDTF.text];
    //h265
    if (TTManager.h265) {
        pushURL = [pushURL stringByAppendingString:TTTH265];
    }
    [builder setPublisherUrl:pushURL];
    [rtcEngine configPublisher:builder.build];
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
        [rtcEngine setHighQualityAudioParametersWithFullband:YES stereo:YES fullBitrate:YES];
    }
    //cdn
    TTTCustomVideoProfile custom = TTManager.cdnCustom;
    CGSize videoSize = custom.videoSize;
    if (swapWH) {
        videoSize = CGSizeMake(videoSize.height, videoSize.width);
    }
    [rtcEngine setVideoMixerParams:videoSize videoFrameRate:custom.fps videoBitRate:custom.videoBitRate];
    if (TTManager.doubleChannel) {
        [rtcEngine setAudioMixerParams:44100 channels:2];
    } else {
        [rtcEngine setAudioMixerParams:48000 channels:1];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_roomIDTF resignFirstResponder];
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
        default:
            errorInfo = [NSString stringWithFormat:@"未知错误：%zd",errorCode];
            break;
    }
    [TTProgressHud hideHud:self.view];
    [self showToast:errorInfo];
}
@end
