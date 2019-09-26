//
//  AFTJAgent.m
//  VigameLibrary
//
//  Created by DLWX on 2017/5/4.
//  Copyright © 2017年 vigame. All rights reserved.
//

#import "AFTJAgent.h"
#import <AppsFlyerLib/AppsFlyerTracker.h>

@implementation AFTJAgent

+(void)applicationLaunched{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"VigameLibrary" ofType:@"plist"];
    NSDictionary *rootDict = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSDictionary *tjDict = [rootDict objectForKey:@"statistical parameters"];
    NSString *flyerDevKey = [tjDict objectForKey:@"appsflyer_devkey"];
    NSString *appleAppID = [rootDict objectForKey:@"apple_appid"];
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = flyerDevKey;
    [AppsFlyerTracker sharedTracker].appleAppID = appleAppID;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        //默认第一取到值为NO 转成YES 是第一次启动
        NSString* firstLaunchTime = [def objectForKey:@"First_Launch_Time"];
        if (!firstLaunchTime) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
            NSDate *datenow = [NSDate date];
            NSString *currentTimeString = [formatter stringFromDate:datenow];
            [def setObject:currentTimeString forKey:@"First_Launch_Time"];
            [def synchronize];
        }else{
            //如果是第二天 并且尚未统计过
            BOOL isTJ_Second_Day = [def boolForKey:@"Appflyer_TJ_Second_Day"];
            if ([AFTJAgent isSecondLaunchDay] && !isTJ_Second_Day) {
                [def setBool:YES forKey:@"Appflyer_TJ_Second_Day"];
                [AFTJAgent event:@"day 2 retention" lable:@""];//统计一次
            }
        }
    });
}
#pragma mark - 是否为第二天打开
+(BOOL)isSecondLaunchDay{
    //第一次启动的保存时间
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *firstLaunchTime1 = [def objectForKey:@"First_Launch_Time"];//yyyy-MM-dd HH-mm-ss
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSDate *firstLaunchDate = [formatter1 dateFromString:firstLaunchTime1];//时分秒
    //当前时间
    NSDate *datenow = [NSDate date];
    //当前时间和第一次启动时间的间隔
    double t1 =  [datenow timeIntervalSince1970] - [firstLaunchDate timeIntervalSince1970];
    //当天剩余时间
    double t2 = [AFTJAgent restTimeOfDate:firstLaunchDate];
   
    //判断是否是第二天
    if (t1>=t2 && t1<t2+24*60*60) {
        return YES;
    }
    return NO;
}
#pragma mark - 当天剩下的秒
+(double)restTimeOfDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *dateString = [formatter stringFromDate:date];
    dateString = [dateString substringToIndex:11];
    dateString = [dateString stringByAppendingString:@"00-00-00"];
    NSDate* date1 = [formatter dateFromString:dateString];
    NSTimeInterval t =  [date timeIntervalSince1970] - [date1 timeIntervalSince1970];
    return 24*60*60 - t;
}

+(void)applicationDidBecomeActive{
    //追踪应用打开
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

+(void)profileSignIn:(NSString *)puid provider:(NSString *)provider{
    if (!puid||[puid isEqualToString:@""]) {
        NSLog(@"登录账号不能为空，也不能为空字符串");
        return;
    }
    NSDictionary *dict = @{@"puid":puid};
    if (provider) {
        dict = @{@"puid":puid,@"provider":provider};
    }
    [[AppsFlyerTracker sharedTracker]trackEvent:AFEventLogin withValues:dict];
}
+(void)payByRealCurrency:(NSDictionary *)params{
    NSNumber *money = params[@"money"];
    NSString *itemStr = [NSString stringWithFormat:@"%@",params[@"item"]];
    [[AppsFlyerTracker sharedTracker] trackEvent:AFEventPurchase withValues: @{
                                                                               AFEventParamContentId:itemStr,
                                                                               AFEventParamContentType : @"category_a",
                                                                               AFEventParamRevenue: money,
                                                                               AFEventParamCurrency:@"CNY"}];    
}
+(void)event:(NSString *)eventName lable:(NSString *)label{
    NSDictionary *params = nil;
    if (![label isEqualToString:@""]) {
        params = @{@"label":label};
    }
    [[AppsFlyerTracker sharedTracker]trackEvent:eventName withValues:params];
}


+(void)event:(NSString *)eventName attributes:(NSDictionary *)params{
    [[AppsFlyerTracker sharedTracker]trackEvent:eventName withValues:params];
}
@end
