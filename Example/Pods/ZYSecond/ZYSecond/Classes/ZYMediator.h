//
//  ZYMediator.h
//  BMJingKeLong
//
//  Created by LiuZiyi on 2016/12/20.
//  Copyright © 2016年 蓝色互动. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <PYSearch/PYSearch.h>
//#import "StoreAuthorityModel.h"
@interface ZYMediator : NSObject<NSCoding>

@property(nonatomic, copy) NSString *realName;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *sessionId;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *loginTime;
@property(nonatomic, copy) NSString *expiredTime;
@property(nonatomic, copy) NSString *avatar;

@property(nonatomic, copy) NSString *sn;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *role_id;

@property(nonatomic, assign) NSInteger force;
@property(nonatomic, copy) NSString *versionName;
-(NSString *)storeName;
-(NSString *)roleName;
+(instancetype)sharedInstance;
-(BOOL)save;
-(void)clear;
@end

@interface ZYMediator (Login)
-(BOOL)isLogin;
-(void)reset;
@end

@interface ZYMediator (ProjectHelper)
-(UIColor *)getThemeColor;
-(NSArray<NSString *> *)getHotWords;
-(UIColor *)getBackgroundColor;

@end

@interface ZYMediator (AllGoodsList)
-(id)zymediator_viewControllerWithClass:(Class)className;
-(id)zymediator_viewControllerWithClass:(Class)className params:(NSDictionary *)params;
-(id)zymediator_MainStroyboardVCWithParams:(NSDictionary *)params storyboardID:(NSString *)sbdID;
-(id)zymediator_HomePageStroyboardVCWithParams:(NSDictionary *)params storyboardID:(NSString *)sbdID;
-(id)zymediator_CategoryPageStroyboardVCWithParams:(NSDictionary *)params storyboardID:(NSString *)sbdID;
-(id)zymediator_ThirdPageStroyboardVCWithParams:(NSDictionary *)params storyboardID:(NSString *)sbdID;
-(id)zymediator_MinePageStroyboardVCWithParams:(NSDictionary *)params storyboardID:(NSString *)sbdID;
//-(id)zymediator_NewHomePageStroyboardVCWithParams:(NSDictionary *)params storyboardID:(NSString *)sbdID;
//-(id)zymediator_ConvenienceShopPageStroyboardVCWithParams:(NSDictionary *)params storyboardID:(NSString *)sbdID;
@end

@interface ZYMediator (PageTransition)
-(void)zymediator_jumpSearchPageWithSourceViewController:(UIViewController *)sourceViewController;
@end
