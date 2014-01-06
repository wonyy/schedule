//
//  SettingItem.h
//  Schedule
//
//  Created by TanLong on 10/26/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingItem : NSObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * accountType;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * birthdate;
@property (nonatomic, retain) NSString * phonenumber;
@property (nonatomic, retain) NSString * address;

@property (nonatomic, retain) NSString * occupation;
@property (nonatomic, retain) NSString * aboutme;
@property (nonatomic, retain) NSString * profilepicture;

@property (nonatomic, retain) NSString * workColor;
@property (nonatomic, retain) NSString * schoolColor;
@property (nonatomic, retain) NSString * personalColor;
@property (nonatomic, retain) NSString * otherColor;

@property (nonatomic, retain) NSString * startday;
@property (nonatomic, retain) NSString * startweek;
@property (nonatomic, retain) NSString * dateformat;
@property (nonatomic, retain) NSString * timeformat;

- (id) initWithSettingItem: (SettingItem *) item;
- (id) initWithDictionary: (NSDictionary *) dict;

@end
