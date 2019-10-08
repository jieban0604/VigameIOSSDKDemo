//
//  HeadLineNativeExpressPlaque.m
//  VigameDemo
//
//  Created by 动能无限 on 2019/7/15.
//  Copyright © 2019 动能无限. All rights reserved.
//

#import "HeadLineNativeExpressPlaque.h"

#import "VBAdUtils.h"
#import <BUAdSDK/BUAdSDK.h>

@interface HeadLineNativeExpressPlaque () <BUNativeExpresInterstitialAdDelegate>

@property (nonatomic, strong) NSDictionary *adParam;
@property (nonatomic, copy) void (^callback)(NSDictionary *);
@property (nonatomic, strong) BUNativeExpressInterstitialAd *interstitialAd;
@end

@implementation HeadLineNativeExpressPlaque

-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParam = param;
    dispatch_async(dispatch_get_main_queue(), ^{
        [BUAdSDKManager setAppID:param[KTMLoadAdAppId]];
        self.interstitialAd = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:param[KTMLoadPlaceCodeId] imgSize:[BUSize sizeBy:BUProposalSize_Interstitial600_600] adSize:CGSizeMake(300, 450)];
        self.interstitialAd.delegate = self;
        [self.interstitialAd loadAdData];
    });
}

-(void)openPlaque:(NSDictionary *)param{
    [self vigame_openHeadLineNativeExpressPlaque];
}



-(void)vigame_openHeadLineNativeExpressPlaque {
    if (self.interstitialAd.isAdValid) {
        [self.interstitialAd showAdFromRootViewController:[VBAdUtils getUIViewController]];
    }
}

#pragma ---BUNativeExpresInterstitialAdDelegate

- (void)nativeExpresInterstitialAdDidLoad:(BUNativeExpressInterstitialAd *)interstitialAd {

    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadSuccess};
    if (self.callback) {
        self.callback(dic);
    }
}

- (void)nativeExpresInterstitialAd:(BUNativeExpressInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadFail};
    if (self.callback) {
        self.callback(dic);
    }
}

- (void)nativeExpresInterstitialAdRenderSuccess:(BUNativeExpressInterstitialAd *)interstitialAd {
    
}

- (void)nativeExpresInterstitialAdRenderFail:(BUNativeExpressInterstitialAd *)interstitialAd error:(NSError *)error {
    
}

- (void)nativeExpresInterstitialAdWillVisible:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateOpenSuccess};
    if (self.callback) {
        self.callback(dic);
    }
}

- (void)nativeExpresInterstitialAdDidClick:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateAdClicked};
    if (self.callback) {
        self.callback(dic);
    }
}

- (void)nativeExpresInterstitialAdWillClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    
}

- (void)nativeExpresInterstitialAdDidClose:(BUNativeExpressInterstitialAd *)interstitialAd {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateAdClosed};
    if (self.callback) {
        self.callback(dic);
    }
    //[self.interstitialAd loadAdData];
}
@end
