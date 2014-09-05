//
//  BDDViewController.h
//  RottenTomatoes
//
//  Created by DX133-XL on 2014-09-04.
//  Copyright (c) 2014 DX133-XL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BDDViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property UITableView *mainTableView;
@property NSArray *results;
@property NSMutableData *data;
@property NSDictionary *responseDict;
@property UIImage *img;

@property (strong ,nonatomic) NSMutableArray *tableItems;
@property (nonatomic, strong) NSMutableData *resultData;
@property (strong, nonatomic) NSMutableDictionary *cachedImages;

@end
