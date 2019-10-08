//
//  UnityPlaque.m
//  NativeTest
//
//  Created by DLWX on 2019/3/5.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "UnityPlaque.h"
#import "VBAdUtils.h"
#import <UnityAds/UnityAds.h>
@interface UnityPlaque()<UnityMonetizationDelegate,UMONShowAdDelegate,UnityAdsDelegate>
@property(nonatomic,strong)void (^callback)(NSDictionary *);
@property(nonatomic,strong)void (^videoLoadCallback)(NSDictionary *);
@property(nonatomic,strong)void (^videoOpenCallback)(NSDictionary *);
@property (nonatomic,strong)NSDictionary *videoLoadParams;
@property (nonatomic,strong)NSDictionary *videoOpenParams;
@property (nonatomic,strong)NSDictionary *loadParams;
@property (nonatomic,strong)NSDictionary *openParams;
@property(nonatomic,assign)BOOL firstTime;
@property(assign)BOOL isOpenVideo;
@property (strong) UMONShowAdPlacementContent* interstitialVideo;
@property(strong)NSMutableArray *sourceArr;
@property(nonatomic,assign)int loadSuccessTimes;
@end
static UnityPlaque *agent = nil;
@implementation UnityPlaque
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [super init];
        self.firstTime = true;
        self.sourceArr = [NSMutableArray arrayWithCapacity:0];
    });
    return agent;
}
//加载插屏广告
-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    NSString *adType = [param objectForKey:@"adType"];
    if ([adType isEqualToString:@"video"])
    {
        self.videoLoadCallback = cb;
        self.videoLoadParams = param;
    }
    else
    {
        self.callback = cb;
        self.loadParams = param;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:param];
        [dict setObject:@"LOAD" forKey:@"STUTE"];
        BOOL isContant = false;
        for(NSMutableDictionary *dict in self.sourceArr)
        {
            if ([[dict objectForKey:KTMLoadPlaceCodeId] isEqualToString:param[KTMLoadPlaceCodeId]] &&
                ([[dict objectForKey:@"STUTE"] isEqualToString:@"LOAD"]||[[dict objectForKey:@"STUTE"] isEqualToString:@"LOADSUCCESS"]))
            {
                isContant = true;
                break;
            }
        }
        if (isContant == false)
        {
            [self.sourceArr addObject:dict];
        }
    }
    if (self.firstTime)
    {
        NSString *appid = param[KTMLoadAdAppId];
        self.firstTime = !self.firstTime;
        [UnityMonetization initialize:appid delegate: self testMode: false];
        [UnityAds setDelegate:self];
    }
}

-(void)openVideoWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary*))callback{
    self.isOpenVideo = true;
    self.videoOpenParams = param;
    self.videoOpenCallback = callback;
    [UnityAds show:[VBAdUtils getUIViewController] placementId:self.videoLoadParams[KTMLoadPlaceCodeId]];
}

-(void)openPlaque:(NSDictionary *)param
{
    self.isOpenVideo = false;
    NSString *pAdid = [param objectForKey:KTMLoadAdSourceItemId];
    NSString *pCode = [param objectForKey:KTMLoadPlaceCodeId];
    
    for (NSMutableDictionary *itemDict in self.sourceArr)
    {
        NSString *code = [itemDict objectForKey:KTMLoadPlaceCodeId];
        NSString *adid = [NSString stringWithFormat:@"%@",[itemDict objectForKey:KTMLoadAdSourceItemId]];
        UMONShowAdPlacementContent* vAgent = [itemDict objectForKey:@"video"];
        NSString *stute = [itemDict objectForKey:@"STUTE"];
        if (![stute isEqualToString:@"LOADSUCCESS"]) {
            continue;
        }
        
        NSLog(@"%d",vAgent.ready);
        if ([pAdid isEqualToString:adid] &&
            [pCode isEqualToString:code] &&
            vAgent.ready)
        {
            [itemDict setObject:@"OPENED" forKey:@"STUTE"];
            UIViewController *vc = [VBAdUtils getUIViewController];
            [vAgent show:vc withDelegate:self];
            break;
        }
    }
}

- (void)unityAdsReady:(nonnull NSString *)placementId {
    if ([placementId isEqualToString:@"banner"]){return;}
    if (self.videoLoadParams == nil) { return;}
    
    if ([self.videoLoadParams[KTMLoadPlaceCodeId] isEqualToString:placementId])
    {
        NSDictionary *dict = @{KTMCallbackADID:self.videoLoadParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
        if (self.videoLoadCallback) {  self.videoLoadCallback(dict); }
    }
}

- (void)unityServicesDidError:(UnityServicesError)error withMessage:(nonnull NSString *)message
{
    NSLog(@"unityServicesDidError = %@",message);
}

- (void)placementContentReady:(nonnull NSString *)placementId placementContent:(nonnull UMONPlacementContent *)placementContent
{
    for (NSMutableDictionary *item in self.sourceArr)
    {
        NSString *code = [item objectForKey:KTMLoadPlaceCodeId];
        NSString *stute = [item objectForKey:@"STUTE"];
        if ([code isEqualToString:placementId]&&[stute isEqualToString:@"LOAD"])
        {
            [item setObject:@"LOADSUCCESS" forKey:@"STUTE"];
            [item setObject:(UMONShowAdPlacementContent*)placementContent forKey:@"video"];
            NSDictionary *dict = @{KTMCallbackADID:item[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateLoadSuccess};
            if (self.callback) {  self.callback(dict); }
            break;
        }
    }
}

- (void)placementContentStateDidChange:(nonnull NSString *)placementId placementContent:(nonnull UMONPlacementContent *)placementContent previousState:(UnityMonetizationPlacementContentState)previousState newState:(UnityMonetizationPlacementContentState)newState {
    NSLog(@"%s",__func__);
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state {
    if (self.isOpenVideo)
    {
        NSDictionary *dict = @{KTMCallbackADID:self.videoOpenParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateCloseSuccess};
        if (self.videoOpenCallback) {  self.videoOpenCallback(dict); }
        switch (state) {
            case kUnityAdsFinishStateCompleted:
            {
                dict = @{KTMCallbackADID:self.videoOpenParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateGiveReward};
                if (self.videoOpenCallback) {  self.videoOpenCallback(dict); }
                
            }break;
            case kUnityAdsFinishStateError|kUnityAdsFinishStateSkipped:
            {
                NSDictionary *dict = @{KTMCallbackADID:self.videoOpenParams[KTMLoadAdSourceItemId],KTMCallbackState:KTMCallbackStateOpenFail};
                if (self.videoOpenCallback) {  self.videoOpenCallback(dict); }
            }break;
                
            default:{ }break;
        }
    }
    else
    {
        for (NSDictionary *item in self.sourceArr)
        {
            NSString *code = [item objectForKey:KTMLoadPlaceCodeId];
            NSString *stute = [item objectForKey:@"STUTE"];
            if ([code isEqualToString:placementId] && [stute isEqualToString:@"OPENED"])
            {
                NSDictionary *dict = @{KTMCallbackADID:item[KTMLoadAdSourceItemId],KTMCallbackState: KTMCallbackStateCloseSuccess};
                if (self.callback) {  self.callback(dict); }
                break;
            }
        }
        
        for (NSDictionary *item in self.sourceArr)
        {
            NSString *code = [item objectForKey:KTMLoadPlaceCodeId];
            NSString *stute = [item objectForKey:@"STUTE"];
            if ([code isEqualToString:placementId] && [stute isEqualToString:@"OPENED"])
            {
                [self.sourceArr removeObject:item];
                break;
            }
        }
    }
}

- (void)unityAdsDidStart:(NSString *)placementId {
    
    if (self.isOpenVideo)
    {
        NSDictionary *dict = @{KTMCallbackADID:self.videoOpenParams[KTMLoadAdSourceItemId],KTMCallbackState: KTMCallbackStateOpenSuccess};
        if (self.videoOpenCallback) {  self.videoOpenCallback(dict); }
    }
    else
    {
        for (NSDictionary *item in self.sourceArr)
        {
            NSString *code = [item objectForKey:KTMLoadPlaceCodeId];
            NSString *stute = [item objectForKey:@"STUTE"];
            if ([code isEqualToString:placementId] && [stute isEqualToString:@"OPENED"])
            {
                NSDictionary *dict = @{KTMCallbackADID:item[KTMLoadAdSourceItemId],KTMCallbackState: KTMCallbackStateOpenSuccess};
                if (self.callback) {  self.callback(dict); }
                break;
            }
        }
    }
}

@end
