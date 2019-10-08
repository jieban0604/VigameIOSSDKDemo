//
//  HeadLineNativeBanner.m
//  VigameDemo
//
//  Created by 动能无限 on 2019/7/4.
//  Copyright © 2019 动能无限. All rights reserved.
//

#import "HeadLineNativeBanner.h"
#import <UIKit/UIKit.h>
#import <BUAdSDK/BUAdSDK.h>
#import "VBAdUtils.h"

@interface HeadLineNativeBanner () <BUNativeAdDelegate>

@property (nonatomic, strong) NSDictionary *adParam;
@property (nonatomic, copy) void (^loadCallback)(NSDictionary *);

@property (nonatomic, strong) BUNativeAd *nativeAd;
@property(nonatomic, strong)NSDictionary *bannerParams;
@property (nonatomic, strong) UIView *bannerView;
@property (nonatomic, assign) BOOL canOpen;

@end

@implementation HeadLineNativeBanner

-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.loadCallback = cb;
    self.adParam = param;
    NSDictionary *dic =@{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadSuccess};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
       [BUAdSDKManager setAppID:param[KTMLoadAdAppId]];
    });
}

- (void)openBanner {
    [self vigame_openHeadLineNativeBanner];
}

- (void)closeBanner {
    self.canOpen = NO;
    if (self.bannerView == nil) {
        return;
    }
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateCloseSuccess};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.bannerView && self.bannerView.superview) {
            [self.bannerView removeFromSuperview];
            self.bannerView = nil;
        }
    });
}

-(void)vigame_openHeadLineNativeBanner {
    self.canOpen = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.nativeAd) {
            BUSize *imgSize = [[BUSize alloc] init];
            imgSize.width = 1080;
            imgSize.height = 1920;
            
            BUAdSlot *slot = [[BUAdSlot alloc] init];
            slot.ID = self.adParam[KTMLoadPlaceCodeId];
            slot.AdType = BUAdSlotAdTypeBanner;
            slot.position = BUAdSlotPositionTop;
            slot.imgSize = imgSize;
            slot.isSupportDeepLink = YES;
            slot.isOriginAd = YES;
            
            BUNativeAd *nad = [BUNativeAd new];
            nad.adslot = slot;
            nad.rootViewController = [VBAdUtils getBannerViewController];
            nad.delegate = self;
            self.nativeAd = nad;
            
            [self.nativeAd loadAdData];
        }
    });
    
}

#pragma mark - BUNativeAdDelegate

- (void)nativeAdDidLoad:(BUNativeAd *)nativeAd {
    if (!self.canOpen) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGRect bannerFrame;
        bannerFrame = [VBAdUtils getBannerFrame];
        self.bannerView = [[UIView alloc] initWithFrame:[VBAdUtils getBannerFrame]];
        UIView *vcView = [VBAdUtils getBannerViewController].view;
        //[vcView addSubview:self.bannerView];
        [vcView insertSubview:self.bannerView atIndex:0];
        self.bannerView.backgroundColor = [UIColor whiteColor];
        /*广告标题*/
        UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake( bannerFrame.size.height+10, 5,  bannerFrame.size.width-30-bannerFrame.size.height, 25)];
        txt.adjustsFontSizeToFitWidth = YES;
        txt.text = nativeAd.data.AdTitle;
        [self.bannerView addSubview:txt];
        
        /*广告描述*/
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(bannerFrame.size.height+10, 25, bannerFrame.size.width-30-bannerFrame.size.height, 25)];
        desc.font = [UIFont systemFontOfSize:12];
        desc.text = nativeAd.data.AdDescription;
        [self.bannerView addSubview:desc];
        
        /*广告Icon*/
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, bannerFrame.size.height-10, bannerFrame.size.height-10)];
        [self.bannerView addSubview:iconImageView];
        NSURL *iconURL = [NSURL URLWithString:nativeAd.data.icon.imageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:iconURL];
        iconImageView.image = [UIImage imageWithData:imageData];
        UIImageView *adImageView = [[UIImageView alloc]init];
        [self.bannerView addSubview:adImageView];
        adImageView.image = [UIImage imageNamed:@"ad.png"];
        adImageView.frame = CGRectMake(0, self.bannerView.bounds.size.height-13, 25, 13);
        
        UIImageView *logoImageView = [[UIImageView alloc]init];
        [self.bannerView addSubview:logoImageView];
        logoImageView.clipsToBounds = YES;
        logoImageView.frame = CGRectMake(self.bannerView.bounds.size.width-20, self.bannerView.bounds.size.height-20, 20, 20);
        logoImageView.image = [UIImage imageNamed:@"headlineLogo.png"];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bannerView addSubview:closeBtn];
        closeBtn.frame = CGRectMake(self.bannerView.bounds.size.width-20, 0, 20, 20);
        [closeBtn setImage:[UIImage imageNamed:@"gdt_bnclose.png"] forState:0];
        [closeBtn addTarget:self action:@selector(closeBanner) forControlEvents:UIControlEventTouchUpInside];
        
        [nativeAd registerContainer:self.bannerView withClickableViews:@[self.bannerView]];
        
    });
}

- (void)nativeAd:(BUNativeAd *)nativeAd didFailWithError:(NSError *)error {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadFail};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
    [self closeBanner];
}

- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *)view {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateAdClicked};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)nativeAdDidBecomeVisible:(BUNativeAd *)nativeAd {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateOpenSuccess};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

@end
