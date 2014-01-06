//
//  StartEndDateViewController.h
//  Schedule
//
//  Created by Galaxy39 on 8/19/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StartEndDateViewControllerDelegate
- (void)StartEndDateEdited:(NSDate *)sDate : (NSDate *)eDate;
@end

@interface StartEndDateViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    NSDate * sDate;
    NSDate * eDate;
    int selectedIndex;
    
    NSTimer *m_timer;

}

@property (nonatomic, retain) id<StartEndDateViewControllerDelegate>delegate;
@property (retain, nonatomic) IBOutlet UITableView *tblView;
@property (retain, nonatomic) IBOutlet UISegmentedControl *interval;
@property (retain, nonatomic) IBOutlet UIDatePicker *picker;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;


- (IBAction)intervalChanged:(id)sender;
- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;
- (IBAction)dateChanged:(id)sender;

- (void) SetDates: (NSDate *) startDate end: (NSDate *) endDate;

@end
