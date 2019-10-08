//
//  GDTNativeModelPlaque.m
//  Vigame_Test
//
//  Created by DLWX on 2018/10/10.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "GDTNativeModelPlaque.h"
#import "VBAdUtils.h"
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"
@interface GDTNativeModelPlaque()<GDTNativeExpressAdDelegete>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property(nonatomic,strong)GDTNativeExpressAd *nativeExpressAd;
@property(nonatomic,strong)GDTNativeExpressAdView *plaqueAdView;
@property(nonatomic,strong)UIView *contianView;
@end
@implementation GDTNativeModelPlaque
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParams = param;
    dispatch_async(dispatch_get_main_queue(), ^{
        float width = [UIScreen mainScreen].bounds.size.width *0.8;
        self.nativeExpressAd = [[GDTNativeExpressAd alloc]initWithAppId:param[KTMLoadAdAppId] placementId:param[KTMLoadPlaceCodeId] adSize:CGSizeMake(width, width)];
        self.nativeExpressAd.delegate = self;
        [self.nativeExpressAd loadAd:1];
    });
}
-(void)openPlaque:(NSDictionary *)dict{
    [self vigame_openGDTModelPlaque];
}
-(void)vigame_openGDTModelPlaque{
    
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.contianView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UIViewController *currentVc = [VBAdUtils getUIViewController];
    [currentVc.view addSubview:self.contianView];
    {
        UIButton *zzbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contianView addSubview:zzbtn];
        zzbtn.frame = [UIScreen mainScreen].bounds;
        zzbtn.backgroundColor = [UIColor blackColor];
        zzbtn.alpha = 0.5;
        [zzbtn addTarget:self action:@selector(zzBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.contianView addSubview:self.plaqueAdView];
    self.plaqueAdView.center = self.contianView.center ;
    self.plaqueAdView.controller = [VBAdUtils getUIViewController];
    [self.plaqueAdView render];
}

-(void)zzBtnClick{ NSLog(@"点击在半透明灰色遮罩上面");}
- (void)nativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof GDTNativeExpressAdView *> *)views{
    if ([views count]>0) {
        NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
        if (self.callback) {  self.callback(dict); }
        self.plaqueAdView = [views firstObject];
    }
}

/**
 * 拉取原生模板广告失败
 */
- (void)nativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}

/**
 * 原生模板广告渲染成功, 此时的 nativeExpressAdView.size.height 根据 size.width 完成了动态更新。
 */
- (void)nativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
}

/**
 * 原生模板广告渲染失败
 */
- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
    if (self.callback) {  self.callback(dict); }
}


/**
 * 原生模板广告点击回调
 */
- (void)nativeExpressAdViewClicked:(GDTNativeExpressAdView *)nativeExpressAdView{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

/**
 * 原生模板广告被关闭
 */
- (void)nativeExpressAdViewClosed:(GDTNativeExpressAdView *)nativeExpressAdView{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
    [self.contianView removeFromSuperview];
}

@end
