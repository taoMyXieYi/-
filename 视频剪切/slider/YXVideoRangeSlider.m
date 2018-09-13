//
//  YXVideoRangeSlider.m
//  视频剪切
//
//  Created by wangtao on 2018/7/26.
//  Copyright © 2018年 wangtao. All rights reserved.
//

#import "YXVideoRangeSlider.h"
#import "YXVideoLeftSilder.h"
#import "YXVideoRightSlider.h"
#import "YXImageCollectionViewCell.h"
#import "YXVideoEditTool.h"

static NSInteger sliderW = 8;

static NSInteger margin = 14;

@interface YXVideoRangeSlider ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) YXVideoLeftSilder *leftSlider;

@property (nonatomic, strong) YXVideoRightSlider *rightSlider;

@property (nonatomic, strong) YXVideoEditTool *videoTool;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) CGFloat videoPosition;

@property (nonatomic, assign) CGFloat imageWidth;

@end

@implementation YXVideoRangeSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataSource = [NSMutableArray array];
        _leftPosition = margin;
        _imageWidth = 50;
        _rightPosition = self.bounds.size.width - margin;
        [self setupUI];
    }
    return self;
}

- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    _videoTool = [[YXVideoEditTool alloc] initWithVideoURL:_videoURL];
    [_videoTool cutFirstVideoImageCompeletBlock:^(UIImage *image) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoRange:didSliderToPositionImage:)]) {
            [self.delegate videoRange:self didSliderToPositionImage:image];
        }
    }];
    if (_videoTool.durationSeconds >= 15) {
        _imageWidth = (self.bounds.size.width - margin * 2)/15.0;
    } else {
        _imageWidth = (self.bounds.size.width - margin * 2)/floor(_videoTool.durationSeconds);
    }
    [_videoTool getMovieFrameCompletionHandler:^(UIImage *videoImage, NSError *error) {
        if (!error) {
            NSLog(@"images%@",videoImage);
            [self.dataSource addObject:videoImage];
            [self.collectionView reloadData];
        }
    }];
}

- (void)setupUI {
    [self addSubview:self.collectionView];
    _leftSlider = [[YXVideoLeftSilder alloc] initWithFrame:CGRectMake(margin, 0, sliderW, self.bounds.size.height)];
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPan:)];
    [_leftSlider.lineView addGestureRecognizer:leftPan];
    
    _rightSlider = [[YXVideoRightSlider alloc] initWithFrame:CGRectMake(self.bounds.size.width - margin - sliderW, 0, sliderW, self.bounds.size.height)];
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPan:)];
    [_rightSlider.lineView addGestureRecognizer:rightPan];
    [self addSubview:_leftSlider];
    [self addSubview:_rightSlider];
}

- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        _leftPosition += translation.x;
        if (_leftPosition < margin) {
            _leftPosition = margin;
        }
        if (_leftPosition >= _rightPosition - sliderW *2) {
            _leftPosition = _rightPosition - sliderW * 2;
        }
        [gesture setTranslation:CGPointZero inView:self];
        
        NSLog(@"%f",_leftPosition);
        _leftSlider.frame = CGRectMake(margin, 0, _leftPosition - margin + sliderW, self.bounds.size.height);
        _leftSlider.maskView.frame = CGRectMake(0, 7, (_leftSlider.bounds.size.width - sliderW)<=0?0:(_leftSlider.bounds.size.width - sliderW), self.bounds.size.height - margin);
        _leftSlider.lineView.frame = CGRectMake(_leftSlider.maskView.bounds.size.width, 0, sliderW, self.bounds.size.height);
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSInteger index = ceil((self.collectionView.contentOffset.x + _leftPosition - margin)/_imageWidth);
        UIImage *image = [_videoTool videoImageAtSliderTime:index];
        if (self.delegate && [self.delegate respondsToSelector:@selector(videoRange:didSliderToPositionImage:)]) {
            [self.delegate videoRange:self didSliderToPositionImage:image];
        }
        [self endChangeDelegate];
    }
}

- (void)handleRightPan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        _rightPosition += translation.x;
        if (_rightPosition <= _leftPosition + sliderW) {
            _rightPosition = _leftPosition + sliderW * 2;
        }
        if (_rightPosition >= self.bounds.size.width - margin) {
            _rightPosition = self.bounds.size.width - margin;
        }
        [gesture setTranslation:CGPointZero inView:self];
        NSLog(@"_rightPosition---%f",_rightPosition);
        
        _rightSlider.frame = CGRectMake(_rightPosition - sliderW, 0, (self.bounds.size.width - _rightPosition - margin/2+1)<=0?sliderW:(self.bounds.size.width - _rightPosition - margin/2+1), self.bounds.size.height);
        _rightSlider.lineView.frame = CGRectMake(0, 0, sliderW, self.bounds.size.height);
        
        _rightSlider.maskView.frame = CGRectMake(sliderW , 7, (_rightSlider.bounds.size.width - sliderW) <= 0 ? 0 : (_rightSlider.bounds.size.width - sliderW), self.bounds.size.height - margin);
        
        [self endChangeDelegate];
    }
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YXImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YXImageCollectionViewCellID forIndexPath:indexPath];
    cell.imageView.image = _dataSource[indexPath.row];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [self scrollViewDidEndScroll:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        // 停止类型3
        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (dragToDragStop) {
            [self scrollViewDidEndScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndScroll:(UIScrollView *)scrollView {
    _videoPosition = scrollView.contentOffset.x + _leftPosition - margin;
    NSInteger index = ceil(_videoPosition/_imageWidth);
    UIImage *image = [_videoTool videoImageAtSliderTime:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoRange:didSliderToPositionImage:)]) {
        [self.delegate videoRange:self didSliderToPositionImage:image];
    }
    [self endChangeDelegate];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_imageWidth, 72);
}

- (void)endChangeDelegate {
    CGFloat startTime = (_collectionView.contentOffset.x + _leftPosition)/_imageWidth;
    CGFloat du = (_collectionView.contentOffset.x + _rightPosition)/_imageWidth;
    AVAsset *asset = [AVAsset assetWithURL:_videoURL];
    CMTime start = CMTimeMakeWithSeconds(startTime , asset.duration.timescale);
    CMTime end = CMTimeMakeWithSeconds(du , asset.duration.timescale);
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoRange:didGestureStateEndedStartTime:endTime:)]) {
        [self.delegate videoRange:self didGestureStateEndedStartTime:start endTime:end];
    }
}

#pragma mark - setter && getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(_imageWidth, 72);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(margin, 7, self.bounds.size.width - margin*2, self.bounds.size.height - margin) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[YXImageCollectionViewCell class] forCellWithReuseIdentifier:YXImageCollectionViewCellID];
    }
    return _collectionView;
}

- (void)rangeSliderCutVideoComplete:(void(^)(NSURL *outputURL,NSError *error))compeletHander {
    if ((_rightPosition - _leftPosition)/_imageWidth < 3) {
        if (compeletHander) {
            compeletHander(nil,[NSError errorWithDomain:@"视频没有3s" code:10021 userInfo:nil]);
        }
        return;
    }
    CGFloat startTime = (_collectionView.contentOffset.x + _leftPosition)/_imageWidth;
    CGFloat du = (_rightPosition - _leftPosition)/_imageWidth;
    AVAsset *asset = [AVAsset assetWithURL:_videoURL];
    CMTime start = CMTimeMakeWithSeconds(startTime , asset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(du , asset.duration.timescale);
    CMTimeRange range = CMTimeRangeMake(start, duration);
    [_videoTool cutVideoWithAsset:asset captureVideoWithRange:range completionHandler:^(NSURL *outputUrl, NSError *error) {
        if (!error) {
            NSLog(@"outPut --%@",outputUrl);
            if (compeletHander) {
                compeletHander(outputUrl,nil);
            }
        } else {
            NSLog(@"error --%@",error);
            if (compeletHander) {
                compeletHander(nil,error);
            }
        }
    }];
}

@end
