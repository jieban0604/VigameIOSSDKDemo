//
//  HeadLineMsgm.m
//  VigameDemo
//
//  Created by 动能无限 on 2019/7/5.
//  Copyright © 2019 动能无限. All rights reserved.
//

#import "HeadLineMsgm.h"
#include <UIKit/UIKit.h>
#import <BUAdSDK/BUAdSDK.h>
#import "VBAdUtils.h"
@interface HeadLineMsgm()<BUNativeAdsManagerDelegate,BUNativeAdDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property(nonatomic,strong)UIView *bannerView;
@property(strong)NSDictionary *bannerParams;
@property(strong)BUNativeAdsManager *adManager;
@property(strong)BUNativeAd *nativeAd;
@property (nonatomic, strong) UIImage *image;

@end

@implementation HeadLineMsgm
-(void)loadWithParam:(NSDictionary *)params callback:(void(^)(NSDictionary *))callback{
    self.callback = callback;
    self.adParams = params;
    dispatch_async(dispatch_get_main_queue(), ^{
        [BUAdSDKManager setAppID:self.adParams[KTMLoadAdAppId]];
        BUNativeAdsManager *nad = [BUNativeAdsManager new];
        BUAdSlot *slot1 = [[BUAdSlot alloc] init];//900546910
        slot1.ID = self.adParams[KTMLoadPlaceCodeId];
        slot1.AdType = BUAdSlotAdTypeFeed;
        slot1.position = BUAdSlotPositionTop;
        slot1.imgSize = [BUSize sizeBy:BUProposalSize_Feed690_388];
        slot1.isSupportDeepLink = YES;
        nad.adslot = slot1;
        nad.delegate = self;
        self.adManager = nad;
        [nad loadAdDataWithCount:1];
    });
}

- (void)nativeAdsManagerSuccessToLoad:(BUNativeAdsManager *)adsManager nativeAds:(NSArray<BUNativeAd *> *_Nullable)nativeAdDataArray
{
    self.nativeAd = [nativeAdDataArray objectAtIndex:0];
    
    NSArray *array = self.nativeAd.data.imageAry;
    BUImage *img = array[0];
    NSURL *imageURL = [NSURL URLWithString:img.imageURL];
    __weak  __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        weakSelf.image = [UIImage imageWithData:imageData];
        NSDictionary *dict = @{KTMCallbackADID:weakSelf.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
        if (weakSelf.callback) {  weakSelf.callback(dict); }
    });
}

- (void)nativeAdsManager:(BUNativeAdsManager *)adsManager didFailWithError:(NSError *_Nullable)error
{
    self.nativeAd = nil;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}

- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *_Nullable)view {
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

-(void)closeMsg{
    if (self.bannerView && self.bannerView.superview)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
            if (self.callback) {  self.callback(dict); }
            [self.bannerView removeFromSuperview];
        });
    }
}

-(void)openMsgParams:(NSDictionary *)bInfos
{
    if (!self.nativeAd) {
        return;
    }
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
    int x = [[bInfos objectForKey:@"x"] intValue];
    int y = [[bInfos objectForKey:@"y"] intValue];
    int width = [[bInfos objectForKey:@"width"] intValue];
    int height = [[bInfos objectForKey:@"height"] intValue];
    self.bannerView = [[UIView alloc]initWithFrame:CGRectMake(x-8, y-8, width+8, height+8)];
    UIView *vcView = [VBAdUtils getBannerViewController].view;
   
    [vcView insertSubview:self.bannerView atIndex:0];
    
    UIView *adView = [[UIView alloc]initWithFrame:CGRectMake(8, 8, width, height)];
    [self.bannerView addSubview:adView];
    adView.backgroundColor = [UIColor whiteColor];
    self.nativeAd.delegate = self;
    self.nativeAd.rootViewController = [VBAdUtils getBannerViewController];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bannerView addSubview:closeBtn];
    closeBtn.frame = CGRectMake(0, 0, 25, 25);
    [closeBtn setImage:[UIImage imageNamed:@"gdt_bnclose.png"] forState:0];
    [closeBtn addTarget:self action:@selector(closeMsg) forControlEvents:UIControlEventTouchUpInside];
    //广告详情图
    UIImageView *detailsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width, height)];
    [adView addSubview:detailsImgView];
    detailsImgView.contentMode = UIViewContentModeScaleToFill;
    detailsImgView.clipsToBounds = true;

    detailsImgView.image = self.image;
    UIImageView *adImageView = [[UIImageView alloc]init];
    [self.bannerView addSubview:adImageView];
    adImageView.image = [UIImage imageNamed:@"ad.png"];
    adImageView.frame = CGRectMake(8, self.bannerView.bounds.size.height-13, 25, 13);
    
    UIImageView *logoImageView = [[UIImageView alloc]init];
    [self.bannerView addSubview:logoImageView];
    logoImageView.frame = CGRectMake(self.bannerView.bounds.size.width-20, self.bannerView.bounds.size.height-20, 20, 20);
    logoImageView.image = [UIImage imageNamed:@"headlineLogo.png"];
    
    [self.nativeAd registerContainer:self.bannerView withClickableViews:@[self.bannerView]];
}

@end
