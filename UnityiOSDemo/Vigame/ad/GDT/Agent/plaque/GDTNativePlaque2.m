//
//  GDTNativePlaque2.m
//  NativeTest
//
//  Created by DLWX on 2019/5/14.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "GDTNativePlaque2.h"
#import "VBAdUtils.h"
#include <UIKit/UIKit.h>
#import "GDTUnifiedNativeAd.h"
#import "GDTUnifiedNativeAdView.h"
@interface GDTNativePlaque2()<GDTUnifiedNativeAdDelegate,GDTUnifiedNativeAdViewDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property (nonatomic, strong) GDTUnifiedNativeAd *unifiedNativeAd;
@property(strong) GDTUnifiedNativeAdView *interstitialAd;
@property (nonatomic, strong) NSArray *dataArray;
@property(strong) GDTUnifiedNativeAdDataObject *adData;
@property(nonatomic,strong)UIView *contentView;
@end
@implementation GDTNativePlaque2
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.callback = cb;
        self.adParams = param;
        NSString *appid = self.adParams[KTMLoadAdAppId];
        NSString *code = self.adParams[KTMLoadPlaceCodeId];
        self.unifiedNativeAd = [[GDTUnifiedNativeAd alloc] initWithAppId:appid placementId:code];
        self.unifiedNativeAd.delegate = self;
        [self.unifiedNativeAd loadAd];
    });
}
-(void)openPlaque:(NSDictionary *)dict{
    [self vigame_openGDTNativePlaque];
}
-(void)vigame_openGDTNativePlaque{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,size.width, size.height)];
    UIViewController *vc = [VBAdUtils getUIViewController];
    
    [vc.view addSubview:self.contentView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:button];
    [button setFrame:CGRectMake(0, 0, size.width, size.height)];
    [button addTarget:self action:@selector(zzButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor blackColor];
    button.alpha = 0.5;
    
    CGRect rect = CGRectMake(0, 0, size.width*0.8, size.width*0.8);
    GDTUnifiedNativeAdView *unifiedNativeAdView = [[GDTUnifiedNativeAdView alloc] initWithFrame:rect];
    unifiedNativeAdView.backgroundColor = [UIColor whiteColor];
    unifiedNativeAdView.delegate = self;
    self.interstitialAd = unifiedNativeAdView;
    self.interstitialAd.viewController = vc;
    self.interstitialAd.center = CGPointMake(size.width/2.0, size.height/2.0);
    [self.contentView addSubview:self.interstitialAd];
    
    /*广告Icon*/
    UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    NSURL *iconURL = [NSURL URLWithString:self.adData.iconUrl];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            iconV.image = [UIImage imageWithData:iconData];
        });
    });
    [unifiedNativeAdView addSubview:iconV];
    
    
    /*广告标题*/
    UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(80, 0,  rect.size.width-100, 80)];
    txt.text = self.adData.title;
    txt.font = [UIFont systemFontOfSize:18];
    txt.textAlignment = NSTextAlignmentCenter;
    [unifiedNativeAdView addSubview:txt];
    
    /*广告描述*/
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, rect.size.width-10, 13)];
    desc.text = self.adData.desc;
    desc.font = [UIFont systemFontOfSize:13];
    [unifiedNativeAdView addSubview:desc];
    
    /*广告详情图*/
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 103, size.width*0.8, size.width*0.8-103)];
    [unifiedNativeAdView addSubview:imgV];
    NSURL *imageURL = [NSURL URLWithString:self.adData.imageUrl];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            imgV.image = [UIImage imageWithData:imageData];
        });
    });
    
    GDTLogoView *logoView = [[GDTLogoView alloc] init];
    logoView.frame = CGRectMake(size.width*0.8-kGDTLogoImageViewDefaultWidth, size.width*0.8-kGDTLogoImageViewDefaultHeight, kGDTLogoImageViewDefaultWidth, kGDTLogoImageViewDefaultHeight);
    [unifiedNativeAdView addSubview:logoView];
    
    [unifiedNativeAdView registerDataObject:self.adData clickableViews:@[imgV,iconV,logoView,txt,desc]];

    [unifiedNativeAdView setViewController:vc];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [unifiedNativeAdView addSubview:closeBtn];
    [closeBtn setImage:[UIImage imageNamed:@"gdt_bnclose"] forState:0];
    closeBtn.frame = CGRectMake(size.width*0.8-30, 5, 25, 25);
    [closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}
-(void)closeBtnClicked
{
    if (self.contentView && self.contentView.superview) {
        NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
        if (self.callback) {  self.callback(dict); }
        self.interstitialAd.delegate = nil;
        self.interstitialAd = nil;
        self.unifiedNativeAd.delegate = nil;
        self.unifiedNativeAd = nil;
        [self.contentView removeFromSuperview];
    }
}
-(void)zzButtonClicked{
    
}
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> * _Nullable)unifiedNativeAdDataObjects error:(NSError * _Nullable)error {
    if (unifiedNativeAdDataObjects.count>0)
    {
        self.adData = unifiedNativeAdDataObjects[0];
        NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
        if (self.callback) {  self.callback(dict); }
    }
    else
    {
        NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
        if (self.callback) {  self.callback(dict); }
    }
}

- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
}

- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView { }

- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo { }

- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
}

- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
}

@end
