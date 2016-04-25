//
//  LSTouchID.h
//  LSTouchID
//
//  Created by liushuai on 16/4/21.
//  Copyright © 2016年 liushuai1992@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

@protocol LSTouchIDAuthDelegate <NSObject>

/**
 *  硬件支持TouchID，但未通过验证，error.code包含了错误信息。
 *  错误代码及描述:
 kLAErrorAuthenticationFailed   -1  连续三次指纹识别错误
 kLAErrorUserCancel             -2  点击了取消按钮
 kLAErrorUserFallback           -3  点输入密码按钮
 kLAErrorSystemCancel           -4  系统终止了验证，比如按下电源键
 kLAErrorPasscodeNotSet         -5  用户没有在设备Settings中设定密码
 kLAErrorTouchIDNotAvailable    -6  设备不支持Touch ID
 kLAErrorTouchIDNotEnrolled     -7  设备没有进行Touch ID 指纹注册
 kLAErrorTouchIDLockout         -8  Touch ID功能被锁定，下一次需要输入系统密码
 kLAErrorAppCancel              -9  验证被应用取消
 kLAErrorInvalidContext         -10 无效上下文
 
 */

@required
/** 硬件不支持TouchID时回调此方法，应在此方法中为用户提供其他鉴权方式，比如密码。*/
- (void)TouchIDNotFound;

/** 通过了TouchID鉴权时回调此方法。*/
- (void)TouchIDPassed;

/** 连续三次指纹识别错误回调此方法。 */ 
- (void)TouchIDAuthFailed;

/** 点击了取消按钮回调此方法。*/
- (void)TouchIDUserCancel;

/** 点击了输入密码按钮 */
- (void)TouchIDUserFallback;

@optional
/** 系统终止了验证，比如按下电源键 */
- (void)TouchIDSystemCancel;

/** 用户没有在设备Settings中设定密码 */
- (void)TouchIDPasscodeNotSet;

/** 设备没有进行Touch ID 指纹注册 */
- (void)TouchIDNotEnrolled;

/** Touch ID功能被锁定，下一次需要输入系统密码 */
- (void)TouchIDLockout;

/** 验证被应用取消 */
- (void)TouchIDAppCancel;

/** 无效上下文 */
- (void)TouchIDInvalidContext;

/** 返回错误码，用户可以根据错误码自行处理 */
- (void)TouchIDFailed:(NSError *)error;

@end


@interface LSTouchID : NSObject

@property (nonatomic, weak) id<LSTouchIDAuthDelegate> delegate;

+ (instancetype)shareTouchID;
- (void)authWithRequestReason:(NSString *)reasonStr;


@end
