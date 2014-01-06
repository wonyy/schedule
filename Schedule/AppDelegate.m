//
//  AppDelegate.m
//  Schedule
//
//  Created by suhae on 8/13/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "AppDelegate.h"
#import "EventKitManager.h"
#import "HomeViewController.h"
#import "MonthlyViewController.h"
#import "WeeklyViewController.h"
#import "DailyViewController.h"
#import "FriendsViewController.h"
#import "LoginViewController.h"

#import "DBInitailize.h"
#import "AddEventViewController.h"
#import "NotificationViewController.h"
#import "SettingsViewController.h"
#import "WeatherViewController.h"
#import "DBConnector.h"
#import "Reachability.h"


@implementation AppDelegate

@synthesize locationManager;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    [dataKeeper loadDataFromFile];
    
    EventKitManager *eventKitManager = [EventKitManager sharedInstance];
    
  //  [eventKitManager checkEventStoreAccessForCalendar];
    [eventKitManager requestCalendarAccess];
    
    [[[[DBInitailize alloc] init] autorelease] initialize];
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkNetworkStatus:)
                                                 name:kReachabilityChangedNotification object:nil];
    
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    
    [[self locationManager] startUpdatingLocation];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.mainViewController = [[[UITabBarController alloc] init] autorelease];
    
    HomeViewController * homeControl = [[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil] autorelease];
    DailyViewController * daillyControl = [[[DailyViewController alloc] initWithNibName:@"DailyViewController" bundle:nil] autorelease];
    WeeklyViewController * weeklyControl = [[[WeeklyViewController alloc] initWithNibName:@"WeeklyViewController" bundle:nil] autorelease];
    MonthlyViewController * monthlyControl = [[[MonthlyViewController alloc] initWithNibName:@"MonthlyViewController" bundle:nil] autorelease];
    FriendsViewController * friendsControl = [[[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil] autorelease];
    _menuControl = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle: nil];
    
    [self.mainViewController addChildViewController: [[UINavigationController alloc] initWithRootViewController:homeControl]];
    [self.mainViewController addChildViewController:[[UINavigationController alloc] initWithRootViewController:daillyControl]];
    [self.mainViewController addChildViewController:[[UINavigationController alloc] initWithRootViewController:weeklyControl]];
    [self.mainViewController addChildViewController:[[UINavigationController alloc] initWithRootViewController:monthlyControl]];
    [self.mainViewController addChildViewController:[[UINavigationController alloc] initWithRootViewController:friendsControl]];
    
    LoginViewController * loginControl = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
    
    UINavigationController *navCtrl = [[[UINavigationController alloc] initWithRootViewController:loginControl] autorelease];
    
    [navCtrl setNavigationBarHidden: YES];
    
    self.window.rootViewController = navCtrl;
    [self.window makeKeyAndVisible];
    
    CGRect tabBarRect = CGRectMake(0, self.mainViewController.view.frame.size.height - 68, self.mainViewController.view.frame.size.width, 68);
    
    m_tabBar = [[MainTabBarView alloc] init];
    m_tabBar.delegate = self;
    
    for (UIView * subView in self.mainViewController.view.subviews){
        if ([subView isKindOfClass:[UITabBar class]]){
            [subView setFrame:CGRectMake(0, 800, subView.frame.size.width, subView.frame.size.height)];
        }
    }
    [m_tabBar setFrame:tabBarRect];
    [self.mainViewController.view addSubview:m_tabBar];
    
    [self.mainViewController.view addSubview: _menuControl.view];
    
    [_menuControl.view setFrame: CGRectMake(5, m_tabBar.frame.origin.y - _menuControl.view.frame.size.height + 20, _menuControl.view.frame.size.width, _menuControl.view.frame.size.height)];
    
    [_menuControl.view setHidden: YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TouchNotify) name:NOTIFICATION_NOTIFY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TouchSettings) name:NOTIFICATION_SETTINGS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TouchToday) name:NOTIFICATION_TODAY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TouchWeather) name:NOTIFICATION_WEATHER object:nil];
    
    return YES;
}

- (void) TouchNotify {
    [self ShowMenu];
    
    NotificationViewController *notifyVC = [[[NotificationViewController alloc] initWithNibName:@"NotificationViewController" bundle: nil] autorelease];
    
    [self.mainViewController presentViewController:notifyVC animated: YES completion:nil];
}

- (void) TouchSettings {
    [self ShowMenu];
    
    SettingsViewController *settingsVC = [[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle: nil] autorelease];
    
    UINavigationController *navSettingVC = [[[UINavigationController alloc] initWithRootViewController: settingsVC] autorelease];
    
    [navSettingVC setNavigationBarHidden: YES];
    
    [self.mainViewController presentViewController:navSettingVC animated:YES completion:nil];
    
}

- (void) TouchToday {
    [self ShowMenu];
}

- (void) TouchWeather {
    [self ShowMenu];
    
    WeatherViewController *weatherVC = [[[WeatherViewController alloc] initWithNibName:@"WeatherViewController" bundle: nil] autorelease];
    
    [self.mainViewController presentViewController: weatherVC animated:YES completion:nil];
    
}

- (void)MainTabBarViewDelegate_selectedAt:(int)index
{
    int tabIndex = index;
    
    if (tabIndex < 0)
        return;
    
    if (index == 10) {
        AddEventViewController * controller = [[AddEventViewController alloc]initWithNibName:@"AddEventViewController" bundle:nil];
        [self.mainViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
        return;
    } else if (index == 11) {
        AddEventViewController * controller = [[AddEventViewController alloc] initWithNibName:@"AddEventViewController" bundle:nil];
        
        [controller setM_initDate: _m_dateForDailyView];
        
        [self.mainViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:YES completion:nil];
        return;
    }
    [self.mainViewController setSelectedIndex:tabIndex];
}

- (void) ShowMenu {
    if (_menuControl.view.hidden == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            [_menuControl.view setHidden: NO];
        } completion:^(BOOL finished) {
            
            
        }];
        
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [_menuControl.view setHidden: YES];
        } completion:^(BOOL finished) {
            
            
        }];
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Check Internet Connection

- (BOOL)isInternetConnected {
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    
    if (netStatus == NotReachable) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cloud Gods Mad" message:@"We're having trouble connecting to the internet. Please make sure you have WiFi or a data connection and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        return FALSE;
    }
    else
        return TRUE;
    
}

- (void)checkNetworkStatus:(NSNotification *)notice {
    // called after network status changes
    
    NetworkStatus internetStatus = [internetReach currentReachabilityStatus];
    switch (internetStatus) {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI");
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"PostUnuploadedZum"
             object:self];
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN!");
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"PostUnuploadedZum"
             object:self];
            
            break;
        }
    }
}

#pragma mark - Location Manager

#pragma mark -
#pragma mark Location manager

/**
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager {
	
    if (locationManager != nil) {
		return locationManager;
	}
	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[locationManager setDelegate:self];
	
	return locationManager;
}


/**
 Conditionally enable the Add button:
 If the location manager is generating updates, then enable the button;
 If the location manager is failing, then disable the button.
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    if (dataKeeper.fcurrent_x == 0 && dataKeeper.fcurrent_y == 0) {
        dataKeeper.fcurrent_x = newLocation.coordinate.latitude;
        dataKeeper.fcurrent_y = newLocation.coordinate.longitude;
        
        //        dataKeeper.fcurrent_x = 40.714224;
        //        dataKeeper.fcurrent_y = -73.961452;
    } else {
        //      dataKeeper.fcurrent_x = 40.714224;
        //      dataKeeper.fcurrent_y = -73.961452;
        
        //      [googlePlacesConnection getAddressfromCoordinate:[NSString stringWithFormat:@"%f,%f",  dataKeeper.fcurrent_x, dataKeeper.fcurrent_y]];
        
        
        dataKeeper.fcurrent_x = newLocation.coordinate.latitude;
        dataKeeper.fcurrent_y = newLocation.coordinate.longitude;
        
    }
    
    
    //  [dataKeeper update_location];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
}


@end
