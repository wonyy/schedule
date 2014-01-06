//
//  CompleteRegisterViewController.m
//  Schedule
//
//  Created by TanLong on 11/4/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import "CompleteRegisterViewController.h"
#import "AppDelegate.h"

@interface CompleteRegisterViewController ()

@end

@implementation CompleteRegisterViewController

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

    
    [_m_scrollView setContentSize: CGSizeMake(320, 548)];
    
    [_m_textFirstName setText: _m_strFirstName];
    [_m_textLastName setText: _m_strLastName];
    [_m_textEmail setText: _m_strEmail];
 //       [_m_scrollView setContentSize: CGSizeMake(320, 600)];
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
    [_m_textPassword release];
    [_m_textConfirm release];
    [_m_textPhone release];
    [_m_textAddress release];
    [_m_textAccountType release];
    [_m_textBirthday release];
    [_m_textOccupation release];
    [_m_textAboutme release];
    [_m_scrollView release];
    [_m_imageviewMyPhoto release];
    [_m_imageData release];
    [_m_viewPicker release];
    [_m_pickerView release];
    [_m_datePicker release];
    
    if (_m_strFirstName != nil) {
        [_m_strFirstName release];
    }
    
    if (_m_strLastName != nil) {
        [_m_strLastName release];
    }
    
    if (_m_strEmail != nil) {
        [_m_strEmail release];
    }
    
    
    [super dealloc];
}

#pragma mark - Touch Actions

- (IBAction)onTouchAccountTypeBtn:(id)sender {
    m_nPickerType = 0;
    [self ShowDropdown];
}

- (IBAction)onTouchBirthdayBtn:(id)sender {
    m_nPickerType = 1;
    [self ShowDropdown];
}

- (IBAction)onTouchSubmitBtn:(id)sender {
    
    if ([_m_textPassword.text length] <= 0) {
        [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Password is empty. Please Input password."];
    } else if ([_m_textPassword.text isEqualToString: _m_textConfirm.text] == NO) {
        [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Password confirmation does not match."];
    } else {
        [self Signup];
    }
}

- (IBAction)onTouchPhotoBtn:(id)sender {
    UIActionSheet *selection = [[UIActionSheet alloc] initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"From Photo Library", nil];
        
    [selection showInView:self.view];
    
    [selection release];
}

- (IBAction)onTouchBackgroundBtn:(id)sender {
    [self DismissKeyboard];
    
    [_m_scrollView setContentSize: CGSizeMake(320, 548)];

    [_m_scrollView setContentOffset: CGPointMake(0, 0) animated: YES];
}

- (IBAction)onTouchBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)onTouchPickerCancelBtn:(id)sender {
    [self HideDropdown];
}

- (IBAction)onTouchPickerOkBtn:(id)sender {
    [self HideDropdown];
    
    if (m_nPickerType == 1) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *strDate = [dateFormatter stringFromDate: _m_datePicker.date];
        
        [_m_textBirthday setText: strDate];
        
    }
}

#pragma mark - General Functions

- (void) DismissKeyboard {
    [_m_textFirstName resignFirstResponder];
    [_m_textLastName resignFirstResponder];
    [_m_textEmail resignFirstResponder];
    [_m_textPassword resignFirstResponder];
    [_m_textConfirm resignFirstResponder];
    [_m_textPhone resignFirstResponder];
    [_m_textAddress resignFirstResponder];
    [_m_textAccountType resignFirstResponder];
    [_m_textBirthday resignFirstResponder];
    [_m_textOccupation resignFirstResponder];
    [_m_textAboutme resignFirstResponder];
    
}

#pragma mark - UITextField Delegate Methods

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [_m_scrollView setContentSize: CGSizeMake(320, 748)];

    
    if (textField == _m_textPassword) {
        [_m_scrollView setContentOffset: CGPointMake(0, 80) animated: YES];

    } else if (textField == _m_textConfirm) {
        [_m_scrollView setContentOffset: CGPointMake(0, 110) animated: YES];

    } else if (textField == _m_textPhone) {
        [_m_scrollView setContentOffset: CGPointMake(0, 140) animated: YES];

    } else if (textField == _m_textAddress) {
        [_m_scrollView setContentOffset: CGPointMake(0, 170) animated: YES];
    } else if (textField == _m_textOccupation) {
        [_m_scrollView setContentOffset: CGPointMake(0, 230) animated: YES];
    } else if (textField == _m_textAboutme) {
        [_m_scrollView setContentOffset: CGPointMake(0, 270) animated: YES];
    }
    
    
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [_m_scrollView setContentSize: CGSizeMake(320, 548)];

    [_m_scrollView setContentOffset: CGPointMake(0, 0) animated: YES];
    
    return YES;
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
    
    NSInteger nRet = [dataKeeper Signup2:_m_textEmail.text first:_m_textFirstName.text last:_m_textLastName.text password:_m_textPassword.text accounttype:_m_textAccountType.text birthdate:_m_textBirthday.text phone:_m_textPhone.text address:_m_textAddress.text occupation:_m_textOccupation.text aboutme:_m_textAboutme.text photo: _m_imageData];
    
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.navigationController pushViewController: appDelegate.mainViewController animated: YES];
}

- (void) ShowRegisterFailed {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:dataKeeper.m_strLastErrorMessage];
}

/**
 ** Take Picture from camera or library
 */
- (IBAction)takePictureWithCamera:(int)selected {
    
	UIImagePickerController* controller = [[UIImagePickerController alloc] init];
    
	controller.delegate = self;
    
	if (selected == 1) {
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera Not Available for This Device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alertView show];
            [alertView release];
            
        }
		
	} else {
		[controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setMediaTypes:[NSArray arrayWithObject:(NSString*)kUTTypeImage]];
        controller.allowsEditing = NO;
        
	}
    
    [self presentViewController:controller animated:YES completion:nil];
}

////////////////////////////////////////////////////////////
/////// Action sheet delegate
////////////////////////////////////////////////////////////

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    if ([actionSheet.title isEqualToString:@"Change Photo"]) {
    if (buttonIndex == 0)
    {
        [self takePictureWithCamera:1];
    }
    else if(buttonIndex == 1) {
        [self takePictureWithCamera:2];
    }
    else {
        
    }
    //    }
}

////////////////////////////////////////////////////////////////////////
/////// Image Picker Delegate
////////////////////////////////////////////////////////////////////////

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion: nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    
    if (_m_imageData != nil)
    {
        [_m_imageData release];
    }
    
    UIImage *imgOriginal = [info objectForKey: UIImagePickerControllerOriginalImage];
    UIImage *reducedImage = nil;
    
    if (imgOriginal.size.width > imgOriginal.size.height) {
        NSLog(@"org (%f, %f), new (480, %f)", imgOriginal.size.width, imgOriginal.size.height, 480 * imgOriginal.size.height / imgOriginal.size.width);
        reducedImage = [CUtils resizeImage:imgOriginal toSize:CGSizeMake(480, 480 * imgOriginal.size.height / imgOriginal.size.width)];
    } else {
        NSLog(@"org (%f, %f), new (320, %f)", imgOriginal.size.width, imgOriginal.size.height, 320 * imgOriginal.size.width / imgOriginal.size.height);
        reducedImage = [CUtils resizeImage:imgOriginal toSize:CGSizeMake(320, 320 * imgOriginal.size.height / imgOriginal.size.width)];
    }
    _m_imageData = [UIImageJPEGRepresentation(reducedImage, 1) retain];
    
  //  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  //  [appDelegate showLoading];
    [self dismissViewControllerAnimated:YES completion: nil];
    
    [_m_imageviewMyPhoto setImage: [UIImage imageWithData: _m_imageData]];
    
    //[NSThread detachNewThreadSelector:@selector(UploadImage) toTarget:self withObject:nil];
}

#pragma mark - Upload Image

- (void) UploadImage {
    /*
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    [dataKeeper UploadWallImage: _m_imageData];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate hideLoading];
    
    dataKeeper.m_bShouldRefresh = YES;
    
    [self RefreshWall];
    [pool release];
     */
}

#pragma mark - Picker Functions

/**
 ** Show Drop Down menu
 **/

- (void) ShowDropdown {
    
    if (_m_viewPicker.hidden == NO)
        return;
    
    [self DismissKeyboard];
    
    if (m_nPickerType == 0) {
        [_m_datePicker setHidden: YES];
        [_m_pickerView setHidden: NO];
    } else {
        [_m_datePicker setHidden: NO];
        [_m_pickerView setHidden: YES];
        
    }
    
    //   m_coverView.hidden = NO;
    
    // Animation
    [_m_viewPicker setFrame: CGRectMake(0, self.view.frame.size.height, _m_viewPicker.frame.size.width, _m_viewPicker.frame.size.height)];
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.7f];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector:nil];
    
    [_m_viewPicker setFrame: CGRectMake(0, self.view.frame.size.height - _m_viewPicker.frame.size.height, _m_viewPicker.frame.size.width, _m_viewPicker.frame.size.height)];
    [_m_viewPicker setHidden: NO];
    
    [UIView commitAnimations];
    
}

- (void) HideDropdown {
    // For Portrait
    if (_m_viewPicker.hidden == YES)
        return;
    
    // Animation
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.7f];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector:@selector(pickerAnimationEnded)];
    
    [_m_viewPicker setFrame: CGRectMake(0, self.view.frame.size.height, _m_viewPicker.frame.size.width, _m_viewPicker.frame.size.height)];
    
    [UIView commitAnimations];
    
    //    m_coverView.hidden = YES;
}

- (void) pickerAnimationEnded {
    [_m_viewPicker setHidden: YES];
}

#pragma mark - PickerView delegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    //   DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    if (m_nPickerType == 0) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self getRowString: row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

- (NSString *) getRowString: (NSInteger) nRow {
    //    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    return @"Member";
    
}


@end
