//
//  YMOrdersTableViewController.m
//  yingSDK_DEMO
//
//  Created by yingmi on 16/1/22.
//  Copyright © 2016年 yingmi. All rights reserved.
//

#import "YMOrdersTableViewController.h"
#import "YingmiCsdk.h"
#import "util.h"

@interface YMOrdersTableViewController ()
{
    NSArray *orderDatas;
    NSArray *investPlanDatas;
}
@end

@implementation YMOrdersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    __weak YMOrdersTableViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_enter(group);
        [YingmiCsdk callAsyncWithDataType:@"fundOrders" params:nil options:nil completeBlock:^(id err, id data) {
            if(!err){
                orderDatas = data;
            }
            
            dispatch_group_leave(group);
        }];
        
        
        dispatch_group_enter(group);
        
        [YingmiCsdk callAsyncWithDataType:@"listFundInvestPlan" params:nil options:nil completeBlock:^(id err, id data) {
            if(!err){
                investPlanDatas = data;
                dispatch_group_leave(group);
            }
        }];

        
        dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*60));//最长等待1分钟
        if(orderDatas || investPlanDatas){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
        
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return orderDatas.count;
    }else if(section == 1){
        return investPlanDatas.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = nil;
    if (indexPath.section == 0) {
        reuseIdentifier = @"orderIdentifier";
    }else{
        reuseIdentifier = @"investPlanIdentifier";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        UILabel *name = (UILabel*)[cell viewWithTag:33];
        name.text = orderDatas[indexPath.row][@"fundName"];
        UILabel *fundCode = (UILabel*)[cell viewWithTag:34];
        fundCode.text = orderDatas[indexPath.row][@"fundCode"];
        UIButton *cancelBtn = (UIButton*)[cell viewWithTag:35];
        if ([orderDatas[indexPath.row][@"cancelable"] integerValue] == 1) {
            cancelBtn.enabled = YES;
        }else{
            cancelBtn.enabled = NO;
        }
        
    }else if(indexPath.section == 1){
        UILabel *name = (UILabel*)[cell viewWithTag:43];
        name.text = investPlanDatas[indexPath.row][@"fundName"];
        UILabel *fundCode = (UILabel*)[cell viewWithTag:44];
        fundCode.text = investPlanDatas[indexPath.row][@"fundCode"];
        
        UIButton *updateBtn = (UIButton*)[cell viewWithTag:45];
        UIButton *resumeBtn = (UIButton*)[cell viewWithTag:46];
        UIButton *pauseBtn = (UIButton*)[cell viewWithTag:47];
        UIButton *terminateBtn = (UIButton*)[cell viewWithTag:48];
        
        if ([investPlanDatas[indexPath.row][@"status"] isEqualToString:@"A"]) {
            updateBtn.enabled = YES;
            resumeBtn.enabled = NO;
            pauseBtn.enabled = YES;
            terminateBtn.enabled = YES;
        }else if ([investPlanDatas[indexPath.row][@"status"] isEqualToString:@"P"]){
            updateBtn.enabled = YES;
            resumeBtn.enabled = YES;
            pauseBtn.enabled = NO;
            terminateBtn.enabled = YES;
        }else if ([investPlanDatas[indexPath.row][@"status"] isEqualToString:@"T"]){
            updateBtn.enabled = NO;
            resumeBtn.enabled = NO;
            pauseBtn.enabled = NO;
            terminateBtn.enabled = NO;
        }
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20.;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UILabel * ordersHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20.)];
        ordersHeader.backgroundColor = [UIColor lightGrayColor];
        ordersHeader.text = @"订单";
        
        return ordersHeader;
    }else{
        UILabel * investPlanHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20.)];
        investPlanHeader.backgroundColor = [UIColor lightGrayColor];
        investPlanHeader.text = @"定投";
        
        return investPlanHeader;
    }
    
    return nil;
}

- (IBAction)cancelOrder:(id)sender {
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSInteger row = path.row;
    
    [YingmiCsdk callWithUI:@"cancelFundOrder" params:@{@"orderId":orderDatas[row][@"orderId"]} options:nil completes:@{@"error":^(id err){
        NSLog(@"%@",[util DataTOjsonString:err]);
    },@"success":^(id data){
        NSLog(@"%@",[util DataTOjsonString:data]);
    }}];
}

- (IBAction)updateInvestPlan:(id)sender {
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSInteger row = path.row;
    
    [YingmiCsdk callWithUI:@"updateFundInvestPlan" params:@{@"investPlanId":investPlanDatas[row][@"investPlanId"]} options:nil completes:@{@"error":^(id err){
        NSLog(@"%@",[util DataTOjsonString:err]);
    },@"success":^(id data){
        NSLog(@"%@",[util DataTOjsonString:data]);
    }}];
}


- (IBAction)resumeInvestPlan:(id)sender {
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSInteger row = path.row;
    
    [YingmiCsdk callWithUI:@"resumeFundInvestPlan" params:@{@"investPlanId":investPlanDatas[row][@"investPlanId"]} options:nil completes:@{@"error":^(id err){
        NSLog(@"%@",[util DataTOjsonString:err]);
    },@"success":^(id data){
        NSLog(@"%@",[util DataTOjsonString:data]);
    }}];
}

- (IBAction)pauseInvestPlan:(id)sender {
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSInteger row = path.row;
    
    [YingmiCsdk callWithUI:@"pauseFundInvestPlan" params:@{@"investPlanId":investPlanDatas[row][@"investPlanId"]} options:nil completes:@{@"error":^(id err){
        NSLog(@"%@",[util DataTOjsonString:err]);
    },@"success":^(id data){
        NSLog(@"%@",[util DataTOjsonString:data]);
    }}];
}

- (IBAction)terminateInvestPlan:(id)sender {
    UITableViewCell * cell = (UITableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [self.tableView indexPathForCell:cell];
    NSInteger row = path.row;
    
    [YingmiCsdk callWithUI:@"terminateFundInvestPlan" params:@{@"investPlanId":investPlanDatas[row][@"investPlanId"]} options:nil completes:@{@"error":^(id err){
        NSLog(@"%@",[util DataTOjsonString:err]);
    },@"success":^(id data){
        NSLog(@"%@",[util DataTOjsonString:data]);
    }}];
}

@end
