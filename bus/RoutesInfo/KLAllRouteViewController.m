//
//  TPAllRouteViewController.m
//  bus
//
//  Created by iMac on 13/3/15.
//
//

#import "KLAllRouteViewController.h"
#import "KLRouteGoBackViewController.h"


@implementation KLAllRouteViewController

@synthesize section0Zh, section1Zh, section2Zh, section3Zh, section4Zh, section5Zh, section6Zh, section7Zh;
@synthesize section0Depart, section1Depart, section2Depart, section3Depart, section4Depart, section5Depart, section6Depart, section7Depart;
@synthesize section0Destin, section1Destin, section2Destin, section3Destin, section4Destin, section5Destin, section6Destin, section7Destin;
// ------------ Search Bar -------------------
@synthesize table;
@synthesize search;
@synthesize allData;
@synthesize searchData;
@synthesize allKeys;
@synthesize keys;

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

-(void)resetSearch
{
    searchData = [allData mutableCopy];
    
    NSArray * sectionTitles = [[NSArray alloc] initWithObjects:@"101", @"201", @"301", @"402", @"501", @"601", @"701", @"801", nil];
    NSMutableArray * key = [[NSMutableArray alloc] init];
    [key addObject:UITableViewIndexSearch];// 製作右側放大鏡
    [key addObjectsFromArray:sectionTitles];
    keys = key;
    
    //[sectionTitles release];
    //[key release];
}

-(void)handleSearchForTerm:(NSString *)searchTerm
{
    [self resetSearch];
    NSMutableArray * sectionsToRemove = [NSMutableArray new];
    
    NSMutableArray * AllNameValueArray = [NSMutableArray new];
    NSMutableArray * AllDepartValueArray = [NSMutableArray new];
    NSMutableArray * AllDestinValueArray = [NSMutableArray new];
    
    for(int i = 1; i < 16; i ++)
        [AllNameValueArray addObject:[[allData objectForKey:[keys objectAtIndex:i]] objectAtIndex:0]];
    
    for(int i=1; i<16; i++)
        [AllDepartValueArray addObject:[[allData objectForKey:[keys objectAtIndex:i]] objectAtIndex:1]];
    
    for(int i=1; i<16; i++)
        [AllDestinValueArray addObject:[[allData objectForKey:[keys objectAtIndex:i]] objectAtIndex:2]];
    
    int keyIndex = 1;       // 記錄現在 key 值的 index
    int index = 0;          // 記錄現在公車的 index
    
    for (NSArray * sectionZh in AllNameValueArray)
    {
        NSMutableArray * nameZh =[NSMutableArray new]; // 存含搜尋字元的公車名稱
        [nameZh addObjectsFromArray: sectionZh];
        NSMutableArray * depart =[NSMutableArray new]; // 存公車名稱相對應的起站
        [depart addObjectsFromArray: [AllDepartValueArray objectAtIndex:keyIndex-1]];
        NSMutableArray * destin =[NSMutableArray new]; // 存公車名稱相對應的迄站
        [destin addObjectsFromArray: [AllDestinValueArray objectAtIndex:keyIndex-1]];
        
        index = 0;
        
        NSMutableArray * toRemoveZh = [NSMutableArray new];
        NSMutableArray * toRemoveDepart = [NSMutableArray new];
        NSMutableArray * toRemoveDestin = [NSMutableArray new];
        NSMutableArray * encap = [NSMutableArray new];      // 要將zh、depart、destin包裝起來的陣列
        for (NSString * stringInSectionZh in sectionZh)
        {
            if([stringInSectionZh rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location == NSNotFound)
            {
                [toRemoveZh addObject:[nameZh objectAtIndex:index]];
                [toRemoveDepart addObject:[depart objectAtIndex:index]];
                [toRemoveDestin addObject:[destin objectAtIndex:index]];
            }
            else
            {
                [toRemoveDepart addObject:@" "];
            }
            index ++;
        }
        if ([nameZh count] == [toRemoveZh count])
            [sectionsToRemove addObject:[keys objectAtIndex:keyIndex]];
        else
        {
            [nameZh removeObjectsInArray:toRemoveZh];
            NSMutableArray * depart_new = [NSMutableArray new];
            NSMutableArray * destin_new = [NSMutableArray new];
            for (int i = 0; i < [sectionZh count]; i ++)
            {
                if ([[toRemoveDepart objectAtIndex:i] isEqual:@" "] == YES)
                {
                    [depart_new addObject:[depart objectAtIndex:i]];
                    [destin_new addObject:[destin objectAtIndex:i]];
                }
            }
            [encap addObject:nameZh];
            [encap addObject:depart_new];
            [encap addObject:destin_new];
            [searchData setObject:encap forKey:[keys objectAtIndex:keyIndex]];
            
            //[destin_new release];
            //[depart_new release];
        }
        
        keyIndex ++;
        
        /*[toRemoveZh release];
         [toRemoveDepart release];
         [toRemoveDestin release];
         [encap release];
         [nameZh release];
         [depart release];
         [destin release];*/
    }
    [keys removeObjectsInArray:sectionsToRemove];
    [table reloadData];
    
    /*[AllNameValueArray release];
     [AllDepartValueArray release];
     [AllDestinValueArray release];
     [sectionsToRemove release];*/
    
    // ----- 這裡要加判斷是否按了searchbar以外的地方
}

// ----- 判斷是否滑動 -----
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    startLocation = [touch locationInView:self.tableView];
    NSLog(@"startLocation: x = %.1f, y = %.1f", startLocation.x, startLocation.y);
    
    //[touch release];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isScrolled = NO;
    UITouch * touch = [touches anyObject];
    CGPoint endLocation = [touch locationInView:self.tableView];
    NSLog(@"endLocation: x = %.1f, y = %.1f", endLocation.x, endLocation.y);
    
    if (endLocation.y - startLocation.y != 0)
        isScrolled = YES;
    
    //[touch release];
}
// -----------------------

- (id)init
{
    allData = [NSDictionary new];
    searchData = [NSMutableDictionary new];
    keys = [NSMutableArray new];
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    section0Zh = [NSArray arrayWithObjects:@"101 和平島", @"103 八斗子", @"104 新豐街", @"105 海軍醫院", @"107 八斗子 - 信義國中 - 基隆車站", @"108 八斗子（經潮境公園）", @"109 天顯宮", nil];
    section1Zh = [NSArray arrayWithObjects:@"201 深美國小（仁一路）", @"202 深美國小（信二路、仁五路）", @"203 深澳坑", @"204 教忠街", @"205 信中 - 和平島（祥豐街）", nil];
    section2Zh = [NSArray arrayWithObjects:@"301 太白莊", @"302 中山高中", @"303 大竿林", @"304 高遠新村", @"305 濱海大道", @"306 中平街", @"307 中和國小", @"308 外木山漁港", nil];
    section3Zh = [NSArray arrayWithObjects:@"402 堵南里", @"403 東新街", @"406 長安社區", @"407 七堵至總站", @"408 總站 - 經長庚醫院 - 長安社區", @"409 堵南里（經長庚）", @"410 壯觀台北 - 七堵火車站", nil];
    section4Zh = [NSArray arrayWithObjects:@"501 國家新城", @"502 建德國中", @"503 鶯歌里", @"505 大武崙", @"508 澳底漁港", @"509 情人湖", @"510 大武崙 - 七堵", nil];
    section5Zh = [NSArray arrayWithObjects:@"601 四腳亭", @"602 暖暖", @"603 東勢坑", @"605 龍門谷", @"606 碇內經八堵火車站至七堵線", @"607 羅傑摩爾", @"608 南新街", nil];
    section6Zh = [NSArray arrayWithObjects:@"701 瑪陵", @"702 友蚋", @"703 瑪東里", @"705 百福火車站接駁公車", nil];
    section7Zh = [NSArray arrayWithObjects:@"801 愛心公車信義國中線", @"802 愛心公車八斗子線", nil];
    /*
    section0Depart = [NSArray arrayWithObjects:@"101", @"103", @"104", @"105", @"107", @"108", @"109", nil];
    section1Depart = [NSArray arrayWithObjects:@"201", @"202", @"203", @"204", @"205", nil];
    section2Depart = [NSArray arrayWithObjects:@"301", @"302", @"303", @"304", @"305", @"306", @"307", @"308", nil];
    section3Depart = [NSArray arrayWithObjects:@"402", @"403", @"406", @"407", @"408", @"409", @"410", nil];
    section4Depart = [NSArray arrayWithObjects:@"501", @"502", @"503", @"505", @"508", @"509", @"510", nil];
    section5Depart = [NSArray arrayWithObjects:@"601", @"602", @"603", @"605", @"606", @"607", @"608", nil];
    section6Depart = [NSArray arrayWithObjects:@"701", @"702", @"703", @"705", nil];
    section7Depart = [NSArray arrayWithObjects:@"801", @"802", nil];
    
    
    section0Destin = [NSArray arrayWithObjects:@"101", @"103", @"104", @"105", @"107", @"108", @"109", nil];
    section1Destin = [NSArray arrayWithObjects:@"201", @"202", @"203", @"204", @"205", nil];
    section2Destin = [NSArray arrayWithObjects:@"301", @"302", @"303", @"304", @"305", @"306", @"307", @"308", nil];
    section3Destin = [NSArray arrayWithObjects:@"402", @"403", @"406", @"407", @"408", @"409", @"410", nil];
    section4Destin = [NSArray arrayWithObjects:@"501", @"502", @"503", @"505", @"508", @"509", @"510", nil];
    section5Destin = [NSArray arrayWithObjects:@"601", @"602", @"603", @"605", @"606", @"607", @"608", nil];
    section6Destin = [NSArray arrayWithObjects:@"701", @"702", @"703", @"705", nil];
    section7Destin = [NSArray arrayWithObjects:@"801", @"802", nil];
        
    NSMutableArray * containers0 = [NSMutableArray new];
    [containers0 addObject:section0Zh];
    [containers0 addObject:section0Depart];
    [containers0 addObject:section0Destin];
    NSMutableArray * containers1 = [NSMutableArray new];
    [containers1 addObject:section1Zh];
    [containers1 addObject:section1Depart];
    [containers1 addObject:section1Destin];
    NSMutableArray * containers2 = [NSMutableArray new];
    [containers2 addObject:section2Zh];
    [containers2 addObject:section2Depart];
    [containers2 addObject:section2Destin];
    NSMutableArray * containers3 = [NSMutableArray new];
    [containers3 addObject:section3Zh];
    [containers3 addObject:section3Depart];
    [containers3 addObject:section3Destin];
    NSMutableArray * containers4 = [NSMutableArray new];
    [containers4 addObject:section4Zh];
    [containers4 addObject:section4Depart];
    [containers4 addObject:section4Destin];
    NSMutableArray * containers5 = [NSMutableArray new];
    [containers5 addObject:section5Zh];
    [containers5 addObject:section5Depart];
    [containers5 addObject:section5Destin];
    NSMutableArray * containers6 = [NSMutableArray new];
    [containers6 addObject:section6Zh];
    [containers6 addObject:section6Depart];
    [containers6 addObject:section6Destin];
    NSMutableArray * containers7 = [NSMutableArray new];
    [containers7 addObject:section7Zh];
    [containers7 addObject:section7Depart];
    [containers7 addObject:section7Destin];
        
    self.allData = [[NSDictionary alloc] initWithObjectsAndKeys:containers0, @"101", containers1, @"201",containers2,  @"301",containers3,  @"402",containers4,  @"501",containers5,  @"601",containers6,  @"701",containers7,  @"801", nil];
    */
    
    self.allData = [[NSDictionary alloc] initWithObjectsAndKeys:section0Zh, @"101", section1Zh, @"201",section2Zh,  @"301",section3Zh,  @"402",section4Zh,  @"501",section5Zh,  @"601",section6Zh,  @"701",section7Zh,  @"801", nil];
    
    allKeys = [[NSArray alloc] initWithObjects:@"101", @"201", @"301", @"402", @"501", @"601", @"701", @"801", nil];
    
    //Add the search bar
    self.table.tableHeaderView = search;
    search.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self resetSearch];
    [table reloadData];
    [table setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
    
    /*[allBusNameZh retain];
     [departureNameZh retain];
     [destinationNameZh retain];*/
    
    /*[section0Depart retain];
    [section1Depart retain];
    [section2Depart retain];
    [section3Depart retain];
    [section4Depart retain];
    [section5Depart retain];
    [section6Depart retain];
    [section7Depart retain];
    
    [section0Destin retain];
    [section1Destin retain];
    [section2Destin retain];
    [section3Destin retain];
    [section4Destin retain];
    [section5Destin retain];
    [section6Destin retain];
    [section7Destin retain];*/
    
    [allKeys retain];
    
    /*[containers0 release];
     [containers1 release];
     [containers2 release];
     [containers3 release];
     [containers4 release];
     [containers5 release];
     [containers6 release];
     [containers7 release];
     [containers8 release];
     [containers9 release];
     [containers10 release];
     [containers11 release];
     [containers12 release];
     [containers13 release];
     [containers14 release];*/
}

- (void)viewDidUnload
{
    /*self.allBusNameZh = nil;
     self.departureNameZh = nil;
     self.destinationNameZh = nil;*/
    
    self.section0Zh = nil;
    self.section1Zh = nil;
    self.section2Zh = nil;
    self.section3Zh = nil;
    self.section4Zh = nil;
    self.section5Zh = nil;
    self.section6Zh = nil;
    self.section7Zh = nil;
    
    /*self.section0Depart = nil;
    self.section1Depart = nil;
    self.section2Depart = nil;
    self.section3Depart = nil;
    self.section4Depart = nil;
    self.section5Depart = nil;
    self.section6Depart = nil;
    self.section7Depart = nil;
    
    self.section0Destin = nil;
    self.section1Destin = nil;
    self.section2Destin = nil;
    self.section3Destin = nil;
    self.section4Destin = nil;
    self.section5Destin = nil;
    self.section6Destin = nil;
    self.section7Destin = nil;*/
    
    self.table = nil;
    self.search = nil;
    self.allData = nil;
    self.searchData = nil;
    self.allKeys = nil;
    self.keys = nil;
    [super viewDidUnload];
}

-(void) dealloc
{
    /*[allBusNameZh release];
     [destinationNameZh release];
     [departureNameZh release];*/
    
    [section0Zh release];
    [section1Zh release];
    [section2Zh release];
    [section3Zh release];
    [section4Zh release];
    [section5Zh release];
    [section6Zh release];
    [section7Zh release];
    
    /*[section0Depart release];
    [section1Depart release];
    [section2Depart release];
    [section3Depart release];
    [section4Depart release];
    [section5Depart release];
    [section6Depart release];
    [section7Depart release];
    
    [section0Destin release];
    [section1Destin release];
    [section2Destin release];
    [section3Destin release];
    [section4Destin release];
    [section5Destin release];
    [section6Destin release];
    [section7Destin release];*/
    
    [table release];
    [search release];
    [allData release];
    [searchData release];
    [keys release];
    [allKeys release];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
        return YES;
    }
}

#pragma mark - Table view data source

-(NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(isSearch)
        return nil;
    
    return keys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return ([keys count] > 0) ? [keys count] : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([keys count] == 0)
        return nil;
    
    NSString * key = [keys objectAtIndex:section];
    if(key == UITableViewIndexSearch)
        return nil;
    
    return key;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSString * key = [keys objectAtIndex:index];
    if(key == UITableViewIndexSearch)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    
    //[key release];
    return index;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([keys count] == 0)
        return 0;
    
    //return [[[searchData objectForKey:[keys objectAtIndex:section]] objectAtIndex:0] count];
    return [[searchData objectForKey:[keys objectAtIndex:section]] count];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    /*NSArray * busNameZh = [[searchData objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:0];
    NSArray * depart = [[searchData objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:1];
    NSArray * destin = [[searchData objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:2];
    
    cell.textLabel.text = [busNameZh objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[[depart objectAtIndex:indexPath.row] stringByAppendingString:@" - "] stringByAppendingString:[destin objectAtIndex:indexPath.row]];
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];*/
    
    NSArray * busNameZh = [allData objectForKey:[keys objectAtIndex:indexPath.section]];
    cell.textLabel.text = [busNameZh objectAtIndex:indexPath.row];
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    
    /*[busNameZh release];
     [depart release];
     [destin release];*/
    
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

#pragma mark - Search Bar delegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self handleSearchForTerm:[searchBar text]];
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText length] == 0)
    {
        [self resetSearch];
        [table reloadData];
        return;
    }
    [backgroundButton removeFromSuperview];
    [self.table setScrollEnabled:YES];
    [self handleSearchForTerm:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearch = NO;
    search.text = @"";
    [backgroundButton removeFromSuperview];
    [self resetSearch];
    [self.table setScrollEnabled:YES];
    [search setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

- (void)backgroundButtonPressed:(id)sender
{
    NSLog(@"backgoundButtonPressed");
    isSearch = NO;
    search.text = @"";
    [backgroundButton removeFromSuperview];         // 讓偽裝成背景的button消失
    //[self resetSearch];
    [self.table setScrollEnabled:YES];              // 重新設為可滑動
    [search setShowsCancelButton:NO animated:YES];  // 取消cancel button
    [search resignFirstResponder];                  // SearchBar 歸還 First Responder
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarTextDidBeginEditing");
    isSearch = YES;
    [table reloadData];
    [searchBar setShowsCancelButton:YES animated:YES];
    
    backgroundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 45, 320, 430)];
    [backgroundButton setBackgroundColor:[UIColor blackColor]];
    [backgroundButton setAlpha:0.75f];
    [self.table addSubview:backgroundButton];
    [self.table setScrollEnabled:NO];
    if ([backgroundButton isEnabled])
        [backgroundButton addTarget:self action:@selector(backgroundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [search resignFirstResponder];
    isSearch = NO;
    search.text = @"";
    [table reloadData];
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KLRouteGoBackViewController * routeGoBack = [KLRouteGoBackViewController new];
    NSString * selectedBusName = [[NSString alloc] init];
    
    /*NSArray * sectionArray = [searchData valueForKey:[keys objectAtIndex:indexPath.section]];
    NSArray * busNameArray = [sectionArray objectAtIndex:0];
    NSArray * departArray = [sectionArray objectAtIndex:1];
    NSArray * destinArray = [sectionArray objectAtIndex:2];
    
    NSLog(@"selected bus = %@", [busNameArray objectAtIndex:indexPath.row]);
    selectedBusName = [busNameArray objectAtIndex:indexPath.row];
    routeGoBack.title = [selectedBusName stringByAppendingString:@" 公車路線"];
    [routeGoBack setter_departure:[departArray objectAtIndex:indexPath.row]];
    [routeGoBack setter_destination:[destinArray objectAtIndex:indexPath.row]];
    [routeGoBack setter_busName:[busNameArray objectAtIndex:indexPath.row]];*/
    
    NSArray * busNameArray = [allData valueForKey:[keys objectAtIndex:indexPath.section]];
    selectedBusName = [busNameArray objectAtIndex:indexPath.row];
    routeGoBack.title = [selectedBusName stringByAppendingString:@" 公車路線"];
    [routeGoBack setter_busNameAndNumber:[busNameArray objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:routeGoBack animated:YES];
    
    /*[selectedBusName release];
     [sectionArray release];
     [busNameArray release];
     [departArray release];
     [destinArray release];*/
    
}

@end
