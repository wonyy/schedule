//
//  MenuViewController.m
//  Schedule
//
//  Created by Mountain on 10/2/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "MenuViewController.h"
#import "const.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Touch Actions

- (IBAction)onTouchWeatherBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WEATHER object:nil];

}

- (IBAction)onTouchSettingsBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SETTINGS object:nil];

}

- (IBAction)onTouchTodayBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TODAY object:nil];

}

- (IBAction)onTouchNotificationsBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NOTIFY object:nil];

}

@end
