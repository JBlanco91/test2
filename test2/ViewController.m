//
//  ViewController.m
//  test2
//
//  Created by Juni on 14/8/15.
//  Copyright (c) 2015 Juni. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize buttonGallery;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self.buttonGallery layer] setCornerRadius:8.0f];
    [[self.buttonGallery layer] setMasksToBounds:YES];
    [[self.buttonGallery layer] setBorderWidth:1.0f];
    
    [[self.buttonUpload layer] setCornerRadius:8.0f];
    [[self.buttonUpload layer] setMasksToBounds:YES];
    [[self.buttonUpload layer] setBorderWidth:1.0f];
    
}

@end
