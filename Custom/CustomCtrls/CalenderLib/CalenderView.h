//
//  CalenderView.h
//  HuaweiMeeting
//
//  Created by hana on 8/16/12.
//  Copyright (c) 2012 Twin-Fish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KalViewController.h"

@protocol CalendarDelegate;

@interface CalenderView : UIView <UITableViewDelegate, KalViewControllerDelegate>
{
    KalViewController *kal;
    id dataSource;
    id<CalendarDelegate> calendarDelegate;
}

@property (nonatomic, retain) id<CalendarDelegate> calendarDelegate;

- (id)initWithTabSize:(CGSize)tabSize dlgSize:(CGRect)frame;
- (id)initPopUpCalender:(CGSize)tabSize dlgSize:(CGRect)frame;
- (void)removeAllEvents;
- (void)addEvent:(NSString *)eventID StartTime:(NSDate *)start EndTime:(NSDate *)end;
- (KalViewController*)getKalViewController;
@end

@protocol CalendarDelegate <NSObject>

@optional
- (void)selectDate:(NSDate *)date;

@end