//
//  TWRailViewController.m
//  bus
//
//  Created by NTOUCS on 13/5/31.
//
//

#import "TWRailViewController.h"

@interface TWRailViewController ()

@end

@implementation TWRailViewController

@synthesize departButton;
@synthesize destinButton;
@synthesize dateButton;
@synthesize categoryButton;
@synthesize searchButton;
@synthesize arrowButton;

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
    departButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [departButton addTarget:self action:@selector(departure) forControlEvents:UIControlEventTouchDown];
    [departButton setTitle:@"臺北" forState:UIControlStateNormal];
    departButton.frame = CGRectMake(40.0, 40.0, 80.0, 40.0);
    
    destinButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [destinButton addTarget:self action:@selector(destination) forControlEvents:UIControlEventTouchDown];
    [destinButton setTitle:@"基隆" forState:UIControlStateNormal];
    destinButton.frame = CGRectMake(200.0, 40.0, 80.0, 40.0);
    
    arrowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [arrowButton addTarget:self action:@selector(arrow) forControlEvents:UIControlEventTouchDown];
    [arrowButton setTitle:@"<->" forState:UIControlStateNormal];
    arrowButton.frame = CGRectMake(140.0, 40.0, 40.0, 40.0);
    
    dateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dateButton addTarget:self action:@selector(chooseDate) forControlEvents:UIControlEventTouchDown];
    [dateButton setTitle:@"時間" forState:UIControlStateNormal];
    dateButton.frame = CGRectMake(40.0, 100.0, 240, 40.0);
    
    categoryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [categoryButton addTarget:self action:@selector(chooseCategory) forControlEvents:UIControlEventTouchDown];
    [categoryButton setTitle:@"車種" forState:UIControlStateNormal];
    categoryButton.frame = CGRectMake(40.0, 160.0, 240, 40.0);

    
    [self.view addSubview:departButton];
    [self.view addSubview:destinButton];
    [self.view addSubview:arrowButton];
    [self.view addSubview:dateButton];
    [self.view addSubview:categoryButton];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)departure
{
    NSLog(@"press departure");
}

- (void)destination
{
    TWRailDestinationViewController *destinationViewController = [[TWRailDestinationViewController alloc] init];
    NSLog(@"press destination");
    /* 這裡要加點東西 */
    /*[UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [super pushViewController:destinationViewController animated:YES];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
                     }];*/
    
    [self.navigationController pushViewController:destinationViewController animated:YES];
    [destinationViewController release];
}

- (void)arrow
{
    NSLog(@"arrow");
}

- (void)chooseDate
{
    TWRailDateChooseViewController *chooseDateViewController = [[TWRailDateChooseViewController alloc] init];
    NSLog(@"press destination");
    [self.navigationController pushViewController:chooseDateViewController animated:YES];
    [chooseDateViewController release];
}

@end
