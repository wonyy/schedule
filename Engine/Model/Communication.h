//
//  Communication.h
//  Schedule
//
//  Created by wony on 08/22/13.
//  Copyright 2013 wony. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString *multipartBoundary;

typedef enum {
    MethodTypePost = 0,
    MethodTypeGet = 1,
    MethodTypePut = 2,
    MethodTypeDelete
} MethodType;

// communication interface
@interface Communication : NSObject

// Login
- (BOOL)comm_login: (NSString *)strlogin password: (NSString *)strpass lat: (NSString *)latitude lng: (NSString *) longitude respData: (NSDictionary **)respData;

// Signup
- (BOOL)comm_signup: (NSString *)stremail first_name: (NSString *) firstname last_name: (NSString *) lastname respData: (NSDictionary **)respData;

// Signup 2
- (BOOL)comm_signup2: (NSString *)stremail first_name: (NSString *) firstname last_name: (NSString *)lastname pass: (NSString *) strpass account_type: (NSString *) accounttype birth_date: (NSString *) birthdate phone: (NSString *) strphone address: (NSString *) straddress occupation: (NSString *) stroccu aboutme: (NSString *) strabout FILE: (NSData *) filedata respData: (NSDictionary **)respData ;

// Forgot Password
- (BOOL)comm_forgot_password: (NSString *) stremail respData: (NSDictionary **)respData;

// Sync
- (BOOL)comm_sync: (NSString *) session_token lat: (NSString *)latitude lng: (NSString *) longitude events: (NSString *) eventsJSON respData: (NSDictionary **)respData;

// Add Event
- (BOOL)comm_add_event: (NSString *) session_token eventname: (NSString *) event_name ical_event_id:(NSString *)ical_event_id datetimestart: (NSString *)date_time_start datetimend: (NSString *) date_time_end location: (NSString *) location lat: (NSString *) location_lat lng: (NSString *) location_lon desc: (NSString *) description eventtype: (NSString *)event_type guestlist: (NSString *) guest_list reminder: (NSString *) reminder avail: (NSString *) availability recurring: (NSString *) recurring event_length: (NSString *) eventlength respData: (NSDictionary **)respData;

// Edit Event
- (BOOL)comm_edit_event: (NSString *) session_token eventid: (NSString *) event_id eventname: (NSString *) event_name ical_event_id:(NSString *)ical_event_id datetimestart: (NSString *)date_time_start datetimend: (NSString *) date_time_end location: (NSString *) location lat: (NSString *) location_lat lng: (NSString *) location_lon desc: (NSString *) description eventtype: (NSString *)event_type guestlist: (NSString *) guest_list reminder: (NSString *) reminder avail: (NSString *) availability recurring: (NSString *) recurring event_length: (NSString *) eventlength event_pid: (NSString *) eventpid respData: (NSDictionary **)respData;

// Delete Event
- (BOOL)comm_delete_event: (NSString *) session_token eventid: (NSString *) event_id respData: (NSDictionary **)respData;

// Update Status
- (BOOL)comm_update_status: (NSString *) session_token status: (NSString *) status respData: (NSDictionary **)respData;

// Search
- (BOOL)comm_search: (NSString *) session_token search: (NSString *) search_string respData: (NSDictionary **)respData;

// Get Friend Events
- (BOOL)comm_get_friend_events: (NSString *) session_token memberid: (NSString *) member_id respData: (NSDictionary **)respData;

// Add Friend
- (BOOL)comm_add_friend: (NSString *) session_token memberid: (NSString *) member_id respData: (NSDictionary **)respData;

// Delete Friend
- (BOOL)comm_delete_friend: (NSString *) session_token memberid: (NSString *) member_id respData: (NSDictionary **)respData;

// Edit Friend Settings
- (BOOL)comm_edit_friend_settings: (NSString *) session_token memberid: (NSString *) member_id setting: (NSString *) setting respData: (NSDictionary **)respData;

// Accept Friend Request
- (BOOL)comm_accept_friend_request: (NSString *) session_token friendrequestid: (NSString *) friend_request_id respData: (NSDictionary **)respData;

// Decline Friend Request
- (BOOL)comm_decline_friend_request: (NSString *) session_token friendrequestid: (NSString *) friend_request_id respData: (NSDictionary **)respData;

// Accept Event Invite
- (BOOL)comm_accept_event_invite: (NSString *) session_token eventinviteid: (NSString *) event_invite_id respData: (NSDictionary **)respData;

// Decline Event Invite
- (BOOL)comm_decline_event_invite: (NSString *) session_token eventinviteid: (NSString *) event_invite_id respData: (NSDictionary **)respData;

// Read Notification
- (BOOL)comm_read_notification: (NSString *) session_token notificationid: (NSString *) notification_id respData: (NSDictionary **)respData;

// Update Settings
- (BOOL)comm_update_settings: (NSString *) strsessiontoken new_first_name: (NSString *) newfirstname new_last_name: (NSString *) newlastname new_phone_number: (NSString *) newphonenumber new_address: (NSString *) newaddress new_occupation: (NSString *)newoccupation new_about_me: (NSString *)newaboutme new_birth_date: (NSString *)newbirthdate new_event_color: (NSString *)neweventcolor new_time_preference: (NSString *) newtimepreference new_group_settings: (NSString *) newgroupsettings respData: (NSDictionary **)respData;

// Change Picture
- (BOOL)comm_change_picture: (NSString *) session_token newimage: (NSString *) new_image respData: (NSDictionary **)respData;

// Change Password
- (BOOL)comm_change_password: (NSString *) strsessiontoken currentpass: (NSString *) current_password newpass: (NSString *) new_password respData: (NSDictionary **)respData;

// internal function
- (BOOL)sendRequest:(MethodType)methodType requestURL:(NSString *)requestURL params:(NSString *)params respData:(NSDictionary **)respDic;

//  Upload File
- (BOOL)sendMultipartRequest:(NSString *)strService data:(NSData *)data respData:(NSDictionary **)respDic;
+ (BOOL)uploadFile:(NSString *)strURL filename:(NSString *)filename fileData:(NSString *)fileData respData:(NSDictionary **)respDic;
- (NSData *)makeMultipartBody:(NSDictionary*)dic;
- (void)appendFileToBody:(NSMutableData *)data filenamekey:(NSString*)filenamekey filenamevalue:(NSString*)filenamevalue filedata:(NSData*)filedata;

@end
