//
//  IsPlaque.m
//  NativeTest
//
//  Created by DLWX on 2019/1/24.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "IsPlaque.h"
#import <UIKit/UIKit.h>
#import "VBAdUtils.h"
#import <IronSource/IronSource.h>

@interface IsPlaque()<ISInterstitialDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *adParams;
@property(nonatomic,assign)BOOL firstTime;
@property (nonatomic,strong)NSDictionary *openAdParams;
@property (nonatomic,assign)int adStute;

@end
@implementation IsPlaque

static IsPlaque *agent = nil;
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [super init];
        self.adStute = 0;
    });
    return agent;
}
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.callback = cb;
    self.adParams = param;
    if(!_firstTime) {
        _firstTime = true;
        self.openAdParams = param;
        [IronSource initWithAppKey:param[KTMLoadAdAppId]];
        [IronSource setInterstitialDelegate:self];
        [IronSource loadInterstitial];
    }
    if (self.adStute == -1)
    {
        [IronSource loadInterstitial];
    }
    
}
-(void)openPlaque:(NSDictionary *)dict{
    [self vigame_openIsPlaque];
}
-(void)vigame_openIsPlaque{
    UIViewController *vc = [VBAdUtils getUIViewController];
    if ([IronSource hasInterstitial]) {
        [IronSource showInterstitialWithViewController:vc placement:self.adParams[KTMLoadPlaceCodeId]];
    }
}

#pragma mark - ISInterstitialDelegate
-(void)interstitialDidFailToLoadWithError:(NSError *)error {
    self.adStute = -1;
    NSDictionary *dict = @{KTMCallbackADID:self.openAdParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.callback) {  self.callback(dict); }
}
-(void)interstitialDidLoad
{
    self.adStute = 1;
    NSDictionary *dict = @{KTMCallbackADID:self.openAdParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.callback) {  self.callback(dict); }
}

-(void)interstitialDidFailToShowWithError:(NSError *)error
{
    NSLog(@"iron 插屏广告打开失败!");
}
-(void)didClickInterstitial
{
    NSDictionary *dict = @{KTMCallbackADID:self.openAdParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.callback) {  self.callback(dict); }
}

-(void)interstitialDidClose
{
    NSDictionary *dict = @{KTMCallbackADID:self.openAdParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.callback) {  self.callback(dict); }
    [IronSource setInterstitialDelegate:self];
    [IronSource loadInterstitial];
    self.openAdParams = self.adParams;
}
-(void)interstitialDidOpen
{
    NSDictionary *dict = @{KTMCallbackADID:self.openAdParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.callback) {  self.callback(dict); }
}



- (void)interstitialDidShow {
    
}



@end
