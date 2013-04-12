//
//  ParserViewController.m
//  bus
//
//  Created by NTOUCS on 13/4/12.
//
//

#import "ParserViewController.h"

@interface ParserViewController ()

@end

@implementation ParserViewController

@synthesize xpathArray;

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
    NSError * error;
    xpathArray = [[NSArray alloc] init];
    NSData * htmlData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://e-bus.ntpc.gov.tw/index.php?do=home"] encoding:NSUTF8StringEncoding error:&error] dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple * xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    xpathArray = [xpathParser searchWithXPathQuery:@"//span"];
    [xpathArray retain];
    
    NSLog(@"Parser:%@", xpathArray);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
