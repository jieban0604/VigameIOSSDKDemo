//
//  GoogleNativePlaque.m
//  NativeTest
//
//  Created by DLWX on 2019/4/17.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "GoogleNativePlaque.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "VBAdUtils.h"
@interface GoogleNativePlaque()<GADAdLoaderDelegate,GADUnifiedNativeAdLoaderDelegate,GADUnifiedNativeAdDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property(nonatomic,strong)GADAdLoader *adLoader;
@property(nonatomic,strong)GADUnifiedNativeAdView *nativeAdView;
@property(nonatomic,strong)UIView *contantView;
@end
@implementation GoogleNativePlaque
//- (instancetype)init{
//    static GoogleNativePlaque * googleAgent = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        googleAgent = [super init];
//    });
//    return googleAgent;
//}
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParams = param;
    [self vigame_loadGoogeNativePlaque:param];
}
-(void)vigame_loadGoogeNativePlaque:(NSDictionary *)param
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [GADMobileAds.sharedInstance startWithCompletionHandler:nil];
        NSArray *nibObjects =
        [[NSBundle mainBundle] loadNibNamed:@"GoogleNativePlaque" owner:nil options:nil];
        self.nativeAdView = [nibObjects firstObject];
        //CGRect bannerFrame = [VBAdUtils getBannerFrame];
        CGRect bannerFrame = CGRectMake(0, 0, 380, 420);
        self.nativeAdView.frame = CGRectMake(0, 0, bannerFrame.size.width*0.8, bannerFrame.size.width*0.9);
        
        UIViewController *vc = [VBAdUtils getUIViewController];
        NSString *code = [self.adParams objectForKey:KTMLoadPlaceCodeId];
        GADMultipleAdsAdLoaderOptions *multipleAdsOptions =
        [[GADMultipleAdsAdLoaderOptions alloc] init];
        multipleAdsOptions.numberOfAds = 1;
        
        self.adLoader = [[GADAdLoader alloc] initWithAdUnitID:code rootViewController:vc adTypes:@[kGADAdLoaderAdTypeUnifiedNative] options:@[multipleAdsOptions]];
        self.adLoader.delegate = self;
        [self.adLoader loadRequest:[GADRequest request]];
    });
}
- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}
- (void)adLoaderDidFinishLoading:(GADAdLoader *)adLoader
{
    
}
- (void)adLoader:(nonnull GADAdLoader *)adLoader didReceiveUnifiedNativeAd:(nonnull GADUnifiedNativeAd *)nativeAd
{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
    nativeAd.delegate = self;
    self.nativeAdView.nativeAd = nativeAd;
    ((UILabel *)self.nativeAdView.headlineView).text = nativeAd.headline;
    ((UILabel *)self.nativeAdView.bodyView).text = nativeAd.body;
    [((UIButton *)self.nativeAdView.callToActionView) setTitle:nativeAd.callToAction forState:0];
    self.nativeAdView.callToActionView.userInteractionEnabled = NO;
    ((UIImageView *)self.nativeAdView.iconView).image =nativeAd.icon.image;
    self.nativeAdView.mediaView.mediaContent = nativeAd.mediaContent;
}

- (void)panGestureRecognizerMethod:(UIGestureRecognizer *)gesture {
    
}

-(void)openPlaque:(NSDictionary *)param{
    [self vigame_openGooglePlaque];
}
-(void)vigame_openGooglePlaque{
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.contantView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UIGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerMethod:)];
    gesture.delegate = self;
    [self.contantView addGestureRecognizer:gesture];
    UIViewController *vc = [VBAdUtils getUIViewController];
    [vc.view addSubview:self.contantView];
    self.contantView.backgroundColor = [UIColor clearColor];
    UIButton *zzBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contantView addSubview:zzBtn];
    zzBtn.frame = CGRectMake(0, 0, size.width, size.height);
    zzBtn.backgroundColor = [UIColor blackColor];
    zzBtn.alpha = 0.5;
    [zzBtn addTarget:self action:@selector(zzBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contantView addSubview:self.nativeAdView];
    self.nativeAdView.center = self.contantView.center;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contantView addSubview:closeBtn];
    [closeBtn setImage:[UIImage imageNamed:@"gdt_bnclose.png"] forState:0];
    float left = size.width * 0.9 - 35;
    float top = size.height - (size.height - size.width*0.9)/2 -35;
    closeBtn.frame = CGRectMake(left, top, 35, 35);
    [closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)zzBtnClicked
{
    NSLog(@"clicked on zzButton");
}
-(void)closeBtnClicked
{
    if(self.contantView)
    {
        NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
        if (self.callback) {  self.callback(dict); }
        [self.contantView removeFromSuperview];
    }
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
    return YES;
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
