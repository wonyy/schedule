//
//  CSearchAddressViewController.h
//  taxiboy
//
//  Created by Mountain on 10/8/13.
//  Copyright (c) 2013 wony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GooglePlacesConnection.h"

@class GooglePlacesObject;

@protocol CSearchAddressViewControllerDelegate

- (void)AddressSelected;

@end

@interface CSearchAddressViewController : UIViewController <UITextFieldDelegate> {
    GooglePlacesConnection  *googlePlacesConnection;
    NSMutableArray *arraySuggests;
    
    NSTimer *m_timer;

}

@property (retain, nonatomic) IBOutlet UITextField *m_searchTextField;
@property (retain, nonatomic) IBOutlet UITableView *m_tableView;
@property (nonatomic, retain) id <CSearchAddressViewControllerDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentDate;
@property (retain, nonatomic) IBOutlet UILabel *m_labelCurrentTime;


- (IBAction)onTouchCancelBtn:(id)sender;
- (IBAction)onChangeSearchField:(id)sender;



@end
