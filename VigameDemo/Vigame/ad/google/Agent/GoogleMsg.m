//
//  GoogleMsg.m
//  NativeTest
//
//  Created by DLWX on 2019/6/15.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "GoogleMsg.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "VBAdUtils.h"
@interface GoogleMsg()<GADAdLoaderDelegate,GADUnifiedNativeAdLoaderDelegate,GADUnifiedNativeAdDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property(nonatomic,strong)GADAdLoader *adLoader;
@property(nonatomic,strong)UIView *bannerView;
@property(nonatomic,strong)GADUnifiedNativeAdView *nativeAdView;
@property(strong)NSDictionary *bannerParams;
@property(nonatomic,strong)GADUnifiedNativeAd *nativeAd;


@end
@implementation GoogleMsg
-(void)loadWithParam:(NSDictionary *)params callback:(void(^)(NSDictionary *))callback{
    self.callback = callback;
    self.adParams = params;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *vc = [VBAdUtils getBannerViewController];
        NSString *code = [params objectForKey:KTMLoadPlaceCodeId];
        GADMultipleAdsAdLoaderOptions *multipleAdsOptions =
        [[GADMultipleAdsAdLoaderOptions alloc] init];
        multipleAdsOptions.numberOfAds = 1;
        self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:code rootViewController:vc adTypes:@[kGADAdLoaderAdTypeUnifiedNative] options:@[multipleAdsOptions]];
        self.adLoader.delegate = self;
        [self.adLoader loadRequest:[GADRequest request]];
    });
    
}
- (void)adLoader:(nonnull GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(nonnull GADUnifiedNativeAd *)nativeAd {
    self.nativeAd = nativeAd;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
}
- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}

-(void)closeMsg{
    if (self.bannerView && self.bannerView.superview)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
            if (self.callback) {  self.callback(dict); }
            [self.bannerView removeFromSuperview];
        });
    }
}

-(void)openMsgParams:(NSDictionary *)bInfos
{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
    NSArray *nibObjects =
    [[NSBundle mainBundle] loadNibNamed:@"GoogleNativeBanner2" owner:nil options:nil];
    self.nativeAdView = [nibObjects firstObject];
    
    int x = [[bInfos objectForKey:@"x"] intValue];
    int y = [[bInfos objectForKey:@"y"] intValue];
    int width = [[bInfos objectForKey:@"width"] intValue];
    int height = [[bInfos objectForKey:@"height"] intValue];
    self.nativeAdView.frame = CGRectMake(8, 8, width,height);
    self.bannerView = [[UIView alloc]initWithFrame:CGRectMake(x-8, y-8, width+8, height+8)];
    
    
    self.nativeAd.delegate = self;
    self.nativeAdView.nativeAd = self.nativeAd;
    //    ((UILabel *)self.nativeAdView.headlineView).text = self.nativeAd.headline;
    self.nativeAdView.callToActionView.userInteractionEnabled = NO;
    self.nativeAdView.mediaView.mediaContent = self.nativeAd.mediaContent;
    [self.bannerView addSubview:self.nativeAdView];
    UIViewController *vc = [VBAdUtils getBannerViewController];
    //[vc.view addSubview:self.bannerView];
    [vc.view insertSubview:self.bannerView atIndex:0];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bannerView addSubview:closeBtn];
    [closeBtn setImage:[UIImage imageNamed:@"gdt_bnclose.png"] forState:0];
    closeBtn.frame = CGRectMake(0, 0, 25, 25);
    [closeBtn addTarget:self action:@selector(closeMsg) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)nativeAdDidRecordClick:(GADUnifiedNativeAd *)nativeAd{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

@end
