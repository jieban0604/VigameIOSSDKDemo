//
//  HeadLineSplash.m
//  VigameDemo
//
//  Created by 动能无限 on 2019/7/4.
//  Copyright © 2019 动能无限. All rights reserved.
//

#import "HeadLineSplash.h"
#import "VBAdUtils.h"
#import <BUAdSDK/BUAdSDK.h>

@interface HeadLineSplash () <BUSplashAdDelegate>

@property (nonatomic, copy) void (^loadCallback)(NSDictionary *);

@property (nonatomic, strong) NSDictionary *adParam;

@property (nonatomic, strong) BUSplashAdView *splashAdView;

@property (nonatomic, assign) BOOL isAdClicked;

@end


@implementation HeadLineSplash


-(void)openSplash:(NSDictionary *)param callback:(void (^)(NSDictionary *))callback{
    self.loadCallback = callback;
    self.adParam = param;
    [self vigame_openHeadLineSplash:param];
}

- (void)vigame_openHeadLineSplash:(NSDictionary *)param {
    [BUAdSDKManager setAppID:param[KTMLoadAdAppId]];
    [BUAdSDKManager setIsPaidApp:NO];
    [BUAdSDKManager setLoglevel:BUAdSDKLogLevelDebug];
    
    CGRect frame = [UIScreen mainScreen].bounds;
    BUSplashAdView *splashView = [[BUSplashAdView alloc] initWithSlotID:param[KTMLoadPlaceCodeId] frame:frame];
    
    splashView.delegate = self;
    self.splashAdView = splashView;
    [splashView loadAdData];
    
}

#pragma mark - BUSplashAdDelegate

- (void)splashAdWillVisible:(BUSplashAdView *)splashAd {
    NSDictionary *opendic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateOpenSuccess};
    if (self.loadCallback) {
        self.loadCallback(opendic);
    }
}
- (void)splashAdDidClose:(BUSplashAdView *)splashAd {
    [splashAd removeFromSuperview];
    if (self.isAdClicked) {
        return;
    }
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateCloseSuccess};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)splashAdDidLoad:(BUSplashAdView *)splashAd {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadSuccess};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
    
    UIViewController *vc = [VBAdUtils getUIViewController];
    [vc.view addSubview:self.splashAdView];
    self.splashAdView.rootViewController = vc;
}

- (void)splashAdDidClick:(BUSplashAdView *)splashAd {
    //[VBAdUtils setOpenAppStore:YES];
    self.isAdClicked = YES;
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateAdClicked};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError *)error {
    [splashAd removeFromSuperview];
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadFail};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)splashAdDidCloseOtherController:(BUSplashAdView *)splashAd interactionType:(BUInteractionType)interactionType {
    self.isAdClicked = NO;
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateCloseSuccess};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

@end
