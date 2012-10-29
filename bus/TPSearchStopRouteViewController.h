//
//  TPSearchStopRouteViewController.h
//  bus
//
//  Created by iMac on 12/10/17.
//
//
#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "EGORefreshTableHeaderView.h"
#import "TPFavoriteViewController.h"


@interface SearchStopRouteViewController : UITableViewController<EGORefreshTableHeaderDelegate>
{
    NSArray * m_routes;
    NSArray * m_stopIds;
    NSArray * m_waitTimeResult;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    UIBarButtonItem * anotherButton;
    NSTimer * refreshTimer;
    NSDate * lastRefresh;
    NSString * thisStop;
    UIImageView * success;
    ToolBarController *  toolbar;
}
@property (nonatomic, retain) NSArray * m_routes;
@property (nonatomic, retain) NSArray * m_stopIds;
@property (nonatomic, retain) NSArray * m_waitTimeResult;
@property (nonatomic, retain) UIBarButtonItem * anotherButton;
@property (nonatomic, retain) NSTimer * refreshTimer;
@property (nonatomic, retain) NSDate * lastRefresh;
@property (nonatomic ,retain) NSString * thisStop;
@property (nonatomic, retain) UIImageView * success;
@property (nonatomic, retain) ToolBarController *  toolbar;

-(void)setSelectedStop: (NSString *)stop;
@end
