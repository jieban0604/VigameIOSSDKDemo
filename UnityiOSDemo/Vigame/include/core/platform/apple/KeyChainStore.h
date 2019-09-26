//
//  KeyChainStore.h
//  NativeTest
//
//  Created by DLWX on 2019/5/14.
//  Copyright © 2019 DLWX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainStore : NSObject
+ (void)save:(NSString*)service data:(id)data; // 保存
+ (id)load:(NSString*)service;                 // 获取
+ (void)deleteKeyData:(NSString*)service;      // 删除
@end

NS_ASSUME_NONNULL_END
