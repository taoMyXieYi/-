//
//  YXVideoEditTool.h
//  视频剪切
//
//  Created by wangtao on 2018/7/25.
//  Copyright © 2018年 wangtao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^FirstVideoImageCompeletBlock)(UIImage *image);


@interface YXVideoEditTool : NSObject

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic) Float64 durationSeconds;

- (instancetype)initWithVideoURL:(NSURL *)videoURL;

- (UIImage *)videoImageAtSliderTime:(NSInteger)sliderTime;

- (void)cutFirstVideoImageCompeletBlock:(FirstVideoImageCompeletBlock)firstVideoImageCompeletBlock;

- (void)getMovieFrameCompletionHandler:(void(^)(UIImage* videoImage,NSError * error))completionHandler;

- (void)cutVideoWithAsset:(AVAsset*)asset captureVideoWithRange:(CMTimeRange)videoRange completionHandler:(void(^)(NSURL* outputUrl,NSError * error))completionHandler;

@end
