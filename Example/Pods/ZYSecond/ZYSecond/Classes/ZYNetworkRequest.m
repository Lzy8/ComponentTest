//
//  ZYNetworkRequest.m
//  BMJingKeLong
//
//  Created by LiuZiyi on 2016/12/13.
//  Copyright © 2016年 蓝色互动. All rights reserved.
//

#import "ZYNetworkRequest.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFNetworking.h"
//#import "ZYProjectTool.h"

@interface ZYNetworkRequest ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation ZYNetworkRequest

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

+(NSString *)jsonStr:(NSDictionary *)param{
    NSError *error;
    NSString *jsonStr;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
    if (error) {
    }else{
    
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    }
    return jsonStr ? : @"";
}

-(instancetype)init{

    if (self = [super init]) {
        
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
//        responseSerializer.removesKeysWithNullValues = YES;
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/html",@" text/html",@" text/html;", @"text/javascript", @"text/json", nil];
        self.manager.responseSerializer = responseSerializer;
        self.manager.requestSerializer.timeoutInterval = 20;
        self.baseURL = @"http://mtest2.jkl.com.cn";
        self.path = @"api";
    }
    return self;
}

-(NSDictionary *)signParams:(NSDictionary *)params{

    NSArray *keys = params.allKeys;
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *resultArray = [keys sortedArrayUsingComparator:sort];
    
    NSString *strBeforeSign = @"";
    
    for (int i = 0; i < resultArray.count; i++) {
        
        if (i) {// i >=1
            strBeforeSign = [strBeforeSign stringByAppendingFormat:@"&%@=%@",resultArray[i],params[resultArray[i]]];
        }else{// i == 0
            strBeforeSign = [strBeforeSign stringByAppendingFormat:@"%@=%@",resultArray[i],params[resultArray[i]]];
        }
    }
    
    NSString *strBeforeSignAddKey = [strBeforeSign stringByAppendingString:@"signKeySalt"];
    
    NSString *md5Sign = [ZYNetworkRequest md5ByString:strBeforeSignAddKey].lowercaseString;
    
    
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:params];
    allParams[@"sign"] = md5Sign;
    
    return allParams;

}

-(void)loadDataWithParams:(NSDictionary *)param requestIdentifier:(NSString *)identifier hud:(BOOL)isHud baseURL:(NSString *)baseURL path:(NSString *)path{

    @try {
        
        __weak typeof(self) weakSelf = self;
        
        BOOL isSign = ![baseURL isEqualToString:self.baseURL];
        NSDictionary *params = isSign ? [self signParams:param] : param;
       
        [self.manager POST:[NSString stringWithFormat:@"%@/%@",baseURL,path] parameters:params progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
          
            weakSelf.rawData = responseObject;
            if (![responseObject[@"status"] integerValue]) {
                
                if ([weakSelf.delegate respondsToSelector:@selector(zy_networkRequestSuccess:task:responseObject:identifier:)]) {
                    [weakSelf.delegate zy_networkRequestSuccess:weakSelf task:task responseObject:responseObject identifier:identifier];
                }
            }else{
                if ([weakSelf.delegate respondsToSelector:@selector(zy_networkRequestStatusNotZero:task:responseObject:identifier:)]) {
                    [weakSelf.delegate zy_networkRequestStatusNotZero:weakSelf task:task responseObject:responseObject identifier:identifier];
                }
                
                  
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
            if ([weakSelf.delegate respondsToSelector:@selector(zy_networkRequestFail:task:error:identifier:)]) {
                [weakSelf.delegate zy_networkRequestFail:weakSelf task:task error:error identifier:identifier];
            }
        }];
    } @catch (NSException *exception) {
    } @finally {}
    
}

-(void)loadDataWithParams:(NSDictionary *)param requestIdentifier:(NSString *)identifier hud:(BOOL)isHud path:(NSString *)path{
    [self loadDataWithParams:param requestIdentifier:identifier hud:isHud baseURL:self.baseURL path:path];
}

-(void)loadDataWithParams:(NSDictionary *)param requestIdentifier:(NSString *)identifier hud:(BOOL)isHud{
    
    [self loadDataWithParams:param requestIdentifier:identifier hud:isHud baseURL:self.baseURL path:self.path];

}
-(void)loadDataWithParams:(NSDictionary *)param requestIdentifier:(NSString *)identifier path:(NSString *)path{
    
    [self loadDataWithParams:param requestIdentifier:identifier hud:NO baseURL:self.baseURL path:path];
    
}
-(void)uploadImgesWithParams:(NSDictionary *)param images:(NSArray<NSData *> *)images requestIdentifier:(NSString *)identifier hud:(BOOL)isHud{
    
    [self uploadImgesWithParams:param images:images requestIdentifier:identifier hud:isHud isAvatar:NO];
    
}
-(void)loadDataWithParams:(NSDictionary *)param requestIdentifier:(NSString *)identifier{
    
    [self loadDataWithParams:param requestIdentifier:identifier hud:YES];
}

-(void)uploadImgesWithParams:(NSDictionary *)param images:(NSArray<NSData *> *)images requestIdentifier:(NSString *)identifier hud:(BOOL)isHud isAvatar:(BOOL)isAvatar{

    [self.manager POST:[NSString stringWithFormat:@"%@/%@",@"",@"/bhtreatmentimage/addAvator"]
            parameters:param
               constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < images.count; i++) {
            NSData *imgData = images[i];
            NSString *name = isAvatar ? @"file" : [NSString stringWithFormat:@"avatar%d",i];
            [formData appendPartWithFileData:imgData name:name fileName:[NSString stringWithFormat:@"avatar%d%@.jpeg",i,[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]]] mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"param~~%@,response:---%@",param,responseObject);
  
        self.rawData = responseObject;
        if (![responseObject[@"status"] integerValue]) {
            
            if ([self.delegate respondsToSelector:@selector(zy_networkRequestSuccess:task:responseObject:identifier:)]) {
                [self.delegate zy_networkRequestSuccess:self task:task responseObject:responseObject identifier:identifier];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(zy_networkRequestFail:task:error:identifier:)]) {
                [self.delegate zy_networkRequestFail:self task:task error:NULL identifier:identifier];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"param~~%@,response:---%@",param,error);
        if ([self.delegate respondsToSelector:@selector(zy_networkRequestFail:task:error:identifier:)]) {
            [self.delegate zy_networkRequestFail:self task:task error:error identifier:identifier];
        }
    }];
}

-(void)dealloc{

    [self.manager invalidateSessionCancelingTasks:NO];
}

@end

void *fetchKey;
#import <objc/runtime.h>
@implementation ZYNetworkRequest (DataFetch)

-(void)setFetchData:(NSDictionary *)fetchData{

    objc_setAssociatedObject(self, fetchKey, fetchData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSDictionary *)fetchData{

    return objc_getAssociatedObject(self, fetchKey);
}

-(NSDictionary *)fetchDataWithModelMediator:(id<ZYModelMediatorProtocal>)mediator{
    
    __weak typeof(self) weakSelf = self;
    if (mediator == nil) {
        return self.rawData;
    }else{
        [mediator reformDataWithManager:self completionHandler:^(NSDictionary *fetchData) {
            weakSelf.fetchData = fetchData;
        }];
        return self.fetchData;
    }
}

@end
