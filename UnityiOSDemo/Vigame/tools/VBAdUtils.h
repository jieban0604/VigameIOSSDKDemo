//
//  VBAdUtils.h
//  NewCandyAD
//
//  Created by walle on 11/16/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, KTMGoogleTemViewType) {
    KTMGoogleTemViewSmallType = 0,
    KTMGoogleTemViewMediumType = 1
};

extern NSString *const KTMLoadAdSourceItemId; //回调广告itemId
extern NSString *const KTMLoadPlaceCodeId; //回调广告Code
extern NSString *const KTMLoadAdAppId; //回调广告AppId
extern NSString *const KTMLoadAdAppKey; //回调广告AppKey

extern NSString *const KTMCallbackADID;
extern NSString *const KTMCallbackState;
extern NSString *const KTMCallbackStateOpenSuccess;
extern NSString *const KTMCallbackStateOpenFail;
extern NSString *const KTMCallbackStateGiveReward;
extern NSString *const KTMCallbackStateLoadSuccess;
extern NSString *const KTMCallbackStateLoadFail;
extern NSString *const KTMCallbackStateAdClicked;
extern NSString *const KTMCallbackStateAdClosed;
extern NSString *const KTMCallbackStateCloseSuccess;

extern NSString *const KTMOpenInAppStore;

@interface VBAdUtils : NSObject
+ (UIViewController*)getUIViewController;
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC;
+ (UIViewController *)getBannerViewController;

+ (CGRect)getGoogleTemFrameWithType:(KTMGoogleTemViewType)type;

+ (void)setOpenAppStore:(BOOL)flag ;

+ (BOOL)isRetinaDisplay;
+ (BOOL)isIPad;
+ (NSString*)getIdfa;
+ (NSString*)getMacAddress;
+ (NSString*)getIPAddress;
+ (NSString*)getPackageName:(NSString*) key;
+ (NSString *)getNetWorkStates;
+ (CGRect)getBannerFrame;
@end
