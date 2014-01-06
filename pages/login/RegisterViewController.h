//
//  RegisterViewController.h
//  Schedule
//
//  Created by TanLong on 11/4/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

@property (retain, nonatomic) IBOutlet UITextField *m_textFirstName;
@property (retain, nonatomic) IBOutlet UITextField *m_textLastName;
@property (retain, nonatomic) IBOutlet UITextField *m_textEmail;


- (IBAction)onTouchCancelBtn:(id)sender;
- (IBAction)onTouchSignupBtn:(id)sender;
- (IBAction)onTouchBackgroundBtn:(id)sender;

@end
