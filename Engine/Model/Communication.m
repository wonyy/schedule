//
//  Communication.m
//  Schedule
//
//  Created by wony on 08/22/13.
//  Copyright 2013 wony. All rights reserved.
//

#import "Communication.h"
#import "../JSON/JSON.h"

const NSString *multipartBoundary = @"-------------111";

///
// Implementation for Communication class
///
@implementation Communication

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


///
//  API:    Login
//  Param:  username/email, password, latitude, longitude
///
- (BOOL)comm_login: (NSString *)strlogin password: (NSString *)strpass lat: (NSString *)latitude lng: (NSString *) longitude respData: (NSDictionary **)respData {
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_LOGIN] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"email=%@&password=%@&latitude=%@&longitude=%@", strlogin, strpass, latitude, longitude] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}



///
//  API:    Signup
//  Param:  email, first_name, last_name
///

- (BOOL)comm_signup: (NSString *)stremail first_name: (NSString *) firstname last_name: (NSString *) lastname respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_SIGNUP] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"first_name=%@&last_name=%@&email=%@", firstname, lastname, stremail] autorelease];

    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Signup 2
//  Param:  first_name, last_name, email, password, account_type, birth_date, phone_number, address, occupation, about_me, FILE
///

- (BOOL)comm_signup2: (NSString *)stremail first_name: (NSString *) firstname last_name: (NSString *)lastname pass: (NSString *) strpass account_type: (NSString *) accounttype birth_date: (NSString *) birthdate phone: (NSString *) strphone address: (NSString *) straddress occupation: (NSString *) stroccu aboutme: (NSString *) strabout FILE: (NSData *) filedata respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_SIGNUP2] autorelease];
    
    NSMutableData *body;
    
    NSArray *paramNames = [NSArray arrayWithObjects:@"first_name", @"last_name", @"email", @"password", @"account_type", @"birth_date", @"phone_number", @"address", @"occupation", @"about_me", nil];
    
    NSArray *paramDatas = [NSArray arrayWithObjects:firstname, lastname, stremail, strpass, accounttype, birthdate, strphone, straddress, stroccu, strabout, nil];
    
    NSDictionary *dict = [[[NSDictionary alloc] initWithObjects:paramDatas forKeys:paramNames] autorelease];
    
    body = [NSMutableData dataWithData: [self makeMultipartBody: dict]];
    
    [self appendFileToBody:body filenamekey:@"FILE" filenamevalue:[CUtils generateFileName: NO] filedata:filedata];
    
    return [self sendMultipartRequest:strAction data: body respData: respData];
}

///
//  API:    Forgot Password
//  Param:  email
///

- (BOOL)comm_forgot_password: (NSString *) stremail respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_FORGOT_PASSWORD] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"email=%@",stremail] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Sync
//  Param:  session_token, latitude, longitude, events
///

- (BOOL)comm_sync: (NSString *) session_token lat: (NSString *)latitude lng: (NSString *) longitude events: (NSString *) eventsJSON respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_SYNC] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&latitude=%@&longitude=%@&events=%@", session_token, latitude, longitude, eventsJSON] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Add Event
//  Param:  session_token, event_name, ical_event_id, date_time_start, date_time_end, location, location_lat, location_lon, description, event_type, guest_list, reminder, availability, recurring, event_length
///

- (BOOL)comm_add_event: (NSString *) session_token eventname: (NSString *) event_name ical_event_id:(NSString *)ical_event_id datetimestart: (NSString *)date_time_start datetimend: (NSString *) date_time_end location: (NSString *) location lat: (NSString *) location_lat lng: (NSString *) location_lon desc: (NSString *) description eventtype: (NSString *)event_type guestlist: (NSString *) guest_list reminder: (NSString *) reminder avail: (NSString *) availability recurring: (NSString *) recurring event_length: (NSString *) eventlength respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_ADDEVENT] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&event_name=%@&ical_event_id=%@&date_time_start=%@&date_time_end=%@&location=%@&location_lat=%@&location_lon=%@&description=%@&event_type=%@&guest_list=%@&reminder=%@&availability=%@&recurring=%@&event_length=%@", session_token, event_name, ical_event_id, date_time_start, date_time_end, location, location_lat, location_lon, description, event_type, guest_list, reminder, availability, recurring, eventlength] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Edit Event
//  Param:  session_token, event_id, event_name, ical_event_id, date_time_start, date_time_end, location, location_lat, location_lon, description, event_type, guest_list, reminder, availability, recurring, event_length, event_pid
///

- (BOOL)comm_edit_event: (NSString *) session_token eventid: (NSString *) event_id eventname: (NSString *) event_name ical_event_id:(NSString *)ical_event_id datetimestart: (NSString *)date_time_start datetimend: (NSString *) date_time_end location: (NSString *) location lat: (NSString *) location_lat lng: (NSString *) location_lon desc: (NSString *) description eventtype: (NSString *)event_type guestlist: (NSString *) guest_list reminder: (NSString *) reminder avail: (NSString *) availability recurring: (NSString *) recurring event_length: (NSString *) eventlength event_pid: (NSString *) eventpid respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_EDITEVENT] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&event_id=%@&event_name=%@&ical_event_id=%@&date_time_start=%@&date_time_end=%@&location=%@&location_lat=%@&location_lon=%@&description=%@&event_type=%@&guest_list=%@&reminder=%@&availability=%@&recurring=%@&event_length=%@&event_pid=%@", session_token, event_id, event_name, ical_event_id,date_time_start, date_time_end, location, location_lat, location_lon, description, event_type, guest_list, reminder, availability, recurring, eventlength, eventpid] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Delete Event
//  Param:  session_token, event_id
///

- (BOOL)comm_delete_event: (NSString *) session_token eventid: (NSString *) event_id respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_DELETEEVENT] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&event_id=%@", session_token, event_id] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Update Status
//  Param:  session_token, status
///

- (BOOL)comm_update_status: (NSString *) session_token status: (NSString *) status respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_UPDATESTATUS] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&status=%@", session_token, status] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Search
//  Param:  session_token, search_string
///

- (BOOL)comm_search: (NSString *) session_token search: (NSString *) search_string respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_SEARCH] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&search_string=%@", session_token, search_string] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Get Friend Events
//  Param:  session_token, member_id
///

- (BOOL)comm_get_friend_events: (NSString *) session_token memberid: (NSString *) member_id respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_GETFRIENDEVENTS] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&member_id=%@", session_token, member_id] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Add Friend
//  Param:  session_token, member_id
///

- (BOOL)comm_add_friend: (NSString *) session_token memberid: (NSString *) member_id respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_ADDFRIEND] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&member_id=%@", session_token, member_id] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Delete Friend
//  Param:  session_token, member_id
///

- (BOOL)comm_delete_friend: (NSString *) session_token memberid: (NSString *) member_id respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_DELETEFRIEND] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&member_id=%@", session_token, member_id] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Edit Friend Setting
//  Param:  session_token, member_id, setting
///

- (BOOL)comm_edit_friend_settings: (NSString *) session_token memberid: (NSString *) member_id setting: (NSString *) setting respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_EDITFRIENDSETTINGS] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&member_id=%@&settings=%@", session_token, member_id, setting] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Accept Friend Request
//  Param:  session_token, friend_request_id
///

- (BOOL)comm_accept_friend_request: (NSString *) session_token friendrequestid: (NSString *) friend_request_id respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_ACCEPTFRIENDREQUEST] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&friend_request_id=%@", session_token, friend_request_id] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Decline Friend Request
//  Param:  session_token, friend_request_id
///

- (BOOL)comm_decline_friend_request: (NSString *) session_token friendrequestid: (NSString *) friend_request_id respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_DECLINEFRIENDREQUEST] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&friend_request_id=%@", session_token, friend_request_id] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Accept Event Invite
//  Param:  session_token, event_invite_id
///

- (BOOL)comm_accept_event_invite: (NSString *) session_token eventinviteid: (NSString *) event_invite_id respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_ACCEPTEVENTINVITE] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&event_invite_id=%@", session_token, event_invite_id] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Decline Event Invite
//  Param:  session_token, event_invite_id
///

- (BOOL)comm_decline_event_invite: (NSString *) session_token eventinviteid: (NSString *) event_invite_id respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_DECLINEEVENTINVITE] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&event_invite_id=%@", session_token, event_invite_id] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Read Notification
//  Param:  session_token, notification_id
///

- (BOOL)comm_read_notification: (NSString *) session_token notificationid: (NSString *) notification_id respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_READNOTIFICATION] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&notification_id=%@", session_token, notification_id] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}



///
//  API:    Update Settings
//  Param:  session_token, new_first_name, new_last_name, new_phone_number, new_address, new_occupation, new_about_me, new_birth_date, new_event_color, new_time_preference, new_group_settings
///

- (BOOL)comm_update_settings: (NSString *) strsessiontoken new_first_name: (NSString *) newfirstname new_last_name: (NSString *) newlastname new_phone_number: (NSString *) newphonenumber new_address: (NSString *) newaddress new_occupation: (NSString *)newoccupation new_about_me: (NSString *)newaboutme new_birth_date: (NSString *)newbirthdate new_event_color: (NSString *)neweventcolor new_time_preference: (NSString *) newtimepreference new_group_settings: (NSString *) newgroupsettings respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_UPDATESETTINGS] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&new_first_name=%@&new_last_name=%@&new_phone_number=%@&new_address=%@&new_occupation=%@&new_about_me=%@&new_birth_date=%@&new_event_color=%@&new_date_time_pref=%@&new_group_settings=%@", strsessiontoken, newfirstname, newlastname, newphonenumber, newaddress, newoccupation, newaboutme, newbirthdate, neweventcolor, newtimepreference, newgroupsettings] autorelease];
    
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Change Picture
//  Param:  session_token, new_image
///

- (BOOL)comm_change_picture: (NSString *) session_token newimage: (NSString *) new_image respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_CHANGEPICTURE] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&new_image=%@", session_token, new_image] autorelease];
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

///
//  API:    Change Password
//  Param:  session_token, current_password, new_password
///

- (BOOL)comm_change_password: (NSString *) strsessiontoken currentpass: (NSString *) current_password newpass: (NSString *) new_password respData: (NSDictionary **)respData {
    
    NSString *strAction = [[[NSString alloc] initWithFormat:@"%@%@", WEBAPI_URL, WEBAPI_CHANGEPASSWORD] autorelease];
    
    NSString *strRequestParams = [[[NSString alloc] initWithFormat:@"session_token=%@&current_password=%@&new_password=%@", strsessiontoken, current_password, new_password] autorelease];
    
    
    return [self sendRequest:MethodTypePost requestURL:strAction params:strRequestParams respData:respData];
}

- (NSString*)authValueWithUsername:(NSString *)salt password:(NSString*)password
{
    NSString *salted = [NSString stringWithFormat:@"%@{%@}", password, salt];
    NSString *digest = [CUtils createSHA512: salted];
    
    for (NSInteger nIndex = 1; nIndex < 5000; nIndex++) {
        digest = [CUtils createSHA512: [NSString stringWithFormat:@"%@%@", digest, salted]];
    }
    
    NSData *authData = [digest dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"%@", [self base64forData:authData]];
    return authValue;
}

- (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}


/// parameter - respData is reatined in this function
- (BOOL)sendRequest:(MethodType)methodType requestURL:(NSString *)requestURL params:(NSString *)params respData:(NSDictionary **)respDic
{
    NSLog(@"Request URL: %@", requestURL);
    NSLog(@"PARAMS: %@", params);
    
    NSString *encodedUrl = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodedUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // message type
    if (methodType == MethodTypePost) {
        [request setHTTPMethod:@"POST"];
    } else if (methodType == MethodTypeGet) {
        [request setHTTPMethod:@"GET"];
    } else if (methodType == MethodTypePut) {
        [request setHTTPMethod:@"PUT"];
    } else {
        [request setHTTPMethod:@"DELETE"];
    }
    
    // message body
    if (params) {
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!responseData) {
        // "Connection Error", "Failed to Connect to the Internet"
        NSLog(@"%@", [error description]);
        return NO;
    }
    
    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"RECEIVED DATA : %@", respString);
    
    SBJSON *parser = [[[SBJSON alloc] init] autorelease];
    NSDictionary *dic = (NSDictionary *)[parser objectWithString:respString error:nil];
    [dic retain];
    *respDic = dic;
    return YES;
}

///////////////////////////////////////////////
///////// File Upload
///////////////////////////////////////////////


- (BOOL)sendMultipartRequest:(NSString *)strService data:(NSData *)data respData:(NSDictionary **)respDic
{
    NSMutableString *strURL = [NSMutableString stringWithString:strService];
    
    NSLog(@"URL: %@", strURL);
   // NSLog(@"PARAMS: %@", data);
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", multipartBoundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!response) {
        // "Connection Error", "Failed to Connect to the URL"
        NSLog(@"%@", [error description]);
        return NO;
    }
    
    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"RECEIVED DATA : %@", respString);
    
    SBJSON *parser = [[[SBJSON alloc] init] autorelease];
    NSDictionary *dic = (NSDictionary *)[parser objectWithString:respString error:nil];
    if (dic == nil) 
        return NO;  // invalid JSON format
    
    [dic retain];
    *respDic = dic;
    return YES;
}

+ (BOOL)uploadFile:(NSString *)strURL filename:(NSString *)filename fileData:(NSString *)fileData respData:(NSDictionary **)respDic {
    
    NSLog(@"URL: %@", strURL);
    NSLog(@"FileName: %@", filename);
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", multipartBoundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
	NSMutableData *body = [NSMutableData data];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"orderfile\"; filename=\"%@\"\r\n", filename]] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-type: application/octet-stream\r\n\r\n" dataUsingEncoding: NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"%@", fileData]] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody: body];
    
    NSError *error;
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (!response) {
        // "Connection Error", "Failed to Connect to the URL"
        NSLog(@"%@", [error description]);
        return NO;
    }
    
    NSString *respString = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"RECEIVED DATA : %@", respString);
    
    SBJSON *parser = [[[SBJSON alloc] init] autorelease];
    NSDictionary *dic = (NSDictionary *)[parser objectWithString:respString error:nil];
    if (dic == nil) 
        return NO;  // invalid JSON format
    
    [dic retain];
    *respDic = dic;
    return YES;
}


- (NSData *)makeMultipartBody:(NSDictionary*)dic {
	
	NSMutableData *data = [NSMutableData data];
	
    for (NSString *key in dic) {
        NSString *value = [dic objectForKey:key];
        // set boundary
        [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", key, value] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *logString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
   // NSLog(@"%@", logString);
    [logString release];
    
    return data;
}

- (void)appendFileToBody:(NSMutableData *)data filenamekey:(NSString*)filenamekey filenamevalue:(NSString*)filenamevalue filedata:(NSData*)filedata {
	[data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", filenamekey, filenamevalue]] dataUsingEncoding:NSUTF8StringEncoding]];
	[data appendData:[@"Content-type: application/octet-stream\r\n\r\n" dataUsingEncoding: NSUTF8StringEncoding]];
	[data appendData:filedata];
	[data appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
}


@end

