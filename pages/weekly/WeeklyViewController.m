//
//  WeeklyViewController.m
//  Schedule
//
//  Created by suhae on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "WeeklyViewController.h"
#import "DBConnector.h"
#import "EventDetailViewController.h"

@interface WeeklyViewController ()

@end

@implementation WeeklyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"WeeklyViewController"];
    }
    return self;
}

- (void)reloadData:(NSDate *)today
{
    [self setLabel];
    
    [self refreshImage];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
 //   SettingItem *settingItem = [[[SettingItem alloc] initWithSettingItem: dataKeeper.m_mySettingInfo] autorelease];
    
    if (monthDayView == nil) {
        sunDayView = [[SubWeeklyDayView alloc] init];
        perSubWidth = sunDayView.frame.size.width;
        perSubHeight = sunDayView.frame.size.height;
        monthDayView = [[SubWeeklyDayView alloc] init];
        tuesDayView = [[SubWeeklyDayView alloc] init];
        wensDayView = [[SubWeeklyDayView alloc] init];
        thursDayView = [[SubWeeklyDayView alloc] init];
        friDayView = [[SubWeeklyDayView alloc] init];
        satDayView = [[SubWeeklyDayView alloc] init];
        
        if ([dataKeeper.m_mySettingInfo.startweek integerValue] == 0) {
            
            [monthDayView setFrame:CGRectMake(0, 0, perSubWidth, perSubHeight)];
            [tuesDayView setFrame:CGRectMake(perSubWidth, 0, perSubWidth, perSubHeight)];
            [wensDayView setFrame:CGRectMake(0, perSubHeight, perSubWidth, perSubHeight)];
            [thursDayView setFrame:CGRectMake(perSubWidth, perSubHeight, perSubWidth, perSubHeight)];
            [friDayView setFrame:CGRectMake(0, perSubHeight * 2, perSubWidth, perSubHeight)];
            [satDayView setFrame:CGRectMake(perSubWidth, perSubHeight * 2, perSubWidth, perSubHeight)];
            [sunDayView setFrame:CGRectMake(0, perSubHeight * 3, perSubWidth, perSubHeight)];
            
        } else {
            
            [sunDayView setFrame:CGRectMake(0, 0, perSubWidth, perSubHeight)];
            [monthDayView setFrame:CGRectMake(perSubWidth, 0, perSubWidth, perSubHeight)];
            [tuesDayView setFrame:CGRectMake(0, perSubHeight, perSubWidth, perSubHeight)];
            [wensDayView setFrame:CGRectMake(perSubWidth, perSubHeight, perSubWidth, perSubHeight)];
            [thursDayView setFrame:CGRectMake(0, perSubHeight * 2, perSubWidth, perSubHeight)];
            [friDayView setFrame:CGRectMake(perSubWidth, perSubHeight * 2, perSubWidth, perSubHeight)];
            [satDayView setFrame:CGRectMake(0, perSubHeight * 3, perSubWidth, perSubHeight)];
            
        }
         weekMapView = [[CurrentMonthMap alloc] init];
        [weekMapView setFrame:CGRectMake(perSubWidth, perSubHeight * 3, perSubWidth, perSubHeight)];
        
        sunDayView.delegate = self;
        monthDayView.delegate = self;
        tuesDayView.delegate = self;
        wensDayView.delegate = self;
        thursDayView.delegate = self;
        friDayView.delegate = self;
        
        satDayView.delegate = self;
        sunDayView.tag = 0;
        monthDayView.tag = 1;
        tuesDayView.tag = 2;
        wensDayView.tag = 3;
        thursDayView.tag = 4;
        friDayView.tag = 5;
        satDayView.tag = 6;
        weekMapView.delegate = self;
        
        [_m_containerScroller setContentSize:CGSizeMake(perSubWidth * 2, perSubHeight * 4 + 70)];
        [_m_containerScroller addSubview:sunDayView];
        [_m_containerScroller addSubview:monthDayView];
        [_m_containerScroller addSubview:tuesDayView];
        [_m_containerScroller addSubview:wensDayView];
        [_m_containerScroller addSubview:thursDayView];
        [_m_containerScroller addSubview:friDayView];
        [_m_containerScroller addSubview:satDayView];
        
        if ([dataKeeper.m_mySettingInfo.startweek integerValue] == 0) {
            [_m_containerScroller bringSubviewToFront: sunDayView];
            
        }

        [_m_containerScroller addSubview:weekMapView];
        
    } else {

        if ([dataKeeper.m_mySettingInfo.startweek integerValue] == 0) {
            
            [monthDayView setFrame:CGRectMake(0, 0, perSubWidth, perSubHeight)];
            [tuesDayView setFrame:CGRectMake(perSubWidth, 0, perSubWidth, perSubHeight)];
            [wensDayView setFrame:CGRectMake(0, perSubHeight, perSubWidth, perSubHeight)];
            [thursDayView setFrame:CGRectMake(perSubWidth, perSubHeight, perSubWidth, perSubHeight)];
            [friDayView setFrame:CGRectMake(0, perSubHeight * 2, perSubWidth, perSubHeight)];
            [satDayView setFrame:CGRectMake(perSubWidth, perSubHeight * 2, perSubWidth, perSubHeight)];
            [sunDayView setFrame:CGRectMake(0, perSubHeight * 3, perSubWidth, perSubHeight)];
            
        } else {
            
            [sunDayView setFrame:CGRectMake(0, 0, perSubWidth, perSubHeight)];
            [monthDayView setFrame:CGRectMake(perSubWidth, 0, perSubWidth, perSubHeight)];
            [tuesDayView setFrame:CGRectMake(0, perSubHeight, perSubWidth, perSubHeight)];
            [wensDayView setFrame:CGRectMake(perSubWidth, perSubHeight, perSubWidth, perSubHeight)];
            [thursDayView setFrame:CGRectMake(0, perSubHeight * 2, perSubWidth, perSubHeight)];
            [friDayView setFrame:CGRectMake(perSubWidth, perSubHeight * 2, perSubWidth, perSubHeight)];
            [satDayView setFrame:CGRectMake(0, perSubHeight * 3, perSubWidth, perSubHeight)];
            
        }
    }
    
    NSMutableArray *weekEvents = [NSMutableArray new];
    NSMutableArray *weekdays = [[NSMutableArray alloc] init];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:today];
    
    
    NSDate *todayDate = [NSDate date];
    
    [sunDayView setSelect: NO];
    [monthDayView setSelect: NO];
    [tuesDayView setSelect: NO];
    [wensDayView setSelect: NO];
    [thursDayView setSelect: NO];
    [friDayView setSelect: NO];
    [satDayView setSelect: NO];

    
    for (int i = 1; i <= 7 ;i++) {
        NSMutableArray * weekdayEvent = [NSMutableArray new];
        
        NSDate * weekDay;
        
        if (i == 1 && [dataKeeper.m_mySettingInfo.startweek integerValue] == 0) {
            weekDay = [today dateByAddingTimeInterval:((8 - [comp weekday]) * 24 * 60 * 60)];
        } else {
            weekDay = [today dateByAddingTimeInterval:((i - [comp weekday]) * 24 * 60 * 60)];
        }
        
        if (i == 1) {
            NSLog(@"Current Date = %@", weekDay);
        }
        
        weekdayEvent = [[DBConnector new] getEventsAt:weekDay userID:_m_strUserId];
        NSDateFormatter * dateformatter = [NSDateFormatter new];
        [dateformatter setDateFormat:dataKeeper.m_mySettingInfo.dateformat];
        NSString * dateString = [dateformatter stringFromDate:weekDay];
        dateformatter.dateFormat = @"EE";
        NSString * dayString = [[dateformatter stringFromDate:weekDay] capitalizedString];
        [weekdays addObject:[NSString stringWithFormat:@"%@ %@", dayString, dateString]];
        
        [weekEvents addObject:weekdayEvent];

        if ([[self normalizedDateWithDate:weekDay] isEqualToDate: [self normalizedDateWithDate: todayDate]]) {
            
            if (i == 1) {
                [sunDayView setSelect: YES];
            } else if (i == 2) {
                [monthDayView setSelect: YES];
            } else if (i == 3) {
                [tuesDayView setSelect: YES];
            } else if (i == 4) {
                [wensDayView setSelect: YES];
            } else if (i == 5) {
                [thursDayView setSelect: YES];
            } else if (i == 6) {
                [friDayView setSelect: YES];
            } else {
                [satDayView setSelect: YES];
            }
        }
    }
    
    [sunDayView setTitle:[weekdays objectAtIndex:0]];
    [monthDayView setTitle:[weekdays objectAtIndex:1]];
    [tuesDayView setTitle:[weekdays objectAtIndex:2]];
    [wensDayView setTitle:[weekdays objectAtIndex:3]];
    [thursDayView setTitle:[weekdays objectAtIndex:4]];
    [friDayView setTitle:[weekdays objectAtIndex:5]];
    [satDayView setTitle:[weekdays objectAtIndex:6]];
    
    [sunDayView initializeWithDatas:[weekEvents objectAtIndex:0]];
    [monthDayView  initializeWithDatas:[weekEvents objectAtIndex:1]];
    [tuesDayView  initializeWithDatas:[weekEvents objectAtIndex:2]];
    [wensDayView  initializeWithDatas:[weekEvents objectAtIndex:3]];
    [thursDayView  initializeWithDatas:[weekEvents objectAtIndex:4]];
    [friDayView  initializeWithDatas:[weekEvents objectAtIndex:5]];
    [satDayView  initializeWithDatas:[weekEvents objectAtIndex:6]];
    
    [weekMapView initialize: today];
    
    m_subViewArray = [[NSMutableArray alloc] initWithObjects:sunDayView, monthDayView, tuesDayView, wensDayView, thursDayView, friDayView, satDayView, nil];
 //   [sunDayView setSelect:YES];

}



- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [self reloadData: currentDate];
    
    if (_m_bFriend == NO) {
        
        //  [self.m_container setContentSize:CGSizeMake(self.m_container.frame.size.width * 3, self.m_container.frame.size.height)];
    } else {
        if ([CUtils isIphone5]) {
            [self.m_totalContainer setFrame: CGRectMake(self.m_totalContainer.frame.origin.x, self.m_totalContainer.frame.origin.y, self.m_totalContainer.frame.size.width, 516)];
        } else {
            [self.m_totalContainer setFrame: CGRectMake(self.m_totalContainer.frame.origin.x, self.m_totalContainer.frame.origin.y, self.m_totalContainer.frame.size.width, 327)];
        }
    }
    
    [self.m_totalContainer setContentSize:CGSizeMake(self.m_totalContainer.frame.size.width * 3, self.m_totalContainer.frame.size.height)];

}

- (void) viewDidAppear:(BOOL)animated {
    if (_m_bFriend == NO) {
        
        //  [self.m_container setContentSize:CGSizeMake(self.m_container.frame.size.width * 3, self.m_container.frame.size.height)];
    } else {
        [self.m_totalContainer setContentSize:CGSizeMake(self.m_totalContainer.frame.size.width * 3, self.m_totalContainer.frame.size.height)];
    }
    
}

- (void) gotoToday {
    currentDate = [[NSDate date] retain];
    [self.m_totalContainer setContentOffset:CGPointMake(self.m_totalContainer.frame.size.width, 0)];
    [self reloadData:currentDate];
}

- (void)setLabel {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];

    NSDate * toDay = currentDate;
    NSDateFormatter * dateformatter = [NSDateFormatter new];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    if (_m_bFriend == NO) {
        [self setM_strUserId: dataKeeper.m_mySettingInfo.userId];
    }

    currentDate = [[NSDate date] retain];
//    [self reloadData:[NSDate date]];
    
    self.m_totalContainer.pagingEnabled = YES;
    [self.m_totalContainer setContentSize:CGSizeMake(self.m_totalContainer.frame.size.width * 3, self.m_totalContainer.frame.size.height)];
    
    UIView * firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.m_totalContainer.frame.size.width, self.m_totalContainer.frame.size.height)];
    
    [self.m_totalContainer addSubview:firstView];
    
    UIView * secondView = [[UIView alloc] initWithFrame:CGRectMake(self.m_totalContainer.frame.size.width * 2, 0, self.m_totalContainer.frame.size.width, self.m_totalContainer.frame.size.height)];
    
    [self.m_totalContainer addSubview:secondView];
    
    [self.m_containerScroller setFrame:CGRectMake(self.m_totalContainer.frame.size.width, 0, self.m_totalContainer.frame.size.width, self.m_totalContainer.frame.size.height)];
    
    [self.m_totalContainer setContentOffset:CGPointMake(self.m_totalContainer.frame.size.width, 0)];
    self.m_totalContainer.delegate  = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoToday) name:NOTIFICATION_TODAY object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self.m_totalContainer)
        return;
    
    int widthPoint = scrollView.contentOffset.x;
    int page = widthPoint / self.m_totalContainer.frame.size.width;
    
    if (page == 0) {
        currentDate = [[CommonApi getBeforeWeekDay:currentDate] retain];
        [self.m_totalContainer setContentOffset:CGPointMake(self.m_totalContainer.frame.size.width, 0)];
        [self reloadData:currentDate];
    } else if (page == 2) {
        currentDate = [[CommonApi getAfterWekDay:currentDate] retain];
        [self.m_totalContainer setContentOffset:CGPointMake(self.m_totalContainer.frame.size.width, 0)];
        [self reloadData:currentDate];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_containerScroller release];
    [_m_totalContainer release];
    [_m_imgViewProfile release];
    
    if (_m_strUserId != nil) {
        [_m_strUserId release];
    }
    
    [super dealloc];
}

-(NSDate*)normalizedDateWithDate:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate: date];
    return [calendar dateFromComponents:components]; // NB calendar_ must be initialized
}


- (void)SubWeeklyDayViewDelegate_SelectItem:(int)idx {
    EventDetailViewController * controller = [[EventDetailViewController alloc]initWithNibName:@"EventDetailViewController" bundle:nil];
    [controller initItem:[[DBConnector new] getEventFromID:idx]];
    [self.navigationController pushViewController: controller animated: YES];
    
    [controller release];
    
}

- (void)SubWeeklyDayViewDelegate_selectedAt:(int)tag {
    
    for (SubWeeklyDayView * subView in m_subViewArray) {
        if (subView.tag == tag) {
            [subView setSelect:YES];
        } else {
            [subView setSelect:NO];
        }
    }
    
    [weekMapView setSeleced:NO];
}

- (void)CurrentMonthMapDelegate_selected {
    
    for (SubWeeklyDayView * subView in m_subViewArray) {
        [subView setSelect:NO];
    }
    
    [weekMapView setSeleced:YES];
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

@end
