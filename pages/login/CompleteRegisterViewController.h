//
//  CompleteRegisterViewController.h
//  Schedule
//
//  Created by TanLong on 11/4/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompleteRegisterViewController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    MBProgressHUD *HUD;
    NSInteger m_nPickerType;
}

@property (retain, nonatomic) IBOutlet UIScrollView *m_scrollView;

@property (retain, nonatomic) NSString *m_strFirstName;
@property (retain, nonatomic) NSString *m_strLastName;
@property (retain, nonatomic) NSString *m_strEmail;

@property (retain, nonatomic) IBOutlet UITextField *m_textFirstName;
@property (retain, nonatomic) IBOutlet UITextField *m_textLastName;
@property (retain, nonatomic) IBOutlet UITextField *m_textEmail;
@property (retain, nonatomic) IBOutlet UITextField *m_textPassword;
@property (retain, nonatomic) IBOutlet UITextField *m_textConfirm;
@property (retain, nonatomic) IBOutlet UITextField *m_textPhone;
@property (retain, nonatomic) IBOutlet UITextField *m_textAddress;
@property (retain, nonatomic) IBOutlet UITextField *m_textAccountType;
@property (retain, nonatomic) IBOutlet UITextField *m_textBirthday;
@property (retain, nonatomic) IBOutlet UITextField *m_textOccupation;
@property (retain, nonatomic) IBOutlet UITextField *m_textAboutme;
@property (retain, nonatomic) IBOutlet UIImageView *m_imageviewMyPhoto;

@property (retain, nonatomic) IBOutlet UIView *m_viewPicker;
@property (retain, nonatomic) IBOutlet UIPickerView *m_pickerView;
@property (retain, nonatomic) IBOutlet UIDatePicker *m_datePicker;


@property (retain, nonatomic) NSData *m_imageData;

- (IBAction)onTouchAccountTypeBtn:(id)sender;
- (IBAction)onTouchBirthdayBtn:(id)sender;
- (IBAction)onTouchSubmitBtn:(id)sender;
- (IBAction)onTouchPhotoBtn:(id)sender;
- (IBAction)onTouchBackgroundBtn:(id)sender;
- (IBAction)onTouchBackBtn:(id)sender;

- (IBAction)onTouchPickerCancelBtn:(id)sender;
- (IBAction)onTouchPickerOkBtn:(id)sender;


@end
