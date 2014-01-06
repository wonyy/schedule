//
//  ReminderViewController.h
//  Schedule
//
//  Created by suhae on 8/17/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReminderViewControllerDelegate

- (void)ReminderEdited:(NSString *)interval;

@end

@interface ReminderViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    int interval;
    
    NSTimer *m_timer;
    
    NSArray *arrayReminders;
    NSArray *arrayReminderValues;
}

@property (retain, nonatomic) NSString *m_strInitReminder;

@property (retain, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, retain) id<ReminderViewControllerDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;

- (IBAction)onCancel:(id)sender;

@end
