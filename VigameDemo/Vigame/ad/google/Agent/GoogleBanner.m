//
//  GoogleBanner.m
//  Vigame_Test
//
//  Created by DLWX on 2018/9/27.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "GoogleBanner.h"
#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "VBAdUtils.h"
@interface GoogleBanner ()<GADBannerViewDelegate>

@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic, strong) DFPBannerView *bannerView;
@property (nonatomic,strong)NSDictionary *adParams;
@property (nonatomic,assign)BOOL canOpen;

@end

@implementation GoogleBanner
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    NSLog(@"%@",param);
    self.adParams = param;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
}
-(void)openBanner{
    [self vigame_openGoogleBanner];
}
-(void)vigame_openGoogleBanner{
    self.canOpen = true;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.bannerView = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        UIViewController *vc = [VBAdUtils getBannerViewController];
        self.bannerView.adUnitID = self.adParams[KTMLoadPlaceCodeId];
        self.bannerView.rootViewController = vc;
        self.bannerView.delegate = self;
        [self addBannerViewToViewController];
        [self.bannerView loadRequest:[DFPRequest request]];
    });
}
- (void)addBannerViewToViewController {
    self.bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    UIViewController *vc = [VBAdUtils getBannerViewController];
    [vc.view insertSubview:self.bannerView atIndex:0];
    [vc.view addConstraints:@[
                              [NSLayoutConstraint constraintWithItem:self.bannerView
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:vc.bottomLayoutGuide
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1
                                                            constant:0],
                              [NSLayoutConstraint constraintWithItem:self.bannerView
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:vc.view
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1
                                                            constant:0]
                              ]];
}
-(void)closeBanner{
    [self vigame_closeGoogleBanner];
}
-(void)vigame_closeGoogleBanner{
    self.canOpen = false;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.bannerView)
        {
            [self.bannerView removeFromSuperview];
        }
    });
}


#pragma  mark - banner delegate
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    if (self.canOpen == false) return;
    [self addBannerViewToViewController];
}
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"adView:didFailToReceiveAdWithError: %@", error.localizedDescription);
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}
- (void)adViewWillPresentScreen:(GADBannerView *)bannerView{}
- (void)adViewDidDismissScreen:(GADBannerView *)bannerView{
    
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
}

@end



