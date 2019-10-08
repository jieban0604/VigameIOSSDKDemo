//
//  MobvistaVideo.m
//  Vigame_Test
//
//  Created by DLWX on 2018/10/15.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import "MobvistaVideo.h"
#import "VBAdUtils.h"
#import <MTGSDK/MTGSDK.h>
#import <MTGSDKReward/MTGRewardAdManager.h>
static MobvistaVideo *agent = nil;
@interface MobvistaVideo()<MTGRewardAdLoadDelegate,MTGRewardAdShowDelegate>
@property(nonatomic,strong)void (^loadCallback)(NSDictionary *);
@property(nonatomic,strong)void (^openCallback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *loadParams;
@property(nonatomic,strong)NSDictionary *openParams;
@property(nonatomic,assign)BOOL firstTime;
@property(nonatomic,assign)int loadSuccessTimes;
@property(nonatomic,strong)NSMutableArray *datasourceArray;
@end
@implementation MobvistaVideo
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [super init];
        self.datasourceArray = [NSMutableArray arrayWithCapacity:0];
    });
    return agent;
}
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.loadCallback = cb;
    self.loadParams = param;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self.firstTime){
            self.firstTime = !self.firstTime;
            [[MTGSDK sharedInstance]setAppID:param[KTMLoadAdAppId] ApiKey:param[@"app_key"]];
            
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setObject:param[KTMLoadAdSourceItemId] forKey:KTMLoadAdSourceItemId];
        [self.datasourceArray addObject:dict];
        [[MTGRewardAdManager sharedInstance] loadVideo:param[KTMLoadPlaceCodeId] delegate:self];
    });
}

-(void)openVideoWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary*))callback{
    self.openParams = param;
    self.openCallback = callback;
    if ([[MTGRewardAdManager sharedInstance] isVideoReadyToPlay:param[KTMLoadPlaceCodeId]])
    {
        UIViewController *vc = [VBAdUtils getUIViewController];
        [[MTGRewardAdManager sharedInstance]showVideo:param[KTMLoadPlaceCodeId] withRewardId:@"000" userId:@"111" delegate:self viewController:vc];
    }
    else {
        NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
        if (self.openCallback) {  self.openCallback(dict); }
    }
}

- (void)onVideoAdLoadSuccess:(nullable NSString *)unitId{
    NSDictionary *dictt = @{KTMCallbackADID:self.loadParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
    if (self.loadCallback) {  self.loadCallback(dictt); }
}

- (void)onVideoAdLoadFailed:(nullable NSString *)unitId error:(nonnull NSError *)error{
    NSDictionary *dictt = @{KTMCallbackADID:self.loadParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadFail};
    if (self.loadCallback) {  self.loadCallback(dictt); }
    NSInteger index = -1;
    for (NSMutableDictionary *dict in self.datasourceArray)
    {
        NSInteger code = [[dict objectForKey:KTMLoadAdSourceItemId] integerValue];
        if (code == [self.loadParams[KTMLoadAdSourceItemId] integerValue])
        {
            index = [self.datasourceArray indexOfObject:dict];
            break;
        }
    }
    if (index != -1) {
        [self.datasourceArray removeObjectAtIndex:index];
    }
}

- (void)onVideoAdShowSuccess:(nullable NSString *)unitId{
    NSDictionary *dictt = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
    if (self.loadCallback) {  self.loadCallback(dictt); }
}

- (void)onVideoAdShowFailed:(nullable NSString *)unitId withError:(nonnull NSError *)error{
    NSDictionary *dictt = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
    if (self.loadCallback) {  self.loadCallback(dictt); }
}


- (void)onVideoAdClicked:(nullable NSString *)unitId{
    NSDictionary *dictt = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.loadCallback) {  self.loadCallback(dictt); }
}
- (void)onVideoAdDidClosed:(nullable NSString *)unitId {
    NSDictionary *dictt;
    dictt = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateGiveReward};
    if (self.openCallback) {  self.openCallback(dictt); }
}
- (void)onVideoAdDismissed:(nullable NSString *)unitId withConverted:(BOOL)converted withRewardInfo:(nullable MTGRewardAdInfo *)rewardInfo{
    NSDictionary *dictt;
    dictt = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateGiveReward};
    if (self.openCallback) {  self.openCallback(dictt); }
    NSInteger index = -1;
    for (NSMutableDictionary *dict in self.datasourceArray)
    {
       NSInteger code = [[dict objectForKey:KTMLoadAdSourceItemId] integerValue];
        if (code == [self.openParams[KTMLoadAdSourceItemId] integerValue])
        {
            index = [self.datasourceArray indexOfObject:dict];
            break;
        }
    }
    if (index != -1)
    {
        [self.datasourceArray removeObjectAtIndex:index];
    }
}
@end
