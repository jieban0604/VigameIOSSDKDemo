//
//  HeadLineRewardView.m
//  NativeTest
//
//  Created by 动能无限 on 2019/8/8.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "HeadLineRewardVideo.h"

#import "VBAdUtils.h"
#import <BUAdSDK/BUAdSDK.h>

@interface HeadLineRewardVideo () <BURewardedVideoAdDelegate>
@property (nonatomic, strong) NSDictionary *loadParams;
@property (nonatomic, strong) NSDictionary *openParams;
@property (nonatomic, copy) void (^loadCallback)(NSDictionary *);
@property (nonatomic, copy) void (^openCallback)(NSDictionary *);
@property (nonatomic, assign) BOOL isFirstLaunch;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

static HeadLineRewardVideo *headlineVideo = nil;

@implementation HeadLineRewardVideo

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken
                  , ^{
                      headlineVideo = [super init];
                      self.dataSourceArr = [NSMutableArray array];
                  });
    return headlineVideo;
}

- (void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.loadCallback = cb;
    self.loadParams = param;
    [self vigame_loadHeadLineVideo:param];
}

- (void)vigame_loadHeadLineVideo:(NSDictionary *)param {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.isFirstLaunch) {
            self.isFirstLaunch = !self.isFirstLaunch;
            [BUAdSDKManager setAppID:param[KTMLoadAdAppId]];
        }
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
        model.userId = param[KTMLoadAdAppId];
        BURewardedVideoAd *videoAd = [[BURewardedVideoAd alloc] initWithSlotID:param[KTMLoadPlaceCodeId] rewardedVideoModel:model];
        videoAd.delegate = self;
        [videoAd loadAdData];
        
        NSString *adid = [NSString stringWithFormat:@"%@", param[KTMLoadAdSourceItemId]];
        [self.dataSourceArr addObject:@{KTMLoadAdSourceItemId: adid, @"ad": videoAd}];
    });
   
}

-(void)openVideoWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary*))callback {
    self.openCallback = callback;
    self.openParams = param;
    [self vigame_openHeadLineVideo];
}

- (void)vigame_openHeadLineVideo {
    NSString *openAdId = [NSString stringWithFormat:@"%@", self.openParams[KTMLoadAdSourceItemId]];
    BURewardedVideoAd *ad = nil;
    for (NSDictionary *object in self.dataSourceArr) {
        NSString *adid = [NSString stringWithFormat:@"%@", object[KTMLoadAdSourceItemId]];
        if ([openAdId isEqualToString:adid]) {
            ad = object[@"ad"];
            break;
        }
    }
    if (ad.isAdValid) {
        UIViewController *controller = [VBAdUtils getUIViewController];
        [ad showAdFromRootViewController:controller];
    }
    else {
        NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
        if (self.openCallback) {  self.openCallback(dict); }
    }
}

#pragma  mark - BURewardedVideoAdDelegate
/**
 This method is called when video ad material loaded successfully.
 */
- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd {
    for (NSDictionary *object in self.dataSourceArr) {
        NSString *adid = [object objectForKey:KTMLoadAdSourceItemId];
        if (rewardedVideoAd == object[@"ad"]) {
            NSDictionary *dict = @{KTMCallbackADID:adid,KTMCallbackState:KTMCallbackStateLoadSuccess};
            if (self.loadCallback) {  self.loadCallback(dict); }
        }
    }
}

/**
 This method is called when video ad materia failed to load.
 @param error : the reason of error
 */
- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    for (NSDictionary *object in self.dataSourceArr) {
        NSString *adid = [object objectForKey:KTMLoadAdSourceItemId];
        BURewardedVideoAd *ad = [object objectForKey:@"ad"];
        if ([rewardedVideoAd isEqual:ad]) {
            NSDictionary *dict = @{KTMCallbackADID:adid,KTMCallbackState:KTMCallbackStateLoadFail};
            if (self.loadCallback) {  self.loadCallback(dict); }
        }
    }
    NSInteger index = -1;
    for (NSMutableDictionary *dict in self.dataSourceArr)
    {
        NSInteger code = [[dict objectForKey:KTMLoadAdSourceItemId] integerValue];
        if (code == [self.loadParams[KTMLoadAdSourceItemId] integerValue])
        {
            index = [self.dataSourceArr indexOfObject:dict];
            break;
        }
    }
    if (index != -1) {
        [self.dataSourceArr removeObjectAtIndex:index];
    }
}

/**
 This method is called when video ad is closed.
 */
- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd{
    NSInteger index = -1;
    for (NSMutableDictionary *dict in self.dataSourceArr)
    {
        NSInteger code = [[dict objectForKey:KTMLoadAdSourceItemId] integerValue];
        if (code == [self.openParams[KTMLoadAdSourceItemId] integerValue])
        {
            index = [self.dataSourceArr indexOfObject:dict];
            break;
        }
    }
    NSDictionary *dictt;
    dictt = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateGiveReward};
    if (self.openCallback) {  self.openCallback(dictt); }
    if (index != -1)
    {
        [self.dataSourceArr removeObjectAtIndex:index];
    }
}

/**
 This method is called when video ad is clicked.
 */
- (void)rewardedVideoAdDidClick:(BURewardedVideoAd *)rewardedVideoAd {
    NSDictionary *dic = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateAdClicked};
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

/**
 This method is called when video ad play completed or an error occurred.
 @param error : the reason of error
 */
- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    if (!error) {
        NSDictionary *dictt = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenSuccess};
        if (self.openCallback) {  self.openCallback(dictt); }
    }
}

@end
