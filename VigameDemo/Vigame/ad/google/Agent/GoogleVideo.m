//
//  GoogleVideo.m
//  Vigame_Test
//
//  Created by DLWX on 2018/10/10.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "GoogleVideo.h"
#import "VBAdUtils.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
@interface GoogleVideo()<GADRewardBasedVideoAdDelegate>
@property(nonatomic,strong)void (^loadCallback)(NSDictionary *);
@property(nonatomic,strong)void (^openCallback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *loadParams;
@property(nonatomic,strong)NSDictionary *openParams;
@property(nonatomic,strong)GADRewardBasedVideoAd *videoAd;
@property(nonatomic,assign)BOOL firstTime;
@property(nonatomic,assign)BOOL canGiveReward;
@property(nonatomic,assign)int adStute;
@property(nonatomic,strong)NSMutableArray *dataSourceArr;

@end
static GoogleVideo * googleAgent = nil;
@implementation GoogleVideo
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.loadCallback = cb;
    self.loadParams = param;
    [self vigame_loadGoogleVideo:param];
}

-(void)vigame_loadGoogleVideo:(NSDictionary *)param{
    if(!_firstTime) {
        _firstTime = !_firstTime;
        dispatch_async(dispatch_get_main_queue(), ^{
            //[GADMobileAds.sharedInstance startWithCompletionHandler:nil];
            self.canGiveReward = false;
            self.videoAd = [GADRewardBasedVideoAd sharedInstance];
            self.videoAd.delegate = self;
            GADRequest *request = [GADRequest request];
            [self.videoAd loadRequest:request withAdUnitID:param[KTMLoadPlaceCodeId]];
        });
    }
    if (self.adStute == -1)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            GADRequest *request = [GADRequest request];
            [self.videoAd loadRequest:request withAdUnitID:param[KTMLoadPlaceCodeId]];
        });
    }
}

-(void)openVideoWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary*))callback{
    self.openParams = param;
    self.openCallback = callback;
    [self vigame_openGoogleVideo];
}
-(void)vigame_openGoogleVideo{
    if ([self.videoAd isReady]) {
        UIViewController *topVC = [VBAdUtils getUIViewController];
        [self.videoAd presentFromRootViewController:topVC];
    }
    else {
        NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
        if (self.openCallback) {  self.openCallback(dict); }
    }
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward{
    self.canGiveReward = true;
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error{
    self.adStute = -1;
    NSDictionary *dict = @{KTMCallbackADID:self.loadParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.loadCallback) {  self.loadCallback(dict); }
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    self.adStute = 1;
    NSDictionary *dict = @{KTMCallbackADID:self.loadParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.loadCallback) {  self.loadCallback(dict); }
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    //    NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:@"OPEN_SUCCESS"};
    //    if (self.openCallback) {  self.openCallback(dict); }
}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    if(self.canGiveReward){
        self.canGiveReward = false;
        NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateGiveReward};
        if (self.openCallback) {  self.openCallback(dict); }
    }
    else
    {
        NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
        if (self.openCallback) {  self.openCallback(dict); }
    }
    
    GADRequest *request = [GADRequest request];
    [[GADRewardBasedVideoAd sharedInstance] loadRequest:request withAdUnitID:self.loadParams[KTMLoadPlaceCodeId]];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    [VBAdUtils setOpenAppStore:YES];
    NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.openCallback) {  self.openCallback(dict); }
}
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        googleAgent = [super init];
        self.adStute = 0;
        self.dataSourceArr = [[NSMutableArray alloc]initWithCapacity:0];
    });
    return googleAgent;
}

@end
