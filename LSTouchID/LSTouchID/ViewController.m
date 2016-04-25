//
//  ViewController.m
//  LSTouchID
//
//  Created by liushuai on 16/4/21.
//  Copyright © 2016年 liushuai1992@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "LSTouchID.h"

@interface ViewController () <LSTouchIDAuthDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //实例化LSTouchID并请求指纹验证
    [[LSTouchID shareTouchID] authWithRequestReason:@"验证指纹"];
    //设置委托对象
    [LSTouchID shareTouchID].delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LSTouchIDAuthDelegate methods
- (void)TouchIDPassed {
    NSLog(@"TouchID验证通过");
}

- (void)TouchIDNotFound {
    NSLog(@"设备不支持TouchID,应跳转至密码验证页面");
}

- (void)TouchIDAuthFailed {
    NSLog(@"连续三次指纹识别错误回调此方法");
}

- (void)TouchIDUserCancel {
    NSLog(@"用户取消验证");
}

- (void)TouchIDUserFallback {
    NSLog(@"点击了输入密码按钮");
}


@end
