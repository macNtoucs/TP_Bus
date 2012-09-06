//
//  SearchStopRouteViewController.h
//  bus
//
//  Created by mac_hero on 12/7/11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "EGORefreshTableHeaderView.h"
#import "FavoriteViewController.h"


@interface SearchStopRouteViewController : UITableViewController<EGORefreshTableHeaderDelegate>
{
    NSMutableArray *m_routesGo;
    NSMutableArray * m_routesBack;
    NSMutableArray *m_waitTime;
    NSMutableArray *m_waitTimeResultGo;
    NSMutableArray * m_waitTimeResultBack;
    NSMutableArray *input;
    EGORefreshTableHeaderView *_refreshHeaderView; 
    BOOL _reloading;
    UIBarButtonItem *anotherButton;
    NSTimer * refreshTimer;
    NSDate * lastRefresh;
    NSString *thisStop;
    UIImageView *success;
    NSArray * busTimeArray;     // All times that all buses pass the stop. 
}
@property (nonatomic, retain) NSMutableArray *m_routesGo;
@property (nonatomic, retain) NSMutableArray * m_routesBack;
@property (nonatomic, retain) NSMutableArray *m_waitTime;
@property (nonatomic, retain) NSMutableArray *m_waitTimeResultGo;
@property (nonatomic, retain) NSMutableArray * m_waitTimeResultBack;
@property (nonatomic, retain) NSMutableArray *input;
@property (nonatomic, retain) UIBarButtonItem *anotherButton;
@property (nonatomic, retain) NSTimer *refreshTimer;
@property (nonatomic, retain) NSDate *lastRefresh;
@property (nonatomic ,retain) NSString *thisStop;
@property (nonatomic, retain)UIImageView *success;
-(void)setArray : (NSMutableArray *)input_arr andStop: (NSString *)stop;
- (void)setter_estimateArray:(NSArray *)array;
@end
