//
//  TPAllRouteViewController.h
//  bus
//
//  Created by iMac on 13/3/15.
//
//

#import <UIKit/UIKit.h>

@interface TPAllRouteViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    /*NSArray * allBusNameZh;
     NSArray * departureNameZh;
     NSArray * destinationNameZh;*/
    
    NSArray * section0Zh, * section1Zh, * section2Zh, * section3Zh, * section4Zh, * section5Zh, * section6Zh, * section7Zh, * section8Zh, * section9Zh, * section10Zh, * section11Zh, * section12Zh, * section13Zh, * section14Zh;
    NSArray * section0Depart, * section1Depart, * section2Depart, * section3Depart, * section4Depart, * section5Depart, * section6Depart, * section7Depart, * section8Depart, * section9Depart, * section10Depart, * section11Depart, * section12Depart, * section13Depart, * section14Depart;
    NSArray * section0Destin, * section1Destin, * section2Destin, * section3Destin, * section4Destin, * section5Destin, * section6Destin, * section7Destin, * section8Destin, * section9Destin, * section10Destin, * section11Destin, * section12Destin, * section13Destin, * section14Destin;
    
    // ---------- UISearchBar -------------------------
    UITableView * table;
    UISearchBar * search;
    NSDictionary * allData;
    NSMutableDictionary * searchData;
    NSArray * allKeys;
    NSMutableArray * keys;
    BOOL isSearch;
    
    // ---------- Background appear when searchBar is tapped ----------
    UIButton * backgroundButton;
    BOOL clearNeeded;
    
    // ---------- dismiss keyboard when user scrolls ----------
    CGPoint startLocation;
    BOOL isScrolled;
    
}
/*@property (nonatomic, retain) NSArray * allBusNameZh;
 @property (nonatomic, retain) NSArray * departureNameZh;
 @property (nonatomic, retain) NSArray * destinationNameZh;*/

@property (nonatomic, retain) NSArray * section0Zh, * section1Zh, * section2Zh, * section3Zh, * section4Zh, * section5Zh, * section6Zh, * section7Zh, * section8Zh, * section9Zh, * section10Zh, * section11Zh, * section12Zh, * section13Zh, * section14Zh;
@property (nonatomic, retain) NSArray * section0Depart, * section1Depart, * section2Depart, * section3Depart, * section4Depart, * section5Depart, * section6Depart, * section7Depart, * section8Depart, * section9Depart, * section10Depart, * section11Depart, * section12Depart, * section13Depart, * section14Depart;
@property (nonatomic, retain) NSArray * section0Destin, * section1Destin, * section2Destin, * section3Destin, * section4Destin, * section5Destin, * section6Destin, * section7Destin, * section8Destin, * section9Destin, * section10Destin, * section11Destin, * section12Destin, * section13Destin, * section14Destin;

@property (nonatomic, retain) IBOutlet UITableView * table;
@property (nonatomic, retain) IBOutlet UISearchBar * search;
@property (nonatomic, retain) NSDictionary * allData;
@property (nonatomic, retain) NSMutableDictionary * searchData;
@property (nonatomic, retain) NSArray * allKeys;
@property (nonatomic, retain) NSMutableArray * keys;

- (void) resetSearch;
- (void) handleSearchForTerm:(NSString *)searchTerm;

@end
