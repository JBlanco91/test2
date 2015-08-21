//
//  UploadPhotoViewController.m
//  test2
//
//  Created by Juni on 17/8/15.
//  Copyright (c) 2015 Juni. All rights reserved.
//

#import "UploadPhotoViewController.h"

@interface UploadPhotoViewController ()

@end

@implementation UploadPhotoViewController

@synthesize myImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //ocultar teclado al tocar afuera
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self showIndicatorLoading:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takeAPhoto:(id)sender
{
    @try{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    @catch(NSException * e)
    {
        //NSLog(@"Error: %@", e);
        NSLog(@"El simulador no tiene camara!!");
    }
}

- (IBAction)chooseOne:(id)sender
{
    @try{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    @catch(NSException * e)
    {
        NSLog(@"Error: %@", e);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage]; //imagen obtenida
    self.myImage = chosenImage;
    [self.labelWorry setHidden:YES];
    [self.imageContainer setImage:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)uploadNow:(id)sender
{
    if(self.myImage)
    {
        if([self.titleTextField hasText])
        {
            [self showIndicatorLoading:YES];
            self.imageTitle = self.titleTextField.text;
            //NSLog(@"%@", self.imageTitle);
            [self doTheRequest];
            //[self showIndicatorLoading:NO];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must put a title to that photo!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"What are you going to upload? Pick a photo!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - POST Request to API

-(void)doTheRequest
{
    NSString * image = [self encodeToBase64String:self.myImage];
    //[self showIndicatorLoading:YES];
    [self imgurUploadImage:image withTitle:self.imageTitle complete:^(id result, NSError *error) {
        if (result)
        {
            NSDictionary * dict = result;
            BOOL success = [dict valueForKey:@"success"];
            if(success)
            {
                NSDictionary * data = [dict valueForKey:@"data"];
                NSString * linkToImage = [data valueForKey:@"link"];
                [UIPasteboard generalPasteboard].string = linkToImage;
                NSLog(@"Link to image: %@", linkToImage);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yeah!" message:@"Image uploaded!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                
                //volver a la pantalla anterior
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"I'm sorry, try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
            
        }else{ UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"I'm sorry, try again!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];}
    }];
    
}


//codigo para hacer request POST a API
-(void)imgurUploadImage:(NSString *)image withTitle:(NSString *)title complete:(void(^)(id result, NSError *error))finished
{
    NSString *baseUrl = @"https://api.imgur.com/3/";
    NSString *method = @"upload";
    //WS Parameters
    NSDictionary *parameters = @{@"image": image, @"title": title};
    
    //WS URL
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    //Authorization Header
    [manager.requestSerializer setValue:@"Client-ID 2c599b4fb2f767d" forHTTPHeaderField:@"Authorization"];
    //WS Call
    [manager POST:[NSString stringWithFormat:@"%@%@",baseUrl,method] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
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

-(void)showIndicatorLoading:(BOOL)showIt
{
    if(showIt)
    {
        [self.indicator setHidden:NO];
        [self.labelLoading setHidden:NO];
        [self.buttonChooseOne setEnabled:NO];
        [self.buttonTakePhoto setEnabled:NO];
        [self.buttonUploadNow setEnabled:NO];
        [self.buttonGallery setEnabled:NO];
        [self.titleTextField setEnabled:NO];
        [self.indicator startAnimating];
    }
    else
    {
        [self.indicator setHidden:YES];
        [self.labelLoading setHidden:YES];
        [self.buttonChooseOne setEnabled:YES];
        [self.buttonTakePhoto setEnabled:YES];
        [self.buttonUploadNow setEnabled:YES];
        [self.titleTextField setEnabled:YES];
        //[self.buttonGallery setEnabled:NO];
        [self.indicator stopAnimating];
    }
}

-(void)dismissKeyboard {
    [self.titleTextField resignFirstResponder];
}

//convierte la image a base64 string
- (NSString *)encodeToBase64String:(UIImage *)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
