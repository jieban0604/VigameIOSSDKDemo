//
//  GDTSplash.m
//  Vigame_Test
//
//  Created by DLWX on 2018/10/10.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "GDTSplash.h"
#import "GDTSplashAd.h"
#import "VBAdUtils.h"
@interface GDTSplash()<GDTSplashAdDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property(nonatomic,strong)GDTSplashAd *splashAd;
@end

@implementation GDTSplash
- (instancetype)init{
    static GDTSplash * agent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [super init];
    });
    return agent;
}

-(void)openSplash:(NSDictionary *)param callback:(void (^)(NSDictionary *))callback{
    self.callback = callback;
    self.adParams = param;
    [self vigame_openGDTSplash:param];
    
}
-(void)vigame_openGDTSplash:(NSDictionary *)param{
    if ([[VBAdUtils getNetWorkStates]isEqualToString:@"无网络"]) { return; }
    self.splashAd = [[GDTSplashAd alloc]initWithAppId:self.adParams[KTMLoadAdAppId] placementId:self.adParams[KTMLoadPlaceCodeId]];
    UIImage *lauchImage  = nil;
    NSString  *viewOrientation = nil;
    CGSize  viewSize  = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation orientation  = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        viewOrientation = @"Landscape";
    } else {
        viewOrientation = @"Portrait";
    }
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    self.splashAd.backgroundColor = [UIColor colorWithPatternImage:lauchImage];
    self.splashAd.delegate = self;
    self.splashAd.fetchDelay = 5;
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [self.splashAd loadAdAndShowInWindow:window];

}

- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd{
    
}

- (void)splashAdExposured:(GDTSplashAd *)splashAd{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
}
/**
 *  开屏广告展示失败
 */
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
    if (self.callback) {  self.callback(dict); }
}


/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}


/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
}


@end
