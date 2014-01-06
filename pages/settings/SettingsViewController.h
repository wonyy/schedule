//
//  SettingsViewController.h
//  Schedule
//
//  Created by TanLong on 10/30/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupCell.h"
#import "HRColorPickerViewController.h"
#import "DialogContentViewController.h"


@interface SettingsViewController : UIViewController <HRColorPickerViewControllerDelegate, MBProgressHUDDelegate, UITextFieldDelegate, DialogContentViewControllerDelegate, UIXOverlayControllerDelegate> {
    
    UIView *currentColorView;
    
    SettingItem *settingItem;
    
    NSInteger m_nPickerType;

    MBProgressHUD *HUD;
    
    NSMutableArray *m_arrayGroups;
    
    UIXOverlayController* overlay;
    
    NSTimer *m_timer;
    
}


- (IBAction)onTouchBirthdayBtn:(id)sender;

- (IBAction)onTouchNavBackBtn:(id)sender;
- (IBAction)onTouchNavSaveBtn:(id)sender;
- (IBAction)onTouchWorkColorBtn:(id)sender;
- (IBAction)onTouchSchoolColorBtn:(id)sender;
- (IBAction)onTouchPersonalColorBtn:(id)sender;
- (IBAction)onTouchOtherColorBtn:(id)sender;

- (IBAction)onTouchOkBtn:(id)sender;
- (IBAction)onTouchCancelBtn:(id)sender;

- (IBAction)onTouchStartDay:(id)sender;
- (IBAction)onTouchStartWeek:(id)sender;
- (IBAction)onTouchDateFormat:(id)sender;
- (IBAction)onTouchTimeFormat:(id)sender;

- (IBAction)onTouchAddBtn:(id)sender;
- (IBAction)onTouchBackgroundBtn:(id)sender;
- (IBAction)onTouchChangePassword:(id)sender;

@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;

@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;



@property (retain, nonatomic) IBOutlet UIView *m_viewWorkColor;
@property (retain, nonatomic) IBOutlet UIView *m_viewSchoolColor;
@property (retain, nonatomic) IBOutlet UIView *m_viewPersonalColor;
@property (retain, nonatomic) IBOutlet UIView *m_viewOtherColor;

@property (retain, nonatomic) IBOutlet UIView *m_viewPicker;
@property (retain, nonatomic) IBOutlet UIPickerView *m_pickerView;
@property (retain, nonatomic) IBOutlet UIDatePicker *m_datePicker;

@property (retain, nonatomic) IBOutlet UILabel *m_labelStartDay;
@property (retain, nonatomic) IBOutlet UILabel *m_labelStartWeek;
@property (retain, nonatomic) IBOutlet UILabel *m_labelDateFormat;
@property (retain, nonatomic) IBOutlet UILabel *m_labelTimeFormat;

@property (retain, nonatomic) IBOutlet UITextField *m_textFirstName;
@property (retain, nonatomic) IBOutlet UITextField *m_textLastName;
@property (retain, nonatomic) IBOutlet UITextField *m_textPhone;
@property (retain, nonatomic) IBOutlet UITextField *m_textAddress;
@property (retain, nonatomic) IBOutlet UITextField *m_textOccuapation;
@property (retain, nonatomic) IBOutlet UITextField *m_textAboutme;
@property (retain, nonatomic) IBOutlet UITextField *m_textBirthday;


@property (retain, nonatomic) IBOutlet GroupCell *m_groupCell;

@property (retain, nonatomic) IBOutlet UITableView *m_tableViewGroup;
@property (retain, nonatomic) IBOutlet UIScrollView *m_scrollView;



@end
