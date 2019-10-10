//
//  ZYMediator.m
//  BMJingKeLong
//
//  Created by LiuZiyi on 2016/12/20.
//  Copyright © 2016年 蓝色互动. All rights reserved.
//

#import "ZYMediator.h"
#import "ZYProjectHolder.h"
#define _ZY_COLOR_RGBA(r,g,b,a)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define DEF_FILE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
@interface ZYMediator()

@end

@implementation ZYMediator
- (id)initWithCoder:(NSCoder *)encoder
{
    if (self = [super init]) {
//        [self mj_decode:decoder];

        self.realName =[encoder decodeObjectForKey:@"realName"];
       self.userName = [encoder decodeObjectForKey:@"userName"];
       self.sessionId = [encoder decodeObjectForKey:@"sessionId"];
       self.userId = [encoder decodeObjectForKey:@"userId"];
       _loginTime = [encoder decodeObjectForKey:@"loginTime"];
       _expiredTime = [encoder decodeObjectForKey:@"expiredTime"];
        self.avatar = [encoder decodeObjectForKey:@"avatar"];
       self.sn = [encoder decodeObjectForKey:@"sn"];
       self.desc = [encoder decodeObjectForKey:@"desc"];
       self.role_id = [encoder decodeObjectForKey:@"role_id"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.realName forKey:@"realName"];
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:self.sessionId forKey:@"sessionId"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:_loginTime forKey:@"loginTime"];
    [encoder encodeObject:_expiredTime forKey:@"expiredTime"];
    
    [encoder encodeObject:self.sn forKey:@"sn"];
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeObject:self.role_id forKey:@"role_id"];
    
}
+(instancetype)sharedInstance{
    
    static ZYMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [ZYMediator loadIncetance] ? [ZYMediator loadIncetance] : [[ZYMediator alloc] init];
    });
    return mediator;
}

-(NSString *)loginTime{
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([_loginTime integerValue] / 1000)];
        return [formatter stringFromDate:date];
    } @catch (NSException *exception) {
//        [Bugly reportException:exception];
        return @"--";
    } @finally {}
}

-(NSString *)expiredTime{
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:([_expiredTime integerValue] / 1000)];
        return [formatter stringFromDate:date];
    } @catch (NSException *exception) {
//        [Bugly reportException:exception];
        return @"--";
    } @finally {}
}

-(BOOL)save{
    // 获取沙盒Document路径
    NSString *filePath = DEF_FILE_PATH;
    //[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    //文件路径
    NSString *uniquePath=[filePath stringByAppendingPathComponent:@"mediator.txt"];

    BOOL isSave = [NSKeyedArchiver archiveRootObject:self toFile:uniquePath];
    return isSave;
}

- (void)clear
{
    NSString *filePath = DEF_FILE_PATH;
    //;
    
    //文件路径
    NSString *uniquePath=[filePath stringByAppendingPathComponent:@"mediator.txt"];
    // 创建文件管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    // 删除
    NSError *error;
    [manager removeItemAtPath:uniquePath error:&error];
//    MJLog(@"%@",error.description);
}

+ (instancetype)loadIncetance{
    // 获取沙盒Document路径
    NSString *filePath = DEF_FILE_PATH;
    //[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //文件路径
    NSString *uniquePath=[filePath stringByAppendingPathComponent:@"mediator.txt"];
    ZYMediator *instance = [NSKeyedUnarchiver unarchiveObjectWithFile:uniquePath];
    return instance;
}

-(NSString *)storeName{
    @try {
        return [[self.desc componentsSeparatedByString:@"_"] firstObject];
    } @catch (NSException *exception) {
//        [Bugly reportException:exception];
        return @"--";
    } @finally {}
    
}
-(NSString *)roleName{
    @try {
        return [[self.desc componentsSeparatedByString:@"_"] lastObject];
    } @catch (NSException *exception) {
//        [Bugly reportException:exception];
        return @"--";
    } @finally {}
}


@end

@implementation ZYMediator (ProjectHelper)
-(UIColor *)getThemeColor{
    return _ZY_COLOR_RGBA(0, 122, 255, 1);
}
-(UIColor *)getBackgroundColor{
    return _ZY_COLOR_RGBA(244,244,244,1);
}
-(NSArray<NSString *> *)getHotWords{
    return nil;
//    NSArray *arr = [(NSString *)[[NSUserDefault ] valueForKey:@"HOT_WORDS"] componentsSeparatedByString:@","];
//    if (!arr.count) {
//        return @[@"旺仔",@"乐事"];
//    }else{
//        return arr;
//    }
}
@end

@implementation ZYMediator (Login)
-(BOOL)isLogin{
    if (self.sessionId) {
        return YES;
    }else{
        return NO;
    }
}
-(void)reset{
    [self setSessionId:nil];
    [self setUserId:nil];
    [self setUserName:nil];
}
@end

@implementation ZYMediator (AllGoodsList)
-(id)zymediator_viewControllerWithClass:(Class)className{

    UIViewController *vc = [[className alloc] init];
    return vc;
}
-(id)zymediator_viewControllerWithClass:(Class)className params:(NSDictionary *)params{
    
    UIViewController *vc = [[className alloc] init];
    if (params) {
        
        [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [vc performSelectorOnMainThread:NSSelectorFromString(key) withObject:obj waitUntilDone:YES];
            
        }];
    }
    return vc;
}

-(id)zymediator_MainStroyboardVCWithParams:(NSDictionary *)params storyboardID:(NSString *)sbdID{
    
    UIViewController *vc = [[ZYProjectHolder sharedInstance].mainPage instantiateViewControllerWithIdentifier:sbdID];
    if (params) {
        
        [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [vc performSelectorOnMainThread:NSSelectorFromString(key) withObject:obj waitUntilDone:YES];
            
        }];
    }
    
    return vc;
}

-(id)zymediator_HomePageStroyboardVCWithParams:(NSDictionary *)params storyboardID:(NSString *)sbdID{
    
    UIViewController *vc = [[ZYProjectHolder sharedInstance].homePage instantiateViewControllerWithIdentifier:sbdID];
    if (params) {
        
        [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [vc performSelectorOnMainThread:NSSelectorFromString(key) withObject:obj waitUntilDone:YES];
            
        }];
    }
    
    return vc;
}
-(id)zymediator_CategoryPageStroyboardVCWithParams:(NSDictionary *)params storyboardID:(NSString *)sbdID{
    
    UIViewController *vc = [[ZYProjectHolder sharedInstance].categoryPage instantiateViewControllerWithIdentifier:sbdID];
    if (params) {
        
        [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [vc performSelectorOnMainThread:NSSelectorFromString(key) withObject:obj waitUntilDone:YES];
            
        }];
    }
    return vc;
}
-(id)zymediator_ThirdPageStroyboardVCWithParams:(NSDictionary *)params storyboardID:(NSString *)sbdID{
    
    UIViewController *vc = [[ZYProjectHolder sharedInstance].thirdPage instantiateViewControllerWithIdentifier:sbdID];
    if (params) {
        
        [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [vc performSelectorOnMainThread:NSSelectorFromString(key) withObject:obj waitUntilDone:YES];
            
        }];
    }
    return vc;
}
-(id)zymediator_MinePageStroyboardVCWithParams:(NSDictionary *)params storyboardID:(NSString *)sbdID{
    
    UIViewController *vc = [[ZYProjectHolder sharedInstance].minePage instantiateViewControllerWithIdentifier:sbdID];
    if (params) {
        
        [params enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [vc performSelectorOnMainThread:NSSelectorFromString(key) withObject:obj waitUntilDone:YES];
            
        }];
    }
    return vc;
}

@end

//#import "PYSearch.h"
@implementation ZYMediator (PageTransition)

-(void)zymediator_jumpSearchPageWithSourceViewController:(UIViewController *)sourceViewController{
    
//    NSArray *hotSeaches = @[@"22",@"33",@"44"];
//    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索想要的商品" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
//        // 开始搜索执行以下代码
//        NSMutableDictionary *params = [NSMutableDictionary dictionary];
//        params[@"setKeyStr:"] = searchText;
//        params[@"setSearchType:"] = @"search";
//        UIViewController *vc = [[ZYMediator sharedInstance] zymediator_viewControllerWithClass:NSClassFromString(@"ZYNewGoodsListViewController") params:params];
//        vc.navigationController.navigationBarHidden = NO;
//        // 如：跳转到指定控制器
//        [searchViewController.navigationController pushViewController:vc animated:YES];
//    }];
//
//    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag; // 热门搜索风格为默认
//    searchViewController.searchHistoryStyle = PYSearchHistoryStyleCell; // 搜索历史风格根据选择
//    //    UIViewController *searchVC = [[ZYMediator sharedInstance] zymediator_BranchStroyboardVCWithParams:nil storyboardID:@"searchGoodsStoryboard"];
//    searchViewController.delegate = self;
//    [sourceViewController.navigationController showViewController:searchViewController sender:nil];
    
}

//- (void)didClickCancel:(PYSearchViewController *)searchViewController{
//
//    [searchViewController.navigationController popViewControllerAnimated:YES];
//}

@end
