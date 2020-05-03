//
//  TTTSLocalViewController.m
//  TTTLive
//
//  Created by yanzhen on 2018/9/13.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

#import "TTTSLocalViewController.h"

@interface TTTSLocalViewController ()
@property (weak, nonatomic) IBOutlet UITextField *videoTitleTF;
@property (weak, nonatomic) IBOutlet UITextField *videoSizeTF;
@property (weak, nonatomic) IBOutlet UITextField *videoBitrateTF;
@property (weak, nonatomic) IBOutlet UITextField *videoFpsTF;
@property (weak, nonatomic) IBOutlet UISwitch *audioSwitch;
@property (weak, nonatomic) IBOutlet UIView *pickBGView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (nonatomic, strong) NSArray<NSString *> *videoSizes;
@end

@implementation TTTSLocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _videoSizes = @[@"120P", @"180P", @"240P", @"360P", @"480P", @"640x480", @"960x540", @"720P", @"1080P", @"自定义"];
    _audioSwitch.on = TTManager.isHighQualityAudio;
    BOOL isCustom = TTManager.localCustomProfile.isCustom;
    [self refreshState:isCustom profile:TTManager.localProfile];
    if (isCustom) {
        [_pickView selectRow:9 inComponent:0 animated:YES];
        TTTCustomVideoProfile custom = TTManager.localCustomProfile;
        _videoSizeTF.text = [NSString stringWithFormat:@"%.0fx%.0f", custom.videoSize.width, custom.videoSize.height];
        _videoBitrateTF.text = [NSString stringWithFormat:@"%lu", custom.videoBitRate];
        _videoFpsTF.text = [NSString stringWithFormat:@"%lu", custom.fps];
    } else {
        [_pickView selectRow:[TTManager getVideoInfo:TTManager.localProfile][3].integerValue inComponent:0 animated:YES];
    }
}

- (NSString *)saveSettings {
    if ([_videoTitleTF.text isEqualToString:_videoSizes.lastObject]) {
        NSArray<NSString *> *sizes = [_videoSizeTF.text componentsSeparatedByString:@"x"];
        if (sizes.count != 2) {
            return @"请输入正确的视频参数";
        }
        if (sizes[0].longLongValue <= 0 || sizes[1].longLongValue <= 0) {
            return @"请输入正确的视频参数";
        }
        
        if (sizes[0].longLongValue > 1920) {
            return @"视频宽最大为1920";
        }
        
        if (sizes[1].longLongValue > 1080) {
            return @"视频高最大为1080";
        }
        
        if (_videoBitrateTF.text.longLongValue <= 0) {
            return @"请输入正确码率参数";
        }
        
        if (_videoBitrateTF.text.longLongValue > 5000) {
            return @"码率不能大于5000";
        }
        
        if (_videoFpsTF.text.longLongValue <= 0) {
            return @"请输入正确帧率参数";
        }
        
        TTTCustomVideoProfile profile = {YES, CGSizeMake(sizes[0].longLongValue, sizes[1].longLongValue), _videoBitrateTF.text.integerValue, _videoFpsTF.text.longLongValue};
        TTManager.localCustomProfile = profile;
    } else {
        TTTCustomVideoProfile profile = {NO, CGSizeZero, 0, 0};
        TTManager.localCustomProfile = profile;
        NSInteger index = [_pickView selectedRowInComponent:0];
        TTManager.localProfile = [TTManager getProfileIndex:index];
    }
    TTManager.isHighQualityAudio = _audioSwitch.isOn;
    return nil;
}

- (void)refreshState:(BOOL)isCustom profile:(TTTRtcVideoProfile)profile {
    if (isCustom) {
        _videoTitleTF.text = @"自定义";
        _videoSizeTF.enabled = YES;
        _videoBitrateTF.enabled = YES;
        _videoFpsTF.enabled = YES;
    } else {
        NSArray<NSString *> *info = [TTManager getVideoInfo:profile];
        _videoTitleTF.text = _videoSizes[info[3].integerValue];
        _videoSizeTF.enabled = NO;
        _videoBitrateTF.enabled = NO;
        _videoFpsTF.enabled = NO;
        _videoSizeTF.text = info[1];
        _videoBitrateTF.text = info[0];
        _videoFpsTF.text = info[2];
    }
}

- (IBAction)showMoreVideoPara:(id)sender {
    _pickBGView.hidden = NO;
}

- (IBAction)cancelSetting:(id)sender {
    _pickBGView.hidden = YES;
}

- (IBAction)sureSetting:(id)sender {
    _pickBGView.hidden = YES;
    NSInteger index = [_pickView selectedRowInComponent:0];
    TTTRtcVideoProfile profile = [TTManager getProfileIndex:index];
    [self refreshState:index == 9 profile:profile];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - pickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _videoSizes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _videoSizes[row];
}
@end
