//
//  TableViewController.h
//  test2
//
//  Created by Juni on 14/8/15.
//  Copyright (c) 2015 Juni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "TableCell.h"
#import "Photo.h"

@interface TableViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *allImages;
@property (nonatomic, strong) NSMutableArray *allObjectsFromGallery;
@property (weak, nonatomic) IBOutlet UITableView *theTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *labelLoading;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end
