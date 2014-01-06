//
//  MainTabBarView.h
//  Schedule
//
//  Created by suhae on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainTabBarViewDelegate

- (void)MainTabBarViewDelegate_selectedAt:(int)index;
- (void)ShowMenu;

@end

@interface MainTabBarView : UIView

@property (nonatomic, retain) id <MainTabBarViewDelegate> delegate;

- (IBAction)onSelectType:(id)sender;
- (IBAction)onAddAction:(id)sender;
- (IBAction)onShowMenu:(id)sender;


@end
