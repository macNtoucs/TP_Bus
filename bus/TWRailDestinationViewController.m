//
//  TWRailDestinationViewController.m
//  bus
//
//  Created by MacAir on 13/5/25.
//
//

#import "TWRailDestinationViewController.h"

@interface TWRailDestinationViewController ()

@end

@implementation TWRailDestinationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Destination");
    
    UISwipeGestureRecognizer *leftSwiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
	leftSwiper.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:leftSwiper];
	[leftSwiper release];
    
	UISwipeGestureRecognizer *rightSwiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
	rightSwiper.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:rightSwiper];
	[rightSwiper release];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)swipeLeft
{
	TWRailDateChooseViewController *dateChooseViewController = [[TWRailDateChooseViewController alloc] init];
    [self.navigationController pushViewController:dateChooseViewController animated:YES];
}

- (void)swipeRight
{
    [self.navigationController popToRootViewControllerAnimated:YES];    // 回到台鐵根檢視
}

@end
