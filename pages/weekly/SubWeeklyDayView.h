//
//  SubWeeklyDayView.h
//  Schedule
//
//  Created by Galaxy39 on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekTaskCell.h"


@protocol SubWeeklyDayViewDelegate

- (void)SubWeeklyDayViewDelegate_selectedAt:(int)tag;
- (void)SubWeeklyDayViewDelegate_SelectItem:(int)idx;

@end

@interface SubWeeklyDayView : UIView <UITableViewDelegate, UITableViewDataSource, WeekTaskCellDelegate> {
    NSMutableArray * m_showData;
    SettingItem *settingItem;
}

@property (nonatomic,retain)id<SubWeeklyDayViewDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIButton *m_titleButton;
@property (retain, nonatomic) IBOutlet UIImageView *m_bgImage;
@property (retain, nonatomic) IBOutlet UITableView *m_containerView;

- (void)initializeWithDatas:(NSMutableArray*)data;
- (void)setTitle:(NSString*)title;

- (void)setSelect:(BOOL)res;
- (IBAction)onSelected:(id)sender;

@end
