
//
//  ViewController.m
//  VigameDemo
//
//  Created by 动能无限 on 2019/7/3.
//  Copyright © 2019 动能无限. All rights reserved.
//

#import "ViewController.h"
#import "AdCell.h"
#import "IOSLoader.h"
#import "GDTSDKConfig.h"
#import <AdSupport/AdSupport.h>
#import "Reachability.h"
#import <UnityAds/UnityAds.h>
#import <IronSource/IronSource.h>
#import <BUAdSDK/BUAdSDK.h>
#import <MTGSDK/MTGSDK.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, BUNativeExpressBannerViewDelegate>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) BUNativeExpressBannerView *bannerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Headline Version=%@,Unity Version=%@,Google Version=%@,GDT Version=%@,Irons Version=%@,Mobvisra Version =%@",[BUAdSDKManager SDKVersion],[UnityAds getVersion],[GADRequest sdkVersion],[GDTSDKConfig sdkVersion],[IronSource sdkVersion],@"5.7.1");
   NSString *idfa =[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    //[IOSLoader tj_payWithMoney:6.00 productId:@"xxx.xxx.xxx" number:60 price:60];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AdCellArray" ofType:@"plist"];
    
    self.dataSource = [NSArray arrayWithContentsOfFile:filePath];
    
    self.tableview.bounces = NO;
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([AdCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AdCell class])];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [IOSLoader openBanner];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.dataSource[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
     
//        [IOSLoader openBrowser];
        __weak typeof(self) weakSelf = self;
        [IOSLoader openAd:@"pause" adCallback:^(BOOL flag, KTMADType type) {
        }];
       
        //return;
    }
    if (indexPath.row == 1) {
        __weak typeof(self) weakSelf = self;
        
        if (![IOSLoader isAdReady:@"rotary_mfzs"]) {
            
            NSString *msg = @"暂无准备好广告";
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:cancelAction];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf presentViewController:alert animated:NO completion:nil];
            });
            NSLog(@"rotary_mfzs is not ready");
           return;
        }
       
        [IOSLoader openAd:@"rotary_mfzs" adCallback:^(BOOL flag, KTMADType type) {
            if (type == KTMADTypeVideo) {
                
                NSString *msg = [NSString stringWithFormat:@"%@",flag?@"发放奖励":@"不发奖励"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alert addAction:cancelAction];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf presentViewController:alert animated:NO completion:nil];
                });
            }
        }];
        
        //return;
    }
    if (indexPath.row == 2) {

        [IOSLoader tj_name:@"111"];
        [IOSLoader tj_name:@"222" value:@"Level5"];
        //return;
    }
    if (indexPath.row == 3) {
        [IOSLoader openYSBanner:@"yuans" rect:CGRectMake(50, 20, 300, 150)];
        //return;
    }
    if (indexPath.row == 4) {
        [IOSLoader closeBanner];
        //return;
    }
    if (indexPath.row == 5) {
        [IOSLoader closeYSBanner:@"yuans"];
        //return;
    }
    if (indexPath.row == 6) {
        [IOSLoader textPayWithProductId:2003 callBack:^(NSDictionary *dic) {
            if ([dic[@"reasonCode"] integerValue] == 0) {
                //购买成功
            }
        }];
    }
    if (indexPath.row == 7) {
        //补发道具
        [IOSLoader payConsumableGoodsRecoveryCallBack:^(NSDictionary * dic) {
            //补发道具

            //补发成功调用接口
            [IOSLoader payConsumableGoodsRecoveryFinish];
        }];
    }
}
#pragma mark - getter

- (NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSArray array];
    }
    return _dataSource;
}
@end
