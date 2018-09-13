//
//  ViewController.m
//  视频剪切
//
//  Created by wangtao on 2018/7/25.
//  Copyright © 2018年 wangtao. All rights reserved.
//

#import "ViewController.h"
#import "YXVideoEditViewController.h"


@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tapButton.backgroundColor = [UIColor redColor];
    tapButton.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:tapButton];
    [tapButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapAction {
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"cutVideo" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:pathString];
    YXVideoEditViewController *VC = [[YXVideoEditViewController alloc] init];
    VC.videoURL = url;
    [self presentViewController:VC animated:YES completion:nil];
}


@end
