//
//  FriendDetailViewController.m
//  Schedule
//
//  Created by Mountain on 10/1/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "DBConnector.h"
#import "SBJsonWriter.h"



@interface FriendDetailViewController ()

@end

@implementation FriendDetailViewController

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
    
    // Loading Indicator Initialize
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;

    [self GetFriendEvents];
    
    // Profile Picture
    [self refreshImage];
    
    // Switch Control Initialize
    _switchRequest = [[CustomSwitch alloc] initWithFrame:CGRectMake(7, 198, 43, 24)];
    _switchRequest.delegate = self;
    [_switchRequest setValue:_m_currentFriend.allow_request withUI: NO];
    [self.view addSubview: _switchRequest];
    
    _switchShowEvent = [[CustomSwitch alloc] initWithFrame:CGRectMake(7, 227, 43, 24)];
    _switchShowEvent.delegate = self;
    [_switchShowEvent setValue:_m_currentFriend.show_event_block withUI: NO];
    [self.view addSubview: _switchShowEvent];
    
    _switchPersonalTime = [[CustomSwitch alloc] initWithFrame:CGRectMake(7, 256, 43, 24)];
    _switchPersonalTime.delegate = self;
    [_switchPersonalTime setValue:_m_currentFriend.show_personal_as_available withUI: NO];
    [self.view addSubview: _switchPersonalTime];
    
    _switchDetailWorkTime = [[CustomSwitch alloc] initWithFrame:CGRectMake(7, 285, 43, 24)];
    _switchDetailWorkTime.delegate = self;
    [_switchDetailWorkTime setValue:_m_currentFriend.show_work_time withUI: NO];
    [self.view addSubview: _switchDetailWorkTime];
    
    _switchDetailPersonTime = [[CustomSwitch alloc] initWithFrame:CGRectMake(7, 314, 43, 24)];
    _switchDetailPersonTime.delegate = self;
    [_switchDetailPersonTime setValue:_m_currentFriend.show_personal_time withUI: NO];
    [self.view addSubview: _switchDetailPersonTime];
    
    _switchDetailSchoolTime = [[CustomSwitch alloc] initWithFrame:CGRectMake(7, 343, 43, 24)];
    _switchDetailSchoolTime.delegate = self;
    [_switchDetailSchoolTime setValue:_m_currentFriend.show_school_time withUI: NO];
    [self.view addSubview: _switchDetailSchoolTime];
    
    _switchDetailOtherTime = [[CustomSwitch alloc] initWithFrame:CGRectMake(7, 372, 43, 24)];
    _switchDetailOtherTime.delegate = self;
    [_switchDetailOtherTime setValue:_m_currentFriend.show_other_time withUI: NO];
    [self.view addSubview: _switchDetailOtherTime];
    
    [_m_labelName setText: _m_currentFriend.fullName];
    [_m_labelOccupation setText: _m_currentFriend.occupation];
    [_m_labelContact setText: [NSString stringWithFormat:@"%@", _m_currentFriend.phoneNumber]];
    [_m_labelGroup setText: [NSString stringWithFormat:@"Group : %@", _m_currentFriend.group]];
    
    dailyVC = [[DailyViewController alloc] initWithNibName:@"DailyViewController" bundle:nil];
    weeklyVC = [[WeeklyViewController alloc] initWithNibName:@"WeeklyViewController" bundle:nil];
    monthlyVC = [[MonthlyViewController alloc] initWithNibName:@"MonthlyViewController" bundle: nil];
    
    [dailyVC setM_bFriend: YES];
    [weeklyVC setM_bFriend: YES];
    [monthlyVC setM_bFriend: YES];
    
    [dailyVC setM_strUserId: _m_currentFriend.userID];
    [weeklyVC setM_strUserId: _m_currentFriend.userID];
    [monthlyVC setM_strUserId: _m_currentFriend.userID];
    
 //   [_m_viewEvents addSubview: dailyVC.view];
 //   [_m_viewEvents addSubview: weeklyVC.view];
 //   [_m_viewEvents addSubview: monthlyVC.view];
    
//    [dailyVC.view setHidden: YES];
//    [weeklyVC.view setHidden: YES];
//    [monthlyVC.view setHidden: YES];
    
    [_m_viewEvents setHidden: YES];
    
    // Get Group List
    
    DBConnector *dbConn = [[DBConnector new] autorelease];
    
    m_arrayGroups = [dbConn getAllGroups];
    
    for (NSInteger nIndex = 0; nIndex < [m_arrayGroups count]; nIndex++) {
        GroupItem *groupItem = [m_arrayGroups objectAtIndex: nIndex];
        
        if ([groupItem.groupID isEqualToString: _m_currentFriend.groupID]) {
            [_m_pickerGroups selectRow:nIndex inComponent:0 animated:NO];
            break;
        }
    }
    
    m_arrayMenus = [[NSArray alloc] initWithObjects:@"Contact Detail", @"Day View", @"Week View", @"Month View", nil];
    
    // Set Timer for current Date
    [self setLabel];
    [self createTimer];
    
    m_nPickerType = 1;
    [_m_pickerGroups reloadAllComponents];

    [_m_pickerGroups selectRow:1 inComponent:0 animated:NO];
    
    [self onTouchPickerOkBtn: nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_imgViewProfile release];
    [_switchRequest release];
    [_switchShowEvent release];
    [_switchPersonalTime release];
    [_switchDetailWorkTime release];
    [_switchDetailPersonTime release];
    [_switchDetailSchoolTime release];
    [_switchDetailOtherTime release];
    [_m_currentFriend release];
    [_m_labelName release];
    [_m_labelOccupation release];
    [_m_labelContact release];
    [_m_viewPicker release];
    [_m_pickerGroups release];
    [_m_labelGroup release];
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    
    [m_arrayMenus release];
    
    if (m_timer != nil) {
        [m_timer release];
    }
    
    [dailyVC release];
    [weeklyVC release];
    [monthlyVC release];

    [_m_viewEvents release];
    [_m_viewToolbar release];
    [_m_labelCurrentView release];
    [super dealloc];
}

#pragma mark - Touch Actions

- (IBAction)onTouchPickerCancelBtn:(id)sender {
    [self HideDropdown];
}

- (IBAction)onTouchPickerOkBtn:(id)sender {
    [self HideDropdown];
    
    if (m_nPickerType == 0) {
    
        GroupItem *groupItem = [m_arrayGroups objectAtIndex: [_m_pickerGroups selectedRowInComponent: 0]];
        
        _m_currentFriend.groupID = groupItem.groupID;
        _m_currentFriend.group = groupItem.name;
        
        [_m_labelGroup setText: [NSString stringWithFormat:@"Group : %@", _m_currentFriend.group]];
        
        [self SaveFriendSettings];
    } else if (m_nPickerType == 1) {
        NSInteger nIndex = [_m_pickerGroups selectedRowInComponent: 0];
        
        [_m_labelCurrentView setText:[m_arrayMenus objectAtIndex: nIndex]];
        
        if (nIndex == 0) {
            [_m_viewEvents setHidden: YES];
            
            [dailyVC.view removeFromSuperview];
            [weeklyVC.view removeFromSuperview];
            [monthlyVC.view removeFromSuperview];
        } else if (nIndex == 1) {
            [self.view bringSubviewToFront: _m_viewEvents];
            [self.view bringSubviewToFront: _m_viewToolbar];
            [_m_viewEvents setHidden: NO];
            
            [_m_viewEvents addSubview: dailyVC.view];
            
            [weeklyVC.view removeFromSuperview];
            [monthlyVC.view removeFromSuperview];
        } else if (nIndex == 2) {
            [self.view bringSubviewToFront: _m_viewEvents];
            [self.view bringSubviewToFront: _m_viewToolbar];
            [_m_viewEvents setHidden: NO];
            
            [dailyVC.view removeFromSuperview];
            [_m_viewEvents addSubview: weeklyVC.view];
            [monthlyVC.view removeFromSuperview];
        } else if (nIndex == 3) {
            [self.view bringSubviewToFront: _m_viewEvents];
            [self.view bringSubviewToFront: _m_viewToolbar];
            [_m_viewEvents setHidden: NO];
            
            [dailyVC.view removeFromSuperview];
            [weeklyVC.view removeFromSuperview];
            [_m_viewEvents addSubview: monthlyVC.view];
        }
    }
    
}

- (IBAction)onTouchBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)onTouchChangeGroupSettingsBtn:(id)sender {
    m_nPickerType = 0;
    
    [_m_pickerGroups reloadAllComponents];

    [self ShowDropdown];
}

- (IBAction)onTouchContactDetailBtn:(id)sender {
    m_nPickerType = 1;
    
    [_m_pickerGroups reloadAllComponents];

    [self ShowDropdown];
}

- (void) SaveFriendSettings {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    
    NSDictionary *dictSettings = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", _m_currentFriend.groupID], @"group_id", [NSString stringWithFormat:@"%d", _m_currentFriend.allow_request], @"allow_request", [NSString stringWithFormat:@"%d", _m_currentFriend.show_event_block], @"show_event_block", [NSString stringWithFormat:@"%d", _m_currentFriend.show_personal_as_available], @"show_personal_as_available", [NSString stringWithFormat:@"%d", _m_currentFriend.show_work_time], @"show_work_time", [NSString stringWithFormat:@"%d", _m_currentFriend.show_personal_time], @"show_personal_time", [NSString stringWithFormat:@"%d", _m_currentFriend.show_school_time], @"show_school_time", [NSString stringWithFormat:@"%d", _m_currentFriend.show_other_time], @"show_other_time", nil];
    
    NSString *strjSonSettings = [jsonWriter stringWithObject: dictSettings];
    
    [dataKeeper EditFriendSettings:_m_currentFriend.userID setting: strjSonSettings];
}

#pragma mark - Set Image to cell

- (void) refreshImage {
    [NSThread detachNewThreadSelector:@selector(getImage) toTarget:self withObject:nil];
}

- (void) getImage {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    UIImage *image = [dataKeeper getImage: [NSString stringWithFormat:@"%@%@", WEBAPI_URL, _m_currentFriend.profilePicture]];
    
    if (image != nil) {
        [_m_imgViewProfile setImage: image];
        
        [CUtils makeCircleImage: _m_imgViewProfile];
    }
    
    [autoreleasePool release];
}

#pragma mark - CustomSwitchDelegate
- (void) onValueChanged:(CustomSwitch *)switchCtrl {
    NSLog (@"%d", switchCtrl.m_bValue);
    
    if (switchCtrl == _switchRequest) {
        _m_currentFriend.allow_request = switchCtrl.m_bValue;
    }
    
    if (switchCtrl == _switchShowEvent) {
        _m_currentFriend.show_event_block = switchCtrl.m_bValue;
    }
    
    if (switchCtrl == _switchPersonalTime) {
        _m_currentFriend.show_personal_as_available = switchCtrl.m_bValue;
    }

    if (switchCtrl == _switchDetailWorkTime) {
        _m_currentFriend.show_work_time = switchCtrl.m_bValue;
    }
    
    if (switchCtrl == _switchDetailPersonTime) {
        _m_currentFriend.show_personal_time = switchCtrl.m_bValue;
    }
    
    if (switchCtrl == _switchDetailSchoolTime) {
        _m_currentFriend.show_school_time = switchCtrl.m_bValue;
    }
    
    if (switchCtrl == _switchDetailOtherTime) {
        _m_currentFriend.show_other_time = switchCtrl.m_bValue;
    }
    
    [self SaveFriendSettings];
    
  //  dataKeeper

}


#pragma mark - Picker Functions

/**
 ** Show Drop Down menu
 **/

- (void) ShowDropdown {
    
    if (_m_viewPicker.hidden == NO)
        return;
    
    [self.view bringSubviewToFront: _m_viewPicker];
    
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

    if (m_nPickerType == 0) {
        return [m_arrayGroups count];
    }
    
    return [m_arrayMenus count];
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
    
    if (m_nPickerType == 0) {
    
        GroupItem *groupItem = [m_arrayGroups objectAtIndex: nRow];
    
        return groupItem.name;
    }
    
    return [m_arrayMenus objectAtIndex: nRow];
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

#pragma mark - Loading Indicator Functions

- (void) ShowLoading {
    HUD.labelText = @"Loading";
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

#pragma mark - Get Friend Events

- (void) GetFriendEvents {
    // Show Loading for Initalize
    [self ShowLoading];
    
    [NSThread detachNewThreadSelector:@selector(GetFriendEventsThread) toTarget:self withObject:nil];
}

- (void) GetFriendEventsThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"GetFriendEventsThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSInteger nRet = [dataKeeper GetFriendEvents: _m_currentFriend.userID];
    
    if (nRet == 1) {
   //     [self performSelectorOnMainThread:@selector(refreshTable) withObject:nil waitUntilDone:YES];
        
    } else {
        //[self performSelectorOnMainThread:@selector(ShowLoginFailed) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    
    NSLog(@"GetFriendEventsThread: End!!!");
    [pool release];
}


@end
