//
//  InviteCell.h
//  Schedule
//
//  Created by TanLong on 11/1/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *m_labelMessage;
@property (retain, nonatomic) IBOutlet UIButton *m_btnAccept;
@property (retain, nonatomic) IBOutlet UIButton *m_btnDecline;


@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) NSString *m_strImgURL;

- (void) refreshImage;

@end
