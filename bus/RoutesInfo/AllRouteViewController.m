//
//  TPAllRouteViewController.m
//  bus
//
//  Created by iMac on 12/9/5.
//
//

//
//  FirstLevelViewController.m
//  TaipeiBusSystem
//
//  Created by NTOUCS on 12/7/23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AllRouteViewController.h"
#import "TPAllRouteViewController.h"
#import "NTAllRouteViewController.h"

@implementation AllRouteViewController

@synthesize area;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (id)init
{
    area = [[NSArray alloc] initWithObjects:@"台北市", @"新北市", @"基隆市", nil];
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.area = nil;
    
    [super viewDidUnload];
}

-(void) dealloc
{
    [area release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [area objectAtIndex:indexPath.row];
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id route;
    
    switch (indexPath.row) {
        case 0:{
            route = [TPAllRouteViewController new];
            break;
        }
        case 1:{
            route = [NTAllRouteViewController new];
            break;
        }
        case 2:{
            
            break;
        }
    }
    
    [self.navigationController pushViewController:route animated:YES];
    
    /*[selectedBusName release];
    [sectionArray release];
    [busNameArray release];
    [departArray release];
    [destinArray release];*/
    
}

@end



