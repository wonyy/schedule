//
//  InviteGuestViewController.h
//  Schedule
//
//  Created by TanLong on 11/15/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteGuestCell.h"

@protocol InviteGuestViewControllerDelegate

- (void)InvitedGuest:(NSArray *)selectedGuest;

@end

@interface InviteGuestViewController : UIViewController {
    NSMutableArray *m_aryFriends;
    NSMutableArray *m_arySelectedFriends;
    
    NSTimer *m_timer;
}

@property (nonatomic, retain) id<InviteGuestViewControllerDelegate>delegate;

@property (retain, nonatomic) NSMutableArray *m_aryInitialFriends;
@property (retain, nonatomic) IBOutlet UITableView *m_tableView;
@property (retain, nonatomic) IBOutlet InviteGuestCell *m_inviteCell;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;

@property (retain, nonatomic) IBOutlet UITextField *m_textFieldEmail;
@property (retain, nonatomic) IBOutlet UIView *m_viewEmail;


- (IBAction)onTouchCancelBtn:(id)sender;
- (IBAction)onTouchSaveBtn:(id)sender;
- (IBAction)onTouchAddBtn:(id)sender;
- (IBAction)onEmailDidEndExit:(id)sender;


@end
