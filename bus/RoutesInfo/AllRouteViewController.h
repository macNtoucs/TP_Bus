//
//  TPAllRouteViewController.h
//  bus
//
//  Created by iMac on 12/9/5.
//
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "TFHppleElement.h"

@interface AllRouteViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray * area;
}

@property (nonatomic, retain) NSArray * area;

@end

