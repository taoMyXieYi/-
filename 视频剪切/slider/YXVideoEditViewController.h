//
//  YXVideoEditViewController.h
//  YXARThemeCreation
//
//  Created by wangtao on 2018/7/27.
//  Copyright © 2018年 YX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXVideoEditViewController;

@protocol YXVideoEditViewControllerDelegate <NSObject>

- (void)videoEditViewControllerDidCutVideo:(NSURL *)videoURL previewPicture:(UIImage *)picture;

@end

@interface YXVideoEditViewController : UIViewController

@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, weak) id<YXVideoEditViewControllerDelegate> delegate;

@end
