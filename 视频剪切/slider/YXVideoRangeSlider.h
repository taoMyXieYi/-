//
//  YXVideoRangeSlider.h
//  视频剪切
//
//  Created by wangtao on 2018/7/26.
//  Copyright © 2018年 wangtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class YXVideoRangeSlider;

@protocol YXVideoRangeSliderDelegate <NSObject>

@optional

- (void)videoRange:(YXVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;

- (void)videoRange:(YXVideoRangeSlider *)videoRange didGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;

- (void)videoRange:(YXVideoRangeSlider *)videoRange didGestureStateEndedStartTime:(CMTime)startTime endTime:(CMTime)endTime;

- (void)videoRange:(YXVideoRangeSlider *)videoRange didSliderToPositionImage:(UIImage *)image;

@end

@interface YXVideoRangeSlider : UIView

@property (nonatomic) CGFloat leftPosition;
@property (nonatomic) CGFloat rightPosition;

@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, weak) id <YXVideoRangeSliderDelegate> delegate;

- (void)rangeSliderCutVideoComplete:(void(^)(NSURL *outputURL,NSError *error))compeletHander;

@end
