//
//  GDTVideo.m
//  NativeTest
//
//  Created by DLWX on 2019/2/28.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "GDTVideo.h"
#import "GDTRewardVideoAd.h"
#import "VBAdUtils.h"

@interface GDTVideo()<GDTRewardedVideoAdDelegate>
@property(nonatomic,strong)void (^loadCallback)(NSDictionary *);
@property(nonatomic,strong)void (^openCallback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *loadParams;
@property(nonatomic,strong)NSDictionary *openParams;
@property (nonatomic, strong) GDTRewardVideoAd *rewardVideoAd;
@property(nonatomic,strong)NSMutableArray *dataSourceArr;
@end

static GDTVideo * agent = nil;
@implementation GDTVideo

- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [super init];
        self.dataSourceArr = [NSMutableArray arrayWithCapacity:0];
    });
    return agent;
}


-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.loadCallback = cb;
    self.loadParams = param;
    [self vigame_loadGDTVideo:param];
}
-(void)vigame_loadGDTVideo:(NSDictionary *)param{
    dispatch_async(dispatch_get_main_queue(), ^{
        GDTRewardVideoAd *ad = [[GDTRewardVideoAd alloc] initWithAppId:param[KTMLoadAdAppId] placementId:param[KTMLoadPlaceCodeId]];
        ad.delegate = self;
        [ad loadAd];
        [self.dataSourceArr addObject:@{KTMLoadAdSourceItemId:param[KTMLoadAdSourceItemId],@"ad":ad}];
    });
}

-(void)openVideoWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary*))callback{
    self.openParams = param;
    self.openCallback = callback;
    [self vigame_openGDTVideo];
}
-(void)vigame_openGDTVideo{
    NSString *openAdID = [NSString stringWithFormat:@"%@",self.openParams[KTMLoadAdSourceItemId]];
    GDTRewardVideoAd *ad = nil;
    for (NSDictionary *item in self.dataSourceArr) {
        NSString *adid = [NSString stringWithFormat:@"%@",[item objectForKey:KTMLoadAdSourceItemId]] ;
        if ([adid isEqualToString:openAdID])
        {
            ad = [item objectForKey:@"ad"];
            break;
        }
    }
    if (ad.isAdValid)
    {
        UIViewController *vc = [VBAdUtils getUIViewController];
        [ad showAdFromRootViewController:vc];
    }
    else {
        NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
        if (self.openCallback) {  self.openCallback(dict); }
    }
}

/**
 广告数据加载成功回调
 */
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd{
    
}

/**
 视频数据下载成功回调，已经下载过的视频会直接回调
 */
- (void)gdt_rewardVideoAdVideoDidLoad:(GDTRewardVideoAd *)rewardedVideoAd{
    
    for (NSDictionary *object in self.dataSourceArr) {
        NSString *adid = [object objectForKey:KTMLoadAdSourceItemId];
        if (rewardedVideoAd == object[@"ad"]) {
            NSDictionary *dict = @{KTMCallbackADID:adid,KTMCallbackState:KTMCallbackStateLoadSuccess};
            if (self.loadCallback) {  self.loadCallback(dict); }
        }
    }
    
}
/**
 视频广告各种错误信息回调
 */
- (void)gdt_rewardVideoAd:(GDTRewardVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error
{
    for (NSDictionary *object in self.dataSourceArr) {
        NSString *adid = [object objectForKey:KTMLoadAdSourceItemId];
        GDTRewardVideoAd *ad = [object objectForKey:@"ad"];
        if ([rewardedVideoAd isEqual:ad]) {
            NSDictionary *dict = @{KTMCallbackADID:adid,KTMCallbackState:KTMCallbackStateLoadFail};
            if (self.loadCallback) {  self.loadCallback(dict); }
        }
    }
    
    NSInteger index = -1;
    for (NSMutableDictionary *dict in self.dataSourceArr)
    {
        GDTRewardVideoAd *ad = [dict objectForKey:@"ad"];
        if ([ad isEqual:rewardedVideoAd])
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
 视频播放页即将展示回调
 */
- (void)gdt_rewardVideoAdWillVisible:(GDTRewardVideoAd *)rewardedVideoAd{
    
}

/**
 视频广告曝光回调
 */
- (void)gdt_rewardVideoAdDidExposed:(GDTRewardVideoAd *)rewardedVideoAd{
}

/**
 视频播放页关闭回调
 */
- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSDictionary *dict = @{KTMCallbackADID:self.openParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateGiveReward};
    if (self.openCallback) {  self.openCallback(dict); }
    NSInteger index = -1;
    for (NSDictionary *item in self.dataSourceArr) {
        if ([item objectForKey:@"ad"] == rewardedVideoAd)
        {
            index = [self.dataSourceArr indexOfObject:item];
            break;
        }
    }
    if (index != -1)
    {
        [self.dataSourceArr removeObjectAtIndex:index];
    }
}

/**
 视频广告信息点击回调
 */
- (void)gdt_rewardVideoAdDidClicked:(GDTRewardVideoAd *)rewardedVideoAd
{
    NSString *adid = [self.loadParams objectForKey:KTMLoadAdSourceItemId];
    NSDictionary *dict = @{KTMCallbackADID:adid,KTMCallbackState:KTMCallbackStateAdClicked};
    if (self.openCallback) {  self.openCallback(dict); }
}



/**
 视频广告播放达到激励条件回调
 */
- (void)gdt_rewardVideoAdDidRewardEffective:(GDTRewardVideoAd *)rewardedVideoAd{
}

/**
 视频广告视频播放完成
 */
- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd{
    
}


@end
