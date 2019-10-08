//
//  BugHelper.m
//  WYVigame
//
//  Created by DLWX on 2018/8/1.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "BugHelper.h"

@implementation BugHelper
+(void)startWithCallback:(void (^)(id))callback{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"VigameLibrary" ofType:@"plist"];
    NSDictionary *rootDict = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSString *bugly_appid = [rootDict objectForKey:@"bugly_appid"];
    if ([bugly_appid isEqualToString:@""]||bugly_appid== nil) {
         callback(@"腾讯bugly 跟踪添加失败!");
        return;
    }
    [Bugly startWithAppId:bugly_appid];
    callback(@"腾讯bugly 跟踪添加成功!");
}
@end
