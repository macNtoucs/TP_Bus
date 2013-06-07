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

@synthesize test;

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
    test = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [test addTarget:self action:@selector(testMethod) forControlEvents:UIControlEventTouchDown];
    [test setTitle:@"臺北" forState:UIControlStateNormal];
    test.frame = CGRectMake(40.0, 40.0, 80.0, 40.0);
    
    [self.view addSubview:test];
   	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)testMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
