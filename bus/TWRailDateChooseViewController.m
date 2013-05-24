//
//  TWRailDateChooseViewController.m
//  bus
//
//  Created by MacAir on 13/5/25.
//
//

#import "TWRailDateChooseViewController.h"

@interface TWRailDateChooseViewController ()

@end

@implementation TWRailDateChooseViewController

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
    NSLog(@"Date Choose!");
    
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
    TWRailSearchViewController *searchViewController = [[TWRailSearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}
- (void)swipeRight
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
