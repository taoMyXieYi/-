//
//  YXVideoEditViewController.m
//  YXARThemeCreation
//
//  Created by wangtao on 2018/7/27.
//  Copyright © 2018年 YX. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "YXVideoEditViewController.h"
#import "YXVideoRangeSlider.h"
#import "YXUIAssistDefine.h"

@interface YXVideoEditViewController () <YXVideoRangeSliderDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (nonatomic, strong) YXVideoRangeSlider *rangeSlider;

//@property (nonatomic, strong) AWEasyVideoPlayer *videoPlayer;

@property (nonatomic, assign) CMTime selectStartTime;

@end

@implementation YXVideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectStartTime = kCMTimeZero;
    
    _rangeSlider = [[YXVideoRangeSlider alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 75 - 15, SCREEN_WIDTH, 75)];
    _rangeSlider.delegate = self;
    _rangeSlider.videoURL = self.videoURL;
    [self.view addSubview:_rangeSlider];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
//    [self.view addSubview:self.videoPlayer];
//    [self.videoPlayer play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.videoPlayer pause];
    });
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveAction:(UIButton *)sender {
    sender.enabled = NO;
//    [self.videoPlayer pause];
    [self.rangeSlider rangeSliderCutVideoComplete:^(NSURL *outputURL, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.enabled = YES;
            if (!error) {
                if ([self.delegate respondsToSelector:@selector(videoEditViewControllerDidCutVideo:previewPicture:)]) {
                    [self.delegate videoEditViewControllerDidCutVideo:outputURL previewPicture:self.bgImageView.image];
                }
                [self.navigationController popViewControllerAnimated:NO];
            } else {
//                MBProgressHUD *hud = [MBProgressHUD sr_showMessage:error.domain];
//                [hud hideAnimated:YES afterDelay:3.0];
            }
        });
    }];
}

#pragma mark - YXVideoRangeSliderDelegate

- (void)videoRange:(YXVideoRangeSlider *)videoRange didSliderToPositionImage:(UIImage *)image { 
    self.bgImageView.image = image;
}

- (void)videoRange:(YXVideoRangeSlider *)videoRange didGestureStateEndedStartTime:(CMTime)startTime endTime:(CMTime)endTime {
    _selectStartTime = startTime;
    
//    self.bgImageView.hidden = YES;
//    [self.view addSubview:self.videoPlayer];
//    [self.videoPlayer.player seekToTime:startTime];
//    [self.videoPlayer.player.currentItem setForwardPlaybackEndTime:endTime];
//    [self.videoPlayer pause];
}

#pragma mark - AWEasyVideoPlayerDelegate

//- (void)easyVideoPlayer:(AWEasyVideoPlayer *)videoPlayer didChangeState:(AWEasyVideoPlayerState)state {
//    if (state == AWEasyVideoPlayerStateEnd) {
//        [self.videoPlayer.player seekToTime:self.seletStartTime];
//        [self.videoPlayer pause];
//    }
//}

#pragma mark - Getters
//
//- (AWEasyVideoPlayer *)videoPlayer {
//    if (!_videoPlayer) {
//        _videoPlayer = [[AWEasyVideoPlayer alloc] init];
//        _videoPlayer.frame = self.bgImageView.frame;
//        _videoPlayer.videoURL = self.videoURL;
//        _videoPlayer.delegate = self;
//    }
//    return _videoPlayer;
//}

@end
