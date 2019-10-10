//
//  ZYProjectHolder.h
//  JKLHelper
//
//  Created by 刘梓逸 on 2018/1/30.
//  Copyright © 2018年 刘梓逸. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYProjectHolder : NSObject
@property(nonatomic, strong) UIStoryboard *mainPage;
@property(nonatomic, strong) UIStoryboard *homePage;
@property(nonatomic, strong) UIStoryboard *categoryPage;
@property(nonatomic, strong) UIStoryboard *thirdPage;
@property(nonatomic, strong) UIStoryboard *minePage;
+(instancetype)sharedInstance;
@end
