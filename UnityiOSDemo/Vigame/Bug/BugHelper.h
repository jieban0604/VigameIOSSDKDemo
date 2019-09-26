//
//  BugHelper.h
//  WYVigame
//
//  Created by DLWX on 2018/8/1.
//  Copyright © 2018年 DLWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Bugly/Bugly.h>
@interface BugHelper : NSObject
+(void)startWithCallback:(void (^)(id))callback;
@end
