//
//  IndexViewController.h
//  bus
//
//  Created by NTOUCS on 13/6/14.
//
//

#import <UIKit/UIKit.h>
#import "TPRootViewController.h"
#import "SetStationViewController.h"

@interface IndexViewController : UIViewController
{
    UIButton *enterBus;
    UIButton *enterTWRail;
    UIButton *enterTWHSRail;
    UIButton *enterPassTrans;
}
@property (nonatomic, retain) UIButton *enterBus;
@property (nonatomic, retain) UIButton *enterTWRail;
@property (nonatomic, retain) UIButton *enterTWHSRail;
@property (nonatomic, retain) UIButton *enterPassTrans;
@end
