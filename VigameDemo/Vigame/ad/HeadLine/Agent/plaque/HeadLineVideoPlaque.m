//
//  HeadLineVideoPlaque.m
//  VigameDemo
//
//  Created by 动能无限 on 2019/7/4.
//  Copyright © 2019 动能无限. All rights reserved.
//

#import "HeadLineVideoPlaque.h"
#import "VBAdUtils.h"
#import <BUAdSDK/BUAdSDK.h>

@interface HeadLineVideoPlaque () <BUFullscreenVideoAdDelegate>

@property (nonatomic, strong) BUFullscreenVideoAd *fullscreenVideoAd;

@property (nonatomic, copy) void (^callback)(NSDictionary *);

@property (nonatomic, strong) NSDictionary *adParam;
@end

@implementation HeadLineVideoPlaque

-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParam = param;
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [BUAdSDKManager setAppID:param[KTMLoadAdAppId]];
        [BUAdSDKManager setIsPaidApp:NO];
        [BUAdSDKManager setLoglevel:BUAdSDKLogLevelDebug];
        
        self.fullscreenVideoAd = [[BUFullscreenVideoAd alloc] initWithSlotID:param[KTMLoadPlaceCodeId]];
        self.fullscreenVideoAd.delegate = self;
        [self.fullscreenVideoAd loadAdData];
    });
    
}
-(void)openPlaque:(NSDictionary *)param{
    [self vigame_openHeadLineVideoPlaque];
}
-(void)vigame_openHeadLineVideoPlaque{
    if (self.fullscreenVideoAd) {
        [self.fullscreenVideoAd showAdFromRootViewController:[VBAdUtils getUIViewController]];
    }
}

#pragma mark BURewardedVideoAdDelegate

- (void)fullscreenVideoMaterialMetaAdDidLoad:(BUFullscreenVideoAd *)fullscreenVideoAd {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadSuccess
                          };
    if (self.callback) {
        self.callback(dic);
    }
}

- (void)fullscreenVideoAd:(BUFullscreenVideoAd *)fullscreenVideoAd didFailWithError:(NSError *)error {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadFail
                          };
    if (self.callback) {
        self.callback(dic);
    }
}

/* 广告位即将展示 */
- (void)fullscreenVideoAdWillVisible:(BUFullscreenVideoAd *)fullscreenVideoAd{
    NSDictionary *dict = @{KTMCallbackADID:self.adParam[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
}

/* 视频广告关闭 */
- (void)fullscreenVideoAdDidClose:(BUFullscreenVideoAd *)fullscreenVideoAd{
    NSDictionary *dict = @{KTMCallbackADID:self.adParam[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
    [self.fullscreenVideoAd loadAdData];
}

/* 视频广告点击下载 */
- (void)fullscreenVideoAdDidClick:(BUFullscreenVideoAd *)fullscreenVideoAd
{
    NSDictionary *dict = @{KTMCallbackADID:self.adParam[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

- (void)fullscreenVideoAdDidClickSkip:(BUFullscreenVideoAd *)fullscreenVideoAd {
//    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadSuccess
//                          };
//    if (self.callback) {
//        self.callback(dic);
//    }
}
@end
