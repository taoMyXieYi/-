//
//  YXVideoEditTool.m
//  视频剪切
//
//  Created by wangtao on 2018/7/25.
//  Copyright © 2018年 wangtao. All rights reserved.
//

#import "YXVideoEditTool.h"

@interface YXVideoEditTool ()
@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;
@property (nonatomic, strong) NSURL *videoUrl;

@end

@implementation YXVideoEditTool

- (instancetype)initWithVideoURL:(NSURL *)videoURL
{
    self = [super init];
    if (self) {
        _videoUrl = videoURL;
        _imagesArray = [NSMutableArray array];
    }
    return self;
}

- (void)cutFirstVideoImageCompeletBlock:(FirstVideoImageCompeletBlock)firstVideoImageCompeletBlock {
    AVAsset *myAsset = [[AVURLAsset alloc] initWithURL:_videoUrl options:nil];
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
    //防止时间出现偏差
    self.imageGenerator.appliesPreferredTrackTransform = YES;
    self.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    self.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    _durationSeconds = CMTimeGetSeconds([myAsset duration]);
    //得到第一张图，用于展示识别图
    NSError *error;
    CMTime actualTime;
    CGImageRef halfWayImage = [self.imageGenerator copyCGImageAtTime:kCMTimeZero actualTime:&actualTime error:&error];
    if (halfWayImage != NULL) {
        UIImage *firstImage;
        if ([self isRetina]){
            firstImage = [[UIImage alloc] initWithCGImage:halfWayImage scale:2.0 orientation:UIImageOrientationUp];
        } else {
            firstImage = [[UIImage alloc] initWithCGImage:halfWayImage];
        }
        if (firstVideoImageCompeletBlock) {
            firstVideoImageCompeletBlock(firstImage);
        }
        CGImageRelease(halfWayImage);
    }
}

- (void)cutVideoWithAsset:(AVAsset*)asset captureVideoWithRange:(CMTimeRange)videoRange completionHandler:(void(^)(NSURL* outputUrl,NSError * error))completionHandler {
    AVAssetExportSession *exportSession;
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    if ([presets containsObject:AVAssetExportPreset640x480]) {
        exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPreset640x480];
    } else {
        exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    }
    exportSession.timeRange = videoRange;
    NSString *copyPath = [self createOutputFileUrl];
    exportSession.outputURL = [NSURL fileURLWithPath:copyPath];
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputFileType = AVFileTypeMPEG4;
    __block BOOL copyOK = NO;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        switch (exportSession.status) {
            case AVAssetExportSessionStatusUnknown:
                break;
            case AVAssetExportSessionStatusWaiting:
                break;
            case AVAssetExportSessionStatusExporting:
                break;
            case AVAssetExportSessionStatusCompleted:
                copyOK = YES;
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                break;
            case AVAssetExportSessionStatusCancelled:
                break;
            default:
                break;
        }
        
        if (copyOK) {
            completionHandler([NSURL fileURLWithPath:copyPath],nil);
        } else {
            completionHandler(nil,exportSession.error);
        }
    }];
}

- (NSString*)createOutputFileUrl{
    double timeInterval = [NSDate timeIntervalSinceReferenceDate];
    NSString *typeStrWithFileName = [NSString stringWithFormat:@"%.0f.mp4",timeInterval];
    NSString *tmpPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingString:@"/videos"];
    NSString * outputUrl = [tmpPath stringByAppendingPathComponent:typeStrWithFileName];
    if (![[NSFileManager defaultManager]fileExistsAtPath:tmpPath]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return outputUrl;
}

- (void)getMovieFrameCompletionHandler:(void(^)(UIImage* videoImage,NSError * error))completionHandler {
    NSMutableArray *times = [NSMutableArray array];
    CMTime timeFrame;
    for (int i = 1; i <= _durationSeconds; i++) {
        timeFrame = CMTimeMake(i*60, 60); //第i帧  帧率
        NSValue *timeValue = [NSValue valueWithCMTime:timeFrame];
        [times addObject:timeValue];
    }
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times
                                              completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime,
                                                                  AVAssetImageGeneratorResult result, NSError *error) {
                                                  
                                                  if (result == AVAssetImageGeneratorSucceeded) {
                                                      
                                                      
                                                      UIImage *videoImage;
                                                      if ([self isRetina]){
                                                          videoImage = [[UIImage alloc] initWithCGImage:image scale:2.0 orientation:UIImageOrientationUp];
                                                      } else {
                                                          videoImage = [[UIImage alloc] initWithCGImage:image];
                                                      }
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          completionHandler(videoImage,nil);
                                                      });
                                                  }
                                                  if (result == AVAssetImageGeneratorFailed) {
                                                      NSLog(@"Failed with error: %@", [error localizedDescription]);
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          completionHandler(nil,error);
                                                      });
                                                  }
                                                  if (result == AVAssetImageGeneratorCancelled) {
                                                      NSLog(@"Canceled");
                                                  }
                                              }];
}

- (UIImage *)videoImageAtSliderTime:(NSInteger)sliderTime {
    NSError *error;
    CMTime actualTime;
    CMTime time = CMTimeMakeWithSeconds(sliderTime, 60);
    CGImageRef imageRef = [self.imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
        return nil;
    } else {
        UIImage *videoImage;
        if ([self isRetina]){
            videoImage = [[UIImage alloc] initWithCGImage:imageRef scale:2.0 orientation:UIImageOrientationUp];
        } else {
            videoImage = [[UIImage alloc] initWithCGImage:imageRef];
        }
        CGImageRelease(imageRef);
        return videoImage;
    }
}

- (BOOL)isRetina{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&([UIScreen mainScreen].scale == 2.0));
}

@end
