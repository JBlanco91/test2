//
//  UploadPhotoViewController.h
//  test2
//
//  Created by Juni on 17/8/15.
//  Copyright (c) 2015 Juni. All rights reserved.
//

#import "ViewController.h"

@interface UploadPhotoViewController : ViewController

@property (strong, nonatomic) UIImage * myImage;
@property (weak, nonatomic) IBOutlet UIImageView *imageContainer;
@property (weak, nonatomic) IBOutlet UILabel *labelWorry;
@property (strong, nonatomic) NSString * imageTitle;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *labelLoading;
@property (weak, nonatomic) IBOutlet UIButton *buttonTakePhoto;
@property (weak, nonatomic) IBOutlet UIButton *buttonChooseOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonUploadNow;

@end
