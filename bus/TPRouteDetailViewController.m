//
//  SecondLevelViewController.m
//  TaipeiBusSystem
//
//  Created by Ching-Chi Lin on 12/7/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TPRouteDetailViewController.h"

@implementation SecondLevelViewController

@synthesize stopsGo, stopsBack;
@synthesize goIDs, backIDs;
@synthesize goTimes, backTimes;
@synthesize estimateArray;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self estimateTime];
}

- (void)estimateTime
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
    NSString *filePath = [paths objectAtIndex:0];
    filePath = [filePath stringByAppendingString:@"/stopsName.plist"];
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
            [goTimes addObject:[[NSString alloc] initWithString:@"無此資料！"]];
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
            [backTimes addObject:[[NSString alloc] initWithString:@"無此資料！"]];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
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
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    
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

@end
