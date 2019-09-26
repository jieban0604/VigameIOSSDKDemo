//
//  GDTBanner2.m
//  NativeTest
//
//  Created by DLWX on 2019/5/11.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "GDTBanner2.h"
#import "VBAdUtils.h"
#import "GDTUnifiedBannerView.h"
@interface GDTBanner2()<GDTUnifiedBannerViewDelegate>
@property (nonatomic, strong) GDTUnifiedBannerView *bannerView;
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property(nonatomic,assign)BOOL canOpen;
@property (nonatomic, assign) BOOL isOpen;
@end
@implementation GDTBanner2
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParams = param;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
    
}
-(void)openBanner{
    self.canOpen = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *appid = self.adParams[KTMLoadAdAppId];
        NSString *placecode = self.adParams[KTMLoadPlaceCodeId];
        //MARK: Test
//        UIViewController *vc = [VBAdUtils getUIViewController];
        //MARK: Product
        UIViewController *vc = [VBAdUtils getBannerViewController];
        self.bannerView = [[GDTUnifiedBannerView alloc]initWithAppId:appid placementId:placecode viewController:vc];
        self.bannerView.delegate = self;
        [self.bannerView loadAdAndShow];
        //[vc.view addSubview:self.bannerView];
        [vc.view insertSubview:self.bannerView atIndex:0];
    });
}
-(void)closeBanner{
    self.canOpen = false;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
   
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.bannerView && self.bannerView.superview) {
            self.bannerView.delegate = nil;
            [self.bannerView removeFromSuperview];
            
            self.bannerView = nil;
        }
        
    });
}
/**
 *  请求广告条数据成功后调用
 *  当接收服务器返回的广告数据成功后调用该函数
 */
- (void)unifiedBannerViewDidLoad:(GDTUnifiedBannerView *)unifiedBannerView
{
    CGRect rect = [VBAdUtils getBannerFrame];
    self.bannerView.frame = rect;
}

/**
 *  请求广告条数据失败后调用
 *  当接收服务器返回的广告数据失败后调用该函数
 */
- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error
{
    
}

/* banner2.0曝光回调 */
- (void)unifiedBannerViewWillExpose:(GDTUnifiedBannerView *)unifiedBannerView{
    
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
}

/* banner2.0点击回调 */
- (void)unifiedBannerViewClicked:(GDTUnifiedBannerView *)unifiedBannerView{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}


/*  当点击应用下载或者广告调用系统程序打开 */
- (void)unifiedBannerViewWillLeaveApplication:(GDTUnifiedBannerView *)unifiedBannerView{
    
}

/*   banner2.0被用户关闭时调用 */
- (void)unifiedBannerViewWillClose:(GDTUnifiedBannerView *)unifiedBannerView{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
}


@end
