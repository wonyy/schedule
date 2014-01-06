//
//  DailyCell.h
//  Schedule
//
//  Created by Galaxy39 on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellOfDaily.h"
#import "ScheduleItem.h"

@protocol DailyCellDelegate

- (void)DailyCellDelegate_Seleted:(int)idx;
- (void)DailyCellDoubleTap: (NSString *) strCurDateTime;

@end

@interface DailyCell : UIView <CellOfDailyDelegate> {
    NSMutableArray *firstTasks;
    NSMutableArray *secondTasks;
    int currentHour;
}

@property (retain, nonatomic) id<DailyCellDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *lbl_title;
@property (retain, nonatomic) IBOutlet UIView *m_halfContainer;
@property (retain, nonatomic) IBOutlet UIView *m_secondContainer;

- (void)setTitle:(NSString*)title;
- (void)setHour:(int)hour;
- (void)addTask:(NSDate*)date :(NSString*)title :(UIColor*)color;
- (void)addTask:(ScheduleItem*)item;

@end
