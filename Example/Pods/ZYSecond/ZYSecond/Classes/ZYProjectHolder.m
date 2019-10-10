//
//  ZYProjectHolder.m
//  JKLHelper
//
//  Created by 刘梓逸 on 2018/1/30.
//  Copyright © 2018年 刘梓逸. All rights reserved.
//

#import "ZYProjectHolder.h"

@implementation ZYProjectHolder
+(instancetype)sharedInstance{
    
    static ZYProjectHolder *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance =  [[ZYProjectHolder alloc] init];
        instance.mainPage = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        instance.homePage = [UIStoryboard storyboardWithName:@"HomePage" bundle:[NSBundle mainBundle]];
        instance.categoryPage = [UIStoryboard storyboardWithName:@"CategoryPage" bundle:[NSBundle mainBundle]];
        instance.thirdPage = [UIStoryboard storyboardWithName:@"ThirdPage" bundle:[NSBundle mainBundle]];
        instance.minePage = [UIStoryboard storyboardWithName:@"MinePage" bundle:[NSBundle mainBundle]];
    });
    return instance;
}

@end
