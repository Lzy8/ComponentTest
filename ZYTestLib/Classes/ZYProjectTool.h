//
//  ZYProjectTool.h
//  JKLHelper
//
//  Created by 刘梓逸 on 2017/12/6.
//  Copyright © 2017年 刘梓逸. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYProjectTool : NSObject
#pragma mark - MD5加密
/**
 *  MD5加密
 *
 *  @param string 要加密的字段
 *
 *  @return MD5加密后的新字段
 */
+ (NSString *)md5ByString:(NSString *)string;
+ (NSString *)getUUIDString;

+ (NSString *)getNewSth;
@end
