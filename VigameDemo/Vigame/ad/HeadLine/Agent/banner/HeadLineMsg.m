//
//  HeadLineMsg.m
//  VigameDemo
//
//  Created by 动能无限 on 2019/7/5.
//  Copyright © 2019 动能无限. All rights reserved.
//

#import "HeadLineMsg.h"
#import "VBAdUtils.h"
#import <BUAdSDK/BUAdSDK.h>

@interface HeadLineMsg () <BUNativeAdDelegate>
@property (nonatomic, strong) NSDictionary *adParam;
@property (nonatomic, copy) void (^callback)(NSDictionary *);

@property (nonatomic, strong) BUNativeAd *nativeAd;
@property(nonatomic, strong)NSDictionary *bannerParams;
@property (nonatomic, strong) UIView *bannerView;
@property (nonatomic, assign) BOOL canOpen;

@property (nonatomic, strong) UIImage *image;

@end

@implementation HeadLineMsg

-(void)loadWithParam:(NSDictionary *)params callback:(void(^)(NSDictionary *))callback{
    self.callback = callback;
    self.adParam = params;
    dispatch_async(dispatch_get_main_queue(), ^{
        [BUAdSDKManager setAppID:self.adParam[KTMLoadAdAppId]];
    });
    [self loadHeadLineMsg];
}

- (void)loadHeadLineMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.nativeAd = [BUNativeAd new];
        BUAdSlot *slot = [[BUAdSlot alloc] init];
        slot.ID = self.adParam[KTMLoadPlaceCodeId];
        slot.AdType = BUAdSlotAdTypeBanner;
        slot.position = BUAdSlotPositionBottom;
        slot.imgSize = [BUSize sizeBy:BUProposalSize_Feed690_388];
        slot.isSupportDeepLink = YES;
        slot.isOriginAd = YES;
        self.nativeAd.adslot = slot;
        self.nativeAd.rootViewController = [VBAdUtils getBannerViewController];
        self.nativeAd.delegate = self;
        [self.nativeAd loadAdData];
    });
}

- (void)nativeAdDidLoad:(BUNativeAd *)nativeAd
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = self.nativeAd.data.imageAry;
        BUImage *img = array[0];
        NSURL *imageURL = [NSURL URLWithString:img.imageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        self.image = [UIImage imageWithData:imageData];
        NSDictionary *dict = @{KTMCallbackADID:self.adParam[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
        if (self.callback) {  self.callback(dict); }
    });
}

- (void)nativeAd:(BUNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error{
    NSDictionary *dict = @{KTMCallbackADID:self.adParam[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}

-(void)closeMsg{
    if (self.bannerView && self.bannerView.superview)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDictionary *dict = @{KTMCallbackADID:self.adParam[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
            if (self.callback) {  self.callback(dict); }
            [self.bannerView removeFromSuperview];
        });
    }
}
- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *_Nullable)view {
    NSDictionary *dict = @{KTMCallbackADID:self.adParam[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

-(void)openMsgParams:(NSDictionary *)bInfos
{
    NSDictionary *dict = @{KTMCallbackADID:self.adParam[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
    
    int x = [[bInfos objectForKey:@"x"] intValue];
    int y = [[bInfos objectForKey:@"y"] intValue];
    int width = [[bInfos objectForKey:@"width"] intValue];
    int height = [[bInfos objectForKey:@"height"] intValue];
    self.bannerView = [[UIView alloc]initWithFrame:CGRectMake(x-8, y-8, width+8, height+8)];
    UIView *vcView = [VBAdUtils getBannerViewController].view;
    //[vcView addSubview:self.bannerView];
    [vcView insertSubview:self.bannerView atIndex:0];
    UIView *adView = [[UIView alloc]initWithFrame:CGRectMake(8, 8, width, height)];
    [self.bannerView addSubview:adView];
    adView.backgroundColor = [UIColor whiteColor];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bannerView addSubview:closeBtn];
    closeBtn.frame = CGRectMake(0, 0, 25, 25);
    [closeBtn setImage:[UIImage imageNamed:@"gdt_bnclose.png"] forState:0];
    [closeBtn addTarget:self action:@selector(closeMsg) forControlEvents:UIControlEventTouchUpInside];
    
    //广告详情图
    UIImageView *detailsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width, height)];
    [adView addSubview:detailsImgView];
    detailsImgView.contentMode = UIViewContentModeScaleToFill;
//    NSArray *array = self.nativeAd.data.imageAry;
//    BUImage *img = array[0];
//    NSURL *imageURL = [NSURL URLWithString:img.imageURL];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            detailsImgView.image = [UIImage imageWithData:imageData];
//        });
//    });
    detailsImgView.image = self.image;
    UIImageView *adImageView = [[UIImageView alloc]init];
    [self.bannerView addSubview:adImageView];
    adImageView.image = [UIImage imageNamed:@"ad.png"];
    adImageView.frame = CGRectMake(8, self.bannerView.bounds.size.height-13, 25, 13);
    
    UIImageView *logoImageView = [[UIImageView alloc]init];
    [self.bannerView addSubview:logoImageView];
    logoImageView.frame = CGRectMake(self.bannerView.bounds.size.width-20, self.bannerView.bounds.size.height-20, 20, 20);
    logoImageView.image = [UIImage imageNamed:@"headlineLogo.png"];
    self.nativeAd.rootViewController = [VBAdUtils getBannerViewController];
    [self.nativeAd registerContainer:self.bannerView withClickableViews:@[self.bannerView]];
}

@end
