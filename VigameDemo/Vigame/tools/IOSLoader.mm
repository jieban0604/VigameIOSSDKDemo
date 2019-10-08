//
//  IOSLoader.m
//  Vigame_Test
//
//  Created by DLWX on 2018/9/14.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "IOSLoader.h"
#include "vigame_core.h"
#include "vigame_pay.h"
#include "vigame_ad.h"
#include "vigame_tj.h"
#include "tj/apple/DataTJManagerImpl-apple.h"
#include "vigame_push.h"
#include "ad/ADManagerImpl.h"
#include "core/MmChnlManager.h"
#include "core/SysConfig.h"
#include "core/Community.h"
#include "core/Browser.h"
#import <objc/runtime.h>

#import "VBAdUtils.h"

static BOOL isAwaken = false;
static BOOL isFirstLaunch = true;
static BOOL isOpenUrl = false;
static NSInteger splashPrportRequestCount = 0;
@implementation IOSLoader

#pragma mark - 初始化
// 开屏上报
+(void)splashReport {
    
    vigame::SysConfig* pSysConfig = vigame::SysConfig::getInstance();
    
    NSString *pid = [NSString stringWithCString:pSysConfig->getPrjid().c_str() encoding:[NSString defaultCStringEncoding]];
    NSString *lsn= [NSString stringWithCString:pSysConfig->getLsn().c_str() encoding:[NSString defaultCStringEncoding]];
    NSString *imei = [NSString stringWithCString:pSysConfig->getImei().c_str() encoding:[NSString defaultCStringEncoding]];
    
    NSString *params = [NSString stringWithFormat:@"pid=%@&lsn=%@&imei=%@&postType=1",pid,lsn,imei];

    NSData *encodeData = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
    NSURL *requestURL = [NSURL URLWithString:
                         [NSString stringWithFormat:@"http://data.vimedia.cn/admsg/postpoint/v1?value=%@",base64String]];
    
    NSLog(@"params = %@,base64String = %@,requestURL = %@",params,base64String,requestURL);

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestURL];
    urlRequest.HTTPMethod = @"GET";
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error == nil) {
            NSLog(@"splashReport success!");
            splashPrportRequestCount = 0;
        } else {
            NSLog(@"splashReport fail!");
            splashPrportRequestCount++;
            if (splashPrportRequestCount < 5) {
                [IOSLoader splashReport];
            }
        }
    }];
    [task resume];
}

+(void)startLoaderLibrary
{
   vigame::CoreManager::init();
   vigame::ad::ADManager::init();
   vigame::tj::DataTJManager::init();
    
   vigame::pay::PayManager::init();
   vigame::XYXManager::getInstance()->init();
//   vigame::push::PushManager::init();
//   vigame::InAppAppraise::startAppraise();

}
+ (void)isAwaken {
    isAwaken = true;
}

#pragma mark - Ad相关接口

+(void)openSplash{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        vigame::ad::ADManager::openAd("splash");
    });
}

+(void)openGame_awaken{
    if(vigame::ad::ADManager::isAdOpened() == false && vigame::ad::ADManager::isAdOpen("game_awaken") == false) {
        vigame::ad::ADManager::openAd("game_awaken");
    }
}

+ (void)isOpenURL {
    isOpenUrl = true;
}

+ (void)openAwakenAd{
    BOOL openInAppStore = [[NSUserDefaults standardUserDefaults] boolForKey:KTMOpenInAppStore];
    if (!isOpenUrl && isAwaken && !openInAppStore) {
        NSLog(@"vigame::ad::ADManager::isAdOpened()=%d vigame::ad::ADManager::isAdOpen("")=%d",vigame::ad::ADManager::isAdOpened(),vigame::ad::ADManager::isAdOpen("game_awaken"));
        if(vigame::ad::ADManager::isAdOpened() == false && vigame::ad::ADManager::isAdOpen("game_awaken") == false) {
            vigame::ad::ADManager::openAd("game_awaken");
        }
    }
    [VBAdUtils setOpenAppStore:NO];
    isOpenUrl = false;
    isAwaken = false;
}

+(void)openBanner{
    vigame::ad::ADManager::openAd("banner");
}

+(void)closeBanner{
    vigame::ad::ADManager::closeAd("banner");
}

+(void)openAd:(NSString *)name{
    std::string adName = [name UTF8String];
    vigame::ad::ADManager::openAd(adName.c_str());
}
+(void)openAd:(NSString *)name callback:(void (^)(BOOL))callback
{
    std::string adName = [name UTF8String];
    vigame::ad::ADManager::openAd(adName,[=](vigame::ad::ADSourceItem* adSourceItem, int result){
        if (result==0)
        {
            /*打开视频成功 发放奖励*/
            callback(true);
        }
        else
        {
            /*打开视频失败 不予发放奖励*/
            callback(false);
        }
    });
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vigame::ad::ADManager::setAdStatusChangedCallback([=](vigame::ad::ADSourceItem* adSourceItem){
            std::string type = adSourceItem->adSourcePlacement->type;
            if (adSourceItem->getStatus() == vigame::ad::ADSourceItem::staus_type::Closed && type == "plaque") {
                callback(false);
            }
        });
    });
}

+ (void)openAd:(NSString *)name adCallback:(void (^)(BOOL flag,KTMADType type))callback {
    std::string adName = [name UTF8String];
    vigame::ad::ADManager::openAd(adName,[=](vigame::ad::ADSourceItem* adSourceItem, int result){
        std::string type = adSourceItem->adSourcePlacement->type;
        if (type == "plaque") {
            return ;
        }
        if (result==0)
        {
            /*打开视频成功 发放奖励*/
            callback(true,KTMADTypeVideo);
        }
        else
        {
            /*打开视频失败 不予发放奖励*/
            callback(false,KTMADTypeVideo);
        }
    });
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vigame::ad::ADManager::setAdStatusChangedCallback([=](vigame::ad::ADSourceItem* adSourceItem){
            std::string type = adSourceItem->adSourcePlacement->type;
            if (adSourceItem->getStatus() == vigame::ad::ADSourceItem::staus_type::Closed && type == "plaque") {
                callback(false,KTMADTypePlaque);
            }
        });
    });
}

+ (void)openYSBanner:(NSString *)adName rect:(CGRect)rect {
    vigame::ad::ADManager::openAd([adName UTF8String], rect.size.width, rect.size.height, rect.origin.x, rect.origin.y);
}

+ (void)closeYSBanner:(NSString *)adName {
    vigame::ad::ADManager::closeAd([adName UTF8String]);
}

+(void)is_Active:(BOOL)a
{
    vigame::ad::ADManagerImpl::getInstance()->setActive(a?1:0);
    if (a) {
        //appflyer激活统计
        vigame::tj::DataTJManagerImplApple *apple = (vigame::tj::DataTJManagerImplApple *)vigame::tj::DataTJManagerImpl::getInstance();
        apple->applicationDidBecomeActive();
    }
    if (a && isFirstLaunch)
    {
        isFirstLaunch = false;
        [IOSLoader openSplash];
    }
}

//广告是否准备好
+ (BOOL)isAdReady:(NSString *)name {
    std::string adName = [name UTF8String];
    bool result = vigame::ad::ADManager::isAdReady(adName.c_str());
    char param[64] = {0};
    if (result)
    {
        sprintf(param, "%s_ready_success",adName.c_str());
    }
    else
    {
        sprintf(param, "%s_ready_fail",adName.c_str());
    }
    printf("%s\n",param);
    return result;
}

#pragma mark - getProjectId
+(NSString *)getProjectId{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"VigameLibrary" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *projectid = [dict objectForKey:@"company_prjid"];
    return projectid;
    
}

#pragma mark - 是否越狱
+ (BOOL)isRoot {
    
    return vigame::SysConfig::getInstance()->isRoot();
}

#pragma mark - 是否审核中
+ (BOOL)isAudit {
   int audit = vigame::MMChnlManager::getInstance()->getMMChnl()->audit;
    if (audit == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - 统计相关接口
+ (void)tj_payWithMoney:(double)money productId:(NSString *)productId number:(int)number price:(double)price {
    std::string productID = [productId UTF8String];
    vigame::tj::DataTJManager::pay(money, productID.c_str(), number, price, 30);
}

//appflyer统计相关
+ (void)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)activity {
    vigame::tj::DataTJManagerImplApple *apple = (vigame::tj::DataTJManagerImplApple *)vigame::tj::DataTJManagerImpl::getInstance();
    apple->applicationContinueUserActivity(application, activity);
    
}

+(void)tj_name:(NSString *)name
{
    std::string eventId = [name UTF8String];
    vigame::tj::DataTJManager::event(eventId.c_str());
}
+(void)tj_name:(NSString *)name value:(NSString *)value
{
    std::string eventId = [name UTF8String];
    std::string label = [value UTF8String];
    vigame::tj::DataTJManager::event(eventId.c_str(),label.c_str());
}

+ (void)setFirstLaunchEventID0:(const char*)eventId0 eventID1:(const char*)eventId1 eventID2:(const char*)eventId2 eventID3:(const char*)eventId3 {
    std::unordered_map<std::string, std::string> attributes;
    
    attributes.insert(std::make_pair(eventId0, "0"));
    attributes.insert(std::make_pair(eventId1, "0"));
    attributes.insert(std::make_pair(eventId2, "0"));
    attributes.insert(std::make_pair(eventId3, "0"));
    vigame::tj::DataTJManager::setFirstLaunchEvent(attributes);
}

+ (void)tj_name:(const char  *)name map:(const char *)json {
    NSString *jsonStr = [NSString stringWithUTF8String:json];
    
    NSDictionary *map = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    NSArray *keyList = [map allKeys];
    std::unordered_map<std::string, std::string> attributes;
    for (NSString *key in keyList) {
        NSString *value = map[key];
        attributes.insert(std::make_pair([key UTF8String], [value UTF8String]));
    }
    vigame::tj::DataTJManager::event(name, attributes);
}

+ (void)isAdBeOpenInLevel:(NSString *)adPostionName level:(int)level{
     std::string adName = [adPostionName UTF8String];
    vigame::ad::ADManager::isAdBeOpenInLevel(adName, level);
}

+ (void)tj_startLevel:(NSString *)level {
    vigame::tj::DataTJManager::startLevel([level UTF8String]);
}

+ (void)tj_finishLevel:(NSString *)level {
     vigame::tj::DataTJManager::finishLevel([level UTF8String]);
}

+ (void)tj_failLevel:(NSString *)level {
    vigame::tj::DataTJManager::failLevel([level UTF8String]);
}

#pragma mark - 支付相关接口
+ (void)textPayWithProductId:(int)productId callBack:(void (^)(NSDictionary *))callback{
    vigame::pay::PayManager::orderPay(productId);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vigame::pay::PayManager::setOnPayFinishCallback([=](vigame::pay::PayParams params){
            NSDictionary *dic = @{
                                  @"payId":[NSNumber numberWithInt:params.getPayId()],
                                  @"reasonCode":[NSNumber numberWithInt:params.getPayResult()],
                                  @"userdata" : [NSString stringWithCString:params.getUserdata().c_str() encoding:NSUTF8StringEncoding] 
                                  };
            callback(dic);
        });
    });
}
// 消耗型商品奖励发放失败恢复
+ (void)payConsumableGoodsRecoveryCallBack:(void (^)(NSDictionary *))callback {
    
    vigame::pay::PayManager::setOnGotInventoryCallback([=](vigame::pay::PayParams params) {
        NSDictionary *dic = @{
                              @"payId":[NSNumber numberWithInt:params.getPayId()],
                              @"reasonCode":[NSNumber numberWithInt:params.getPayResult()],
                              @"payDesc": [NSString stringWithCString:params.getPayDesc().c_str() encoding:NSUTF8StringEncoding],
                              @"tradeId": [NSString stringWithCString:params.getTradeId().c_str() encoding:NSUTF8StringEncoding],
                              @"payPrice":[NSNumber numberWithInt:params.getPayPrice()],
                              @"payUserdata": [NSString stringWithCString:params.getUserdata().c_str() encoding:NSUTF8StringEncoding]
                              };
        callback(dic);
    });
    
}

// 苹果支付 消耗性商品支付完成
+ (void)payConsumableGoodsRecoveryFinish {
    
    id ApplePay = [[NSClassFromString(@"ApplePayAgent") alloc]init];
    SEL s = NSSelectorFromString(@"consumableGoodsRecoveryfinishTransaction");
    IMP imp = [ApplePay methodForSelector:s];
    
    void (*func)(Class, SEL) = (void (*)(Class,SEL))imp;
    func(ApplePay,s);
    
}
//+ (void)wxLogin:(void (^)(KTMLoginState flag, NSString *returnMsg))callback {
//    [[[WXSocialAgent alloc] init] loginResult:^(int state, NSString *msg) {
//        if (callback) {
//            callback((KTMLoginState)state,msg);
//        }
//    }];
//}
//
//+ (void)getWXUserInfo:(void (^)(NSDictionary *))callback {
//    [[[WXSocialAgent alloc] init] getUserInfos:^(BOOL isSuccess, NSString *msg) {
//        if (callback) {
//            NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//            callback(dic);
//        }
//    }];
//}
/**
+(void)didRegisterDeviceToken:(NSData *)data{
    NSObject *obj = NSClassFromString(@"UMPushAgent");
    SEL seletor = NSSelectorFromString(@"registerDeviceToken:");
    IMP imp = [obj methodForSelector:seletor];
    void (*func)(Class, SEL,NSData*) = (void (*)(Class,SEL,NSData*))imp;
    if (!obj || ![obj respondsToSelector:seletor]) { return; }
    func(obj,seletor,data);
}
+(void)didReceiveRemoteNotification:(NSDictionary *)infos{

    NSObject *obj = NSClassFromString(@"UMPushAgent");
    SEL seletor = NSSelectorFromString(@"applicationDidReceiveRemoteNotification:");
    IMP imp = [obj methodForSelector:seletor];
    void (*func)(Class, SEL,NSDictionary*) = (void (*)(Class,SEL,NSDictionary*))imp;
    if (!obj || ![obj respondsToSelector:seletor]) { return; }
    func(obj,seletor,infos);


    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *userInfoKey in [infos allKeys]) {
        if ([userInfoKey isEqualToString:@"aps"]
            ||[userInfoKey isEqualToString:@"d"]
            ||[userInfoKey isEqualToString:@"p"]) {continue;}
        else{  [dict setObject:infos[userInfoKey] forKey:userInfoKey]; }
    }
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"PUSHINFOMATIONS"];
    NSString *str = @"";
    for (int i=0; i<[dict allKeys].count; i++)
    {
        NSString *key = [[dict allKeys] objectAtIndex:i];
        NSString *value = [dict objectForKey:key];
        if (0==i)
        {
            str = [NSString stringWithFormat:@"%@=%@,",key,value];
        }
        else if ([dict allKeys].count-1 == i && [dict allKeys].count>=1)
        {
            str = [NSString stringWithFormat:@"%@%@=%@",str,key,value];
        }
        else
        {
             str = [NSString stringWithFormat:@"%@%@=%@,",str,key,value];
        }
    }


    NSLog(@"%@",str);
    const char * pushInfos = [str UTF8String];

    vigame::push::PushManagerImpl::getInstance()->dealWithCustomAction(pushInfos);
}
*/

#pragma mark - progressWKContentViewCrash
+ (void)progressWKContentViewCrash {
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)) {
        const char *className = @"WKContentView".UTF8String;
        Class WKContentViewClass = objc_getClass(className);
        SEL isSecureTextEntry = NSSelectorFromString(@"isSecureTextEntry");
        SEL secureTextEntry = NSSelectorFromString(@"secureTextEntry");
        BOOL addIsSecureTextEntry = class_addMethod(WKContentViewClass, isSecureTextEntry, (IMP)isSecureTextEntryIMP, "B@:");
        BOOL addSecureTextEntry = class_addMethod(WKContentViewClass, secureTextEntry, (IMP)secureTextEntryIMP, "B@:");
        if (!addIsSecureTextEntry || !addSecureTextEntry) {
            NSLog(@"WKContentView-Crash->修复失败");
        }
    }
}

+ (void)openBrowser {
    vigame::browser::openDialogWeb("https://www.baidu.com","百度");
    //vigame::community::open("123");
    
}

/**
 实现WKContentView对象isSecureTextEntry方法
 @return NO
 */
BOOL isSecureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}

/**
 实现WKContentView对象secureTextEntry方法
 @return NO
 */
BOOL secureTextEntryIMP(id sender, SEL cmd) {
    return NO;
}

@end
