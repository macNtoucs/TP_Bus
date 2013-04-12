//
//  TPRootViewController.h
//  bus
//
//  Created by iMac on 12/9/3.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "CellTextField.h"
#import "TPSearchTableViewController.h"
#import "TPFavoriteViewController.h"
#import "AboutMeTableViewController.h"
#import "GpsTableViewController.h"
#import "AlertViewDelegate.h"
#import "TPRouteByButtonViewController.h"   // new

@class SearchTableViewController;

@interface TPRootViewController : UITableViewController<EditableTableViewCellDelegate,MFMailComposeViewControllerDelegate,CLLocationManagerDelegate, UITabBarDelegate>{
    UITextField *_editWindow;
    CellTextField *_editCell;
    SearchTableViewController *instant_search;
    CLLocation *lastLocation;
    CLLocationManager *locationManager;
    bool isLocateFinished;
    NSArray * xpathArray;
    TFHpple * xpathParser;
    //UITabBar & UITabBarItem
    UITabBar *transTabBar;
    NSMutableArray *transTabBarItems;
    
}

@property (nonatomic, retain) CellTextField *editCell;
@property (nonatomic, retain) UITextField *editWindow;
@property (nonatomic, retain) NSArray * xpathArray;
@property (nonatomic, retain) TFHpple * xpathParser;
@property (nonatomic, retain) UITabBar *transTabBar;
@property (nonatomic, retain) NSMutableArray *transTabBarItems;

@end
