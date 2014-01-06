//
//  GuestCell.h
//  Schedule
//
//  Created by TanLong on 11/21/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *m_guestName;
@property (retain, nonatomic) IBOutlet UIImageView *m_imageView;

@property (retain, nonatomic) NSString *m_strImgURL;

- (void) refreshImage;

@end
