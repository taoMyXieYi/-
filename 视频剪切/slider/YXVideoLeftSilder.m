//
//  YXVideoLeftSilder.m
//  视频剪切
//
//  Created by wangtao on 2018/7/26.
//  Copyright © 2018年 wangtao. All rights reserved.
//

#import "YXVideoLeftSilder.h"
#import "YXUIAssistDefine.h"

@implementation YXVideoLeftSilder

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _lineView = [[YXSliderView alloc] initWithFrame:CGRectMake(0, 0, 8, self.bounds.size.height)];
    _lineView.backgroundColor = UICOLOR_HEX(0xffc10b);
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 0, self.bounds.size.height - 14)];
    _maskView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    [self addSubview:_maskView];
    [self addSubview:_lineView];
}

@end
