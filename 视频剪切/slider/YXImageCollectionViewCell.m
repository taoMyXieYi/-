//
//  YXImageCollectionViewCell.m
//  视频剪切
//
//  Created by wangtao on 2018/7/26.
//  Copyright © 2018年 wangtao. All rights reserved.
//

#import "YXImageCollectionViewCell.h"

@implementation YXImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_imageView];
}

@end
