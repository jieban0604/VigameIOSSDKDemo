//
//  AdjustAgent.m
//  VigameDemo
//
//  Created by Adam on 2019/8/19.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import "AdjustAgent.h"
#import "Adjust.h"

@interface AdjustDelegate : NSObject <AdjustDelegate>

@end

@implementation AdjustDelegate

/**
 * @brief Optional delegate method that gets called when the attribution information changed.
 *
 * @param attribution The attribution information.
 *
 * @note See ADJAttribution for details.
 */
- (void)adjustAttributionChanged:(nullable ADJAttribution *)attribution {
    
}

/**
 * @brief Optional delegate method that gets called when an event is tracked with success.
 *
 * @param eventSuccessResponseData The response information from tracking with success
 *
 * @note See ADJEventSuccess for details.
 */
- (void)adjustEventTrackingSucceeded:(nullable ADJEventSuccess *)eventSuccessResponseData {
    
}
/**
 * @brief Optional delegate method that gets called when an event is tracked with failure.
 *
 * @param eventFailureResponseData The response information from tracking with failure
 *
 * @note See ADJEventFailure for details.
 */
- (void)adjustEventTrackingFailed:(nullable ADJEventFailure *)eventFailureResponseData {
    
}

/**
 * @brief Optional delegate method that gets called when an session is tracked with success.
 *
 * @param sessionSuccessResponseData The response information from tracking with success
 *
 * @note See ADJSessionSuccess for details.
 */
- (void)adjustSessionTrackingSucceeded:(nullable ADJSessionSuccess *)sessionSuccessResponseData {
    
}

/**
 * @brief Optional delegate method that gets called when an session is tracked with failure.
 *
 * @param sessionFailureResponseData The response information from tracking with failure
 *
 * @note See ADJSessionFailure for details.
 */
- (void)adjustSessionTrackingFailed:(nullable ADJSessionFailure *)sessionFailureResponseData {
    
}

/**
 * @brief Optional delegate method that gets called when a deferred deep link is about to be opened by the adjust SDK.
 *
 * @param deeplink The deep link url that was received by the adjust SDK to be opened.
 *
 * @return Boolean that indicates whether the deep link should be opened by the adjust SDK or not.
 */
- (BOOL)adjustDeeplinkResponse:(nullable NSURL *)deeplink {
    
    NSLog(@"Deferred deep link callback called!");
    NSLog(@"Deferred deep link URL: %@", [deeplink absoluteString]);
    
    return YES;
}

@end


@interface AdjustAgent ()

@property(nonatomic,strong) AdjustDelegate *delegate;

@end

static AdjustDelegate *adjustDelegate = nil;

@implementation AdjustAgent

+(void)applicationLaunched {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"VigameLibrary" ofType:@"plist"];
    NSDictionary *rootDict = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSDictionary *tjDict = [rootDict objectForKey:@"statistical parameters"];
    NSString *adjustAppToken = [tjDict objectForKey:@"adjust_appToken"];
    
    //NSString *yourAppToken = @"rm2l74uolji8";
    //test
    //NSString *environment = ADJEnvironmentSandbox;
    // Production
    NSString *environment = ADJEnvironmentProduction;

    ADJConfig *adjustConfig = [ADJConfig configWithAppToken:adjustAppToken
                                                environment:environment];
    adjustDelegate = [[AdjustDelegate alloc] init];
    [adjustConfig setDelegate:adjustDelegate];
    
    // test
    [adjustConfig setLogLevel:ADJLogLevelVerbose];  // enable all logging

    // Production
//    [adjustConfig setLogLevel:ADJLogLevelInfo];     // the default
    
    
//    [adjustConfig setLogLevel:ADJLogLevelDebug];    // enable more logging
//    [adjustConfig setLogLevel:ADJLogLevelWarn];     // disable info logging
//    [adjustConfig setLogLevel:ADJLogLevelError];    // disable warnings as well
//    [adjustConfig setLogLevel:ADJLogLevelAssert];   // disable errors as well
//    [adjustConfig setLogLevel:ADJLogLevelSuppress]; // disable all logging
    
    [Adjust appDidLaunch:adjustConfig];
    
}




@end
