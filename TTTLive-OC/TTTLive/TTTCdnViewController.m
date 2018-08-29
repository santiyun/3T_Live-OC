//
//  TTTCdnViewController.m
//  TTTLive
//
//  Created by yanzhen on 2018/8/27.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

#import "TTTCdnViewController.h"

@interface TTTCdnViewController ()
@property (weak, nonatomic) IBOutlet UIButton *size2Btn;
@property (weak, nonatomic) IBOutlet UIButton *fps2Btn;
@property (weak, nonatomic) IBOutlet UIButton *h264Btn;
@property (weak, nonatomic) IBOutlet UIButton *channelsBtn;
//当前选中的btn
@property (nonatomic, weak) UIButton *sizeBtn;
@property (nonatomic, weak) UIButton *fpsBtn;
@property (nonatomic, weak) UIButton *formatBtn;
@property (nonatomic, weak) UIButton *sampleSBtn;
@end

@implementation TTTCdnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _sizeBtn = _size2Btn;
    _fpsBtn = _fps2Btn;
    _formatBtn = _h264Btn;
    _sampleSBtn = _channelsBtn;
}

- (IBAction)sureBtnAction:(id)sender {
    self.view.hidden = YES;
    BOOL h265 = _formatBtn != _h264Btn;
    NSUInteger fps = 15;
    if (_fpsBtn.tag == 1) {
        fps = 10;
    } else if (_fpsBtn.tag == 3) {
        fps = 30;
    }
    //视频竖屏，默认交换宽高
    NSUInteger videoBitRate = 500;
    CGSize videoSize = CGSizeMake(480, 640);
    if (_sizeBtn.tag == 1) {
        videoBitRate = 200;
        videoSize = CGSizeMake(240, 320);
    } else if (_sizeBtn.tag == 3) {
        videoBitRate = 1130;
        videoSize = CGSizeMake(720, 1280);
    }
    TTTMixSettings mixSettings = TTManager.mixSettings;
    mixSettings.mix = YES;
    mixSettings.videoSize = videoSize;
    mixSettings.fps = fps;
    mixSettings.h265 = h265;
    mixSettings.videoBitRate = videoBitRate;
    mixSettings.channels = _sampleSBtn == _channelsBtn;
}

- (IBAction)sizeBtnAction:(id)sender {
    _sizeBtn = [self switchSelectedBtn:sender selectedBtn:_sizeBtn];
}

- (IBAction)fpsBtnAction:(UIButton *)sender {
    _fpsBtn = [self switchSelectedBtn:sender selectedBtn:_fpsBtn];
}

- (IBAction)formatBtnAction:(UIButton *)sender {
    _formatBtn = [self switchSelectedBtn:sender selectedBtn:_formatBtn];
}

- (IBAction)channelsBtnAction:(UIButton *)sender {
    _sampleSBtn = [self switchSelectedBtn:sender selectedBtn:_sampleSBtn];
}

- (IBAction)viewTapAction:(id)sender {
    self.view.hidden = YES;
}

- (UIButton *)switchSelectedBtn:(UIButton *)sender selectedBtn:(UIButton *)selected {
    if (sender.isSelected) {
        return sender;
    }
    selected.selected = NO;
    selected.backgroundColor = [UIColor whiteColor];
    selected.borderWidth = 1;
    selected.borderColor = [UIColor lightGrayColor];
    sender.backgroundColor = [UIColor colorWithRed:39 / 255.0 green:205 / 255.0 blue:175 / 255.0 alpha:1];
    sender.selected = YES;
    sender.borderWidth = 0;
    sender.borderColor = [UIColor clearColor];
    return sender;
}

@end
