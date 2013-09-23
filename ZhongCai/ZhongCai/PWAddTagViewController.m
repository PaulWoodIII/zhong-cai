//
//  PWAddTagViewController.m
//  ZhongCai
//
//  Created by Paul Wood on 9/23/13.
//  Copyright (c) 2013 Paul Wood. All rights reserved.
//

#import "PWAddTagViewController.h"
#import "PWAddImageViewController.h"

@interface PWAddTagViewController ()

@property (nonatomic, strong) PFObject *object;

@end

@implementation PWAddTagViewController

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
    [self.formView setFrame:CGRectMake(0, 10, self.formView.frame.size.width, self.formView.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(self.formView.frame.size.width, self.formView.frame.size.height+10)];
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
    
    NSString *enName = self.enNameTextField.text;
    NSString *cnNameHanzi = self.cnHanziTextField.text;
    NSString *cnNamePinyin = self.cnPinyinTextField.text;
    NSString *editorial = self.editorialTextField.text;
    
    PFObject *tagObject = [PFObject objectWithClassName:@"Tag"];
    [tagObject setObject:enName forKey:@"enName"];
    [tagObject setObject:cnNameHanzi forKey:@"cnNameHanzi"];
    [tagObject setObject:cnNamePinyin forKey:@"cnNamePinyin"];
    [tagObject setObject:editorial forKey:@"editorial"];
    
    [tagObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.object = tagObject;
        [self performSegueWithIdentifier:@"PWAddTagImage" sender:nil];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"PWAddTagImage"]) {
        PWAddImageViewController *addVC = (PWAddImageViewController *)segue.destinationViewController;
        addVC.object = self.object;
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	self.currentTextField = textField;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag == 1){
        [self.cnHanziTextField becomeFirstResponder];
        return NO;
    }
    else if (textField.tag == 2){
        [self.cnPinyinTextField becomeFirstResponder];
        return NO;
    }
    else if(textField.tag == 3){
        [self.editorialTextField becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	if ([self.currentTextField isEqual:textField])
	{
		self.currentTextField = nil;
	}
    
    if (textField.tag == 1){

    }
    
    if (textField.tag == 3){

    }
    
}

- (IBAction)textFieldDidUpdate:(id)sender{
    //Clear any Error
}


#pragma mark ### Handle the sliding/scrolling of the view when the keyboard appears

//
// keyboardWillHideNotification:
//
// Slides the view back when done editing.
//
- (void)keyboardWillHideNotification:(NSNotification *)aNotification
{
	if (textFieldAnimatedDistance == 0)
	{
		return;
	}
	
	CGRect viewFrame = self.view.frame;
	viewFrame.size.height += textFieldAnimatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.33];
	[self.view setFrame:viewFrame];
	[UIView commitAnimations];
	
	textFieldAnimatedDistance = 0;
}

//
// keyboardWillShowNotification:
//
// Slides the view to avoid the keyboard.
//
- (void)keyboardWillShowNotification:(NSNotification *)aNotification
{
	//
	// Remove any previous view offset.
	//
	[self keyboardWillHideNotification:nil];
	
	//
	// Only animate if the text field is part of the hierarchy that we manage.
	//
	UIView *parentView = [self.currentTextField superview];
	while (parentView != nil && ![parentView isEqual:self.view])
	{
		parentView = [parentView superview];
	}
	if (parentView == nil)
	{
		//
		// Not our hierarchy... ignore.
		//
		return;
	}
	
	CGRect keyboardRect = CGRectZero;
	
	//
	// Perform different work on iOS 4 and iOS 3.x. Note: This requires that
	// UIKit is weak-linked. Failure to do so will cause a dylib error trying
	// to resolve UIKeyboardFrameEndUserInfoKey on startup.
	//
	if (UIKeyboardFrameEndUserInfoKey != nil)
	{
		keyboardRect = [self.view.superview
                        convertRect:[[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]
                        fromView:nil];
	}
	else
	{
		NSArray *topLevelViews = [self.view.window subviews];
		if ([topLevelViews count] == 0)
		{
			return;
		}
		
		UIView *topLevelView = [[self.view.window subviews] objectAtIndex:0];
		
		//
		// UIKeyboardBoundsUserInfoKey is used as an actual string to avoid
		// deprecated warnings in the compiler.
		//
		keyboardRect = [[[aNotification userInfo] objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
		keyboardRect.origin.y = topLevelView.bounds.size.height - keyboardRect.size.height;
		keyboardRect = [self.view.superview
                        convertRect:keyboardRect
                        fromView:topLevelView];
	}
	
	CGRect viewFrame = self.view.frame;
    
	textFieldAnimatedDistance = 0;
	if (keyboardRect.origin.y < viewFrame.origin.y + viewFrame.size.height)
	{
		textFieldAnimatedDistance = (viewFrame.origin.y + viewFrame.size.height) - (keyboardRect.origin.y - viewFrame.origin.y);
		viewFrame.size.height = keyboardRect.origin.y - viewFrame.origin.y;
        
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.33];
		[self.view setFrame:viewFrame];
		[UIView commitAnimations];
	}
	
	const CGFloat ViewControllerTextFieldScrollSpacing = 40;
    
	CGRect textFieldRect =
    [self.scrollView convertRect:self.currentTextField.bounds fromView:self.currentTextField];
	textFieldRect = CGRectInset(textFieldRect, 0, -ViewControllerTextFieldScrollSpacing);
	[self.scrollView scrollRectToVisible:textFieldRect animated:NO];
}

//
// viewWillAppear:
//
// Watches for keyboard animation when visible.
//
// Parameters:
//    animated - Will the appearance be animated.
//
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShowNotification:)
     name:UIKeyboardWillShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHideNotification:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

//
// viewWillDisappear:
//
// Deanimates the keyboard on dismiss.
//
// Parameters:
//    animated - is the transition animated
//
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	
	[[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillShowNotification
     object:nil];
	[[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:UIKeyboardWillHideNotification
     object:nil];
    
	if (self.currentTextField)
	{
		[self keyboardWillHideNotification:nil];
	}
}


@end
