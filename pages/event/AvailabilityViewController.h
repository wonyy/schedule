//
//  AvailabilityViewController.h
//  Schedule
//
//  Created by suhae on 8/17/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AvailabilityViewControllerDelegate

- (void)AvailabilityEdited:(NSString *)avail;

@end

@interface AvailabilityViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSString * avail;
    
    NSTimer *m_timer;

}

@property (retain, nonatomic) IBOutlet UITableView *tblView;
@property (nonatomic, retain) id<AvailabilityViewControllerDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;


- (IBAction)onCancel:(id)sender;

@end