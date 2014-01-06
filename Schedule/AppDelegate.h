//
//  AppDelegate.h
//  Schedule
//
//  Created by suhae on 8/13/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MenuViewController.h"
#import "MainTabBarView.h"

@class Reachability;

@interface AppDelegate : UIResponder <UIApplicationDelegate, MainTabBarViewDelegate, CLLocationManagerDelegate> {
    MainTabBarView * m_tabBar;
    Reachability* internetReach;

    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MenuViewController * menuControl;

@property (strong, nonatomic) UITabBarController *mainViewController;
@property (retain, nonatomic) CLLocationManager *locationManager;

@property (retain, nonatomic) NSString *m_dateForDailyView;

- (void)checkNetworkStatus:(NSNotification *)notice;
- (BOOL)isInternetConnected;
- (void)MainTabBarViewDelegate_selectedAt:(int)index;

@end
