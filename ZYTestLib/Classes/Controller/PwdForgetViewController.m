//
//  PwdForgetViewController.m
//  JKLHelper
//
//  Created by 刘梓逸 on 2018/3/7.
//  Copyright © 2018年 刘梓逸. All rights reserved.
//

#import "PwdForgetViewController.h"

static NSString *kRequetOperationConfirmEdit = @"kRequetOperationConfirmEdit";
static NSString *kRequetOperationPasswordMsgCodeSend = @"kRequetOperationPasswordMsgCodeSend";

@interface PwdForgetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *msgCode;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;

@property(nonatomic, weak) NSTimer *timer;
@property(nonatomic, assign) NSInteger counter;
@end

@implementation PwdForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(NSString *)baseURL{
    return @"";
}

-(NSString *)path{
    return @"user/passwordForget.do";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMsgCode:(UIButton *)sender {
    if (!self.userName.text.length) {
        [ZYHUDTool showMessage:@"请输入用户名"];
        return;
    }
    [self msgCoodeSendRequest];
    self.counter = 60;
    sender.enabled = NO;
    [self.timer fire];
}
- (IBAction)confirm:(id)sender {
    if (!self.userName.text.length) {
        [ZYHUDTool showMessage:@"请输入用户名"];
        return;
    }
    if (!self.password.text.length) {
        [ZYHUDTool showMessage:@"请输入新密码"];
        return;
    }
    
    if ([self.password.text containsString:@" "]) {
        [ZYHUDTool showMessage:@"密码不能包含空格等特殊字符"];
        return;
    }
    if (self.password.text.length <6 || self.password.text.length > 13 ) {
        [ZYHUDTool showMessage:@"密码长度需要在6-13位之间"];
        return;
    }
    if (!self.msgCode.text.length) {
        [ZYHUDTool showMessage:@"请输入验证码"];
        return;
    }
    [self confirmRequest];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Request
-(void)confirmRequest{
    
    NSMutableDictionary *params = [@{} mutableCopy];
    NSString *pwd = [NSString stringWithFormat:@"%@%@",self.password.text,INTERFACE_SIGN_KEY];
    params[@"userName"] = self.userName.text;
    params[@"newPassword"] = [ZYProjectTool md5ByString:pwd].uppercaseString;
    params[@"zsessionId"] = @"forgotpassowrd";
    params[@"msgCode"] = self.msgCode.text;

    [self.requestManager loadDataWithParams:params requestIdentifier:kRequetOperationConfirmEdit];
    
}

-(void)msgCoodeSendRequest{
    
    NSMutableDictionary *params = [@{} mutableCopy];
    params[@"username"] = self.userName.text;
    params[@"mark"] = @"forgotpassowrd";
    params[@"timestamp"] = [NSString stringWithFormat:@"%ld",(NSInteger)[[NSDate date] timeIntervalSince1970]];
    [self.requestManager loadDataWithParams:params requestIdentifier:kRequetOperationPasswordMsgCodeSend hud:NO baseURL:DEF_NETPATH_PHP path:@"Applogin/sendCode"];
    
}

#pragma mark - network

-(void)zy_networkRequestSuccess:(ZYNetworkRequest *)requestMgr task:(NSURLSessionDataTask *)task responseObject:(id)responseObject identifier:(NSString *)identifier{
    
    if ([identifier isEqualToString:kRequetOperationConfirmEdit]) {
        
        @try {
            
            [ZYHUDTool showSuccess:responseObject[@"msg"]];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } @catch (NSException *exception) {
            [Bugly reportException:exception];
        } @finally {}
        
    }
    
    if ([identifier isEqualToString:kRequetOperationPasswordMsgCodeSend]) {
        @try {
            [ZYHUDTool showMessage:requestMgr.rawData[@"msg"]];
        } @catch (NSException *exception) {
            [Bugly reportException:exception];
        } @finally {}
    }
    
}

-(void)zy_networkRequestStatusNotZero:(ZYNetworkRequest *)requestMgr task:(NSURLSessionDataTask *)task responseObject:(id)responseObject identifier:(NSString *)identifier{
    
    @try {
        if ([responseObject[@"status"] isEqual:@4006]) {
            
        }
        
        [ZYHUDTool showMessageOnBottom:requestMgr.rawData[@"msg"]];
    } @catch (NSException *exception) {
        [Bugly reportException:exception];
    } @finally {}
    
}

-(void)zy_networkRequestFail:(ZYNetworkRequest *)requestMgr task:(NSURLSessionDataTask *)task error:(NSError *)error identifier:(NSString *)identifier{
    
}

#pragma mark - getter
-(void)timerFired:(NSTimer *)timer{
    if (self.counter == -1) {
        [self.sendCodeBtn setEnabled:YES];
        [self.timer invalidate];
        self.timer = nil;
        return;
    }else{
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%lds重新获取",self.counter] forState:UIControlStateDisabled];
        self.counter--;
    }
    
}
-(NSTimer *)timer{
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

@end
