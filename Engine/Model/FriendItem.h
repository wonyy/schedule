//
//  FriendItem.h
//  Schedule
//
//  Created by TanLong on 10/28/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendItem : NSObject

@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * accountType;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * profilePicture;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * address;

@property (nonatomic, retain) NSString * occupation;
@property (nonatomic, retain) NSString * aboutme;

@property (nonatomic, retain) NSString * group;
@property (nonatomic, retain) NSString * groupID;
@property (nonatomic, retain) NSString * distance;

@property (nonatomic)        BOOL allow_request;
@property (nonatomic)        BOOL show_event_block;
@property (nonatomic)        BOOL show_personal_as_available;
@property (nonatomic)        BOOL show_work_time;
@property (nonatomic)        BOOL show_personal_time;
@property (nonatomic)        BOOL show_school_time;
@property (nonatomic)        BOOL show_other_time;


- (id) initWithDictionary: (NSDictionary *) dict;

@end
