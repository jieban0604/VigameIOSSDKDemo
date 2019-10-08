//
//  GoogleNativeBanner.m
//  NativeTest
//
//  Created by DLWX on 2019/4/15.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "GoogleNativeBanner.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "VBAdUtils.h"
@interface GoogleNativeBanner()<GADAdLoaderDelegate,GADUnifiedNativeAdLoaderDelegate,GADUnifiedNativeAdDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property(nonatomic,strong)GADAdLoader *adLoader;
@property(nonatomic,strong)UIView *bannerView;
@property(nonatomic,strong)GADUnifiedNativeAdView *nativeAdView;
@property(strong)NSDictionary *bannerParams;

@property (nonatomic, assign) BOOL canOpen;

@end

@implementation GoogleNativeBanner
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParams = param;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
    dispatch_async(dispatch_get_main_queue(), ^{
        //[GADMobileAds.sharedInstance startWithCompletionHandler:nil];
    });
}
-(void)openBanner{
    self.canOpen = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *vc = [VBAdUtils getBannerViewController];
        NSString *code = [self.adParams objectForKey:KTMLoadPlaceCodeId];
        GADMultipleAdsAdLoaderOptions *multipleAdsOptions =
        [[GADMultipleAdsAdLoaderOptions alloc] init];
        multipleAdsOptions.numberOfAds = 1;
        
        self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:code rootViewController:vc adTypes:@[kGADAdLoaderAdTypeUnifiedNative] options:@[multipleAdsOptions]];
        self.adLoader.delegate = self;
        [self.adLoader loadRequest:[GADRequest request]];
    });
}

-(void)closeBanner{
    self.canOpen = NO;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.bannerView && self.bannerView.superview)
        {
            [self.bannerView removeFromSuperview];
        }
    });
   
}

- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}
- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader
{
    
}
- (void)adLoader:(nonnull GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(nonnull GADUnifiedNativeAd *)nativeAd {
    nativeAd.delegate = self;
    if (!self.canOpen) {
        return;
    }
    NSArray *nibObjects =
    [[NSBundle mainBundle] loadNibNamed:@"GoogleNativeBanner" owner:nil options:nil];
    self.nativeAdView = [nibObjects firstObject];
    CGRect bannerFrame = [VBAdUtils getBannerFrame];
    self.nativeAdView.frame = CGRectMake(0, 0, bannerFrame.size.width, bannerFrame.size.height);
    self.bannerView = [[UIView alloc]initWithFrame:bannerFrame];
    self.bannerView.backgroundColor = [UIColor redColor];
    UIViewController *vc = [VBAdUtils getBannerViewController];
    //[vc.view addSubview:self.bannerView];
    [vc.view insertSubview:self.bannerView atIndex:0];
    self.nativeAdView.nativeAd = nativeAd;
    [self.bannerView addSubview:self.nativeAdView];
    
    ((UILabel *)self.nativeAdView.headlineView).text = nativeAd.headline;
    ((UILabel *)self.nativeAdView.bodyView).text = nativeAd.body;
    
    ((UIImageView *)self.nativeAdView.iconView).image =nativeAd.icon.image;
    
    [((UIButton *)self.nativeAdView.callToActionView) setTitle:nativeAd.callToAction
                                                      forState:UIControlStateNormal];
    self.nativeAdView.callToActionView.userInteractionEnabled = NO;
}

#pragma mark GADVideoControllerDelegate implementation

- (void)videoControllerDidEndVideoPlayback:(GADVideoController *)videoController {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark GADUnifiedNativeAdDelegate

- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd {
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

- (void)nativeAdDidRecordImpression:(GADUnifiedNativeAd *)nativeAd {
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
}

- (void)nativeAdWillPresentScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdDidDismissScreen:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)nativeAdWillLeaveApplication:(GADUnifiedNativeAd *)nativeAd {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}
@end
