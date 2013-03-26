//
//  TPRouteGoBackViewController.m
//  bus
//
//  Created by iMac on 12/10/29.
//
//

#import "KLRouteGoBackViewController.h"
#import "KLRouteDetailViewController.h"

@implementation KLRouteGoBackViewController
@synthesize busName, busNumber;
@synthesize routeNames, departures, destinations, IDs;

/*
- (void) setter_departure:(NSString *) name //取得所點選的公車路線起始位置
{
    departure = name;
    NSLog(@"RouteGoBack.m 起始站牌 = %@", departure);
}

- (void) setter_destination:(NSString *) name   //取得所點選的公車路線終點位置
{
    destination = name;
    NSLog(@"RouteGoBack.m 終點站牌 = %@", destination);
}*/

- (void) setter_busNameAndNumber:(NSString *)name
{
    busName = name;
    busNumber = [NSString stringWithFormat:@"%d", [busName intValue]];
    NSLog(@"KLRouteGoBack.m  busName:%@, busNumber:%@", busName, busNumber);
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

    routeNames = [NSMutableArray new];
    departures = [NSMutableArray new];
    destinations = [NSMutableArray new];
    IDs = [NSMutableArray new];
    
    NSString *encodedBus = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)busNumber, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    NSString *strURL = [NSString stringWithFormat:@"http://140.121.91.62/KLRouteGoBack.php?bus=%@", encodedBus];
    
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    NSString *strResult = [[[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding]autorelease];
    
    NSLog(@"strResult = %@", strResult);
    
    NSArray * routes = [strResult componentsSeparatedByString:@";"];
    
    NSArray * tmp_nameZhs = [[NSArray alloc] init];
    tmp_nameZhs = [[routes objectAtIndex:0] componentsSeparatedByString:@"|"];
    for (NSString * str in tmp_nameZhs)
    {
        [routeNames addObject:str];
    }
    [routeNames removeLastObject];
    
    NSArray * tmp_departureZhs = [[NSArray alloc] init];
    tmp_departureZhs = [[routes objectAtIndex:1] componentsSeparatedByString:@"|"];
    for (NSString * str in tmp_departureZhs)
    {
        [departures addObject:str];
    }
    [departures removeLastObject];
    
    NSArray * tmp_destinationZhs = [[NSArray alloc] init];
    tmp_destinationZhs = [[routes objectAtIndex:2] componentsSeparatedByString:@"|"];
    for (NSString * str in tmp_destinationZhs)
    {
        [destinations addObject:str];
    }
    [destinations removeLastObject];
    
    NSArray * tmp_ids = [[NSArray alloc] init];
    tmp_ids = [[routes objectAtIndex:3] componentsSeparatedByString:@"|"];
    for (NSString * str in tmp_ids)
    {
        [IDs addObject:str];
    }
    [IDs removeLastObject];
    
    [routeNames retain];
    [departures retain];
    [destinations retain];
    [IDs retain];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [routeNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [routeNames objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[[departures objectAtIndex:indexPath.row] stringByAppendingString:@" - "] stringByAppendingString:[destinations objectAtIndex:indexPath.row]];
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    
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
    UIAlertView *loadingAlertView = [[UIAlertView alloc]
                                     initWithTitle:nil message:@"\n\nDownloading\nPlease wait"
                                     delegate:nil cancelButtonTitle:nil
                                     otherButtonTitles: nil];
    CGRect frame = CGRectMake(120, 10, 40, 40);
    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [progressInd startAnimating];
    [loadingAlertView addSubview:progressInd];
    [loadingAlertView show];
    [progressInd release];
    
    KLRouteDetailViewController * detailViewController = [KLRouteDetailViewController new];
    NSString * selectedRouteName = [routeNames objectAtIndex:indexPath.row];
    
    NSLog(@"selected route = %@", selectedRouteName);
    detailViewController.title = selectedRouteName;
    [detailViewController setter_busId:[IDs objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    [loadingAlertView dismissWithClickedButtonIndex:0 animated:NO];
    [loadingAlertView release];
    [detailViewController release];

}

- (void)dealloc
{
    [busName release];
    //[departure release];
    //[destination release];
    [super dealloc];
}

@end
