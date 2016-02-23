//
//  YingmiCsdk.h
//  YingmiCsdk
//
//  Created by www.yingmi.cn on 15/12/28.
//  Copyright © 2015年 www.yingmi.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  完成块
 *
 *  @param err  错误，err包含错误信息,没有错误err = nil
 *  @param data 成功返回的数据(如果有)
 */
typedef void(^completeBlock)(id err,id data);



@interface YingmiCsdk : NSObject

/**
 *  初始化函数
 *
 *  @param config   参数
 *  @param complete 初始化结果
 */
+ (void)initSDKWithConfig:(NSDictionary*)config completeBlock:(completeBlock)complete;

/**
 *  设置token
 *
 *  @param token
 *
 */
+ (void)setToken:(NSString*)token;

/**
 *  根据command构造url，弹出相关页面
 *
 *  @param command    接口
 *  @param params  接口参数
 *  @param options 其他参数，如http的method UI配色color
 *  @param complete 调用结果
 *
 */
+ (void)callWithUI:(NSString*)command params:(NSDictionary*)params options:(NSDictionary*)options completeBlock:(completeBlock)complete;


/**
 *  接口查询
 *
 *  @param dataType    接口
 *  @param params  接口参数
 *  @param options 其他参数，如http的method
 *  @param complete 调用结果
 *
 */
+ (void)callAsyncWithDataType:(NSString*)dataType params:(NSDictionary*)params options:(NSDictionary*)options completeBlock:(completeBlock)complete;


/**
 *  关闭callWithUI弹出界面
 *
 */
+ (void)abort;
@end
