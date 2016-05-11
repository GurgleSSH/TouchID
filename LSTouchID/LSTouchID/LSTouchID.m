//
//  LSTouchID.m
//  LSTouchID
//
//  Created by liushuai on 16/4/21.
//  Copyright © 2016年 liushuai1992@gmail.com. All rights reserved.
//

#import "LSTouchID.h"


#define DELEGATE_RESPONDS(method) if (self.delegate && [self.delegate respondsToSelector:@selector(method)]) {[self.delegate method];}

@implementation LSTouchID

+ (instancetype)sharedTouchID {
    static LSTouchID *touchID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        touchID = [[LSTouchID alloc] init];
    });
    return touchID;
}

- (void)authWithRequestReason:(NSString *)reasonStr {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSError *error = nil;
        LAContext *authenticationContext = [[LAContext alloc] init];
        //是否支持生物识别
        if ([authenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            //支持生物识别
            [authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reasonStr reply:^(BOOL success, NSError * _Nullable error) {
                
                //生物识别成功
                if (success) {
                    DELEGATE_RESPONDS(TouchIDPassed)
                } else {
                    //生物识别失败
                    if (self.delegate && [self.delegate respondsToSelector:@selector(TouchIDFailed:)]) {
                        [self.delegate TouchIDFailed:error];
                    }
                    switch (error.code) {
                            //-1  连续三次指纹识别错误
                        case kLAErrorAuthenticationFailed: {DELEGATE_RESPONDS(TouchIDAuthFailed) break;}
                            //-2  点击了取消按钮
                        case kLAErrorUserCancel: {DELEGATE_RESPONDS(TouchIDUserCancel) break;}
                            //-3  点输入密码按钮
                        case kLAErrorUserFallback: {DELEGATE_RESPONDS(TouchIDUserFallback) break;}
                            //-4  系统终止了验证，比如按下电源键
                        case kLAErrorSystemCancel: {DELEGATE_RESPONDS(TouchIDSystemCancel) break;}
                            //-5  用户没有在设备Settings中设定密码
                        case kLAErrorPasscodeNotSet: {DELEGATE_RESPONDS(TouchIDPasscodeNotSet) break;}
                            //-7  设备没有进行Touch ID 指纹注册
                        case kLAErrorTouchIDNotEnrolled: {DELEGATE_RESPONDS(TouchIDNotEnrolled) break;}
                            //-8  Touch ID功能被锁定，下一次需要输入系统密码
                        case kLAErrorTouchIDLockout: {DELEGATE_RESPONDS(TouchIDLockout) break;}
                            //-9  验证被应用取消
                        case kLAErrorAppCancel: {DELEGATE_RESPONDS(TouchIDAppCancel) break;}
                            //-10 无效上下文
                        case kLAErrorInvalidContext: {DELEGATE_RESPONDS(TouchIDInvalidContext) break;}
                        default:{break;}
                    }
                }
            }];
        } else {
            //不支持生物识别
            if (self.delegate && [self.delegate respondsToSelector:@selector(TouchIDNotFound)]) {
                [self.delegate TouchIDNotFound];
            }
        }
    });
}

@end
