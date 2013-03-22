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

@synthesize section0Zh, section1Zh, section2Zh, section3Zh, section4Zh, section5Zh, section6Zh, section7Zh, section8Zh, section9Zh, section10Zh, section11Zh, section12Zh, section13Zh, section14Zh;
@synthesize section0Depart, section1Depart, section2Depart, section3Depart, section4Depart, section5Depart, section6Depart, section7Depart, section8Depart, section9Depart, section10Depart, section11Depart, section12Depart, section13Depart, section14Depart;
@synthesize section0Destin, section1Destin, section2Destin, section3Destin, section4Destin, section5Destin, section6Destin, section7Destin, section8Destin, section9Destin, section10Destin, section11Destin, section12Destin, section13Destin, section14Destin;
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
    
    NSArray * sectionTitles = [[NSArray alloc] initWithObjects:@"0", @"201", @"302", @"601", @"701", @"市", @"其他", @"小", @"幹線", @"內科", @"低", @"紅", @"藍", @"棕", @"綠", nil];
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
    
    section0Zh = [NSArray arrayWithObjects:@"0東", @"0南", @"1", @"2", @"3", @"5", @"9", @"12", @"14", @"15", @"18", @"20", @"21", @"21直", @"22", @"22區", @"26", @"28", @"32", @"32區", @"33", @"37", @"38", @"38區", @"39", @"39夜", @"41", @"42", @"42區", @"46", @"49", @"51", @"52", @"53", @"62", @"63", @"68", @"68副", @"72", @"74", @"108", @"108區(二子坪)", @"109", @"111", nil];
    section1Zh = [NSArray arrayWithObjects:@"201", @"202", @"202區", @"203", @"204", @"205", @"206", @"207", @"208", @"208區", @"208直", @"211", @"212", @"212區", @"212夜", @"212直", @"214", @"214直", @"215", @"216副", @"216區", @"218", @"218區", @"218直", @"220", @"220夜", @"220直", @"221", @"222", @"223", @"224", @"225", @"225區", @"226", @"227", @"227區", @"230", @"231", @"232", @"232副", @"232快", @"234", @"235", @"236", @"236區", @"236夜", @"237", @"240", @"240直", @"241", @"242", @"243", @"245", @"246", @"247", @"247區", @"248", @"249", @"250", @"251", @"251區", @"252", @"253", @"254", @"255", @"255區", @"256", @"257", @"260", @"260區", @"261", @"262", @"262區", @"263", @"265區", @"265夜", @"265經中央路", @"265經明德路", @"266", @"266區", @"267", @"268", @"270", @"270區", @"274", @"276", @"277", @"278", @"278區", @"279", @"280", @"280直", @"281", @"282", @"282副", @"284", @"284直", @"285", @"286", @"286副", @"287", @"287區", @"287夜", @"288", @"288區", @"290", @"290副", @"292", @"292副", @"294", @"295", @"297", @"298", @"298區", @"299", @"299區", nil];
    section2Zh = [NSArray arrayWithObjects:@"302", @"303", @"303區", @"304承德", @"304重慶", @"306", @"306區", @"307", @"308", @"310", @"311", @"505", @"508", @"508區", @"513", @"518", @"520", @"521", @"527", @"529", @"530", @"531", @"535", @"536", @"537", @"539", @"542", @"550", @"551", @"552", @"553", @"555", @"556", nil];
    section3Zh = [NSArray arrayWithObjects:@"601", @"602", @"604", @"605", @"605副", @"605快", @"605新台五", @"606", @"611", @"612", @"612區", @"615", @"616", @"617", @"618", @"620", @"620區", @"621", @"622", @"624", @"629", @"630", @"631", @"632", @"635", @"635副", @"636", @"637", @"638", @"639", @"640", @"641", @"642", @"643", @"644", @"645", @"645副", @"646", @"646區", @"647", @"648", @"650", @"651", @"652", @"656", @"658", @"659", @"660", @"662", @"663", @"665", @"666", @"667", @"668", @"669", @"670", @"671", @"672", @"672區", @"673", @"675", @"676", @"677", @"678", @"679", @"680", @"681", @"685", nil];
    section4Zh = [NSArray arrayWithObjects:@"701", @"702", @"705", @"706", @"711", @"756", @"902", @"903", @"905", @"905副", @"906", @"906副", @"907", @"909", @"912", @"915", nil];
    section5Zh = [NSArray arrayWithObjects:@"市民小巴1", @"市民小巴2", @"市民小巴3", @"市民小巴5", @"市民小巴6", @"市民小巴7", @"市民小巴8", @"市民小巴9", @"市民小巴10", @"市民小巴11", @"市民小巴12", @"市民小巴15", nil];
    section6Zh = [NSArray arrayWithObjects:@"景美-榮總(快)", @"貓空右線", @"貓空左線(動物園)", @"貓空左線(指南宮)", @"南軟專車(中和)", @"南軟專車(北投)", @"南軟專車(天母)", @"南軟專車(雙和)", @"懷恩專車S31(公館六張犁)", @"懷恩專車S31(捷運忠孝復興)", nil];
    section7Zh = [NSArray arrayWithObjects:@"小1", @"小1區", @"小2", @"小2區", @"小3", @"小3區", @"小5", @"小5區", @"小6", @"小7", @"小8", @"小9", @"小10", @"小11", @"小12", @"小12區", @"小14", @"小15", @"小15區", @"小16", @"小17", @"小18", @"小18區", @"小19", @"小21", @"小22", @"小23", @"小25", @"小26", @"小28", nil];
    section8Zh = [NSArray arrayWithObjects:@"敦化幹線", @"忠孝新幹線", @"和平幹線", @"中山幹線", @"信義幹線", @"信義幹線(副)", @"信義新幹線", @"重慶幹線(中興)", @"博愛公車", nil];
    section9Zh = [NSArray arrayWithObjects:@"內科圓山線直達車", @"內科通勤專車1", @"內科通勤專車2", @"內科通勤專車3", @"內科通勤專車5", @"內科通勤專車6", @"內科通勤專車7", @"內科通勤專車8", @"內科通勤專車9", @"內科通勤專車10", @"內科通勤專車11", @"內科通勤專車12", @"內科通勤專車13", @"內科通勤專車15", @"內科通勤專車16", @"內科通勤專車17", @"內科通勤專車18", @"內科通勤專車19", @"內科通勤專車20", @"市府線直達車", nil];
    section10Zh = [NSArray arrayWithObjects:@"紅2", @"紅7區", @"紅30", @"紅31", @"紅32", @"紅50", @"藍10", @"棕9", @"1", @"12", @"15", @"21", @"72", @"74", @"202", @"203", @"204", @"205", @"206", @"207", @"208", @"214", @"214直", @"220", @"263", @"266", @"266區", @"270", @"270區", @"280", @"280直", @"282", @"282副", @"284", @"284直", @"285", @"287", @"304承德", @"304重慶", @"307", @"518", @"601", @"620", @"630", @"645", @"645副", @"671", @"680", @"685", @"902", @"忠孝新幹線", @"信義新幹線", nil];
    section11Zh = [NSArray arrayWithObjects:@"紅2", @"紅3", @"紅5", @"紅7", @"紅7區", @"紅9", @"紅10", @"紅12", @"紅15", @"紅19", @"紅25", @"紅29", @"紅30", @"紅31", @"紅32", @"紅33", @"紅34", @"紅35", @"紅50", nil];
    section12Zh = [NSArray arrayWithObjects:@"藍2", @"藍5", @"藍7", @"藍10", @"藍12", @"藍20區", @"藍25", @"藍26", @"藍27", @"藍28", @"藍29", @"藍36", @"藍50", @"藍51", nil];
    section13Zh = [NSArray arrayWithObjects:@"棕1", @"棕2", @"棕3", @"棕5", @"棕6", @"棕7", @"棕9", @"棕10", @"棕11", @"棕11副", @"棕12", @"棕13", @"棕15", @"棕15區", @"棕16", @"棕18", @"棕19", @"棕20", @"棕21", nil];
    section14Zh = [NSArray arrayWithObjects:@"綠1", @"綠2右", @"綠2左", @"綠11", nil];
    
    section0Depart = [NSArray arrayWithObjects:@"內湖", @"萬芳社區", @"華江", @"台北海院", @"麟光新村", @"中和", @"社子", @"東園", @"蘆洲", @"萬芳社區", @"萬華", @"松德路", @"東湖", @"東湖", @"吳興街", @"吳興街", @"社子", @"大直", @"吳興站", @"吳興站", @"永春高中", @"松德站", @"環南市場", @"寶興街", @"三重", @"三重", @"士林高商", @"基河二期國宅", @"大直", @"松德", @"建國北路", @"汐止", @"興隆站", @"瓏山林社區", @"三重", @"內湖", @"洲美里", @"洲美運動公園", @"捷運麟光站", @"建國北路", @"陽明山公車總站", @"二子坪", @"萬芳站", @"新莊", nil];
    section1Depart = [NSArray arrayWithObjects:@"中和", @"中和", @"錦繡", @"汐止社后", @"東園", @"中華科技大學", @"天母", @"內湖", @"中和", @"中和", @"大直", @"二重", @"舊庄", @"舊莊", @"舊庄", @"舊庄", @"中和", @"中和", @"臺北海院", @"關渡", @"新北投", @"新北投", @"新北投", @"新北投", @"天母", @"天母", @"天母", @"蘆洲", @"內湖", @"關渡", @"天母", @"蘆洲", @"蘆洲", @"三重", @"三重", @"三重", @"捷運北投站", @"德霖技術學院", @"蘆洲", @"蘆洲", @"蘆洲", @"板橋", @"新莊", @"東南科技大學", @"動物園", @"東南科技大學", @"動物園", @"東湖", @"東湖", @"中和", @"中和", @"中和", @"德霖技術學院", @"普濟堂", @"東湖", @"東湖", @"錦繡", @"華夏學院", @"後港里", @"東南科技大學", @"東南科技大學", @"石壁坑", @"景美女中", @"中央站", @"雙溪", @"雙溪", @"大直", @"新莊高中", @"陽明山", @"陽明山", @"蘆洲", @"德霖技術學院", @"中和", @"松山商職", @"重慶國中", @"土城", @"土城", @"土城", @"新北投", @"文林國小", @"金龍寺", @"天母", @"中華科技大學", @"凌雲五村", @"蘆洲", @"舊莊", @"松德站", @"捷運景美站", @"捷運景美站", @"天母", @"天母", @"天母", @"東湖", @"動物園", @"動物園", @"汐止社后", @"汐止社后", @"麟光新村", @"福德街", @"福德街", @"東湖", @"東湖", @"東湖", @"捷運明德站", @"士林高商", @"溪園路", @"興隆站", @"二重", @"二重", @"動物園", @"動物園", @"中和站", @"萬芳社區", @"大安國宅", @"輔大", @"輔大", nil];
    section2Depart = [NSArray arrayWithObjects:@"關渡宮", @"捷運劍潭站", @"捷運劍潭站", @"故宮", @"故宮", @"蘆洲", @"舊庄", @"撫遠街", @"淡江大學", @"板橋國中", @"中和", @"撫遠街", @"泰山公有市場", @"蘆洲", @"輔仁大學", @"麥帥新城", @"新北產業園區", @"內湖", @"建國北路", @"士林高商", @"指南宮", @"紫雲里", @"捷運石牌站", @"台北海院", @"捷運市政府站", @"三重", @"捷運圓山站", @"關渡宮", @"台北花市", @"金龍寺", @"東湖", @"松德站", @"木柵象頭埔", nil];
    section3Depart = [NSArray arrayWithObjects:@"天母", @"天母", @"板橋", @"汐止", @"汐止", @"汐止", @"汐止", @"萬芳社區", @"動物園站", @"松德站", @"松德站", @"丹鳳", @"泰山", @"新莊", @"新莊", @"科學教育館", @"後港里", @"二重", @"新莊高中", @"新店", @"汐止", @"東園", @"淡水", @"八里", @"迴龍", @"迴龍", @"迴龍", @"五股", @"五股", @"樹林", @"五股", @"五股坑", @"青潭", @"錦繡山莊", @"青潭", @"舊莊", @"中華科技大學", @"東湖", @"東湖", @"大崎腳", @"錦繡山莊", @"大崎腳", @"板橋", @"新莊高中", @"德霖學院", @"板橋", @"蘆洲", @"深坑", @"三重", @"新莊二站", @"榮總", @"景美站", @"板橋", @"汐止", @"三重市", @"華夏學院", @"景美女中", @"大鵬新城", @"大鵬新城", @"大鵬新村", @"汐止", @"動物園", @"汐止社后", @"汐止", @"動物園", @"天母", @"東湖", @"麟光新村", nil];
    section4Depart = [NSArray arrayWithObjects:@"迴龍", @"三峽", @"三峽", @"三峽", @"汐止", @"淡江大學", @"麟光站", @"東湖", @"新店錦繡", @"錦繡", @"錦繡山莊", @"錦繡山莊", @"華江", @"錦繡山莊", @"深坑", @"景美", nil];
    section5Depart = [NSArray arrayWithObjects:@"捷運劍潭站", @"捷運北投站", @"陽明山", @"興得閱覽室", @"舊莊", @"麟光新村", @"洲美", @"大佳河濱公園", @"麥帥新城", @"天母", @"捷運芝山站", @"捷運昆陽站", nil];
    section6Depart = [NSArray arrayWithObjects:@"景美女中", @"貓纜貓空站", @"貓覽貓空站", @"茶推廣中心停車場", @"中和", @"新北投", @"天母", @"土城", @"第二殯儀館", @"八德市場", nil];
    section7Depart = [NSArray arrayWithObjects:@"中華技術學院", @"內溝", @"石崁", @"國立臺灣戲曲學院", @"捷運昆陽站", @"捷運昆陽站", @"捷運昆陽站", @"捷運昆陽站", @"北投站", @"北投站", @"捷運石牌站", @"北投站", @"萬芳社區", @"萬芳社區", @"捷運昆陽站", @"捷運昆陽站", @"北投", @"捷運劍潭站", @"捷運劍潭站", @"捷運劍潭站", @"捷運劍潭站", @"捷運劍潭站", @"捷運劍潭站", @"捷運劍潭站", @"復興站", @"捷運北投站", @"關渡碼頭", @"捷運北投站", @"北投站", @"捷運北投站", nil];
    section8Depart = [NSArray arrayWithObjects:@"建國北路", @"台北車站", @"萬華", @"天母", @"福德街", @"永春高中", @"捷運昆陽站", @"故宮博物院", @"松德站", nil];
    section9Depart = [NSArray arrayWithObjects:@"捷運圓山站", @"中和高中", @"中和高中", @"土城駕訓中心", @"捷運市政府站", @"蘆洲站", @"汐止車站", @"松山車站", @"捷運中山國中站", @"新店錦繡", @"新莊", @"新莊", @"天母", @"天母", @"北投", @"士林", @"捷運民權西路站", @"捷運市政府站", @"捷運市政府站", @"捷運市政府站", nil];
    section10Depart = [NSArray arrayWithObjects:@"汐止社后", @"社子", @"故宮", @"金龍路", @"南港", @"內湖", @"民生社區", @"東湖", @"華江", @"東園", @"萬芳社區", @"東湖", @"捷運麟光站", @"建國北路", @"中和", @"汐止社后", @"東園", @"中華科技大學", @"天母", @"內湖", @"中和", @"中和", @"中和", @"天母", @"松山商職", @"新北投", @"文林國小", @"中華科技大學", @"凌雲五村", @"天母", @"天母", @"動物園", @"動物園", @"汐止社后", @"汐止社后", @"麟光新村", @"東湖", @"故宮", @"故宮", @"撫遠街", @"麥帥新城", @"天母", @"科學教育館", @"東園", @"舊莊", @"中華科技大學", @"景美女中", @"天母", @"麟光新村", @"麟光站", @"台北車站", @"捷運昆陽站", nil];
    section11Depart = [NSArray arrayWithObjects:@"汐止社后", @"社子站", @"捷運劍潭站", @"捷運劍潭站", @"社子", @"蘆洲", @"臺北海院", @"市立天文館", @"天母", @"天母", @"南港", @"內湖", @"故宮", @"金龍路", @"南港", @"葫蘆里", @"捷運圓山站", @"關渡碼頭", @"內湖", nil];
    section12Depart = [NSArray arrayWithObjects:@"新莊", @"吳興街", @"大直", @"民生社區", @"東湖", @"大直", @"中華技術學院", @"舊宗路", @"內湖行政中心", @"興隆站", @"華中河濱公園", @"汐止社后", @"新湖二路", @"捷運昆陽站", nil];
    section13Depart = [NSArray arrayWithObjects:@"內湖站", @"景美女中", @"捷運動物園", @"萬芳社區", @"捷運動物園站", @"新店", @"東湖", @"大湖山莊", @"動物園", @"捷運動物園站", @"景美", @"雙溪", @"捷運動物園站", @"水鋼琴社區", @"台北花市", @"政治大學", @"南港車站", @"內科", @"政大里", nil];
    section14Depart = [NSArray arrayWithObjects:@"新店", @"景美", @"景美", @"萬芳社區", nil];
    
    section0Destin = [NSArray arrayWithObjects:@"台北車站", @"捷運東門站", @"吳興國小", @"台大醫院", @"捷運古亭站", @"行天宮", @"萬華", @"民生社區", @"台北車站", @"衡陽路", @"捷運麟光站", @"衡陽路", @"台北橋", @"臺北橋", @"衡陽路", @"台北車站", @"行天宮", @"市政府", @"南港國宅", @"捷運市政府站", @"基河二期國宅", @"捷運臺大醫院", @"吳興街", @"捷運龍山寺站", @"台北車站", @"台北車站", @"捷運大安站", @"北門", @"捷運圓山站", @"台北橋", @"東園", @"南港車站", @"中興醫院", @"西松國中", @"東園", @"台北車站", @"捷運劍潭站", @"捷運劍潭站", @"大直", @"景美", @"陽明山公車總站", @"陽明山", @"陽明山公車總站", @"陽明山", nil];
    section1Destin = [NSArray arrayWithObjects:@"龍山寺", @"市政府", @"台北科技大學", @"天母", @"麥帥新城", @"東園", @"中華路", @"南勢角", @"大直", @"公館", @"中和", @"捷運麟光站", @"青年公園", @"捷運昆陽站", @"青年公園", @"青年公園", @"內湖", @"松山機場", @"台北車站", @"捷運劍潭站", @"捷運劍潭站", @"萬華", @"捷運奇岩站", @"萬華", @"衡陽路", @"衡陽路", @"衡陽路", @"台北車站", @"衡陽路", @"青年公園", @"捷運石牌站", @"民生社區", @"松山機場", @"吳興街", @"永和", @"捷運民權西路站", @"陽明山", @"捷運西門站", @"松山車站", @"松山車站", @"松山車站", @"西門", @"國父紀念館", @"台北車站", @"公館", @"台北車站", @"金甌女中", @"國父紀念館", @"國父紀念館", @"博愛路", @"西門", @"西門", @"台北市政府", @"果菜市場", @"衡陽路", @"捷運圓山站", @"民生社區", @"台北車站", @"永和", @"臺北車站", @"公館", @"台北車站", @"台北車站", @"民生社區", @"台北車站", @"士林", @"南松山", @"忠孝醫院", @"東園", @"台北車站", @"南港", @"民生社區", @"民生社區", @"五福新村", @"行政院", @"行政院", @"行政院", @"成功中學", @"捷運市政府站", @"捷運市政府站", @"天母", @"麗山高中", @"中華路", @"市政府", @"台北車站", @"凌雲站", @"榮總站", @"金龍路(捷運內湖站)", @"民生社區", @"東湖", @"公館", @"公館", @"市政府", @"圓環", @"圓環", @"景美", @"景美", @"榮總", @"捷運西湖站", @"行天宮", @"衡陽路", @"捷運圓山站", @"衡陽路", @"吳興街", @"吳興街", @"榮總", @"溪園路", @"捷運麟光站", @"捷運麟光站", @"仁愛國中", @"台北車站", @"中山市場", @"行天宮", @"第二果菜市場", @"永春高中", @"臺北車站", nil];
    section2Destin = [NSArray arrayWithObjects:@"萬華", @"大坪尾", @"平等里", @"永和", @"永和", @"凌雲五村", @"台北橋", @"板橋前站", @"捷運劍潭站", @"士林", @"松山", @"景美", @"大同之家", @"惇敘高工", @"捷運台大醫院站", @"圓環", @"捷運民權西路", @"捷運忠孝復興站", @"萬華", @"新光醫院", @"捷運公館站", @"南松山", @"六窟", @"大同之家", @"世貿中心", @"台北車站", @"捷運中山國中站", @"洲美運動公園", @"捷運昆陽站", @"捷運市政府站", @"捷運劍南路站", @"捷運忠孝復興站", @"捷運劍潭站", nil];
    section3Destin = [NSArray arrayWithObjects:@"東園", @"北投", @"民生社區", @"台北車站", @"台北車站", @"台北車站", @"台北車站", @"榮總", @"松山車站", @"大同之家", @"榮總", @"台北車站", @"天母", @"內湖", @"士林", @"中華科技大學", @"南港高工", @"捷運永春站", @"南港", @"台北", @"南松山", @"東湖", @"北投", @"北投", @"台北", @"台北", @"圓環", @"台北", @"捷運南京東路站", @"北門", @"台北", @"台北車站", @"復興北村", @"復興北村", @"博愛路", @"榮總", @"榮總", @"榮總", @"捷運劍潭站", @"捷運市政府站", @"台北車站", @"捷運市政府站", @"臺北市政府", @"內湖", @"捷運台大醫院", @"西門", @"台北車站", @"圓環", @"國父紀念館", @"國父紀念館", @"信義國中", @"烏塗窟", @"捷運西門站", @"公館", @"市政府", @"台北車站", @"台北車站", @"民生社區", @"捷運公館站", @"東園", @"捷運公館站", @"行天宮", @"捷運圓山站", @"捷運巿府站", @"金龍寺", @"麟光", @"陽明山", @"天母", nil];
    section4Destin = [NSArray arrayWithObjects:@"西門", @"西門", @"西門", @"西門", @"圓環", @"北門", @"捷運石牌站", @"忠孝東路", @"民生社區", @"民生社區", @"松山機場", @"松山機場", @"崇義高中", @"松山機場", @"捷運市政府站", @"捷運市府站", nil];
    section5Destin = [NSArray arrayWithObjects:@"風櫃嘴", @"北投溫泉博物館", @"新園街", @"捷運景美站", @"捷運南港站", @"捷運市政府站", @"後港里", @"中興醫院", @"三民國中", @"捷運芝山站", @"社子里", @"捷運南港展覽館站", nil];
    section6Destin = [NSArray arrayWithObjects:@"榮總", @"貓纜貓空站", @"捷運動物園", @"貓纜指南宮站", @"南港軟體園區", @"南港軟體園區", @"南港軟體園區", @"南港軟體園區", @"第二殯儀館", @"第二殯儀館", nil];
    section7Destin = [NSArray arrayWithObjects:@"內溝", @"捷運昆陽站", @"捷運市政府站", @"石崁", @"翠柏新村", @"清白里", @"光明寺", @"光明寺", @"清天宮", @"嶺頭", @"竹子湖", @"竹子湖", @"貓空", @"大春山莊", @"貓纜動物園站", @"中華科技大學", @"照明寺", @"擎天崗", @"菁山遊憩園區", @"公館里", @"新安里", @"聖人瀑布", @"故宮", @"平等里", @"八仙里", @"泉源路", @"北投國小", @"六窟", @"頂湖", @"登山路", nil];
    section8Destin = [NSArray arrayWithObjects:@"中和成功路", @"南港展覽館", @"捷運麟光站", @"南門市場", @"台北車站", @"台北車站", @"衡陽路", @"衡陽路", @"榮總站", nil];
    section9Destin = [NSArray arrayWithObjects:@"新湖舊宗路口", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", @"內湖科技園區", nil];
    section10Destin = [NSArray arrayWithObjects:@"捷運圓山站", @"捷運劍潭站", @"捷運劍潭站", @"捷運民權西路站", @"台北橋", @"捷運圓山站", @"南港國宅", @"圓環", @"吳興國小", @"民生社區", @"衡陽路", @"台北橋", @"大直", @"景美", @"市政府", @"天母", @"麥帥新城", @"東園", @"中華路", @"南勢角", @"大直", @"內湖", @"松山機場", @"衡陽路", @"五福新村", @"捷運市政府站", @"捷運市政府站", @"中華路", @"市政府", @"公館", @"公館", @"圓環", @"圓環", @"景美", @"景美", @"榮總", @"衡陽路", @"永和", @"永和", @"板橋前站", @"圓環", @"東園", @"中華科技大學", @"東湖", @"榮總", @"榮總", @"台北車站", @"麟光", @"天母", @"捷運石牌站", @"南港展覽館", @"衡陽路", nil];
    section11Destin = [NSArray arrayWithObjects:@"捷運圓山站", @"台北花市", @"陽明山", @"社子", @"捷運劍潭站", @"捷運劍潭站", @"捷運劍潭站", @"捷運石牌站", @"社子", @"士林", @"圓環", @"捷運民權西路站", @"捷運劍潭站", @"捷運民權西路站", @"台北橋", @"中興醫院", @"大佳河濱公園", @"捷運關渡站", @"捷運圓山站", nil];
    section12Destin = [NSArray arrayWithObjects:@"捷運西門站", @"捷運市政府站", @"捷運市政府站", @"南港國宅", @"南港車站", @"捷運昆陽站", @"捷運昆陽站", @"捷運市政府站", @"捷運市政府站", @"東園", @"龍山寺", @"捷運昆陽站", @"捷運昆陽站", @"內湖安泰里", nil];
    section13Destin = [NSArray arrayWithObjects:@"松山機場", @"萬芳社區", @"萬芳社區", @"指南宮", @"捷運市政府站", @"台北市政府", @"圓環", @"捷運南京東路站", @"捷運公館站", @"福興路", @"客家文化主題公園", @"捷運大直站", @"貓空", @"捷運動物園站", @"松山機場", @"捷運市政府站", @"捷運大湖公園站", @"故宮博物院", @"捷運市政府站", nil];
    section14Destin = [NSArray arrayWithObjects:@"台北市政府", @"中永和", @"中永和", @"台電大樓", nil];
    
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
    NSMutableArray * containers8 = [NSMutableArray new];
    [containers8 addObject:section8Zh];
    [containers8 addObject:section8Depart];
    [containers8 addObject:section8Destin];
    NSMutableArray * containers9 = [NSMutableArray new];
    [containers9 addObject:section9Zh];
    [containers9 addObject:section9Depart];
    [containers9 addObject:section9Destin];
    NSMutableArray * containers10 = [NSMutableArray new];
    [containers10 addObject:section10Zh];
    [containers10 addObject:section10Depart];
    [containers10 addObject:section10Destin];
    NSMutableArray * containers11 = [NSMutableArray new];
    [containers11 addObject:section11Zh];
    [containers11 addObject:section11Depart];
    [containers11 addObject:section11Destin];
    NSMutableArray * containers12 = [NSMutableArray new];
    [containers12 addObject:section12Zh];
    [containers12 addObject:section12Depart];
    [containers12 addObject:section12Destin];
    NSMutableArray * containers13 = [NSMutableArray new];
    [containers13 addObject:section13Zh];
    [containers13 addObject:section13Depart];
    [containers13 addObject:section13Destin];
    NSMutableArray * containers14 = [NSMutableArray new];
    [containers14 addObject:section14Zh];
    [containers14 addObject:section14Depart];
    [containers14 addObject:section14Destin];
    
    self.allData = [[NSDictionary alloc] initWithObjectsAndKeys:containers0, @"0", containers1, @"201",containers2,  @"302",containers3,  @"601",containers4,  @"701",containers5,  @"市",containers6,  @"其他",containers7,  @"小",containers8,  @"幹線",containers9,  @"內科",containers10,  @"低",containers11,  @"紅",containers12,  @"藍",containers13,  @"棕",containers14,  @"綠", nil];
    
    allKeys = [[NSArray alloc] initWithObjects:@"0", @"201", @"302", @"601", @"701", @"市", @"其他", @"小", @"幹線", @"內科", @"低", @"紅", @"藍", @"棕", @"綠", nil];
    
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
    [section7Depart retain];
    [section8Depart retain];
    [section9Depart retain];
    [section10Depart retain];
    [section11Depart retain];
    [section12Depart retain];
    [section13Depart retain];
    [section14Depart retain];
    
    [section0Destin retain];
    [section1Destin retain];
    [section2Destin retain];
    [section3Destin retain];
    [section4Destin retain];
    [section5Destin retain];
    [section6Destin retain];
    [section7Destin retain];
    [section8Destin retain];
    [section9Destin retain];
    [section10Destin retain];
    [section11Destin retain];
    [section12Destin retain];
    [section13Destin retain];
    [section14Destin retain];
    
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
    self.section8Zh = nil;
    self.section9Zh = nil;
    self.section10Zh = nil;
    self.section11Zh = nil;
    self.section12Zh = nil;
    self.section13Zh = nil;
    self.section14Zh = nil;
    
    self.section0Depart = nil;
    self.section1Depart = nil;
    self.section2Depart = nil;
    self.section3Depart = nil;
    self.section4Depart = nil;
    self.section5Depart = nil;
    self.section6Depart = nil;
    self.section7Depart = nil;
    self.section8Depart = nil;
    self.section9Depart = nil;
    self.section10Depart = nil;
    self.section11Depart = nil;
    self.section12Depart = nil;
    self.section13Depart = nil;
    self.section14Depart = nil;
    
    self.section0Destin = nil;
    self.section1Destin = nil;
    self.section2Destin = nil;
    self.section3Destin = nil;
    self.section4Destin = nil;
    self.section5Destin = nil;
    self.section6Destin = nil;
    self.section7Destin = nil;
    self.section8Destin = nil;
    self.section9Destin = nil;
    self.section10Destin = nil;
    self.section11Destin = nil;
    self.section12Destin = nil;
    self.section13Destin = nil;
    self.section14Destin = nil;
    
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
    [section8Zh release];
    [section9Zh release];
    [section10Zh release];
    [section11Zh release];
    [section12Zh release];
    [section13Zh release];
    [section14Zh release];
    
    [section0Depart release];
    [section1Depart release];
    [section2Depart release];
    [section3Depart release];
    [section4Depart release];
    [section5Depart release];
    [section6Depart release];
    [section7Depart release];
    [section8Depart release];
    [section9Depart release];
    [section10Depart release];
    [section11Depart release];
    [section12Depart release];
    [section13Depart release];
    [section14Depart release];
    
    [section0Destin release];
    [section1Destin release];
    [section2Destin release];
    [section3Destin release];
    [section4Destin release];
    [section5Destin release];
    [section6Destin release];
    [section7Destin release];
    [section8Destin release];
    [section9Destin release];
    [section10Destin release];
    [section11Destin release];
    [section12Destin release];
    [section13Destin release];
    [section14Destin release];
    
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
    NSLog(@"TP viewWillAppear");
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
    KLRouteGoBackViewController * routeGoBack = [KLRouteGoBackViewController new];
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
