//
//  SettingsViewController.m
//  Schedule
//
//  Created by TanLong on 10/30/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "SettingsViewController.h"
#import "ChangePasswordViewController.h"
#import "HRColorUtil.h"
#import "UIColor+expanded.h"
#import "SBJsonWriter.h"
#import "DBConnector.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
    
    [self refreshImage];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    settingItem = [[SettingItem alloc] initWithSettingItem: dataKeeper.m_mySettingInfo];
    
    [_m_textFirstName setText: settingItem.firstName];
    [_m_textLastName setText: settingItem.lastName];
    [_m_textPhone setText: settingItem.phonenumber];
    [_m_textAddress setText: settingItem.address];
    [_m_textBirthday setText: [CommonApi ConvertWithNewFormat:settingItem.birthdate oldFormat:DEFAULT_DATE_FORMAT newFormat:settingItem.dateformat]];
    [_m_textOccuapation setText: settingItem.occupation];
    [_m_textAboutme setText: settingItem.aboutme];
    
    NSInteger nStartWeek = [settingItem.startweek integerValue];
    
    m_nPickerType = 1;
    [_m_labelStartWeek setText: [self getRowString: nStartWeek forComponenet: 0]];
    
    NSInteger nHour = [settingItem.startday integerValue] % 12;
    
    BOOL bPM = ([settingItem.startday integerValue] < 12) ? NO: YES;
    
    if (nHour == 0) {
        nHour = 12;
    }
    
    [_m_labelStartDay setText: [NSString stringWithFormat:@"%02d:00 %@", nHour, bPM ? @"PM" : @"AM"]];
    
    [_m_labelDateFormat setText: [CommonApi ConvertWithNewFormat:@"2013-12-31" oldFormat:DEFAULT_DATE_FORMAT newFormat:settingItem.dateformat]];
    
    [_m_labelTimeFormat setText: [CommonApi ConvertWithNewFormat:@"13:00" oldFormat:DEFAULT_TIME_FORMAT newFormat:settingItem.timeformat]];
    
    [_m_viewWorkColor setBackgroundColor: [UIColor colorWithHexString: [settingItem.workColor substringFromIndex:1]]];
    [_m_viewSchoolColor setBackgroundColor: [UIColor colorWithHexString: [settingItem.schoolColor substringFromIndex: 1]]];
    [_m_viewPersonalColor setBackgroundColor: [UIColor colorWithHexString: [settingItem.personalColor substringFromIndex: 1]]];
    [_m_viewOtherColor setBackgroundColor: [UIColor colorWithHexString: [settingItem.otherColor substringFromIndex: 1]]];
        
    DBConnector *dbConn = [[DBConnector new] autorelease];
    
    m_arrayGroups = [dbConn getAllGroups];

    // Loading Indicator Initialize
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    [_m_tableViewGroup setEditing: YES];
    
    // Set Timer for current Date
    [self setLabel];
    [self createTimer];
}

- (void) RefreshViewSizes {
    [_m_tableViewGroup setFrame: CGRectMake(_m_tableViewGroup.frame.origin.x, _m_tableViewGroup.frame.origin.y, _m_tableViewGroup.frame.size.width, _m_tableViewGroup.contentSize.height)];
    
    [_m_scrollView setContentSize:CGSizeMake(_m_scrollView.frame.size.width, _m_tableViewGroup.frame.size.height + 603)];    
}

- (void) IncreaeContentSize {
    [_m_tableViewGroup setFrame: CGRectMake(_m_tableViewGroup.frame.origin.x, _m_tableViewGroup.frame.origin.y, _m_tableViewGroup.frame.size.width, _m_tableViewGroup.contentSize.height)];
    
    [_m_scrollView setContentSize:CGSizeMake(_m_scrollView.frame.size.width, _m_tableViewGroup.frame.size.height + 823)];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden: YES];
}

- (void) viewDidAppear:(BOOL)animated {
    [self RefreshViewSizes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_imgViewProfile release];
    
    [_m_viewWorkColor release];
    [_m_viewSchoolColor release];
    [_m_viewPersonalColor release];
    [_m_viewOtherColor release];
    
    if (settingItem != nil) {
        [settingItem release];
    }
    
    [m_arrayGroups release];
    
    [_m_viewPicker release];
    [_m_pickerView release];
    [_m_datePicker release];
    
    [_m_labelStartDay release];
    [_m_labelStartWeek release];
    [_m_labelDateFormat release];
    [_m_labelTimeFormat release];
    
    [_m_groupCell release];
    [_m_tableViewGroup release];
    
    [_m_scrollView release];
    
    [_m_textFirstName release];
    [_m_textLastName release];
    [_m_textPhone release];
    [_m_textAddress release];
    [_m_textOccuapation release];
    [_m_textAboutme release];
    [_m_textBirthday release];
    
    if (m_timer != nil) {
        [m_timer release];
    }
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    [super dealloc];
}


#pragma mark - Touch Actions

- (IBAction)onTouchBirthdayBtn:(id)sender {
    m_nPickerType = 4;
    [_m_pickerView reloadAllComponents];
    
    [self ShowDropdown];
}

- (IBAction)onTouchNavBackBtn:(id)sender {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)onTouchNavSaveBtn:(id)sender {
  //  DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
  //  [dataKeeper setM_mySettingInfo: settingItem];
    
    [self SaveSetting];
    
    //[self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)onTouchWorkColorBtn:(id)sender {
    currentColorView = _m_viewWorkColor;
    
    [self gotoSelectColor];
}

- (IBAction)onTouchSchoolColorBtn:(id)sender {
    currentColorView = _m_viewSchoolColor;
    
    [self gotoSelectColor];
}

- (IBAction)onTouchPersonalColorBtn:(id)sender {
    currentColorView = _m_viewPersonalColor;
    
    [self gotoSelectColor];
}

- (IBAction)onTouchOtherColorBtn:(id)sender {
    currentColorView = _m_viewOtherColor;
    
    [self gotoSelectColor];
}

- (IBAction)onTouchOkBtn:(id)sender {
    if (m_nPickerType == 0) {
       // NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
       // [formatter setDateFormat:@"hh:00 a"];
        
      //  [_m_labelStartDay setText: [formatter stringFromDate:_m_datePicker.date]];
        
        [_m_labelStartDay setText: [NSString stringWithFormat:@"%02d:00 %@", [_m_pickerView selectedRowInComponent: 0] + 1, [self getRowString: [_m_pickerView selectedRowInComponent: 1] forComponenet: 1]]];
        
        NSInteger nHour = ([_m_pickerView selectedRowInComponent: 0] + 1 + [_m_pickerView selectedRowInComponent: 1] * 12) % 24;
        
       // [formatter setDateFormat:@"HH"];
        
        
        
      //  settingItem.startday = [formatter stringFromDate:_m_datePicker.date];
        settingItem.startday = [NSString stringWithFormat:@"%02d", nHour];
        
       // [formatter release];
    } else if (m_nPickerType == 1) {
        settingItem.startweek = [NSString stringWithFormat:@"%d", [_m_pickerView selectedRowInComponent:0]];
        [_m_labelStartWeek setText: [self getRowString: [_m_pickerView selectedRowInComponent: 0] forComponenet: 0]];
    } else if (m_nPickerType == 2) {
        settingItem.dateformat = [self getDateFormat: [_m_pickerView selectedRowInComponent: 0]];
        [_m_labelDateFormat setText: [self getRowString: [_m_pickerView selectedRowInComponent: 0] forComponenet: 0]];
        
        [_m_textBirthday setText:[CommonApi ConvertWithNewFormat:settingItem.birthdate oldFormat:DEFAULT_DATE_FORMAT newFormat:settingItem.dateformat]];
        
        
    } else if (m_nPickerType == 3) {
        settingItem.timeformat = [self getTimeFormat: [_m_pickerView selectedRowInComponent: 0]];
        [_m_labelTimeFormat setText: [self getRowString: [_m_pickerView selectedRowInComponent: 0] forComponenet: 0]];
        
    } else if (m_nPickerType == 4) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:settingItem.dateformat];
        
        [_m_textBirthday setText: [formatter stringFromDate:_m_datePicker.date]];
        
        [formatter setDateFormat:DEFAULT_DATE_FORMAT];
        
        settingItem.birthdate = [formatter stringFromDate:_m_datePicker.date];
        
        [formatter release];
    }
    
    [self HideDropdown];

}

- (IBAction)onTouchCancelBtn:(id)sender {
    [self HideDropdown];

}

- (IBAction)onTouchStartDay:(id)sender {
    m_nPickerType = 0;
    [_m_pickerView reloadAllComponents];
    
    [self ShowDropdown];
}

- (IBAction)onTouchStartWeek:(id)sender {
    m_nPickerType = 1;
    [_m_pickerView reloadAllComponents];
    
    [self ShowDropdown];
}

- (IBAction)onTouchDateFormat:(id)sender {
    m_nPickerType = 2;
    [_m_pickerView reloadAllComponents];
    
    [self ShowDropdown];
}

- (IBAction)onTouchTimeFormat:(id)sender {
    m_nPickerType = 3;
    [_m_pickerView reloadAllComponents];
    
    [self ShowDropdown];
}

- (void)PopupInputGroupName {
    
    overlay = [[UIXOverlayController alloc] init];
    overlay.dismissUponTouchMask = NO;
    overlay.overlayDelegate = self;
    
    DialogContentViewController* vc = [[[DialogContentViewController alloc] init] autorelease];
    
    vc.delegate = self;
    
    [overlay presentOverlayOnView:self.view withContent:vc animated: YES];
}


- (IBAction)onTouchAddBtn:(id)sender {
    [self PopupInputGroupName];
}

- (IBAction)onTouchBackgroundBtn:(id)sender {
    [self DismissKeyboard];
    
    [self RefreshViewSizes];
    
    [_m_scrollView setContentOffset: CGPointMake(0, 0) animated: YES];

}

- (IBAction)onTouchChangePassword:(id)sender {
    ChangePasswordViewController *changePasswordVC = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle: nil];
    
    [changePasswordVC setM_settingItem: settingItem];
    
    [self.navigationController pushViewController: changePasswordVC animated: YES];
    
    [changePasswordVC release];
}

- (void) gotoSelectColor {
    HRColorPickerViewController* controller;
    
    controller = [HRColorPickerViewController cancelableColorPickerViewControllerWithColor:[currentColorView backgroundColor]];
    
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];

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

#pragma mark - Hayashi311ColorPickerDelegate

- (void)setSelectedColor:(UIColor *)color{
    [currentColorView setBackgroundColor:color];
    
    if (currentColorView == _m_viewWorkColor) {
        settingItem.workColor = [NSString stringWithFormat:@"#%06x", HexColorFromUIColor(color)];
    } else if (currentColorView == _m_viewSchoolColor) {
        settingItem.schoolColor = [NSString stringWithFormat:@"#%06x", HexColorFromUIColor(color)];
    } else if (currentColorView == _m_viewPersonalColor) {
        settingItem.personalColor = [NSString stringWithFormat:@"#%06x", HexColorFromUIColor(color)];
    } else if (currentColorView == _m_viewOtherColor) {
        settingItem.otherColor = [NSString stringWithFormat:@"#%06x", HexColorFromUIColor(color)];
    }
    
//    [hexColorLabel setText:[NSString stringWithFormat:@"#%06x",HexColorFromUIColor(color)]];
}

#pragma mark - Loading Indicator Functions

- (void) ShowLoading {
    HUD.labelText = @"Loading";
    [HUD showUsingAnimation: YES];
}

- (void) ShowSaving {
    HUD.labelText = @"Saving...";
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

- (void) SaveSetting {
    // Show Loading for Initalize
    [self ShowSaving];
    
    settingItem.firstName = _m_textFirstName.text;
    settingItem.lastName = _m_textLastName.text;
    settingItem.phonenumber = _m_textPhone.text;
    settingItem.address = _m_textAddress.text;
    settingItem.occupation = _m_textOccuapation.text;
    settingItem.aboutme = _m_textAboutme.text;
    
    [NSThread detachNewThreadSelector:@selector(SaveSettingThread) toTarget:self withObject:nil];
}

- (void) SaveSettingThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"SaveSettingThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    SBJsonWriter *jsonWriter = [[[SBJsonWriter alloc] init] autorelease];
    
    NSDictionary *dictColors = [NSDictionary dictionaryWithObjectsAndKeys:settingItem.workColor, @"Work", settingItem.schoolColor, @"School", settingItem.personalColor, @"Personal", settingItem.otherColor, @"Other", nil];
    
    NSString *strjSonColors = [jsonWriter stringWithObject: dictColors];
    
    NSMutableArray *newGroups = [NSMutableArray new];
    NSMutableArray *removedGroups = [NSMutableArray new];
    
    DBConnector *dbConn = [[DBConnector new] autorelease];
    
    NSMutableArray *originalGroups = [dbConn getAllGroups];

    for (NSInteger nIndex = 0; nIndex < [m_arrayGroups count]; nIndex++) {
        GroupItem *groupItem = [m_arrayGroups objectAtIndex: nIndex];
        
        if ([groupItem.groupID isEqualToString:@""]) {
            [newGroups addObject: [NSDictionary dictionaryWithObject:groupItem.name forKey:@"group_name"]];
        }
    }
    
    for (NSInteger nIndex = 0; nIndex < [originalGroups count]; nIndex++) {
        GroupItem *groupItem = [originalGroups objectAtIndex: nIndex];
        BOOL bRemoved = YES;
        
        for (NSInteger nIndexCurrent = 0; nIndexCurrent < [m_arrayGroups count]; nIndexCurrent++) {
            
            GroupItem *checkGroupItem = [m_arrayGroups objectAtIndex: nIndexCurrent];
            
            if ([groupItem.groupID isEqualToString:checkGroupItem.groupID]) {
                bRemoved = NO;
                break;
            }

        }
        
        if (bRemoved) {
            [removedGroups addObject: [NSDictionary dictionaryWithObject:groupItem.groupID forKey:@"group_id"]];

        }
    }
    
    NSDictionary *dictGroupSettings = [NSDictionary dictionaryWithObjectsAndKeys:newGroups, @"new_groups", removedGroups, @"delete_groups", nil];
    
    NSString *strGroupSettings = [jsonWriter stringWithObject: dictGroupSettings];
    
    NSLog(@"Group Settings = %@", strGroupSettings);
    
 //   NSString *strTestGroupSettings = @"{\"new_groups\":[{\"group_name\":\"NewName\"},{\"group_name\":\"NewName2\"}],\"delete_groups\":[{\"group_id\":\"1\"},{\"group_id\":\"2\"}]}";
    
    NSInteger nRet = [dataKeeper UpdateSettings:settingItem.firstName lastname:settingItem.lastName phone:settingItem.phonenumber address:settingItem.address occupation:settingItem.occupation aboutme:settingItem.aboutme birthdate:settingItem.birthdate eventcolor:strjSonColors timepreference:[NSString stringWithFormat:@"{\"start_of_the_day\":\"%@\",\"start_of_the_week\":\"%@\",\"date_format\":\"%@\",\"time_format\":\"%@\"}", settingItem.startday, settingItem.startweek, settingItem.dateformat, settingItem.timeformat] groupsettings:strGroupSettings];
    
    if (nRet == 1) {
        [self performSelectorOnMainThread:@selector(GotoMainScreen) withObject:nil waitUntilDone:YES];
        
    } else {
        //[self performSelectorOnMainThread:@selector(ShowLoginFailed) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    
    NSLog(@"SaveSettingThread: End!!!");
    [pool release];
}

- (void) GotoMainScreen {
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Picker Functions

/**
 ** Show Drop Down menu
 **/

- (void) ShowDropdown {
    
    if (_m_viewPicker.hidden == NO)
        return;
    
    /*if (m_nPickerType == 0) {
        [_m_datePicker setHidden: NO];
        [_m_pickerView setHidden: YES];
        
        [_m_datePicker setDatePickerMode: UIDatePickerModeTime];
    }  else */
    if (m_nPickerType == 4) {
        [_m_datePicker setHidden: NO];
        [_m_pickerView setHidden: YES];
        
        [_m_datePicker setDatePickerMode: UIDatePickerModeDate];
    } else {
        [_m_datePicker setHidden: YES];
        [_m_pickerView setHidden: NO];
        
    }
    
    //   m_coverView.hidden = NO;
    
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
    
 //   DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    if (m_nPickerType == 0) {
        if (component == 0) {
            return 12;
        } else {
            return 2;
        }
    } else if (m_nPickerType == 1) {
        return 2;
    } else if (m_nPickerType == 2) {
        return 2;
    } else if (m_nPickerType == 3) {
        return 2;
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (m_nPickerType == 0) {
        return 2;
    }
    
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self getRowString: row forComponenet: component];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

- (NSString *) getRowString: (NSInteger) nRow forComponenet: (NSInteger) component {
//    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    if (m_nPickerType == 0) {
        
        if (component == 0) {
            return [NSString stringWithFormat:@"%d", nRow + 1];
        } else {
            NSArray *arrayAMPM = [NSArray arrayWithObjects:@"AM", @"PM", nil];
            
            return [arrayAMPM objectAtIndex: nRow];
        }
    } else if (m_nPickerType == 1) {
        
        NSArray *arrayWeeks = [NSArray arrayWithObjects:@"Monday", @"Sunday", nil];
        
        return [arrayWeeks objectAtIndex: nRow];
        
    } else if (m_nPickerType == 2) {
        
        NSArray *arrayDateFormats = [NSArray arrayWithObjects:@"Dec 31, 2013", @"2013-12-31", nil];
        
        return [arrayDateFormats objectAtIndex: nRow];
        
    } else if (m_nPickerType == 3) {
        
        NSArray *arrayTimeFormats = [NSArray arrayWithObjects:@"1:00 PM", @"13:00", nil];
        
        return [arrayTimeFormats objectAtIndex: nRow];
    }
    
    return @"";
    
}

- (NSString *) getDateFormat: (NSInteger) nRow {
    //    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    NSArray *arrayDateFormats = [NSArray arrayWithObjects:@"MMM d, yyyy", @"yyyy-MM-dd", nil];
    
    return [arrayDateFormats objectAtIndex: nRow];
}

- (NSString *) getTimeFormat: (NSInteger) nRow {
    //    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    NSArray *arrayTimeFormats = [NSArray arrayWithObjects:@"h:mm a", @"H:mm", nil];
    
    return [arrayTimeFormats objectAtIndex: nRow];

}


#pragma mark - UITableViewDelegate

// Set the height of each cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

// Set Cell Count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [m_arrayGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSBundle mainBundle] loadNibNamed:@"GroupCell" owner:self options:nil];
    
    GroupItem *item = [m_arrayGroups objectAtIndex: indexPath.row];
    
    [_m_groupCell.m_labelGroupName setText: item.name];
    
    return _m_groupCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [m_arrayGroups removeObjectAtIndex: indexPath.row];
    
    [_m_tableViewGroup reloadData];
    [self RefreshViewSizes];

}

#pragma mark - General Functions

- (void) DismissKeyboard {
    [_m_textFirstName resignFirstResponder];
    [_m_textLastName resignFirstResponder];
    [_m_textPhone resignFirstResponder];
    [_m_textAddress resignFirstResponder];
    [_m_textOccuapation resignFirstResponder];
    [_m_textBirthday resignFirstResponder];
    [_m_textAboutme resignFirstResponder];
    
}

#pragma mark - UITextField Delegate Methods

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    [self IncreaeContentSize];
    
    
    if (textField == _m_textAddress) {
        [_m_scrollView setContentOffset: CGPointMake(0, 80) animated: YES];
        
    } else if (textField == _m_textOccuapation) {
        [_m_scrollView setContentOffset: CGPointMake(0, 110) animated: YES];
        
    } else if (textField == _m_textAboutme) {
        [_m_scrollView setContentOffset: CGPointMake(0, 170) animated: YES];
    }
    
    
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self RefreshViewSizes];
    
    [_m_scrollView setContentOffset: CGPointMake(0, 0) animated: YES];
    
    return YES;
}

#pragma mark - UIXOverlayControllerDelegate

- (void) overlayRemoved:(UIXOverlayController*) overlayController
{
    [overlay release];
    overlay = nil;
}

#pragma mark - DialogContentViewControllerDelegate

- (void) onYesPressed: (NSString *) strGroupName {
    
    GroupItem *groupItem = [[GroupItem alloc] init];
    
    groupItem.name = strGroupName;
    
    [m_arrayGroups addObject: groupItem];
    
    [groupItem release];
    
    [_m_tableViewGroup reloadData];
    [self RefreshViewSizes];
}

#pragma mark - Date/Time Functions
- (void) createTimer {
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setLabel) userInfo:nil repeats: YES];
}

- (void)setLabel {
    NSDate * toDay = [NSDate date];
    NSDateFormatter * dateformatter = [[NSDateFormatter new] autorelease];
    
    [dateformatter setDateFormat:settingItem.dateformat];
    NSString * dateString = [dateformatter stringFromDate:toDay];
    dateformatter.dateFormat = @"EEE";
    
    NSString * dayString = [[dateformatter stringFromDate:toDay] capitalizedString];
    [_m_labelCurrentDate setText:[NSString stringWithFormat:@"%@, %@", dayString, dateString]];
    
    
    dateformatter.dateFormat = settingItem.timeformat;
    NSString * timeString = [dateformatter stringFromDate:toDay];
    [_m_labelCurrentTime setText:timeString];
    
    //   NSLog(@"---- setLabel -----");
}


@end
