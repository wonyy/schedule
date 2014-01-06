//
//  RecurringEndDateViewController.h
//  Schedule
//
//  Created by TanLong on 12/24/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecurringEndDateViewControllerDelegate

- (void)EndDateEdited:(NSString*) endDate;

@end

@interface RecurringEndDateViewController : UIViewController {
    NSTimer *m_timer;
    NSDate * eDate;
    BOOL bOnDate;
    
}


@property (retain, nonatomic) id<RecurringEndDateViewControllerDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;
@property (retain, nonatomic) IBOutlet UIView *m_viewPicker;
@property (retain, nonatomic) IBOutlet UIDatePicker *m_pickerView;

- (void) SetEDate: (NSDate *) date;

- (IBAction)onTouchNavCancelBtn:(id)sender;
- (IBAction)OnDateChanged:(id)sender;

@end
