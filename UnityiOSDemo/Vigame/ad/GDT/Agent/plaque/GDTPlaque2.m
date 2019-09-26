//
//  GDTPlaque2.m
//  NativeTest
//
//  Created by DLWX on 2019/5/13.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "GDTPlaque2.h"
#import "VBAdUtils.h"
#import "GDTUnifiedInterstitialAd.h"
@interface GDTPlaque2() <GDTUnifiedInterstitialAdDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property (nonatomic, strong) GDTUnifiedInterstitialAd *interstitialAd;
@end

@implementation GDTPlaque2
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb
{
    self.callback = cb;
    self.adParams = param;
    NSString *appid = param[KTMLoadAdAppId];
    NSString *code = param[KTMLoadPlaceCodeId];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.interstitialAd = [[GDTUnifiedInterstitialAd alloc] initWithAppId:appid placementId:code];
        self.interstitialAd.delegate = self;
        [self.interstitialAd loadAd];
    });
}
-(void)openPlaque:(NSDictionary *)dict{
    [self vigame_openGDTPlaque];
}
-(void)vigame_openGDTPlaque{
    UIViewController *vc = [VBAdUtils getUIViewController];
    [self.interstitialAd presentAdFromRootViewController:vc];
}

/**
 *  插屏2.0广告预加载成功回调
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedInterstitialSuccessToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
}

/**
 *  插屏2.0广告预加载失败回调
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error
{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}

/**
 *  插屏2.0广告将要展示回调
 *  插屏2.0广告即将展示回调该函数
 */
- (void)unifiedInterstitialWillPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial{}

/**
 *  插屏2.0广告视图展示失败回调
 *  插屏2.0广告展示失败回调该函数
 */
- (void)unifiedInterstitialFailToPresent:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
    if (self.callback) {  self.callback(dict); }
}


/**
 *  插屏2.0广告视图展示成功回调
 *  插屏2.0广告展示成功回调该函数
 */
- (void)unifiedInterstitialDidPresentScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
}

/**
 *  插屏2.0广告展示结束回调
 *  插屏2.0广告展示结束回调该函数
 */
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
}

/**
 *  插屏2.0广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}


@end
