//
//  EventDetailViewController.h
//  Schedule
//
//  Created by Mountain on 10/1/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleItem.h"

@interface EventDetailViewController : UIViewController {
    ScheduleItem *m_information;
    NSTimer *m_timer;

}

@property (retain, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;

@property (retain, nonatomic) IBOutlet UILabel *m_labelEventTitle;
@property (retain, nonatomic) IBOutlet UILabel *m_labelStart;
@property (retain, nonatomic) IBOutlet UILabel *m_labelEnd;
@property (retain, nonatomic) IBOutlet UILabel *m_labelRepeats;
@property (retain, nonatomic) IBOutlet UILabel *m_labelAlert;
@property (retain, nonatomic) IBOutlet UILabel *m_labelLocation;
@property (retain, nonatomic) IBOutlet UITextView *m_textViewNote;
@property (retain, nonatomic) IBOutlet UILabel *m_labelEventType;

@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewGuest1;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewGuest2;
@property (retain, nonatomic) IBOutlet UIButton *m_btnSeeAllGuests;

@property (retain, nonatomic) NSString *m_strImgURL1;
@property (retain, nonatomic) NSString *m_strImgURL2;

- (IBAction)onTouchCancelBtn:(id)sender;
- (IBAction)onTouchEditBtn:(id)sender;
- (IBAction)onTouchLocationBtn:(id)sender;
- (IBAction)onTouchShowAllGuests:(id)sender;

- (void)initItem:(ScheduleItem *)item;

@end
