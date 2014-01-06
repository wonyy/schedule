//
//  LoginViewController.m
//  Schedule
//
//  Created by Mountain on 10/19/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    // Do any additional setup after loading the view from its nib.
    
    // Loading Indicator Initialize
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_textEmailAddress release];
    [_m_textPassword release];
    [super dealloc];
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
    
    self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardEndFrame.size.height);
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

#pragma mark - Loading Indicator Functions

- (void) ShowLoading {
    HUD.labelText = @"Loading";
    [HUD showUsingAnimation: YES];
}

- (void) ShowLogin {
    HUD.labelText = @"Login...";
    [HUD showUsingAnimation: YES];
}


- (void) HideIndicator {
    [HUD hideUsingAnimation: YES];
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    //    [HUD removeFromSuperview];
    //    [HUD release];
}

- (IBAction)onTouchSubmitBtn:(id)sender {
    if ([_m_textEmailAddress.text isEqualToString:@""]) {
        [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Email Address is Empty."];
    } else if ([_m_textPassword.text isEqualToString:@""]) {
        [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Password is Emptry."];
    } else {
        [self Login];
    }

}

- (IBAction)onTouchForgetPasswordBtn:(id)sender {
    if ([_m_textEmailAddress.text isEqualToString:@""] == NO) {
        [self ForgotPassword];
    } else {
        [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Email Address is Empty."];
    }

}

- (IBAction)onTouchSignupBtn:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle: nil];
    [self.navigationController pushViewController: registerVC animated: YES];
    [registerVC release];
}

- (IBAction)onTextDidEndExit:(id)sender {
    [sender resignFirstResponder];
}

#pragma mark - Navigation Functions

- (void) GotoMainScreen {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      
    [self.navigationController pushViewController: appDelegate.mainViewController animated: YES];
}

#pragma mark - Login Functions

- (void) ForgotPassword {
    // Show Loading for Initalize
    [self DismissKeyboard];
    [self ShowLoading];
    
    [NSThread detachNewThreadSelector:@selector(ForgotPasswordThread) toTarget:self withObject:nil];
}

- (void) ForgotPasswordThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"ForgotPasswordThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    BOOL bRet = [dataKeeper ForgotPassword: _m_textEmailAddress.text];
    if (bRet == YES) {
        [self performSelectorOnMainThread:@selector(ForgotPasswordSuccess) withObject:nil waitUntilDone:YES];
        
    } else {
        [self performSelectorOnMainThread:@selector(ShowLoginFailed) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    NSLog(@"ForgotPasswordThread: End!!!");
    [pool release];
}


- (void) Login {
    // Show Loading for Initalize
    [self DismissKeyboard];
    [self ShowLogin];
    
    [NSThread detachNewThreadSelector:@selector(LoginThread) toTarget:self withObject:nil];
}

- (void) LoginThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"Login: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSInteger nRet = [dataKeeper Login:_m_textEmailAddress.text strPass:_m_textPassword.text];
    if (nRet == 1) {
        HUD.labelText = @"Sync...";
        
        if ([dataKeeper Sync:@""] == 1) {
            [self performSelectorOnMainThread:@selector(GotoMainScreen) withObject:nil waitUntilDone:YES];
        }

    } else {
        [self performSelectorOnMainThread:@selector(ShowLoginFailed) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    NSLog(@"Login: End!!!");
    [pool release];
}

- (void) ForgotPasswordSuccess {
    [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Your Password is successfully sent to you email."];
}

- (void) ShowLoginFailed {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:dataKeeper.m_strLastErrorMessage];
}

- (void) DismissKeyboard {
    [_m_textEmailAddress resignFirstResponder];
    [_m_textPassword resignFirstResponder];
}


@end
