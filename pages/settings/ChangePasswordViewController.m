//
//  ChangePasswordViewController.m
//  Schedule
//
//  Created by TanLong on 11/15/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

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
    
    [self refreshImage];
    
    // Set Timer for Current Date Label
    [self setLabel];
    [self createTimer];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_textCurrentPassword release];
    [_m_textNewPassword release];
    [_m_textConfirmPassword release];
    [_m_imgViewProfile release];
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    
    [_m_settingItem release];
    
    if (m_timer != nil) {
        [m_timer release];
    }

    [super dealloc];
}

#pragma mark - Touch Actions

- (IBAction)onTouchSubmitBtn:(id)sender {
    if ([_m_textCurrentPassword.text isEqualToString:@""]) {
        [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Please input Current Password"];
    } else if ([_m_textNewPassword.text isEqualToString:@""]) {
        [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Please input New Password"];
    } else if ([_m_textNewPassword.text isEqualToString: _m_textConfirmPassword.text] == NO) {
        [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Password does not match"];
    } else {
        [self ChangePassword];
    }

}

- (IBAction)onTouchNavBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - Navigation Functions

- (void) GotoBackScreen {
    [self.navigationController popViewControllerAnimated: YES];
    [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Password is successfully changed."];
}

#pragma mark - UITextField Delegate Methods

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return YES;
}

#pragma mark - Login Functions

- (void) ChangePassword {
    // Show Loading for Initalize
    [self DismissKeyboard];
    [self ShowChanging];
    
    [NSThread detachNewThreadSelector:@selector(ChangePasswordThread) toTarget:self withObject:nil];
}

- (void) ChangePasswordThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"ChangePasswordThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    BOOL bRet = [dataKeeper ChangePassword:_m_textCurrentPassword.text newpassword:_m_textNewPassword.text];
    
    if (bRet == YES) {
        [self performSelectorOnMainThread:@selector(GotoBackScreen) withObject:nil waitUntilDone:YES];
    } else {
        [self performSelectorOnMainThread:@selector(ShowChangePasswordFailed) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    NSLog(@"ChangePasswordThread: End!!!");
    [pool release];
}

- (void) ShowChangePasswordFailed {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:dataKeeper.m_strLastErrorMessage];
}

- (void) DismissKeyboard {
    [_m_textCurrentPassword resignFirstResponder];
    [_m_textNewPassword resignFirstResponder];
    [_m_textConfirmPassword resignFirstResponder];
}

#pragma mark - Loading Indicator Functions

- (void) ShowLoading {
    HUD.labelText = @"Loading";
    [HUD showUsingAnimation: YES];
}

- (void) ShowChanging {
    HUD.labelText = @"Changing Password...";
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

#pragma mark - Date/Time Functions
- (void) createTimer {
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setLabel) userInfo:nil repeats: YES];
}

- (void)setLabel {
    
    NSDate * toDay = [NSDate date];
    NSDateFormatter * dateformatter = [[NSDateFormatter new] autorelease];
    
    [dateformatter setDateFormat:_m_settingItem.dateformat];
    NSString * dateString = [dateformatter stringFromDate:toDay];
    dateformatter.dateFormat = @"EEE";
    
    NSString * dayString = [[dateformatter stringFromDate:toDay] capitalizedString];
    [_m_labelCurrentDate setText:[NSString stringWithFormat:@"%@, %@", dayString, dateString]];
    
    
    dateformatter.dateFormat = _m_settingItem.timeformat;
    NSString * timeString = [dateformatter stringFromDate:toDay];
    [_m_labelCurrentTime setText:timeString];
    
    //   NSLog(@"---- setLabel -----");
}

#pragma mark - Set Image to cell

- (void) refreshImage {
    [NSThread detachNewThreadSelector:@selector(getImage) toTarget:self withObject:nil];
}

- (void) getImage {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    UIImage *image = [dataKeeper getImage: [dataKeeper getProfileImageURL]];
    
    if (image != nil) {
        [_m_imgViewProfile setImage: image];
        
        [CUtils makeCircleImage: _m_imgViewProfile];
    }
    
    [autoreleasePool release];
}


@end
