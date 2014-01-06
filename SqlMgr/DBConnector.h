//
//  DBConnector.h
//  ARSLanch
//
//  Created by Galaxy39 on 1/29/13.
//  Copyright (c) 2013 FED. All rights reserved.
//

////////////////////////////
//   tbUser_pson_IDs  : psonID, userName, pson_num
//   tbUser_accounts  : accountID, userName, account_num
//   tbUser_phones    : phoneID, userName, phone_num
//   tbUser_contractor : contractorID, userName, user_num
//   tbUser_cardInfo  : cardID, cardName, card_num, card_cvc, card_mm, card_yy
//   tbMyARS_info       : myARSId,myARSName,myARSDesc,myARSString
///////////////////////////

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "SQLMgr.h"
#import "ScheduleItem.h"
#import "SettingItem.h"
#import "FriendItem.h"
#import "NotificationItem.h"
#import "PendingItem.h"
#import "RequestItem.h"
#import "InviteItem.h"
#import "WeatherItem.h"
#import "GroupItem.h"

#define CREATE_DB_SQL_PREFIX  @"CREATE TABLE IF NOT EXISTS "
#define DELETE_DB_SQL_PREFIX    @"DROP TABLE IF EXISTS "

@interface DBConnector : NSObject {
    SQLMgr * mDatabase;
    
}

- (void)createTables;

- (void) clearEvents;
- (void) clearEventsbyID: (NSString *) strUserId;
- (void) insertEvent:(ScheduleItem *)item;
- (void) updateEvent:(ScheduleItem *)item;
- (void) makeEventOnline:(ScheduleItem *) item online: (BOOL) bOnline;
- (NSMutableArray*)getEventsAt:(NSDate *)date userID: (NSString *) struserId;
- (NSMutableArray *)getEventsAt:(NSDate *)stDate :(NSDate *)edDate;
- (ScheduleItem *)getEventFromID:(int)idx;
- (NSMutableDictionary*) getAllEventsbyID: (NSString *) strMemberId fromNow: (NSDate *) dateFromNow;
- (NSMutableArray*)getAllEventsAsArray : (NSString *) struserId;

- (void)clearSettings;
- (void)insertSetting: (SettingItem *) item;
- (void)updateSettings: (SettingItem *)item;
- (SettingItem *) getSettings;

- (void)clearGroups;
- (void)insertGroup: (GroupItem *) item;
- (void)updateGroup:(GroupItem *)item;
- (NSMutableArray *) getAllGroups;

- (void)clearGuests;
- (void)insertGuest: (NSDictionary *) item event_id: (NSString *) eventid;
- (void) AddGuests: (NSArray *) array  event_id: (NSString *) eventid;
- (NSMutableArray *) getAllGuestsByEvent: (NSString *) eventid;


- (void)clearFriends;
- (void)insertFriend: (FriendItem *) item;
- (void)updateFriend:(FriendItem *)item;
- (NSMutableArray *) getAllFriends;


- (void)clearNotifications;
- (void)insertNotification: (NotificationItem *) item;
- (void)updateNotification:(NotificationItem *)item;
- (NSMutableArray *)getAllNotifications;

- (void)clearPendings;
- (void)insertPending: (PendingItem *) item;
- (NSMutableArray *)getAllPendings;

- (void)clearRequests;
- (void)insertRequest: (RequestItem *) item;
- (void)updateRequest:(RequestItem *)item;
- (NSMutableArray *)getAllRequests;

- (void)clearInvites;
- (void)insertInvite: (InviteItem *) item;
- (void)updateInvite:(InviteItem *)item;
- (NSMutableArray *)getAllInvites;

- (void)clearWeathers;
- (void)insertWeather: (WeatherItem *) item;
- (void)updateWeather:(WeatherItem *)item;
- (NSMutableArray *)getAllWeathers;


@end
