//
//  SearchTableViewController.h
//  bus
//
//  Created by mac_hero on 12/6/8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "LoadingTestAppDelegate.h"
#import "SearchStopRouteViewController.h"
#import "Levenshtein_Distance_Algorithm.h"
#import "TPRootViewController.h"

@class TPRootViewController;

@interface SearchTableViewController : UITableViewController{
    NSString *search;
    NSMutableArray *resultInfo; //record search_result(route)
    NSMutableArray *waitTime;   //record search_result(waitTime)
    //NSMutableArray *resultStopName;
    NSArray *root_item;
    NSArray *routes_item;
    NSArray *stop_item;
    NSMutableArray *sectionNum;
    NSMutableDictionary *memory;
    BOOL enterFromRoot;
    TPRootViewController *rootdelegate;
    NSArray * xpathArray;   // save estimate time content 
}

@property (retain,nonatomic) NSString* search;
@property (retain,nonatomic) NSArray *root_item;
@property (retain,nonatomic) NSArray *routes_item;
@property (retain,nonatomic) NSArray *stop_item;
@property (retain,nonatomic) NSMutableArray *resultInfo;
@property (retain,nonatomic) NSMutableArray *waitTime;
@property (retain,nonatomic) NSMutableArray *sectionNum;
@property (retain, nonatomic) NSString *routesName;
@property (retain, nonatomic) NSURL *waitTimeURL;
@property (retain, nonatomic) NSMutableDictionary *memory;

-(void)setEnterFromRoot:(TPRootViewController *)delegate;
-(void) setInfo : (NSString *)key;
- (void) loadDataBase ;
-(NSMutableArray *) getSearchResult;
- (void)setter_estimateArray:(NSArray *)array;
@end
