//
//  ViewController.m
//  touch
//
//  Created by 姜宁桃 on 2017/2/14.
//  Copyright © 2017年 姜宁桃. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTouch];
}

- (void)configTouch{
    // 判断用户手机系统是否是 iOS 8.0以上版本
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        return;
    }
    
    // 实例化本地身份验证上下文
    LAContext * context = [[LAContext alloc] init];
    
    // 判断是否支持指纹识别
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        return;
    }
    
    // 设置 输入密码 按钮的标题
    context.localizedFallbackTitle = @"按钮标题";
    
    // 设置 取消密码 按钮的标题
//    context.localizedCancelTitle = @"取消按钮标题";
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {
        
        // 输入指纹开始验证，异步执行
        if (success) {
            [self refreshUI:[NSString stringWithFormat:@"验证指纹成功"] message:nil];
        }else
        {
            [self refreshUI:[NSString stringWithFormat:@"指纹验证失败"] message:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

// 主线程刷新 UI
- (void)refreshUI:(NSString *)str message:(NSString *)msg {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:str
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    });
}

- (IBAction)buttonClickEvent:(id)sender {
    [self configTouch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
