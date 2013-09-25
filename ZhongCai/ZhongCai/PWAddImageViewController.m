//
//  PWAddImageViewController.m
//  ZhongCai
//
//  Created by Paul Wood on 9/23/13.
//  Copyright (c) 2013 Paul Wood. All rights reserved.
//

#import "PWAddImageViewController.h"

@interface PWAddImageViewController ()

@end

@implementation PWAddImageViewController

- (id)initWithObject:(PFObject *)aObject{
    self = [self init];
    if (self) {
        self.object = aObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self cameraButtonTapped:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipPressed:(id)sender{
    if (self.parentViewController) {
        NSLog(@"%@",self.parentViewController);
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)cameraButtonTapped:(id)sender
{
    // Check for camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES) {
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Show image picker
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
    else{

    }
}

- (void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // Create a PFObject around a PFFile and associate it with the current user
            [self.object setObject:imageFile forKey:@"image"];
            
            [self.object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [self skipPressed:nil];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                    [self cameraButtonTapped:nil];
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
                    [self cameraButtonTapped:nil];
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.

    }];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
    [self uploadImage:imageData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self skipPressed:nil];
}

@end
