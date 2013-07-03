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
@synthesize tabBarController;
@synthesize nav;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    IndexViewController *indexViewController = [[IndexViewController alloc] initWithStyle:UITableViewStyleGrouped];
        
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        NSLog(@"Recieved Notification %@",localNotif);
        NSDictionary* infoDic = localNotif.userInfo;
        NSLog(@"userInfo description=%@",[infoDic description]);
    }
    nav = [UINavigationController new];
    nav.navigationBar.tintColor = [UIColor colorWithRed:12.0/255 green:46.0/255 blue:112.0/255 alpha:1];
    [[UIBarButtonItem appearance] setTintColor: [UIColor colorWithRed:59.0/255 green:89.0/255 blue:152.0/255 alpha:1]];
    indexViewController.title = @"交通工具";
    [nav pushViewController:indexViewController animated:NO];
    [indexViewController release];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NTOUImageNameBackground]];
    [nav release];
    
    //[indexViewController release];     // 一定要這行？
    
    [_window makeKeyAndVisible];
    BOOL success;
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/stationNumber.plist"];
    
    success = [fileManager fileExistsAtPath:filePath];
    if (success) return YES;
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/stationNumber.plist"];
    success = [fileManager copyItemAtPath:path toPath:filePath error:&error];
    
    if (!success) {
        NSAssert1(0, @"Failed to copy Plist. Error %@", [error localizedDescription]);
    }
    
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
