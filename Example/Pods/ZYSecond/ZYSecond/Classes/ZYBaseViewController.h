//
//  ZYBaseViewController.h
//  BMJingKeLong
//
//  Created by LiuZiyi on 2016/12/13.
//  Copyright © 2016年 蓝色互动. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYNetworkRequest.h"
@interface ZYBaseViewController : UIViewController<ZYNetworkRequestDelegate>

@property (nonatomic, strong) ZYNetworkRequest *requestManager;

@end
