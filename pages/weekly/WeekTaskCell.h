//
//  WeekTaskCell.h
//  Schedule
//
//  Created by Galaxy39 on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeekTaskCellDelegate

- (void)WeekTaskCellDelegate_Seleted:(int)idx;

@end

@interface WeekTaskCell : UITableViewCell {
    int eventID;
}

@property (retain, nonatomic) id<WeekTaskCellDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *lblTime;
@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewBackground;

- (void)setInfo:(NSString *)time :(NSString*)title :(UIColor*)color :(int)idx;

@end
