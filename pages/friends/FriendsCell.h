//
//  FriendsCell.h
//  Schedule
//
//  Created by Mountain on 10/1/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *m_labelName;
@property (retain, nonatomic) IBOutlet UILabel *m_labelOccupation;
@property (retain, nonatomic) IBOutlet UILabel *m_labelDistance;
@property (retain, nonatomic) IBOutlet UILabel *m_labelGroup;

@property (retain, nonatomic) IBOutlet UIButton *m_btnCellPhone;
@property (retain, nonatomic) IBOutlet UIButton *m_btnEmail;

@property (retain, nonatomic) IBOutlet UIImageView *m_imageView;

@property (retain, nonatomic) NSString *m_strImgURL;

- (void) refreshImage;

@end
