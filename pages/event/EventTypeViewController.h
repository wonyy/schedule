//
//  EventTypeViewController.h
//  Schedule
//
//  Created by TanLong on 11/1/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EventTypeViewControllerDelegate

- (void)EventTypeEdited:(NSString *)eventtype;

@end

@interface EventTypeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSString * eventType;
    
    NSTimer *m_timer;


}

@property (nonatomic, retain) id <EventTypeViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;

@property (retain, nonatomic) IBOutlet UITableView *tblView;


- (IBAction)onCancel:(id)sender;


@end
