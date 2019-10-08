//
//  VBAdUtil.m
//  NewCandyAD
//
//  Created by walle on 11/16/15.
//
//

#import "VBAdUtils.h"
#import <AdSupport/AdSupport.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "Reachability.h"

NSString *const KTMLoadAdSourceItemId = @"adSourceItemid";
NSString *const KTMLoadPlaceCodeId = @"placeCodeid";
NSString *const KTMLoadAdAppId = @"ad_appid";
NSString *const KTMLoadAdAppKey = @"app_key";

NSString *const KTMCallbackADID = @"ADID";
NSString *const KTMCallbackState = @"STATE";
NSString *const KTMCallbackStateGiveReward =@"GIVE_REWARD" ;
NSString *const KTMCallbackStateOpenSuccess = @"OPEN_SUCCESS";
NSString *const KTMCallbackStateOpenFail = @"OPEN_FAIL";
NSString *const KTMCallbackStateLoadSuccess = @"LOAD_SUCCESS";
NSString *const KTMCallbackStateLoadFail = @"LOAD_FAIL";
NSString *const KTMCallbackStateAdClicked = @"AD_CLICKED";
NSString *const KTMCallbackStateAdClosed = @"AD_CLOSED";
NSString *const KTMCallbackStateCloseSuccess = @"CLOSE_SUCCESS";

NSString *const KTMOpenInAppStore = @"OpenInAppStore";
@implementation VBAdUtils

+ (UIViewController *)getBannerViewController {
    UIViewController *bannerVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    return bannerVc;
}

+ (UIViewController*)getUIViewController{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [VBAdUtils getCurrentVCFrom:rootViewController];
    return currentVC;
}
+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]])
    {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    }
    else if ([rootVC isKindOfClass:[UINavigationController class]])
    {
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else
    {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

+ (void)setOpenAppStore:(BOOL)flag {
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:KTMOpenInAppStore];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isRetinaDisplay{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        return YES;
    } else {
        // non-Retina display
        return NO;
    }
}

+ (BOOL)isIPad{
    NSString *  nsStrIpad=@"iPad";
    
    NSString* deviceType = [UIDevice currentDevice].model;
    //NSLog(@"deviceType = %@", deviceType);
    
    NSRange range = [deviceType rangeOfString:nsStrIpad];
    return range.location != NSNotFound;
}

+ (NSString*)getIdfa{
    NSString *uuid;
    int ver = [[[UIDevice currentDevice] systemVersion] intValue];
    if(ver >= 7)
    {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        uuid = [def objectForKey:@"USER_IDENTIFY"];
        if (uuid == nil||[uuid isEqualToString:@""])
        {
            CFUUIDRef puuid = CFUUIDCreate(nil);
            CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
            NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
            NSMutableString *tmpResult = result.mutableCopy;
            NSRange range = [tmpResult rangeOfString:@"-"];
            while (range.location != NSNotFound) {
                [tmpResult deleteCharactersInRange:range];
                range = [tmpResult rangeOfString:@"-"];
            }
            [def setObject:tmpResult forKey:@"USER_IDENTIFY"];
            uuid = tmpResult;
            NSLog(@"UUID:%@",tmpResult);
        }
    }
    else
    {
        uuid = [VBAdUtils getMacAddress];
    }
    
    return uuid;
}


+(NSString*)getMacAddress{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = (char*)malloc(len)) == NULL)
    {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    char tmp[64] = {0};
    sprintf(tmp,"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5));
    
    free(buf);
    
    return [NSString stringWithCString:tmp encoding:NSUTF8StringEncoding];
    
    
}

+ (NSString*)getIPAddress{
    NSString *address = @"an error occurred when obtaining ip address";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) { // 0 表示获取成功
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET||temp_addr->ifa_addr->sa_family == AF_INET6) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);  
    
    //NSLog("IPAddress @%",address);
    return address;
}

+ (NSString*)getPackageName:(NSString*) key{
    
    //NSString *nskey = [NSString stringWithUTF8String:"CFBundleIdentifier"];
    NSString *value = NULL;
    value = [[[NSBundle mainBundle] infoDictionary] objectForKey:key ];
    return value;
}

+ (NSString *)getNetWorkStates{
    Reachability * r = [Reachability reachabilityWithHostName : @"www.apple.com"];
    switch ([r currentReachabilityStatus])
    {
        case NotReachable:{ return @"未联网";}
        case ReachableViaWWAN:{ return @"4G网络";}
        case ReachableViaWiFi:{ return @"WIFI网络";}
    }
}

+(void)getNetWorkStatesCallback:(void(^)(NSString *))callback{
    callback([VBAdUtils getNetWorkStates]);
}

+ (CGRect)getBannerFrame{
     CGRect rx = [[UIScreen mainScreen] bounds];
    if([VBAdUtils isIPad]){
        float adHeight = 90;
        float adWidth = 576;
        float adPosX = (rx.size.width - adWidth) / 2;
        float adPosY = rx.size.height - adHeight;
        return CGRectMake(adPosX, adPosY, adWidth, adHeight);
    }
    else{
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            float adHeight = rx.size.width / 320.0f * 50;
            float adWidth = rx.size.width;
            float adPosX = (rx.size.width - adWidth) / 2;
            float adPosY = rx.size.height - adHeight;
            return CGRectMake(adPosX, adPosY, adWidth, adHeight);
        }else {
            float adHeight = 50;
            float adWidth = 320;
            float adPosX = (rx.size.width - adWidth) / 2;
            float adPosY = rx.size.height - adHeight;
            return CGRectMake(adPosX, adPosY, adWidth, adHeight);
        }
    }
}

+ (CGRect)getGoogleTemFrameWithType:(KTMGoogleTemViewType)type{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (type == KTMGoogleTemViewSmallType) {
        if ((NSInteger)size.width==320) {
            float adHeight = 91;
            float adWidth = 320;
            float adPosX = (size.width - adWidth) / 2;
            float adPosY = size.height - adHeight;
            return CGRectMake(adPosX, adPosY, adWidth, adHeight);
        }
        float adHeight = 91;
        float adWidth = 355;
        float adPosX = (size.width - adWidth) / 2;
        float adPosY = size.height - adHeight;
        return CGRectMake(adPosX, adPosY, adWidth, adHeight);
    }
    if (type == KTMGoogleTemViewMediumType) {
        if ((NSInteger)size.width==320) {
            float adHeight = 325;
            float adWidth = 320;
            float adPosX = (size.width - adWidth) / 2;
            float adPosY = (size.height - adHeight)/2;
            return CGRectMake(adPosX, adPosY, adWidth, adHeight);
        }
        float adHeight = 375;
        float adWidth = 355;
        float adPosX = (size.width - adWidth) / 2;
        float adPosY = (size.height - adHeight)/2;
        return CGRectMake(adPosX, adPosY, adWidth, adHeight);
    }
    return CGRectZero;
}

+(void)getProjectid{
   
}
@end
