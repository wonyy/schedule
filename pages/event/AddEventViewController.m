//
//  AddEventViewController.m
//  Schedule
//
//  Created by suhae on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "AddEventViewController.h"
#import "EventKitManager.h"
#import "DBConnector.h"
#import <EventKit/EventKit.h>

@interface AddEventViewController ()

@end

@implementation AddEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_information = [ScheduleItem new];
        title = @"Add Event";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tblView.delegate = self;
    _tblView.dataSource = self;
    [_tblView reloadData];
    [_lblTitle setText:title];
    
    if (_m_initDate != nil) {
        m_information.eventStartDay = _m_initDate;
        m_information.eventEndDay = _m_initDate;
        
    }
    
    [self refreshImage];
    
    // Loading Indicator Initialize
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    // Set Timer for current Date
    [self setLabel];
    [self createTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tblView release];
    [_lblTitle release];
    [_m_imgViewProfile release];
    [_m_EmptyCell release];
    [_m_TextInputCell release];
    [_m_DateCell release];
    [_m_CheckCell release];
    [_m_ChooseCell release];
    [_m_NoteCell release];
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    
    if (m_timer != nil) {
        [m_timer release];
    }
    [_m_DeleteCell release];
    [super dealloc];
}


- (void)initItem:(ScheduleItem*)item {
    title = @"Edit Event";
    m_bEdit = YES;
    m_information = item;
}

//----------------tableview delegate start-------------------------//

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (m_bEdit == YES) {
        return 15;
    }
    // Return the number of rows in the section.
    return 14;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 2 || indexPath.row == 6) {
        
        [[NSBundle mainBundle] loadNibNamed:@"EmptyCell" owner:self options:nil];
        
        
        return _m_EmptyCell;
        
    } else if (indexPath.row == 0) {
        
        [[NSBundle mainBundle] loadNibNamed:@"TextInputCell" owner:self options:nil];
        
        _m_TextInputCell.m_textField.placeholder = @"Title";
        _m_TextInputCell.m_textField.text = m_information.eventName;
        _m_TextInputCell.m_textField.returnKeyType = UIReturnKeyDone;
        _m_TextInputCell.m_textField.textColor = [UIColor blackColor];
        _m_TextInputCell.m_textField.backgroundColor = [UIColor whiteColor];
        _m_TextInputCell.m_textField.delegate = self;

        return _m_TextInputCell;

    } else if (indexPath.row == 1) {
        
        [[NSBundle mainBundle] loadNibNamed:@"ChooseCell" owner:self options:nil];
        
        [_m_ChooseCell.m_labelName setText: @"Location"];
        [_m_ChooseCell.m_labelValue setText: [NSString stringWithFormat:@"%@", m_information.eventLocation]];
        
        return _m_ChooseCell;

        
    } else if (indexPath.row == 3) {
    
        [[NSBundle mainBundle] loadNibNamed:@"CheckCell" owner:self options:nil];
        
        if (_m_CheckCell.switchCtrl == nil) {
            _m_CheckCell.switchCtrl = [[CustomSwitch alloc] initWithFrame:CGRectMake(250, 10, 43, 24)];
            _m_CheckCell.switchCtrl.delegate = self;
            [_m_CheckCell.switchCtrl setValue: m_bAllDay withUI: NO];
            [_m_CheckCell addSubview: _m_CheckCell.switchCtrl];
        }

        return _m_CheckCell;

    } else if (indexPath.row == 4) {
        
        [[NSBundle mainBundle] loadNibNamed:@"DateTimeCell" owner:self options:nil];
        
        [_m_DateCell.m_labelTitle setText:@"Starts"];
        
        NSDate *stDate;
        
        if (m_bEdit == YES || _m_initDate == nil) {
            stDate = [CommonApi getDateTimeFromString: m_information.eventStartDay];
        } else {
            stDate = [CommonApi getDateTimeFromStringWithCurrentTimeZone: m_information.eventStartDay];

        }
        
        [_m_DateCell.m_labelDate setText: [CommonApi getDateTime: stDate]];
        
        return _m_DateCell;
        
    } else if (indexPath.row == 5) {
        
        [[NSBundle mainBundle] loadNibNamed:@"DateTimeCell" owner:self options:nil];
        
        [_m_DateCell.m_labelTitle setText:@"Ends"];
        
        NSDate *enDate;
        
        if (m_bEdit == YES || _m_initDate == nil) {
            enDate = [CommonApi getDateTimeFromString: m_information.eventEndDay];
        } else {
            enDate = [CommonApi getDateTimeFromStringWithCurrentTimeZone: m_information.eventEndDay];
            
        }

        [_m_DateCell.m_labelDate setText: [CommonApi getDateTime: enDate]];
        
        return _m_DateCell;
        
    } else if (indexPath.row == 7) {
        [[NSBundle mainBundle] loadNibNamed:@"ChooseCell" owner:self options:nil];
        
        [_m_ChooseCell.m_labelName setText: @"Availability"];
        [_m_ChooseCell.m_labelValue setText: [NSString stringWithFormat:@"%@ >", m_information.eventAvailability]];
        
        return _m_ChooseCell;
        //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 8) {
        [[NSBundle mainBundle] loadNibNamed:@"ChooseCell" owner:self options:nil];
        
        [_m_ChooseCell.m_labelName setText: @"Repeat"];
        
        if (m_information.eventRecurring == nil || [m_information.eventRecurring length] <= 0) {
            m_information.eventRecurring = @"None";
        }
        
        [_m_ChooseCell.m_labelValue setText: [NSString stringWithFormat:@"%@ >", m_information.eventRecurring]];
        
        return _m_ChooseCell;
     //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }  else if (indexPath.row == 9) {
        [[NSBundle mainBundle] loadNibNamed:@"ChooseCell" owner:self options:nil];
        
        [_m_ChooseCell.m_labelName setText: @"End Repeat"];
        
        if ([m_information.eventRecurring isEqualToString:@""] || [m_information.eventRecurring isEqualToString:@"None"]) {
            [_m_ChooseCell setEnable: NO];
            [_m_ChooseCell.m_labelValue setText:@""];
        } else {
            [_m_ChooseCell setEnable: YES];
            if (m_information.eventRecurringEndDay == nil || [m_information.eventRecurringEndDay isEqualToString:@""]) {
                m_information.eventRecurringEndDay = @"Never";
            }
            
            [_m_ChooseCell.m_labelValue setText:[NSString stringWithFormat:@"%@ >", m_information.eventRecurringEndDay]];
        }
        
//        [_m_ChooseCell.m_labelValue setText: [NSString stringWithFormat:@"%@ >", m_information.eventRecurring]];
        
        return _m_ChooseCell;
        //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 10) {
        [[NSBundle mainBundle] loadNibNamed:@"ChooseCell" owner:self options:nil];
        
        [_m_ChooseCell.m_labelName setText: @"Event Type"];
        [_m_ChooseCell.m_labelValue setText: [NSString stringWithFormat:@"%@ >", m_information.eventType]];
        
        return _m_ChooseCell;

    } else if (indexPath.row == 11) {
        [[NSBundle mainBundle] loadNibNamed:@"ChooseCell" owner:self options:nil];
        
        [_m_ChooseCell.m_labelName setText: @"Reminder"];
        
        NSString *strEventReminder = @"";
        
        if ([m_information.eventReminder isEqualToString:@""]) {
            strEventReminder = @"None";
        } else {
        
            NSArray *arrayInterval = [m_information.eventReminder componentsSeparatedByString:@"#"];
            
            if ([[arrayInterval objectAtIndex: 0] isEqualToString: @"0"]) {
                strEventReminder = @"At time of event";
            } else if ([[arrayInterval objectAtIndex: 1] isEqualToString:@"min"]) {
                strEventReminder = [NSString stringWithFormat:@"%@ minute%@ before",[arrayInterval objectAtIndex: 0], ([[arrayInterval objectAtIndex: 0] integerValue] > 1) ? @"s" : @""];

            } else if ([[arrayInterval objectAtIndex: 1] isEqualToString:@"hour"]) {
                strEventReminder = [NSString stringWithFormat:@"%@ hour%@ before", [arrayInterval objectAtIndex: 0], ([[arrayInterval objectAtIndex: 0] integerValue] > 1) ? @"s" : @""];
            } else if ([[arrayInterval objectAtIndex: 1] isEqualToString:@"day"]) {
                strEventReminder = [NSString stringWithFormat:@"%@ day%@ before", [arrayInterval objectAtIndex: 0], ([[arrayInterval objectAtIndex: 0] integerValue] > 1) ? @"s" : @""];
            } else {
                strEventReminder = @"Invalid data";
            }
            
        }
        
        [_m_ChooseCell.m_labelValue setText: [NSString stringWithFormat:@"%@ >", strEventReminder]];

        
        return _m_ChooseCell;
        
    } else if (indexPath.row == 12) {
        [[NSBundle mainBundle] loadNibNamed:@"ChooseCell" owner:self options:nil];
        
        [_m_ChooseCell.m_labelName setText: @"Guests"];
        [_m_ChooseCell.m_labelValue setText: [NSString stringWithFormat:@">"]];
        
        NSInteger nGuestCount = [m_information.arrayGuests count];
        
        if (nGuestCount == 0) {
            [_m_ChooseCell.m_imgViewGuest1 setHidden: YES];
            [_m_ChooseCell.m_imgViewGuest2 setHidden: YES];
        } else if (nGuestCount == 1) {
            [_m_ChooseCell.m_imgViewGuest2 setHidden: NO];
            [_m_ChooseCell.m_imgViewGuest1 setHidden: YES];
            
            NSDictionary *friendItem2 = [m_information.arrayGuests objectAtIndex: 0];
            _m_ChooseCell.m_strImgURL2 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem2 objectForKey:@"profile_picture"]];
            [_m_ChooseCell refreshImage2];
            
        } else if (nGuestCount == 2) {
            [_m_ChooseCell.m_imgViewGuest2 setHidden: NO];
            [_m_ChooseCell.m_imgViewGuest1 setHidden: NO];
            
            NSDictionary *friendItem2 = [m_information.arrayGuests objectAtIndex: 0];
            _m_ChooseCell.m_strImgURL2 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem2 objectForKey:@"profile_picture"]];
            [_m_ChooseCell refreshImage2];
            
            NSDictionary *friendItem1 = [m_information.arrayGuests objectAtIndex: 1];
            _m_ChooseCell.m_strImgURL1 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem1 objectForKey:@"profile_picture"]];
            [_m_ChooseCell refreshImage1];
        } else {
            [_m_ChooseCell.m_imgViewGuest2 setHidden: NO];
            [_m_ChooseCell.m_imgViewGuest1 setHidden: NO];
            
            NSDictionary *friendItem2 = [m_information.arrayGuests objectAtIndex: 0];
            _m_ChooseCell.m_strImgURL2 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem2 objectForKey:@"profile_picture"]];
            [_m_ChooseCell refreshImage2];
            
            NSDictionary *friendItem1 = [m_information.arrayGuests objectAtIndex: 1];
            _m_ChooseCell.m_strImgURL1 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem1 objectForKey:@"profile_picture"]];
            [_m_ChooseCell refreshImage1];
        }
        
        return _m_ChooseCell;
    } else if (indexPath.row == 13) {
        [[NSBundle mainBundle] loadNibNamed:@"NoteCell" owner:self options:nil];
        
        [_m_NoteCell.m_textViewNote setText: m_information.eventDescription];
        [_m_NoteCell.m_textViewNote setDelegate: self];
        [_m_NoteCell AddPlaceHolder: @"Description"];
        
        return _m_NoteCell;
    } else if (indexPath.row == 14) {
        [[NSBundle mainBundle] loadNibNamed:@"DeleteCell" owner:self options:nil];
        
        return _m_DeleteCell;
    }
    
    return nil;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 13) {
        return 100;
    } else if (indexPath.row == 14) {
        return 50;
    }
    
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2 || indexPath.row == 6) {
            
                
        } else if (indexPath.row == 1) {
            CSearchAddressViewController *searchAddressVC = [[CSearchAddressViewController alloc] initWithNibName:@"CSearchAddressViewController" bundle: nil];
            
            searchAddressVC.delegate = self;
            [self.navigationController pushViewController: searchAddressVC animated: YES];
            
            [searchAddressVC release];
        } else if (indexPath.row == 3) {
          
        } else if (indexPath.row == 4 || indexPath.row == 5) {
            
            StartEndDateViewController * controller = [[StartEndDateViewController alloc] initWithNibName:@"StartEndDateViewController" bundle:nil];
            
            [controller SetDates:[CommonApi getDateTimeFromString: m_information.eventStartDay] end:[CommonApi getDateTimeFromString: m_information.eventEndDay]];

            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];

        } else if (indexPath.row == 7) {
            
            AvailabilityViewController * controller = [[AvailabilityViewController alloc]initWithNibName:@"AvailabilityViewController" bundle:nil];
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];

        } else if (indexPath.row == 8) {
            
            RecurrenceViewController * controller = [[RecurrenceViewController alloc]initWithNibName:@"RecurrenceViewController" bundle:nil];
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];

        } else if (indexPath.row == 9) {
            
            RecurringEndDateViewController * controller = [[RecurringEndDateViewController alloc]initWithNibName:@"RecurringEndDateViewController" bundle:nil];
            controller.delegate = self;
            
            if ([m_information.eventRecurringEndDay isEqualToString:@"Never"] == NO) {
                [controller SetEDate: [CommonApi getDateFromString: m_information.eventRecurringEndDay]];
            }
            
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            
        } else if (indexPath.row == 10) {
            
            EventTypeViewController *controller = [[EventTypeViewController alloc] initWithNibName:@"EventTypeViewController" bundle: nil];
            
            controller.delegate = self;
            [self.navigationController pushViewController: controller animated: YES];
            [controller release];
            
        } else if (indexPath.row == 11) {
            
            ReminderViewController * controller = [[ReminderViewController alloc]initWithNibName:@"ReminderViewController" bundle:nil];
            controller.delegate = self;
            [controller setM_strInitReminder: m_information.eventReminder];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];

        } else if (indexPath.row == 12) {
            
            InviteGuestViewController * controller = [[InviteGuestViewController alloc]initWithNibName:@"InviteGuestViewController" bundle:nil];
            controller.delegate = self;
            [controller setM_aryInitialFriends: m_information.arrayGuests];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
            
        }
    }
}

- (void)ColorEdited:(int)color {
    /*
    m_information.eventColor = [NSString stringWithFormat:@"%d", color];
    NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:6];
    //[[_tblView cellForRowAtIndexPath:path].contentView setBackgroundColor:[CommonApi getColorFromIndex:color]];
    [[_tblView cellForRowAtIndexPath:path].textLabel setTextColor:[CommonApi getColorFromIndex:color]];
     */
}

- (void)NoteEdited:(NSString *)notes {
    /*
    m_information.eventNote = notes;
    NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:8];
    [[_tblView cellForRowAtIndexPath:path].textLabel setText:notes];
    [_tblView reloadData];
     */
}

#pragma mark - AvailabilityViewControllerDelegate

- (void)AvailabilityEdited:(NSString *)avail {
    m_information.eventAvailability = avail;
    [_tblView reloadData];
}

- (void)EventTypeEdited:(NSString *)eventtype {
    m_information.eventType = eventtype;
    [_tblView reloadData];
}

#pragma mark - RecurrenceViewControllerDelegate

- (void)RecurrenceEdited:(NSString*)repeats {
    
    m_information.eventRecurring = repeats;
    
    [_tblView reloadData];
     
}

#pragma mark - RecurringEndDateViewControllerDelegate

- (void)EndDateEdited:(NSString*) endDate {
    m_information.eventRecurringEndDay = endDate;
    
    [_tblView reloadData];
}

#pragma mark - ReminderViewControllerDelegate

- (void)ReminderEdited:(NSString *)interval {
    m_information.eventReminder = interval;
    [_tblView reloadData];
}

- (void)AddressSelected {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    m_information.eventLocation = dataKeeper.m_curLocation;
    m_information.eventLatitude = dataKeeper.m_curLatitude;
    m_information.eventLongitude = dataKeeper.m_curLongitude;
    
    [_tblView reloadData];
}

//- (void)EventnameEdited:(NSString *)name
//{
//    m_information.eventName = name;
//    NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:0];
//    [[_tblView cellForRowAtIndexPath:path].textLabel setText:name];
//}
//- (void)EventlocationEdited:(NSString *)name
//{
//    m_information.eventLocation = name;
//    NSIndexPath * path = [NSIndexPath indexPathForRow:1 inSection:0];
//    [[_tblView cellForRowAtIndexPath:path].textLabel setText:name];
//}
- (void)onChangeAlldayMode {
    
    BOOL res = [m_autoCheck isOn];
    
    if (res){
        m_information.eventIsAllDay = @"YES";
    } else {
        m_information.eventIsAllDay = @"NO";
    }
}

- (void)StartEndDateEdited:(NSDate *)sDate :(NSDate *)eDate {
    
    if (m_bAllDay) {
        NSArray *dateArrays = [CommonApi getDateStringStartAndEndTime: sDate endDate:eDate];
        
        m_information.eventStartDay = [dateArrays objectAtIndex: 0];
        m_information.eventEndDay = [dateArrays objectAtIndex: 1];
        
    } else {
        
        NSString * sDateString = [CommonApi getStringFromDateTime:sDate];
        NSString * eDateString = [CommonApi getStringFromDateTime:eDate];
        
        m_information.eventStartDay = sDateString;
        m_information.eventEndDay = eDateString;
    }
    
    _m_initDate = nil;
    
    [_tblView reloadData];
}


- (void)InvitedGuest:(NSArray *)selectedGuest {
    [m_information.arrayGuests removeAllObjects];
    
    for (NSInteger nIndex = 0; nIndex < [selectedGuest count]; nIndex++) {
        FriendItem *newFriend = [selectedGuest objectAtIndex: nIndex];
        
        NSDictionary *dictItem = [NSDictionary dictionaryWithObjectsAndKeys:newFriend.userID, @"user_id", newFriend.fullName, @"full_name", newFriend.profilePicture, @"profile_picture", nil];
        
        [m_information.arrayGuests addObject: dictItem];
    }
    
    [_tblView reloadData];

}

//----------------tableview delegate end-------------------------//


#pragma mark - Touch Actions

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSave:(id)sender {
    
    /*
    if (m_information.eventId > 0)
        [[[DBConnector alloc] init] updateEvent:m_information];
    else
        [[[DBConnector alloc] init] insertEvent:m_information];
     */
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    [self Save];
}

- (IBAction)onDeleteEventBtn:(id)sender {
    [self DeleteEvent];
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
    HUD.labelText = @"Saving...";
    [HUD showUsingAnimation: YES];
}

- (void) ShowDeleting {
    HUD.labelText = @"Deleting...";
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

- (void) DeleteEvent {
    // Show Loading for Initalize
    [self DismissKeyboard];
    [self ShowDeleting];
    
    [NSThread detachNewThreadSelector:@selector(DeleteEventThread) toTarget:self withObject:nil];
}

- (void) DeleteEventThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"DeleteEventThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSInteger nRet = [dataKeeper DeleteEvent: [NSString stringWithFormat:@"%d", m_information.eventId]];
    
    if (nRet == 1) {
        if ([m_information.iCalEventId isEqualToString:@""]) {
            
        } else {
            EventKitManager *eventKitManager = [EventKitManager sharedInstance];
            
            EKEvent *ekEvent;
            ekEvent = [eventKitManager.eventStore eventWithIdentifier: m_information.iCalEventId];
            
            [eventKitManager.eventStore removeEvent:ekEvent span:EKSpanFutureEvents commit:YES error:nil];
        }

        [self performSelectorOnMainThread:@selector(DeleteSuccess) withObject:nil waitUntilDone:YES];
    } else {
        
        //[dbConn makeEventOnline: m_information online: NO];
        [self performSelectorOnMainThread:@selector(FailedDelete) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    NSLog(@"DeleteEventThread: End!!!");
    [pool release];
}

- (void) Save {
    // Show Loading for Initalize
    [self DismissKeyboard];
    [self ShowSaving];
    
    [NSThread detachNewThreadSelector:@selector(SaveThread) toTarget:self withObject:nil];
}

- (void) SaveThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"SaveThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    EventKitManager *eventKitManager = [EventKitManager sharedInstance];
    
    EKEvent *ekEvent;
    
    
    if ([m_information.iCalEventId isEqualToString:@""]) {
        ekEvent = [EKEvent eventWithEventStore: eventKitManager.eventStore];
    } else {
        ekEvent = [eventKitManager.eventStore eventWithIdentifier: m_information.iCalEventId];
    }
    
    ekEvent.title = m_information.eventName;
    
    if ([m_information.eventAvailability isEqualToString:@"free"]) {
        ekEvent.availability = EKEventAvailabilityFree;
    } else {
        ekEvent.availability = EKEventAvailabilityBusy;
    }
  
    ekEvent.startDate = [CommonApi getDateTimeFromString: m_information.eventStartDay];
    ekEvent.endDate = [CommonApi getDateTimeFromString: m_information.eventEndDay];
    
    ekEvent.allDay = [m_information.eventIsAllDay isEqualToString:@"YES"] ? YES : NO;
    
    [ekEvent setCalendar: eventKitManager.defaultCalendar];
    
    EKAlarm *alarm = nil;
    
    if ([m_information.eventReminder isEqualToString:@""]) {
        
    } else {
        
        NSArray *arrayInterval = [m_information.eventReminder componentsSeparatedByString:@"#"];
        
        if ([[arrayInterval objectAtIndex: 0] isEqualToString: @"0"]) {
            alarm = [EKAlarm alarmWithRelativeOffset: 0];
        } else if ([[arrayInterval objectAtIndex: 1] isEqualToString:@"min"]) {
            NSInteger nMin = [[arrayInterval objectAtIndex: 0] integerValue];
            
            alarm = [EKAlarm alarmWithRelativeOffset:-nMin * 60];
        } else if ([[arrayInterval objectAtIndex: 1] isEqualToString:@"hour"]) {
            NSInteger nMin = [[arrayInterval objectAtIndex: 0] integerValue];
            
            alarm = [EKAlarm alarmWithRelativeOffset:-nMin * 60 * 60];
        } else if ([[arrayInterval objectAtIndex: 1] isEqualToString:@"day"]) {
            NSInteger nMin = [[arrayInterval objectAtIndex: 0] integerValue];
            
            alarm = [EKAlarm alarmWithRelativeOffset:-nMin * 60 * 60 * 24];
        } else {
            
        }
        
    }
    
    if (alarm != nil) {
        [ekEvent addAlarm: alarm];
    }
    
    
//@"Daily", @"Weekly",    @"Biweekly", @"Monthly", @"Yearly";
    
    EKRecurrenceRule *recurringRule = nil;
    EKRecurrenceFrequency freq = EKRecurrenceFrequencyDaily;
    EKRecurrenceEnd *recurrenceEnd = nil;
    NSInteger nInterval = 0;

    if ([m_information.eventRecurring isEqualToString:@"Daily"]) {
        freq = EKRecurrenceFrequencyDaily;
        nInterval = 1;
    } else if ([m_information.eventRecurring isEqualToString:@"Weekly"]) {
        freq = EKRecurrenceFrequencyWeekly;
        nInterval = 1;

    } else if ([m_information.eventRecurring isEqualToString:@"Biweekly"]) {
        freq = EKRecurrenceFrequencyWeekly;
        nInterval = 2;
    } else if ([m_information.eventRecurring isEqualToString:@"Monthly"]) {
        freq = EKRecurrenceFrequencyMonthly;
        nInterval = 1;
    } else if ([m_information.eventRecurring isEqualToString:@"Yearly"]) {
        freq = EKRecurrenceFrequencyYearly;
        nInterval = 1;
    } else {
        nInterval = 0;
    }
    
    if (m_information.eventRecurringEndDay != nil && [m_information.eventRecurringEndDay length] > 0 && [m_information.eventRecurringEndDay isEqualToString:@"Never"] == NO) {
        recurrenceEnd = [EKRecurrenceEnd recurrenceEndWithEndDate: [CommonApi getDateFromString: m_information.eventRecurringEndDay]];
    }
    
    if (nInterval > 0) {
        recurringRule = [[[EKRecurrenceRule alloc] initRecurrenceWithFrequency:freq interval:nInterval end:recurrenceEnd] autorelease];
    }
    
    if (recurringRule != nil) {
        [ekEvent addRecurrenceRule: recurringRule];
    }
    
    NSError *error;
    
    if ( [eventKitManager.eventStore saveEvent:ekEvent span:EKSpanThisEvent commit:YES error:&error] ) {
        NSLog(@"EventIdentifier = %@", ekEvent.eventIdentifier);
        [m_information setICalEventId: ekEvent.eventIdentifier];

        
    } else {
        NSLog(@"%@", [error description]);
    }
    
    NSInteger nRet = [dataKeeper AddEvent: m_information];
    
    if (nRet == 1) {
        [self performSelectorOnMainThread:@selector(GotoMainScreen) withObject:nil waitUntilDone:YES];
    } else {
        
        //[dbConn makeEventOnline: m_information online: NO];
        [self performSelectorOnMainThread:@selector(FailedSave) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    NSLog(@"SaveThread: End!!!");
    [pool release];
}

- (void) DeleteSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_EVENT_DELETED object:nil];

    [self GotoMainScreen];
}

- (void) GotoMainScreen {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) FailedSave {
    [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Save is failed."];
}

- (void) FailedDelete {
    [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:@"Delete is failed."];
}

- (void) DismissKeyboard {
    
}

#pragma mark - CustomSwitchDelegate
- (void) onValueChanged:(CustomSwitch *)switchCtrl {
    NSLog (@"%d", switchCtrl.m_bValue);
    
    m_bAllDay = switchCtrl.m_bValue;
    
    if (m_bAllDay && m_information.eventStartDay != nil) {
        
        NSDate *sDate = [CommonApi getDateTimeFromString: m_information.eventStartDay];
        NSDate *eDate = [CommonApi getDateTimeFromString: m_information.eventEndDay];

        
        if (sDate == nil) {
            return;
        }
        
        if (eDate == nil) {
            return;
        }
        
        NSArray *dateArrays = [CommonApi getDateStringStartAndEndTime: sDate endDate:eDate];
        
        m_information.eventStartDay = [dateArrays objectAtIndex: 0];
        m_information.eventEndDay = [dateArrays objectAtIndex: 1];
    }
    
    [_tblView reloadData];

}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [_tblView setContentOffset:CGPointMake(0, 390) animated: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (![textView hasText]) {
        [textView viewWithTag: 999].hidden = NO;
    }

}

- (void)textViewDidChange:(UITextView *)textView {
    m_information.eventDescription = textView.text;
    
    if(![textView hasText]) {
        [textView viewWithTag: 999].hidden = NO;
    }
    else{
        [textView viewWithTag: 999].hidden = YES;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.placeholder isEqualToString:@"Title"]) {
        m_information.eventName = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
