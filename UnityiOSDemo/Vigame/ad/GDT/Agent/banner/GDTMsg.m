//
//  GDTMsg.m
//  NativeTest
//
//  Created by DLWX on 2019/6/15.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "GDTMsg.h"
#import "GDTUnifiedNativeAd.h"
#import "GDTUnifiedNativeAdView.h"
#import "VBAdUtils.h"
@interface GDTMsg()<GDTUnifiedNativeAdDelegate,GDTUnifiedNativeAdViewDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic, strong) GDTUnifiedNativeAd *unifiedNativeAd;
@property(strong)NSDictionary *adParams;
@property(strong)UIView *msgView;
@property(strong) GDTUnifiedNativeAdView *gdtView;
@property(strong)GDTUnifiedNativeAdDataObject *msgData;

@property (nonnull, strong) UIImage *image;
@end
@implementation GDTMsg
-(void)loadWithParam:(NSDictionary *)params callback:(void(^)(NSDictionary *))callback{
    self.callback = callback;
    self.adParams = params;
    NSString *appid = params[KTMLoadAdAppId];
    NSString *code = params[KTMLoadPlaceCodeId];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.unifiedNativeAd = [[GDTUnifiedNativeAd alloc] initWithAppId:appid placementId:code];
        self.unifiedNativeAd.delegate = self;
        [self.unifiedNativeAd loadAd];
    });
}
- (void)gdt_unifiedNativeAdLoaded:(NSArray<GDTUnifiedNativeAdDataObject *> * _Nullable)unifiedNativeAdDataObjects error:(NSError * _Nullable)error {
    if (unifiedNativeAdDataObjects.count>0)
    {
        self.msgData = unifiedNativeAdDataObjects[0];
       
        NSURL *imageURL = [NSURL URLWithString:self.msgData.imageUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            self.image = [UIImage imageWithData:imageData];
            NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
            self.callback(dict);
        });
    }
    else
    {
        NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
        self.callback(dict);
    }
    if (error.code == 5004)  NSLog(@"没匹配的广告，禁止重试，否则影响流量变现效果");
    else if (error.code == 5005)NSLog(@"流量控制导致没有广告，超过日限额，请明天再尝试");
    else if (error.code == 5009)NSLog(@"流量控制导致没有广告，超过小时限额");
    else if (error.code == 5006)NSLog(@"包名错误");
    else if (error.code == 5010)NSLog(@"广告样式校验失败");
    else if (error.code == 3001)NSLog(@"网络错误");
    else  NSLog(@"ERROR: %@", error);
}

-(void)closeMsg{
    if (self.msgView && self.msgView.superview)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
            if (self.callback) {  self.callback(dict); }
            [self.msgView removeFromSuperview];
        });
    }
}

-(void)openMsgParams:(NSDictionary *)bInfos
{
    
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
    int x = [[bInfos objectForKey:@"x"] intValue];
    int y = [[bInfos objectForKey:@"y"] intValue];
    int width = [[bInfos objectForKey:@"width"] intValue];
    int height = [[bInfos objectForKey:@"height"] intValue];
    
    
    self.msgView = [[UIView alloc]initWithFrame:CGRectMake(x-8, y-8, width+8, height+8)];
    self.msgView.backgroundColor = [UIColor clearColor];
    /*自渲染2.0视图类*/
    GDTUnifiedNativeAdView *unifiedNativeAdView = [[GDTUnifiedNativeAdView alloc] initWithFrame:CGRectMake(8, 8, width, height)];
    unifiedNativeAdView.backgroundColor = [UIColor whiteColor];
    unifiedNativeAdView.delegate = self;
    self.gdtView = unifiedNativeAdView;
    [self.msgView addSubview:self.gdtView];
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.msgView addSubview:closeBtn];
    closeBtn.frame = CGRectMake(0, 0, 25, 25);
    [closeBtn setImage:[UIImage imageNamed:@"gdt_bnclose.png"] forState:0];
    [closeBtn addTarget:self action:@selector(closeMsg) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    /*广告标题*/
    //    UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, width-60, 25)];
    //    txt.text = self.msgData.title;
    //    txt.textAlignment = NSTextAlignmentCenter;
    //    [self.gdtView addSubview:txt];
    
    
    /*广告详情图*/
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width, height)];
    [unifiedNativeAdView addSubview:imgV];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
  
    imgV.image = self.image;
    GDTLogoView *logoView = [[GDTLogoView alloc] init];
    logoView.frame = CGRectMake(width-kGDTLogoImageViewDefaultWidth, height-kGDTLogoImageViewDefaultHeight, kGDTLogoImageViewDefaultWidth, kGDTLogoImageViewDefaultHeight);
    [self.gdtView addSubview:logoView];
    
    // MARK: Test
//    UIViewController *vc = [VBAdUtils getUIViewController];
    // NARK: Product
    UIViewController *vc = [VBAdUtils getBannerViewController];
    [unifiedNativeAdView registerDataObject:self.msgData clickableViews:@[unifiedNativeAdView]];
    [unifiedNativeAdView setViewController:vc];
//    [unifiedNativeAdView registerDataObject:self.msgData logoView:logoView viewController:vc clickableViews:@[unifiedNativeAdView]];
    [vc.view insertSubview:self.msgView atIndex:0];
}
- (void)gdt_unifiedNativeAdViewDidClick:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

- (void)gdt_unifiedNativeAdDetailViewClosed:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
}


- (void)gdt_unifiedNativeAdDetailViewWillPresentScreen:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
}


- (void)gdt_unifiedNativeAdView:(GDTUnifiedNativeAdView *)unifiedNativeAdView playerStatusChanged:(GDTMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo {
    
}


- (void)gdt_unifiedNativeAdViewApplicationWillEnterBackground:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
}


- (void)gdt_unifiedNativeAdViewWillExpose:(GDTUnifiedNativeAdView *)unifiedNativeAdView {
    
}

@end
