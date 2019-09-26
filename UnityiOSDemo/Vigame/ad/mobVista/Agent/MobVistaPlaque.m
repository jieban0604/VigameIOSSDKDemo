//
//  MobVistaPlaque.m
//  Vigame_Test
//
//  Created by DLWX on 2018/10/15.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "MobVistaPlaque.h"
#import "VBAdUtils.h"
#import <MTGSDK/MTGSDK.h>
#import <MTGSDKInterstitialVideo/MTGInterstitialVideoAdManager.h>
@interface MobVistaPlaque()<MTGInterstitialVideoDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property (nonatomic, strong) MTGInterstitialVideoAdManager *plaqueAdManager;
@end
@implementation MobVistaPlaque

-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParams = param;
    [self vigame_loadMobvistaPlaque:param];
}
-(void)vigame_loadMobvistaPlaque:(NSDictionary *)param{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[MTGSDK sharedInstance]setAppID:param[KTMLoadAdAppId] ApiKey:param[@"app_key"]];
        self.plaqueAdManager = [[MTGInterstitialVideoAdManager alloc]initWithUnitID:param[KTMLoadPlaceCodeId] delegate:self];
        [self.plaqueAdManager loadAd];
    });
    
}
-(void)openPlaque:(NSDictionary *)param{
    [self vigame_openMobvistaPlaque];
}
-(void)vigame_openMobvistaPlaque{
    UIViewController *vc = [VBAdUtils getUIViewController];
    [self.plaqueAdManager showFromViewController:vc];
}

- (void) onInterstitialVideoLoadSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
}
- (void) onInterstitialVideoLoadFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}
- (void) onInterstitialVideoShowSuccess:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
}

/**
 *  Called when the ad failed to display for some reason
 *  @param error       - error object that describes the exact error encountered when showing the ad.
 */
- (void) onInterstitialVideoShowFail:(nonnull NSError *)error adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSLog(@"mobvistab show fail error:%@",error);
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
    if (self.callback) {  self.callback(dict); }
}

/**
 *  Called when the ad is clicked
 */
- (void) onInterstitialVideoAdClick:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

/**
 *  Called when the ad has been dismissed from being displayed, and control will return to your app
 *  @param converted   - BOOL describing whether the ad has converted
 */
- (void)onInterstitialVideoAdDismissedWithConverted:(BOOL)converted adManager:(MTGInterstitialVideoAdManager *_Nonnull)adManager{
    NSDictionary *dict = @{KTMCallbackADID:self.adParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
}

@end
