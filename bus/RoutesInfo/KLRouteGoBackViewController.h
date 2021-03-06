//
//  TPRouteGoBackViewController.h
//  bus
//
//  Created by iMac on 12/10/29.
//
//

#import <UIKit/UIKit.h>

@interface KLRouteGoBackViewController : UITableViewController
{
    //NSString * departure;   // 存起始站牌名稱
    //NSString * destination; // 存終點站牌名稱
    NSString * busName; // 存取公車名稱
    NSString * busNumber; // 存取公車編號
    NSMutableArray * routeNames; // 存取公車不同路線名稱
    NSMutableArray * departures;   // 存起始站牌名稱
    NSMutableArray * destinations; // 存終點站牌名稱
    NSMutableArray * IDs; // 存ID
}

@property (nonatomic, retain) NSString * busName;
@property (nonatomic, retain) NSString * busNumber;
@property (nonatomic, retain) NSMutableArray * routeNames;
@property (nonatomic, retain) NSMutableArray * departures;
@property (nonatomic, retain) NSMutableArray * destinations;
@property (nonatomic, retain) NSMutableArray * IDs;
//@property (nonatomic, retain) NSString * departure;
//@property (nonatomic, retain) NSString * destination;

//- (void) setter_departure:(NSString *) name;    // 取得所點選的公車路線起始位置
//- (void) setter_destination:(NSString *) name;  // 取得所點選的公車路線終點位置
- (void) setter_busNameAndNumber:(NSString *) name; // 取得公車名稱

@end
