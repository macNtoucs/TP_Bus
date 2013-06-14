//
//  TWRailDepartureViewController.h
//  bus
//
//  Created by NTOUCS on 13/6/14.
//
//

#import <UIKit/UIKit.h>

@interface TWRailDepartureViewController : UITableViewController
{
    NSArray *region;
    NSArray *station;
    NSMutableArray *stationName;
}
@property (nonatomic, retain) NSArray *region;
@property (nonatomic, retain) NSArray *station;
@property (nonatomic, retain) NSMutableArray *stationName;
@end
