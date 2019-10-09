//
//  ZYNetworkRequest.h
//  BMJingKeLong
//
//  Created by LiuZiyi on 2016/12/13.
//  Copyright © 2016年 蓝色互动. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZYNetworkRequest;

@protocol ZYNetworkRequestDelegate <NSObject>

@required
-(NSString *)baseURL;
-(NSString *)path;

@optional
-(void)zy_networkRequestSuccess:(ZYNetworkRequest *)requestMgr task:(NSURLSessionDataTask *)task responseObject:(id)responseObject identifier:(NSString *)identifier;
-(void)zy_networkRequestStatusNotZero:(ZYNetworkRequest *)requestMgr task:(NSURLSessionDataTask *)task responseObject:(id)responseObject identifier:(NSString *)identifier;
-(void)zy_networkRequestFail:(ZYNetworkRequest *)requestMgr task:(NSURLSessionDataTask *)task error:(NSError *)error identifier:(NSString *)identifier;

@end

@interface ZYNetworkRequest : NSObject

@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, copy) NSString *path;

@property (nonatomic, weak) id<ZYNetworkRequestDelegate> delegate;
@property (nonatomic, strong) NSDictionary *rawData;


//dic-->jsonStr
+(NSString *)jsonStr:(NSDictionary *)param;
//签名sign
-(NSDictionary *)signParams:(NSDictionary *)params;

//特定路径
-(void)loadDataWithParams:(NSDictionary *)param requestIdentifier:(NSString *)identifier path:(NSString *)path;
-(void)loadDataWithParams:(NSDictionary *)param requestIdentifier:(NSString *)identifier hud:(BOOL)isHud path:(NSString *)path;
-(void)loadDataWithParams:(NSDictionary *)param requestIdentifier:(NSString *)identifier hud:(BOOL)isHud baseURL:(NSString *)baseURL path:(NSString *)path;

//默认路径 mobinterface
-(void)loadDataWithParams:(NSDictionary *)param requestIdentifier:(NSString *)identifier;
-(void)loadDataWithParams:(NSDictionary *)param requestIdentifier:(NSString *)identifier hud:(BOOL)isHud;
-(void)uploadImgesWithParams:(NSDictionary *)param images:(NSArray<NSData *> *)images requestIdentifier:(NSString *)identifier hud:(BOOL)isHud;
-(void)uploadImgesWithParams:(NSDictionary *)param images:(NSArray<NSData *> *)images requestIdentifier:(NSString *)identifier hud:(BOOL)isHud isAvatar:(BOOL)isAvatar;
@end

typedef void(^ZYDataMediatorBlock)(NSDictionary *fetchData);
@protocol ZYModelMediatorProtocal <NSObject>
@property (nonatomic, strong) NSDictionary *fetchData;
- (void)reformDataWithManager:(ZYNetworkRequest *)managerRequest completionHandler:(ZYDataMediatorBlock)completionHandler;

@end

@interface ZYNetworkRequest (DataFetch)
@property (nonatomic, strong, readonly) NSDictionary *fetchData;
-(NSDictionary *)fetchDataWithModelMediator:(id<ZYModelMediatorProtocal>)mediator;
@end
