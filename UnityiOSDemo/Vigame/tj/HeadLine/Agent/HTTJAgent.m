//
//  HTTJAgent.m
//  Vigame_Test
//
//  Created by DLWX on 2018/10/25.
//  Copyright © 2018 DLWX. All rights reserved.
//

#import "HTTJAgent.h"
#import <TTTracker/TTTracker.h>

@implementation HTTJAgent
+(void)applicationLaunched{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"VigameLibrary" ofType:@"plist"];
    NSDictionary *rootDict = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSDictionary *tjDict = [rootDict objectForKey:@"statistical parameters"];
    NSString *appkey = [tjDict objectForKey:@"headline_appkey"];
    path = [[NSBundle mainBundle]pathForResource:@"Info" ofType:@"plist"];
    rootDict = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSString *appName = [rootDict objectForKey:@"CFBundleDisplayName"];
    [[TTTracker sharedInstance] setSessionEnable:NO];
    [TTTracker startWithAppID:appkey channel:@"app store" appName:appName];
}
@end
