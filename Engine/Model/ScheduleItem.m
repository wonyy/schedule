//
//  ScheduleItem.m
//  Schedule
//
//  Created by Galaxy39 on 8/17/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "ScheduleItem.h"

@implementation ScheduleItem

@synthesize eventId, iCalEventId, eventName, creatorId, creatorName, eventLocation, eventLatitude, eventLongitude, eventIsAllDay, eventStartDay, eventEndDay, eventDescription, eventType, eventAvailability, eventReminder, eventRecurring, eventRecurringEndDay, eventRecType, eventLength, eventPID, arrayGuests;

- (id) init {
    if (self = [super init]) {
       self.eventId = 0;
       self.iCalEventId = @"";
       self.eventName = @"";
       self.creatorId = @"";
       self.creatorName = @"";
       self.eventLocation = @"";
       self.eventLatitude = @"43.6826285";
       self.eventLongitude = @"-79.3919381";

       self.eventIsAllDay = @"";
       self.eventStartDay = @"";
       self.eventEndDay = @"";
        
       self.eventDescription = @"";
       self.eventType = @"Work";
       self.eventAvailability = @"free";
        
       self.eventReminder = @"5#min";
       self.eventRecurring = @"None";
       self.eventRecurringEndDay = @"";
       self.eventRecType = @"";
       self.eventLength = @"0";
       self.eventPID = @"";
       self.arrayGuests = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dict {
    if (self = [super init]) {
        self.eventId = [[dict objectForKey:@"event_id"] integerValue];
    //    self.iCalEventId = [dict objectForKey:@"ical_event_id"];
        self.iCalEventId = @"";

        self.eventName = [dict objectForKey:@"event_name"];
        self.creatorId = [dict objectForKey:@"creator_id"];
        self.creatorName = [dict objectForKey:@"creator_name"];
        self.eventLocation = [dict objectForKey:@"location"];
        self.eventLatitude = [dict objectForKey:@"location_lat"];
        self.eventLongitude = [dict objectForKey:@"location_lon"];
        
        self.eventIsAllDay = @"";
        self.eventStartDay = [dict objectForKey:@"date_time_start"];
        self.eventEndDay = [dict objectForKey:@"date_time_end"];
        
        self.eventDescription = [dict objectForKey:@"description"];
        self.eventType = [dict objectForKey:@"event_type"];
        self.eventAvailability = [dict objectForKey:@"availability"];
        
        self.eventReminder = [dict objectForKey:@"reminder"];
        
        NSString *strRecurring = [dict objectForKey:@"recurring"];
        
        if (strRecurring != nil && [strRecurring isKindOfClass:[NSString class]]) {
            self.eventRecurring = [dict objectForKey:@"recurring"];
        } else {
            self.eventRecurring = @"";
        }
        
        self.eventRecurringEndDay = @"";

        self.eventRecType = [dict objectForKey:@"rec_type"];
        self.eventLength = [dict objectForKey:@"event_length"];
        self.eventPID = [dict objectForKey:@"event_pid"];
        
        self.arrayGuests = [[NSMutableArray alloc] initWithArray: [dict objectForKey:@"guest_list"]];
    }
    return self;
}
@end
