//
//  util.m
//  yingSDK_DEMO
//
//  Created by yingmi on 16/1/22.
//  Copyright © 2016年 yingmi. All rights reserved.
//

#import "util.h"

@implementation util

//json数据转字符串
+ (NSString*)DataTOjsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
