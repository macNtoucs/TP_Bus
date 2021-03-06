//
//  busAppDelegate.m
//  bus
//
//  Created by mac_hero on 12/5/4.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "busAppDelegate.h"
#import "TPRootViewController.h"

@implementation busAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize tpRootNavController;
@synthesize twRailNavController;
@synthesize twhsRailNavController;
@synthesize kou_kuangNavController;
@synthesize moreNavController;
@synthesize tprootViewController;
@synthesize twRailViewController;
@synthesize twhsRailViewController;
@synthesize kuo_kuangTableViewController;
@synthesize moreViewController;
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    tabBarController = [[UITabBarController alloc] init];
    
    tpRootNavController = [[UINavigationController alloc] init];
    tprootViewController = [[TPRootViewController alloc] initWithStyle:UITableViewStyleGrouped];
    tpRootNavController.tabBarItem.title = @"公車";
    tprootViewController.navigationItem.title = @"北北基公車動態系統";
    tpRootNavController.viewControllers = [NSArray arrayWithObjects:tprootViewController, nil];
    
    twRailNavController = [[UINavigationController alloc] init];
    twRailViewController = [[TWRailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    twRailNavController.tabBarItem.title = @"台鐵";
    twRailViewController.navigationItem.title = @"台鐵乘車資訊";
    twRailNavController.viewControllers = [NSArray arrayWithObjects:twRailViewController, nil];
    twRailViewController.navigationController.navigationBarHidden = NO;
    twRailViewController.navigationItem.hidesBackButton = YES;
    
    twhsRailNavController = [[UINavigationController alloc] init];
    twhsRailViewController = [[TWHSRailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    twhsRailNavController.tabBarItem.title = @"高鐵";
    twhsRailViewController.navigationItem.title = @"高鐵乘車資訊";
    twhsRailNavController.viewControllers = [NSArray arrayWithObjects:twhsRailViewController, nil];
    
    kou_kuangNavController = [[UINavigationController alloc] init];
    kuo_kuangTableViewController = [[KOU_KUANGTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    kou_kuangNavController.tabBarItem.title = @"國光";
    kuo_kuangTableViewController.navigationItem.title = @"國光客運資訊";
    kou_kuangNavController.viewControllers = [NSArray arrayWithObjects:kuo_kuangTableViewController, nil];
    
    moreNavController = [[UINavigationController alloc] init];
    moreViewController = [[MoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
    moreNavController.tabBarItem.title = @"更多";
    moreViewController.navigationItem.title = @"更多";
    moreNavController.viewControllers = [NSArray arrayWithObjects:moreViewController, nil];
    
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:tpRootNavController, twRailNavController, twhsRailNavController,kou_kuangNavController , moreNavController, nil];
    
    [tprootViewController release];
    [twRailViewController release];
    [twhsRailViewController release];
    [kuo_kuangTableViewController release];
    [moreViewController release];
    
    //tabBarController.viewControllers = [NSArray arrayWithObjects:navController, viewController2, viewController3, viewController4, viewController5, nil];
    
    
    UIView *backgroundView = [[UIView alloc] initWithFrame: _window.frame];
    backgroundView.alpha = 0.7f;
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BGP.png"]];
    [_window addSubview:backgroundView];
    [backgroundView release];
    
    /*TPRootViewController *root = [[TPRootViewController alloc] initWithStyle:UITableViewStyleGrouped];
    root.view.backgroundColor = [UIColor clearColor];
    
   
    UINavigationController *nav = [UINavigationController new];
    root.title = @"北北基公車動態系統";
    [nav pushViewController:root animated:NO];
    [root release];
    self.window.rootViewController = nav;
    [nav release];
    root.view.backgroundColor = [UIColor clearColor];*/
    //[self.window makeKeyAndVisible];
    
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        NSLog(@"Recieved Notification %@",localNotif);
        NSDictionary* infoDic = localNotif.userInfo;
        NSLog(@"userInfo description=%@",[infoDic description]);
    }
    
    [_window setRootViewController:tabBarController];
    
    [tabBarController release];     // 一定要這行？
    
    [_window makeKeyAndVisible];
    /*BOOL success;
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *filePath = [documentsDirectory stringByAppendingString:@"/stopsNameNew.plist"];
    
    success = [fileManager fileExistsAtPath:filePath];
    if (success) return YES;
    
    //NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/stopsNameNew.plist"];
    success = [fileManager copyItemAtPath:path toPath:filePath error:&error];
    
    if (!success) {
        NSAssert1(0, @"Failed to copy Plist. Error %@", [error localizedDescription]);
    }*/
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    if ( ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) ||
        ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)      ) {
        // isInBackground = YES;
        //  ------ UI not available
    }
    else {

        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:nil message:[NSString stringWithFormat:@"即將到站"]
                              delegate:nil cancelButtonTitle:@"確定"
                              otherButtonTitles: nil];
        [alert show];
        application.applicationIconBadgeNumber = 0;
        [application cancelAllLocalNotifications];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
