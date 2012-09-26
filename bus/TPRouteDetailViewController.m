//
//  SecondLevelViewController.m
//  TaipeiBusSystem
//
//  Created by Ching-Chi Lin on 12/7/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TPRouteDetailViewController.h"
#define kRefreshInterval 60

@implementation SecondLevelViewController

@synthesize stopsGo, stopsBack;
@synthesize busName;
@synthesize goIDs, backIDs;
@synthesize goTimes, backTimes;
@synthesize estimateArray;

@synthesize toolbar;
@synthesize anotherButton;
@synthesize success;
@synthesize lastRefresh;
@synthesize refreshTimer;

- (void) setter_departure:(NSString *) name //取得所點選的公車路線起始位置
{
    departure = name;
    NSLog(@"起始站牌 = %@", departure);
}

- (void) setter_destination:(NSString *) name   //取得所點選的公車路線終點位置
{
    destination = name;
    NSLog(@"終點站牌 = %@", destination);
}

- (void) setter_stopsGo:(NSArray *) arrayGo
{
    stopsGo = arrayGo;
}

- (void) setter_stopsBack:(NSArray *) arrayBack
{
    stopsBack = arrayBack;
}

- (void) setter_busName:(NSString *)name
{
    busName = name;
    NSLog(@"busName:%@", busName);
}

- (void) setter_estimateArray:(NSArray *)array
{
    estimateArray = array;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)CatchData
{
    NSError * error1;
    NSData * htmlData1 = [[NSString stringWithContentsOfURL:[NSURL
                                                            URLWithString: @"http://140.121.197.167/estimatetime.aspx_Command=All.xml"]
                                                  encoding:NSUTF8StringEncoding error:&error1]
                         dataUsingEncoding:NSUTF8StringEncoding];  // 得到網頁資訊
    
    TFHpple *xpathParser1 = [[TFHpple alloc] initWithHTMLData:htmlData1];
    [estimateArray removeAllObjects];
    [estimateArray addObjectsFromArray:[xpathParser1 searchWithXPathQuery:@"//estimate"]];
    
    if (!htmlData1)
    {
        UIAlertView *loadingAlertView = [[UIAlertView alloc]
                                         initWithTitle:nil message:@"當前無網路或連接伺服器失敗"
                                         delegate:nil cancelButtonTitle:@"確定"
                                         otherButtonTitles: nil];
        [loadingAlertView show];
        [loadingAlertView release];
    }
    [self estimateTime];
    [self.tableView reloadData];
}

-(void)AlertStart:(UIAlertView *) loadingAlertView{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CGRect frame = CGRectMake(120, 10, 40, 40);
    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [progressInd startAnimating];
    [loadingAlertView addSubview:progressInd];
    [loadingAlertView show];
    [progressInd release];
    [pool drain];
}

- (void)refreshPropertyList{
    self.lastRefresh = [NSDate date];
    self.navigationItem.rightBarButtonItem.title = @"Refreshing";
    UIAlertView *  loadingAlertView = [[UIAlertView alloc]
                                       initWithTitle:nil message:@"\n\nDownloading\nPlease wait..."
                                       delegate:nil cancelButtonTitle:nil
                                       otherButtonTitles: nil];
    NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(AlertStart:) object:loadingAlertView];
    [thread start];
    while (true) {
        if ([thread isFinished]) {
            break;
        }
    }
    [self CatchData];
    [loadingAlertView dismissWithClickedButtonIndex:0 animated:NO];
    [loadingAlertView release];
    [thread release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    estimateArray = [NSMutableArray new];
    
    // Refresh button & toolbar
    toolbar = [[ToolBarController alloc]init];
    [self.navigationController.view addSubview:[toolbar CreatTabBarWithNoFavorite:NO delegate:self] ];
    anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPropertyList)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    // 手動下拉更新
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view1 = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,5.0f - self.tableView.bounds.size.height,self.tableView.bounds.size.width,self.tableView.bounds.size.height)];
        view1.delegate = self;
        [self.tableView addSubview:view1];
        _refreshHeaderView = view1;
        [view1 release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    success = [[UIImageView alloc] initWithFrame:CGRectMake(75.0, 250.0, 150.0, 150.0)];
    [success setImage:[UIImage imageNamed:@"ok.png"]];
    [self refreshPropertyList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self startTimer];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [toolbar.toolbarcontroller removeFromSuperview];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopTimer];
    [super viewDidDisappear:animated];
}

- (void)startTimer
{
    self.lastRefresh = [NSDate date];
    NSDate *oneSecondFromNow = [NSDate dateWithTimeIntervalSinceNow:0];
    self.refreshTimer = [[[NSTimer alloc] initWithFireDate:oneSecondFromNow interval:1 target:self selector:@selector(countDownAction:) userInfo:nil repeats:YES] autorelease];
    [[NSRunLoop currentRunLoop] addTimer:self.refreshTimer forMode:NSDefaultRunLoopMode];
}

-(void)stopTimer
{
	if (self.refreshTimer !=nil)
	{
		[self.refreshTimer invalidate];
		self.refreshTimer = nil;
		self.anotherButton.title = @"Refresh";
	}
}

-(void) countDownAction:(NSTimer *)timer
{
    
    if (self.refreshTimer !=nil && self.refreshTimer)
	{
		NSTimeInterval sinceRefresh = [self.lastRefresh timeIntervalSinceNow];
        
        // If we detect that the app was backgrounded while this timer
        // was expiring we go around one more time - this is to enable a commuter
        // bookmark time to be processed.
        
        bool updateTimeOnButton = YES;
        
		if (sinceRefresh <= -kRefreshInterval)
		{
            [self refreshPropertyList];
			self.anotherButton.title = @"Refreshing";
            //updateTimeOnButton = NO;
		}
        
        else if (updateTimeOnButton)
        {
            int secs = (1+kRefreshInterval+sinceRefresh);
            if (secs < 0) secs = 0;
            self.anotherButton.title = [NSString stringWithFormat:@"Refresh in %d", secs];
        }
	}
}

- (void)estimateTime
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *filePath = [paths objectAtIndex:0];
    filePath = [filePath stringByAppendingString:@"/stopsNameNew.plist"];
    NSDictionary * plistData = [[NSDictionary dictionaryWithContentsOfFile:filePath] retain];
    NSLog(@"path = %@", paths);
    
    int goBack; //判斷它是go還是back
    NSArray * goValuesData = [[NSArray alloc] init];
    NSArray * backValuesData = [[NSArray alloc] init];
    goIDs = [[NSMutableArray alloc] init];
    BOOL check = FALSE;
    
    // 存取去程的ID
    for (int i =  0; i < [stopsGo count]; i ++)
    {
        goValuesData = [plistData valueForKey:[stopsGo objectAtIndex:i]];
        for (int j = 1; j < [goValuesData count]; j = j+2)
        {
            if ([[goValuesData objectAtIndex:j] isEqual:busName])
            {
                goBack = [[goValuesData objectAtIndex:j-1] intValue] % 10;
                if (goBack == 0)
                {
                    [goIDs addObject:[[NSString alloc] initWithFormat:@"%i", [[goValuesData objectAtIndex:j-1] intValue]/10]];
                    check = TRUE;
                    break;
                }
            }
        }
        if (check == FALSE)
        {
            [goIDs addObject:[[NSString alloc] initWithString:@"0"]];
        }
        check = FALSE;
    }
    
    
    backIDs = [[NSMutableArray alloc] init];
    // 存取回程的ID
    for (int i =  0; i < [stopsBack count]; i ++)
    {
        backValuesData = [plistData valueForKey:[stopsBack objectAtIndex:i]];
        for (int j = 1; j < [backValuesData count]; j = j+2)
        {
            if ([[backValuesData objectAtIndex:j] isEqual:busName])
            {
                goBack = [[backValuesData objectAtIndex:j-1] intValue] % 10;
                if (goBack == 1)
                {
                    [backIDs addObject:[[NSString alloc] initWithFormat:@"%i", [[backValuesData objectAtIndex:j-1] intValue]/10]];
                    check = TRUE;
                    break;
                }
            }
        }
        if (check == FALSE)
        {
            [backIDs addObject:[[NSString alloc] initWithString:@"0"]];
        }
        check = FALSE;
    }
    
    goTimes = [[NSMutableArray alloc] init];
    backTimes = [[NSMutableArray alloc] init];
    
    // 存取去程的進站時間
    for (int i = 0; i < [goIDs count]; i ++)
    {
        for (TFHppleElement * element in estimateArray)
        {
            if ([[goIDs objectAtIndex:i] isEqual:[element.attributes valueForKey:@"stopid"]])
            {
                [goTimes addObject:[element.attributes valueForKey:@"estimatetime"]];
                check = TRUE;
                break;
            }
        }
        if (check == FALSE)
        {
            [goTimes addObject:[[NSString alloc] initWithString:@"更新中..."]];
        }
        check = FALSE;
    }
    
    // 存取回程的進站時間
    for (int i = 0; i < [backIDs count]; i ++)
    {
        for (TFHppleElement * element in estimateArray)
        {
            if ([[backIDs objectAtIndex:i] isEqual:[element.attributes valueForKey:@"stopid"]])
            {
                [backTimes addObject:[element.attributes valueForKey:@"estimatetime"]];
                check = TRUE;
                break;
            }
        }
        if (check == FALSE)
        {
            [backTimes addObject:[[NSString alloc] initWithString:@"更新中..."]];
        }
        check = FALSE;
    }
    [goIDs retain];
    [goTimes retain];
    [backIDs retain];
    [backTimes retain];
    [plistData release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * to = @"往 ";
    if(section == 0)
        return [to stringByAppendingString:destination];
    else
        return [to stringByAppendingString:departure];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (section == 0)
        return [stopsGo count];
    else
        return [stopsBack count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSString * stopName;
    NSString * comeTime;
    
    if (indexPath.section == 0)
    {
        stopName = [stopsGo objectAtIndex:indexPath.row];
        comeTime = [goTimes objectAtIndex:indexPath.row];
    }
    else
    {
        stopName = [stopsBack objectAtIndex:indexPath.row];
        comeTime = [backTimes objectAtIndex:indexPath.row];
    }
    
    if ([comeTime isEqual:@"-1"])
    {
        cell.detailTextLabel.text = @"尚未發車";
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    else if ([comeTime isEqual:@"無此資料！"])
    {
        cell.detailTextLabel.text = @"無此資料！";
        cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:13.0/255.0 green:139.0/255.0 blue:13.0/255.0 alpha:100.0];
    }
    else if ([comeTime intValue] <= 10)
    {
        cell.detailTextLabel.text = @"進站中";
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    else if ([comeTime intValue] > 10 && [comeTime intValue] <= 120)
    {
        cell.detailTextLabel.text = @"即將進站";
        cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:255.0/255.0 green:138.0/255.0 blue:25.0/255.0 alpha:100.0];
    }
    else
    {
        cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%i 分鐘", (int)([comeTime doubleValue]/60 + 0.5)];
        cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:0.0 green:45.0/255.0 blue:153.0/255.0 alpha:100.0];
    }
    cell.textLabel.text = stopName;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    
    [[cell.contentView viewWithTag:indexPath.row+1]removeFromSuperview];
    [cell.contentView addSubview:[toolbar CreateButton:indexPath]];
    [toolbar isStopAdded:busName andStop:cell.textLabel.text];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark –
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    _reloading = YES;
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    [self CatchData];
    self.lastRefresh = [NSDate date];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}
#pragma mark –
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}
@end
