//
//  MonthlyViewController.m
//  Schedule
//
//  Created by suhae on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "MonthlyViewController.h"
#import "DBConnector.h"
#import "EventDetailViewController.h"
#import "InviteListViewController.h"

@interface MonthlyViewController ()

@end

@implementation MonthlyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"MonthlyViewController"];
        m_selectedDate = [[NSDate date] retain];
    }
    return self;
}

 - (void)reloadData
{
    
    [self refreshImage];
    
    if (m_selectedDate) {
        m_showData = [[[DBConnector new] autorelease] getEventsAt:m_selectedDate userID:_m_strUserId];
        [mTableView reloadData];
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:m_selectedDate]; // Get necessary date components
        
        int year = [components year]; // gives you year
        [_lbl_dateLabel setText:[NSString stringWithFormat:@"%@ %d", [self getMonthString:m_selectedDate], year]];
    }
    
    NSArray *array = [[[DBConnector new] autorelease] getAllEventsAsArray:_m_strUserId];
    
    for (NSInteger nIndex = 0; nIndex < [array count]; nIndex++) {
        ScheduleItem *item = [array objectAtIndex: nIndex];
        
        NSDate *startDate = [CommonApi getDateTimeFromString: item.eventStartDay];
        NSDate *endDate = [CommonApi getDateTimeFromString: item.eventEndDay];
        
        [mCalenderView addEvent:item.eventName StartTime:startDate EndTime:endDate];
    }
    
//    mCalenderView addEvent:<#(NSString *)#> StartTime:<#(NSDate *)#> EndTime:<#(NSDate *)#>
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
    if (_m_bFriend == NO) {
        
        //  [self.m_container setContentSize:CGSizeMake(self.m_container.frame.size.width * 3, self.m_container.frame.size.height)];
    } else {
        if ([CUtils isIphone5]) {
            [self.m_swipeContainer setFrame: CGRectMake(self.m_swipeContainer.frame.origin.x, self.m_swipeContainer.frame.origin.y, self.m_swipeContainer.frame.size.width, 516)];
        } else {
            [self.m_swipeContainer setFrame: CGRectMake(self.m_swipeContainer.frame.origin.x, self.m_swipeContainer.frame.origin.y, self.m_swipeContainer.frame.size.width, 327)];
        }
    }
    
    [self.m_swipeContainer setContentSize:CGSizeMake(self.m_swipeContainer.frame.size.width * 3, self.m_swipeContainer.frame.size.height)];

    [self reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    if (_m_bFriend == NO) {
        
        //  [self.m_container setContentSize:CGSizeMake(self.m_container.frame.size.width * 3, self.m_container.frame.size.height)];
    } else {
        [self.m_swipeContainer setContentSize:CGSizeMake(self.m_swipeContainer.frame.size.width * 3, self.m_swipeContainer.frame.size.height)];
    }
    
}

- (NSString *)getMonthString:(NSDate*)date
{
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:date];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    if (_m_bFriend == NO) {
        [self setM_strUserId: dataKeeper.m_mySettingInfo.userId];
    }
    
    NSLog(@"height = %f", self.view.bounds.size.height);

    CGSize tabSize = CGSizeMake(_m_calendarContainerView.frame.size.width / 7.0 - 5, _m_calendarContainerView.frame.size.width / 7.0);
    CGRect dlgSize = CGRectMake(0, 0, _m_calendarContainerView.frame.size.width, _m_calendarContainerView.frame.size.height);
    mCalenderView = [[[CalenderView alloc] initWithTabSize:tabSize dlgSize:dlgSize] autorelease];
    mCalenderView.calendarDelegate = self;
    [_m_calendarContainerView addSubview:mCalenderView];
    
    
    
    [_m_scrolContainter setContentSize:CGSizeMake(320, 600)];
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 372, 320, 228)];
    [mTableView setSeparatorStyle: UITableViewCellSeparatorStyleNone];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    [_m_scrolContainter addSubview:mTableView];
    
    //swipeView
    self.m_swipeContainer.pagingEnabled = YES;
    
    [self.m_swipeContainer setContentSize:CGSizeMake(self.m_swipeContainer.frame.size.width * 3, self.m_swipeContainer.frame.size.height)];
    UIView * firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_swipeContainer.frame.size.width, self.m_swipeContainer.frame.size.height)];
    [self.m_swipeContainer addSubview:firstView];
    
    UIView * secondView = [[UIView alloc] initWithFrame:CGRectMake(self.m_swipeContainer.frame.size.width * 2, 0, self.m_swipeContainer.frame.size.width, self.m_swipeContainer.frame.size.height)];
    [self.m_swipeContainer addSubview:secondView];
    
    [self.m_scrolContainter setFrame:CGRectMake(self.m_swipeContainer.frame.size.width, 0, self.m_swipeContainer.frame.size.width, self.m_swipeContainer.frame.size.height)];
    [self.m_swipeContainer setContentOffset:CGPointMake(self.m_swipeContainer.frame.size.width, 0)];
    self.m_swipeContainer.delegate  = self;
    
    // Set Timer for current Date
    [self setLabel];
    [self createTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lbl_dateLabel release];
    [_m_calendarContainerView release];
    [_m_scrolContainter release];
    [_m_swipeContainer release];
    [_m_imgViewProfile release];
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    
    if (m_timer != nil) {
        [m_timer release];
    }
    
    if (_m_strUserId != nil) {
        [_m_strUserId release];
    }
    [super dealloc];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.m_swipeContainer)
        return;
    int widthPoint = scrollView.contentOffset.x;
    int page = widthPoint / self.m_swipeContainer.frame.size.width;
    if (page == 0) {
        [[mCalenderView getKalViewController] showPreviousMonth];
        m_selectedDate = [[CommonApi getBeforeMonthDay:m_selectedDate] retain];
        [self.m_swipeContainer setContentOffset:CGPointMake(self.m_swipeContainer.frame.size.width, 0)];
        [self reloadData];
    } else if (page == 2){
        [[mCalenderView getKalViewController] showFollowingMonth];
        m_selectedDate = [[CommonApi getAfterMonthDay:m_selectedDate] retain];
        [self.m_swipeContainer setContentOffset:CGPointMake(self.m_swipeContainer.frame.size.width, 0)];
        [self reloadData];
    }
}

- (void)selectDate:(NSDate *)date {
    m_selectedDate = [date retain];
    [self reloadData];
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
    //    if(!cell){
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenitfier];
    
    EventCellView * cellView = [[EventCellView alloc] init];
    ScheduleItem * item = (ScheduleItem*)[m_showData objectAtIndex:indexPath.row];
    [cellView setInfo:item];
    
    
    [cellView.m_btnSeeAll setTag: indexPath.row];
    [cellView.m_btnSeeAll addTarget:self action:@selector(onTouchSeeAllGuests:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:cellView];
    
   //    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    for (UIView * v in [cell.contentView subviews]) {
        if([v isKindOfClass: [EventCellView class]]) {
            
            EventDetailViewController * controller = [[EventDetailViewController alloc]initWithNibName:@"EventDetailViewController" bundle:nil];
            [controller initItem:[(EventCellView*)v cellItem]];
            [self.navigationController pushViewController: controller animated: YES];
            
            [controller release];
        }
    }
}

- (IBAction)onTouchSeeAllGuests:(id)sender {
    ScheduleItem * item = (ScheduleItem*)[m_showData objectAtIndex: [sender tag]];
    
    InviteListViewController *invitelistVC = [[InviteListViewController alloc] initWithNibName:@"InviteListViewController" bundle: nil];
    
    [invitelistVC setM_arrayGuests: item.arrayGuests];
    
    [self.navigationController pushViewController: invitelistVC animated: YES];
    
    [invitelistVC release];

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
