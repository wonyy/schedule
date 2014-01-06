//
//  RecurrenceViewController.h
//  Schedule
//
//  Created by suhae on 8/17/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecurrenceViewControllerDelegate

- (void)RecurrenceEdited:(NSString*)repeats;

@end

@interface RecurrenceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSString * repeates;
    NSTimer *m_timer;

}

@property (retain, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, retain) id<RecurrenceViewControllerDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;

- (IBAction)onCancel:(id)sender;

@end