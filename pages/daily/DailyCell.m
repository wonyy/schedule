//
//  DailyCell.m
//  Schedule
//
//  Created by Galaxy39 on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "DailyCell.h"
#import "UIColor+expanded.h"

@implementation DailyCell

- (id)init
{
    NSArray * array;
    array = [[NSBundle mainBundle] loadNibNamed:@"DailyCell" owner:nil options:nil];
    self = [array objectAtIndex:0];
    if (self) {
        firstTasks = [NSMutableArray new];
        secondTasks = [NSMutableArray new];
        
        
    }
    return self;
}

- (void)setHour:(int)hour {
    currentHour = hour;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)setTitle:(NSString *)title {
    [_lbl_title setText:title];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        NSInteger nMin = (([sender locationInView:self].y / self.frame.size.height) * 60);
        [self.delegate DailyCellDoubleTap: [NSString stringWithFormat:@"%02d:%d", currentHour, nMin]];
        // handling code
    }
}

- (void)addTask:(NSDate*)date :(NSString*)title :(UIColor*)color {
    
    CGSize cellSize = [[CellOfDaily alloc] init].frame.size;
    
    NSDate *currentDate = date;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:currentDate]; // Get necessary date components
    
    int hour = [components hour]; // gives you year
    int minutes = [components minute];
    
    if (currentHour != hour)
        return;
    if (minutes < 30) {
        int count = [firstTasks count];
        int stPos = count * cellSize.width;
        CellOfDaily * cellView = [[CellOfDaily alloc] init];
        [cellView setFrame:CGRectMake(stPos, 0, cellSize.width, cellSize.height)];
        [_m_halfContainer addSubview:cellView];
        [firstTasks addObject:@"0"];
        [cellView setTitle:[NSString stringWithFormat:@"%d:%d %@", hour, minutes, title]];
        [cellView setColor:color];
    } else {
        int count = [secondTasks count];
        int stPos = count * cellSize.width;
        CellOfDaily * cellView = [[CellOfDaily alloc] init];
        [cellView setFrame:CGRectMake(stPos, 0, cellSize.width, cellSize.height)];
        [_m_secondContainer addSubview:cellView];
        [secondTasks addObject:@"0"];
        [cellView setTitle:[NSString stringWithFormat:@"%d:%d %@", hour, minutes, title]];
        [cellView setColor:color];
    }
}

- (void)addTask:(ScheduleItem*) item {
    NSDate * date = [CommonApi getDateTimeFromString:item.eventStartDay];
    NSString *title = item.eventName;
    
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
    

    
    UIColor *color = eventColor;
    CGSize cellSize = [[CellOfDaily alloc] init].frame.size;
    
    NSDate *currentDate = date;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:currentDate]; // Get necessary date components
    
    int hour = [components hour]; // gives you year
    int minutes = [components minute];
    
    if (currentHour != hour)
        return;
    
    if (minutes < 30) {
        int count = [firstTasks count];
        int stPos = count * cellSize.width;
        CellOfDaily * cellView = [[CellOfDaily alloc] init];
        cellView.delegate = self;
        [cellView setFrame:CGRectMake(stPos, 0, cellSize.width, cellSize.height)];
        [_m_halfContainer addSubview:cellView];
        [firstTasks addObject:@"0"];
        [cellView setTitle:[NSString stringWithFormat:@"%d:%d %@",hour,minutes,title]];
        [cellView setColor:color];
        [cellView setEventID:item.eventId];
    } else {
        int count = [secondTasks count];
        int stPos = count * cellSize.width;
        CellOfDaily * cellView = [[CellOfDaily alloc] init];
        cellView.delegate = self;
        [cellView setFrame:CGRectMake(stPos, 0, cellSize.width, cellSize.height)];
        [_m_secondContainer addSubview:cellView];
        [secondTasks addObject:@"0"];
        [cellView setTitle:[NSString stringWithFormat:@"%d:%d %@", hour, minutes, title]];
        [cellView setColor:color];
        [cellView setEventID:item.eventId];
    }
}

- (void)CellOfDailyDelegate_Selected:(int)idx {
    [self.delegate DailyCellDelegate_Seleted:idx];
}

- (void)dealloc {
    [_lbl_title release];
    [_m_halfContainer release];
    [_m_secondContainer release];
    [super dealloc];
}
@end
