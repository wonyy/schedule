//
//  HomeViewController.h
//  Schedule
//
//  Created by wonymini on 9/26/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCell.h"
#import "CustomSwitch.h"


@interface HomeViewController : UIViewController <CustomSwitchDelegate, MBProgressHUDDelegate> {
    NSMutableDictionary *m_dictData;
    MBProgressHUD *HUD;
    
    NSMutableArray *m_aryWeathers;
    
    NSTimer *m_timer;
}


@property (retain, nonatomic) IBOutlet UIView *m_headerView;

@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;

@property (retain, nonatomic) IBOutlet UITableView *m_tableView;
@property (retain, nonatomic) IBOutlet HomeCell *m_homeCell;

@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewWeather;
@property (retain, nonatomic) IBOutlet UILabel *m_labelWeather;

@property (retain, nonatomic) IBOutlet UILabel *m_labelDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelHour;
@property (retain, nonatomic) IBOutlet UILabel *m_labelMinute;


@property (retain, nonatomic) CustomSwitch *switchAvail;

- (IBAction)onTouchSeeAllGuestsBtn:(id)sender;


@end
