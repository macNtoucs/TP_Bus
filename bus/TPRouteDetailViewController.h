//
//  TPRouteDetailViewController.h
//  bus
//
//  Created by iMac on 12/9/5.
//
//
//
//  SecondLevelViewController.h
//  TaipeiBusSystem
//
//  Created by Ching-Chi Lin on 12/7/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "ToolBarController.h"
#import "EGORefreshTableHeaderView.h"

@interface SecondLevelViewController : UITableViewController<EGORefreshTableHeaderDelegate>
{
    NSString * departure;   // 存起始站牌名稱
    NSString * destination; // 存終點站牌名稱
    NSArray * stopsGo;
    NSArray * stopsBack;
    NSString * busName; // 存取公車名稱
    NSMutableArray * goIDs; // 存放去程(goBack = 0)的ID
    NSMutableArray * backIDs;   // 存放回程(goBack = 1)的ID
    NSMutableArray * goTimes;   // 存放去程(goBack = 0)的進站時間
    NSMutableArray * backTimes; // 存放回程(goBack = 1)的進站時間
    NSMutableArray * estimateArray;    // 存放所有進站時間
    
    ToolBarController* toolbar;
    UIBarButtonItem *anotherButton;
    EGORefreshTableHeaderView *_refreshHeaderView; // 手動下拉更新
    UIImageView * success;
    NSDate * lastRefresh;
    NSTimer * refreshTimer; // 倒數計時
    BOOL _reloading;
}

@property (nonatomic, retain) NSArray * stopsGo;
@property (nonatomic, retain) NSArray * stopsBack;
@property (nonatomic, retain) NSString * busName;
@property (nonatomic, retain) NSMutableArray * goIDs;
@property (nonatomic, retain) NSMutableArray * backIDs;
@property (nonatomic, retain) NSMutableArray * goTimes;
@property (nonatomic, retain) NSMutableArray * backTimes;
@property (nonatomic, retain) NSMutableArray * estimateArray;
@property (nonatomic, retain) ToolBarController* toolbar;

@property (nonatomic, retain) UIBarButtonItem *anotherButton;
@property (nonatomic, retain) UIImageView * success;
@property (nonatomic, retain) NSDate *lastRefresh;
@property (nonatomic, retain) NSTimer *refreshTimer;

- (void) setter_departure:(NSString *) name;    // 取得所點選的公車路線起始位置
- (void) setter_destination:(NSString *) name;  // 取得所點選的公車路線終點位置
- (void) setter_stopsGo:(NSArray *) arrayGo;
- (void) setter_stopsBack:(NSArray *) arrayBack;
- (void) estimateTime; // 抓取公車進站時間
- (void) setter_busName:(NSString *) name; // 取得公車名稱
- (void) setter_estimateArray:(NSArray *) array;

- (void)reloadTableViewDataSource;

@end

