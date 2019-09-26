//
//  GDTNativeBanner.m
//  Vigame_Test
//
//  Created by DLWX on 2018/9/28.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "GDTNativeBanner.h"
#import "VBAdUtils.h"
#import "GDTNativeAd.h"

@interface GDTNativeBanner()<GDTNativeAdDelegate>
@property(nonatomic,strong)GDTNativeAd *nativeAd;//原生广告实例
@property(nonatomic,strong)GDTNativeAdData *currentAd;//当前展示的原生广告数据对象
@property(nonatomic,strong)UIView *bannerView; //当前展示的原生广告界
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property(nonatomic,assign)BOOL canOpen;
@property(strong)NSDictionary *bannerParams;
@property (nonatomic, assign) BOOL isOpen;
@end

@implementation GDTNativeBanner
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParams = param;
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
}
-(void)openBanner{
    self.canOpen = YES;
    [self vigame_openGDTNativeBanner];
}

-(void)vigame_openGDTNativeBanner{
    self.canOpen = true;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.nativeAd = [[GDTNativeAd alloc] initWithAppId:self.adParams[KTMLoadAdAppId] placementId:self.adParams[KTMLoadPlaceCodeId]];
        //MARK: Test
//        self.nativeAd.controller = [VBAdUtils getUIViewController];
        //MARK: Product
        self.nativeAd.controller = [VBAdUtils getBannerViewController];
        self.nativeAd.delegate = self;
        [self.nativeAd loadAd:1];
    });
}
-(void)closeBanner{
    self.canOpen = NO;
    if (self.bannerView) {
        self.nativeAd.delegate = nil;
        NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
        if (self.callback) {  self.callback(dict); }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.bannerView && self.bannerView.superview)
                [self.bannerView removeFromSuperview];
        });
    }
}
-(void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray{
    if (self.canOpen == false)  return;
    
    if (nativeAdDataArray.count>0) {
       
        NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
        if (self.callback) {  self.callback(dict); }
        self.currentAd = [nativeAdDataArray firstObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect bannerFrame = [VBAdUtils getBannerFrame];
            self.bannerView = [[UIView alloc] initWithFrame:bannerFrame];
            self.bannerView.backgroundColor = [UIColor whiteColor];
            /*广告标题*/
            UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake( bannerFrame.size.height+10, 5,  bannerFrame.size.width-30-bannerFrame.size.height, 25)];
            txt.adjustsFontSizeToFitWidth = YES;
            txt.text = [self.currentAd.properties objectForKey:GDTNativeAdDataKeyTitle];
            [self.bannerView addSubview:txt];
            /*广告描述*/
            UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(bannerFrame.size.height+10, 30, bannerFrame.size.width-30-bannerFrame.size.height, 25)];
            desc.font = [UIFont systemFontOfSize:12];
            desc.text = [self.currentAd.properties objectForKey:GDTNativeAdDataKeyDesc];
            [self.bannerView addSubview:desc];
            /*广告Icon*/
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, bannerFrame.size.height-10, bannerFrame.size.height-10)];
            
            [self.bannerView addSubview:iconImageView];
            NSURL *iconURL = [NSURL URLWithString:[self.currentAd.properties objectForKey:GDTNativeAdDataKeyIconUrl]];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:iconURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    iconImageView.image = [UIImage imageWithData:imageData];
                });
            });
            
            UIImageView *adImageView = [[UIImageView alloc]init];
            [self.bannerView addSubview:adImageView];
            adImageView.image = [UIImage imageNamed:@"ad.png"];
            adImageView.frame = CGRectMake(0, self.bannerView.bounds.size.height-13, 25, 13);
            
            UIImageView *logoImageView = [[UIImageView alloc]init];
            [self.bannerView addSubview:logoImageView];
            logoImageView.frame = CGRectMake(self.bannerView.bounds.size.width-37.5, self.bannerView.bounds.size.height-30, 37.5, 30);
            logoImageView.image = [UIImage imageNamed:@"gdt_logo.png"];
            
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.bannerView addSubview:closeBtn];
            closeBtn.frame = CGRectMake(self.bannerView.bounds.size.width-25, 0, 25, 25);
            [closeBtn setImage:[UIImage imageNamed:@"gdt_bnclose.png"] forState:0];
            [closeBtn addTarget:self action:@selector(closeBanner) forControlEvents:UIControlEventTouchUpInside];
            
            /*注册点击事件*/
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nativeAdDidClick)];
            [self.bannerView addGestureRecognizer:tap];
            //MARK: test
//            [[VBAdUtils getUIViewController].view insertSubview:self.bannerView atIndex:0];
            //MARK: Product
            [[VBAdUtils getBannerViewController].view insertSubview:self.bannerView atIndex:0];
            /*广告数据渲染完毕，即将展示时需调用AttachAd方法 */
            [self.nativeAd attachAd:self.currentAd toView:self.bannerView];
        });
    }
}
-(void)nativeAdFailToLoad:(NSError *)error{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
    if (self.callback) {  self.callback(dict); }
}
#pragma mark - 点击广告内容
-(void)nativeAdDidClick{
    [self.nativeAd clickAd:self.currentAd]; /*点击发生，调用点击接口*/
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}
/**
 *  原生广告点击之后将要展示内嵌浏览器或应用内AppStore回调
 */
- (void)nativeAdWillPresentScreen{
    
}

@end
