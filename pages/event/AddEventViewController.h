//
//  AddEventViewController.h
//  Schedule
//
//  Created by suhae on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleItem.h"
#import "InviteGuestViewController.h"
#import "StartEndDateViewController.h"
#import "ReminderViewController.h"
#import "RecurrenceViewController.h"
#import "RecurringEndDateViewController.h"
#import "AvailabilityViewController.h"
#import "EventTypeViewController.h"
#import "NoteViewController.h"
#import "CSearchAddressViewController.h"

#import "EmptyCell.h"
#import "TextInputCell.h"
#import "DateTimeCell.h"
#import "CheckCell.h"
#import "ChooseCell.h"
#import "NoteCell.h"
#import "DeleteCell.h"

@interface AddEventViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, InviteGuestViewControllerDelegate, StartEndDateViewControllerDelegate,  ReminderViewControllerDelegate, RecurrenceViewControllerDelegate, RecurringEndDateViewControllerDelegate, AvailabilityViewControllerDelegate, EventTypeViewControllerDelegate, NoteViewControllerDelegate, UITextFieldDelegate, MBProgressHUDDelegate, CustomSwitchDelegate, CSearchAddressViewControllerDelegate, UITextViewDelegate> {
    
    ScheduleItem *m_information;
    UISwitch *m_autoCheck;
    UILabel *date1;
    UILabel *date2;
    UITextField *nameField;
    UITextField *locField;
    NSString *title;
    MBProgressHUD *HUD;
    
    BOOL  m_bAllDay;
    
    NSTimer *m_timer;
    
    BOOL m_bEdit;
}

@property (retain, nonatomic) NSString *m_initDate;

@property (retain, nonatomic) IBOutlet UITableView *tblView;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;
@property (retain, nonatomic) IBOutlet EmptyCell *m_EmptyCell;
@property (retain, nonatomic) IBOutlet TextInputCell *m_TextInputCell;
@property (retain, nonatomic) IBOutlet DateTimeCell *m_DateCell;
@property (retain, nonatomic) IBOutlet CheckCell *m_CheckCell;
@property (retain, nonatomic) IBOutlet ChooseCell *m_ChooseCell;
@property (retain, nonatomic) IBOutlet NoteCell *m_NoteCell;
@property (retain, nonatomic) IBOutlet DeleteCell *m_DeleteCell;


- (IBAction)onCancel:(id)sender;
- (IBAction)onSave:(id)sender;
- (IBAction)onDeleteEventBtn:(id)sender;


- (void)initItem:(ScheduleItem *)item;

@end
