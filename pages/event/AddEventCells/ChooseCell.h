//
//  ChooseCell.h
//  Schedule
//
//  Created by TanLong on 10/29/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *m_labelName;
@property (retain, nonatomic) IBOutlet UILabel *m_labelValue;

@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewGuest1;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewGuest2;

@property (retain, nonatomic) NSString *m_strImgURL1;
@property (retain, nonatomic) NSString *m_strImgURL2;

- (void) setEnable: (BOOL) bEnable;

- (void) refreshImage1;
- (void) refreshImage2;

@end
