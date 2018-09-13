//
//  YXSliderView.h
//  YXARThemeCreation
//
//  Created by wangtao on 2018/8/31.
//  Copyright © 2018年 YX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXSliderView : UIView

/**
 增加左边的相应区域
 */
@property (nonatomic,assign)NSInteger lefEdgeInset;
/**
 增加右边的相应区域
 */
@property (nonatomic,assign)NSInteger rightEdgeInset;
/**
 增加上边的相应区域
 */
@property (nonatomic,assign)NSInteger topEdgeInset;
/**
 增加下边的相应区域
 */
@property (nonatomic,assign)NSInteger bottomEdgeInset;

@end
