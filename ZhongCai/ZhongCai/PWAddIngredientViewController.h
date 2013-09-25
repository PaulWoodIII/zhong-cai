//
//  PWAddIngredientViewController.h
//  ZhongCai
//
//  Created by Paul Wood on 9/24/13.
//  Copyright (c) 2013 Paul Wood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PWAddIngredientViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView       *formView;
@property (nonatomic, strong) IBOutlet UITextField  *enNameTextField;
@property (nonatomic, strong) IBOutlet UITextField  *cnHanziTextField;
@property (nonatomic, strong) IBOutlet UITextField  *cnPinyinTextField;
@property (nonatomic, strong) IBOutlet UITextField  *editorialTextField;

@property (nonatomic, strong) UITextField *currentTextField;

- (IBAction)cancelPressed:(id)sender;
- (IBAction)savePressed:(id)sender;

@end
