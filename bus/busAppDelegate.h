//
//  busAppDelegate.h
//  bus
//
//  Created by mac_hero on 12/5/4.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPRootViewController.h"
#import "TWRailViewController.h"
#import "TWHSRailViewController.h"
#import "KOU_KUANGTableViewController.h"
#import "MoreViewController.h"

@class busViewController;

@interface busAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow *window;
    UINavigationController *tpRootNavController;
    UINavigationController *twRailNavController;
    UINavigationController *twhsRailNavController;
    UINavigationController *kou_kuangNavController;
    UINavigationController *moreNavController;
    TPRootViewController *tprootViewController;
    TWRailViewController *twRailViewController;
    TWHSRailViewController *twhsRailViewController;
    KOU_KUANGTableViewController *kuo_kuangTableViewController;
    MoreViewController *moreViewController;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *tpRootNavController;
@property (nonatomic, retain) UINavigationController *twRailNavController;
@property (nonatomic, retain) UINavigationController *twhsRailNavController;
@property (nonatomic, retain) UINavigationController *kou_kuangNavController;
@property (nonatomic, retain) UINavigationController *moreNavController;
@property (nonatomic, retain) TPRootViewController *tprootViewController;
@property (nonatomic, retain) TWRailViewController *twRailViewController;
@property (nonatomic, retain) TWHSRailViewController *twhsRailViewController;
@property (nonatomic, retain) KOU_KUANGTableViewController *kuo_kuangTableViewController;
@property (nonatomic, retain) MoreViewController *moreViewController;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet busViewController *viewController;

@end
