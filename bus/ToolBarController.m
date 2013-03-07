//
//  ToolBarController.m
//  bus
//
//  Created by mac_hero on 12/8/21.
//
//

#import "ToolBarController.h"
#import "TPRouteDetailViewController.h"
#import "NTRouteDetailViewController.h"
#import "TPSearchStopRouteViewController.h"
#import "AlertViewDelegate.h"
#import "TPFavoriteViewController.h"

@implementation ToolBarController
@synthesize toolbarcontroller;
@synthesize button;
@synthesize success;
@synthesize localNotif;

-(id)init{
    if (self ==[super init]) {

        toolbarcontroller = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 436, 320, 44)];
        
        toolbarcontroller.barStyle = UIBarButtonItemStyleBordered;
        toolbarcontroller.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)]){
        backgroundSupported = device.multitaskingSupported;
    }
    return self;
}

-(NSString*) fixedStringBrackets : (NSString *)oldString
{
    /*NSString* newString = [NSString new] ;
    NSRange range = [oldString rangeOfString:@")"];
    if (range.length!=0)
        return newString = [oldString substringFromIndex:range.location+1];
    else
        return oldString;*/
    NSString * newString = [NSString new];
    NSArray * newArray = [oldString componentsSeparatedByString:@"("];
    newString = [newArray objectAtIndex:0];
    NSLog(@"newString = %@", newString);
    [newArray release];
    return newString;
}

- (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
        }
    }
    
    [UIView commitAnimations];
}

- (void)showTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        NSLog(@"%@", view);
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
            
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
        }
    }
    
    [UIView commitAnimations];
}


-(void)addNotification:(NSString *)timeData RouteName:(NSString *)RouteName andStopName:(NSString *)StopName{
    
    localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil){
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:nil message:@"\n\nError"
                              delegate:nil cancelButtonTitle:@"確定"
                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    NSString *pureNumbers = [[timeData componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    
    if (![pureNumbers intValue]) {
        UIAlertView* alert = [[UIAlertView alloc]
                              initWithTitle:nil message:[NSString stringWithFormat:@"%@",timeData]
                              delegate:nil cancelButtonTitle:@"確定"
                              otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow: [pureNumbers intValue]*60];
    localNotif.timeZone = [NSTimeZone localTimeZone];
    
    
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    localNotif.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:RouteName,RouteNameKey,StopName,StopNameKey, nil];
    localNotif.alertBody = [NSString stringWithFormat:@"%@\n%@\n即將到站.....",[localNotif.userInfo objectForKey:RouteNameKey],[localNotif.userInfo objectForKey:StopNameKey]];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:nil message:[NSString stringWithFormat:@"%@\n%@\n加入通知",[localNotif.userInfo objectForKey:RouteNameKey],[localNotif.userInfo objectForKey:StopNameKey]]
                          delegate:nil cancelButtonTitle:@"確定"
                          otherButtonTitles: nil];
    [alert show];
}

-(void)removeNotificationRouteName:(NSString *)RouteName andStopName:(NSString *)StopName{
    NSArray *notificationArray = [[UIApplication sharedApplication]  scheduledLocalNotifications];
    for (UILocalNotification *row in notificationArray) {
        if ([[row.userInfo objectForKey:RouteNameKey] isEqualToString: RouteName]&&[[row.userInfo objectForKey:StopNameKey]isEqualToString:StopName]) {
            [[UIApplication sharedApplication] cancelLocalNotification:row];
        }
    }
}

-(IBAction)SaveUserDefault:(id)sender{
    int Tag = [sender tag]%1000-1;
    int section = [sender tag]/1000;
    NSUserDefaults *prefs = [[NSUserDefaults standardUserDefaults]retain];
    NSMutableArray *favoriteData;
    NSString * fixedStringStopName = [NSString new];
    NSString *RouteName;
    if (Fix) {
        NSLog(@"toolbar.m Fix tag = %i, section = %i", Tag, section);
        RouteName = [[[delegate busName] componentsSeparatedByString:@"("] objectAtIndex:0];
        //RouteName = [delegate busName];
        if([delegate isKindOfClass:[TPRouteDetailViewController class]] || [delegate isKindOfClass:[NTRouteDetailViewController class]])
        {
            favoriteData = [[NSMutableArray alloc] initWithObjects: RouteName , [[delegate IDs] objectAtIndex:Tag], nil];
            fixedStringStopName = [[delegate stops] objectAtIndex:Tag];
            NSLog(@"toolbar.m Fix str = %@", [delegate stops]);
            /*if(section == 0)
            {
                NSLog(@"toolbar.m Fix section = 0");
                favoriteData = [[NSMutableArray alloc] initWithObjects: RouteName , [[delegate goIDs] objectAtIndex:Tag], nil];
                //fixedStringStopName = [self fixedStringBrackets:[[delegate stopsGo] objectAtIndex:Tag]];
                fixedStringStopName = [[delegate stopsGo] objectAtIndex:Tag];
            }
            else
            {
                NSLog(@"toolbar.m Fix section = 1");
                favoriteData = [[NSMutableArray alloc] initWithObjects: RouteName , [[delegate backIDs] objectAtIndex:Tag], nil];
                //fixedStringStopName = [self fixedStringBrackets: [[delegate stopsBack] objectAtIndex:Tag]];
                fixedStringStopName = [[delegate stopsBack] objectAtIndex:Tag];
            }*/
        }
    }
    else if ([delegate isKindOfClass:[TPFavoriteViewController class]]){
        NSLog(@"toolbar.m else if");
        NSArray* temp = [[delegate favoriteDic] objectForKey: [[[delegate favoriteDic] allKeys] objectAtIndex:section ]];
        RouteName = [[[temp objectAtIndex:Tag*2] componentsSeparatedByString:@"("] objectAtIndex:0];
        //RouteName = [temp objectAtIndex:Tag*2];
        favoriteData = [[NSMutableArray alloc] initWithObjects:RouteName, [temp objectAtIndex:Tag*2+1],nil];
        fixedStringStopName = [[[delegate favoriteDic] allKeys] objectAtIndex:section];
    }
    else
    {
        NSLog(@"toolbar.m else");
        RouteName = [[[[delegate m_routes] objectAtIndex:Tag] componentsSeparatedByString:@"("] objectAtIndex:0];
        
        favoriteData = [[NSMutableArray alloc] initWithObjects:RouteName, [[delegate m_stopIds] objectAtIndex:Tag], nil];
        
        fixedStringStopName = [delegate thisStop];
    }
    if (ButtonMode == 1) {
        NSMutableDictionary *favoriteDictionary = [[prefs objectForKey:AlarmUserDefaultKey] mutableCopy];
        if (![prefs objectForKey:AlarmUserDefaultKey]) {
            favoriteDictionary = [ NSMutableDictionary new ];
        }
        NSMutableArray * temp = [[favoriteDictionary objectForKey:fixedStringStopName] mutableCopy];
        
        if (temp)
        {
            /*for (NSString * str in temp)
                NSLog(@"ButtonMode == 1 temp = %@", temp);*/
            NSLog(@"toolbar.m stopKey has something");
            if (![temp containsObject:RouteName])
            {
                NSLog(@"toolbar.m temp doesn't contain route");
                [temp addObjectsFromArray:favoriteData];
                //NSLog(@"temp after addObjectsFromArray= %@", temp);
                [favoriteDictionary setObject:temp forKey:fixedStringStopName];
                if([delegate isKindOfClass:[TPRouteDetailViewController class]] || [delegate isKindOfClass:[NTRouteDetailViewController class]])
                {
                    [self addNotification:[[delegate times] objectAtIndex:Tag] RouteName:RouteName andStopName:fixedStringStopName];
                    /*if(section == 0)
                        [self addNotification:[[delegate goTimes] objectAtIndex:Tag] RouteName:RouteName andStopName:fixedStringStopName];
                    else
                        [self addNotification:[[delegate backTimes] objectAtIndex:Tag] RouteName:RouteName andStopName:fixedStringStopName];*/
                }
                /*else
                {
                    [self addNotification:[[delegate m_waitTimeResult] objectAtIndex:Tag] RouteName:RouteName andStopName:fixedStringStopName];
                }*/
            }
            else
            {
                NSLog(@"toolbar.m temp contain");
                NSInteger index = [temp indexOfObject:RouteName];
                [temp removeObjectAtIndex:index];
                [favoriteDictionary setObject:temp forKey:fixedStringStopName];
                [self removeNotificationRouteName:RouteName andStopName:fixedStringStopName];
            }
        }
        else    // temp內沒東西
        {
            NSLog(@"There is nothing in temp.");
            [favoriteDictionary setObject:favoriteData forKey:fixedStringStopName];
            if([delegate isKindOfClass:[TPRouteDetailViewController class]] || [delegate isKindOfClass:[NTRouteDetailViewController class]])
            {
                [self addNotification:[[delegate times] objectAtIndex:Tag] RouteName:RouteName andStopName:fixedStringStopName];
                /*if(section == 0)
                    [self addNotification:[[delegate goTimes] objectAtIndex:Tag] RouteName:RouteName andStopName:fixedStringStopName];
                else
                    [self addNotification:[[delegate backTimes] objectAtIndex:Tag] RouteName:RouteName andStopName:fixedStringStopName];*/
            }
            else
            {
                [self addNotification:[[delegate m_waitTimeResult] objectAtIndex:Tag] RouteName:RouteName andStopName:fixedStringStopName];
            }
        }
        [prefs setObject:favoriteDictionary forKey:AlarmUserDefaultKey];
        
    }
    else if (ButtonMode==2) {
        NSMutableDictionary *favoriteDictionary = [[prefs objectForKey:FavoriteUserDefaultKey] mutableCopy];
        if (![prefs objectForKey:FavoriteUserDefaultKey]) {
            favoriteDictionary = [ NSMutableDictionary new ];
        }
        NSMutableArray* temp = [[favoriteDictionary objectForKey:fixedStringStopName] mutableCopy];
        if ( temp ){
            if (![temp containsObject:RouteName]) {
                [temp addObjectsFromArray:favoriteData];
                [favoriteDictionary setObject:temp forKey:fixedStringStopName];
            }
        }
        else{
            [favoriteDictionary setObject:favoriteData forKey:fixedStringStopName];
        }
        [prefs setObject:favoriteDictionary forKey:FavoriteUserDefaultKey];
    }
    [prefs synchronize];
    [[delegate navigationController].view addSubview:success];
    success.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];
    success.alpha = 0.0f;
    [UIView commitAnimations];
    
    if (ButtonMode==1)
    {
        //NSLog(@"saveDefault buttonmode1");
        //[self fixedStringBrackets:RouteName];
        [self isStopAdded:RouteName andStop:fixedStringStopName andNo:@"toolbar"];
    }
    else if (ButtonMode==2)
        [sender removeFromSuperview];
    
    [[delegate tableView] reloadData];
    [favoriteData release];
}


-(void) isStopAdded : (NSString*) input andStop: (NSString*)thisStop andNo:(NSString *)no
{
    //NSLog(@"no = %@", no);
    //NSLog(@"input newString = %@", input);
    //NSLog(@"input = %@, thisStop = %@", input, thisStop);
    //NSLog(@"isStopAdded");
    if (ButtonMode==0) {
        //NSLog(@"ButtonMode == 0");
        return;
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic;
    if (ButtonMode==1) {
        //NSLog(@"isStopAdded ButtonMode");
        dic = [[prefs objectForKey:AlarmUserDefaultKey] mutableCopy];
        //NSLog(@"dic = %@", dic);
    }
    else if(ButtonMode==2){
        dic = [[prefs objectForKey:FavoriteUserDefaultKey] mutableCopy];
    }
    NSMutableArray* temp;
    /*NSLog(@"thisStop = %@", thisStop);
    temp = [[dic objectForKey:thisStop] mutableCopy];
    for (NSString * str in temp)
    {
        NSLog(@"else Fix temp = %@", str);
        //input = [self fixedStringBrackets:str];
        //NSLog(@"inputYeah = %@", input);
    }*/
    if (Fix)
    {
        //temp = [[dic objectForKey:[self fixedStringBrackets:thisStop]] mutableCopy];
        temp = [[dic objectForKey:thisStop] mutableCopy];
        //for (NSString * str in temp)
            //NSLog(@"if Fix temp = %@", str);
    }
    else
    {
        temp = [[dic objectForKey:thisStop] mutableCopy];
        //for (NSString * str in temp)
            //NSLog(@"else Fix temp = %@", str);
    }
    
    if (ButtonMode == 1) {
        //NSLog(@"isStopAdded ButtonMode == 1");
        if (temp && [temp containsObject:input])
        {
            NSLog(@"input = %@", input);
            NSLog(@"toolbar.m cancel");
            [button setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
        }
    }
    else if(ButtonMode==2)
    {
        if (temp &&[temp containsObject:input])
            [button removeFromSuperview];
    }
    //NSLog(@"toolbar.m end");
}

-(UIButton *)CreateButton:(NSIndexPath *)indexPath{
    if (ButtonMode==0) {
        button = nil;
    }
    else if (ButtonMode==1){
        //NSLog(@"\n");
        //NSLog(@"toolbar.m createButton == 1");
        button = [UIButton buttonWithType:0];
        button.tag = indexPath.row+1+indexPath.section*1000;
        button.frame  = CGRectMake(275, 5, 30, 30);
        UIImage * star = [UIImage imageNamed:@"Alert.png"];
        [button setImage:star forState:UIControlStateNormal];
        button.backgroundColor =  [UIColor colorWithRed:255.0/255 green:228.0/255 blue:225.0/255 alpha:1.0];
        [button addTarget:self action:@selector(SaveUserDefault:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (ButtonMode==2) {
        button = [UIButton buttonWithType:0];
        button.tag = indexPath.row+1+indexPath.section*1000;
        button.frame  = CGRectMake(275, 5, 30, 30);
        UIImage* star = [UIImage imageNamed:@"star-button.png"];
        [button setImage:star forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(SaveUserDefault:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor =  [UIColor yellowColor];
    }
    //NSLog(@"=====%d",button.tag);
    return button;
}

- (IBAction)buttonPress:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:ButtonText1]) {
        NSLog(@"toolbar.m buttonPressed");
        ButtonMode=1;
    }
    else if ([sender.title isEqualToString:ButtonText2]){
        ButtonMode=2;
    }
    [[delegate tableView] reloadData];
}

- (IBAction)buttonPressHome:(UIBarButtonItem *)sender
{
    [[delegate navigationController] popToRootViewControllerAnimated:YES];
}

- (IBAction)buttonPressFavorite:(UIBarButtonItem *)sender
{
    AlertViewDelegate *alert = [[AlertViewDelegate alloc]init];
    [alert AlertViewStart];
    TPFavoriteViewController *favorite = [[TPFavoriteViewController alloc] initWithStyle:UITableViewStylePlain];
    favorite.title = @"常用路線";
    [[delegate navigationController] pushViewController:favorite animated:YES];
    [favorite release];
    [alert AlertViewEnd];
}

-(UIToolbar *)CreatTabBarWithNoFavorite:(BOOL) favorite delegate:(id)dele{
    delegate = dele;
    if ([delegate isKindOfClass:[TPRouteDetailViewController class]] || [delegate isKindOfClass:[NTRouteDetailViewController class]]) {
        NSLog(@"Fix = YES");
        Fix = YES;
    }
    else
    {
        //Fix = YES;
        //Fix = NO;
        NSLog(@"Fix = else");
    }
    UIBarButtonItem * barItem1 = [[UIBarButtonItem alloc] initWithTitle:ButtonText1 style:UIBarButtonItemStyleBordered target:self action:@selector(buttonPress:)];
    UIBarButtonItem * barItem3 = [[UIBarButtonItem alloc] initWithTitle:ButtonText3 style:UIBarButtonItemStyleBordered target:self action:@selector(buttonPressHome:)];
    UIBarButtonItem * barItem4 = [[UIBarButtonItem alloc] initWithTitle:ButtonText4 style:UIBarButtonItemStyleBordered target:self action:@selector(buttonPressFavorite:)];
    if (favorite) {
        [toolbarcontroller setItems:[NSArray arrayWithObjects:barItem1, nil]];
    }
    else{
        UIBarButtonItem* barItem2 = [[UIBarButtonItem alloc] initWithTitle:ButtonText2 style:UIBarButtonItemStyleBordered target:self action:@selector(buttonPress:)];
        [toolbarcontroller setItems:[NSArray arrayWithObjects:barItem1,barItem2,barItem3,barItem4, nil]];
        [barItem2 release];
    }
    [barItem1 release];
    [barItem3 release];
    [barItem4 release];
    [toolbarcontroller addSubview:[delegate view]];
    return toolbarcontroller;
}

-(void)dealloc{
    [toolbarcontroller release];
    [button release];
    [success release];
    [localNotif release];
    [super dealloc];

}

@end
