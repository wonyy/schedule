//
//  CheckCell.h
//  Schedule
//
//  Created by TanLong on 10/29/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSwitch.h"

@interface CheckCell : UITableViewCell

@property (nonatomic, retain) CustomSwitch *switchCtrl;
@property (retain, nonatomic) IBOutlet UILabel *m_labelTitle;


@end
