//
//  NTAllRouteViewController.m
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

#import "NTAllRouteViewController.h"
#import "NTRouteGoBackViewController.h"

@implementation NTAllRouteViewController

//@synthesize allBusNameZh, departureNameZh, destinationNameZh;
@synthesize section0Zh, section1Zh, section2Zh, section3Zh, section4Zh, section5Zh, section6Zh;
@synthesize section0Depart, section1Depart, section2Depart, section3Depart, section4Depart, section5Depart, section6Depart;
@synthesize section0Destin, section1Destin, section2Destin, section3Destin, section4Destin, section5Destin, section6Destin;
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
    
    NSArray * sectionTitles = [[NSArray alloc] initWithObjects:@"一般", @"快捷", @"新巴士", @"橘", @"紅", @"綠", @"藍", nil];
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
    
    for(int i = 1; i < 7; i ++)
        [AllNameValueArray addObject:[[allData objectForKey:[keys objectAtIndex:i]] objectAtIndex:0]];
    
    for(int i=1; i<7; i++)
        [AllDepartValueArray addObject:[[allData objectForKey:[keys objectAtIndex:i]] objectAtIndex:1]];
    
    for(int i=1; i<7; i++)
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
    
    section0Zh = [NSArray arrayWithObjects:@"8", @"51", @"57", @"99", @"264", @"275", @"275副", @"636", @"657", @"657延", @"704", @"704區", @"778", @"779", @"780", @"781", @"782", @"783", @"785", @"786", @"787", @"787經瑞芳工業區", @"788", @"789", @"790", @"791", @"793", @"795", @"796", @"797", @"798", @"799", @"800", @"801", @"802", @"802區", @"803", @"805", @"806", @"807", @"807經滿月園", @"808", @"810", @"811", @"812", @"813", @"815", @"816", @"817", @"818", @"819", @"820", @"821", @"823", @"825", @"826", @"827", @"828", @"829", @"833三峽線", @"833鶯歌線", @"835", @"836", @"836假日", @"837", @"838", @"839", @"839耕莘", @"840", @"841", @"842", @"843", @"845", @"846", @"847", @"847區", @"848", @"849", @"850", @"851", @"852", @"856", @"857", @"858", @"859", @"860", @"861", @"862基隆-淡水", @"862淡水-基隆", @"862皇冠北海岸", @"863", @"864", @"865", @"866", @"867", @"868正", @"868返", @"869", @"870", @"871", @"871經正德國中", @"872", @"872經正德國中", @"873", @"873經正德國中", @"874", @"875", @"876", @"877", @"878", @"879", @"880樹林-淡水", @"880淡水-樹林", @"881", @"882", @"883樹林-淡水", @"883淡水-樹林", @"885", @"886", @"887", @"888", @"889", @"890", @"891", @"892", @"893", @"三鶯捷運先導公車", @"北宜高-十分", @"北宜高-白石村", @"十分-平溪", @"捷運環狀先導公車", @"捷運環狀區間", @"木柵-十分", @"木柵-白石村", @"淡海捷運先導公車", @"瑞芳-十分", nil];
    section1Zh = [NSArray arrayWithObjects:@"908", @"910", @"916", @"917", @"918", @"918延", @"919", @"920", @"921", @"922", @"923", @"925", @"926", @"926副", @"927", @"927經台北港", @"928", @"930", @"930延", @"931", @"932", @"933", @"935", @"936", @"937", @"938", @"939", @"939假日", nil];
    section2Zh = [NSArray arrayWithObjects:@"F511", @"F921", @"F921假日", @"F923", @"F923假日", nil];
    section3Zh = [NSArray arrayWithObjects:@"橘1", @"橘2", @"橘3", @"橘5", @"橘9", @"橘10", @"橘12", @"橘13", @"橘16", @"橘17", @"橘18", @"橘19", @"橘20", @"橘21", @"橘22", @"橘23", @"橘25", @"橘26", nil];
    section4Zh = [NSArray arrayWithObjects:@"紅13", @"紅22", @"紅22台北港", @"紅22往-台北港", @"紅23", @"紅26", @"紅27", @"紅28", @"紅36", @"紅37", @"紅38", @"紅38區", @"紅39", @"紅51", nil];
    section5Zh = [NSArray arrayWithObjects:@"綠3", @"綠5", @"綠6", @"綠7", @"綠8", @"綠9", @"綠9-北新國小", @"綠9-耕莘", @"綠10", @"綠12", @"綠13", @"綠15", nil];
    section6Zh = [NSArray arrayWithObjects:@"藍1", @"藍15", @"藍17", @"藍18", @"藍21", @"藍22", @"藍23", @"藍31", @"藍32", @"藍33", @"藍35", @"藍37", @"藍38", @"藍39", @"藍40", @"藍41", @"藍43", @"藍44", @"藍45", @"藍46", nil];
    
    section0Depart = [NSArray arrayWithObjects:@"溪頭", @"亞東技術學院", @"南雅站", @"民安站", @"捷運蘆洲站", @"少年觀護所", @"三峽國中", @"迴龍", @"少年觀護所", @"少年觀護所", @"廖添丁廟", @"廖添丁廟", @"三峽國小", @"三峽國小", @"分駐所", @"分駐所", @"分駐所", @"陸光國宅一", @"妙雲寺", @"公賣局", @"東和里", @"東和里", @"獅子橋", @"麥金樂利三街口", @"安一路", @"麥金樂利三街口", @"濟安宮", @"文山一分局", @"文山一分局", @"明日世界", @"明日世界", @"山佳國小", @"山佳國小", @"明日世界", @"三峽國小", @"西盛", @"明日世界", @"捷運永寧站", @"信義路", @"三峽國小", @"三峽國小", @"地政事務所", @"大同工廠", @"蘆洲總站", @"大仁路", @"明日世界", @"仙公廟", @"仙公廟", @"基隆市界", @"八勢一街", @"阿柔洋", @"山腳橋", @"三芝", @"舊莊公園", @"瑞芳火車站", @"瑞柑新村", @"瑞芳火車站", @"金山(南勢)", @"金山", @"客家文化園區", @"環河路停車場", @"管理中心", @"捷運淡水站", @"捷運淡水站", @"新春街", @"山腳橋", @"達觀A6站", @"達觀A6站", @"濟安宮", @"僑中一街", @"西盛", @"十三公", @"西盛", @"地政事務所", @"陽光峇里", @"山佳國小", @"工程處", @"觀光大橋", @"三峽國小", @"學成路", @"姑娘廟", @"九份", @"觀景台", @"樹林區衛生所", @"同興公園", @"古庄", @"永樂巷口", @"安一路", @"永樂巷口", @"大武崙工業區", @"永樂巷口", @"三芝", @"永樂巷口", @"永樂巷口", @"永樂巷口", @"東宇花園城", @"東宇花園城", @"福德宮", @"永樂巷口", @"永樂巷口", @"永樂巷口", @"永樂巷口", @"永樂巷口", @"永樂巷口", @"永樂巷口", @"永樂巷口", @"永樂巷口", @"永樂巷口", @"永樂巷口", @"廖添丁廟", @"古庄", @"山佳國小", @"美人嶼社區", @"淡海", @"古庄", @"山佳國小", @"淡海", @"三峽國小", @"瑞芳區公所", @"龍門營區", @"萬里橋頭", @"台北大學三峽校區", @"汐止", @"勸濟堂", @"聯合醫院中興院區", @"聯合醫院中興院區", @"文昌街口", @"北宜高石碇聯絡道", @"北宜高石碇聯絡道", @"十分平交道", @"中央合署辦公大樓", @"中央合署辦公大樓", @"木柵動物園", @"木柵動物園", @"龍騰區", @"瑞芳車站", nil];
    section1Depart = [NSArray arrayWithObjects:@"三峽國小", @"三峽國小", @"三峽國小", @"南鶯集會所", @"山腳橋", @"山腳橋", @"基隆市界", @"啟智學校(家天下社區)", @"姑娘廟", @"姑娘廟", @"坪林國中", @"捷運蘆洲站", @"分子尾", @"分子尾", @"自然公園", @"自然公園", @"自然公園", @"青潭", @"大崎腳", @"捷運蘆洲站", @"姑娘廟", @"仙公廟", @"美墅家", @"醒吾科技大學(東林里)", @"人見仁愛社區", @"明日世界", @"大義路口", @"大義路口", nil];
    section2Depart = [NSArray arrayWithObjects:@"中和農會民享分部", @"北基路口", @"北基路口", @"美崙7-11", @"美崙7-11", nil];
    section3Depart = [NSArray arrayWithObjects:@"錦繡站", @"雙和醫院", @"錦和路", @"名來新城", @"碧瑤", @"山腳橋", @"仙公廟", @"自然公園", @"榖保中學", @"標準廠房", @"九芎街口", @"陸光國宅二站", @"凌雲禪寺", @"龍壽村", @"捷運輔大站(建國一路)", @"龍壽村", @"忠義國小", @"捷運輔大站", nil];
    section4Depart = [NSArray arrayWithObjects:@"廖添丁廟", @"廖添丁廟", @"廖添丁廟", @"廖添丁廟", @"觀景台", @"淡海站", @"黃昏市場", @"鄧公里", @"東宇花園城", @"東宇花園城", @"龍騰區", @"新春街", @"東宇花園城", @"龍騰區", nil];
    section5Depart = [NSArray arrayWithObjects:@"花園新城(一)", @"大崎腳", @"潭之鄉", @"黎明路口", @"台北小城(一)", @"大香山登山口", @"大香山登山口", @"大香山登山口", @"台貿八村", @"蓬泰茶莊", @"青潭", @"造鎮", nil];
    section6Depart = [NSArray arrayWithObjects:@"蘆洲總站", @"鄉長路一段", @"五福新村", @"錦和路", @"社后消防隊", @"基隆市界", @"福德二路", @"冷凍廠", @"信義公園", @"振義里", @"僑中一街", @"龍壽村", @"樹林區衛生所", @"福德二路", @"華克山莊", @"員福里", @"三樹路", @"濟安宮", @"田寮站", @"二鬮", nil];
    
    section0Destin = [NSArray arrayWithObjects:@"捷運新店站", @"亞東技術學院", @"南雅站", @"民安站", @"捷運蘆洲站", @"少年觀護所", @"三峽國中", @"迴龍商場", @"少年觀護所", @"少年觀護所", @"廖添丁廟", @"廖添丁廟", @"三峽國小", @"三峽國小", @"分駐所", @"分駐所", @"分駐所", @"陸光國宅一", @"妙雲寺", @"公賣局", @"地政事務所", @"地政事務所", @"義二路口", @"樂利三街", @"主普壇", @"樂利三街", @"濟安宮", @"文山一分局", @"文山一分局", @"明日世界", @"明日世界", @"山佳國小", @"山佳國小", @"明日世界", @"三峽國小", @"西盛", @"明日世界", @"捷運永寧站", @"信義路", @"三峽國小", @"三峽國小", @"地政事務所", @"大同工廠", @"蘆洲總站", @"大仁路", @"明日世界", @"仙公廟", @"仙公廟", @"基隆市界", @"捷運紅樹林站", @"阿柔洋", @"山腳橋", @"三芝", @"舊莊公園", @"瑞芳火車站", @"瑞新新村", @"瑞芳火車站", @"金山(南勢)", @"金山", @"客家文化園區", @"環河路停車場", @"管理中心", @"捷運淡水站", @"捷運淡水站", @"新春街", @"山腳橋", @"達觀A6站", @"達觀A6站", @"濟安宮", @"僑中一街", @"西盛", @"十三公", @"西盛", @"瑞芳車站", @"水景", @"山佳國小", @"台北區監理所", @"觀光大橋", @"三峽國小", @"台北大學三峽校區", @"姑娘廟", @"九份", @"沙崙里", @"樹林區衛生所", @"環河路口", @"古庄", @"華南銀行", @"捷運淡水站", @"基隆車站", @"大武崙工業區", @"華南銀行", @"三芝", @"華南銀行", @"華南銀行", @"華南銀行", @"東宇花園城", @"東宇花園城", @"福德宮", @"華南銀行", @"華南銀行", @"華南銀行", @"華南銀行", @"華南銀行", @"華南銀行", @"華南銀行", @"華南銀行", @"華南銀行", @"華南銀行", @"華南銀行", @"廖添丁廟", @"古庄", @"淡海站", @"樹林站", @"捷運淡水站", @"古庄", @"淡海站", @"樹林站", @"恩主公醫院", @"瑞芳區公所", @"龍門營區", @"萬里橋頭", @"台北大學三峽校區", @"汐止", @"黃金博物館", @"北平西路", @"北平西路", @"中鶯", @"北宜高石碇聯絡道", @"北宜高石碇聯絡道", @"十分平交道", @"中央合署辦公大樓", @"中央合署辦公大樓", @"木柵動物園", @"木柵動物園", @"鳳翔區", @"瑞芳車站", nil];
    section1Destin = [NSArray arrayWithObjects:@"三峽國小", @"三峽國小", @"三峽國小", @"陶瓷博物館", @"山腳橋", @"山腳橋", @"基隆市界", @"啟智學校(家天下社區)", @"大學路", @"大學路", @"坪林國中", @"捷運蘆洲站", @"分仔尾", @"分仔尾", @"自然公園", @"自然公園", @"自然公園", @"青潭", @"大崎腳", @"捷運蘆洲站", @"大學路", @"仙公廟", @"美墅家", @"醒吾科技大學(東林里) ", @"人見仁愛社區", @"明日世界", @"大學路一", @"學成路一", nil];
    section2Destin = [NSArray arrayWithObjects:@"中和農會民享分部", @"北基路口", @"北基路口", @"美崙7-11", @"美崙7-11", nil];
    section3Destin = [NSArray arrayWithObjects:@"碧瑤", @"碧湖社區", @"錦和路", @"玫瑰公園", @"碧瑤", @"山腳橋", @"仙公廟", @"自然公園", @"榖保中學", @"標準廠房", @"九芎街口", @"陸光國宅二站", @"凌雲禪寺", @"龍壽村", @"捷運輔大站(建國一路)", @"龍壽村", @"忠義國小", @"捷運輔大站(建國一路)", nil];
    section4Destin = [NSArray arrayWithObjects:@"廖添丁廟", @"廖添丁廟", @"廖添丁廟", @"八里站", @"漁人碼頭", @"淡水拖吊場", @"黃昏市場", @"捷運淡水站", @"東宇花園城", @"東宇花園城", @"鳳翔區", @"新春街", @"東宇花園城 ", @"鳳翔區", nil];
    section5Destin = [NSArray arrayWithObjects:@"崎頂", @"大崎腳", @"美之城", @"黎明清境", @"台北小城(一)", @"大香山登山口", @"大香山登山口", @"大香山登山口", @"台貿八村", @"蓬泰茶莊", @"青潭", @"造鎮", nil];
    section6Destin = [NSArray arrayWithObjects:@"蘆洲總站", @"鄉長路一段", @"冷凍廠", @"錦和路", @"社后消防隊", @"基隆市界", @"福德二路", @"音樂公園", @"信義公園", @"振義里", @"僑中一街", @"龍壽村", @"樹林區衛生所", @"福德二路", @"華克山莊", @"日新里", @"三樹路", @"濟安宮", @"田寮站", @"二鬮", nil];
    
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
        
    self.allData = [[NSDictionary alloc] initWithObjectsAndKeys:containers0, @"一般", containers1, @"快捷",containers2,  @"新巴士",containers3,  @"橘",containers4,  @"紅",containers5,  @"綠",containers6,  @"藍", nil];
    
    allKeys = [[NSArray alloc] initWithObjects:@"一般", @"快捷", @"新巴士", @"橘", @"紅", @"綠", @"藍", nil];
    
    //Add the search bar
    self.table.tableHeaderView = search;
    search.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self resetSearch];
    [table reloadData];
    [table setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
    
    /*[allBusNameZh retain];
    [departureNameZh retain];
    [destinationNameZh retain];*/
    
    [section0Depart retain];
    [section1Depart retain];
    [section2Depart retain];
    [section3Depart retain];
    [section4Depart retain];
    [section5Depart retain];
    [section6Depart retain];
    
    [section0Destin retain];
    [section1Destin retain];
    [section2Destin retain];
    [section3Destin retain];
    [section4Destin retain];
    [section5Destin retain];
    [section6Destin retain];
        
    [allKeys retain];
    
    /*[containers0 release];
    [containers1 release];
    [containers2 release];
    [containers3 release];
    [containers4 release];
    [containers5 release];
    [containers6 release];*/
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
        
    self.section0Depart = nil;
    self.section1Depart = nil;
    self.section2Depart = nil;
    self.section3Depart = nil;
    self.section4Depart = nil;
    self.section5Depart = nil;
    self.section6Depart = nil;
        
    self.section0Destin = nil;
    self.section1Destin = nil;
    self.section2Destin = nil;
    self.section3Destin = nil;
    self.section4Destin = nil;
    self.section5Destin = nil;
    self.section6Destin = nil;
        
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
    
    [section0Depart release];
    [section1Depart release];
    [section2Depart release];
    [section3Depart release];
    [section4Depart release];
    [section5Depart release];
    [section6Depart release];
    
    [section0Destin release];
    [section1Destin release];
    [section2Destin release];
    [section3Destin release];
    [section4Destin release];
    [section5Destin release];
    [section6Destin release];
        
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
    
    return [[[searchData objectForKey:[keys objectAtIndex:section]] objectAtIndex:0] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSArray * busNameZh = [[searchData objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:0];
    NSArray * depart = [[searchData objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:1];
    NSArray * destin = [[searchData objectForKey:[keys objectAtIndex:indexPath.section]] objectAtIndex:2];
    
    cell.textLabel.text = [busNameZh objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[[depart objectAtIndex:indexPath.row] stringByAppendingString:@" - "] stringByAppendingString:[destin objectAtIndex:indexPath.row]];
    
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
    NTRouteGoBackViewController * routeGoBack = [NTRouteGoBackViewController new];
    NSString * selectedBusName = [[NSString alloc] init];
    
    NSArray * sectionArray = [searchData valueForKey:[keys objectAtIndex:indexPath.section]];
    NSArray * busNameArray = [sectionArray objectAtIndex:0];
    NSArray * departArray = [sectionArray objectAtIndex:1];
    NSArray * destinArray = [sectionArray objectAtIndex:2];
    
    NSLog(@"selected bus = %@", [busNameArray objectAtIndex:indexPath.row]);
    selectedBusName = [busNameArray objectAtIndex:indexPath.row];
    routeGoBack.title = [selectedBusName stringByAppendingString:@" 公車路線"];
    [routeGoBack setter_departure:[departArray objectAtIndex:indexPath.row]];
    [routeGoBack setter_destination:[destinArray objectAtIndex:indexPath.row]];
    [routeGoBack setter_busName:[busNameArray objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:routeGoBack animated:YES];
    
    /*[selectedBusName release];
    [sectionArray release];
    [busNameArray release];
    [departArray release];
    [destinArray release];*/
    
}

@end



