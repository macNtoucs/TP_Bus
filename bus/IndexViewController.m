//
//  IndexViewController.m
//  bus
//
//  Created by NTOUCS on 13/6/14.
//
//

#import "IndexViewController.h"
#import "KUO_RouteViewController_Bra2.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

@synthesize enterBus;
@synthesize enterTWRail;
@synthesize enterTWHSRail;
@synthesize enterPassTrans;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    enterBus = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [enterBus addTarget:self action:@selector(enterNextPage:) forControlEvents:UIControlEventTouchDown];
    [enterBus setTitle:@"公車" forState:UIControlStateNormal];
    enterBus.frame = CGRectMake(40.0, 40.0, 80.0, 80.0);
    enterBus.tag = 0;
    
    enterTWRail = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [enterTWRail addTarget:self action:@selector(enterNextPage:) forControlEvents:UIControlEventTouchDown];
    [enterTWRail setTitle:@"台鐵" forState:UIControlStateNormal];
    enterTWRail.frame = CGRectMake(160.0, 40.0, 80.0, 80.0);
    enterTWRail.tag = 1;
    
    enterTWHSRail = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [enterTWHSRail addTarget:self action:@selector(enterNextPage:) forControlEvents:UIControlEventTouchDown];
    [enterTWHSRail setTitle:@"高鐵" forState:UIControlStateNormal];
    enterTWHSRail.frame = CGRectMake(40.0, 160.0, 80.0, 80.0);
    enterTWHSRail.tag = 2;
    
    enterPassTrans = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [enterPassTrans addTarget:self action:@selector(enterNextPage:) forControlEvents:UIControlEventTouchDown];
    [enterPassTrans setTitle:@"客運" forState:UIControlStateNormal];
    enterPassTrans.frame = CGRectMake(160.0, 160.0, 80, 80.0);
    enterPassTrans.tag = 3;
	// Do any additional setup after loading the view.
    
    [self.view addSubview:enterBus];
    [self.view addSubview:enterTWRail];
    [self.view addSubview:enterTWHSRail];
    [self.view addSubview:enterPassTrans];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enterNextPage:(id)sender
{
    NSLog(@"enterNextPage");
    TPRootViewController *tpRootViewController = [[TPRootViewController alloc] initWithStyle:UITableViewStyleGrouped];
    SetStationViewController *setStationViewController = [[SetStationViewController alloc] init];
    KUO_RouteViewController_Bra2 *kuo_routeViweController = [[KUO_RouteViewController_Bra2 alloc] initWithStyle:UITableViewStyleGrouped WithType:Kuo_Data];
    
    switch (((UIButton *)sender).tag) {
        case 0:
            [self.navigationController pushViewController:tpRootViewController animated:YES];
            break;
        case 1:
            [setStationViewController initIsHighSpeedTrain:false];
            [self.navigationController pushViewController:setStationViewController animated:YES];
            break;
        case 2:
            [setStationViewController initIsHighSpeedTrain:true];
            [self.navigationController pushViewController:setStationViewController animated:YES];
            break;
        default:
            [self.navigationController pushViewController:kuo_routeViweController animated:YES];
            break;
    }
}

@end
