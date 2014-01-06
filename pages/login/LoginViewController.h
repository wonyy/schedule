//
//  LoginViewController.h
//  Schedule
//
//  Created by Mountain on 10/19/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

@property (retain, nonatomic) IBOutlet UITextField *m_textEmailAddress;
@property (retain, nonatomic) IBOutlet UITextField *m_textPassword;

- (IBAction)onTouchSubmitBtn:(id)sender;
- (IBAction)onTouchForgetPasswordBtn:(id)sender;
- (IBAction)onTouchSignupBtn:(id)sender;


- (IBAction)onTextDidEndExit:(id)sender;

@end
