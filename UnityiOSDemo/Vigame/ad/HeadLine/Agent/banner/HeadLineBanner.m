//
//  HeadLineBanner.m
//  VigameDemo
//
//  Created by 动能无限 on 2019/7/4.
//  Copyright © 2019 动能无限. All rights reserved.
//

#import "HeadLineBanner.h"
#import <BUAdSDK/BUAdSDK.h>
#import "VBAdUtils.h"

@interface HeadLineBanner () <BUBannerAdViewDelegate>

@property (nonatomic, copy) void (^loadCallback)(NSDictionary *);

@property (nonatomic, strong) NSDictionary *loadParams;

@property (nonatomic, strong) BUBannerAdView *bannerAdView;

@property (nonatomic, assign) BOOL canOpen;

@property (nonatomic, assign) BOOL isOpen;

@end

static HeadLineBanner *headlinebanner = nil;

@implementation HeadLineBanner

-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.loadCallback = cb;
    self.loadParams = param;
    NSDictionary *dic =@{KTMCallbackADID: self.loadParams[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadSuccess};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
    
}

- (void)openBanner {
    [self vigame_openHeadLineBanner];
}

- (void)closeBanner {
    self.canOpen = NO;
    NSDictionary *dict = @{KTMCallbackADID:self.loadParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.loadCallback) {  self.loadCallback(dict); }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.bannerAdView && self.bannerAdView.superview) {
            [self.bannerAdView removeFromSuperview];
            self.bannerAdView = nil;
        }
    });
}

-(void)vigame_openHeadLineBanner {
    self.canOpen = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [BUAdSDKManager setAppID:self.loadParams[KTMLoadAdAppId]];
        BUSize *size = [BUSize sizeBy:BUProposalSize_Banner600_90];
        self.bannerAdView = [[BUBannerAdView alloc] initWithSlotID:self.loadParams[KTMLoadPlaceCodeId] size:size rootViewController:[VBAdUtils getBannerViewController]];
        [self.bannerAdView loadAdData];
        self.bannerAdView.frame = [VBAdUtils getBannerFrame];
        self.bannerAdView.delegate = self;
    });
    
}

#pragma mark - BUBannerAdViewDelegate
- (void)bannerAdViewDidLoad:(BUBannerAdView * _Nonnull)bannerAdView WithAdmodel:(BUNativeAd *_Nullable)admodel {
    if (self.bannerAdView==nil || self.canOpen==NO) {
        return;
    }
    UIViewController *controller = [VBAdUtils getBannerViewController];
    [controller.view insertSubview:self.bannerAdView atIndex:0];
}

/**
 This method is called when bannerAdView is clicked.
 */
- (void)bannerAdViewDidClick:(BUBannerAdView *)bannerAdView WithAdmodel:(BUNativeAd *_Nullable)nativeAd {
    NSDictionary *dic = @{KTMCallbackADID: self.loadParams[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateAdClicked};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}
/**
 This method is called when bannerAdView ad slot showed new ad.
 */
- (void)bannerAdViewDidBecomVisible:(BUBannerAdView *)bannerAdView WithAdmodel:(BUNativeAd *_Nullable)nativeAd {
    
    NSDictionary *dic = @{KTMCallbackADID: self.loadParams[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateOpenSuccess};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)bannerAdView:(BUBannerAdView *_Nonnull)bannerAdView didLoadFailWithError:(NSError *_Nullable)error {
    NSDictionary *dic = @{KTMCallbackADID: self.loadParams[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadFail};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)bannerAdView:(BUBannerAdView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterwords {
    [self closeBanner];
}
@end
