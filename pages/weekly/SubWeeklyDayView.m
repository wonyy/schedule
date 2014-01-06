//
//  SubWeeklyDayView.m
//  Schedule
//
//  Created by Galaxy39 on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "SubWeeklyDayView.h"
#import "ScheduleItem.h"
#import "UIColor+expanded.h"

@implementation SubWeeklyDayView
@synthesize delegate;

- (id)init {
    NSArray * array;
    array = [[NSBundle mainBundle] loadNibNamed:@"SubWeeklyDayView" owner:nil options:nil];
    self = [array objectAtIndex:0];
    if (self) {
    }
    return self;
}

-(void)initializeWithDatas:(NSMutableArray*)data {
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    settingItem = [[SettingItem alloc] initWithSettingItem: dataKeeper.m_mySettingInfo];
    
    m_showData = data;
    _m_containerView.dataSource = self;
    _m_containerView.delegate = self;
    [_m_containerView reloadData];
}

- (void)setTitle:(NSString*)title {
    [_m_titleButton setTitle:title forState:UIControlStateNormal];
    [_m_titleButton setTitle:title forState:UIControlStateSelected];
}

- (void)dealloc {
    [_m_titleButton release];
    [_m_bgImage release];
    [_m_containerView release];
    [settingItem release];
    [super dealloc];
}

#pragma mark -
#pragma mark table management

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [m_showData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeekTaskCell * cellView = [[[NSBundle mainBundle] loadNibNamed:@"WeekTaskCell" owner:nil options:nil] objectAtIndex:0];
    
    cellView.delegate = self;
    
    ScheduleItem * item = (ScheduleItem*)[m_showData objectAtIndex:indexPath.row];
    NSDate *currentDate = [CommonApi getDateTimeFromString:item.eventStartDay];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:currentDate]; // Get necessary date components
    int hour = [components hour]; // gives you year
    int minutes = [components minute];
    
    
    UIColor *eventColor;
    if ([item.eventType isEqualToString:@"Work"]) {
        eventColor = [UIColor colorWithHexString: [settingItem.workColor substringFromIndex:1]];
    } else if ([item.eventType isEqualToString:@"School"]) {
        eventColor = [UIColor colorWithHexString: [settingItem.schoolColor substringFromIndex:1]];
    } else if ([item.eventType isEqualToString:@"Personal"]) {
        eventColor = [UIColor colorWithHexString: [settingItem.personalColor substringFromIndex:1]];
    } else if ([item.eventType isEqualToString:@"Other"]) {
        eventColor = [UIColor colorWithHexString: [settingItem.otherColor substringFromIndex:1]];
    } else {
        eventColor = [UIColor colorWithHexString: [settingItem.otherColor substringFromIndex:1]];
    }

    [cellView setInfo:[NSString stringWithFormat:@"%d:%d", hour, minutes] : item.eventName : eventColor : item.eventId];
    
    return cellView;
}

- (void)WeekTaskCellDelegate_Seleted:(int)idx {
    [self.delegate SubWeeklyDayViewDelegate_SelectItem:idx];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



- (void)setSelect:(BOOL)res {
    [_m_titleButton setSelected:res];
    if (res)
        [_m_bgImage setImage:[UIImage imageNamed:@"red"]];
    else
        [_m_bgImage setImage:[UIImage imageNamed:@"grey"]];
}

- (IBAction)onSelected:(id)sender {
   // [self.delegate SubWeeklyDayViewDelegate_selectedAt:self.tag];
}
@end
