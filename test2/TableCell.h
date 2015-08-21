//
//  TableCell.h
//  test2
//
//  Created by Juni on 14/8/15.
//  Copyright (c) 2015 Juni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;


@end
