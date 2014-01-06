//
//  WeatherViewController.h
//  Schedule
//
//  Created by TanLong on 11/26/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherCell.h"

@interface WeatherViewController : UIViewController {
    NSTimer *m_timer;

    NSMutableArray *m_aryWeathers;

}

@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;

@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;

@property (retain, nonatomic) IBOutlet WeatherCell *m_weatherCell;


- (IBAction)onTouchNavBackBtn:(id)sender;

@end
