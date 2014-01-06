//
//  FriendsViewController.m
//  Schedule
//
//  Created by wonymini on 9/26/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendDetailViewController.h"
#import "DBConnector.h"


@interface FriendsViewController ()

@end

@implementation FriendsViewController

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
    // Loading Indicator Initialize
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    m_sortArrays = [[NSArray alloc] initWithObjects:@"First Name", @"Available/Busy", @"Group", nil];

    // Set Timer for current Date
    [self setLabel];
    [self createTimer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [self refreshImage];
    
    [self ReloadData];
}

- (void)dealloc {
    [_m_friendsCell release];
    [_m_imgViewProfile release];
    [_m_textfieldSearch release];
    [_m_btnSort release];
    [_m_tableView release];
    [_m_viewPicker release];
    [_m_pickerView release];
    [m_sortArrays release];
    
    if (m_timer != nil) {
        [m_timer release];
    }
    
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    [super dealloc];
}

- (void) ReloadData {
    DBConnector *dbConn = [[DBConnector new] autorelease];
    
    m_aryFriends = [dbConn getAllFriends];
    
    [self Sort];
    
    [_m_tableView reloadData];
}

#pragma mark - Table View Delegate


// Set the height of each cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

// Set Cell Count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (m_bType == 0) {
        return [m_aryFriends count];
    }
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    return [dataKeeper.m_arraySearchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSBundle mainBundle] loadNibNamed:@"FriendsCell" owner:self options:nil];
    
    if (m_bType == 0) {
    
        FriendItem *item = [m_aryFriends objectAtIndex: indexPath.row];
        
        [_m_friendsCell.m_labelName setText: item.fullName];
        [_m_friendsCell.m_labelOccupation setText: item.occupation];
        [_m_friendsCell.m_labelGroup setText: [NSString stringWithFormat:@"Group :  %@", item.group]];
        [_m_friendsCell.m_labelDistance setText: [NSString stringWithFormat:@"Distance : %@km", item.distance]];
        
        [_m_friendsCell setM_strImgURL: [NSString stringWithFormat:@"%@%@", HOST_URL, item.profilePicture]];
        [_m_friendsCell refreshImage];
        
        return _m_friendsCell;
    }
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSDictionary *dictItem = [dataKeeper.m_arraySearchResults objectAtIndex: indexPath.row];
    
    [_m_friendsCell.m_labelName setText: [dictItem objectForKey:@"full_name"]];
    [_m_friendsCell.m_labelOccupation setText: [dictItem objectForKey:@"occupation"]];
    
    if ([[dictItem objectForKey:@"is_friend"] isEqualToString:@"false"]) {
        [_m_friendsCell.m_labelDistance setHidden: YES];
        [_m_friendsCell.m_labelGroup setText: [NSString stringWithFormat:@"Click to invite"]];
        [_m_friendsCell.m_btnCellPhone setHidden: YES];
        [_m_friendsCell.m_btnEmail setHidden: YES];
    } else {
        [_m_friendsCell.m_labelDistance setHidden: NO];
        
        [_m_friendsCell.m_labelGroup setText: [NSString stringWithFormat:@"Group :  %@", [dictItem objectForKey:@"group"]]];
        [_m_friendsCell.m_btnCellPhone setHidden: NO];
        [_m_friendsCell.m_btnEmail setHidden: NO];
    }
    
    
    [_m_friendsCell setM_strImgURL: [NSString stringWithFormat:@"%@%@", HOST_URL, [dictItem objectForKey:@"profile_picture"]]];
    [_m_friendsCell refreshImage];
    
    return _m_friendsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendDetailViewController *detailVC = [[FriendDetailViewController alloc] initWithNibName:@"FriendDetailViewController" bundle: nil];
    
    if (m_bType == 0) {
    
        FriendItem *item = [m_aryFriends objectAtIndex: indexPath.row];
        [detailVC setM_currentFriend: item];
        
        [self.navigationController pushViewController: detailVC animated: YES];
        [detailVC release];
    } else {
        DataKeeper *dataKeeper = [DataKeeper sharedInstance];
        
        NSDictionary *dictItem = [dataKeeper.m_arraySearchResults objectAtIndex: indexPath.row];
        
        if ([[dictItem objectForKey:@"is_friend"] isEqual:@"true"]) {
            
            for (NSInteger nIndex = 0; nIndex < [m_aryFriends count]; nIndex++) {
                FriendItem *item = [m_aryFriends objectAtIndex: nIndex];
                
                if ([item.userID isEqualToString: [dictItem objectForKey:@"user_id"]]) {
                    [detailVC setM_currentFriend: item];
                    
                    [self.navigationController pushViewController: detailVC animated: YES];
                    [detailVC release];
                    
                    return;
                    
                }
            }
            
        }
        
        m_dictCurrentUser = dictItem;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_ALERT_TITLE message:@"Are you going to invite this user?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        [alertView show];
        
        [alertView release];
    }
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

#pragma mark - Touch Actions

- (IBAction)onTouchPickerCancelBtn:(id)sender {
    [self HideDropdown];
}

- (IBAction)onTouchPickerOkBtn:(id)sender {
    
    m_sortType = [_m_pickerView selectedRowInComponent: 0];
    
    [_m_btnSort setTitle:[self getRowString: [_m_pickerView selectedRowInComponent: 0]] forState:UIControlStateNormal];
    
    [self Sort];
    
    [_m_tableView reloadData];
    
    [self HideDropdown];    
}

- (IBAction)onTouchSortBtn:(id)sender {
    [_m_textfieldSearch resignFirstResponder];
    [self ShowDropdown];
}

- (IBAction)onSearch:(id)sender {
    if ([_m_textfieldSearch.text isEqualToString:@""]) {
        m_bType = 0;
        [self ReloadData];
    } else {
        m_bType = 1;
        [self Search];   
    }
}

- (void) Sort {
    if (m_bType == 0) {
        [m_aryFriends sortUsingComparator:^NSComparisonResult(id a, id b) {
            if (m_sortType == SORT_FIRSTNAME) {
                return [[(FriendItem *)a fullName] compare: [(FriendItem *)b fullName]];
            } else if (m_sortType == SORT_GROUP) {
                return [[(FriendItem *)a group] compare: [(FriendItem *)b group]];
            }
            
            return [[(FriendItem *)a fullName] compare: [(FriendItem *)b fullName]];
            
        }];
    } else {
        DataKeeper *dataKeeper = [DataKeeper sharedInstance];
        
        [dataKeeper.m_arraySearchResults sortUsingComparator:^NSComparisonResult(id a, id b) {
            if (m_sortType == SORT_FIRSTNAME) {
                return [[(NSDictionary *)a objectForKey:@"full_name"] compare: [(NSDictionary *)b objectForKey:@"full_name"]];
            } else if (m_sortType == SORT_GROUP) {
                return [[(NSDictionary *)a objectForKey:@"group"] compare: [(NSDictionary *)b objectForKey:@"group"]];
            }
            
            return [[(NSDictionary *)a objectForKey:@"full_name"] compare: [(NSDictionary *)b objectForKey:@"full_name"]];
            
        }];
    }
}

#pragma mark - Loading Indicator Functions

- (void) ShowLoading {
    HUD.labelText = @"Loading";
    [HUD showUsingAnimation: YES];
}

- (void) ShowSearch {
    HUD.labelText = @"Search...";
    [HUD showUsingAnimation: YES];
}

- (void) ShowInvite {
    HUD.labelText = @"Invite...";
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

- (void) Search {
    // Show Loading for Initalize
    [self ShowSearch];
    
    [NSThread detachNewThreadSelector:@selector(SearchThread) toTarget:self withObject:nil];
}

- (void) SearchThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"SearchThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSInteger nRet = [dataKeeper Search: _m_textfieldSearch.text];
    
    if (nRet == 1) {
        [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:YES];
        
    } else {
        //[self performSelectorOnMainThread:@selector(ShowLoginFailed) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    
    NSLog(@"SearchThread: End!!!");
    [pool release];
}

- (void) InviteUser {
    // Show Loading for Initalize
    [self ShowInvite];
    
    [NSThread detachNewThreadSelector:@selector(InviteUserThread) toTarget:self withObject:nil];
}

- (void) InviteUserThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"InviteUserThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSInteger nRet = [dataKeeper AddFriend: [m_dictCurrentUser objectForKey:@"user_id"]];
    
    if (nRet == 1) {
        [self performSelectorOnMainThread:@selector(SuccessInvite) withObject:nil waitUntilDone:YES];
        
    } else {
        [self performSelectorOnMainThread:@selector(FailedInvite) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    
    NSLog(@"InviteUserThread: End!!!");
    [pool release];
}


- (void) refreshTable {
    [self Sort];
    
    [_m_tableView reloadData];
}

- (void) SuccessInvite {
    [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Friend Invitation successfully sent!"];
}

- (void) FailedInvite {
    [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Failed to Invite a friend!"];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"Yes Button is Clicked!!");
        
        [self InviteUser];
    }
}

#pragma mark - Picker Functions

/**
 ** Show Drop Down menu
 **/

- (void) ShowDropdown {
    
    if (_m_viewPicker.hidden == NO)
        return;
        
    // Animation
    [_m_viewPicker setFrame: CGRectMake(0, self.view.frame.size.height, _m_viewPicker.frame.size.width, _m_viewPicker.frame.size.height)];
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.7f];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector:nil];
    
    [_m_viewPicker setFrame: CGRectMake(0, self.view.frame.size.height - _m_viewPicker.frame.size.height, _m_viewPicker.frame.size.width, _m_viewPicker.frame.size.height)];
    [_m_viewPicker setHidden: NO];
    
    [UIView commitAnimations];
    
}

- (void) HideDropdown {
    // For Portrait
    if (_m_viewPicker.hidden == YES)
        return;
    
    // Animation
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.7f];
    [UIView setAnimationDelegate: self];
    [UIView setAnimationDidStopSelector:@selector(pickerAnimationEnded)];
    
    [_m_viewPicker setFrame: CGRectMake(0, self.view.frame.size.height, _m_viewPicker.frame.size.width, _m_viewPicker.frame.size.height)];
    
    [UIView commitAnimations];
    
    //    m_coverView.hidden = YES;
}

- (void) pickerAnimationEnded {
    [_m_viewPicker setHidden: YES];
}

#pragma mark - PickerView delegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return SORT_TYPE_SIZE;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self getRowString: row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

- (NSString *) getRowString: (NSInteger) nRow {
    return [m_sortArrays objectAtIndex: nRow];
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
