//
//  FriendsViewController.h
//  Schedule
//
//  Created by wonymini on 9/26/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsCell.h"

typedef enum _eSortType {
    SORT_FIRSTNAME = 0,
    SORT_AVAILABLE,
    SORT_GROUP,
    SORT_TYPE_SIZE,
} SortType;

@interface FriendsViewController : UIViewController <MBProgressHUDDelegate, UIAlertViewDelegate> {
    
    NSMutableArray * m_aryFriends;
    MBProgressHUD *HUD;
    
    BOOL m_bType;
    
    NSDictionary *m_dictCurrentUser;
    
    SortType m_sortType;
    NSArray *m_sortArrays;
    
    NSTimer *m_timer;
}

@property (retain, nonatomic) IBOutlet FriendsCell *m_friendsCell;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;

@property (retain, nonatomic) IBOutlet UITextField *m_textfieldSearch;
@property (retain, nonatomic) IBOutlet UIButton *m_btnSort;
@property (retain, nonatomic) IBOutlet UITableView *m_tableView;

@property (retain, nonatomic) IBOutlet UIView *m_viewPicker;
@property (retain, nonatomic) IBOutlet UIPickerView *m_pickerView;

- (IBAction)onTouchPickerCancelBtn:(id)sender;
- (IBAction)onTouchPickerOkBtn:(id)sender;

- (IBAction)onTouchSortBtn:(id)sender;
- (IBAction)onSearch:(id)sender;


@end
