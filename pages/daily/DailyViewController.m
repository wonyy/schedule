//
//  DailyViewController.m
//  Schedule
//
//  Created by suhae on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "DailyViewController.h"
#import "DBConnector.h"
#import "EventDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+expanded.h"
#import "AppDelegate.h"

@interface DailyViewController ()

@end

@implementation DailyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"DailyViewController"];
        
        m_showData = [[NSMutableArray alloc] initWithObjects:@"00 am",@"01 am",@"02 am",@"03 am",@"04 am",@"05 am",@"06 am",@"07 am",@"08 am",@"09 am",@"10 am",@"11 am",@"12 pm",@"01 pm",@"02 pm",@"03 pm",@"04 pm",@"05 pm",@"06 pm",@"07 pm",@"08 pm",@"09 pm",@"10 pm",@"11 pm", nil];
        
    }
    return self;
}

- (void)reloadData {
    m_aryEvent = [[DBConnector new] getEventsAt:currentDate userID:_m_strUserId];
    
    [self refreshImage];
    
    [self initializeScrollView];
    
    [self setLabel];
    
    [self removeRegion];
    [self addRegion];
    
    [self scrollToDefault];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [self reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    // Loading Indicator Initialize
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    // Add HUD to screen
    [self.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;

    currentDate = [[NSDate date] retain];
  
    
  // For test
  //  currentDate = [[CommonApi getDateFromString:@"2013-10-20"] retain];

    if (_m_bFriend == NO) {
        DataKeeper *dataKeeper = [DataKeeper sharedInstance];
        [self setM_strUserId: dataKeeper.m_mySettingInfo.userId];
    }
    
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoToday) name:NOTIFICATION_TODAY object:nil];
   // [self createTimer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_dataContainer release];
    [_lbl_weekNumber release];
    [_lbl_TodayDate release];
    [_lbl_time release];
    [_m_container release];
    [_m_imgViewProfile release];
    
    if (_m_strUserId != nil) {
        [_m_strUserId release];
    }
    [super dealloc];
}

- (void) viewDidAppear:(BOOL)animated {
    if (_m_bFriend == NO) {
        
      //  [self.m_container setContentSize:CGSizeMake(self.m_container.frame.size.width * 3, self.m_container.frame.size.height)];
    } else {
        [self.m_container setContentSize:CGSizeMake(self.m_container.frame.size.width * 3, self.m_container.frame.size.height)];

        [_m_dataContainer setFrame:CGRectMake(self.m_container.frame.size.width, 0, self.m_container.frame.size.width, self.m_container.frame.size.height)];
    }
    
    NSLog(@"self.view = %f, container.fram = %f, container.contentsize = %f, table.frame = %f, table.content = %f", self.view.frame.size.height, self.m_container.frame.size.height, self.m_container.contentSize.height, self.m_dataContainer.frame.size.height, self.m_dataContainer.contentSize.height);
}

#pragma mark - General Functions

- (void)initializeScrollView
{
    if (_m_bFriend == NO) {
        
        [self.m_container setContentSize:CGSizeMake(self.m_container.frame.size.width * 3, self.m_container.frame.size.height)];
    } else {
        
        if ([CUtils isIphone5]) {
            [self.m_container setFrame: CGRectMake(self.m_container.frame.origin.x, self.m_container.frame.origin.y, self.m_container.frame.size.width, 500)];
        } else {
            [self.m_container setFrame: CGRectMake(self.m_container.frame.origin.x, self.m_container.frame.origin.y, self.m_container.frame.size.width, 327)];
        }
         
        
      //  [self.m_container setContentSize:CGSizeMake(self.m_container.frame.size.width * 3, self.m_container.frame.size.height)];
    }
    
    [self.m_container setContentSize:CGSizeMake(self.m_container.frame.size.width * 3, self.m_container.frame.size.height)];

    
    if (firstTable) {
        [firstTable removeFromSuperview];
        [firstTable release];
    }
    
    
    firstTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.m_container.frame.size.width, self.m_container.frame.size.height) style:UITableViewStylePlain];
    firstTable.delegate = self;
    firstTable.dataSource = self;
    [self.m_container addSubview:firstTable];
    
    [_m_dataContainer removeFromSuperview];
    
    [_m_dataContainer setFrame:CGRectMake(self.m_container.frame.size.width, 0, self.m_container.frame.size.width, self.m_container.frame.size.height)];
    
  //  _m_dataContainer.delegate = self;
  //  _m_dataContainer.dataSource = self;
    
    [self.m_container addSubview:_m_dataContainer];
    
    if (secondTable) {
        [secondTable removeFromSuperview];
        [secondTable release];
    }
    
    secondTable = [[UITableView alloc] initWithFrame:CGRectMake(self.m_container.frame.size.width * 2, 0, self.m_container.frame.size.width, self.m_container.frame.size.height) style:UITableViewStylePlain];
    
    secondTable.delegate = self;
    secondTable.dataSource = self;
    [self.m_container addSubview:secondTable];
    self.m_container.pagingEnabled = YES;
    [self.m_container setContentOffset:CGPointMake(self.m_container.frame.size.width, 0) animated:NO];
    [firstTable reloadData];
    [_m_dataContainer reloadData];
    [secondTable reloadData];
    
    self.m_container.delegate = self;
}

- (void) scrollToDefault {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    SettingItem *settingItem = [[SettingItem alloc] initWithSettingItem: dataKeeper.m_mySettingInfo];
    
    [settingItem release];
    
    [_m_dataContainer scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[settingItem.startday integerValue] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated: YES];
}


- (void) createTimer {
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setLabel) userInfo:nil repeats: YES];
}

- (void) gotoToday {
    currentDate = [[NSDate date] retain];
    [self setLabel];
    m_aryEvent = [[DBConnector new] getEventsAt:currentDate userID:_m_strUserId];
    [self.m_container setContentOffset:CGPointMake(self.m_container.frame.size.width, 0)];
    [_m_dataContainer reloadData];
    [self removeRegion];
    [self addRegion];
}

- (void)setLabel {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];

    NSDate * toDay = currentDate;
    NSDateFormatter * dateformatter = [[NSDateFormatter new] autorelease];
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    gregorian.firstWeekday = 2;
    NSDateComponents *components = [gregorian components:NSWeekOfYearCalendarUnit fromDate:toDay];
    NSUInteger weekOfYear = [components weekOfYear];
    [_lbl_weekNumber setText:[NSString stringWithFormat:@"%d", weekOfYear]];
    [dateformatter setDateFormat:dataKeeper.m_mySettingInfo.dateformat];
    NSString * dateString = [dateformatter stringFromDate:toDay];
    dateformatter.dateFormat = @"EEE";
    NSString * dayString = [[dateformatter stringFromDate:toDay] capitalizedString];
    [_lbl_TodayDate setText:[NSString stringWithFormat:@"%@, %@", dayString, dateString]];
    dateformatter.dateFormat = dataKeeper.m_mySettingInfo.timeformat;
    NSString * timeString = [dateformatter stringFromDate:toDay];
    [_lbl_time setText:timeString];
    
    NSLog(@"---- setLabel -----");
}

- (UIView *)getView:(ScheduleItem *)i {
    CGFloat w = 0, h = 0;
    UIView * v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)] retain];
    
    return v;
}

- (CGRect)getRect:(ScheduleItem *) i {
    CGFloat y, h;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[CommonApi getDateTimeFromString:i.eventStartDay]];
    int shour = [components hour];
    int sminutes = [components minute];
    components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:[CommonApi getDateTimeFromString:i.eventEndDay]];
    int ehour = [components hour];
    int eminutes = [components minute];
    
    y = shour * 50 + 25 * (sminutes > 30 ? 1:0);
    h = (ehour * 50 + 25 * (eminutes > 30 ? 1:0)) - (shour * 50 + 25 * (sminutes > 30 ? 1:0));
    
    CGRect r = CGRectMake(75, y, 240, h);
    return r;
}

- (void)addRegion {
    
    for (NSInteger nIndex = 0; nIndex < [m_aryEvent count]; nIndex++) {
        
        ScheduleItem *item = [m_aryEvent objectAtIndex: nIndex];
        
        UIView * v = [[UIView alloc] initWithFrame:[self getRect:item]];
        
        DataKeeper *dataKeeper = [DataKeeper sharedInstance];
        
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

        
        v.backgroundColor = eventColor;

        v.layer.cornerRadius = 5;
        v.layer.masksToBounds = YES;
        v.tag = 1000 + nIndex;
        
        [_m_dataContainer addSubview:v];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired = 1; 
        [v addGestureRecognizer:tapGesture];
        [tapGesture release];
        
        UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, v.frame.size.width, 15)];
        
        [labelTime setTextAlignment: NSTextAlignmentCenter];
        [labelTime setTextColor: [UIColor whiteColor]];
        [labelTime setBackgroundColor: [UIColor clearColor]];
        [labelTime setFont: [UIFont systemFontOfSize:10.0f]];
        [labelTime setTag: 999];
        
        [labelTime setText: [NSString stringWithFormat:@"%@ - %@", [CommonApi getTime: [CommonApi getDateTimeFromString: item.eventStartDay]], [CommonApi getTime: [CommonApi getDateTimeFromString: item.eventEndDay]]]];
        
        [v addSubview: labelTime];
        
        [labelTime release];
        
        
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, v.frame.size.width, 20)];
        
        [labelTitle setTextAlignment: NSTextAlignmentCenter];
        [labelTitle setTextColor: [UIColor whiteColor]];
        [labelTitle setBackgroundColor: [UIColor clearColor]];
        [labelTitle setFont: [UIFont systemFontOfSize:12.0f]];
        
        [labelTitle setText: [NSString stringWithFormat:@"%@", item.eventName]];
        
        [v addSubview: labelTitle];
        
        [labelTitle release];
        [v release];
    }
}

- (void)removeRegion {
    for (UIView * v in [_m_dataContainer subviews]) {
        if (v.tag >= 1000) {
            [v removeFromSuperview];
        }
    }
}

#pragma mark - Gesture
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSInteger nIdx = sender.view.tag - 1000;
        [self DailyCellDelegate_Seleted: nIdx];
        // handling code
    }
}


#pragma mark -
#pragma mark table management


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_showData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellIndenitfier = @"cellIndenitfier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndenitfier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenitfier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    DailyCell * cellView = [[DailyCell alloc] init];
    cellView.delegate = self;
    [cellView setHour:indexPath.row];
    [cellView setTitle:[m_showData objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:cellView];
    
    /*
    if (tableView == _m_dataContainer) {
        if (m_aryEvent != nil && [m_aryEvent isKindOfClass:[NSMutableArray class]]) {
            for (int i = 0; i < [m_aryEvent count]; i++) {
                ScheduleItem * item = (ScheduleItem *)[m_aryEvent objectAtIndex:i];
                [cellView addTask:item];
            }
        }
    }
    */
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.m_container)
        return;
    
    int widthPoint = scrollView.contentOffset.x;
    int page = widthPoint / self.m_container.frame.size.width;
    
    if (page == 0) {
        currentDate = [[CommonApi getBeforeDay:currentDate] retain];
        [self setLabel];
        m_aryEvent = [[DBConnector new] getEventsAt:currentDate userID:_m_strUserId];
        [self.m_container setContentOffset:CGPointMake(self.m_container.frame.size.width, 0)];
        [_m_dataContainer reloadData];
        [self removeRegion];
        [self addRegion];
    } else if (page == 2) {
        currentDate = [[CommonApi getAfterDay:currentDate] retain];
        [self setLabel];
        m_aryEvent = [[DBConnector new] getEventsAt:currentDate userID:_m_strUserId];
        [self.m_container setContentOffset:CGPointMake(self.m_container.frame.size.width, 0)];
        [_m_dataContainer reloadData];
        [self removeRegion];
        [self addRegion];
    }
}

#pragma mark - UIDragTableView Delegate

- (void) SubItemTouchMove: (NSInteger) nIndex view:(UIView *)curview nStart:(float)start nEnd:(float)end {
    ScheduleItem *item = [m_aryEvent objectAtIndex: nIndex];
    
  //  getDateTimeFromStringWithCurrentTimeZone
  //  item.eventStartDay
    
    NSDate * toDay = currentDate;
    
    NSDateFormatter * dateformatter = [[NSDateFormatter new] autorelease];
    
    [dateformatter setDateFormat:DEFAULT_DATE_FORMAT];
    
    NSString * dateString = [dateformatter stringFromDate:toDay];
    
 //   AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    float fHeightCell = 50.0f;
    
    NSInteger nHour = start / fHeightCell;
    NSInteger nMin = (start - nHour * fHeightCell) * 60 / fHeightCell;
    
    NSString *strNewStartTime = [NSString stringWithFormat:@"%@ %02d:%d:00", dateString, nHour, nMin];
    NSLog(@"MovedStartTime: %@", strNewStartTime);
    
    item.eventStartDay = [CommonApi getStringFromDateTime: [CommonApi getDateTimeFromStringWithCurrentTimeZone: strNewStartTime]];
    
    nHour = end / fHeightCell;
    nMin = (end - nHour * fHeightCell) * 60 / fHeightCell;
    
    NSString *strNewEndTime = [NSString stringWithFormat:@"%@ %02d:%d:00", dateString, nHour, nMin];
    NSLog(@"MovedEndTime: %@", strNewEndTime);
    
    item.eventEndDay = [CommonApi getStringFromDateTime: [CommonApi getDateTimeFromStringWithCurrentTimeZone: strNewEndTime]];
    
    UILabel *labelTime = (UILabel *) [curview viewWithTag: 999];
    
    [labelTime setText: [NSString stringWithFormat:@"%@ - %@", [CommonApi getTime: [CommonApi getDateTimeFromString: item.eventStartDay]], [CommonApi getTime: [CommonApi getDateTimeFromString: item.eventEndDay]]]];
}

- (void) SubItemTouchEnd: (NSInteger) nIndex {
    m_nCurIndex = nIndex;
    
    [self UpdateSchedule];
}


#pragma mark - DailyCellDelegate 

- (void)DailyCellDelegate_Seleted:(int)idx {
    EventDetailViewController * controller = [[EventDetailViewController alloc]initWithNibName:@"EventDetailViewController" bundle:nil];
    
    [controller initItem:[m_aryEvent objectAtIndex: idx]];
    [self.navigationController pushViewController: controller animated: YES];
    
    [controller release];
   // [self presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
}

- (void)DailyCellDoubleTap: (NSString *) strCurDateTime {
    
    if (_m_bFriend == NO) {
        
        NSDate * toDay = currentDate;
        
        NSDateFormatter * dateformatter = [[NSDateFormatter new] autorelease];
        
        [dateformatter setDateFormat:DEFAULT_DATE_FORMAT];
        
        NSString * dateString = [dateformatter stringFromDate:toDay];
            
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
        [appDelegate setM_dateForDailyView: [NSString stringWithFormat:@"%@ %@:00", dateString, strCurDateTime]];
    
        [appDelegate MainTabBarViewDelegate_selectedAt: 11];
    }
    
    /*
    AddEventViewController * controller = [[AddEventViewController alloc]initWithNibName:@"AddEventViewController" bundle:nil];
    [self.mainViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
     */
}

#pragma mark - Touch Actions

- (IBAction) onTouchRegionButton:(id)sender {
    NSInteger nIdx = [sender tag] - 1000;
    
    [self DailyCellDelegate_Seleted: nIdx];
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
    HUD.labelText = @"Updating...";
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

- (void) UpdateSchedule {
    // Show Loading for Initalize
    [self ShowSaving];
    
    [NSThread detachNewThreadSelector:@selector(UpdateScheduleThread) toTarget:self withObject:nil];
}

- (void) UpdateScheduleThread {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"UpdateScheduleThread: Start!!!");
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSInteger nRet;
    
    ScheduleItem *item = [m_aryEvent objectAtIndex: m_nCurIndex];

    
    nRet = [dataKeeper AddEvent: item];
    
    if (nRet == 1) {
        // [self performSelectorOnMainThread:@selector(GotoMainScreen) withObject:nil waitUntilDone:YES];
        
    } else {
        [self performSelectorOnMainThread:@selector(ShowFailedMessage) withObject:nil waitUntilDone:YES];
    }
    
    [self HideIndicator];
    
    
    NSLog(@"UpdateScheduleThread: End!!!");
    [pool release];
}

- (void) ShowFailedMessage {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    [CUtils showAlertWithTitle:APP_ALERT_TITLE andMessage:dataKeeper.m_strLastErrorMessage];
    
    [self reloadData];

}

@end
