//
//  EventCellView.h
//  Schedule
//
//  Created by Galaxy39 on 8/18/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleItem.h"

@interface EventCellView : UIView

- (void)setInfo:(ScheduleItem *)item;

@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UILabel *lblFrom;
@property (retain, nonatomic) IBOutlet UILabel *lblTo;

@property (retain, nonatomic) IBOutlet UIView *m_eventTypeView;

@property (retain, nonatomic) ScheduleItem* cellItem;

@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile1;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile2;

@property (retain, nonatomic) NSString *m_strImgURL1;
@property (retain, nonatomic) NSString *m_strImgURL2;

@property (retain, nonatomic) IBOutlet UIButton *m_btnSeeAll;

@end
