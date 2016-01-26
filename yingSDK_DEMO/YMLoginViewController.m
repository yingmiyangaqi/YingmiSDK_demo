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
}

@property (nonatomic) BOOL isInit;

@property (weak, nonatomic) IBOutlet UITextField *txt_accountId;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
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

    [d then:^id(id resultObject) {
        NSDictionary *dict = (NSDictionary*)resultObject;
        if(dict){
            //2.
            token = dict[@"token"];
        }
        return resultObject;
    } failure:^id(id resultObject) {
        return resultObject;
    }];
}


@end
