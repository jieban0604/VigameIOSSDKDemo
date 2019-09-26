//
//  IOSLoader.h
//  Vigame_Test
//
//  Created by DLWX on 2018/9/14.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KTMLoginState) {
    KTMLoginStateSuccess = 1,
    KTMLoginStateFail = 0,
    KTMLoginStateCancel = 2
};

typedef NS_ENUM(NSInteger, KTMADType) {
    KTMADTypePlaque = 0,
    KTMADTypeVideo
};

@interface IOSLoader : NSObject

/**
 开屏上报
 这个方法应该再 willFinishLaunching方法中调用
 */
+ (void)splashReport;
/**
 初始化广告统计等
 */
+ (void)startLoaderLibrary;

#pragma mark - Ad
/**
 打开开屏广告
 */
+ (void)openSplash;
/**
 打开/关闭banner广告
 */
+ (void)openBanner;
+ (void)closeBanner;
+ (void)openYSBanner:(NSString *)adName rect:(CGRect)rect;
+ (void)closeYSBanner:(NSString *)adName;
/**
 设置唤醒广告状态
 */
+ (void)isAwaken;
/**
 打开广告位为name的广告
 @param name 广告位
 */
+ (void)openAd:(NSString *)name;
/**
 打开广告位为name的广告，并回调结果
  @param name 广告位 callback
 */
+ (void)openAd:(NSString *)name callback:(void (^)(BOOL))callback;
+ (void)openAd:(NSString *)name adCallback:(void (^)(BOOL flag,KTMADType type))callback;

/**
 设置是否激活
 */
+ (void)is_Active:(BOOL)a;

/**
 设置是否激活
 */
+ (void)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)activity;

/**
 -(BOOL)application:openURL:中调用，解决支付频繁出发唤醒广告
 */
+ (void)isOpenURL;//解决第三方登录、充值调起

/**
- (void)applicationWillEnterForeground:(UIApplication *)application中调用，打开唤醒广告
 */
+ (void)openAwakenAd;

/**
 广告是否准备好，在调用openAd前先调用
 */
+ (BOOL)isAdReady:(NSString *)name;//广告是否准备好

#pragma mark - getProjectId
/**
 获取项目ID
 */
+ (NSString *)getProjectId;

#pragma mark - 是否审核中
+ (BOOL)isAudit;

#pragma mark - 是否越狱
+ (BOOL)isRoot;

#pragma mark - 处理WKContentView的crash
/**
 处理WKContentView的crash
 -[WKContentView isSecureTextEntry]: unrecognized selector sent to instance 0x110977800
 */
+ (void)progressWKContentViewCrash;


#pragma mark - 统计相关接口
+ (void)setFirstLaunchEventID0:(const char*)eventId0 eventID1:(const char*)eventId1 eventID2:(const char*)eventId2 eventID3:(const char*)eventId3;

+ (void)tj_name:(NSString *)name;
+  (void)tj_name:(NSString *)name value:(NSString *)value;
+ (void)tj_name:(const char  *)name map:(const char *)json;

+ (void)isAdBeOpenInLevel:(NSString *)adPostionName level:(int)level;

//关卡统计相关接口
+ (void)tj_startLevel:(NSString *)level;
+ (void)tj_finishLevel:(NSString *)level;
+ (void)tj_failLevel:(NSString *)level;

//充值统计
+ (void)tj_payWithMoney:(double)money productId:(NSString *)productId number:(int)number price:(double)price;


 //充值接口
+ (void)textPayWithProductId:(int)productId callBack:(void (^)(NSDictionary *))callback;

/**
//推送相关的内容
//+(void)didRegisterDeviceToken:(NSData *)data;
//+(void)didReceiveRemoteNotification:(NSDictionary *)infos;
 */
/**
//微信登录相关
+ (void)wxLogin:(void(^)(KTMLoginState code, NSString *returnMsg))callback;
+ (void)getWXUserInfo:(void (^)(NSDictionary *userinfo))callback;
 */
@end
