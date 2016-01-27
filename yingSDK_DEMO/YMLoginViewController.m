//
//  YMLoginViewController.m
//  yingSDK_DEMO
//
//  Created by yingmi on 16/1/22.
//  Copyright © 2016年 yingmi. All rights reserved.
//

#import "YMLoginViewController.h"
#import "YingmiSDK.h"
#import "HttpClient.h"

@interface YMLoginViewController ()
{
    Deferred *d;
    NSString *token;
    NSString *access_token;
}

@property (nonatomic) BOOL isInit;

@property (weak, nonatomic) IBOutlet UITextField *txt_accountId;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
@property (weak, nonatomic) IBOutlet UIButton *btnToken;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
@property (weak, nonatomic) IBOutlet UILabel *lb_token;
@end

@implementation YMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
    [self.view endEditing:NO];
}

- (IBAction)login:(id)sender {
    NSString *name = self.txt_accountId.text;
    NSString *password = self.txt_password.text;
    //1.第三方用户登录，获取第三方用户token 注：这地方是个模拟过程
    d = [HttpClient doPost:@"http://172.19.0.244/ymb/v1/user/login" parameters:@{@"name":name,@"password":password}];
    __weak YMLoginViewController *weakSelf = self;
    [d then:^id(id resultObject) {
        NSDictionary *dict = (NSDictionary*)resultObject;
        if(dict){
            //2.
            token = dict[@"token"];
            weakSelf.btnToken.enabled = YES;
            
        }
        return resultObject;
    } failure:^id(id resultObject) {
        return resultObject;
    }];
}


- (IBAction)token:(id)sender {
    //3.获取盈米token 注：这地方是个模拟过程
    d = [HttpClient doGet:@"http://172.19.0.244/ymb/v1/user/token" parameters:@{@"access_token":token}];
    
    __weak YMLoginViewController *weakSelf = self;
    [d then:^id(id resultObject) {
        NSDictionary *dict = (NSDictionary*)resultObject;
        if(dict){
            //4.
            access_token = dict[@"accessToken"];
            weakSelf.btnBuy.enabled = YES;
            self.lb_token.text = access_token;
            
            if(!weakSelf.isInit){
                //5.获取盈米token后，初始化SDK,初始化只需要一次
                [YingmiSDK initSDKWithConfig:@{@"brokerId":@"123456",@"token":access_token} completeBlock:^(id err, id data) {
                    if(err){
                        weakSelf.isInit = NO;
                    }else{
                        weakSelf.isInit = YES;
                    }
                }];
            }else{
                //6.如果重新登录,不必再初始化SDK(初始化也不会有任何影响),只需设置SDK中盈米token
                [YingmiSDK setToken:access_token];
            }
        }
        
        return resultObject;
    } failure:^id(id resultObject) {
        return resultObject;
    }];
}


@end
