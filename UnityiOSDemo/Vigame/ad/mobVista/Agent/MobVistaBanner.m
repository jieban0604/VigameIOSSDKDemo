//
//  MobVistaBanner.m
//  NativeTest
//
//  Created by 动能无限 on 2019/9/17.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "MobVistaBanner.h"
#import <MTGSDK/MTGSDK.h>
#import <MTGSDKBanner/MTGBannerAdView.h>
#import <MTGSDKBanner/MTGBannerAdViewDelegate.h>
#import "VBAdUtils.h"

@interface MobVistaBanner () <MTGBannerAdViewDelegate>

@property (nonatomic, copy) void (^loadCallback)(NSDictionary *);

@property (nonatomic, strong) NSDictionary *loadParams;

@property (nonatomic, strong) MTGBannerAdView *bannerAdView;

@property (nonatomic, assign) BOOL canOpen;

@end

@implementation MobVistaBanner

-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.loadCallback = cb;
    self.loadParams = param;
    NSDictionary *dic =@{KTMCallbackADID: self.loadParams[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadSuccess};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)openBanner {
    [self vigame_openMobVistaBanner];
}

- (void)closeBanner {
    self.canOpen = NO;
    NSDictionary *dict = @{KTMCallbackADID:self.loadParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.loadCallback) {  self.loadCallback(dict); }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.bannerAdView destroyBannerAdView];
    });
}

-(void)vigame_openMobVistaBanner {
    self.canOpen = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
        });
        [[MTGSDK sharedInstance] setAppID:self.loadParams[KTMLoadAdAppId] ApiKey:self.loadParams[@"app_key"]];
        UIViewController *viewController = [VBAdUtils getBannerViewController];
       
        self.bannerAdView  = [[MTGBannerAdView alloc] initBannerAdViewWithBannerSizeType:[VBAdUtils isIPad]?MTGLargeBannerType320x90:MTGStandardBannerType320x50 unitId:self.loadParams[KTMLoadPlaceCodeId] rootViewController:viewController];
        self.bannerAdView.autoRefreshTime = 0;//Automatic refresh time, in seconds, is set in the range of 10s~180s.If set to 0, it will not be automatically refreshed.
        //CGRect rect = [VBAdUtils getBannerFrame];
        CGRect rect = [[UIScreen mainScreen] bounds];
        self.bannerAdView.center = CGPointMake(viewController.view.center.x, rect.size.height-self.bannerAdView.frame.size.height/2);
        self.bannerAdView.showCloseButton = MTGBoolYes;
        self.bannerAdView.delegate = self;
        
        [self.bannerAdView loadBannerAd];
    });
    
}

#pragma mark - MTGBannerAdViewDelegate

- (void)adViewLoadSuccess:(MTGBannerAdView *)adView {
    if (self.bannerAdView==nil || self.canOpen==NO) {
        return;
    }
    UIViewController *viewController = [VBAdUtils getBannerViewController];
    [viewController.view addSubview:self.bannerAdView];
}

- (void)adViewLoadFailedWithError:(NSError *)error adView:(MTGBannerAdView *)adView {
    NSDictionary *dic = @{KTMCallbackADID: self.loadParams[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadFail};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)adViewDidClicked:(MTGBannerAdView *)adView {
    //This method is called when ad is clicked.
    NSDictionary *dic = @{KTMCallbackADID: self.loadParams[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateAdClicked};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)adViewCloseFullScreen:(MTGBannerAdView *)adView {
    //Would close the full screen view.Sent when closing storekit or closing the webpage in app.
}

- (void)adViewWillOpenFullScreen:(MTGBannerAdView *)adView
{
    //Would open the full screen view.Sent when openning storekit or openning the webpage in app.
}

- (void)adViewShowFailedWithError:(NSError *)error adView:(MTGBannerAdView *)adView {
    NSDictionary *dic = @{KTMCallbackADID: self.loadParams[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadFail};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)adViewShowSuccess:(MTGBannerAdView *)adView {
    NSDictionary *dic = @{KTMCallbackADID: self.loadParams[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateOpenSuccess};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)adViewWillLeaveApplication:(MTGBannerAdView *)adView {
    NSDictionary *dic = @{KTMCallbackADID: self.loadParams[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateAdClicked};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

@end
