//
//  PWAddDishViewController.m
//  ZhongCai
//
//  Created by Paul Wood on 9/23/13.
//  Copyright (c) 2013 Paul Wood. All rights reserved.
//

#import "PWAddDishViewController.h"
#import "PWAddImageViewController.h"

@interface PWAddDishViewController ()

@property (nonatomic, strong) PFObject *object;

@end

@implementation PWAddDishViewController

- (void)viewDidLoad{
    [self.navigationItem.backBarButtonItem setTitle:NSLocalizedString(@"Cancel", nil)];
    [super viewDidLoad];
}

- (IBAction)cancelPressed:(id)sender{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePressed:(id)sender{
    
    NSString *enName = self.enNameTextField.text;
    NSString *cnNameHanzi = self.cnHanziTextField.text;
    NSString *cnNamePinyin = self.cnPinyinTextField.text;
    NSString *editorial = self.editorialTextField.text;
    
    PFObject *tagObject = [PFObject objectWithClassName:@"Dish"];
    [tagObject setObject:enName forKey:@"enName"];
    [tagObject setObject:cnNameHanzi forKey:@"cnNameHanzi"];
    [tagObject setObject:cnNamePinyin forKey:@"cnNamePinyin"];
    [tagObject setObject:editorial forKey:@"editorial"];
    
    [tagObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.object = tagObject;
        [self performSegueWithIdentifier:@"PWAddDishImage" sender:nil];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"PWAddDishImage"]) {
        PWAddImageViewController *addVC = (PWAddImageViewController *)segue.destinationViewController;
        addVC.object = self.object;
    }
}

@end
