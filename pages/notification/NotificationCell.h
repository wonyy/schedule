//
//  NotificationCell.h
//  Schedule
//
//  Created by Mountain on 10/2/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *m_labelMessage;
@property (retain, nonatomic) IBOutlet UIButton *m_btnOk;

@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) NSString *m_strImgURL;

- (void) refreshImage;

@end
