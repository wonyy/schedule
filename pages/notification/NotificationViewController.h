//
//  NotificationViewController.h
//  Schedule
//
//  Created by Mountain on 10/2/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationCell.h"
#import "RequestCell.h"
#import "InviteCell.h"
#import "PendingCell.h"

@interface NotificationViewController : UIViewController <MBProgressHUDDelegate> {
    NSMutableArray * m_aryNotifi;
    NSMutableArray * m_aryRequests;
    NSMutableArray * m_aryInvites;
    NSMutableArray * m_aryPendings;
    
    MBProgressHUD *HUD;
    
    NSInteger m_nCurNotiID;
    
    NSTimer *m_timer;
}

@property (retain, nonatomic) IBOutlet UITableView *m_tableView;
@property (retain, nonatomic) IBOutlet NotificationCell *m_notifyCell;
@property (retain, nonatomic) IBOutlet PendingCell *m_pendingCell;
@property (retain, nonatomic) IBOutlet InviteCell *m_inviteCell;
@property (retain, nonatomic) IBOutlet RequestCell *m_requestCell;

@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;

@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;


@property (retain, nonatomic) IBOutlet UIButton *m_btnNotifications;
@property (retain, nonatomic) IBOutlet UIButton *m_btnPendings;

- (IBAction)onTouchBackBtn:(id)sender;
- (IBAction)onTouchEditBtn:(id)sender;
- (IBAction)onTouchNotificationBtn:(id)sender;
- (IBAction)onTouchPendingBtn:(id)sender;

- (IBAction)onTouchRequestAcceptBtn:(id)sender;
- (IBAction)onTouchRequestDeclineBtn:(id)sender;
- (IBAction)onTouchInviteAcceptBtn:(id)sender;
- (IBAction)onTouchInviteDeclineBtn:(id)sender;
- (IBAction)onTouchNotificationOkBtn:(id)sender;

@end
