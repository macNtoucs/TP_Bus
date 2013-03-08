//
//  TPSearchStopRouteViewController.m
//  bus
//
//  Created by iMac on 12/9/5.
//
//

#import "TPSearchStopRouteViewController.h"

#define kRefreshInterval 60

@implementation SearchStopRouteViewController

@synthesize thisStop;   // plist 的 key（站名）

@synthesize m_routes;           // 所有路線名稱
@synthesize m_waitTimeResult;   // 由 stopID 所取得的「所有進站資訊」

@synthesize anotherButton;
@synthesize refreshTimer;
@synthesize lastRefresh;
@synthesize success;
@synthesize toolbar;

// 上層呼叫（TPSearchTableViewController）
-(void)setSelectedStop: (NSString *)stop
{
    thisStop = [[NSString alloc] initWithString:stop];
}

-(id)init{
    [super init];
    m_routes = [NSArray new];
    m_waitTimeResult = [NSArray new];
    m_stopIds = [NSArray new];
    return self;
}

-(void)CatchData
{
    NSMutableString *encodedStop = (NSMutableString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)thisStop, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    NSString *strURL = [NSString stringWithFormat:@"http://140.121.91.62/SearchStopPhpFile.php?stop=%@", encodedStop];
    
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    NSString *strResult = [[[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding]autorelease];
    
    NSArray * route_time = [strResult componentsSeparatedByString:@";"];
    m_routes = [[route_time objectAtIndex:0] componentsSeparatedByString:@"|"];
    m_stopIds = [[route_time objectAtIndex:1] componentsSeparatedByString:@"|"];
    m_waitTimeResult = [[route_time objectAtIndex:2] componentsSeparatedByString:@"|"];
    
    [m_routes retain];
    [m_stopIds retain];
    [m_waitTimeResult retain];
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
    UIAlertView * loadingAlertView = [[UIAlertView alloc]
                                       initWithTitle:nil message:@"\n\nDownloading\nPlease wait"
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

- (void)startTimer
{
    self.lastRefresh = [NSDate date];
    NSDate *oneSecondFromNow = [NSDate dateWithTimeIntervalSinceNow:0];
    self.refreshTimer = [[[NSTimer alloc] initWithFireDate:oneSecondFromNow interval:1 target:self selector:@selector(countDownAction:) userInfo:nil repeats:YES] autorelease];
    [[NSRunLoop currentRunLoop] addTimer:self.refreshTimer forMode:NSDefaultRunLoopMode];
	
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

#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPropertyList)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    toolbar = [[ToolBarController alloc]init];
    [self.navigationController.view addSubview:[toolbar CreatTabBarWithNoFavorite:NO delegate:self] ];
    
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.view addSubview:toolbar.toolbarcontroller];
    [self.toolbar hideTabBar:self.tabBarController];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];
    if (![m_waitTimeResult count]) {
        [self CatchData];
    }
    [self.tableView reloadData];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [toolbar.toolbarcontroller removeFromSuperview];
    [self.toolbar showTabBar: self.tabBarController];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopTimer];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc
{
    [m_routes release];
    [m_waitTimeResult release];
    [m_stopIds release];
    
    [anotherButton release];
    [refreshTimer release];
    [lastRefresh release];
    [thisStop release];
    [success release];
    
    [super dealloc];
}

#pragma mark - Table view data source

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(IBAction)favorite:(id)sender{
    
    UIButton * button = (UIButton *) sender;
    int Tag = button.tag;
    NSUserDefaults *prefs = [[NSUserDefaults standardUserDefaults]retain];
    NSMutableArray *favoriteData = [[NSMutableArray alloc] initWithObjects:[m_routes objectAtIndex:Tag], [m_stopIds objectAtIndex:Tag],nil];
    NSMutableDictionary *favoriteDictionary = [[prefs objectForKey:@"userTP"] mutableCopy];
    if (![prefs objectForKey:@"userTP"]) {
        favoriteDictionary = [ NSMutableDictionary new ];
    }
    NSMutableArray* temp = [[favoriteDictionary objectForKey:thisStop] mutableCopy];
    if (temp){
        if (![temp containsObject:[m_routes objectAtIndex:Tag]]) {
            [temp addObjectsFromArray:favoriteData];
            [favoriteDictionary setObject:temp forKey:thisStop];
        }
    }
    else{
        [favoriteDictionary setObject:favoriteData forKey:thisStop];
    }
    
    [prefs setObject:favoriteDictionary forKey:@"userTP"];
    [prefs synchronize];
    [self.navigationController.view addSubview:success];
    success.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0f];
    success.alpha = 0.0f;
    [UIView commitAnimations];
    [button removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [m_routes count];
}

/*-(BOOL) isStopAdded : (NSString*) inputStr
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [[prefs objectForKey:@"userTP"] mutableCopy];
    NSMutableArray* temp = [[dic objectForKey:thisStop] mutableCopy];
    for (NSString * str in temp)
        NSLog(@"SearchStop.m temp = %@", str);
    if ( temp ){
        if (![temp containsObject:inputStr]) {
            return false;
        }
        else return true;
    }
    else return false;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    NSString * busName = [[NSString alloc] init];
    NSString * comeTime = [[NSString alloc] init];
    
    if (indexPath.row == [m_routes count]-1)
    {
        [cell.contentView removeFromSuperview];
    }
    else
    {
        busName = [m_routes objectAtIndex:indexPath.row];
        comeTime = [m_waitTimeResult objectAtIndex:indexPath.row];
        
        if ([comeTime isEqual:@"-1"])
        {
            cell.detailTextLabel.text = @"尚未發車";
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        else if ([comeTime isEqual:@"更新中..."])
        {
            cell.detailTextLabel.text = @"更新中...";
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
    }
    
    cell.textLabel.text = busName;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    
    [[cell.contentView viewWithTag:indexPath.row+1] removeFromSuperview];
    [cell.contentView addSubview:[toolbar CreateButton:indexPath]];
    NSString * newString = [[cell.textLabel.text componentsSeparatedByString:@"("] objectAtIndex:0];
    [toolbar isStopAdded:newString andStop:thisStop andNo:@"SearchStopRoute"];
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
     [detailViewController release];
     */
}

#pragma mark –
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    _reloading = YES;
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    [self.tableView reloadData];
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

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}
@end
