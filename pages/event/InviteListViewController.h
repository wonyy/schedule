//
//  InviteListViewController.h
//  Schedule
//
//  Created by TanLong on 11/21/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GuestCell.h"

@interface InviteListViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITableView *m_tableView;

@property (retain, nonatomic) NSArray *m_arrayGuests;

@property (retain, nonatomic) IBOutlet GuestCell *m_GuestCell;


- (IBAction)onTouchNavBackBtn:(id)sender;

@end
