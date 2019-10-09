//
//  LoginViewController.m
//  JKLHelper
//
//  Created by 刘梓逸 on 2017/12/6.
//  Copyright © 2017年 刘梓逸. All rights reserved.
//

#import "LoginViewController.h"
//#import "PCCircleViewConst.h"
static NSString *kRequetOperationLogin = @"kRequetOperationLogin";
static NSString *kRequetOperationMsgCodeSend = @"kRequetOperationMsgCodeSend";

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIView *msgCodeContainerView;
@property (weak, nonatomic) IBOutlet UITextField *msgCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forget;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnTopConstraint;

@property(nonatomic, weak) NSTimer *timer;
@property(nonatomic, assign) NSInteger counter;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.msgCodeContainerView.hidden = YES;
    self.loginBtnTopConstraint.constant = 20;
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [self.timer invalidate];
}

-(NSString *)baseURL{
    return @"";
}

-(NSString *)path{
    return @"user/login.do";
}

#pragma mark - Action

- (IBAction)msgSend:(UIButton *)sender {
    if (!self.userNameTextField.text.length) {
        [ZYHUDTool showMessage:@"请输入用户名"];
        return;
    }
    [self msgCoodeSendRequest];
    self.counter = 60;
    sender.enabled = NO;
    [self.timer fire];
    
}
- (IBAction)login:(UIButton *)sender {
    
    if (!self.userNameTextField.text.length) {
        [ZYHUDTool showMessage:@"请输入用户名"];
        return;
    }
    if (!self.pwdTextField.text.length) {
        [ZYHUDTool showMessage:@"请输入密码"];
        return;
    }
    
    [self loginRequest];
}

#pragma mark - Request
-(void)loginRequest{
    
    NSMutableDictionary *params = [@{} mutableCopy];
    NSString *pwd = [NSString stringWithFormat:@"%@%@",self.pwdTextField.text,INTERFACE_SIGN_KEY];
    params[@"username"] = self.userNameTextField.text;
    params[@"password"] = [ZYProjectTool md5ByString:pwd].uppercaseString;
    params[@"imei"] = [ZYProjectTool getUUIDString];
    params[@"deviceType"] = @"1";
    params[@"zsessionId"] = @"Login";
    params[@"msgCode"] = self.msgCodeContainerView.isHidden ? @"0" : self.msgCodeTextField.text;
    
    [self.requestManager loadDataWithParams:params requestIdentifier:kRequetOperationLogin];
    
}

-(void)msgCoodeSendRequest{
    
    NSMutableDictionary *params = [@{} mutableCopy];
    params[@"username"] = self.userNameTextField.text;
    params[@"mark"] = @"login";
    params[@"timestamp"] = [NSString stringWithFormat:@"%ld",(NSInteger)[[NSDate date] timeIntervalSince1970]];
    [self.requestManager loadDataWithParams:params requestIdentifier:kRequetOperationMsgCodeSend hud:NO baseURL:DEF_NETPATH_PHP path:@"Applogin/sendCode"];
    
}

#pragma mark - network

-(void)zy_networkRequestSuccess:(ZYNetworkRequest *)requestMgr task:(NSURLSessionDataTask *)task responseObject:(id)responseObject identifier:(NSString *)identifier{
    
    if ([identifier isEqualToString:kRequetOperationLogin]) {
        
        @try {
#pragma warning 持久化重构
            /*** 持久化重构
            [[ZYMediator sharedInstance] setUserName:responseObject[@"data"][@"name"]];
            [[ZYMediator sharedInstance] setAvatar:responseObject[@"data"][@"avator"]];
            [[ZYMediator sharedInstance] setRealName:responseObject[@"data"][@"real_name"]];
            [[ZYMediator sharedInstance] setUserId:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"id"]]];
            [[ZYMediator sharedInstance] setSessionId:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]]];
            [[ZYMediator sharedInstance] setLoginTime:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"login_time"]]];
            [[ZYMediator sharedInstance] setExpiredTime:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"expired_time"]]];
            [[ZYMediator sharedInstance] save];
            */
            
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.loginType && [self.loginType isEqualToString:@"gesture"]) {
//                    [[self valueForKeyPath:@"modalSourceViewController"] performSelectorOnMainThread:NSSelectorFromString(@"resetGesture") withObject:nil waitUntilDone:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:RESET_GESTURE_AFTER_LOGIN_NOTIFICATION object:nil];
                }else{
                    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_NOTIFICATION object:nil];
                }
                
            }];
            
        } @catch (NSException *exception) {
        } @finally {}
        
    }
    
    if ([identifier isEqualToString:kRequetOperationMsgCodeSend]) {
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
            [self sendCodeButtonAppear];
        }
        
        [ZYHUDTool showMessageOnBottom:requestMgr.rawData[@"msg"]];
    } @catch (NSException *exception) {
        [Bugly reportException:exception];
    } @finally {}
    
}

-(void)zy_networkRequestFail:(ZYNetworkRequest *)requestMgr task:(NSURLSessionDataTask *)task error:(NSError *)error identifier:(NSString *)identifier{
    
}

#pragma mark - Private Method
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

-(void)sendCodeButtonAppear{
    if (!self.msgCodeContainerView.isHidden) return;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.loginBtn.zy_y =self.loginBtn.zy_y + 50;
        self.forget.zy_y = self.forget.zy_y + 50;
    } completion:^(BOOL finished) {
        self.msgCodeContainerView.alpha = 0.01;
        [UIView animateWithDuration:0.5 animations:^{
            self.msgCodeContainerView.hidden = NO;
            self.msgCodeContainerView.alpha = 1;
        }];
    }];
    
}

#pragma mark - getter

-(NSTimer *)timer{
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

@end
