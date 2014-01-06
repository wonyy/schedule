//
//  ChangePasswordViewController.h
//  Schedule
//
//  Created by TanLong on 11/15/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController <MBProgressHUDDelegate, UITextFieldDelegate> {
    MBProgressHUD *HUD;
    NSTimer *m_timer;
    

}

@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;

@property (retain, nonatomic) IBOutlet UITextField *m_textCurrentPassword;
@property (retain, nonatomic) IBOutlet UITextField *m_textNewPassword;
@property (retain, nonatomic) IBOutlet UITextField *m_textConfirmPassword;
@property (retain, nonatomic) SettingItem *m_settingItem;

- (IBAction)onTouchSubmitBtn:(id)sender;
- (IBAction)onTouchNavBackBtn:(id)sender;

@end
