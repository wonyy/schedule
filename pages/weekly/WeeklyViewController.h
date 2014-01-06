//
//  WeeklyViewController.h
//  Schedule
//
//  Created by suhae on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubWeeklyDayView.h"
#import "CurrentMonthMap.h"

@interface WeeklyViewController : UIViewController <SubWeeklyDayViewDelegate,CurrentMonthMapDelegate, UIScrollViewDelegate>
{
    SubWeeklyDayView * sunDayView;
    SubWeeklyDayView * monthDayView;
    SubWeeklyDayView * tuesDayView;
    SubWeeklyDayView * wensDayView;
    SubWeeklyDayView * thursDayView;
    SubWeeklyDayView * friDayView;
    SubWeeklyDayView * satDayView;
    CurrentMonthMap  * weekMapView;
    NSMutableArray * m_subViewArray;
    
    NSDate * currentDate;
    
    int perSubWidth;
    int perSubHeight;
}
@property (nonatomic) BOOL m_bFriend;
@property (retain, nonatomic) NSString *m_strUserId;

@property (retain, nonatomic) IBOutlet UIScrollView *m_containerScroller;
@property (retain, nonatomic) IBOutlet UILabel *lbl_weekNumber;
@property (retain, nonatomic) IBOutlet UILabel *lbl_TodayDate;
@property (retain, nonatomic) IBOutlet UIScrollView *m_totalContainer;
@property (retain, nonatomic) IBOutlet UILabel *lbl_time;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;


@end
