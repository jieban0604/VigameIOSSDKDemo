//
//  HeadLineNativeExpressBanner.m
//  VigameDemo
//
//  Created by 动能无限 on 2019/7/15.
//  Copyright © 2019 动能无限. All rights reserved.
//

#import "HeadLineNativeExpressBanner.h"

#import "VBAdUtils.h"
#import <BUAdSDK/BUAdSDK.h>

@interface HeadLineNativeExpressBanner () <BUNativeExpressBannerViewDelegate>
@property (nonatomic, strong) NSDictionary *adParam;
@property (nonatomic, copy) void (^callback)(NSDictionary *);
@property (nonatomic, strong) BUNativeExpressBannerView *bannerView;
@property (nonatomic, assign)BOOL canOpen;
@end

@implementation HeadLineNativeExpressBanner

-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParam = param;
    NSDictionary *dic =@{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadSuccess};
    if (self.callback) {
        self.callback(dic);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [BUAdSDKManager setAppID:param[KTMLoadAdAppId]];
    });
}

- (void)openBanner {
    [self vigame_openHeadLineNativeExpressBanner];
}

- (void)closeBanner {
    self.canOpen = NO;
    if (self.bannerView == nil) {
        return;
    }
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateCloseSuccess};
    if (self.callback) {
        self.callback(dic);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.bannerView && self.bannerView.superview) {
            [self.bannerView removeFromSuperview];
            self.bannerView = nil;
        }
    });
}

-(void)vigame_openHeadLineNativeExpressBanner {
    self.canOpen = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.bannerView == nil) {
            CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
            CGFloat bannerHeigh = screenWidth/600*90;
            BUSize *imgSize = [BUSize sizeBy:BUProposalSize_Banner600_150];
            UIViewController *controller = [VBAdUtils getBannerViewController];
            self.bannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:self.adParam[KTMLoadPlaceCodeId] rootViewController:controller imgSize:imgSize adSize:CGSizeMake(screenWidth, bannerHeigh) IsSupportDeepLink:YES];
              self.bannerView.frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-bannerHeigh, screenWidth, bannerHeigh);
            self.bannerView.delegate = self;
        }
        [self.bannerView loadAdData];
    });
}

#pragma mark - BUNativeExpressBannerViewDelegate

- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView {
    
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *)error {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadFail};
    if (self.callback) {
        self.callback(dic);
    }
}

- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView {
    if (!self.canOpen) {
        return;
    }
    UIViewController *rootViewController = [VBAdUtils getBannerViewController];
    [rootViewController.view insertSubview:bannerAdView atIndex:0];
}

- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError *)error {
    
}

- (void)nativeExpressBannerAdViewWillBecomVisible:(BUNativeExpressBannerView *)bannerAdView {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateOpenSuccess};
    if (self.callback) {
        self.callback(dic);
    }
}

- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateAdClicked};
    if (self.callback) {
        self.callback(dic);
    }
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *)filterwords {
   
    [UIView animateWithDuration:0.25 animations:^{
        bannerAdView.alpha = 0;
    } completion:^(BOOL finished) {
        [bannerAdView removeFromSuperview];
        if (self.bannerView == bannerAdView) {
            self.bannerView = nil;
        }
       
    }];
}

@end
