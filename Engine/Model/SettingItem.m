//
//  SettingItem.m
//  Schedule
//
//  Created by TanLong on 10/26/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "SettingItem.h"

@implementation SettingItem

@synthesize userId;
@synthesize firstName;
@synthesize lastName;
@synthesize accountType;
@synthesize email;
@synthesize birthdate;
@synthesize phonenumber;
@synthesize address;

@synthesize occupation;
@synthesize aboutme;
@synthesize profilepicture;

@synthesize workColor;
@synthesize schoolColor;
@synthesize personalColor;
@synthesize otherColor;

@synthesize startday;
@synthesize startweek;
@synthesize dateformat;
@synthesize timeformat;

- (id) init {
    if (self = [super init]) {
        self.userId = @"";
        self.firstName = @"";
        self.lastName = @"";
        self.accountType = @"";
        self.email = @"";
        
        self.birthdate = @"";
        self.phonenumber = @"";
        self.address = @"";
        
        self.occupation = @"";
        self.aboutme = @"";
        self.profilepicture = @"";
        
        self.workColor = @"";
        self.schoolColor = @"";
        self.personalColor = @"";
        self.otherColor = @"";
        
        self.startday = @"";
        self.startweek = @"";
        self.dateformat = @"";
        self.timeformat = @"";
        
    }
    return self;
}

- (id) initWithSettingItem: (SettingItem *) item {
    if (self = [super init]) {
        self.userId = item.userId;
        self.firstName = item.firstName;
        self.lastName = item.lastName;
        self.accountType = item.accountType;
        self.email = item.email;
        
        self.birthdate = item.birthdate;
        self.phonenumber = item.phonenumber;
        self.address = item.address;
        
        self.occupation = item.occupation;
        self.aboutme = item.aboutme;
        self.profilepicture = item.profilepicture;
        
        self.workColor = item.workColor;
        self.schoolColor = item.schoolColor;
        self.personalColor = item.personalColor;
        self.otherColor = item.otherColor;
        
        self.startday = item.startday;
        self.startweek = item.startweek;
        self.dateformat = item.dateformat;
        self.timeformat = item.timeformat;
        
    }
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dict {
    if (self = [super init]) {
        
        NSDictionary *dictMyProfile = [dict objectForKey:@"my_profile"];
        
        self.userId = [dictMyProfile objectForKey:@"user_id"];
        self.firstName = [dictMyProfile objectForKey:@"first_name"];
        self.lastName = [dictMyProfile objectForKey:@"last_name"];
        self.accountType = [dictMyProfile objectForKey:@"account_type"];
        self.email = [dictMyProfile objectForKey:@"email"];
        self.birthdate = [dictMyProfile objectForKey:@"birth_date"];
        self.address = [dictMyProfile objectForKey:@"address"];
        self.phonenumber = [dictMyProfile objectForKey:@"phone_number"];
        self.occupation = [dictMyProfile objectForKey:@"occupation"];
        self.aboutme = [dictMyProfile objectForKey:@"about_me"];
        self.profilepicture = [dictMyProfile objectForKey:@"profile_picture"];
        
        NSDictionary *dictEventColor = [dict objectForKey:@"event_color"];

        self.workColor = [dictEventColor objectForKey:@"Work"];
        self.schoolColor = [dictEventColor objectForKey:@"School"];
        self.personalColor = [dictEventColor objectForKey:@"Personal"];
        self.otherColor = [dictEventColor objectForKey:@"Other"];
        
        NSDictionary *dictDateTime = [dict objectForKey:@"date_time_pref"];
        
        self.startday = [dictDateTime objectForKey:@"start_of_the_day"];
        self.startweek = [dictDateTime objectForKey:@"start_of_the_week"];
        self.dateformat = [dictDateTime objectForKey:@"date_format"];
        self.timeformat = [dictDateTime objectForKey:@"time_format"];
        
        self.dateformat = [CommonApi getClientTimeFormat: self.dateformat];
        self.timeformat = [CommonApi getClientTimeFormat: self.timeformat];
    }
    
    return self;
}

@end
