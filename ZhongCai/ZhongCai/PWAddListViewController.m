//
//  PWAddListViewController.m
//  ZhongCai
//
//  Created by Paul Wood on 9/23/13.
//  Copyright (c) 2013 Paul Wood. All rights reserved.
//

#import "PWAddListViewController.h"

@interface PWAddListViewController ()

@end

@implementation PWAddListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelPressed:(id)sender{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePressed:(id)sender{
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
