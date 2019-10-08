//
//  IsVideo.m
//  Vigame_Test
//
//  Created by DLWX on 2018/10/12.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "IsVideo.h"
#import "VBAdUtils.h"
#import <IronSource/IronSource.h>

@interface IsVideo()<ISRewardedVideoDelegate>
@property(nonatomic,strong)void (^loadCallback)(NSDictionary *);
@property(nonatomic,strong)void (^openCallback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *loadParams;
@property(nonatomic,strong)NSDictionary *openParams;

@end
static IsVideo *agent = nil;
@implementation IsVideo
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [super init];
    });
    return agent;
}
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.loadCallback = cb;
    self.loadParams = param;
    [IronSource initWithAppKey:param[KTMLoadAdAppId]];
    [IronSource setRewardedVideoDelegate:self];
}
-(void)openVideoWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary*))callback{
    self.openParams = param;
    self.openCallback = callback;
    if ([IronSource hasRewardedVideo]) {
        UIViewController *vc = [VBAdUtils getUIViewController];
        [IronSource showRewardedVideoWithViewController:vc];
    }
    else {
        NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
        if (self.openCallback) {  self.openCallback(dict); }
    }
}

- (void)rewardedVideoHasChangedAvailability:(BOOL)available {
    if (self.openParams) {
        return;
    }
    if (available) {
        NSDictionary *dict = @{KTMCallbackADID:self.loadParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
        if (self.loadCallback) {  self.loadCallback(dict); }
    }else{
        NSDictionary *dict = @{KTMCallbackADID:self.loadParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
        if (self.loadCallback) {  self.loadCallback(dict); }
    }
}
- (void)rewardedVideoDidOpen {
    //    NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:@"OPEN_SUCCESS"};
    //    if (self.openCallback) {  self.openCallback(dict); }
}
- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo {
    NSLog(@"%s",__func__);
}
- (void)rewardedVideoDidClose {
    NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
    if (self.openCallback) {  self.openCallback(dict); }
    NSDictionary *dict1 = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateGiveReward};
    if (self.openCallback) {  self.openCallback(dict1); }
    self.openParams = nil;
}

- (void)didClickRewardedVideo:(ISPlacementInfo *)placementInfo {
    NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.openCallback) {  self.openCallback(dict); }
}





- (void)rewardedVideoDidEnd {
    NSLog(@"%s",__func__);
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error {
    NSLog(@"error == %@",[error debugDescription]);
    NSLog(@"%s",__func__);
    NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
    if (self.openCallback) {  self.openCallback(dict); }
}

- (void)rewardedVideoDidStart {
    NSLog(@"%s",__func__);
}



@end
