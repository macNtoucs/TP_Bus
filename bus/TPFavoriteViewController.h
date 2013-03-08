//
//  TPFavoriteViewController.h
//  bus
//
//  Created by iMac on 12/9/26.
//
//

#import <UIKit/UIKit.h>
#import <libxml/HTMLparser.h>
#import "TFHpple.h"
#import "EGORefreshTableHeaderView.h"
#import "ToolBarController.h"
#import "TPRouteDetailViewController.h"

@interface TPFavoriteViewController : UITableViewController<EGORefreshTableHeaderDelegate>{
    
    NSMutableDictionary* favoriteDic ;
    NSMutableArray* m_waitTimeResult;   // 存常用站牌的進站時間
    BOOL newSection ;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    NSDate * lastRefresh;
    ToolBarController * toolbar;
    //TPRouteDetailViewController * routeDetailController;
    int rowsNumber;
}

@property (nonatomic, retain) NSMutableDictionary* favoriteDic ;
@property (nonatomic, retain) NSMutableArray* m_waitTimeResult ;
@property (nonatomic, retain) NSDate *lastRefresh;
@property (nonatomic, retain) ToolBarController * toolbar;
//@property (nonatomic, retain) TPRouteDetailViewController * routeDetailController;
@property (nonatomic, assign) int rowsNumber;
@end

