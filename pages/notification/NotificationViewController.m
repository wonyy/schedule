//
//  NotificationViewController.m
//  Schedule
//
//  Created by Mountain on 10/2/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "NotificationViewController.h"
#import "DBConnector.h"
#import <QuartzCore/QuartzCore.h>

@interface NotificationViewController ()

@end

@implementation NotificationViewController

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
    
    _m_tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _m_tableView.layer.borderWidth = 1;
    _m_tableView.layer.cornerRadius = 2;
    _m_tableView.layer.masksToBounds = YES;
    
    // Set Profile Image
    
    [self refreshImage];
    
    [self ReloadData];
    
    // Set Timer for current Date
    [self setLabel];
    [self createTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_notifyCell release];
    [_m_tableView release];
    [_m_imgViewProfile release];
    [_m_btnNotifications release];
    [_m_btnPendings release];
    
    if (m_aryNotifi != nil) {
        [m_aryNotifi release];
    }
    
    if (m_aryRequests != nil) {
        [m_aryRequests release];
    }
    
    if (m_aryInvites != nil) {
        [m_aryInvites release];
    }
    
    if (m_aryPendings != nil) {
        [m_aryPendings release];
    }
    
    
    [_m_pendingCell release];
    [_m_inviteCell release];
    [_m_requestCell release];
    
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    
    if (m_timer != nil) {
        [m_timer release];
    }
    
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    [dataKeeper saveDataToFile];
    
    [super dealloc];
}

- (void) ReloadData {
    DBConnector *dbConn = [[DBConnector new] autorelease];
    
    m_aryNotifi = [dbConn getAllNotifications];
    m_aryRequests = [dbConn getAllRequests];
    m_aryInvites = [dbConn getAllInvites];
    m_aryPendings = [dbConn getAllPendings];
    
    NSInteger m_nNotiCnt = [m_aryNotifi count] + [m_aryRequests count] + [m_aryInvites count];
    
    [_m_btnNotifications setTitle:[NSString stringWithFormat:@"Notifications (%d)", m_nNotiCnt] forState:UIControlStateNormal];
    
    [_m_btnPendings setTitle:[NSString stringWithFormat:@"Pending (%d)", [m_aryPendings count]] forState:UIControlStateNormal];
    
    [_m_tableView reloadData];
}

#pragma mark - Touch Actions

- (IBAction)onTouchBackBtn:(id)sender {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)onTouchEditBtn:(id)sender {
    
}

- (IBAction)onTouchNotificationBtn:(id)sender {
    [_m_btnNotifications setSelected: YES];
    [_m_btnPendings setSelected: NO];
    
    [self ReloadData];
}

- (IBAction)onTouchPendingBtn:(id)sender {
    [_m_btnNotifications setSelected: NO];
    [_m_btnPendings setSelected: YES];
    
    [self ReloadData];
}

- (IBAction)onTouchRequestAcceptBtn:(id)sender {
    m_nCurNotiID = [sender tag];
    
    [self AcceptRequest];
}

- (IBAction)onTouchRequestDeclineBtn:(id)sender {
    m_nCurNotiID = [sender tag];
    
    [self ReadNotification];
}

- (IBAction)onTouchInviteAcceptBtn:(id)sender {
    m_nCurNotiID = [sender tag];
    
    [self AcceptInvite];

}

- (IBAction)onTouchInviteDeclineBtn:(id)sender {
    m_nCurNotiID = [sender tag];
    
    [self DeclineInvite];
}

- (IBAction)onTouchNotificationOkBtn:(id)sender {
    m_nCurNotiID = [sender tag];
    
    [self ReadNotification];
}

#pragma mark - Table View Delegate

// Set the height of each cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

// Set Cell Count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_m_btnNotifications.selected == YES) {
        return [m_aryNotifi count] + [m_aryRequests count] + [m_aryInvites count];
    }
    
    return [m_aryPendings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (_m_btnNotifications.selected == YES) {
        if (indexPath.row < [m_aryRequests count]) {
            [[NSBundle mainBundle] loadNibNamed:@"RequestCell" owner:self options:nil];
            
            RequestItem *requestItem = [m_aryRequests objectAtIndex: indexPath.row];
            
            [_m_requestCell.m_labelMessage setText: requestItem.message];
            
            [_m_requestCell setM_strImgURL: [NSString stringWithFormat:@"%@%@", HOST_URL, requestItem.profile_picture]];
            
            [_m_requestCell.m_btnAccept setTag: [requestItem.requestID integerValue]];
            [_m_requestCell.m_btnDecline setTag: [requestItem.requestID integerValue]];
            
            [_m_requestCell refreshImage];
            
            return _m_requestCell;
            
        } else if (indexPath.row < [m_aryRequests count] + [m_aryInvites count]) {
            [[NSBundle mainBundle] loadNibNamed:@"InviteCell" owner:self options:nil];

            InviteItem *inviteItem = [m_aryInvites objectAtIndex: indexPath.row - [m_aryRequests count]];
            
            [_m_inviteCell.m_labelMessage setText: inviteItem.message];
            
            [_m_inviteCell setM_strImgURL: [NSString stringWithFormat:@"%@%@", HOST_URL, inviteItem.profile_picture]];
            
            [_m_inviteCell.m_btnAccept setTag: [inviteItem.inviteID integerValue]];
            [_m_inviteCell.m_btnDecline setTag: [inviteItem.inviteID integerValue]];
            
            [_m_inviteCell refreshImage];

            
            return _m_inviteCell;

        } else {
            [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil];

            NotificationItem *notifiItem = [m_aryNotifi objectAtIndex: indexPath.row - [m_aryRequests count] - [m_aryInvites count]];
            
            [_m_notifyCell.m_labelMessage setText: notifiItem.message];
            [_m_notifyCell setM_strImgURL: [NSString stringWithFormat:@"%@%@", HOST_URL, notifiItem.profile_picture]];
            [_m_notifyCell.m_btnOk setTag: [notifiItem.notifID integerValue]];
            
            [_m_notifyCell refreshImage];
            
            return _m_notifyCell;
        }
        
    } else {
        [[NSBundle mainBundle] loadNibNamed:@"PendingCell" owner:self options:nil];

        PendingItem *pendingItem = [m_aryPendings objectAtIndex: indexPath.row];
        
        [_m_pendingCell.m_labelMessage setText: pendingItem.message];
        
        return _m_pendingCell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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

#pragma mark - Loading Indicator Functions

- (void) ShowLoading {
    HUD.labelText = @"Loading";
    [HUD showUsingAnimation: YES];
}

- (void) ShowSaving {
    HUD.labelText = @"";
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

- (void) AcceptRequest {
    // Show Loading for Initalize
    [self ShowSaving];
    
    [NSThread detachNewThreadSelector:@selector(AcceptRequestThread) toTarget:self withObject:nil];
}

- (void) AcceptRequestThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"AcceptRequestThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSInteger nRet = [dataKeeper AcceptFriendRequest: [NSString stringWithFormat:@"%d", m_nCurNotiID]];
    
    if (nRet == 1) {
        [self performSelectorOnMainThread:@selector(ReloadData) withObject:nil waitUntilDone:YES];
    } else {
        
        //[dbConn makeEventOnline: m_information online: NO];
        [self performSelectorOnMainThread:@selector(FailedSave) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    NSLog(@"AcceptRequestThread: End!!!");
    [pool release];
}

- (void) DeclineRequest {
    // Show Loading for Initalize
    [self ShowSaving];
    
    [NSThread detachNewThreadSelector:@selector(DeclineRequestThread) toTarget:self withObject:nil];
}

- (void) DeclineRequestThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"DeclineRequestThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSInteger nRet = [dataKeeper DeclineFriendRequest: [NSString stringWithFormat:@"%d", m_nCurNotiID]];
    
    if (nRet == 1) {
        [self performSelectorOnMainThread:@selector(ReloadData) withObject:nil waitUntilDone:YES];
    } else {
        
        //[dbConn makeEventOnline: m_information online: NO];
        [self performSelectorOnMainThread:@selector(FailedSave) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    NSLog(@"DeclineRequestThread: End!!!");
    [pool release];
}

- (void) AcceptInvite {
    // Show Loading for Initalize
    [self ShowSaving];
    
    [NSThread detachNewThreadSelector:@selector(AcceptInviteThread) toTarget:self withObject:nil];
}

- (void) AcceptInviteThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"AcceptInviteThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSInteger nRet = [dataKeeper AcceptEventInvite: [NSString stringWithFormat:@"%d", m_nCurNotiID]];
    
    if (nRet == 1) {
        [self performSelectorOnMainThread:@selector(ReloadData) withObject:nil waitUntilDone:YES];
    } else {
        
        //[dbConn makeEventOnline: m_information online: NO];
        [self performSelectorOnMainThread:@selector(FailedSave) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    NSLog(@"AcceptInviteThread: End!!!");
    [pool release];
}

- (void) DeclineInvite {
    // Show Loading for Initalize
    [self ShowSaving];
    
    [NSThread detachNewThreadSelector:@selector(DeclineInviteThread) toTarget:self withObject:nil];
}

- (void) DeclineInviteThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"DeclineInviteThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSInteger nRet = [dataKeeper DeclineEventInvite: [NSString stringWithFormat:@"%d", m_nCurNotiID]];
    
    if (nRet == 1) {
        [self performSelectorOnMainThread:@selector(ReloadData) withObject:nil waitUntilDone:YES];
    } else {
        
        //[dbConn makeEventOnline: m_information online: NO];
        [self performSelectorOnMainThread:@selector(FailedSave) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    NSLog(@"DeclineInviteThread: End!!!");
    [pool release];
}

- (void) ReadNotification {
    // Show Loading for Initalize
    [self ShowSaving];
    
    [NSThread detachNewThreadSelector:@selector(ReadNotificationThread) toTarget:self withObject:nil];
}

- (void) ReadNotificationThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"ReadNotificationThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSInteger nRet = [dataKeeper ReadNotification: [NSString stringWithFormat:@"%d", m_nCurNotiID]];
    
    if (nRet == 1) {
        [self performSelectorOnMainThread:@selector(ReloadData) withObject:nil waitUntilDone:YES];
    } else {
        
        //[dbConn makeEventOnline: m_information online: NO];
        [self performSelectorOnMainThread:@selector(FailedSave) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    NSLog(@"ReadNotificationThread: End!!!");
    [pool release];
}

- (void) GotoMainScreen {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) FailedSave {
    [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Save is failed."];
}


#pragma mark - Date/Time Functions
- (void) createTimer {
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setLabel) userInfo:nil repeats: YES];
}

- (void)setLabel {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSDate * toDay = [NSDate date];
    NSDateFormatter * dateformatter = [[NSDateFormatter new] autorelease];
    
    [dateformatter setDateFormat:dataKeeper.m_mySettingInfo.dateformat];
    NSString * dateString = [dateformatter stringFromDate:toDay];
    dateformatter.dateFormat = @"EEE";
    
    NSString * dayString = [[dateformatter stringFromDate:toDay] capitalizedString];
    [_m_labelCurrentDate setText:[NSString stringWithFormat:@"%@, %@", dayString, dateString]];
    
    
    dateformatter.dateFormat = dataKeeper.m_mySettingInfo.timeformat;
    NSString * timeString = [dateformatter stringFromDate:toDay];
    [_m_labelCurrentTime setText:timeString];
    
    //   NSLog(@"---- setLabel -----");
}
@end
