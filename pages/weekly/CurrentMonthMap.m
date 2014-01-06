//
//  CurrentMonthMap.m
//  Schedule
//
//  Created by Galaxy39 on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "CurrentMonthMap.h"

@implementation CurrentMonthMap
@synthesize delegate;

- (id)init {
    NSArray * array;
    array = [[NSBundle mainBundle] loadNibNamed:@"CurrentMonthMap" owner:nil options:nil];
    self = [array objectAtIndex:0];
    if (self) {
    }
    return self;
}

- (NSString *)getMonthString:(NSDate*)date {
    NSDateFormatter * formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:date];
}

- (int)getWeekCount:(NSDate*)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    gregorian.firstWeekday = 2;
    NSDateComponents *components = [gregorian components:NSWeekOfYearCalendarUnit fromDate:date];
    NSUInteger weekOfYear = [components weekOfYear];
    return weekOfYear;
}

- (int)getMonthDayCount:(int)month {
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comps = [[[NSDateComponents alloc] init] autorelease];
    
    // Set your month here
    [comps setMonth:month];
    
    NSRange range = [cal rangeOfUnit:NSDayCalendarUnit
                              inUnit:NSMonthCalendarUnit
                             forDate:[cal dateFromComponents:comps]];
    return range.length;
}

- (void)initialize : (NSDate *) date {
    m_weekNumLblArray = [[NSMutableArray alloc] initWithObjects:_lbl_0_14,
                                                                _lbl_1_14,
                                                                _lbl_2_14,
                                                                _lbl_3_14,
                                                                _lbl_4_14,  nil];
    m_daysLblArray = [[NSMutableArray alloc] initWithObjects:_lbl_00,
                                                              _lbl_01,
                                                              _lbl_02,
                                                              _lbl_03,
                                                              _lbl_04,
                                                              _lbl_05,
                                                              _lbl_06,
                                                              _lbl_07,
                                                              _lbl_08,
                                                              _lbl_09,
                                                              _lbl_10,
                                                              _lbl_11,
                                                              _lbl_12,
                                                              _lbl_13,
                                                              _lbl_14,
                                                              _lbl_15,
                                                              _lbl_16,
                                                              _lbl_17,
                                                              _lbl_18,
                                                              _lbl_19,
                                                              _lbl_20,
                                                              _lbl_21,
                                                              _lbl_22,
                                                              _lbl_23,
                                                              _lbl_24,
                                                              _lbl_25,
                                                              _lbl_26,
                                                              _lbl_27,
                                                              _lbl_28,
                                                              _lbl_29,
                                                              _lbl_30,
                                                              _lbl_31,
                                                              _lbl_32,
                                                              _lbl_33,
                                                              _lbl_34,
                                                              _lbl_35,
                                                              _lbl_36,
                                                              _lbl_37,
                                                              _lbl_38,
                                                              _lbl_39,
                                                              _lbl_40,
                                                              _lbl_41, nil];
    
    NSDate *currentDate = nil;
    
    if (date != nil) {
        currentDate = date;
    } else {
        currentDate = [NSDate date];
    }
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:currentDate]; // Get necessary date components
    
    int month = [components month]; //gives you month
    int year = [components year]; // gives you year
    int day = [components day]; // gives you day
    
    NSDateFormatter * dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate * monthFirstDay = [dateformatter dateFromString:[NSString stringWithFormat:@"%d-%d-01 00:00:00", year, month]];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:monthFirstDay];
    
    int weekDayNumber = [comp weekday];
    int firstDayPos;
    int firstDayofCurrentWeek;
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    if ([dataKeeper.m_mySettingInfo.startweek integerValue] == 0) {
        firstDayPos = (weekDayNumber + 12) % 7;
        firstDayofCurrentWeek = day - [components weekday] + 1;

    } else {
        firstDayPos = weekDayNumber - 1;
        firstDayofCurrentWeek = day - [components weekday];
    }
    
    int monthDayCount = [self getMonthDayCount:month];
    
    for (int i = 0; i < monthDayCount; i++) {
        UILabel * label = [m_daysLblArray objectAtIndex:firstDayPos + i];
        
        [label setText:[NSString stringWithFormat:@"%d", i + 1]];
        
        
        // if sunday
        if ([dataKeeper.m_mySettingInfo.startweek integerValue] == 0 && (firstDayPos + i) % 7 == 6) {
            [label setTextColor: [UIColor redColor]];
            
        } else if ([dataKeeper.m_mySettingInfo.startweek integerValue] == 1 && (firstDayPos + i) % 7 == 0) {
            [label setTextColor: [UIColor redColor]];
        }
        // else
        else {
            
            if (i >= firstDayofCurrentWeek && i < firstDayofCurrentWeek + 7) {
                [label setTextColor: [UIColor blueColor]];
            } else {
                [label setTextColor: [UIColor grayColor]];
            }
        }
    }
    
    for (int i = 0; i < firstDayPos; i++) {
        UILabel *label = [m_daysLblArray objectAtIndex:i];
        [label setText:[NSString stringWithFormat:@""]];
    }
    
    for (int i = firstDayPos + monthDayCount; i <= 41; i++) {
        UILabel *label = [m_daysLblArray objectAtIndex:i];
        [label setText:[NSString stringWithFormat:@""]];
    }
    
    [_btn_title setTitle:[NSString stringWithFormat:@"%@ %d", [self getMonthString:currentDate], year] forState:UIControlStateNormal];
}

- (void)dealloc {
    [_btn_title release];
    [_lbl_0_14 release];
    [_lbl_1_14 release];
    [_lbl_2_14 release];
    [_lbl_3_14 release];
    [_lbl_4_14 release];
    [_lbl_00 release];
    [_lbl_01 release];
    [_lbl_02 release];
    [_lbl_03 release];
    [_lbl_04 release];
    [_lbl_05 release];
    [_lbl_06 release];
    [_lbl_07 release];
    [_lbl_08 release];
    [_lbl_09 release];
    [_lbl_10 release];
    [_lbl_11 release];
    [_lbl_12 release];
    [_lbl_13 release];
    [_lbl_14 release];
    [_lbl_15 release];
    [_lbl_16 release];
    [_lbl_17 release];
    [_lbl_18 release];
    [_lbl_19 release];
    [_lbl_20 release];
    [_lbl_21 release];
    [_lbl_22 release];
    [_lbl_23 release];
    [_lbl_24 release];
    [_lbl_25 release];
    [_lbl_26 release];
    [_lbl_27 release];
    [_lbl_28 release];
    [_lbl_29 release];
    [_lbl_30 release];
    [_lbl_31 release];
    [_lbl_32 release];
    [_lbl_33 release];
    [_lbl_34 release];
    [_lbl_35 release];
    [_lbl_36 release];
    [_lbl_37 release];
    [_lbl_38 release];
    [_lbl_39 release];
    [_lbl_40 release];
    [_lbl_41 release];
    [super dealloc];
}

- (IBAction)onSelected:(id)sender {
//    [self.delegate CurrentMonthMapDelegate_selected];
}

- (void)setSeleced:(BOOL)res {
    [_btn_title setSelected:res];
}

@end
