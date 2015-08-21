//
//  TableViewController.m
//  test2
//
//  Created by Juni on 14/8/15.
//  Copyright (c) 2015 Juni. All rights reserved.
//

#import "TableViewController.h"
#import "TableCell.h"

@interface TableViewController ()

@end

@implementation TableViewController

@synthesize allImages, allObjectsFromGallery, theTable, segmentedControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    allImages = [[NSMutableArray alloc] init];
    allObjectsFromGallery = [[NSMutableArray alloc] init];
    
    [self hideTheTable:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self callTheGalleryWithSort:@"top"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentedControlChanged:(id)sender
{
    UISegmentedControl *segmentedC = (UISegmentedControl *)sender;
    [self hideTheTable:YES];
    switch (segmentedC.selectedSegmentIndex) {
        case 0:
            //NSLog(@"Top");
            allImages = [[NSMutableArray alloc] init];
            [self callTheGalleryWithSort:@"top"];
            //[self hideTheTable:NO];
            break;
        case 1:
            //NSLog(@"Time");
            allImages = [[NSMutableArray alloc] init];
            [self callTheGalleryWithSort:@"time"];
            //[self hideTheTable:NO];
            break;
        case 2:
            //NSLog(@"Viral");
            allImages = [[NSMutableArray alloc] init];
            [self callTheGalleryWithSort:@"viral"];
            //[self hideTheTable:NO];
            break;
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [allImages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"theCell" forIndexPath:indexPath];

    NSInteger row = [indexPath row];
    Photo * photo = [allImages objectAtIndex:row];
    
    NSString *name =[photo name];
    [cell.TitleLabel setText:name]; // cargo el titulo de la foto aca
    
    NSString * urlImage = [photo img];
    NSURL *url = [NSURL URLWithString:urlImage]; // convierto string a url
    
    //asincronico
    [cell.Image setImage:nil];
    cell.imageView.image = [UIImage imageNamed:@"icn_default"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.Image setImage:nil];
            [cell.Image setImage:image];
        });
    });
    
    
    //sincronico
    //NSData *data = [NSData dataWithContentsOfURL : url];
    //UIImage *image = [UIImage imageWithData: data];
    //[cell.Image setImage:image];
    
    return cell;
}


#pragma mark - GET Requests to API

-(void) callTheGalleryWithSort:(NSString *) sort
{
    [self imgurGalleryWithSort:sort complete:^(id result, NSError *error) {
        if (result)
        {
            //NSLog(@"result");
            
            NSDictionary * dict = result;
            BOOL success = [dict valueForKey:@"success"];
            if(success)
            {
                NSArray * arrayImages = [dict valueForKey:@"data"];
                //NSDictionary * dictImages = [dict valueForKey:@"data"];
                for(int i = 0; i<[arrayImages count]; i++)
                {
                    NSString *type = [[arrayImages objectAtIndex:i] valueForKey:@"type"];
                    if([type containsString:@"jpg"] || [type containsString:@"jpeg"] || [type containsString:@"png"])
                    {
                        Photo * photo = [[Photo alloc] init];
                        NSString * title = [[arrayImages objectAtIndex:i] valueForKey:@"title"];
                        NSString * link = [[arrayImages objectAtIndex:i] valueForKey:@"link"];
                        [photo setImg:link];//photo.img = link;
                        [photo setName:title];//photo.name = title;
                        [allImages addObject:photo];
                    }
                }
                [self.theTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
                [self.theTable reloadData];
                [self hideTheTable:NO];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"I'm sorry, try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
            
        }else{ UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"I'm sorry, no result, try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];}
    }];
}


//codigo para hacer request a API
-(void)imgurGalleryWithSort:(NSString *)sort complete:(void(^)(id result, NSError *error))finished
{
    NSString *url = @"https://api.imgur.com/3/gallery/hot/";

    //URL
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    //Authorization Header
    [manager.requestSerializer setValue:@"Client-ID 2c599b4fb2f767d" forHTTPHeaderField:@"Authorization"];
    
    //Call
    [manager GET:[NSString stringWithFormat:@"%@%@",url,sort] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //Success
         if (finished) finished(responseObject, nil);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //Failure
         NSLog(@"WS logInWsWithUser Error: %@", error);
         if (finished) finished(nil, error);
     }];
}

# pragma mark - Auxiliar methods

- (void) hideTheTable:(BOOL)hideIt
{
    if(hideIt)
    {
        [theTable setHidden:YES];
        [self.indicator setHidden:NO];
        [self.labelLoading setHidden:NO];
        [self.indicator startAnimating];
    }
    else
    {
        [theTable setHidden:NO];
        [self.indicator setHidden:YES];
        [self.labelLoading setHidden:YES];
        [self.indicator stopAnimating];
    }
}

@end
