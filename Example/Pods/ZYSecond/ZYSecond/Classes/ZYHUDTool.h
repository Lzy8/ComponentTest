//
//  ZYHUDTool.h
//  BMJingKeLong
//
//  Created by LiuZiyi on 2017/3/23.
//  Copyright © 2017年 蓝色互动. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JGProgressHUD;

@interface ZYHUDTool : NSObject
+(void)showMessage:(NSString *)text;
+(void)showSuccess:(NSString *)text;
+(void)showError:(NSString *)text;
//+(void)showMessage:(NSString *)text postion:(JGProgressHUDPosition)position;
+(void)showMessageOnBottom:(NSString *)text;
+(JGProgressHUD *)showLoading:(NSString *)loadingText;
+(JGProgressHUD *)showDone:(NSString *)doneText HUD:(JGProgressHUD *)HUD;
@end
