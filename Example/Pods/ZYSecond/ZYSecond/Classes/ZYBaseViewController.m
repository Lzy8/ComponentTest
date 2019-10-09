//
//  ZYBaseViewController.m
//  BMJingKeLong
//
//  Created by LiuZiyi on 2016/12/13.
//  Copyright © 2016年 蓝色互动. All rights reserved.
//

#import "ZYBaseViewController.h"

@interface ZYBaseViewController ()

@end

@implementation ZYBaseViewController

-(ZYNetworkRequest *)requestManager{

    if (!_requestManager) {
        _requestManager = [[ZYNetworkRequest alloc] init];
        _requestManager.delegate = self;
    }
    return _requestManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.requestManager.baseURL = [self baseURL];
    self.requestManager.path = [self path];

}

-(NSString *)baseURL{

    return @"";
}
-(NSString *)path{

    return @"api";
}

//-(void)setupBaseNavBar
//{
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
//}

-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}

@end
