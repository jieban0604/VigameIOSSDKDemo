//
//  UMTJAgent.m
//  VigameLibrary
//
//  Created by DLWX on 2017/5/4.
//  Copyright © 2017年 vigame. All rights reserved.
//

#import "UMTJAgent.h"
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
#import <UMAnalytics/DplusMobClick.h>
#import <UMAnalytics/MobClickGameAnalytics.h>
@implementation UMTJAgent
+(void)applicationLaunched{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"VigameLibrary" ofType:@"plist"];
    NSDictionary *rootDict = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSDictionary *tjDict = [rootDict objectForKey:@"statistical parameters"];
    NSString *appkey = [tjDict objectForKey:@"umeng_appkey"];
    [UMConfigure initWithAppkey:appkey channel:@"App Store"];
    [MobClick setScenarioType:E_UM_GAME];
    [MobClick setCrashReportEnabled:NO];
    NSString * deviceID =[UMConfigure deviceIDForIntegration];
    NSLog(@"集成测试的deviceID:%@", deviceID);
    
}
+(void)profileSignIn:(NSString *)puid provider:(NSString *)provider{
    if (!puid||[puid isEqualToString:@""]) {
        NSLog(@"登录账号不能为空，也不能为空字符串");
        return;
    }
    [MobClick profileSignInWithPUID:puid provider:provider];
}

+(void)profileSignOff{
    [MobClick profileSignOff];
}

+(void)setUserLevel:(NSNumber *)level{
    [MobClickGameAnalytics setUserLevelId:[level intValue]];
}

+(void)payByVirtualCurrency:(NSDictionary *)params{
    
    double money = [params[@"money"] doubleValue];
    int source = [params[@"source"] intValue];
    double coin = [params[@"coin"] doubleValue];
    
    [MobClickGameAnalytics pay:money source:source coin:coin];
}


+(void)payByRealCurrency:(NSDictionary *)params{
    double money = [params[@"money"] doubleValue];
    NSString *itemName = params[@"item"];
    int number = [params[@"number"] intValue];
    double price = [params[@"price"] doubleValue];
    int source = [params[@"source"] intValue];
    double coin = [params[@"coin"] doubleValue];
    if (params.allKeys.count == 4) {
        [MobClickGameAnalytics pay:money source:source coin:coin];
    }else{
        [MobClickGameAnalytics pay:money source:source item:itemName amount:number price:price];
    }
}

+(void)buyByVirtualCurrency:(NSDictionary *)params{
    NSString *itemName = params[@"item"];
    int number = [params[@"number"] intValue];
    double price = [params[@"price"] doubleValue];
    
    [MobClickGameAnalytics buy:itemName amount:number price:price];
}

+(void)useVirtualCurrencyBuyProps:(NSDictionary *)params{
    
    NSString *itemName = params[@"item"];
    int number = [params[@"number"] intValue];
    double price = [params[@"price"] doubleValue];
    
    [MobClickGameAnalytics use:itemName amount:number price:price];
    
    
}

+(void)bonusCoin:(NSDictionary *)params{
    
    double coin = [params[@"coin"] doubleValue];
    int source = [params[@"source"] intValue];
    [MobClickGameAnalytics bonus:coin source:source];
    
}

+(void)bonusProp:(NSDictionary *)params{
    
    NSString *itemName = params[@"itemName"];
    int number = [params[@"number"] intValue];
    double price = [params[@"price"] doubleValue];
    int source = [params[@"source"] intValue];
    [MobClickGameAnalytics bonus:itemName amount:number price:price source:source];
    
}

+(void)startLevel:(NSString *)level{
    
    [MobClickGameAnalytics startLevel:level];
    
}

+(void)finishLevel:(NSString *)level score:(NSString *)score{
    
    [MobClickGameAnalytics finishLevel:level];
    
}

+(void)failLevel:(NSString *)level score:(NSString *)score{
    
    [MobClickGameAnalytics failLevel:level];
    
}

+(void)event:(NSString *)eventName lable:(NSString *)label{
    
    if ([label isEqualToString:@""])
    {
        [MobClick event:eventName];
    }
    else
    {
        [MobClick event:eventName label:label];
    }
    
}

+(void)event:(NSString *)eventName attributes:(NSDictionary *)params{
    
    [MobClick event:eventName attributes:params];
    
}

+(void)eventInfo:(NSDictionary *)eventInfo attributes:(NSDictionary *)params{
    
    NSString *eventName = eventInfo[@"eventName"];
    int duration = [eventInfo[@"duration"] intValue];
    [MobClick event:eventName attributes:params counter:duration];
}

+(void)setFirstLaunchEvent:(NSArray *)eventList {
    [DplusMobClick setFirstLaunchEvent:eventList ];
}

@end
