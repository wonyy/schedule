//
//  DBConnector.m
//  ARSLanch
//
//  Created by Galaxy39 on 1/29/13.
//  Copyright (c) 2013 FED. All rights reserved.
//

#import "DBConnector.h"
////////////////////////////
//   tbUser_pson_IDs  : psonID, userName, pson_num
//   tbUser_accounts  : accountID, userName, account_num
//   tbUser_phones    : phoneID, userName, phone_num
//   tbUser_contractor : contractorID, userName, user_num
//   tbUser_cardInfo  : cardID, cardName, card_num, card_cvc, card_mm, card_yy

///////////////////////////
@implementation DBConnector
//////////////////

- (void)createTables
{
    mDatabase = [[SQLMgr alloc] init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return;
    }
    
    // Events Table
    
    NSString* query = [NSString stringWithFormat:@"%@ tbEvent (scheduleId integer primary key autoincrement, eventId integer, eventName text, ical_event_id text, creator_id text, creator_name text, location text, latitude text, longitude text, isAllday text, startDate text, endDate text, description text, event_type text, availabilty text, reminder text, rec_type text, recurring text, event_pid integer, online integer)", CREATE_DB_SQL_PREFIX];
    
    if (![mDatabase executeUpdate:query]) {
		[mDatabase close];
        return;
    }

    // Settings Table
    query = [NSString stringWithFormat:@"%@ tbSettings (settingID integer primary key autoincrement, title text, value text)", CREATE_DB_SQL_PREFIX];
    
    if (![mDatabase executeUpdate:query]) {
		[mDatabase close];
        return;
    }
    
    // Friends Table
    query = [NSString stringWithFormat:@"%@ tbFriends (userId integer primary key, account_type text, full_name text,profile_picture text,phone_number text, address text, occupation text, about_me text, group_name text, group_id integer, distance float, allow_request bool, show_event_block bool, show_personal_as_available bool, show_work_time bool, show_personal_time bool, show_school_time bool, show_other_time bool)", CREATE_DB_SQL_PREFIX];
    
    if (![mDatabase executeUpdate:query]) {
		[mDatabase close];
        return;
    }
    
    // Groups Table
    query = [NSString stringWithFormat:@"%@ tbGroups (groupId integer primary key, group_name text)", CREATE_DB_SQL_PREFIX];
    
    if (![mDatabase executeUpdate:query]) {
		[mDatabase close];
        return;
    }
    
    // Notifications Table
    query = [NSString stringWithFormat:@"%@ tbNotifications (notiId integer primary key, profile_picture text, click_event text, message text)", CREATE_DB_SQL_PREFIX];
    
    if (![mDatabase executeUpdate:query]) {
		[mDatabase close];
        return;
    }
    
    // Pendings Table
    query = [NSString stringWithFormat:@"%@ tbPendings (pendingID integer primary key autoincrement, message text, click_event text)", CREATE_DB_SQL_PREFIX];
    
    if (![mDatabase executeUpdate:query]) {
		[mDatabase close];
        return;
    }
    
    // Requests Table
    query = [NSString stringWithFormat:@"%@ tbRequests (request_id integer primary key, profile_picture text, click_event text, message text)", CREATE_DB_SQL_PREFIX];
    
    if (![mDatabase executeUpdate:query]) {
		[mDatabase close];
        return;
    }
    
    // Invites Table
    query = [NSString stringWithFormat:@"%@ tbInvites (inviteId integer primary key, profile_picture text, click_event text, message text)", CREATE_DB_SQL_PREFIX];
    
    if (![mDatabase executeUpdate:query]) {
		[mDatabase close];
        return;
    }
    
    // Weathers Table
    query = [NSString stringWithFormat:@"%@ tbWeathers (day integer primary key, keyword text, high text, low text)", CREATE_DB_SQL_PREFIX];
    
    if (![mDatabase executeUpdate:query]) {
		[mDatabase close];
        return;
    }
    
    
    
    // Guest Table
    query = [NSString stringWithFormat:@"%@ tbGuests (guest_id integer primary key autoincrement, user_id integer, full_name text, profile_picture text, event_id integer)", CREATE_DB_SQL_PREFIX];
    
    if (![mDatabase executeUpdate:query]) {
		[mDatabase close];
        return;
    }
     
    
    
    [mDatabase close];
    [mDatabase disconnect];
}

- (void)updateQuery:(NSString*)qeury
{
    mDatabase = [[SQLMgr alloc] init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
      //  [mDatabase release];
        return;
    }
    
    if (![mDatabase executeUpdate:qeury]) {
		[mDatabase close];
        [mDatabase disconnect];
   //     [mDatabase release];
        return;
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    
    [mDatabase release];
}

// eventId integer primary key, eventName text, location text, latitude text, longitude text, isAllday text, startDate text, endDate text, description text, event_type text, availabilty text, reminder text, rec_type text, event_pid integer

- (void)clearEvents {
    NSString * query = [NSString stringWithFormat:@"delete from tbEvent"];
    [self updateQuery:query];
    
    [self clearGuests];
}

- (void)clearEventsbyID: (NSString *) strUserId {
    NSString * query = [NSString stringWithFormat:@"delete from tbEvent where creator_id = '%@'", strUserId];
    [self updateQuery:query];
    
   // [self clearGuests];
}

- (void)insertEvent: (ScheduleItem *) item
{
    if (item.eventId == 0) {        
        NSString * query = [NSString stringWithFormat:@"insert into tbEvent (eventId, eventName, ical_event_id, creator_id, creator_name, location, latitude, longitude, isAllday, startDate, endDate, description, event_type, availabilty, reminder, rec_type, recurring, event_pid, online) values('0','%@','%@','%@', '%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@', '%@', '0')", item.eventName, item.iCalEventId, item.creatorId, item.creatorName, item.eventLocation, item.eventLatitude, item.eventLongitude, item.eventIsAllDay, item.eventStartDay,item.eventEndDay,item.eventDescription, item.eventType, item.eventAvailability,item.eventReminder, item.eventRecType, item.eventRecurring, item.eventPID];
        
        NSLog(@"%@", query);
        
        [self updateQuery:query];
    } else {
        NSString * query = [NSString stringWithFormat:@"insert into tbEvent (eventId, eventName, ical_event_id, creator_id, creator_name, location, latitude, longitude, isAllday, startDate, endDate, description, event_type, availabilty, reminder, rec_type, recurring, event_pid, online) values('%d','%@','%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@', '%@', '1')", item.eventId, item.eventName, item.iCalEventId, item.creatorId, item.creatorName, item.eventLocation, item.eventLatitude, item.eventLongitude, item.eventIsAllDay, item.eventStartDay, item.eventEndDay, item.eventDescription, item.eventType, item.eventAvailability, item.eventReminder, item.eventRecType, item.eventRecurring, item.eventPID];
        
        NSLog(@"%@", query);
        
        [self updateQuery:query];
    }
    
    [self AddGuests:item.arrayGuests event_id:[NSString stringWithFormat:@"%d", item.eventId]];
}

- (void)updateEvent:(ScheduleItem *)item {
    
    NSString * query = [NSString stringWithFormat:@"update tbEvent set eventName = '%@', ical_event_id = '%@', creator_id = '%@', creator_name = '%@', location = '%@', latitude = '%@', longitude = '%@', isAllday = '%@', startDate = '%@', endDate = '%@', description = '%@', event_type = '%@', availabilty = '%@', reminder = '%@', rec_type = '%@', recurring = '%@', event_pid = '%@', online = '0' where eventId = %d", item.eventName, item.iCalEventId, item.creatorId, item.creatorName, item.eventLocation, item.eventLatitude, item.eventLongitude, item.eventIsAllDay, item.eventStartDay, item.eventEndDay, item.description, item.eventType, item.eventAvailability, item.eventReminder,item.eventRecType, item.eventPID, item.eventRecurring, item.eventId];
    [self updateQuery:query];
    
   [self AddGuests:item.arrayGuests event_id:[NSString stringWithFormat:@"%d", item.eventId]];
}

- (void) makeEventOnline: (ScheduleItem *) item online: (BOOL) bOnline {
    NSString * query = [NSString stringWithFormat:@"update tbEvent set online = '%d' where eventId = %d", item.eventId, bOnline];
    [self updateQuery:query];

}

- (NSInteger) getLastItemIndex {
    NSString * query = [NSString stringWithFormat:@"select max(eventId) from tbEvent"];
    
    mDatabase = [[SQLMgr alloc] init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return 0;
    }
    
    NSInteger nLastIndex = 0;
    
    if ([mDatabase executeQuery:query]) {
        while ([mDatabase next]) {
            nLastIndex = [[mDatabase getValueAt: 0] intValue];
            break;
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    [mDatabase release];
    
    return nLastIndex;

}

- (NSMutableArray*)getEventsAt:(NSDate *)date userID: (NSString *) struserId
{
    NSMutableArray * dataArray = [NSMutableArray new];
    NSString * query = [NSString stringWithFormat:@"select * from tbEvent where creator_id='%@'", struserId];
    mDatabase = [[SQLMgr alloc] init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
         [mDatabase disconnect];
         return dataArray;
    }
    
    if ([mDatabase executeQuery:query]) {
        while ([mDatabase next]) {
            NSDate * stDatetime = [CommonApi getDateTimeFromString:[mDatabase getValue:@"startDate"]];
            if ([CommonApi compare:stDatetime :[[CommonApi getDateStartAndEndTime:date] objectAtIndex:0]] &&
               ![CommonApi compare:stDatetime :[[CommonApi getDateStartAndEndTime:date] objectAtIndex:1]]) {
                
                ScheduleItem * item = [[ScheduleItem alloc] init];
                item.eventId = [[mDatabase getValue:@"eventId"] intValue];
                item.eventName = [mDatabase getValue:@"eventName"];
                item.iCalEventId = [mDatabase getValue:@"ical_event_id"];
                item.creatorId = [mDatabase getValue:@"creator_id"];
                item.creatorName = [mDatabase getValue:@"creator_name"];
                item.eventLocation = [mDatabase getValue:@"location"];
                item.eventLatitude = [mDatabase getValue:@"latitude"];
                item.eventLongitude = [mDatabase getValue:@"longitude"];
                item.eventIsAllDay = [mDatabase getValue:@"isAllday"];
                item.eventStartDay = [mDatabase getValue:@"startDate"];
                item.eventEndDay = [mDatabase getValue:@"endDate"];
                
                item.eventDescription = [mDatabase getValue:@"description"];
                item.eventType = [mDatabase getValue:@"event_type"];
                item.eventAvailability = [mDatabase getValue:@"availabilty"];
                item.eventReminder = [mDatabase getValue:@"reminder"];
                item.eventRecType = [mDatabase getValue:@"rec_type"];
                item.eventRecurring = [mDatabase getValue:@"recurring"];
                item.eventPID = [mDatabase getValue:@"event_pid"];
                                
                [dataArray addObject:item];
                
                [item release];
            }
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    
    [mDatabase release];
    
    for (NSInteger nIndex = 0; nIndex < [dataArray count]; nIndex++) {
        ScheduleItem *item = [dataArray objectAtIndex: nIndex];
        
        [item.arrayGuests addObjectsFromArray: [self getAllGuestsByEvent: [NSString stringWithFormat:@"%d", item.eventId]]];
    }

    return dataArray;
}

- (ScheduleItem*)getEventFromID:(int)idx
{
    ScheduleItem * item = [[ScheduleItem alloc] init];
    NSString * query = [NSString stringWithFormat:@"select * from tbEvent where eventId=%d", idx];
    mDatabase = [[SQLMgr alloc] init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return item;
    }
    
    if ([mDatabase executeQuery:query]) {
        while ([mDatabase next]) {                           
            item.eventId = [[mDatabase getValue:@"eventId"] intValue];
            item.eventName = [mDatabase getValue:@"eventName"];
            item.iCalEventId = [mDatabase getValue:@"ical_event_id"];
            item.creatorId = [mDatabase getValue:@"creator_id"];
            item.creatorName = [mDatabase getValue:@"creator_name"];
            item.eventLocation = [mDatabase getValue:@"location"];
            item.eventLatitude = [mDatabase getValue:@"latitude"];
            item.eventLongitude = [mDatabase getValue:@"longitude"];
            item.eventIsAllDay = [mDatabase getValue:@"isAllday"];
            item.eventStartDay = [mDatabase getValue:@"startDate"];
            item.eventEndDay = [mDatabase getValue:@"endDate"];
            
            item.eventDescription = [mDatabase getValue:@"description"];
            item.eventType = [mDatabase getValue:@"event_type"];
            item.eventAvailability = [mDatabase getValue:@"availabilty"];
            item.eventReminder = [mDatabase getValue:@"reminder"];
            item.eventRecType = [mDatabase getValue:@"rec_type"];
            item.eventRecurring = [mDatabase getValue:@"recurring"];
            item.eventPID = [mDatabase getValue:@"event_pid"];
            
       //     [item.arrayGuests addObjectsFromArray: [self getAllGuestsByEvent: [NSString stringWithFormat:@"%d", item.eventId]]];


            break;
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    

    [item.arrayGuests addObjectsFromArray: [self getAllGuestsByEvent: [NSString stringWithFormat:@"%d", item.eventId]]];
    
    return item;
}
- (NSMutableArray*)getEventsAt:(NSDate*)stDate :(NSDate*)edDate
{
    NSMutableArray * dataArray = [NSMutableArray new];
    NSString * query = [NSString stringWithFormat:@"select * from tbEvent"];
    mDatabase = [[SQLMgr alloc] init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return dataArray;
    }
    
    if ([mDatabase executeQuery:query]) {
        while ([mDatabase next]) {
            NSDate * stDatetime = [CommonApi getDateTimeFromString:[mDatabase getValue:@"startDate"]];
            NSDate * edDateTime = [CommonApi getDateTimeFromString:[mDatabase getValue:@"endDate"]];
            if ([CommonApi compare:stDatetime :stDate] && [CommonApi compare:edDateTime :edDate]) {
                ScheduleItem * item = [[ScheduleItem alloc] init];
                item.eventId = [[mDatabase getValue:@"eventId"] intValue];
                item.eventName = [mDatabase getValue:@"eventName"];
                item.iCalEventId = [mDatabase getValue:@"ical_event_id"];
                item.creatorId = [mDatabase getValue:@"creator_id"];
                item.creatorName = [mDatabase getValue:@"creator_name"];
                item.eventLocation = [mDatabase getValue:@"location"];
                item.eventLatitude = [mDatabase getValue:@"latitude"];
                item.eventLongitude = [mDatabase getValue:@"longitude"];
                item.eventIsAllDay = [mDatabase getValue:@"isAllday"];
                item.eventStartDay = [mDatabase getValue:@"startDate"];
                item.eventEndDay = [mDatabase getValue:@"endDate"];
                
                item.eventDescription = [mDatabase getValue:@"description"];
                item.eventType = [mDatabase getValue:@"event_type"];
                item.eventAvailability = [mDatabase getValue:@"availabilty"];
                item.eventReminder = [mDatabase getValue:@"reminder"];
                item.eventRecType = [mDatabase getValue:@"rec_type"];
                item.eventRecurring = [mDatabase getValue:@"recurring"];
                item.eventPID = [mDatabase getValue:@"event_pid"];
                
                [dataArray addObject:item];
                [item release];
            }
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    
    for (NSInteger nIndex = 0; nIndex < [dataArray count]; nIndex++) {
        ScheduleItem *item = [dataArray objectAtIndex: nIndex];
        
        [item.arrayGuests addObjectsFromArray: [self getAllGuestsByEvent: [NSString stringWithFormat:@"%d", item.eventId]]];
    }
    
    return dataArray;
}

- (NSMutableArray*)getAllEventsAsArray: (NSString *) struserId
{
    NSMutableArray * dataArray = [NSMutableArray new];
    NSString * query = [NSString stringWithFormat:@"select * from tbEvent where creator_id='%@'", struserId];
    mDatabase = [[SQLMgr alloc] init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return dataArray;
    }
    
    if ([mDatabase executeQuery:query]) {
        while ([mDatabase next]) {
            ScheduleItem * item = [[ScheduleItem alloc] init];
            item.eventId = [[mDatabase getValue:@"eventId"] intValue];
            item.eventName = [mDatabase getValue:@"eventName"];
            item.iCalEventId = [mDatabase getValue:@"ical_event_id"];
            item.creatorId = [mDatabase getValue:@"creator_id"];
            item.creatorName = [mDatabase getValue:@"creator_name"];
            item.eventLocation = [mDatabase getValue:@"location"];
            item.eventLatitude = [mDatabase getValue:@"latitude"];
            item.eventLongitude = [mDatabase getValue:@"longitude"];
            item.eventIsAllDay = [mDatabase getValue:@"isAllday"];
            item.eventStartDay = [mDatabase getValue:@"startDate"];
            item.eventEndDay = [mDatabase getValue:@"endDate"];
            
            item.eventDescription = [mDatabase getValue:@"description"];
            item.eventType = [mDatabase getValue:@"event_type"];
            item.eventAvailability = [mDatabase getValue:@"availabilty"];
            item.eventReminder = [mDatabase getValue:@"reminder"];
            item.eventRecType = [mDatabase getValue:@"rec_type"];
            item.eventRecurring = [mDatabase getValue:@"recurring"];
            item.eventPID = [mDatabase getValue:@"event_pid"];
            
            [dataArray addObject:item];
            [item release];
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    
    for (NSInteger nIndex = 0; nIndex < [dataArray count]; nIndex++) {
        ScheduleItem *item = [dataArray objectAtIndex: nIndex];
        
        [item.arrayGuests addObjectsFromArray: [self getAllGuestsByEvent: [NSString stringWithFormat:@"%d", item.eventId]]];
    }
    
    
    return dataArray;
}

- (NSMutableDictionary*) getAllEventsbyID: (NSString *) strMemberId fromNow: (NSDate *) dateFromNow {
    
    NSMutableDictionary * dataDict = [NSMutableDictionary new];
    NSString * query = [NSString stringWithFormat:@"select * from tbEvent where creator_id = '%@'", strMemberId];
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if (![mDatabase open]){
        [mDatabase disconnect];
        return dataDict;
    }
    
    if ([mDatabase executeQuery:query]){
        while ([mDatabase next]) {
            NSDate * edDateTime = [CommonApi getDateTimeFromString:[mDatabase getValue:@"endDate"]];
            
            if ([CommonApi compare:edDateTime : dateFromNow]) {
                NSString *strDate = [mDatabase getValue:@"startDate"];

                NSDate * stDate = [CommonApi getDateTimeFromString: strDate];
                strDate = [CommonApi getStringFromDate: stDate];
                
                if (strDate == nil) {
                    continue;
                }
                
                NSMutableArray *arrayData = [dataDict objectForKey: strDate];
                
                if (arrayData == nil) {
                    arrayData = [NSMutableArray new];
                }
                
                ScheduleItem * item = [[ScheduleItem alloc] init];
                item.eventId = [[mDatabase getValue:@"eventId"] intValue];
                item.eventName = [mDatabase getValue:@"eventName"];
                item.iCalEventId = [mDatabase getValue:@"ical_event_id"];
                item.creatorId = [mDatabase getValue:@"creator_id"];
                item.creatorName = [mDatabase getValue:@"creator_name"];
                item.eventLocation = [mDatabase getValue:@"location"];
                item.eventLatitude = [mDatabase getValue:@"latitude"];
                item.eventLongitude = [mDatabase getValue:@"longitude"];
                item.eventIsAllDay = [mDatabase getValue:@"isAllday"];
                item.eventStartDay = [mDatabase getValue:@"startDate"];
                item.eventEndDay = [mDatabase getValue:@"endDate"];
                
                item.eventDescription = [mDatabase getValue:@"description"];
                item.eventType = [mDatabase getValue:@"event_type"];
                item.eventAvailability = [mDatabase getValue:@"availabilty"];
                item.eventReminder = [mDatabase getValue:@"reminder"];
                item.eventRecType = [mDatabase getValue:@"rec_type"];
                item.eventRecurring = [mDatabase getValue:@"recurring"];
                item.eventPID = [mDatabase getValue:@"event_pid"];
                
                [arrayData addObject: item];
                
                [dataDict setObject:arrayData forKey: strDate];
            }
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    
    NSArray *arrayAllKeys = [dataDict allKeys];
    
    for (NSInteger nIndex = 0; nIndex < [arrayAllKeys count]; nIndex++) {
        NSString *strKey = [arrayAllKeys objectAtIndex: nIndex];
        
        NSMutableArray *arrays = [dataDict objectForKey:strKey];
        
        for (NSInteger nIndex2 = 0; nIndex2 < [arrays count]; nIndex2++) {
            ScheduleItem *item = [arrays objectAtIndex: nIndex2];
            
            [item.arrayGuests addObjectsFromArray: [self getAllGuestsByEvent: [NSString stringWithFormat:@"%d", item.eventId]]];
            
        }
        
    }
    return dataDict;
}


/// Setting

- (void)clearSettings {
    NSString * query = [NSString stringWithFormat:@"delete from tbSettings"];
    [self updateQuery:query];
}

///        query = [NSString stringWithFormat:@"%@ tbSettings (settingID integer primary key autoincrement, title text, value text)", CREATE_DB_SQL_PREFIX];

- (void)insertSetting: (SettingItem *) item {
    
    NSString * query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"first_name", item.firstName];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"last_name", item.lastName];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"account_type", item.accountType];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"email", item.email];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"birth_date", item.birthdate];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"phone_number", item.phonenumber];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"address", item.address];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"occupation", item.occupation];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"about_me", item.aboutme];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"profile_picture", item.profilepicture];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"Work", item.workColor];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"School", item.schoolColor];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"Personal", item.personalColor];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"Other", item.otherColor];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"start_of_the_day", item.startday];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"start_of_the_week", item.startweek];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"date_format", item.dateformat];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"insert into tbSettings (title, value)  values('%@','%@')", @"time_format", item.timeformat];
    
    [self updateQuery:query];
    
}

- (void)updateSettings:(SettingItem *)item {
    
    NSString * query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.firstName, @"first_name"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.lastName, @"last_name"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.accountType, @"account_type"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.email, @"email"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.birthdate, @"birth_date"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.phonenumber, @"phone_number"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.address, @"address"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.occupation, @"occupation"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.aboutme, @"about_me"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.profilepicture, @"profile_picture"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.workColor, @"Work"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.schoolColor, @"School"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.personalColor, @"Personal"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.otherColor, @"Other"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.startday, @"start_of_the_day"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.startweek, @"start_of_the_week"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.dateformat, @"date_format"];
    
    [self updateQuery:query];
    
    query = [NSString stringWithFormat:@"update tbSettings set value = '%@' where title = '%@'", item.timeformat, @"time_format"];
    
    [self updateQuery:query];
}

- (SettingItem *)getSettings {
    
    SettingItem * item = [[SettingItem alloc] init];
    NSString * query = [NSString stringWithFormat:@"select * from tbSettings"];
    
    mDatabase = [[SQLMgr alloc] init];
    
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return item;
    }
    
    if ([mDatabase executeQuery:query]) {
        
        while ([mDatabase next]) {
            
            NSString *strTitle = [mDatabase getValue:@"title"];
            NSString *strValue = [mDatabase getValue:@"value"];
            
            if ([strTitle isEqualToString:@"first_name"]) {
                item.firstName = strValue;
            } else if ([strTitle isEqualToString:@"last_name"]) {
                item.lastName = strValue;
            } else if ([strTitle isEqualToString:@"accoun_type"]) {
                item.accountType = strValue;
            } else if ([strTitle isEqualToString:@"email"]) {
                item.email = strValue;
            } else if ([strTitle isEqualToString:@"birth_date"]) {
                item.birthdate = strValue;
            } else if ([strTitle isEqualToString:@"phone_number"]) {
                item.phonenumber = strValue;
            } else if ([strTitle isEqualToString:@"address"]) {
                item.address = strValue;
            } else if ([strTitle isEqualToString:@"occupation"]) {
                item.occupation = strValue;
            } else if ([strTitle isEqualToString:@"about_me"]) {
                item.aboutme = strValue;
            } else if ([strTitle isEqualToString:@"profile_picture"]) {
                item.profilepicture = strValue;
            } else if ([strTitle isEqualToString:@"Work"]) {
                item.workColor = strValue;
            } else if ([strTitle isEqualToString:@"School"]) {
                item.schoolColor = strValue;
            } else if ([strTitle isEqualToString:@"Personal"]) {
                item.personalColor = strValue;
            } else if ([strTitle isEqualToString:@"Other"]) {
                item.otherColor = strValue;
            } else if ([strTitle isEqualToString:@"start_of_the_day"]) {
                item.startday = strValue;
            } else if ([strTitle isEqualToString:@"start_of_the_week"]) {
                item.startweek = strValue;
            } else if ([strTitle isEqualToString:@"date_format"]) {
                item.dateformat = strValue;
            } else if ([strTitle isEqualToString:@"time_format"]) {
                item.timeformat = strValue;
            }
            
            break;
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    return item;
}

// Groups
//     query = [NSString stringWithFormat:@"%@ tbGroups (groupId integer primary key, group_name text)", CREATE_DB_SQL_PREFIX];


- (void)clearGroups {
    NSString * query = [NSString stringWithFormat:@"delete from tbGroups"];
    [self updateQuery:query];
}

- (void)insertGroup: (GroupItem *) item
{
    NSString * query = [NSString stringWithFormat:@"insert into tbGroups (groupId, group_name) values('%@','%@')", item.groupID, item.name];
    
    NSLog(@"%@", query);
    
    [self updateQuery:query];
}

- (void)updateGroup:(GroupItem *)item
{
    NSString * query = [NSString stringWithFormat:@"update tbGroups set group_name = '%@' where groupId = %@", item.name, item.groupID];
    [self updateQuery:query];
}

- (NSMutableArray *) getAllGroups {
    
    NSMutableArray * dataArray = [NSMutableArray new];
    NSString * query = [NSString stringWithFormat:@"select * from tbGroups"];
    mDatabase = [[SQLMgr alloc] init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return dataArray;
    }
    
    if ([mDatabase executeQuery:query]) {
        while ([mDatabase next]) {
            GroupItem * item = [[GroupItem alloc] init];
            item.groupID = [mDatabase getValue:@"groupId"];
            item.name = [mDatabase getValue:@"group_name"];
            
            [dataArray addObject:item];
            [item release];
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    return dataArray;
}



// Guests
//  query = [NSString stringWithFormat:@"%@ tbGuests (guest_id integer primary key autoincrement, user_id integer, full_name text, profile_picture text, event_id integer)", CREATE_DB_SQL_PREFIX];


- (void)clearGuests {
    NSString * query = [NSString stringWithFormat:@"delete from tbGuests"];
    [self updateQuery:query];
}

- (void)insertGuest: (NSDictionary *) item event_id: (NSString *) eventid {
    NSString * query = [NSString stringWithFormat:@"insert into tbGuests (user_id, full_name, profile_picture, event_id) values('%@','%@','%@','%@')", [item objectForKey:@"user_id"], [item objectForKey:@"full_name"], [item objectForKey:@"profile_picture"], eventid];
    
    NSLog(@"%@", query);
    
    [self updateQuery:query];
}

- (void) AddGuests: (NSArray *) array  event_id: (NSString *) eventid {
    
    NSString * query = [NSString stringWithFormat:@"delete from tbGuests where event_id = %@", eventid];
    [self updateQuery:query];
    
    
    for (NSInteger nIndex = 0; nIndex < [array count]; nIndex++) {
        NSDictionary *dictItem = [array objectAtIndex: nIndex];
        
        [self insertGuest: dictItem event_id: eventid];
    }
}

- (NSMutableArray *) getAllGuestsByEvent: (NSString *) eventid {
    
    NSMutableArray * dataArray = [NSMutableArray new];
    NSString * query = [NSString stringWithFormat:@"select * from tbGuests where event_id = %@", eventid];
    
    mDatabase = [[SQLMgr alloc] init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return dataArray;
    }
    
    if ([mDatabase executeQuery:query]) {
        while ([mDatabase next]) {
            NSDictionary* item = [[NSDictionary alloc] initWithObjectsAndKeys:[mDatabase getValue:@"user_id"], @"user_id", [mDatabase getValue:@"full_name"], @"full_name", [mDatabase getValue:@"profile_picture"], @"profile_picture", [mDatabase getValue:@"event_id"], @"event_id", nil];
            
            [dataArray addObject:item];
            [item release];
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    
    return dataArray;
}



// Friends
/*
 @synthesize allow_request;
 @synthesize show_event_block;
 @synthesize show_personal_as_available;
 @synthesize show_work_time;
 @synthesize show_personal_time;
 @synthesize show_school_time;
 @synthesize show_other_time;
 */
///     query = [NSString stringWithFormat:@"%@ tbFriends (userId integer primary key, account_type text, full_name text,profile_picture text,phone_number text, address text, occupation text, about_me text, group_name text, group_id integer)", CREATE_DB_SQL_PREFIX];

- (void)clearFriends {
    NSString * query = [NSString stringWithFormat:@"delete from tbFriends"];
    [self updateQuery:query];
}

- (void)insertFriend: (FriendItem *) item
{
    NSString * query = [NSString stringWithFormat:@"insert into tbFriends (userId, account_type, full_name, profile_picture, phone_number, address, occupation, about_me, group_name, group_id, distance, allow_request, show_event_block, show_personal_as_available, show_work_time, show_personal_time, show_school_time, show_other_time) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%d', '%d','%d','%d','%d','%d','%d')", item.userID, item.accountType, item.fullName, item.profilePicture, item.phoneNumber, item.address, item.occupation, item.aboutme, item.group, item.groupID, item.distance, item.allow_request, item.show_event_block, item.show_personal_as_available, item.show_work_time, item.show_personal_time, item.show_school_time, item.show_other_time];
    
    NSLog(@"%@", query);
    
    [self updateQuery:query];
}

- (void)updateFriend:(FriendItem *)item
{
    NSString * query = [NSString stringWithFormat:@"update tbFriends set account_type = '%@', full_name = '%@', profile_picture = '%@', phone_number = '%@', address = '%@', occupation = '%@', about_me = '%@', group_name = '%@', group_id = '%@', distance = '%@', allow_request = '%d', show_event_block = '%d', show_personal_as_available = '%d', show_work_time = '%d', show_personal_time = '%d', show_school_time = '%d', show_other_time = '%d' where userId = %@", item.accountType, item.fullName, item.profilePicture, item.phoneNumber, item.address, item.occupation, item.aboutme, item.group, item.groupID, item.distance, item.allow_request, item.show_event_block, item.show_personal_as_available, item.show_work_time, item.show_personal_time, item.show_school_time, item.show_other_time, item.userID];
    [self updateQuery:query];
}


//(userId integer primary key, account_type text, full_name text,profile_picture text,phone_number text, address text, occupation text, about_me text, group_name text, group_id integer)

- (NSMutableArray *) getAllFriends {
    
    NSMutableArray * dataArray = [NSMutableArray new];
    NSString * query = [NSString stringWithFormat:@"select * from tbFriends"];
    mDatabase = [[SQLMgr alloc] init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return dataArray;
    }
    
    if ([mDatabase executeQuery:query]) {
        while ([mDatabase next]) {
            FriendItem * item = [[FriendItem alloc] init];
            item.userID = [mDatabase getValue:@"userId"];
            item.accountType = [mDatabase getValue:@"account_type"];
            item.fullName = [mDatabase getValue:@"full_name"];
            item.profilePicture = [mDatabase getValue:@"profile_picture"];
            item.phoneNumber = [mDatabase getValue:@"phone_number"];
            item.address = [mDatabase getValue:@"address"];
            item.occupation = [mDatabase getValue:@"occupation"];
            item.aboutme = [mDatabase getValue:@"about_me"];
            item.group = [mDatabase getValue:@"group_name"];
            item.groupID = [mDatabase getValue:@"group_id"];
            item.distance = [mDatabase getValue:@"distance"];
            item.allow_request = [[mDatabase getValue:@"allow_request"] boolValue];
            item.show_event_block = [[mDatabase getValue:@"show_event_block"] boolValue];
            item.show_personal_as_available = [[mDatabase getValue:@"show_personal_as_available"] boolValue];
            item.show_school_time = [[mDatabase getValue:@"show_school_time"] boolValue];
            item.show_other_time = [[mDatabase getValue:@"show_other_time"] boolValue];
            
            [dataArray addObject:item];
            [item release];
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    return dataArray;
}

// Notifications
///    query = [NSString stringWithFormat:@"%@ tbNotifications (notiId integer primary key, profile_picture text, click_event text, message text)", CREATE_DB_SQL_PREFIX];

- (void)clearNotifications {
    NSString * query = [NSString stringWithFormat:@"delete from tbNotifications"];
    [self updateQuery:query];
}

- (void)insertNotification: (NotificationItem *) item
{
    NSString * query = [NSString stringWithFormat:@"insert into tbNotifications (notiId, profile_picture, click_event, message) values('%@','%@','%@','%@')", item.notifID, item.profile_picture, item.click_event, item.message];
    
    NSLog(@"%@", query);
    
    [self updateQuery:query];
}

- (void)updateNotification:(NotificationItem *)item
{
    NSString * query = [NSString stringWithFormat:@"update tbNotifications set profile_picture = '%@', click_event = '%@', message = '%@' where notiId = %@", item.profile_picture, item.click_event, item.message, item.notifID];
    [self updateQuery:query];
}

- (NSMutableArray *)getAllNotifications {
    
    NSMutableArray * dataArray = [NSMutableArray new];
    NSString * query = [NSString stringWithFormat:@"select * from tbNotifications"];
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return dataArray;
    }
    
    if ([mDatabase executeQuery:query]) {
        while ([mDatabase next]) {
            NotificationItem * item = [[NotificationItem alloc] init];
            item.notifID = [mDatabase getValue:@"notiId"];
            item.profile_picture = [mDatabase getValue:@"profile_picture"];
            item.click_event = [mDatabase getValue:@"click_event"];
            item.message = [mDatabase getValue:@"message"];
           
            [dataArray addObject:item];
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    return dataArray;
}

// Pendings
///    query = [NSString stringWithFormat:@"%@ tbPendings (pendingID integer primary key autoincrement, message text, click_event text)", CREATE_DB_SQL_PREFIX];

- (void)clearPendings {
    NSString * query = [NSString stringWithFormat:@"delete from tbPendings"];
    [self updateQuery:query];
}

- (void)insertPending: (PendingItem *) item
{
    NSString * query = [NSString stringWithFormat:@"insert into tbPendings (click_event, message) values('%@','%@')",item.click_event, item.message];
    
    NSLog(@"%@", query);
    
    [self updateQuery:query];
}

- (NSMutableArray *)getAllPendings {
    
    NSMutableArray * dataArray = [NSMutableArray new];
    NSString * query = [NSString stringWithFormat:@"select * from tbPendings"];
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return dataArray;
    }
    
    if ([mDatabase executeQuery:query]) {
        while ([mDatabase next]) {
            PendingItem * item = [[PendingItem alloc] init];
            item.click_event = [mDatabase getValue:@"click_event"];
            item.message = [mDatabase getValue:@"message"];
            
            [dataArray addObject:item];
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    return dataArray;
}

// Requests
///     query = [NSString stringWithFormat:@"%@ tbRequests (request_id integer primary key, profile_picture text, click_event text, message text)", CREATE_DB_SQL_PREFIX];

- (void)clearRequests {
    NSString * query = [NSString stringWithFormat:@"delete from tbRequests"];
    [self updateQuery:query];
}

- (void)insertRequest: (RequestItem *) item
{
    NSString * query = [NSString stringWithFormat:@"insert into tbRequests (request_id, profile_picture, click_event, message) values('%@','%@','%@','%@')", item.requestID, item.profile_picture, item.click_event, item.message];
    
    NSLog(@"%@", query);
    
    [self updateQuery:query];
}

- (void)updateRequest:(RequestItem *)item
{
    NSString * query = [NSString stringWithFormat:@"update tbRequests set profile_picture = '%@', click_event = '%@', message = '%@' where request_id = %@", item.profile_picture, item.click_event, item.message, item.requestID];
    [self updateQuery:query];
}

- (NSMutableArray *)getAllRequests {
    
    NSMutableArray * dataArray = [NSMutableArray new];
    NSString * query = [NSString stringWithFormat:@"select * from tbRequests"];
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return dataArray;
    }
    
    if ([mDatabase executeQuery:query]) {
        while ([mDatabase next]) {
            RequestItem * item = [[RequestItem alloc] init];
            item.requestID = [mDatabase getValue:@"request_id"];
            item.profile_picture = [mDatabase getValue:@"profile_picture"];
            item.click_event = [mDatabase getValue:@"click_event"];
            item.message = [mDatabase getValue:@"message"];
            
            [dataArray addObject:item];
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    return dataArray;
}

// Invites
///    query = [NSString stringWithFormat:@"%@ tbInvites (inviteId integer primary key, profile_picture text, click_event text, message text)", CREATE_DB_SQL_PREFIX];

- (void)clearInvites {
    NSString * query = [NSString stringWithFormat:@"delete from tbInvites"];
    [self updateQuery:query];
}

- (void)insertInvite: (InviteItem *) item
{
    NSString * query = [NSString stringWithFormat:@"insert into tbInvites (inviteId, profile_picture, click_event, message) values('%@','%@','%@','%@')", item.inviteID, item.profile_picture, item.click_event, item.message];
    
    NSLog(@"%@", query);
    
    [self updateQuery:query];
}

- (void)updateInvite:(InviteItem *)item
{
    NSString * query = [NSString stringWithFormat:@"update tbInvites set profile_picture = '%@', click_event = '%@', message = '%@' where inviteId = %@", item.profile_picture, item.click_event, item.message, item.inviteID];
    [self updateQuery:query];
}

- (NSMutableArray *)getAllInvites {
    
    NSMutableArray * dataArray = [NSMutableArray new];
    NSString * query = [NSString stringWithFormat:@"select * from tbInvites"];
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return dataArray;
    }
    
    if ([mDatabase executeQuery:query]) {
        while ([mDatabase next]) {
            InviteItem * item = [[InviteItem alloc] init];
            item.inviteID = [mDatabase getValue:@"inviteId"];
            item.profile_picture = [mDatabase getValue:@"profile_picture"];
            item.click_event = [mDatabase getValue:@"click_event"];
            item.message = [mDatabase getValue:@"message"];
            
            [dataArray addObject:item];
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    return dataArray;
}

// Weathers
///    query = [NSString stringWithFormat:@"%@ tbWeathers (day integer primary key, keyword text, high text, low text)", CREATE_DB_SQL_PREFIX];

- (void)clearWeathers {
    NSString * query = [NSString stringWithFormat:@"delete from tbWeathers"];
    [self updateQuery:query];
}

- (void)insertWeather: (WeatherItem *) item
{
    NSString * query = [NSString stringWithFormat:@"insert into tbWeathers (day, keyword, high, low) values('%@','%@','%@','%@')", item.day, item.keyword, item.high, item.low];
    
    NSLog(@"%@", query);
    
    [self updateQuery:query];
}

- (void)updateWeather:(WeatherItem *)item
{
    NSString * query = [NSString stringWithFormat:@"update tbWeathers set keyword = '%@', high = '%@', low = '%@' where day = %@", item.keyword, item.high, item.low, item.day];
    [self updateQuery:query];
}

- (NSMutableArray *) getAllWeathers {
    
    NSMutableArray * dataArray = [NSMutableArray new];
    NSString * query = [NSString stringWithFormat:@"select * from tbWeathers"];
    mDatabase = [[SQLMgr alloc]init];
    [mDatabase connect];
    
    if (![mDatabase open]) {
        [mDatabase disconnect];
        return dataArray;
    }
    
    if ([mDatabase executeQuery:query]) {
        while ([mDatabase next]) {
            WeatherItem * item = [[WeatherItem alloc] init];
            item.day = [mDatabase getValue:@"day"];
            item.keyword = [mDatabase getValue:@"keyword"];
            item.high = [mDatabase getValue:@"high"];
            item.low = [mDatabase getValue:@"low"];
            
            [dataArray addObject:item];
        }
    }
    
    [mDatabase close];
    [mDatabase disconnect];
    return dataArray;
}


@end
