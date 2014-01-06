//
//  CustomSwitch.h
//  Schedule
//
//  Created by TanLong on 11/2/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomSwitch;

@protocol CustomSwitchDelegate <NSObject>

- (void) onValueChanged: (CustomSwitch *) switchCtrl;

@end

@interface CustomSwitch : UIView {
    id <CustomSwitchDelegate> delegate;

}

@property (nonatomic) BOOL m_bValue;

@property (nonatomic, retain) UIImageView *m_imgViewBackground;
@property (nonatomic, retain) UIImageView *m_imgViewThumb;

@property (nonatomic, assign) id <CustomSwitchDelegate> delegate;

- (void) setValue : (BOOL) bValue withUI: (BOOL) withUI;

@end
