//
//  TWRailDepartureViewController.m
//  bus
//
//  Created by NTOUCS on 13/6/14.
//
//

#import "TWRailDepartureViewController.h"

@interface TWRailDepartureViewController ()

@end

@implementation TWRailDepartureViewController

@synthesize region;
@synthesize station;
@synthesize stationName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self createData];
        
        /*NSString *plistPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"stationNumber.plist"];
        NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        for (NSString *strRegion in station)
        {
            NSLog(@"%@:%@", strRegion, [plistDict objectForKey:strRegion]);
            [stationName addObject:[plistDict objectForKey:strRegion]];
        }*/
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createData{
    region = [[NSArray alloc] initWithObjects:@"臺北", @"桃園",@"新竹",@"苗栗",@"臺中",@"彰化",@"雲林",@"南投",@"嘉義",@"臺南",@"高雄",@"屏東",@"臺東",@"花蓮",@"宜蘭",nil];
    station = [[NSArray alloc]initWithObjects:
               [NSArray arrayWithObjects:@"福隆",@"貢寮",@"雙溪",@"牡丹",@"三貂嶺",@"侯硐",@"瑞芳",@"四腳亭",@"暖暖",@"基隆",@"三坑",@"八堵",@"七堵",@"百福",@"五堵",@"汐止",@"汐科",@"南港",@"松山",@"臺北",@"萬華",@"板橋",@"浮州",@"樹林",@"山佳",@"鶯歌",nil ],
               [NSArray arrayWithObjects:@"桃園",@"內壢",@"中壢",@"埔心",@"楊梅",@"富岡",nil ],
               [NSArray arrayWithObjects:@"北湖",@"湖口",@"新豐",@"竹北",@"北新竹",@"新竹",@"香山",nil ],
               [NSArray arrayWithObjects:@"崎頂",@"竹南",@"談文",@"大山",@"後龍",@"龍港",@"白沙屯",@"新埔",@"通霄",@"苑里",@"豐富",@"苗栗",@"南勢",@"銅鑼",@"三義",nil ],
               [NSArray arrayWithObjects:@"日南",@"大甲",@"臺中港",@"清水",@"沙鹿",@"龍井",@"大肚",@"追分",@"泰安",@"后里",@"豐原",@"潭子",@"太原",@"臺中",@"大慶",@"烏日",@"新烏日",@"成功",nil ],
               [NSArray arrayWithObjects:@"彰化",@"花壇",@"大村",@"員林",@"永靖",@"社頭",@"田中",@"二水",nil ],
               [NSArray arrayWithObjects:@"林內",@"石榴",@"斗六",@"斗南",@"石龜",nil ],
               [NSArray arrayWithObjects:@"源泉",@"濁水",@"龍泉",@"集集",@"水里",@"車程",nil ],
               [NSArray arrayWithObjects:@"大林",@"民雄",@"嘉北",@"嘉義",@"水上",@"南靖",nil ],
               [NSArray arrayWithObjects:@"後壁",@"新營",@"柳營",@"林鳳營",@"隆田",@"拔林",@"善化",@"南科",@"新市",@"永康",@"大橋",@"臺南",@"保安",@"中洲",@"長榮大學",@"沙崙",nil ],
               [NSArray arrayWithObjects:@"大湖",@"路竹",@"岡山",@"橋頭",@"楠梓",@"新左營",@"左營",@"高雄",@"鳳山",@"後庄",@"九曲堂",nil ],
               [NSArray arrayWithObjects:@"六塊厝",@"屏東",@"歸來",@"麟落",@"西勢",@"竹田",@"潮州",@"崁頂",@"南州",@"鎮安",@"林邊",@"佳冬",@"東海",@"枋寮",@"加祿",@"內獅",@"枋山",nil ],
               [NSArray arrayWithObjects:@"古莊",@"瀧溪",@"大武",@"金崙",@"太麻里",@"知本",@"康樂",@"臺東",@"山里",@"鹿野",@"瑞源",@"瑞和",@"月美",@"關山",@"海瑞",@"池上",nil ],
               [NSArray arrayWithObjects:@"富里",@"東竹",@"東里",@"玉里",@"三民",@"瑞穗",@"富源",@"大富",@"光榮",@"萬榮",@"鳳林",@"南平",@"溪口",@"豐田",@"壽豐",@"平和",@"志學",@"吉安",@"花蓮",@"北埔",@"景美",@"新城",@"崇德",@"和仁",@"和平",nil ],
               [NSArray arrayWithObjects:@"漢本",@"武塔",@"南澳",@"東澳",@"永樂",@"蘇澳",@"蘇澳新",@"新馬",@"冬山",@"羅東",@"中里",@"二結",@"宜蘭",@"四城",@"礁溪",@"頂埔",@"頭城",@"外澳",@"龜山",@"大溪",@"大里",@"石城",nil ]
               
               , nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [region count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    sectionName = [region objectAtIndex:section];
    return sectionName;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *sIndex = [[NSMutableArray alloc] init];
    for (NSString *str in region)
        [sIndex addObject:str];
    return [sIndex autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger rowNumber = [[station objectAtIndex:section] count];
    NSLog(@"%d", rowNumber);
    return rowNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.textLabel.text = [[station objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    // Configure the cell...
    
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
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
