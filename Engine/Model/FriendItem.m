//
//  FriendItem.m
//  Schedule
//
//  Created by TanLong on 10/28/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "FriendItem.h"

@implementation FriendItem

@synthesize userID;
@synthesize accountType;
@synthesize fullName;
@synthesize profilePicture;
@synthesize phoneNumber;
@synthesize address;
@synthesize occupation;
@synthesize aboutme;
@synthesize group;
@synthesize groupID;
@synthesize distance;
@synthesize allow_request;
@synthesize show_event_block;
@synthesize show_personal_as_available;
@synthesize show_work_time;
@synthesize show_personal_time;
@synthesize show_school_time;
@synthesize show_other_time;

- (id) init {
    if (self = [super init]) {
        self.userID = @"";
        self.accountType = @"";
        self.fullName = @"";
        self.profilePicture = @"";
        
        self.phoneNumber = @"";
        self.address = @"";
        self.occupation = @"";
        
        self.aboutme = @"";
        self.group = @"";
        self.groupID = @"";
        
        self.distance = @"0";
    }
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dict {
    if (self = [super init]) {
        
        self.userID = [dict objectForKey:@"user_id"];
        self.accountType = [dict objectForKey:@"account_type"];
        self.fullName = [dict objectForKey:@"full_name"];
        self.profilePicture = [dict objectForKey:@"profile_picture"];
        self.phoneNumber = [dict objectForKey:@"phone_number"];
        self.address = [dict objectForKey:@"address"];
        self.occupation = [dict objectForKey:@"occupation"];
        self.aboutme = [dict objectForKey:@"about_me"];

        self.group = [dict objectForKey:@"group"];
        self.groupID = [dict objectForKey:@"group_id"];
        
        self.distance = [dict objectForKey:@"distance"];
        
        self.allow_request = [[dict objectForKey:@"allow_request"] boolValue];
        self.show_event_block = [[dict objectForKey:@"show_event_block"] boolValue];
        self.show_personal_as_available = [[dict objectForKey:@"show_personal_as_available"] boolValue];
        self.show_work_time = [[dict objectForKey:@"show_work_time"] boolValue];
        self.show_personal_time = [[dict objectForKey:@"show_personal_time"] boolValue];
        self.show_school_time = [[dict objectForKey:@"show_school_time"] boolValue];
        self.show_other_time = [[dict objectForKey:@"show_other_time"] boolValue];
    }
    
    return self;
}


@end
