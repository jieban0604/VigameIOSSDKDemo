//
//  HeadLineNativePlaque.m
//  VigameDemo
//
//  Created by 动能无限 on 2019/7/4.
//  Copyright © 2019 动能无限. All rights reserved.
//

#import "HeadLineNativePlaque.h"
#import "VBAdUtils.h"
#import <BUAdSDK/BUAdSDK.h>
#import <UIKit/UIKit.h>

@interface HeadLineNativePlaque () <BUNativeAdDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSDictionary *adParam;
@property (nonatomic, copy) void (^callback)(NSDictionary *);

@property (nonatomic, strong) BUNativeAd *nativeAd;

@property (nonatomic, strong) UIView *plaqueView;

@end

@implementation HeadLineNativePlaque
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParam = param;
    [self vigame_loadNativePlaque:param];
}

- (void)vigame_loadNativePlaque:(NSDictionary *)param {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [BUAdSDKManager setAppID:param[KTMLoadAdAppId]];
        self.nativeAd = [BUNativeAd new];
        BUAdSlot *slot = [[BUAdSlot alloc] init];
        slot.ID = self.adParam[KTMLoadPlaceCodeId];
        slot.AdType = BUAdSlotAdTypeInterstitial;
        slot.position = BUAdSlotPositionMiddle;
        slot.imgSize = [BUSize sizeBy:BUProposalSize_Feed690_388];
        slot.isSupportDeepLink = YES;
        slot.isOriginAd = YES;
        self.nativeAd.adslot = slot;
        self.nativeAd.rootViewController = [VBAdUtils getUIViewController];
        self.nativeAd.delegate = self;
        [self.nativeAd loadAdData];
    });
}

-(void)openPlaque:(NSDictionary *)param{
    [self vigame_openHeadLineNativePlaque];
}
-(void)zzBtnClick{
    NSLog(@"点击在半透明灰色遮罩上面");
}

- (void)headline_nativeAdClosed {
    if (self.plaqueView) {
        [self.plaqueView removeFromSuperview];
    }
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateCloseSuccess};
    if (self.callback) {
        self.callback(dic);
    }
}

- (void)panGestureRecognizerMethod:(UIGestureRecognizer *)gesture {
    
}


-(void)vigame_openHeadLineNativePlaque {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = @{KTMCallbackADID:self.adParam[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
        if (self.callback) {  self.callback(dict); }
        self.nativeAd.rootViewController = [VBAdUtils getUIViewController];
        CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.plaqueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        
        UIViewController *currentVc = [VBAdUtils getUIViewController];
        [currentVc.view addSubview:self.plaqueView];
        {
            UIButton *zzbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.plaqueView addSubview:zzbtn];
            zzbtn.frame = [UIScreen mainScreen].bounds;
            zzbtn.backgroundColor = [UIColor blackColor];
            zzbtn.alpha = 0.5;
            [zzbtn addTarget:self action:@selector(zzBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
        {
            float width = (size.width>size.height?size.height:size.width)*0.9;
            float height = size.width>size.height?size.width:size.height;
            CGSize realSize = CGSizeMake(width, height);
            
            UIView *containView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, realSize.width, 115+realSize.width*2/3.0)];
            [self.plaqueView addSubview:containView];
            containView.center = self.plaqueView.center;
            containView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
            UIGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerMethod:)];
            UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerMethod:)];
            gesture.delegate = self;
            tap.delegate = self;
            [containView addGestureRecognizer:tap];
            [containView addGestureRecognizer:gesture];
            /*广告Icon*/
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
            icon.layer.cornerRadius = 5.0f;
            icon.layer.masksToBounds = YES;
            NSURL *iconURL = [NSURL URLWithString:self.nativeAd.data.icon.imageURL];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:iconURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    icon.image = [UIImage imageWithData:imageData];
                });
            });
            [containView addSubview:icon];
            
            
            /*广告标题*/
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake( 70 , 0,  realSize.width-80, 50)];
            titleLab.font = [UIFont systemFontOfSize:20];
            titleLab.text = self.nativeAd.data.AdTitle;
            [containView addSubview:titleLab];
            
            /*广告描述*/
            UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60,realSize.width-20, 50)];
            descLabel.font = [UIFont systemFontOfSize:16];
            descLabel.numberOfLines = 0;
            descLabel.text = self.nativeAd.data.AdDescription;
            descLabel.textColor = [UIColor blackColor];
            [containView addSubview:descLabel];
            
            
            //广告详情图
            UIImageView *detailsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,115,containView.bounds.size.width, containView.bounds.size.width*2/3.0)];
            [containView addSubview:detailsImgView];
            NSArray *array = self.nativeAd.data.imageAry;
            BUImage *img = array[0];
            NSURL *imageURL = [NSURL URLWithString:img.imageURL];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    detailsImgView.image = [UIImage imageWithData:imageData];
                });
            });
            
            
            UIImageView *adlogo = [[UIImageView alloc]init];
            [containView addSubview:adlogo];
            adlogo.image = [UIImage imageNamed:@"ad.png"];
            adlogo.frame = CGRectMake(0, containView.bounds.size.height-13, 25, 13);
            
            UIImageView *gdtLogo = [[UIImageView alloc]init];
            [containView addSubview:gdtLogo];
            gdtLogo.frame = CGRectMake(containView.bounds.size.width-25, containView.bounds.size.height-25, 25, 25);
            gdtLogo.image = [UIImage imageNamed:@"headlineLogo.png"];
            
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            closeBtn.frame = CGRectMake(containView.bounds.size.width-37, 5, 32, 32);
            [containView addSubview:closeBtn];
            [closeBtn setImage:[UIImage imageNamed:@"gdt_bnclose"] forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(headline_nativeAdClosed) forControlEvents:UIControlEventTouchUpInside];
            
            [self.nativeAd registerContainer:containView withClickableViews:@[gdtLogo,adlogo,descLabel,detailsImgView,titleLab]];
        }
    });
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
    
    return YES;
}

#pragma mark - BUNativeAdDelegate

- (void)nativeAdDidLoad:(BUNativeAd *)nativeAd{
    self.nativeAd = nativeAd;
    NSDictionary *dict = @{KTMCallbackADID:self.adParam[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
}

- (void)nativeAd:(BUNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error{
    NSDictionary *dict = @{KTMCallbackADID:self.adParam[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}


- (void)nativeAdDidClick:(BUNativeAd *)nativeAd withView:(UIView *_Nullable)view{
    NSDictionary *dict = @{KTMCallbackADID:self.adParam[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
    
}
-(void)headerline_nativeAdClosed{
    if (self.plaqueView) {
        [self.plaqueView removeFromSuperview];
    }
    NSDictionary *dict = @{KTMCallbackADID:self.adParam[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
}

@end
