//
//  CurrentMonthMap.h
//  Schedule
//
//  Created by Galaxy39 on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CurrentMonthMapDelegate
-(void)CurrentMonthMapDelegate_selected;
@end

@interface CurrentMonthMap : UIView
{
    NSMutableArray * m_weekNumLblArray;
    NSMutableArray * m_daysLblArray;
}

- (void)initialize : (NSDate *) date;

@property (nonatomic,retain)id<CurrentMonthMapDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIButton *btn_title;

@property (retain, nonatomic) IBOutlet UILabel *lbl_0_14;
@property (retain, nonatomic) IBOutlet UILabel *lbl_1_14;
@property (retain, nonatomic) IBOutlet UILabel *lbl_2_14;
@property (retain, nonatomic) IBOutlet UILabel *lbl_3_14;
@property (retain, nonatomic) IBOutlet UILabel *lbl_4_14;
@property (retain, nonatomic) IBOutlet UILabel *lbl_00;
@property (retain, nonatomic) IBOutlet UILabel *lbl_01;
@property (retain, nonatomic) IBOutlet UILabel *lbl_02;
@property (retain, nonatomic) IBOutlet UILabel *lbl_03;
@property (retain, nonatomic) IBOutlet UILabel *lbl_04;
@property (retain, nonatomic) IBOutlet UILabel *lbl_05;
@property (retain, nonatomic) IBOutlet UILabel *lbl_06;
@property (retain, nonatomic) IBOutlet UILabel *lbl_07;
@property (retain, nonatomic) IBOutlet UILabel *lbl_08;
@property (retain, nonatomic) IBOutlet UILabel *lbl_09;
@property (retain, nonatomic) IBOutlet UILabel *lbl_10;
@property (retain, nonatomic) IBOutlet UILabel *lbl_11;
@property (retain, nonatomic) IBOutlet UILabel *lbl_12;
@property (retain, nonatomic) IBOutlet UILabel *lbl_13;
@property (retain, nonatomic) IBOutlet UILabel *lbl_14;
@property (retain, nonatomic) IBOutlet UILabel *lbl_15;
@property (retain, nonatomic) IBOutlet UILabel *lbl_16;
@property (retain, nonatomic) IBOutlet UILabel *lbl_17;
@property (retain, nonatomic) IBOutlet UILabel *lbl_18;
@property (retain, nonatomic) IBOutlet UILabel *lbl_19;
@property (retain, nonatomic) IBOutlet UILabel *lbl_20;
@property (retain, nonatomic) IBOutlet UILabel *lbl_21;
@property (retain, nonatomic) IBOutlet UILabel *lbl_22;
@property (retain, nonatomic) IBOutlet UILabel *lbl_23;
@property (retain, nonatomic) IBOutlet UILabel *lbl_24;
@property (retain, nonatomic) IBOutlet UILabel *lbl_25;
@property (retain, nonatomic) IBOutlet UILabel *lbl_26;
@property (retain, nonatomic) IBOutlet UILabel *lbl_27;
@property (retain, nonatomic) IBOutlet UILabel *lbl_28;
@property (retain, nonatomic) IBOutlet UILabel *lbl_29;
@property (retain, nonatomic) IBOutlet UILabel *lbl_30;
@property (retain, nonatomic) IBOutlet UILabel *lbl_31;
@property (retain, nonatomic) IBOutlet UILabel *lbl_32;
@property (retain, nonatomic) IBOutlet UILabel *lbl_33;
@property (retain, nonatomic) IBOutlet UILabel *lbl_34;
@property (retain, nonatomic) IBOutlet UILabel *lbl_35;
@property (retain, nonatomic) IBOutlet UILabel *lbl_36;
@property (retain, nonatomic) IBOutlet UILabel *lbl_37;
@property (retain, nonatomic) IBOutlet UILabel *lbl_38;
@property (retain, nonatomic) IBOutlet UILabel *lbl_39;
@property (retain, nonatomic) IBOutlet UILabel *lbl_40;
@property (retain, nonatomic) IBOutlet UILabel *lbl_41;


- (void)setSeleced:(BOOL)res;
- (IBAction)onSelected:(id)sender;

@end
