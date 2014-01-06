//
//  MonthlyViewController.h
//  Schedule
//
//  Created by suhae on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalenderView.h"
#import "EventCellView.h"

@interface MonthlyViewController : UIViewController<CalendarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    CalenderView * mCalenderView;
    UITableView * mTableView;
    NSMutableArray * m_showData;
    
    NSDate * m_selectedDate;
    
    NSTimer *m_timer;

}

@property (nonatomic) BOOL m_bFriend;
@property (retain, nonatomic) NSString *m_strUserId;

@property (retain, nonatomic) IBOutlet UILabel *lbl_dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;

@property (retain, nonatomic) IBOutlet UIView *m_calendarContainerView;
@property (retain, nonatomic) IBOutlet UIScrollView *m_scrolContainter;
@property (retain, nonatomic) IBOutlet UIScrollView *m_swipeContainer;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;

@end
