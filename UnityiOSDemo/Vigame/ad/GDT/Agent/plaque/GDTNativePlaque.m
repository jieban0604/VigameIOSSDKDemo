//
//  GDTNativePlaque.m
//  Vigame_Test
//
//  Created by DLWX on 2018/10/10.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "GDTNativePlaque.h"
#import "VBAdUtils.h"
#import "GDTNativeAd.h"

@interface GDTNativePlaque()<GDTNativeAdDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property(nonatomic,strong)GDTNativeAd *nativeAd;//当前展示的原生广告数据对象
@property(nonatomic,strong)GDTNativeAdData *nativeData;//原生广告数据
@property(nonatomic,strong)UIView *plaqueView;
@end

@implementation GDTNativePlaque

-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.callback = cb;
        self.adParams = param;
        self.nativeAd = [[GDTNativeAd alloc]initWithAppId:param[KTMLoadAdAppId] placementId:param[KTMLoadPlaceCodeId]];
        self.nativeAd.controller =  [VBAdUtils getUIViewController];
        self.nativeAd.delegate = self;
        [self.nativeAd loadAd:1];
    });
}
-(void)openPlaque:(NSDictionary *)dict{
    [self vigame_openGDTNativePlaque];
}
-(void)vigame_openGDTNativePlaque{
    if (!self.nativeData) {
        NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
        if (self.callback) {  self.callback(dict); }
        return;
    }
    self.nativeAd.controller = [VBAdUtils getUIViewController];
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.plaqueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    UIGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerMethod:)];
    gesture.delegate = self;
    [self.plaqueView addGestureRecognizer:gesture];
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
        
        
        /*广告Icon*/
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        icon.layer.cornerRadius = 5.0f;
        icon.layer.masksToBounds = YES;
        NSURL *iconURL = [NSURL URLWithString:[self.nativeData.properties objectForKey:GDTNativeAdDataKeyIconUrl]];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:iconURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                icon.image = [UIImage imageWithData:imageData];
            });
        });
        [containView addSubview:icon];
        
        
        /*广告标题*/
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 0,  realSize.width-80, 70)];
        titleLab.font = [UIFont systemFontOfSize:20];
        titleLab.text = [self.nativeData.properties objectForKey:GDTNativeAdDataKeyTitle];
        [containView addSubview:titleLab];
        
        /*广告描述*/
        UILabel * descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60,realSize.width-20, 50)];
        descLabel.font = [UIFont systemFontOfSize:16];
        descLabel.numberOfLines = 0;
        descLabel.text = [self.nativeData.properties objectForKey:GDTNativeAdDataKeyDesc];
        descLabel.textColor = [UIColor blackColor];
        [containView addSubview:descLabel];
        
        
        //广告详情图
        UIImageView *detailsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,115,realSize.width, realSize.width*2/3.0)];
        [containView addSubview:detailsImgView];
        NSURL *imageURL = [NSURL URLWithString:[self.nativeData.properties objectForKey:GDTNativeAdDataKeyImgUrl]];
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
        gdtLogo.frame = CGRectMake(containView.bounds.size.width-37.5, containView.bounds.size.height-30, 37.5, 30);
        gdtLogo.image = [UIImage imageNamed:@"gdt_logo.png"];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(containView.bounds.size.width-37, 5, 32, 32);
        [containView addSubview:closeBtn];
        [closeBtn setImage:[UIImage imageNamed:@"gdt_bnclose"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(nativeAdClosed) forControlEvents:UIControlEventTouchUpInside];
        
        UIViewController *vc = [VBAdUtils getUIViewController];
        [self.nativeAd setController:vc];
        /*注册点击事件*/
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nativeAdDidClick)];
        [containView addGestureRecognizer:tap];
        
        [self.nativeAd attachAd:self.nativeData toView:containView];
 
    }
}

-(void)nativeAdDidClick{
    [self.nativeAd clickAd:self.nativeData]; /*点击发生，调用点击接口*/
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

-(void)zzBtnClick{
    NSLog(@"点击在半透明灰色遮罩上面");
    
}
- (void)panGestureRecognizerMethod:(UIGestureRecognizer *)gesture {
    
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch {
    return YES;
}
- (void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray {
    if (nativeAdDataArray.count >0){
        self.nativeData = [nativeAdDataArray firstObject];
        NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
        if (self.callback) {  self.callback(dict); }
    }
}

- (void)nativeAdFailToLoad:(NSError *)error {
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}
-(void)nativeAdClosed{
    if (self.plaqueView) {
        [self.plaqueView removeFromSuperview];
        self.plaqueView = nil;
        NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
        if (self.callback) {  self.callback(dict); }
    }
}


@end
