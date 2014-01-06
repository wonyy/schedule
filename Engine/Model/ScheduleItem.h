//
//  ScheduleItem.h
//  Schedule
//
//  Created by Galaxy39 on 8/17/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ScheduleItem : NSObject

@property (atomic) int eventId;

@property (nonatomic, retain) NSString * iCalEventId;

@property (nonatomic, retain) NSString * eventName;

@property (nonatomic, retain) NSString * creatorId;
@property (nonatomic, retain) NSString * creatorName;

@property (nonatomic, retain) NSString * eventLocation;
@property (nonatomic, retain) NSString * eventLatitude;
@property (nonatomic, retain) NSString * eventLongitude;

@property (nonatomic, retain) NSString * eventIsAllDay;

@property (nonatomic, retain) NSString * eventStartDay;
@property (nonatomic, retain) NSString * eventEndDay;

@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * eventType;
@property (nonatomic, retain) NSString * eventAvailability;

@property (nonatomic, retain) NSString * eventReminder;
@property (nonatomic, retain) NSString * eventRecurring;
@property (nonatomic, retain) NSString * eventRecurringEndDay;
@property (nonatomic, retain) NSString * eventRecType;
@property (nonatomic, retain) NSString * eventLength;
@property (nonatomic, retain) NSString * eventPID;
@property (nonatomic, retain) NSMutableArray *arrayGuests;

- (id) initWithDictionary: (NSDictionary *) dict;

@end
