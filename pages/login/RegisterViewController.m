//
//  RegisterViewController.m
//  Schedule
//
//  Created by TanLong on 11/4/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "RegisterViewController.h"
#import "CompleteRegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_textFirstName release];
    [_m_textLastName release];
    [_m_textEmail release];
    [super dealloc];
}

#pragma mark - Actions

- (IBAction)onTouchCancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)onTouchSignupBtn:(id)sender {
    if ([_m_textFirstName.text isEqualToString:@""]) {
        [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"First Name is Empty."];
    } else if ([_m_textLastName.text isEqualToString:@""]) {
        [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Last Name is Emptry."];
    } else if ([_m_textEmail.text isEqualToString:@""]) {
        [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Email Address is Emptry."];
    } else {
        [self Signup];
    }

}

- (IBAction)onTouchBackgroundBtn:(id)sender {
    [self DismissKeyboard];
}

- (void) Signup {
    // Show Loading for Initalize
    [self DismissKeyboard];
    [self ShowLogin];
    
    [NSThread detachNewThreadSelector:@selector(SignupThread) toTarget:self withObject:nil];
}

- (void) SignupThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"SignupThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSInteger nRet = [dataKeeper Signup:_m_textEmail.text firstname:_m_textFirstName.text lastname:_m_textLastName.text];
    
    if (nRet == 1) {
        [self performSelectorOnMainThread:@selector(GotoNextScreen) withObject:nil waitUntilDone:YES];
        
    } else {
        [self performSelectorOnMainThread:@selector(ShowRegisterFailed) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    NSLog(@"SignupThread: End!!!");
    [pool release];
}

- (void) GotoNextScreen {
    CompleteRegisterViewController *completeRegisterVC = [[CompleteRegisterViewController alloc] initWithNibName:@"CompleteRegisterViewController" bundle: nil];
    
    [self.navigationController pushViewController: completeRegisterVC animated: YES];
    
    [completeRegisterVC setM_strFirstName: _m_textFirstName.text];
    [completeRegisterVC setM_strLastName:  _m_textLastName.text];
    [completeRegisterVC setM_strEmail: _m_textEmail.text];
    
    [completeRegisterVC release];
}

- (void) ShowRegisterFailed {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:dataKeeper.m_strLastErrorMessage];
}


#pragma mark - Loading Indicator Functions

- (void) ShowLoading {
    HUD.labelText = @"Loading";
    [HUD showUsingAnimation: YES];
}

- (void) ShowLogin {
    HUD.labelText = @"Submit...";
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

- (void) DismissKeyboard {
    [_m_textFirstName resignFirstResponder];
    [_m_textLastName resignFirstResponder];
    [_m_textEmail resignFirstResponder];
}

@end
