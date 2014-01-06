//
//  DialogContentViewController.m
//  UIXOverlayController
//
//  Created by Tan Hui on 8/29/13.
//  Copyright 2013 Cariloop. All rights reserved.
//

#import "DialogContentViewController.h"


@implementation DialogContentViewController

@synthesize delegate;

- (id)init
{
    self = [super initWithNibName:@"DialogContent" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_m_textGroupName release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"appear");
}

- (void) viewDidDisappear:(BOOL)animated
{
    NSLog(@"disappear");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction) yesPressed:(id) sender
{
    if ([_m_textGroupName.text isEqual:@""] == NO) {
        [delegate performSelector:@selector(onYesPressed:) withObject: _m_textGroupName.text];
    } else {
        return;
    }
    
    [self.overlayController dismissOverlay:  YES];
}

- (IBAction) noPressed:(id) sender
{
    [self.overlayController dismissOverlay:  YES];
}

- (IBAction)onTextDidEndExit:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark -
#pragma mark Keyboard Notification
- (void)keyboardWillShow: (NSNotification *)notif
{
    NSDictionary *info = [notif userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.transform = CGAffineTransformMakeTranslation(0, -100);
    [UIView commitAnimations];
}

- (void)keyboardwillHide: (NSNotification *)notif
{
    
    NSDictionary *info = [notif userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}



@end
