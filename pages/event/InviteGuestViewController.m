//
//  InviteGuestViewController.m
//  Schedule
//
//  Created by TanLong on 11/15/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "InviteGuestViewController.h"
#import "DBConnector.h"

@interface InviteGuestViewController ()

@end

@implementation InviteGuestViewController

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
	// Do any additional setup after loading the view.
    
    m_arySelectedFriends = [[NSMutableArray alloc] init];
    
    [self ReloadData];
    
    [self refreshImage];
    
    // Set Timer for current Date
    [self setLabel];
    [self createTimer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_tableView release];
    [_m_inviteCell release];
    
    [m_arySelectedFriends release];
    [_m_aryInitialFriends release];
    
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    [_m_imgViewProfile release];
    
    if (m_timer != nil) {
        [m_timer release];
    }
    [_m_textFieldEmail release];
    [_m_viewEmail release];
    [super dealloc];
}


#pragma mark -
#pragma mark Keyboard Notification
- (void)keyboardWillShow: (NSNotification *)notif
{
    NSDictionary *info = [notif userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    
    [_m_viewEmail setFrame: CGRectMake(0, self.view.bounds.size.height - keyboardEndFrame.size.height - 45, 320, 45)];
    [UIView commitAnimations];
}

- (void)keyboardwillHide: (NSNotification *)notif
{
    
    NSDictionary *info = [notif userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    
    [_m_viewEmail setFrame: CGRectMake(0, self.view.bounds.size.height  - 45, 320, 45)];
    [UIView commitAnimations];
}



#pragma mark - Touch Actions

- (IBAction)onTouchCancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)onTouchSaveBtn:(id)sender {
    [self.delegate InvitedGuest:m_arySelectedFriends];
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)onTouchAddBtn:(id)sender {
    FriendItem *newFriend = [[FriendItem alloc] init];
    
    newFriend.userID = _m_textFieldEmail.text;
    
    [m_aryFriends addObject: newFriend];
    [m_arySelectedFriends addObject: newFriend];
    
    [newFriend release];
    
    [_m_textFieldEmail resignFirstResponder];
    _m_textFieldEmail.text = @"";
    
    [_m_tableView reloadData];
}

- (IBAction)onEmailDidEndExit:(id)sender {
    [sender resignFirstResponder];
}

- (void) ReloadData {
    DBConnector *dbConn = [[DBConnector new] autorelease];
    
    m_aryFriends = [dbConn getAllFriends];
    
    if (_m_aryInitialFriends != nil) {
        for (NSInteger nIndex = 0; nIndex < [_m_aryInitialFriends count]; nIndex++) {
            NSDictionary *dictItem = [_m_aryInitialFriends objectAtIndex: nIndex];
            
            FriendItem *friendItem = [[FriendItem alloc] initWithDictionary: dictItem];
            
            [m_arySelectedFriends addObject: friendItem];
            
            [friendItem release];
        }
    }
        
    [_m_tableView reloadData];
}


#pragma mark - Table View Delegate

// Set the height of each cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

// Set Cell Count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_aryFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSBundle mainBundle] loadNibNamed:@"InviteGuestCell" owner:self options:nil];
    
    FriendItem *item = [m_aryFriends objectAtIndex: indexPath.row];
    
    if ([item.userID integerValue] > 0) {
        [_m_inviteCell.m_labelName setText: item.fullName];
        [_m_inviteCell.m_labelOccupation setText: item.occupation];
        //[_m_inviteCell.m_labelGroup setText: [NSString stringWithFormat:@"Group :  %@", item.group]];
        
        [_m_inviteCell setM_strImgURL: [NSString stringWithFormat:@"%@%@", HOST_URL, item.profilePicture]];
        [_m_inviteCell refreshImage];
        
    } else {
        [_m_inviteCell.m_labelName setText: item.userID];
    }
    
    
    NSInteger nIndex = [self FindItem: item];
    
    if (nIndex >= 0) {
        _m_inviteCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        _m_inviteCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
//    _m_inviteCell.accessoryType = UITableViewCellAccessoryCheckmark;
   
    return _m_inviteCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    FriendItem *item = [m_aryFriends objectAtIndex: indexPath.row];
    
    NSInteger nIndex = [self FindItem: item];
    
    if (nIndex >= 0) {
        [m_arySelectedFriends removeObjectAtIndex: nIndex];
    } else {
        [m_arySelectedFriends addObject: item];
    }
    
    [_m_tableView reloadData];
}

- (NSInteger) FindItem: (FriendItem *) item {
    for (NSInteger nIndex = 0; nIndex < [m_arySelectedFriends count]; nIndex++) {
        
        FriendItem *friendItem = [m_arySelectedFriends objectAtIndex: nIndex];
        
        if ([item.userID isEqualToString: friendItem.userID]) {
            return nIndex;
        }
    }
    
    return -1;
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
