//
//  EventKitManager.h
//  Schedule
//
//  Created by TanLong on 11/29/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>


@interface EventKitManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@property (nonatomic, strong) NSMutableArray *eventsList;

- (void) checkEventStoreAccessForCalendar;
- (void)requestCalendarAccess;

+ (id)sharedInstance;

@end
