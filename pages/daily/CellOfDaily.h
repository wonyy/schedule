//
//  CellOfDaily.h
//  Schedule
//
//  Created by Galaxy39 on 8/17/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellOfDailyDelegate

- (void)CellOfDailyDelegate_Selected:(int)idx;

@end

@interface CellOfDaily : UIView {
    int eventID;
}
@property (retain, nonatomic) id<CellOfDailyDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *lbl_titleLabel;

- (void)setTitle:(NSString*)title;
- (void)setColor:(UIColor*)color;
- (void)setEventID:(int)idx;
@end
