//
//  RouteDetailViewController.m
//  bus
//
//  Created by mac_hero on 12/5/18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RouteDetailViewController.h"
#import "UIKit+NTOUAdditions.h"
#define kPlainId				@"Plain"
#define kRefreshInterval 60



@implementation RouteDetailViewController
@synthesize item;
@synthesize waitTime;
@synthesize  waitTime1_103;
@synthesize waitTime2_103;
@synthesize waitTime1_104;
@synthesize waitTime2_104;
@synthesize station_waitTime1_103;
@synthesize station_waitTime1_104;
@synthesize station_waitTime2_103;
@synthesize station_waitTime2_104;
@synthesize anotherButton;
@synthesize refreshTimer;
@synthesize lastRefresh;
@synthesize receivedData;
@synthesize theConncetion;
@synthesize queue;
- (void) getURL:(NSString* ) inputURL
{
   
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.tableView applyStandardColors];
        // Custom initialization
    }
    theConncetionCount = 0;
    updateTimeOnButton = NO;
    item = [NSMutableArray new];
    queue = [[NSOperationQueue alloc] init];
    waitTime = [NSMutableArray new];
    return self;
}

-(void) addRoutesURL:(NSString *)_103First and:(NSString *)_103Second and:(NSString *)_104First and:(NSString *)_104Second{
    if (_103First){
        waitTime1_103 = [[NSURL alloc ]initWithString:_103First];
        [waitTime  addObject:waitTime1_103 ];
    }
    if (_103Second){
        waitTime2_103 = [[NSURL alloc ]initWithString:_103Second];
        [ waitTime  addObject:waitTime2_103 ];
    }
    if (_104First){
        waitTime1_104 = [[NSURL alloc ]initWithString:_104First];
        [ waitTime  addObject:waitTime1_104 ];
    }
    if (_104Second){
        waitTime2_104 = [[NSURL alloc ]initWithString:_104Second];
        [ waitTime  addObject:waitTime2_104 ];
    }
}
-(void) addStationURL:(NSString *)_103First and:(NSString *)_103Second and:(NSString *)_104First and:(NSString *)_104Second{
    station_waitTime1_103 = [[NSURL alloc]initWithString:_103First];
    station_waitTime2_103 = [[NSURL alloc]initWithString:_103Second];
    station_waitTime1_104 = [[NSURL alloc]initWithString:_104First];
    station_waitTime2_104 = [[NSURL alloc]initWithString:_104Second];
    [waitTime addObject:station_waitTime1_103];
    [waitTime addObject:station_waitTime2_103];
    [waitTime addObject:station_waitTime1_104];
    [waitTime addObject:station_waitTime2_104];
}

-(void)goBackMode:(BOOL)go{
       dir = go;
} 
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


-(void)CatchData{
    [item removeAllObjects];
    for (id obj in waitTime){
        if (queue) {
            NSURLRequest* request = [NSURLRequest requestWithURL:obj cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0];
            RequestOperation* operation = [[RequestOperation alloc] initWithRequest:request];
            operation.RequestDelegate = self;
            [operation start];
            [operation autorelease];
            [queue addOperation:operation];
            NSLog(@"%@",[queue operations]);
        }
        /*NSURLRequest *urlRequest = [NSURLRequest requestWithURL:obj];
        theConncetion=[[NSURLConnection alloc]initWithRequest:urlRequest delegate:self];*/
               
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
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }
    self.anotherButton.title = @"更新中";
    updateTimeOnButton = NO;
    loadingAlertView = [[UIAlertView alloc]
                        initWithTitle:nil message:@"\n\n下載中\n請稍候"
                        delegate:self cancelButtonTitle:@"取消"
                        otherButtonTitles: nil];
    [self AlertStart:loadingAlertView];
    /*NSThread*thread = [[NSThread alloc]initWithTarget:self selector:@selector(AlertStart:) object:loadingAlertView];
    [thread start];
    while (true) {
        if ([thread isFinished]) {
            break;
        }
    }*/
    double interval = 1.0;
    [NSTimer scheduledTimerWithTimeInterval:interval
                                     target:self
                                   selector:@selector(CatchData)
                                   userInfo:nil
                                    repeats:FALSE];


    //[thread release];
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
        if (!updateTimeOnButton) {
            return;
        }
		else if (sinceRefresh <= -kRefreshInterval)
		{
            
            [self refreshPropertyList];
		}
        
        else
        {
            int secs = (1+kRefreshInterval+sinceRefresh);
            if (secs < 0) secs = 0;
            self.anotherButton.title = [NSString stringWithFormat:@"%d 秒後更新", secs];
            
        }
	}
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex==0) {
        NSLog(@"%@",[queue operations]);
        [queue cancelAllOperations];
        queue = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad
{
    loadingAlertView = [[UIAlertView alloc]
                        initWithTitle:nil message:@"\n\n下載中\n請稍候"
                        delegate:self cancelButtonTitle:@"取消"
                        otherButtonTitles: nil];
    [self AlertStart:loadingAlertView];
    [super viewDidLoad];
    anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"更新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPropertyList)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    //[anotherButton release];
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view1 = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,5.0f - self.tableView.bounds.size.height,self.tableView.bounds.size.width,self.tableView.bounds.size.height)];
        view1.delegate = self;
        [self.tableView addSubview:view1];
        _refreshHeaderView = view1;
        [view1 release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}

-(void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    double interval = 1.0;
    [NSTimer scheduledTimerWithTimeInterval:interval
                                     target:self
                                   selector:@selector(CatchData)
                                   userInfo:nil
                                    repeats:FALSE];
    
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /*dispatch_queue_t network = dispatch_get_specific("");
    dispatch_async(network, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_release(network);
        });
    });*/
    //dispatch_release(network);
}

-(void)stopTimer
{
	if (self.refreshTimer !=nil)
	{
		[self.refreshTimer invalidate];
		self.refreshTimer = nil;
		self.anotherButton.title = @"更新";
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopTimer];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [item release];
    [super dealloc];
}


#pragma mark - connected

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Did Receive Response %@", response);
    receivedData = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //NSLog(@"Did Receive Data %@", data);
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    UIAlertView * AlertView;
    theConncetionCount++;
    if ([waitTime count]==theConncetionCount) {
        if (loadingAlertView) {
            [loadingAlertView dismissWithClickedButtonIndex:0 animated:NO];
            [loadingAlertView release];
            loadingAlertView = nil;
        }
        if (error) {
            AlertView = [[UIAlertView alloc] initWithTitle:nil message:@"無法連接伺服器\n或無網路連線"
                                                  delegate:nil cancelButtonTitle:@"確定"
                                         otherButtonTitles: nil];
            [AlertView show];
        }
        else{
            AlertView = [[UIAlertView alloc] initWithTitle:nil message:@"無法連接伺服器\n或無網路連線"
                                                  delegate:nil cancelButtonTitle:@"確定"
                                         otherButtonTitles: nil];
            [AlertView show];
        }
        self.lastRefresh = [NSDate date];
        theConncetionCount=0;
        updateTimeOnButton = YES;
    }
    NSLog(@"Did Fail");
}
- (void)connectionDidFinishLoading:(NSMutableData *)received
{
    if (queue) {
        UInt32 big5 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5);
        //NSData* data = [[NSString stringWithContentsOfURL:obj encoding:big5 error:&error] dataUsingEncoding:big5];
        TFHpple* parser = [[TFHpple alloc] initWithHTMLData:received];
        NSArray *waittime_tmp  = [parser searchWithXPathQuery:@"//body//div//table//tr//td"]; // get the title
        
        TFHppleElement* T_ptr2 = [waittime_tmp objectAtIndex:2];
        NSArray *child2 = [T_ptr2 children];
        TFHppleElement* buf2 = [child2 objectAtIndex:0];
        [item  addObject: [buf2 content] ];
        theConncetionCount++;
        NSLog(@"Did Finish");
        if ([waitTime count]==theConncetionCount) {
            if (loadingAlertView) {
                [loadingAlertView dismissWithClickedButtonIndex:0 animated:NO];
                [loadingAlertView release];
                loadingAlertView = nil;
            }
            [self.tableView reloadData];
            self.lastRefresh = [NSDate date];
            theConncetionCount=0;
            updateTimeOnButton = YES;
        }
    }
    else
        theConncetionCount=0;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [item count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlainId];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kPlainId] autorelease];
    }
    
    // Set up the cell
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text =[item objectAtIndex:indexPath.row];
    
    cell.backgroundColor = SECONDARY_GROUP_BACKGROUND_COLOR;
	
	cell.textLabel.font = [UIFont fontWithName:BOLD_FONT size:CELL_STANDARD_FONT_SIZE];
	cell.textLabel.textColor = CELL_STANDARD_FONT_COLOR;
	cell.textLabel.backgroundColor = [UIColor clearColor];

    if (dir){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"103八斗子-中正路-總站";
                break;
            case 1:
                if ([waitTime count]>2)
                    cell.textLabel.text = @"103八斗子-祥豐街-總站";
                else
                    cell.textLabel.text = @"104新豐街-中正路-總站";
                break;
            case 2:
                cell.textLabel.text = @"104新豐街-中正路-總站";
                break;
            case 3:
                cell.textLabel.text = @"104新豐街-祥豐街-總站";
                break;
            default:
                break;
        }
    }
    else {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"103總站-中正路-八斗子";
                break;
            case 1:
                if ([waitTime count]>2)
                    cell.textLabel.text = @"103總站-祥豐街-中正路";
                else
                    cell.textLabel.text = @"104總站-中正路-新豐街";
                break;
            case 2:
                cell.textLabel.text = @"104總站-中正路-新豐街";
                break;
            case 3:
                cell.textLabel.text = @"104總站-祥豐街-新豐街";
                break;
            default:
                break;
        }
    
    
    }
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    if ([cell.detailTextLabel.text isEqualToString:@"即將進站..."]) {
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    else if ([cell.detailTextLabel.text isEqualToString:@"目前無公車即時資料"]) {
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    else{
        cell.detailTextLabel.textColor = [UIColor colorWithRed:35.0/255 green:192.0/255 blue:46/255 alpha:1];
    }
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
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }
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

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}



@end
