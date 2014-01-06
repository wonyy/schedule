//
//  DataKeeper.m
//  Schedule
//
//  Created by wony on 08/22/13.
//  Copyright 2013 wony. All rights reserved.
//

#import "DataKeeper.h"
#import "DBConnector.h"
#import "SBJsonWriter.h"


@implementation DataKeeper

@synthesize communication;

@synthesize m_strLastErrorMessage;

@synthesize m_dictLocalImageCaches;

@synthesize m_strDeviceToken;

@synthesize m_strUserSecurity;

@synthesize m_strUserEmail;
@synthesize m_strUserName;
@synthesize m_strUserMobile;
@synthesize m_strUserHomeAddress;
@synthesize m_strUserLatitude;
@synthesize m_strUserLongitude;

@synthesize m_curLocation;
@synthesize m_curLatitude;
@synthesize m_curLongitude;

@synthesize m_arraySearchResults;

@synthesize m_mySettingInfo;

@synthesize m_strPickDate;

@synthesize m_bLogin;
@synthesize m_bAvailable;


- (id)init
{
    self = [super init];
    if (self) {
        
        ////////////////////////////////////////////
        //// Initialize
        ////////////////////////////////////////////
        
        communication = [[Communication alloc] init];
        
        m_dictLocalImageCaches = [[NSMutableDictionary alloc] init];
        
        m_bAvailable = NO;
        
        m_mySettingInfo = [[SettingItem alloc] init];
        
        m_arraySearchResults = [[NSMutableArray alloc] init];
                    
        ////////////////////////////////////////////
    }
    
    return self;
}

- (void)dealloc
{
    [communication release];
    
    if (m_strLastErrorMessage != nil) {
        [m_strLastErrorMessage release];
    }
    
    if (m_strDeviceToken != nil) {
        [m_strDeviceToken release];
    }
    
    if (m_strUserEmail != nil) {
        [m_strUserEmail release];
    }

    if (m_strUserName != nil) {
        [m_strUserName release];
    }
    
    if (m_strUserMobile != nil) {
        [m_strUserMobile release];
    }
    
    if (m_strUserHomeAddress != nil) {
        [m_strUserHomeAddress release];
    }
    
    if (m_strUserLatitude != nil) {
        [m_strUserLatitude release];
    }
    
    if (m_strUserLongitude != nil) {
        [m_strUserLongitude release];
    }
    
    if (m_mySettingInfo != nil) {
        [m_mySettingInfo release];
    }

    if (m_strPickDate != nil) {
        [m_strPickDate release];
    }

    if (m_strUserSecurity != nil) {
        [m_strUserSecurity release];
    }
    
    if (m_dictLocalImageCaches != nil) {
        [m_dictLocalImageCaches release];
    }
    
    if (m_curLocation != nil) {
        [m_curLocation release];
    }
    
    if (m_curLatitude != nil) {
        [m_curLatitude release];
    }
    
    if (m_curLongitude != nil) {
        [m_curLongitude release];
    }

    if (m_arraySearchResults != nil) {
        [m_arraySearchResults release];
    }
    
    [super dealloc];
}

#pragma mark - Auth
- (NSInteger) Login: (NSString *)strUser strPass: (NSString *) strPassword {
    
    // Initial Checking...
    if (!strUser || !strPassword || !communication) {
        return 0;
    }
    
    // Read Datas...
    NSDictionary *respData;
    BOOL bResult = [communication comm_login:strUser password:strPassword lat:[NSString stringWithFormat:@"%f", _fcurrent_x] lng:[NSString stringWithFormat:@"%f", _fcurrent_y] respData:&respData];
    
    // Login Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return 0;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    NSInteger nRetCode = 0;
    
    if ([strStatus isEqualToString:@"success"] == YES) {
        NSLog(@"Login is successful");
        
        NSString *token = [respData objectForKey:@"session_token"];
        [self setM_strUserSecurity: token];
        [self setM_bLogin: YES];
        [self setM_bAvailable: YES];
        
        nRetCode = 1;
    } else {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        nRetCode = 0;

    }
    [respData release];
    return nRetCode;
}


- (BOOL) Signup: (NSString *) strEmail firstname: (NSString *) firstname lastname: (NSString *) lastname {
    
    // Initial Checking...
    if (!strEmail || !firstname || !lastname || !communication) {
        return NO;
    }
         
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_signup:strEmail first_name:firstname last_name:lastname respData:&respData];
    
    // Login Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
        
    }
    
    [respData release];
    
    return YES;
}

- (BOOL) Signup2: (NSString *) strEmail first: (NSString *) strFirst last: (NSString *) strLast password: (NSString *) strpass accounttype: (NSString *) strAcctType birthdate: (NSString *) strBirthdate phone: (NSString *) strphone address: (NSString *) straddr occupation: (NSString *) stroccu aboutme: (NSString *) strabout photo: (NSData *) photodata {
    
    // Initial Checking...
    if (!strFirst || !strLast || !strEmail || !strpass ||!communication) {
        return NO;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_signup2:strEmail first_name:strFirst last_name:strLast pass:strpass account_type:strpass birth_date:strBirthdate phone:strphone address:straddr occupation:stroccu aboutme:strabout FILE:photodata respData:&respData];
    
    // Login Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
//        NSString *token = [respData objectForKey:@"session_token"];
        NSString *token = [respData objectForKey:@"error"];

        [self setM_strUserSecurity: token];
        [self setM_bLogin: YES];
    }
    
    [respData release];
    
    return YES;
}

- (BOOL) ForgotPassword: (NSString *)strEmail {
    
    // Initial Checking...
    if (!strEmail || !communication) {
        return NO;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_forgot_password:strEmail respData: &respData];
    
    // Login Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
        
    }
    
    [respData release];
    
    return YES;
}

- (NSInteger) Sync: (NSString *) events {
    
    // Initial Checking...
    if (!m_strUserSecurity || !events || !communication) {
        return 0;
    }
    
    // Read Datas...
    NSDictionary *respData;
    BOOL bResult = [communication comm_sync:m_strUserSecurity lat:[NSString stringWithFormat:@"%f", _fcurrent_x] lng:[NSString stringWithFormat:@"%f", _fcurrent_y] events:events respData:&respData];
    
    // Login Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return 0;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    NSInteger nRetCode = 0;
    
    if ([strStatus isEqualToString:@"success"] == YES) {
        NSLog(@"Sync is successful");
        
        DBConnector *dbConn = [[DBConnector alloc] init];

        // Events
        NSArray *arrayEvents = [respData objectForKey:@"events"];
        
        [dbConn clearEvents];
        
        
        for (NSInteger nIndex = 0; nIndex < [arrayEvents count]; nIndex++) {
            NSDictionary *dictItem = [arrayEvents objectAtIndex: nIndex];
            
            ScheduleItem *scheduleItem = [[ScheduleItem alloc] initWithDictionary:dictItem];
            [dbConn insertEvent: scheduleItem];
            [scheduleItem release];
          //  dbConn insertEvent:
        }
         
                
        // Settings
        NSDictionary *dictSettings = [respData objectForKey:@"settings"];

        [dbConn clearSettings];
        
        if (m_mySettingInfo != nil) {
            [m_mySettingInfo release];
        }
        
        m_mySettingInfo = [[SettingItem alloc] initWithDictionary: dictSettings];
        
        [dbConn insertSetting: m_mySettingInfo];
        
        // Groups
        NSArray *arrayGroups = [dictSettings objectForKey:@"groups"];
        
        [dbConn clearGroups];
        
        for (NSInteger nIndex = 0; nIndex < [arrayGroups count]; nIndex++) {
            NSDictionary *dictItem = [arrayGroups objectAtIndex: nIndex];
            
            GroupItem *groupItem = [[GroupItem alloc] initWithDictionary:dictItem];
            [dbConn insertGroup: groupItem];
            [groupItem release];
        }

        
        // Friends
        
        NSArray *arrayFriends = [respData objectForKey:@"friends"];
        
        [dbConn clearFriends];
        
        for (NSInteger nIndex = 0; nIndex < [arrayFriends count]; nIndex++) {
            NSDictionary *dictItem = [arrayFriends objectAtIndex: nIndex];
            
            FriendItem *friendItem = [[FriendItem alloc] initWithDictionary:dictItem];
            [dbConn insertFriend: friendItem];
            [friendItem release];
            //  dbConn insertEvent:
        }
        
        // Notifications
        
        NSArray *arrayNotifications = [respData objectForKey:@"notifications"];
        
        [dbConn clearNotifications];
        
        for (NSInteger nIndex = 0; nIndex < [arrayNotifications count]; nIndex++) {
            NSDictionary *dictItem = [arrayNotifications objectAtIndex: nIndex];
            
            NotificationItem *notiItem = [[NotificationItem alloc] initWithDictionary:dictItem];
            [dbConn insertNotification: notiItem];
            [notiItem release];
            //  dbConn insertEvent:
        }
        
        // Pendings
        
        NSArray *arrayPendings = [respData objectForKey:@"pendings"];
        
        [dbConn clearPendings];
        
        for (NSInteger nIndex = 0; nIndex < [arrayPendings count]; nIndex++) {
            NSDictionary *dictItem = [arrayPendings objectAtIndex: nIndex];
            
            PendingItem *pendingItem = [[PendingItem alloc] initWithDictionary:dictItem];
            [dbConn insertPending: pendingItem];
            [pendingItem release];
            //  dbConn insertEvent:
        }
        
        // Requests
        
        NSArray *arrayRequests = [respData objectForKey:@"requests"];
        
        [dbConn clearRequests];
        
        for (NSInteger nIndex = 0; nIndex < [arrayRequests count]; nIndex++) {
            NSDictionary *dictItem = [arrayRequests objectAtIndex: nIndex];
            
            RequestItem *requestItem = [[RequestItem alloc] initWithDictionary:dictItem];
            [dbConn insertRequest: requestItem];
            [requestItem release];
            //  dbConn insertEvent:
        }
        
        
        // Invites
        
        NSArray *arrayInvites = [respData objectForKey:@"invites"];
        
        [dbConn clearInvites];
        
        for (NSInteger nIndex = 0; nIndex < [arrayInvites count]; nIndex++) {
            NSDictionary *dictItem = [arrayInvites objectAtIndex: nIndex];
            
            InviteItem *inviteItem = [[InviteItem alloc] initWithDictionary:dictItem];
            [dbConn insertInvite: inviteItem];
            [inviteItem release];
            //  dbConn insertEvent:
        }
        
        // Weathers
        
        NSArray *arrayWeathers = [respData objectForKey:@"weathers"];
        
        [dbConn clearWeathers];
        
        for (NSInteger nIndex = 0; nIndex < [arrayWeathers count]; nIndex++) {
            NSDictionary *dictItem = [arrayWeathers objectAtIndex: nIndex];
            
            WeatherItem *weatherItem = [[WeatherItem alloc] initWithDictionary:dictItem];
            [dbConn insertWeather: weatherItem];
            [weatherItem release];
            //  dbConn insertEvent:
        }
        
        [dbConn release];
        nRetCode = 1;
    } else {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        nRetCode = 0;
        
    }
    [respData release];
    return nRetCode;
}

- (NSInteger) AddEvent: (ScheduleItem *) newEvent {
    
    SBJsonWriter *jsonWriter = [[[SBJsonWriter alloc] init] autorelease];
    
    NSString *strjSonGuests = [jsonWriter stringWithObject: newEvent.arrayGuests];

    
    if (newEvent.eventId > 0) {
        return [self EditEvent:[NSString stringWithFormat:@"%d", newEvent.eventId]  datetimestart:newEvent.eventStartDay datetimeend:newEvent.eventEndDay eventname:newEvent.eventName ical_event_id:newEvent.iCalEventId location:newEvent.eventLocation latitude:newEvent.eventLatitude longitude:newEvent.eventLongitude description:newEvent.eventDescription eventtype:newEvent.eventType guestlist:strjSonGuests reminder:newEvent.eventReminder avail:newEvent.eventAvailability recurring:newEvent.eventRecurring event_length:newEvent.eventLength event_pid:newEvent.eventPID];
    }
    
    return [self AddEvent: newEvent.eventStartDay datetimeend:newEvent.eventEndDay eventname:newEvent.eventName ical_event_id:newEvent.iCalEventId location:newEvent.eventLocation latitude: newEvent.eventLatitude longitude: newEvent.eventLongitude description: newEvent.eventDescription eventtype: newEvent.eventType guestlist:strjSonGuests reminder:newEvent.eventReminder avail: newEvent.eventAvailability recurring:newEvent.eventRecurring event_length:newEvent.eventLength];
}

- (NSInteger) AddEvent: (NSString *) date_time_start datetimeend: (NSString *) date_time_end eventname: (NSString *) event_name ical_event_id: (NSString *) ical_event_id location: (NSString *) location latitude: (NSString *) location_lat longitude: (NSString *) location_lon description: (NSString *) description eventtype: (NSString *) event_type guestlist: (NSString *) guest_list reminder: (NSString *) reminder avail: (NSString *) availability recurring: (NSString *) recurring event_length: (NSString *) eventlength {
    
    // Initial Checking...
    if (!m_strUserSecurity || !communication) {
        return 0;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    NSDate *stDate = [CommonApi getDateTimeFromString: date_time_start];
    NSDate *enDate = [CommonApi getDateTimeFromString: date_time_end];
    
    BOOL bResult = [communication comm_add_event:m_strUserSecurity eventname:event_name ical_event_id: ical_event_id datetimestart:[CommonApi getGMTDateTime: stDate] datetimend:[CommonApi getGMTDateTime: enDate] location:location lat:location_lat lng:location_lon desc:description eventtype:event_type guestlist:guest_list reminder: reminder avail:availability recurring:recurring event_length:eventlength respData:&respData];
    
    // Add Event Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return 0;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    NSInteger nRetCode = 0;
    
    if ([strStatus isEqualToString:@"success"] == YES) {
        NSLog(@"Add Event is successful");
        
        DBConnector *dbConn = [[DBConnector alloc] init];
        
        // Events
        NSArray *arrayEvents = [respData objectForKey:@"events"];
        
        [dbConn clearEvents];
        
        for (NSInteger nIndex = 0; nIndex < [arrayEvents count]; nIndex++) {
            NSDictionary *dictItem = [arrayEvents objectAtIndex: nIndex];
            
            ScheduleItem *scheduleItem = [[ScheduleItem alloc] initWithDictionary:dictItem];
            [dbConn insertEvent: scheduleItem];
            [scheduleItem release];
            //  dbConn insertEvent:
        }

        [dbConn release];
        
        nRetCode = 1;
    } else {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        nRetCode = 0;
        
    }
    
    [respData release];
    return nRetCode;
}

- (NSInteger) EditEvent: (NSString *) event_id datetimestart: (NSString *) date_time_start datetimeend: (NSString *) date_time_end eventname: (NSString *) event_name ical_event_id: (NSString *) ical_event_id location: (NSString *) location latitude: (NSString *) location_lat longitude: (NSString *) location_lon description: (NSString *) description eventtype: (NSString *) event_type guestlist: (NSString *) guest_list reminder: (NSString *) reminder avail: (NSString *) availability recurring: (NSString *) recurring event_length: (NSString *) eventlength event_pid: (NSString *) eventpid {
    
    // Initial Checking...
    if (!m_strUserSecurity || !communication) {
        return 0;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    NSDate *stDate = [CommonApi getDateTimeFromString: date_time_start];
    NSDate *enDate = [CommonApi getDateTimeFromString: date_time_end];
    
    BOOL bResult = [communication comm_edit_event:m_strUserSecurity eventid:event_id eventname:event_name ical_event_id:ical_event_id datetimestart:[CommonApi getGMTDateTime: stDate] datetimend:[CommonApi getGMTDateTime: enDate] location:location lat:location_lat lng:location_lon desc:description eventtype:event_type guestlist:guest_list reminder: reminder avail:availability recurring:recurring event_length:eventlength event_pid:eventpid respData:&respData];
    
    // Edit Event Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return 0;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    NSInteger nRetCode = 0;
    
    if ([strStatus isEqualToString:@"success"] == YES) {
        NSLog(@"Edit Event is successful");
        
        DBConnector *dbConn = [[DBConnector alloc] init];
        
        // Events
        NSArray *arrayEvents = [respData objectForKey:@"events"];
        
        [dbConn clearEvents];
        
        for (NSInteger nIndex = 0; nIndex < [arrayEvents count]; nIndex++) {
            NSDictionary *dictItem = [arrayEvents objectAtIndex: nIndex];
            
            ScheduleItem *scheduleItem = [[ScheduleItem alloc] initWithDictionary:dictItem];
            [dbConn insertEvent: scheduleItem];
            [scheduleItem release];
            //  dbConn insertEvent:
        }
        
        [dbConn release];
        
        nRetCode = 1;
    } else {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        nRetCode = 0;
        
    }
    
    [respData release];
    return nRetCode;
}

- (NSInteger) DeleteEvent: (NSString *) event_id {
    
    // Initial Checking...
    if (!m_strUserSecurity || !event_id || !communication) {
        return 0;
    }
    
    // Read Datas...
    NSDictionary *respData;
    BOOL bResult = [communication comm_delete_event:m_strUserSecurity eventid:event_id respData:&respData];
    
    // Delete Event Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return 0;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    NSInteger nRetCode = 0;
    
    if ([strStatus isEqualToString:@"success"] == YES) {
        NSLog(@"Delete Event is successful");
        
        DBConnector *dbConn = [[DBConnector alloc] init];
        
        // Events
        NSArray *arrayEvents = [respData objectForKey:@"events"];
        
        [dbConn clearEvents];
        
        for (NSInteger nIndex = 0; nIndex < [arrayEvents count]; nIndex++) {
            NSDictionary *dictItem = [arrayEvents objectAtIndex: nIndex];
            
            ScheduleItem *scheduleItem = [[ScheduleItem alloc] initWithDictionary:dictItem];
            [dbConn insertEvent: scheduleItem];
            [scheduleItem release];
            //  dbConn insertEvent:
        }
        
        [dbConn release];
        
        nRetCode = 1;
    } else {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        nRetCode = 0;
        
    }
    
    [respData release];
    return nRetCode;
}

- (NSInteger) UpdateStatus: (NSString *) status {
    
    // Initial Checking...
    if (!m_strUserSecurity || !status || !communication) {
        return 0;
    }
    
    // Read Datas...
    NSDictionary *respData;
    BOOL bResult = [communication comm_update_status:m_strUserSecurity status:status respData:&respData];
    
    // Update Status Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return 0;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    NSInteger nRetCode = 0;
    
    if ([strStatus isEqualToString:@"success"] == YES) {
        NSLog(@"Update Status is successful");
        
        if ([[respData objectForKey:@"status"] isEqual:@"busy"]) {
            self.m_bAvailable = NO;
        } else if ([[respData objectForKey:@"status"] isEqual:@"available"]) {
            self.m_bAvailable = YES;
        }
        
        nRetCode = 1;
    } else {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        nRetCode = 0;
        
    }
    
    [respData release];
    return nRetCode;
}

- (NSInteger) Search: (NSString *) search_string {
    
    // Initial Checking...
    if (!m_strUserSecurity || !search_string || !communication) {
        return 0;
    }
    
    // Read Datas...
    NSDictionary *respData;
    BOOL bResult = [communication comm_search:m_strUserSecurity search:search_string respData:&respData];
    
    // Search Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return 0;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    NSInteger nRetCode = 0;
    
    if ([strStatus isEqualToString:@"success"] == YES) {
        NSLog(@"Search is successful");
        
        [m_arraySearchResults removeAllObjects];
        
        [m_arraySearchResults addObjectsFromArray: [respData objectForKey:@"search_result"]];
        
        nRetCode = 1;
    } else {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        nRetCode = 0;
        
    }
    
    [respData release];
    return nRetCode;
}

- (BOOL) GetFriendEvents: (NSString *) member_id {
    // Initial Checking...
    if (!m_strUserSecurity || !member_id || !communication) {
        return NO;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_get_friend_events: m_strUserSecurity memberid:member_id respData:&respData];
    
    // Add Friend Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
        
        DBConnector *dbConn = [[DBConnector alloc] init];
        
        // Events
        NSArray *arrayEvents = [respData objectForKey:@"events"];
        
        [dbConn clearEventsbyID: member_id];
        
        for (NSInteger nIndex = 0; nIndex < [arrayEvents count]; nIndex++) {
            NSDictionary *dictItem = [arrayEvents objectAtIndex: nIndex];
            
            ScheduleItem *scheduleItem = [[ScheduleItem alloc] initWithDictionary:dictItem];
            [dbConn insertEvent: scheduleItem];
            [scheduleItem release];
            //  dbConn insertEvent:
        }
        
        [dbConn release];
        
        // Pendings
        
        /*
        DBConnector *dbConn = [[DBConnector alloc] init];
        
        NSArray *arrayPendings = [respData objectForKey:@"pendings"];
        
        [dbConn clearPendings];
        
        for (NSInteger nIndex = 0; nIndex < [arrayPendings count]; nIndex++) {
            NSDictionary *dictItem = [arrayPendings objectAtIndex: nIndex];
            
            PendingItem *pendingItem = [[PendingItem alloc] initWithDictionary:dictItem];
            [dbConn insertPending: pendingItem];
            [pendingItem release];
            //  dbConn insertEvent:
        }
        
        [dbConn release];
         */
    }
    
    [respData release];
    
    return YES;
}

- (BOOL) AddFriend: (NSString *) member_id {
    
    // Initial Checking...
    if (!m_strUserSecurity || !member_id || !communication) {
        return NO;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_add_friend:m_strUserSecurity memberid:member_id respData:&respData];
    
    // Add Friend Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
        // Pendings
        
        DBConnector *dbConn = [[DBConnector alloc] init];

        NSArray *arrayPendings = [respData objectForKey:@"pendings"];
        
        [dbConn clearPendings];
        
        for (NSInteger nIndex = 0; nIndex < [arrayPendings count]; nIndex++) {
            NSDictionary *dictItem = [arrayPendings objectAtIndex: nIndex];
            
            PendingItem *pendingItem = [[PendingItem alloc] initWithDictionary:dictItem];
            [dbConn insertPending: pendingItem];
            [pendingItem release];
            //  dbConn insertEvent:
        }
        
        [dbConn release];
    }
    
    [respData release];
    
    return YES;
}


- (BOOL) DeleteFriend: (NSString *) member_id {
    
    // Initial Checking...
    if (!m_strUserSecurity || !member_id || !communication) {
        return NO;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_delete_friend:m_strUserSecurity memberid:member_id respData:&respData];
    
    // DeleteFriend Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
        
    }
    
    [respData release];
    
    return YES;
}

- (BOOL) EditFriendSettings: (NSString *) member_id setting: (NSString *)strSetting {
    
    // Initial Checking...
    if (!m_strUserSecurity || !member_id || !strSetting || !communication) {
        return NO;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_edit_friend_settings:m_strUserSecurity memberid:member_id setting:strSetting respData:&respData];
    
    // EditFriendSettings Failed
    
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
        
    }
    
    [respData release];
    
    return YES;
}


- (BOOL) AcceptFriendRequest: (NSString *) friend_request_id {
    
    // Initial Checking...
    if (!m_strUserSecurity || !friend_request_id || !communication) {
        return NO;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_accept_friend_request:m_strUserSecurity friendrequestid:friend_request_id respData: &respData];
    
    // Accept Friend Request Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
        DBConnector *dbConn = [[DBConnector alloc] init];
        
        // Friends
        
        NSArray *arrayFriends = [respData objectForKey:@"friends"];
        
        [dbConn clearFriends];
        
        for (NSInteger nIndex = 0; nIndex < [arrayFriends count]; nIndex++) {
            NSDictionary *dictItem = [arrayFriends objectAtIndex: nIndex];
            
            FriendItem *friendItem = [[FriendItem alloc] initWithDictionary:dictItem];
            [dbConn insertFriend: friendItem];
            [friendItem release];
            //  dbConn insertEvent:
        }
        
        // Requests
        
        NSArray *arrayRequests = [respData objectForKey:@"requests"];
        
        [dbConn clearRequests];
        
        for (NSInteger nIndex = 0; nIndex < [arrayRequests count]; nIndex++) {
            NSDictionary *dictItem = [arrayRequests objectAtIndex: nIndex];
            
            RequestItem *requestItem = [[RequestItem alloc] initWithDictionary:dictItem];
            [dbConn insertRequest: requestItem];
            [requestItem release];
            //  dbConn insertEvent:
        }
        
        [dbConn release];

    }
    
    [respData release];
    
    return YES;
}

- (BOOL) DeclineFriendRequest: (NSString *) friend_request_id {
    
    // Initial Checking...
    if (!m_strUserSecurity || !friend_request_id || !communication) {
        return NO;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_decline_friend_request:m_strUserSecurity friendrequestid:friend_request_id respData: &respData];
    
    // Decline Friend Request Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
        DBConnector *dbConn = [[DBConnector alloc] init];
        
        // Friends
        
        NSArray *arrayFriends = [respData objectForKey:@"friends"];
        
        [dbConn clearFriends];
        
        for (NSInteger nIndex = 0; nIndex < [arrayFriends count]; nIndex++) {
            NSDictionary *dictItem = [arrayFriends objectAtIndex: nIndex];
            
            FriendItem *friendItem = [[FriendItem alloc] initWithDictionary:dictItem];
            [dbConn insertFriend: friendItem];
            [friendItem release];
            //  dbConn insertEvent:
        }
        
        // Requests
        
        NSArray *arrayRequests = [respData objectForKey:@"requests"];
        
        [dbConn clearRequests];
        
        for (NSInteger nIndex = 0; nIndex < [arrayRequests count]; nIndex++) {
            NSDictionary *dictItem = [arrayRequests objectAtIndex: nIndex];
            
            RequestItem *requestItem = [[RequestItem alloc] initWithDictionary:dictItem];
            [dbConn insertRequest: requestItem];
            [requestItem release];
            //  dbConn insertEvent:
        }
        
        [dbConn release];
    }
    
    [respData release];
    
    return YES;
}

- (BOOL) AcceptEventInvite: (NSString *) event_invite_id {
    
    // Initial Checking...
    if (!m_strUserSecurity || !event_invite_id || !communication) {
        return NO;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_accept_event_invite:m_strUserSecurity eventinviteid:event_invite_id respData:&respData];
    
    // Accept Friend Request Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
        DBConnector *dbConn = [[DBConnector alloc] init];
        
        // Events
        
        NSArray *arrayEvents = [respData objectForKey:@"events"];
        
        [dbConn clearEvents];
        
        for (NSInteger nIndex = 0; nIndex < [arrayEvents count]; nIndex++) {
            NSDictionary *dictItem = [arrayEvents objectAtIndex: nIndex];
            
            ScheduleItem *eventItem = [[ScheduleItem alloc] initWithDictionary:dictItem];
            [dbConn insertEvent: eventItem];
            [eventItem release];
            //  dbConn insertEvent:
        }
        
        [dbConn release];
        
    }
    
    [respData release];
    
    return YES;
}

- (BOOL) DeclineEventInvite: (NSString *) event_invite_id {
    
    // Initial Checking...
    if (!m_strUserSecurity || !event_invite_id || !communication) {
        return NO;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_decline_event_invite:m_strUserSecurity eventinviteid:event_invite_id respData:&respData];
    
    // Decline Friend Request Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
        DBConnector *dbConn = [[DBConnector alloc] init];
        [dbConn release];
    }
    
    [respData release];
    
    return YES;
}


- (BOOL) ReadNotification: (NSString *) notification_id {
    
    // Initial Checking...
    if (!m_strUserSecurity || !notification_id || !communication) {
        return NO;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_read_notification:m_strUserSecurity notificationid:notification_id respData:&respData];
    
    // Read Notification Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
        DBConnector *dbConn = [[DBConnector alloc] init];
    
        // Notifications
        
        NSArray *arrayNotifications = [respData objectForKey:@"notifications"];
        
        [dbConn clearNotifications];
        
        for (NSInteger nIndex = 0; nIndex < [arrayNotifications count]; nIndex++) {
            NSDictionary *dictItem = [arrayNotifications objectAtIndex: nIndex];
            
            NotificationItem *notiItem = [[NotificationItem alloc] initWithDictionary:dictItem];
            [dbConn insertNotification: notiItem];
            [notiItem release];
            //  dbConn insertEvent:
        }
        
        [dbConn release];

    }
    
    [respData release];
    
    return YES;
}

- (BOOL) UpdateSettings: (NSString *)strFirstName lastname: (NSString *) strLastName phone: (NSString *) strphone address: (NSString *) straddr occupation: (NSString *) stroccupation aboutme: (NSString *) straboutme birthdate: (NSString *) strbirthdate eventcolor: (NSString *) streventcolor timepreference: (NSString *) strtimepreference groupsettings: (NSString *)strgroupsettings {
    
    // Initial Checking...
    if (!m_strUserSecurity ||!communication) {
        return NO;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_update_settings:m_strUserSecurity new_first_name:strFirstName new_last_name: strLastName new_phone_number:strphone new_address:straddr new_occupation:stroccupation new_about_me:straboutme new_birth_date:strbirthdate new_event_color: streventcolor new_time_preference:strtimepreference new_group_settings:strgroupsettings respData:&respData];
    
    // Login Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
        // Settings
        DBConnector *dbConn = [[DBConnector alloc] init];

        
        NSDictionary *dictSettings = [respData objectForKey:@"settings"];
        
        [dbConn clearSettings];
        
        if (m_mySettingInfo != nil) {
            [m_mySettingInfo release];
        }
        
        m_mySettingInfo = [[SettingItem alloc] initWithDictionary: dictSettings];
        
        [dbConn insertSetting: m_mySettingInfo];

    }
    
    [respData release];
    
    return YES;
}

- (BOOL) ChangePassword: (NSString *)strcurrent newpassword: (NSString *) strnew {
    
    // Initial Checking...
    if (!m_strUserSecurity || !strcurrent || !strnew || !communication) {
        return NO;
    }
    
    // Read Datas...
    NSDictionary *respData;
    
    BOOL bResult = [communication comm_change_password: m_strUserSecurity currentpass:strcurrent newpass:strnew respData: &respData];
    
    // Login Failed
    if (!bResult) {
        [self setM_strLastErrorMessage: DATAKEEPER_CONNECTION_ERR_MSG];
        return NO;  // network error, or invalid URL/parameter
    }
    
    NSString *strStatus = [respData objectForKey:@"result"];
    
    if ([strStatus isEqualToString:@"success"] == NO) {
        NSString *strMsg = [respData objectForKey:@"error"];
        [self setM_strLastErrorMessage: strMsg];
        return NO;
    } else {
        
    }
    
    [respData release];
    
    return YES;
}

- (NSString *) getProfileImageURL {
    NSString *strImgURL = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, m_mySettingInfo.profilepicture];
    
    return strImgURL;
}


#pragma mark - Image Caching

- (void)CreateThreadDownloadImages {
    [NSThread detachNewThreadSelector:@selector(DownloadImages) toTarget:self withObject:nil];
}

- (void) DownloadImages {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    NSLog(@"Start Downloading....");
    
    [self saveDataToFile];
    [autoreleasePool release];
}


// This functions is to get Image from URL
// If the image isnt in local, download and save to local
// If the image is already in local, use it.

- (UIImage *)getImage: (NSString *) strURL {
    
    if (strURL == nil || [strURL isKindOfClass:[NSString class]] == NO || [strURL isEqualToString:@""]) {
        return nil;
    }
    
    // Get Local URL of image
    NSString *strLocalURL = [m_dictLocalImageCaches objectForKey:strURL];
    
    UIImage *image;
    
    // If image isnt in local, download and save it to local.
    if (strLocalURL == nil || [strLocalURL isEqualToString:@""]) {
        
        // Get image data from URL.
        NSData* imgData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString: 
                                                                 strURL]];
        
        // Generate local file name
        NSString *strFileName = [CUtils generateFileName: NO];
        
        NSString *tempPath = [NSString stringWithFormat:@"%@/%@", [CUtils getDocumentDirectory], strFileName];
        
        // Write Image data as a local file.
        if ([imgData length] != 0) {
            if ([imgData writeToFile:tempPath atomically:YES] == YES) {
                [m_dictLocalImageCaches setObject:tempPath forKey:strURL];
            }
            
            image = [UIImage imageWithData:imgData];
            
            if (!image)
                image = nil;
        } else {
            image = nil;
        }
        
        [imgData release];        
    } else {
        
        NSLog(@"Local URL = %@", strLocalURL);
    // If image is already in local, use it.
       image = [UIImage imageWithContentsOfFile: strLocalURL];
    }
    
    return image;
}

- (UIImage *)getLocalImage: (NSString *) strURL {
    
    // Get Local URL of image
    NSString *strLocalURL = [m_dictLocalImageCaches objectForKey:strURL];
    
    UIImage *image;
    
    // If image isnt in local, download and save it to local.
    if (strLocalURL == nil || [strLocalURL isEqualToString:@""]) {
        return nil;
    } else {
        // If image is already in local, use it.
        image = [UIImage imageWithContentsOfFile: strLocalURL];
    }
    
    return image;
}


#pragma mark - Local Management

// All datas will be written in local file
// Image List, User Name, User Password, User setting information

- (BOOL)saveDataToFile
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:m_dictLocalImageCaches forKey:@"images"];
        
    BOOL bSuccess = [dic writeToFile:[self dataFilePath] atomically:YES];
    
    if (bSuccess) {
        NSLog(@"Write to file successfully. dic=%@", dic);
    } else {
        NSLog(@"Write to file failed");
    }
    
    [dic release];
    
    return bSuccess;
}

- (BOOL)loadDataFromFile
{
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        
        NSLog(@"LoadDatas!, Dic = %@", dic);
        
        NSDictionary *dict = [dic objectForKey:@"images"];
        
        if (dict != nil && [dict count] > 0) {
            [self setM_dictLocalImageCaches: [dic objectForKey:@"images"]];
        }
        
        [dic release];
        return YES;
    }
    
    // if file is not exist, set default value
    //[self setServerAddress:[NSString stringWithString:@"http://develop.sweneno.com/index.php/"]];
    
    return NO;
}

- (NSString*)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"calendarapp.plist"];
}

@end