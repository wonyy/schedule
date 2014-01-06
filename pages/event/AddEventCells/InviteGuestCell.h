//
//  InviteCell.h
//  Schedule
//
//  Created by TanLong on 11/15/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteGuestCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *m_labelName;
@property (retain, nonatomic) IBOutlet UILabel *m_labelOccupation;
@property (retain, nonatomic) IBOutlet UIImageView *m_imageView;

@property (retain, nonatomic) NSString *m_strImgURL;

- (void) refreshImage;

@end
