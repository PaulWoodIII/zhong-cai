//
//  PWAddListViewController.h
//  ZhongCai
//
//  Created by Paul Wood on 9/23/13.
//  Copyright (c) 2013 Paul Wood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PWAddListViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField  *nameTextField;


- (IBAction)cancelPressed:(id)sender;
- (IBAction)savePressed:(id)sender;

@end
