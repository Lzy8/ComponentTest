//
//  ZYProjectTool.m
//  JKLHelper
//
//  Created by 刘梓逸 on 2017/12/6.
//  Copyright © 2017年 刘梓逸. All rights reserved.
//

#import "ZYProjectTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
@implementation ZYProjectTool
#pragma mark - MD5加密
+ (NSString *)md5ByString:(NSString *)string
{
    const char *cStr = [string UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    // 先转MD5，再转大写
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
+ (NSString *)getUUIDString{
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv;
}

+ (NSString *)getNewSth{
    return @"`";
}
+ (NSString *)getNewSthT{
    return @"1";
}
+ (NSString *)getNewSthTo{
    return @"1212";
}
@end
