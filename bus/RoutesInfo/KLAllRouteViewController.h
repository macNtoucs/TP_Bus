//
//  TPAllRouteViewController.h
//  bus
//
//  Created by iMac on 13/3/15.
//
//

#import <UIKit/UIKit.h>

@interface KLAllRouteViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    NSArray * section0Zh, * section1Zh, * section2Zh, * section3Zh, * section4Zh, * section5Zh, * section6Zh, * section7Zh;
    NSArray * section0Depart, * section1Depart, * section2Depart, * section3Depart, * section4Depart, * section5Depart, * section6Depart, * section7Depart;
    NSArray * section0Destin, * section1Destin, * section2Destin, * section3Destin, * section4Destin, * section5Destin, * section6Destin, * section7Destin;
    
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

@property (nonatomic, retain) NSArray * section0Zh, * section1Zh, * section2Zh, * section3Zh, * section4Zh, * section5Zh, * section6Zh, * section7Zh;
@property (nonatomic, retain) NSArray * section0Depart, * section1Depart, * section2Depart, * section3Depart, * section4Depart, * section5Depart, * section6Depart, * section7Depart;
@property (nonatomic, retain) NSArray * section0Destin, * section1Destin, * section2Destin, * section3Destin, * section4Destin, * section5Destin, * section6Destin, * section7Destin;

@property (nonatomic, retain) IBOutlet UITableView * table;
@property (nonatomic, retain) IBOutlet UISearchBar * search;
@property (nonatomic, retain) NSDictionary * allData;
@property (nonatomic, retain) NSMutableDictionary * searchData;
@property (nonatomic, retain) NSArray * allKeys;
@property (nonatomic, retain) NSMutableArray * keys;

- (void) resetSearch;
- (void) handleSearchForTerm:(NSString *)searchTerm;

@end
