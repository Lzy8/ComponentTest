//
//  ZYHUDTool.m
//  BMJingKeLong
//
//  Created by LiuZiyi on 2017/3/23.
//  Copyright © 2017年 蓝色互动. All rights reserved.
//

#import "ZYHUDTool.h"
#import "JGProgressHUD.h"
@implementation ZYHUDTool

+(JGProgressHUD *)showLoading:(NSString *)loadingText{

    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleExtraLight];
    HUD.interactionType = JGProgressHUDInteractionTypeBlockTouchesOnHUDView;
    HUD.textLabel.text = loadingText;
    HUD.textLabel.font = [UIFont systemFontOfSize:12.f];
    HUD.square = YES;
    [HUD showInView:[UIApplication sharedApplication].keyWindow];
    return HUD;
}

+(JGProgressHUD *)showDone:(NSString *)doneText HUD:(JGProgressHUD *)HUD{

    HUD.interactionType = JGProgressHUDInteractionTypeBlockTouchesOnHUDView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HUD.indicatorView = [JGProgressHUDSuccessIndicatorView new];
        HUD.textLabel.text = doneText;
        
        [HUD dismissAfterDelay:1];
    });
    
    return HUD;
}

+(void)showText:(NSString *)text InView:(UIView *)inView isSuccess:(BOOL)isSuccess isTextOnly:(BOOL)textOnly isSquare:(BOOL)isSquare postion:(JGProgressHUDPosition)position{

    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleExtraLight];
    HUD.interactionType = JGProgressHUDInteractionTypeBlockTouchesOnHUDView;
    HUD.textLabel.text = text;
    HUD.indicatorView = textOnly ? nil : (isSuccess ? [[JGProgressHUDSuccessIndicatorView alloc] init] : [[JGProgressHUDErrorIndicatorView alloc] init]);
    HUD.textLabel.font = [UIFont systemFontOfSize:13.f];
    HUD.square = isSquare;
    HUD.position = position;
    [HUD showInView:inView];
    
    [HUD dismissAfterDelay:1.5];
}

+(void)showMessageOnBottom:(NSString *)text{

     [ZYHUDTool showText:text InView:[UIApplication sharedApplication].keyWindow isSuccess:NO isTextOnly:YES isSquare:NO postion:JGProgressHUDPositionBottomCenter];
}

+(void)showMessage:(NSString *)text{
    [ZYHUDTool showMessage:text postion:JGProgressHUDPositionCenter];
}
+(void)showMessage:(NSString *)text postion:(JGProgressHUDPosition)position{
    [ZYHUDTool showText:text InView:[UIApplication sharedApplication].keyWindow isSuccess:NO isTextOnly:YES isSquare:NO postion:position];
}

+(void)showSuccess:(NSString *)text{

    [ZYHUDTool showText:text InView:[UIApplication sharedApplication].keyWindow isSuccess:YES isTextOnly:NO isSquare:YES postion:JGProgressHUDPositionCenter];
}
+(void)showError:(NSString *)text{
    
    [ZYHUDTool showText:text InView:[UIApplication sharedApplication].keyWindow isSuccess:NO isTextOnly:NO isSquare:NO postion:JGProgressHUDPositionCenter];
}

@end









