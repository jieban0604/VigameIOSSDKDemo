//
//  DataEyeAgent.m
//  VigameLibrary
//
//  Created by DLWX on 2017/5/8.
//  Copyright © 2017年 vigame. All rights reserved.
//


#import "DataEyeAgent.h"
#import "tj/DataEye/IOS/DEAgent.h"
#import "DCTrackingAgent.h"
#include "core/SysConfig.h"
static NSString * m_account = nil;
@implementation DataEyeAgent
+(void)applicationLaunched{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"VigameLibrary" ofType:@"plist"];
    NSDictionary *rootDict = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSDictionary *tjDict = [rootDict objectForKey:@"statistical parameters"];
    NSString *trackAppID = [tjDict objectForKey:@"dataeye_trackingid"];
    [DCTrackingAgent initWithAppId:trackAppID andChannelId:@"app store"];
}

+ (void)profileSignIn:(NSString *)puid provider:(NSString *)provider{
    if (!puid||[puid isEqualToString:@""]) {
        NSLog(@"登录账号不能为空，也不能为空字符串");
        return;
    }
    m_account = puid;//在账号登录的时候将账号 保存在静态变量中 供上报使用
    [DCTrackingPoint login:puid];
}

+ (void)payByRealCurrency:(NSDictionary *)params {
    double amountMoney = [params[@"money"] doubleValue];
    NSString *paymentType = [NSString stringWithFormat:@"%@",params[@"source"]];
    std::string ac = vigame::SysConfig::getInstance()->getImei();
    NSString *account = [NSString stringWithUTF8String:ac.c_str()];
    
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYYMMddHHmmssSSSS"];
    NSString *orderID = [nsdf2 stringFromDate:[NSDate date]];
    [DCTrackingPoint paymentSuccess:account orderId:orderID currencyAmount:amountMoney currencyType:@"CNY" paymentType:paymentType];
}

+(void)setEffectPoint:(NSString*)pointId dictionary:(NSDictionary*)map {
    [DCTrackingPoint setEffectPoint:pointId propDictionary:map];
}

@end
