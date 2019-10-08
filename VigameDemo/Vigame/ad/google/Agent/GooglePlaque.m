//
//  GooglePlaque.m
//  Vigame_Test
//
//  Created by DLWX on 2018/10/10.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "GooglePlaque.h"
#import "VBAdUtils.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
@interface GooglePlaque()<GADInterstitialDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property (nonatomic,strong) DFPInterstitial *interstitialAd;

@end
@implementation GooglePlaque
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParams = param;
    [self vigame_loadGoogePlaque:param];
}
-(void)vigame_loadGoogePlaque:(NSDictionary *)param{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.interstitialAd = [self createAndLoadInterstitial];
    });
    
}

-(void)openPlaque:(NSDictionary *)param{
    [self vigame_openGooglePlaque];
}
-(void)vigame_openGooglePlaque{
    if ([self.interstitialAd isReady]) {
        UIViewController * rootViewController = [VBAdUtils getUIViewController];
        [self.interstitialAd presentFromRootViewController:rootViewController];
    }
}

- (DFPInterstitial *)createAndLoadInterstitial {
    
    DFPInterstitial *interstitial =
    [[DFPInterstitial alloc] initWithAdUnitID:self.adParams[KTMLoadPlaceCodeId]];
    interstitial.delegate = self;
    [interstitial loadRequest:[DFPRequest request]];
    return interstitial;
}

#pragma mark - GADInterstitialDelegate
- (void)interstitialDidReceiveAd:(DFPInterstitial *)ad{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
}
- (void)interstitial:(DFPInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}

- (void)interstitialWillPresentScreen:(DFPInterstitial *)ad{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
}

/// Called when |ad| fails to present.
- (void)interstitialDidFailToPresentScreen:(DFPInterstitial *)ad{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
    if (self.callback) {  self.callback(dict); }
}
- (void)interstitialDidDismissScreen:(DFPInterstitial *)ad{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
    
}
- (void)interstitialWillLeaveApplication:(DFPInterstitial *)ad{
    [VBAdUtils setOpenAppStore:YES];
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

@end
