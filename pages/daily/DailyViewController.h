//
//  DailyViewController.h
//  Schedule
//
//  Created by suhae on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyCell.h"
#import "UIDragTableView.h"

@interface DailyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, DailyCellDelegate, UIScrollViewDelegate, UIDragTableViewDelegate, MBProgressHUDDelegate>
{
    NSMutableArray * m_showData;
    NSMutableArray * m_aryEvent;
    
    NSDate * currentDate;
    
    UITableView * firstTable;
    UITableView * secondTable;
    
    NSTimer *m_timer;
    
    MBProgressHUD *HUD;
    
    NSInteger m_nCurIndex;

    
}
@property (retain, nonatomic) NSString *m_strUserId;
@property (nonatomic) BOOL m_bFriend;
@property (retain, nonatomic) IBOutlet UIDragTableView *m_dataContainer;
@property (retain, nonatomic) IBOutlet UILabel *lbl_weekNumber;
@property (retain, nonatomic) IBOutlet UILabel *lbl_TodayDate;
@property (retain, nonatomic) IBOutlet UILabel *lbl_time;
@property (retain, nonatomic) IBOutlet UIScrollView *m_container;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;



@end
