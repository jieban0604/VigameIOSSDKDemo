//
//  GDTBanner.m
//  Vigame_Test
//
//  Created by DLWX on 2018/9/28.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "GDTBanner.h"
#import "VBAdUtils.h"
#import "GDTMobBannerView.h"
#import <UIKit/UIKit.h>
@interface GDTBanner()<GDTMobBannerViewDelegate>

@property (nonatomic,retain)GDTMobBannerView *bannerView;
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property(nonatomic,assign)BOOL canOpen;
@property (nonatomic, assign) BOOL isOpen;

@end

@implementation GDTBanner
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParams = param;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
    
}
-(void)openBanner{
    [self vigame_openGDTBanner];
}
-(void)vigame_openGDTBanner{
    self.canOpen = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bannerView = [[GDTMobBannerView alloc]initWithFrame:[VBAdUtils getBannerFrame] appId:self.adParams[KTMLoadAdAppId] placementId:self.adParams[KTMLoadPlaceCodeId]];
        self.bannerView.delegate = self; // 设置Delegate
        self.bannerView.currentViewController =  [VBAdUtils getBannerViewController]; //设置当前的ViewController
        self.bannerView.interval = 30; //【可选】设置刷新频率;默认30秒
        self.bannerView.isGpsOn = NO; //【可选】开启GPS定位;默认关闭
        self.bannerView.showCloseBtn = YES; //【可选】展示关闭按钮;默认显示
        self.bannerView.isAnimationOn = YES; //【可选】开启banner轮播和展现时的动画效果;默认开启
        [self.bannerView loadAdAndShow]; //加载广告并展示
        UIView *view = [VBAdUtils getBannerViewController].view;
        [view insertSubview:self.bannerView atIndex:0];
    });
}


-(void)closeBanner{
    self.canOpen = false;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.bannerView && self.bannerView.superview) {
            [self.bannerView removeFromSuperview];
        }
    });
}
/**
 *  请求广告条数据成功后调用
 *  详解:当接收服务器返回的广告数据成功后调用该函数
 */
- (void)bannerViewDidReceived{
    if (self.canOpen == false||self.bannerView == nil) return;
   
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {
        self.callback(dict);
    }
}

/**
 *  请求广告条数据失败后调用
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)bannerViewFailToReceived:(NSError *)error{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.bannerView && self.bannerView.superview) {
            [self.bannerView removeFromSuperview];
        }
    });
}


/**
 *  banner条被用户关闭时调用
 *  详解:当打开showCloseBtn开关时，用户有可能点击关闭按钮从而把广告条关闭
 */
- (void)bannerViewWillClose{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
}

/**
 *  banner条点击回调
 */
- (void)bannerViewClicked{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

@end
