//
//  HomeViewController.m
//  Schedule
//
//  Created by wonymini on 9/26/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "HomeViewController.h"
#import "EventDetailViewController.h"
#import "InviteListViewController.h"
#import "DBConnector.h"
#import "UIColor+expanded.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    // Do any additional setup after loading the view from its nib
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    _switchAvail = [[CustomSwitch alloc] initWithFrame:CGRectMake(107, 50, 43, 24)];
    _switchAvail.delegate = self;
    [_switchAvail setValue:dataKeeper.m_bAvailable withUI:NO];
    
    [_m_headerView addSubview: _switchAvail];
    
    // Loading Indicator Initialize
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
    DBConnector *dbConn = [[DBConnector new] autorelease];
    
    m_aryWeathers = [dbConn getAllWeathers];
    
    WeatherItem *weatherItem = [m_aryWeathers objectAtIndex: 0];
    
    [_m_labelWeather setText: [NSString stringWithFormat:@"%@° ~ %@°", weatherItem.low, weatherItem.high]];
    
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
    
    [self reloadData];
}

- (void)dealloc {
    [_m_homeCell release];
    [_m_tableView release];
    [_m_imgViewProfile release];
    [_m_imgViewWeather release];
    [_m_labelWeather release];
    [_m_headerView release];
    [_switchAvail release];
    [_m_labelDate release];
    [_m_labelHour release];
    [_m_labelMinute release];
    
    if (m_timer != nil) {
        [m_timer release];
    }
    [super dealloc];
}

- (void)reloadData
{
    [self refreshImage];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    m_dictData = [[DBConnector new] getAllEventsbyID: dataKeeper.m_mySettingInfo.userId fromNow: [NSDate date]];
    [_m_tableView reloadData];
}


#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 17;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 17)] autorelease];
    
    [view setBackgroundColor: [UIColor colorWithRed:0.0f/255.0f green:181.0f/255.0f blue:203.0f/255.0f alpha: 1.0f]];
    
    UILabel *labelWeek = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 17)] autorelease];
    
    NSString *strDate = [[m_dictData allKeys] objectAtIndex: section];
    
    NSDate *date = [CommonApi getDateFromString: strDate];
    
    [labelWeek setText: [CommonApi getWeekDay: date]];
    
    [labelWeek setTextColor: [UIColor whiteColor]];
    [labelWeek setBackgroundColor: [UIColor clearColor]];
    
    [labelWeek setTextAlignment: NSTextAlignmentRight];
    [labelWeek setFont: [UIFont systemFontOfSize: 13.0f]];
    
    [view addSubview: labelWeek];
    
    UILabel *labelDate = [[[UILabel alloc] initWithFrame:CGRectMake(200, 0, 100, 17)] autorelease];
    
  //  [labelDate setText: strDate];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    [labelDate setText: [CommonApi ConvertWithNewFormat:strDate oldFormat:DEFAULT_DATE_FORMAT newFormat:dataKeeper.m_mySettingInfo.dateformat]];

    [labelDate setTextColor: [UIColor whiteColor]];
    [labelDate setBackgroundColor: [UIColor clearColor]];
    
    [labelDate setTextAlignment: NSTextAlignmentRight];
    [labelDate setFont: [UIFont systemFontOfSize: 13.0f]];
    
    [view addSubview: labelDate];

    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[m_dictData allKeys] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[m_dictData allKeys] objectAtIndex: section];
}

// Set the height of each cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

// Set Cell Count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *strKey = [[m_dictData allKeys] objectAtIndex: section];
    
    return [[m_dictData objectForKey: strKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
    
    NSString *strKey = [[m_dictData allKeys] objectAtIndex: indexPath.section];
    
    NSArray *array = [m_dictData objectForKey: strKey];
    
    ScheduleItem * item = (ScheduleItem*)[array objectAtIndex: indexPath.row];
    
    NSDate *stDate = [CommonApi getDateTimeFromString: item.eventStartDay];
    NSDate *enDate = [CommonApi getDateTimeFromString: item.eventEndDay];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];

    [_m_homeCell.labelFrom setText: [CommonApi getTime:stDate timeformat:dataKeeper.m_mySettingInfo.timeformat]];
    [_m_homeCell.labelTo setText: [CommonApi getTime: enDate timeformat:dataKeeper.m_mySettingInfo.timeformat]];
    [_m_homeCell.labelTitle setText: item.eventName];
    
    NSInteger nGuestCount = [item.arrayGuests count];
    
    if (nGuestCount == 0) {
        [_m_homeCell.m_imgViewGuest1 setHidden: YES];
        [_m_homeCell.m_imgViewGuest2 setHidden: YES];
    } else if (nGuestCount == 1) {
        [_m_homeCell.m_imgViewGuest2 setHidden: NO];
        [_m_homeCell.m_imgViewGuest1 setHidden: YES];
    
        NSDictionary *friendItem2 = [item.arrayGuests objectAtIndex: 0];
        _m_homeCell.m_strImgURL2 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem2 objectForKey:@"profile_picture"]];
        [_m_homeCell refreshImage2];
        
    } else if (nGuestCount == 2) {
        [_m_homeCell.m_imgViewGuest2 setHidden: NO];
        [_m_homeCell.m_imgViewGuest1 setHidden: NO];
        
        NSDictionary *friendItem2 = [item.arrayGuests objectAtIndex: 0];
        _m_homeCell.m_strImgURL2 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem2 objectForKey:@"profile_picture"]];
        [_m_homeCell refreshImage2];
        
        NSDictionary *friendItem1 = [item.arrayGuests objectAtIndex: 1];
        _m_homeCell.m_strImgURL1 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem1 objectForKey:@"profile_picture"]];
        [_m_homeCell refreshImage1];
    } else {
        [_m_homeCell.m_imgViewGuest2 setHidden: NO];
        [_m_homeCell.m_imgViewGuest1 setHidden: NO];
        
        NSDictionary *friendItem2 = [item.arrayGuests objectAtIndex: 0];
        _m_homeCell.m_strImgURL2 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem2 objectForKey:@"profile_picture"]];
        [_m_homeCell refreshImage2];
        
        NSDictionary *friendItem1 = [item.arrayGuests objectAtIndex: 1];
        _m_homeCell.m_strImgURL1 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem1 objectForKey:@"profile_picture"]];
        [_m_homeCell refreshImage1];
        [_m_homeCell.m_btnSeeAllGuests setHidden: NO];
        [_m_homeCell.m_btnSeeAllGuests setTag: item.eventId];
    }

    UIColor *eventColor;
    if ([item.eventType isEqualToString:@"Work"]) {
        eventColor = [UIColor colorWithHexString: [dataKeeper.m_mySettingInfo.workColor substringFromIndex:1]];
    } else if ([item.eventType isEqualToString:@"School"]) {
        eventColor = [UIColor colorWithHexString: [dataKeeper.m_mySettingInfo.schoolColor substringFromIndex:1]];
    } else if ([item.eventType isEqualToString:@"Personal"]) {
        eventColor = [UIColor colorWithHexString: [dataKeeper.m_mySettingInfo.personalColor substringFromIndex:1]];
    } else if ([item.eventType isEqualToString:@"Other"]) {
        eventColor = [UIColor colorWithHexString: [dataKeeper.m_mySettingInfo.otherColor substringFromIndex:1]];
    } else {
        eventColor = [UIColor colorWithHexString: [dataKeeper.m_mySettingInfo.otherColor substringFromIndex:1]];
    }
    
    [_m_homeCell.m_eventTypeView setBackgroundColor: eventColor];
    [_m_homeCell.labelTitle setTextColor: eventColor];
    
    return _m_homeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *strKey = [[m_dictData allKeys] objectAtIndex: indexPath.section];
    
    
    NSArray *array = [m_dictData objectForKey: strKey];
    
    ScheduleItem * item = (ScheduleItem*)[array objectAtIndex: indexPath.row];
    
    
    EventDetailViewController * controller = [[EventDetailViewController alloc]initWithNibName:@"EventDetailViewController" bundle:nil];
    [controller initItem: item];
    [self.navigationController pushViewController: controller animated: YES];
    
    [controller release];
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

#pragma mark - CustomSwitchDelegate
- (void) onValueChanged:(CustomSwitch *)switchCtrl {
    NSLog (@"%d", switchCtrl.m_bValue);
    
    [self UpdateStatus];
}



#pragma mark - Loading Indicator Functions

- (void) ShowLoading {
    HUD.labelText = @"Loading";
    [HUD showUsingAnimation: YES];
}

- (void) ShowSaving {
    HUD.labelText = @"Updating status...";
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

- (void) UpdateStatus {
    // Show Loading for Initalize
    [self ShowSaving];
    
    [NSThread detachNewThreadSelector:@selector(UpdateStatusThread) toTarget:self withObject:nil];
}

- (void) UpdateStatusThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"UpdateStatusThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSInteger nRet;
    
    if (_switchAvail.m_bValue == YES) {
        nRet = [dataKeeper UpdateStatus:@"busy"];
    } else {
        nRet = [dataKeeper UpdateStatus:@"available"];
    }
    
    if (nRet == 1) {
       // [self performSelectorOnMainThread:@selector(GotoMainScreen) withObject:nil waitUntilDone:YES];
        
    } else {
        //[self performSelectorOnMainThread:@selector(ShowLoginFailed) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    
    NSLog(@"UpdateStatusThread: End!!!");
    [pool release];
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
    [_m_labelDate setText:[NSString stringWithFormat:@"%@, %@", dayString, dateString]];
    
    
    dateformatter.dateFormat = @"HH";
    NSString * timeString = [dateformatter stringFromDate:toDay];
    [_m_labelHour setText:timeString];
    
    dateformatter.dateFormat = @"mm";
    timeString = [dateformatter stringFromDate:toDay];
    [_m_labelMinute setText:timeString];
    
 //   NSLog(@"---- setLabel -----");
}

#pragma mark - Touch Actions

- (IBAction)onTouchSeeAllGuestsBtn:(id)sender {
    NSInteger nEventID = [sender tag];
    
    DBConnector *dbConnector = [[DBConnector alloc] init];
    
    ScheduleItem *item = [dbConnector getEventFromID: nEventID];
    InviteListViewController *guestListVC = [[InviteListViewController alloc] initWithNibName:@"InviteListViewController" bundle: nil];
    
    [guestListVC setM_arrayGuests: item.arrayGuests];
    
    [self.navigationController pushViewController:guestListVC animated: YES];
    
    [guestListVC release];
    [dbConnector release];
    
}
@end
