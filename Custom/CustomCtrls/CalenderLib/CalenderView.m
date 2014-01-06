//
//  CalenderView.m
//  HuaweiMeeting
//
//  Created by hana on 8/16/12.
//  Copyright (c) 2012 Twin-Fish. All rights reserved.
//

#import "CalenderView.h"
#import "EventKitDataSource.h"
#import "Kal.h"
#import "KalDate.h"
#import "QuartzCore/QuartzCore.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@implementation CalenderView

@synthesize calendarDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {      
    }
    return self;
}
- (id)initWithTabSize:(CGSize)tabSize dlgSize:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        kal = [[KalViewController alloc] initWithTabSize:tabSize withViewSize:frame.size withParentDelegate:self];
        kal.title = @"NativeCal";
        kal.delegate = self;
        dataSource = [[EventKitDataSource alloc] init];
        kal.dataSource = dataSource;
        [self addSubview:kal.view];        
    }
    return self;

}

-(id)initPopUpCalender:(CGSize)tabSize dlgSize:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius = 10;
        kal = [[KalViewController alloc] initPopWithTabSize:tabSize withViewSize:frame.size withParentDelegate:self];
        kal.title = @"PopCal";
        kal.delegate = self;
        dataSource = [[EventKitDataSource alloc] init];
        kal.dataSource = dataSource;
        [self addSubview:kal.view];        
    }
    return self;

}

-(KalViewController*)getKalViewController
{
    return kal;
}

- (void)removeAllEvents
{
    [dataSource removeAllEvents];
}

- (void)addEvent:(NSString *)eventID StartTime:(NSDate *)start EndTime:(NSDate *)end
{
    [dataSource addEvent:eventID StartTime:start EndTime:end];
}

- (void)showAndSelectToday
{
    [kal showAndSelectDate:[NSDate date]];
}

- (void)dateWasSelected:(KalDate *)date
{
    if (date == nil)
        return;
    NSDate * mDate = [date nsDate];
//    if ([kal.title isEqualToString:@"NativeCal"] && ([dataSource hasEventInDate:mDate] == NO))
//        return;
    
    if ([calendarDelegate respondsToSelector:@selector(selectDate:)] == YES)
        [calendarDelegate selectDate:mDate];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Display a details screen for the selected event/row.
    EKEventViewController *vc = [[[EKEventViewController alloc] init] autorelease];
    vc.event = [dataSource eventAtIndexPath:indexPath];
    vc.allowsEditing = NO;
//    [navController pushViewController:vc animated:YES];
}


@end
