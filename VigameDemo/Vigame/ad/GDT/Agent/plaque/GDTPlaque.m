//
//  GDTPlaque.m
//  Vigame_Test
//
//  Created by DLWX on 2018/10/10.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "GDTPlaque.h"
#import "VBAdUtils.h"
#import "GDTMobInterstitial.h"
@interface GDTPlaque()<GDTMobInterstitialDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property (nonatomic,retain)GDTMobInterstitial *interstitial;
@end
@implementation GDTPlaque
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParams = param;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.interstitial = [[GDTMobInterstitial alloc]initWithAppId:param[KTMLoadAdAppId] placementId:param[KTMLoadPlaceCodeId]];
        self.interstitial.delegate = self; //设置委托
        self.interstitial.isGpsOn = NO; //【可选】设置GPS开关
        [self.interstitial loadAd];
    });
}
-(void)openPlaque:(NSDictionary *)dict{
    [self vigame_openGDTPlaque];
}
-(void)vigame_openGDTPlaque{
    if (self.interstitial && [self.interstitial isReady]) {
        UIViewController * currentVc = [VBAdUtils getUIViewController];
        [self.interstitial presentFromRootViewController:currentVc];
    } else {
        NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
        if (self.callback) {  self.callback(dict); }
    }
}

- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial{
    self.interstitial = interstitial;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
}

- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}

- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
}

- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)interstitial{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
}

- (void)interstitialClicked:(GDTMobInterstitial *)interstitial{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}
@end
