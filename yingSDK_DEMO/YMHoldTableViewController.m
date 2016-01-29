//
//  YMHoldTableViewController.m
//  yingSDK_DEMO
//
//  Created by yingmi on 16/1/22.
//  Copyright © 2016年 yingmi. All rights reserved.
//

#import "YMHoldTableViewController.h"
#import "YingmiCsdk.h"
#import "util.h"

@interface YMHoldTableViewController ()
{
    NSArray *holdDatas;
}
@end

@implementation YMHoldTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    __weak YMHoldTableViewController *weakSelf = self;
    [YingmiCsdk callAsyncWithDataType:@"fundShares" params:nil options:nil completeBlock:^(id err, id data) {
        if(!err){
            holdDatas = data;
            [weakSelf.tableView reloadData];
        }
    }];
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
    return holdDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"holdIdentifier" forIndexPath:indexPath];
    
    UILabel *name = (UILabel*)[cell viewWithTag:23];
    name.text = holdDatas[indexPath.row][@"fundName"];
    UILabel *fundCode = (UILabel*)[cell viewWithTag:24];
    fundCode.text = holdDatas[indexPath.row][@"fundCode"];
    
    return cell;
}


- (IBAction)redeem:(id)sender{
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSInteger row = path.row;
    
    [YingmiCsdk callWithUI:@"redeemFund" params:@{@"shareId":holdDatas[row][@"shareId"]} options:nil completeBlock:^(id err, id data) {
        NSString *msg = err ? [util DataTOjsonString:err] : [util DataTOjsonString:data];
        NSLog(@"%@",msg);
    }];
}

- (IBAction)convert:(id)sender{
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSInteger row = path.row;
    
    [YingmiCsdk callWithUI:@"convert" params:@{@"shareId":holdDatas[row][@"shareId"]} options:nil completeBlock:^(id err, id data) {
        NSString *msg = err ? [util DataTOjsonString:err] : [util DataTOjsonString:data];
        NSLog(@"%@",msg);
    }];
}


- (IBAction)change:(id)sender {
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSInteger row = path.row;
    
    [YingmiCsdk callWithUI:@"setFundDividendMethod" params:@{@"shareId":holdDatas[row][@"shareId"]} options:nil completeBlock:^(id err, id data) {
        NSString *msg = err ? [util DataTOjsonString:err] : [util DataTOjsonString:data];
        NSLog(@"%@",msg);
    }];
}

@end
