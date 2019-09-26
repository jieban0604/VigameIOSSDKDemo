//
//  HeadLinePlaque.m
//  VigameDemo
//
//  Created by 动能无限 on 2019/7/4.
//  Copyright © 2019 动能无限. All rights reserved.
//

#import "HeadLinePlaque.h"
#import "VBAdUtils.h"
#import <BUAdSDK/BUAdSDK.h>

@interface HeadLinePlaque () <BUInterstitialAdDelegate>

@property (nonatomic, copy) void (^loadCallback)(NSDictionary *);

@property (nonatomic, strong) NSDictionary *adParam;

@property (nonatomic, strong) BUInterstitialAd *interstitialAd;

@end

@implementation HeadLinePlaque

-(void)loadWithParam:(NSDictionary *)param callback:(void (^)(NSDictionary *))cb{
    self.loadCallback = cb;
    self.adParam = param;

    dispatch_async(dispatch_get_main_queue(), ^{
        [BUAdSDKManager setAppID:param[KTMLoadAdAppId]];
        [BUAdSDKManager setIsPaidApp:NO];

        if (self.interstitialAd==nil) {
            self.interstitialAd = [[BUInterstitialAd alloc] initWithSlotID:self.adParam[KTMLoadPlaceCodeId] size:[BUSize sizeBy:BUProposalSize_Interstitial600_600]];
            self.interstitialAd.delegate = self;
        }
        [self.interstitialAd loadAdData];
    });
    
}
-(void)openPlaque:(NSDictionary *)param{
    [self vigame_openHeadLinePlaque];
}
-(void)vigame_openHeadLinePlaque{

    if (self.interstitialAd.adValid) {

        UIViewController *controller = [VBAdUtils getBannerViewController];
        [self.interstitialAd showAdFromRootViewController:controller];
    }
    else {
        NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateOpenFail
                              };
        if (self.loadCallback) {
            self.loadCallback(dic);
        }
    }
}

#pragma mark - BUInterstitialAdDelegate

- (void)interstitialAdDidLoad:(BUInterstitialAd *)interstitialAd {
    
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadSuccess
                          };
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)interstitialAdDidClick:(BUInterstitialAd *)interstitialAd {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateAdClicked
                          };
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)interstitialAdDidClose:(BUInterstitialAd *)interstitialAd {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateCloseSuccess
                          };
    if (self.loadCallback) {
        self.loadCallback(dic);
    }

}

- (void)interstitialAd:(BUInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateLoadFail
                          };
    if (self.loadCallback) {
        self.loadCallback(dic);
    }
}

- (void)interstitialAdDidCloseOtherController:(BUInterstitialAd *)interstitialAd interactionType:(BUInteractionType)interactionType {
//    NSDictionary *dic = @{KTMCallbackADID: self.adParam[KTMLoadAdSourceItemId], KTMCallbackState: KTMCallbackStateCloseSuccess
//                          };
//    if (self.loadCallback) {
//        self.loadCallback(dic);
//    }
}

@end
