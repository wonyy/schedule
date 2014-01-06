//
//  FriendDetailViewController.h
//  Schedule
//
//  Created by Mountain on 10/1/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSwitch.h"
#import "FriendItem.h"
#import "DailyViewController.h"
#import "WeeklyViewController.h"
#import "MonthlyViewController.h"

@interface FriendDetailViewController : UIViewController <MBProgressHUDDelegate, CustomSwitchDelegate> {
    
    MBProgressHUD *HUD;

    NSMutableArray *m_arrayGroups;
    NSArray *m_arrayMenus;
    NSTimer *m_timer;
    
    NSInteger m_nPickerType;
    
    DailyViewController *dailyVC;
    WeeklyViewController *weeklyVC;
    MonthlyViewController *monthlyVC;
}

@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentView;


@property (retain, nonatomic) FriendItem *m_currentFriend;

@property (retain, nonatomic) CustomSwitch *switchRequest;
@property (retain, nonatomic) CustomSwitch *switchShowEvent;
@property (retain, nonatomic) CustomSwitch *switchPersonalTime;
@property (retain, nonatomic) CustomSwitch *switchDetailWorkTime;
@property (retain, nonatomic) CustomSwitch *switchDetailPersonTime;
@property (retain, nonatomic) CustomSwitch *switchDetailSchoolTime;
@property (retain, nonatomic) CustomSwitch *switchDetailOtherTime;

@property (retain, nonatomic) IBOutlet UILabel *m_labelName;
@property (retain, nonatomic) IBOutlet UILabel *m_labelOccupation;
@property (retain, nonatomic) IBOutlet UILabel *m_labelContact;
@property (retain, nonatomic) IBOutlet UILabel *m_labelGroup;


@property (retain, nonatomic) IBOutlet UIView *m_viewPicker;
@property (retain, nonatomic) IBOutlet UIPickerView *m_pickerGroups;

@property (retain, nonatomic) IBOutlet UIView *m_viewEvents;
@property (retain, nonatomic) IBOutlet UIView *m_viewToolbar;


- (IBAction)onTouchPickerCancelBtn:(id)sender;
- (IBAction)onTouchPickerOkBtn:(id)sender;

- (IBAction)onTouchBackBtn:(id)sender;
- (IBAction)onTouchChangeGroupSettingsBtn:(id)sender;
- (IBAction)onTouchContactDetailBtn:(id)sender;


@end
