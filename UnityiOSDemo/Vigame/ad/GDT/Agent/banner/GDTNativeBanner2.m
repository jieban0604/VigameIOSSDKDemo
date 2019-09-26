//
//  GDTNativeBanner2.m
//  NativeTest
//
//  Created by DLWX on 2019/5/13.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "GDTNativeBanner2.h"
#import "VBAdUtils.h"
#include <UIKit/UIKit.h>
#import "GDTUnifiedNativeAd.h"
#import "GDTUnifiedNativeAdView.h"
@interface GDTNativeBanner2()<GDTUnifiedNativeAdDelegate,GDTUnifiedNativeAdViewDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property(nonatomic,assign)BOOL canOpen;
@property(strong)NSDictionary *bannerParams;
@property (nonatomic, strong) GDTUnifiedNativeAd *unifiedNativeAd;
@property(strong) GDTUnifiedNativeAdView *bannerView;
@property(strong)UIView *bannerView2;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) BOOL isOpen;//广告是否打开

@end
@implementation GDTNativeBanner2
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParams = param;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
}
-(void)openBanner{
    [self vigame_openGDTNativeBanner];
}

-(void)vigame_openGDTNativeBanner
{
    self.canOpen = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *appid = self.adParams[KTMLoadAdAppId];
        NSString *code = self.adParams[KTMLoadPlaceCodeId];
        self.unifiedNativeAd = [[GDTUnifiedNativeAd alloc] initWithAppId:appid placementId:code];
        self.unifiedNativeAd.delegate = self;
        [self.unifiedNativeAd loadAd];
    });
}

-(void)closeBanner{
    self.canOpen = NO;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
   
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.bannerView && self.bannerView.superview) {
            self.bannerView.delegate = nil;
            self.unifiedNativeAd.delegate = nil;
            [self.bannerView removeFromSuperview];
            self.bannerView = nil;
        }
        if (self.bannerView2) {
            [self.bannerView2 removeFromSuperview];
        }
        
    });
}
-(void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray
{
    
}
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> *)unifiedNativeAdDataObjects error:(NSError *)error
{
    
    if (unifiedNativeAdDataObjects.count>0)
    {
        NSLog(@"成功请求到广告数据");
        if (!self.canOpen ) {
            return;
        }
        GDTUnifiedNativeAdDataObject *dataObject = unifiedNativeAdDataObjects[0];
        CGRect rect = [VBAdUtils getBannerFrame];
        
        /*自渲染2.0视图类*/
        GDTUnifiedNativeAdView *unifiedNativeAdView = [[GDTUnifiedNativeAdView alloc] initWithFrame:rect];
        unifiedNativeAdView.backgroundColor = [UIColor whiteColor];
        unifiedNativeAdView.delegate = self;
        self.bannerView = unifiedNativeAdView;
        
        /*广告Icon*/
        UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, rect.size.height-10, rect.size.height-10)];
        NSURL *iconURL = [NSURL URLWithString:dataObject.iconUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                iconV.image = [UIImage imageWithData:iconData];
            });
        });
        [unifiedNativeAdView addSubview:iconV];
        
        GDTLogoView *logoView = [[GDTLogoView alloc] init];
        logoView.frame = CGRectMake(rect.size.width-kGDTLogoImageViewDefaultWidth, rect.size.height-kGDTLogoImageViewDefaultHeight, kGDTLogoImageViewDefaultWidth, kGDTLogoImageViewDefaultHeight);
        [unifiedNativeAdView addSubview:logoView];
        
        /*广告标题*/
        UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.height+10, 5,  rect.size.width-30-rect.size.height, 25)];
        txt.text = dataObject.title;
        [unifiedNativeAdView addSubview:txt];
        
        
        /*广告描述*/
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.height+10, 25, rect.size.width-30-rect.size.height, 25)];
        desc.text = dataObject.desc;
        desc.font = [UIFont systemFontOfSize:13];
        [unifiedNativeAdView addSubview:desc];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bannerView addSubview:closeBtn];
        closeBtn.frame = CGRectMake(self.bannerView.bounds.size.width-25, 0, 25, 25);
        [closeBtn setImage:[UIImage imageNamed:@"gdt_bnclose.png"] forState:0];
        [closeBtn addTarget:self action:@selector(closeBanner) forControlEvents:UIControlEventTouchUpInside];
        
        //MARK: test
//        UIViewController *vc = [VBAdUtils getUIViewController];
        //MARK: Product
        UIViewController *vc = [VBAdUtils getBannerViewController];
        [unifiedNativeAdView registerDataObject:dataObject clickableViews:@[iconV,logoView,txt,desc]];
        [unifiedNativeAdView setViewController:vc];

        unifiedNativeAdView.tag = 1001;
        [vc.view insertSubview:unifiedNativeAdView atIndex:0];
      
    }
    if (error.code == 5004) {
        NSLog(@"没匹配的广告，禁止重试，否则影响流量变现效果");
    } else if (error.code == 5005) {
        NSLog(@"流量控制导致没有广告，超过日限额，请明天再尝试");
    } else if (error.code == 5009) {
        NSLog(@"流量控制导致没有广告，超过小时限额");
    } else if (error.code == 5006) {
        NSLog(@"包名错误");
    } else if (error.code == 5010) {
        NSLog(@"广告样式校验失败");
    } else if (error.code == 3001) {
        NSLog(@"网络错误");
    } else {
        NSLog(@"ERROR: %@", error);
    }
}

- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView {}

- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
}

- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo {}

- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView {}

- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView {}

@end
