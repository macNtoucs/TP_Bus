//
//  TWRailViewController.h
//  bus
//
//  Created by NTOUCS on 13/5/31.
//
//

#import <UIKit/UIKit.h>
#import "TWRailDepartureViewController.h"
#import "TWRailDestinationViewController.h"

@interface TWRailViewController : UIViewController
{
    UIButton *departButton;
    UIButton *destinButton;
    UIButton *dateButton;
    UIButton *categoryButton;
    UIButton *searchButton;
    UIButton *arrowButton;
    NSString *strDepart;
    NSString *strDestin;
}
@property (nonatomic, retain) UIButton *departButton;
@property (nonatomic, retain) UIButton *destinButton;
@property (nonatomic, retain) UIButton *dateButton;
@property (nonatomic, retain) UIButton *categoryButton;
@property (nonatomic, retain) UIButton *searchButton;
@property (nonatomic, retain) UIButton *arrowButton;
@property (nonatomic, retain) NSString *strDepart;
@property (nonatomic, retain) NSString *strDestin;
@end
