//
//  YXSliderView.m
//  YXARThemeCreation
//
//  Created by wangtao on 2018/8/31.
//  Copyright © 2018年 YX. All rights reserved.
//

#import "YXSliderView.h"

@implementation YXSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lefEdgeInset = 60;
        self.rightEdgeInset = 60;
        self.topEdgeInset = 0;
        self.bottomEdgeInset = 0;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    CGRect rect = CGRectMake(self.bounds.origin.x - self.lefEdgeInset, self.bounds.origin.y - self.topEdgeInset, CGRectGetWidth(self.bounds) + self.lefEdgeInset + self.rightEdgeInset, CGRectGetHeight(self.bounds) + self.bottomEdgeInset + self.topEdgeInset);
    if (CGRectContainsPoint(rect, point)) {
        return YES;
    }
    return NO;
}

@end
