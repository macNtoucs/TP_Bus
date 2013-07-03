//
//  NTOUTableViewControllerLayer1.m
//  MIT Mobile
//
//  Created by mac_hero on 12/9/26.
//
//

#import "IndexViewController.h"

#import "UIKit+NTOUAdditions.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"交通資訊";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    [self.tableView applyStandardCellHeight];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display 	 an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
    NSString *cellText = nil;
    
    cellText = @"A"; // just something to guarantee one line
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    rowHeight = labelSize.height + 20.0f;
    
    return rowHeight;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @" ";
    
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 32;
}



- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *headerTitle;
    switch (section) {
        case 0:
            headerTitle = @"搭乘工具";
            break;
        case 1:
            headerTitle = @"市區公車";
            break;
        default:
            break;
    }
    UIFont *font = [UIFont boldSystemFontOfSize:STANDARD_CONTENT_FONT_SIZE];
	CGSize size = [headerTitle sizeWithFont:font];
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(19.0, 3.0, appFrame.size.width - 19.0, size.height)];
	
	label.text = headerTitle;
	label.textColor = GROUPED_SECTION_FONT_COLOR;
	label.font = font;
	label.backgroundColor = [UIColor clearColor];
	
	UIView *labelContainer = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, appFrame.size.width, GROUPED_SECTION_HEADER_HEIGHT)] autorelease];
	labelContainer.backgroundColor = [UIColor clearColor];
	
	[labelContainer addSubview:label];
	[label release];
	return labelContainer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:STANDARD_CONTENT_FONT_SIZE];
    switch (indexPath.section)  {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"公車";
                    break;
                case 1:
                    cell.textLabel.text = @"台鐵";
                    break;
                case 2:
                    cell.textLabel.text = @"高鐵";
                    break;
                case 3:
                    cell.textLabel.text = @"客運";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"八斗子  → 海大  → 火車站";
                    break;
                case 1:
                    cell.textLabel.text = @"火車站  → 海大  → 八斗子";
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
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
    
    if (indexPath.section==0)
    {
        if (indexPath.row == 0)
        {
            TPRouteByButtonViewController *tpRouteByButtonViewController = [[TPRouteByButtonViewController alloc] init];
            [self.navigationController pushViewController:tpRouteByButtonViewController animated:YES];
            [tpRouteByButtonViewController release];
        }
        else if (indexPath.row == 1)
        {
            SetStationViewController *setStationViewController = [[SetStationViewController alloc] init];
            [setStationViewController initIsHighSpeedTrain:false];
            [self.navigationController pushViewController:setStationViewController animated:YES];
            setStationViewController.navigationItem.leftBarButtonItem.title = @"Back";
            [setStationViewController release];
        }
        else if (indexPath.row == 2)
        {
            SetStationViewController *setStationViewController = [[SetStationViewController alloc] init];
            [setStationViewController initIsHighSpeedTrain:true];
            [self.navigationController pushViewController:setStationViewController animated:YES];
            setStationViewController.navigationItem.leftBarButtonItem.title = @"Back";
            [setStationViewController release];
        }
        else
        {
            KuoFuhoViewController *kuoFuhoViewController = [[KuoFuhoViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:kuoFuhoViewController animated:YES];
            kuoFuhoViewController.navigationItem.leftBarButtonItem.title = @"Back";
            [kuoFuhoViewController release];
        }
    }
    else
    {
            SecondaryGroupedTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            StopsViewController * stops = [[StopsViewController alloc]initWithStyle:UITableViewStyleGrouped];
            stops.title =[ NSString stringWithFormat:@"往%@",[cell.textLabel.text substringWithRange:NSMakeRange(13, 3)] ];
            if (indexPath.row==0) {
                [stops setDirection:true];
                [self.navigationController pushViewController:stops animated:YES];
                stops.navigationItem.leftBarButtonItem.title=@"Back";
            } else {
                [stops setDirection:false];
                [self.navigationController pushViewController:stops animated:YES];
                stops.navigationItem.leftBarButtonItem.title=@"Back";
            }
            [stops release];
    }
}

@end
