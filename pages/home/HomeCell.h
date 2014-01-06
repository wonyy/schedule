//
//  HomeCell.h
//  Schedule
//
//  Created by Mountain on 9/28/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *labelFrom;
@property (retain, nonatomic) IBOutlet UILabel *labelTo;
@property (retain, nonatomic) IBOutlet UILabel *labelTitle;

@property (retain, nonatomic) IBOutlet UIView *m_eventTypeView;

@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewGuest1;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewGuest2;
@property (retain, nonatomic) IBOutlet UIButton *m_btnSeeAllGuests;

@property (retain, nonatomic) NSString *m_strImgURL1;
@property (retain, nonatomic) NSString *m_strImgURL2;

- (void) refreshImage1;
- (void) refreshImage2;


@end
