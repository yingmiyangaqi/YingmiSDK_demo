//
//  YMMethodTableViewController.m
//  yingSDK_DEMO
//
//  Created by yingmi on 16/1/22.
//  Copyright © 2016年 yingmi. All rights reserved.
//

#import "YMMethodTableViewController.h"
#import "YingmiSDK.h"
#import "util.h"

@interface YMMethodTableViewController (){
    NSArray *datas;
}

@end

@implementation YMMethodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    datas = @[@{@"fundName":@"广发聚富",@"fundCode":@"270001"},
              @{@"fundName":@"广发稳健增长",@"fundCode":@"270002"},
              @{@"fundName":@"广发改革先锋",@"fundCode":@"001468"},
              @{@"fundName":@"广发货币A",@"fundCode":@"270004"},
              @{@"fundName":@"广发标普全球农业",@"fundCode":@"270027"},
              @{@"fundName":@"广发新经济",@"fundCode":@"270050"}];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datas.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = nil;
    if (indexPath.row == datas.count) {
        reuseIdentifier = @"walletIdentifier";
    }else{
        reuseIdentifier = @"cellIdentifier";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == datas.count) {
        UILabel *name = (UILabel*)[cell viewWithTag:13];
        name.text = @"盈米宝";
        UILabel *fundCode = (UILabel*)[cell viewWithTag:14];
        fundCode.text = @"000509";
    }else{
        UILabel *name = (UILabel*)[cell viewWithTag:13];
        name.text = datas[indexPath.row][@"fundName"];
        UILabel *fundCode = (UILabel*)[cell viewWithTag:14];
        fundCode.text = datas[indexPath.row][@"fundCode"];
    }
    
    
    return cell;
}

- (IBAction)risk:(id)sender {
    [YingmiSDK callWithUI:@"riskSurvey" params:nil options:nil completeBlock:^(id err, id data) {
        NSString *msg = err ? [util DataTOjsonString:err] : [util DataTOjsonString:data];
        NSLog(@"%@",msg);
    }];
}

- (IBAction)allot:(id)sender {
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSInteger row = path.row;
    
    [YingmiSDK callWithUI:@"buyFund" params:@{@"fundCode":datas[row][@"fundCode"]} options:nil completeBlock:^(id err, id data) {
        NSString *msg = err ? [util DataTOjsonString:err] : [util DataTOjsonString:data];
        NSLog(@"%@",msg);
    }];
}


- (IBAction)investPlan:(id)sender {
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSInteger row = path.row;
    
    [YingmiSDK callWithUI:@"createFundInvestPlan" params:@{@"fundCode":datas[row][@"fundCode"]} options:nil completeBlock:^(id err, id data) {
        NSString *msg = err ? [util DataTOjsonString:err] : [util DataTOjsonString:data];
        NSLog(@"%@",msg);
    }];
}

- (IBAction)rechargeWallet:(id)sender {
    [YingmiSDK callWithUI:@"deposit" params:nil options:nil completeBlock:^(id err, id data) {
        NSString *msg = err ? [util DataTOjsonString:err] : [util DataTOjsonString:data];
        NSLog(@"%@",msg);
    }];
}


- (IBAction)redeemWallet:(id)sender {
    [YingmiSDK callWithUI:@"withdraw" params:nil options:nil completeBlock:^(id err, id data) {
        NSString *msg = err ? [util DataTOjsonString:err] : [util DataTOjsonString:data];
        NSLog(@"%@",msg);
    }];
}

@end
