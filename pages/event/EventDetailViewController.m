//
//  EventDetailViewController.m
//  Schedule
//
//  Created by Mountain on 10/1/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "EventDetailViewController.h"
#import "AddEventViewController.h"
#import "InviteListViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_information = [ScheduleItem new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_m_scrollView setContentSize: CGSizeMake(_m_scrollView.frame.size.width, _m_scrollView.frame.size.height)];
    
    [self refreshImage];
    
    [_m_labelEventTitle setText: m_information.eventName];
    [_m_labelLocation setText: m_information.eventLocation];
    [_m_labelEventType setText: m_information.eventType];
    [_m_textViewNote setText: m_information.eventDescription];
    
    [_m_labelRepeats setText: [NSString stringWithFormat:@"repeats %@", m_information.eventRecurring]];
    
    NSDate *stDate = [CommonApi getDateTimeFromString: m_information.eventStartDay];
    NSDate *enDate = [CommonApi getDateTimeFromString: m_information.eventEndDay];
    
    [_m_labelStart setText: [NSString stringWithFormat: @"from %@", [CommonApi getDateTime: stDate]]];
    
    [_m_labelEnd setText: [NSString stringWithFormat: @"to %@", [CommonApi getDateTime: enDate]]];
    
    
    NSString *strEventReminder;
    
    if ([m_information.eventReminder isEqualToString:@""]) {
        strEventReminder = @"None";
    } else {
        
        NSArray *arrayInterval = [m_information.eventReminder componentsSeparatedByString:@"#"];
        
        if ([[arrayInterval objectAtIndex: 0] isEqualToString: @"0"]) {
            strEventReminder = @"At time of event";
        } else if ([[arrayInterval objectAtIndex: 1] isEqualToString:@"min"]) {
            strEventReminder = [NSString stringWithFormat:@"%@ minute%@ before",[arrayInterval objectAtIndex: 0], ([[arrayInterval objectAtIndex: 0] integerValue] > 1) ? @"s" : @""];
        } else if ([[arrayInterval objectAtIndex: 1] isEqualToString:@"hour"]) {
            strEventReminder = [NSString stringWithFormat:@"%@ hour%@", [arrayInterval objectAtIndex: 0], ([[arrayInterval objectAtIndex: 0] integerValue] > 1) ? @"s" : @""];
        } else if ([[arrayInterval objectAtIndex: 1] isEqualToString:@"day"]) {
            strEventReminder = [NSString stringWithFormat:@"%@ day%@", [arrayInterval objectAtIndex: 0], ([[arrayInterval objectAtIndex: 0] integerValue] > 1) ? @"s" : @""];
        } else {
            strEventReminder = @"Invalid data";
        }
        
    }
    
    [_m_labelAlert setText: strEventReminder];

    
    NSInteger nGuestCount = [m_information.arrayGuests count];
    
    if (nGuestCount == 0) {
        [_m_imgViewGuest1 setHidden: YES];
        [_m_imgViewGuest2 setHidden: YES];
    } else if (nGuestCount == 1) {
        [_m_imgViewGuest2 setHidden: NO];
        [_m_imgViewGuest1 setHidden: YES];
        
        NSDictionary *friendItem2 = [m_information.arrayGuests objectAtIndex: 0];
        _m_strImgURL2 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem2 objectForKey:@"profile_picture"]];
        [self refreshImage2];
        
    } else if (nGuestCount == 2) {
        [_m_imgViewGuest2 setHidden: NO];
        [_m_imgViewGuest1 setHidden: NO];
        
        NSDictionary *friendItem2 = [m_information.arrayGuests objectAtIndex: 0];
        _m_strImgURL2 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem2 objectForKey:@"profile_picture"]];
        
        NSDictionary *friendItem1 = [m_information.arrayGuests objectAtIndex: 1];
        _m_strImgURL1 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem1 objectForKey:@"profile_picture"]];
        
        [self refreshImage1];
        [self refreshImage2];
    } else {
        [_m_imgViewGuest2 setHidden: NO];
        [_m_imgViewGuest1 setHidden: NO];
        
        NSDictionary *friendItem2 = [m_information.arrayGuests objectAtIndex: 0];
        _m_strImgURL2 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem2 objectForKey:@"profile_picture"]];
        
        NSDictionary *friendItem1 = [m_information.arrayGuests objectAtIndex: 1];
        _m_strImgURL1 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem1 objectForKey:@"profile_picture"]];
        [self refreshImage1];
        [self refreshImage2];
        [_m_btnSeeAllGuests setHidden: NO];
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EventDeleted) name:NOTIFICATION_EVENT_DELETED object:nil];
    
    // Set Timer for current Date
    [self setLabel];
    [self createTimer];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initItem:(ScheduleItem *)item {
    m_information = item;
}

- (void)dealloc {
    [_m_scrollView release];
    [_m_imgViewProfile release];
    [_m_labelEventTitle release];
    [_m_labelStart release];
    [_m_labelEnd release];
    [_m_labelRepeats release];
    [_m_labelLocation release];
    [_m_textViewNote release];
    [_m_labelEventType release];
    [_m_labelAlert release];
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    
    if (m_timer != nil) {
        [m_timer release];
    }
    [_m_imgViewGuest1 release];
    [_m_imgViewGuest2 release];
    [_m_btnSeeAllGuests release];
    [_m_strImgURL1 release];
    [_m_strImgURL2 release];
    
    [super dealloc];
}


#pragma mark - Actions

- (IBAction)onTouchCancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)onTouchEditBtn:(id)sender {
    AddEventViewController * controller = [[[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil] autorelease];
    [controller initItem: m_information];

    [self presentViewController:[[[UINavigationController alloc] initWithRootViewController:controller] autorelease] animated:YES completion:nil];
}

- (IBAction)onTouchLocationBtn:(id)sender {
    
}

- (IBAction)onTouchShowAllGuests:(id)sender {
    InviteListViewController *invitelistVC = [[InviteListViewController alloc] initWithNibName:@"InviteListViewController" bundle: nil];
    
    [invitelistVC setM_arrayGuests: m_information.arrayGuests];
    
    [self.navigationController pushViewController: invitelistVC animated: YES];
    
    [invitelistVC release];
}

- (void) EventDeleted {
    [self.navigationController popViewControllerAnimated: YES];
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

#pragma mark - Set Image to cell

- (void) refreshImage1 {
    [NSThread detachNewThreadSelector:@selector(getImage1) toTarget:self withObject:nil];
}

- (void) getImage1 {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    UIImage *image = [dataKeeper getImage: _m_strImgURL1];
    
    if (image != nil) {
        [_m_imgViewGuest1 setImage: image];
        
        [CUtils makeCircleImage: _m_imgViewGuest1];
    }
    
    [autoreleasePool release];
}

- (void) refreshImage2 {
    [NSThread detachNewThreadSelector:@selector(getImage2) toTarget:self withObject:nil];
}

- (void) getImage2 {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    UIImage *image = [dataKeeper getImage: _m_strImgURL2];
    
    if (image != nil) {
        [_m_imgViewGuest2 setImage: image];
        
        [CUtils makeCircleImage: _m_imgViewGuest2];
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
