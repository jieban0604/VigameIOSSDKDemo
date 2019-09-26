//
//  ApplePayAgent.m
//  TestProj
//
//  Created by DLWX on 2017/6/21.
//  Copyright © 2017年 DLWX. All rights reserved.
//

#import "ApplePayAgent.h"
#import "DejalActivityView.h"
#import <AdSupport/AdSupport.h>
#include "vigame_pay.h"

@interface ApplePayAgent()<SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property(nonatomic,strong)SKProduct *product;
@property(nonatomic,strong)NSDictionary *payParams;
@property(nonatomic,strong)NSString *oderIdentify;//订单ID
@property(nonatomic,strong)void (^payCallback)( NSDictionary*);
@property(nonatomic,strong)SKPaymentTransaction *transaction;
@end
static ApplePayAgent *agent = nil;
const char* jailbreak_tool_pathes[] = {
    "/Applications/Cydia.app",
    "/Library/MobileSubstrate/MobileSubstrate.dylib",
    "/bin/bash",
    "/usr/sbin/sshd",
    "/etc/apt"
};
@implementation ApplePayAgent
#pragma mark - 检测设备是否越狱
- (BOOL)isJailBreak{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://"]]) {
        return YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]) {
        return YES;
    }
    for (int i=0; i<5; i++) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_tool_pathes[i]]]) {
            return YES;
        }
    }
    return NO;
}

-(void)payWithProductId:(NSString *)productId params:(NSDictionary *)payParams callback:(void (^)(NSDictionary *))callback{
    
    if ([self isJailBreak])
    {
        //越狱设备 直接支付失败
        //1:支付失败  0:支付成功
        callback(@{@"payResult":@"1",@"payReason":@"检测到设备异常"});
        return;
    }

    if (![SKPaymentQueue canMakePayments])
    {
        //用户禁用了苹果支付功能
        callback(@{@"payResult":@"1",@"payReason":@"设备未开启苹果支付功能!"});
        return;
    }
    
    
    //发起支付请求
    self.payCallback = callback;
    self.payParams = payParams;
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topVC.presentedViewController) {topVC = topVC.presentedViewController;}
    [DejalBezelActivityView activityViewForView:topVC.view withLabel:@"Loading..."];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObjects:productId, nil]];
    request.delegate = self;
    [request start];
}

#pragma mark - 从苹果服务器获取需要购买的产品信息
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    if (response.products.count < 1)
    {
        [DejalBezelActivityView removeViewAnimated:YES];
        self.payCallback(@{@"payResult":@"1",@"payReason":@"没有可购买商品!"});
        return;
    }
    
    //商品订单信息
    self.product = [response.products firstObject];
    self.oderIdentify = self.product.productIdentifier;
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:self.product];
    //使用IDFA 作为用户名称
    payment.applicationUsername = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
#pragma mark - SKRequestDelegate 请求失败
-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [DejalBezelActivityView removeViewAnimated:YES];
    self.payCallback(@{@"payResult":@"1",
                       @"payReason":@"发送支付失败,请检测网络!"});
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                if (self.payCallback != nil) {
                    // 正常支付流程
                    self.payCallback(@{@"payResult":@"0",
                                       @"payReason":@"购买成功",
                                       @"payTradeId":tran.transactionIdentifier});
                    
                    [DejalBezelActivityView removeViewAnimated:YES];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:tran.transactionIdentifier];
                }
                break;
            default: break;
        }
    }
    
}

//监听购买结果
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions{
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                if (self.payCallback != nil) {
                    // 正常支付流程
                    // 保存Userdata用于恢复
                    NSString *payUserdata = [self.payParams objectForKey:@"payUserdata"];
                    if (payUserdata != nil) {
                        [[NSUserDefaults standardUserDefaults] setObject:payUserdata forKey:tran.transactionIdentifier];
                    }
                    
                    [[SKPaymentQueue defaultQueue] finishTransaction: tran];
                } else {
                    // 通知恢复上一次支付成功但未下发奖励的购买
                    // 更具tran.transactionIdentifier
                    NSString *productId = tran.payment.productIdentifier;
                    NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
                    NSString *feeItemCode = [[productId stringByReplacingOccurrencesOfString:bundleId withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
                    vigame::pay::FeeInfo * feeInfo = vigame::pay::PayManager::getFeeInfo();
                    vigame::pay::FeeItem * feeItem = feeInfo->getFeeItemByCode([feeItemCode UTF8String]);
                    int payId = feeItem->getID();
                    int price = feeItem->getPrice();
                    NSString *code = [NSString stringWithCString:feeItem->getCode().c_str() encoding:NSUTF8StringEncoding];
                    NSString *desc = [NSString stringWithCString:feeItem->getDesc().c_str() encoding:NSUTF8StringEncoding];
                    float giftCoinPercent = feeItem->getGiftCoinPercent();
                    self.transaction = tran;
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:@{@"payResult":@"0",
                                                                                                    @"payReason":@"购买成功",
                                                                                                    @"payId": @(payId),
                                                                                                    @"payPrice": @(price),
                                                                                                    @"payCode": code,
                                                                                                    @"payDesc": desc,
                                                                                                    @"payGiftCoinPercent": @(giftCoinPercent),
                                                                                                    @"payTradeId":tran.transactionIdentifier}];
                    
                    NSString *userData = [[NSUserDefaults standardUserDefaults] objectForKey:tran.transactionIdentifier];
                    if (userData != nil) {
                        [userInfo addEntriesFromDictionary:@{@"payUserdata":userData}];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RESTOREDATA" object:self userInfo:userInfo];

                }
            }break;
            case SKPaymentTransactionStatePurchasing:{
                NSLog(@"交易正在添加到服务器队列中。");
            }break;
            case SKPaymentTransactionStateRestored:{ NSLog(@"购买历史中恢复"); }break;
            case SKPaymentTransactionStateFailed:{
                if (self.payCallback != nil) {
                    NSLog(@"trans error = %@",tran.error.description);
                    if (tran.error.code != SKErrorPaymentCancelled)
                    {
                        self.payCallback(@{@"payResult":@"1",@"payReason":@"购买失败"});
                    }
                    else
                    {
                        self.payCallback(@{@"payResult":@"1",@"payReason":@"已取消购买"});
                    }
                    [DejalBezelActivityView removeViewAnimated:YES];
                    [[SKPaymentQueue defaultQueue] finishTransaction: tran];
                }
            }break;
            default: break;
        }
    }
}

- (void)consumableGoodsRecoveryfinishTransaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:self.transaction];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.transaction.transactionIdentifier];
    self.transaction = nil;
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
}

-(void)requestDidFinish:(SKRequest *)request{
    NSLog(@"发起支付请求完成");
}

- (instancetype)init
{
    // 只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        agent = [super init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    });
    return agent;
}


//#pragma mark - google  支付跟踪
//-(void)addGooglePaymentTracking{
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"VigameLibrary" ofType:@"plist"];
//    NSDictionary *rootDict = [[NSDictionary alloc]initWithContentsOfFile:path];
//    NSDictionary *tjDict = [rootDict objectForKey:@"Used TJ Agent"];
//    NSDictionary *googleInfos = [tjDict objectForKey:@"TJ-Google"];
//
//    NSString *price = [NSString stringWithFormat:@"%@",_product.price];
//    if ([googleInfos[@"IS_USED"] boolValue] && googleInfos) {
//        NSString *conversion_id = googleInfos[@"Conversion_ID"];
//        NSString *pay_Conversion_Label = googleInfos[@"pay_Conversion_Label"];
//        NSCAssert(pay_Conversion_Label&&![pay_Conversion_Label isEqualToString:@""], @"google 统计参数配置错误!!!");
//        [ACTConversionReporter reportWithConversionID:conversion_id label:pay_Conversion_Label value:price isRepeatable:NO];
//    }
//}
@end
