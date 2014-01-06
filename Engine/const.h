//
//  const.h
//  Schedule
//
//  Created by Tan Hui on 08/22/13.
//  Copyright (c) 2013 Schedule. All rights reserved.
//

#ifndef schedule_const_h
#define schedule_const_h



#endif

#define GOOGLE_APIKeyForBrowser         @"AIzaSyAFtPku_jXn8xhhhtx_G5yUs3a3_h-yZ4k"


// API
#define HOST_URL        @"http://ec2-54-211-60-170.compute-1.amazonaws.com/calendar"
#define WEBAPI_URL      @"http://ec2-54-211-60-170.compute-1.amazonaws.com/calendar/"

// AUTH
#define WEBAPI_LOGIN                     @"login.php"
#define WEBAPI_SIGNUP                    @"signup_1.php"
#define WEBAPI_SIGNUP2                   @"signup_2.php"
#define WEBAPI_FORGOT_PASSWORD           @"forgot_password.php"

#define WEBAPI_SYNC                      @"sync.php"

// Event
#define WEBAPI_ADDEVENT                  @"add_event.php"
#define WEBAPI_EDITEVENT                 @"edit_event.php"
#define WEBAPI_DELETEEVENT               @"delete_event.php"

#define WEBAPI_UPDATESTATUS              @"update_status.php"

#define WEBAPI_SEARCH                    @"search.php"


// Friend
#define WEBAPI_ADDFRIEND                    @"add_friend.php"
#define WEBAPI_GETFRIENDEVENTS              @"get_friend_events.php"
#define WEBAPI_DELETEFRIEND                 @"delete_friend.php"
#define WEBAPI_EDITFRIENDSETTINGS           @"edit_friend_settings.php"
#define WEBAPI_ACCEPTFRIENDREQUEST          @"accept_friend_request.php"
#define WEBAPI_DECLINEFRIENDREQUEST         @"decline_friend_request.php"
#define WEBAPI_ACCEPTEVENTINVITE            @"accept_event_invite.php"
#define WEBAPI_DECLINEEVENTINVITE           @"decline_event_invite.php"

// Notifications
#define WEBAPI_READNOTIFICATION             @"read_notification.php"

// Settings
#define WEBAPI_UPDATESETTINGS               @"update_settings.php"
#define WEBAPI_CHANGEPICTURE                @"change_picture.php"
#define WEBAPI_CHANGEPASSWORD               @"change_password.php"

// Alert Title
#define APP_ALERT_TITLE                 @"Schedule"

// DataKeeper error messages
#define DATAKEEPER_CONNECTION_ERR_MSG   @"Connection Error: Connection failed"
#define DATAKEEPER_INVALIDDATA_ERR_MSG  @"Server Error: Invalid Data"
#define DATAKEEPER_UNKNOWN_ERR_MSG      @"Unknow Error: Impossible to get status"

#define NOTIFICATION_NOTIFY                 @"Notification_Notification"
#define NOTIFICATION_WEATHER                @"Notification_Weather"
#define NOTIFICATION_SETTINGS               @"Notification_Settings"
#define NOTIFICATION_TODAY                  @"Notification_Today"

#define NOTIFICATION_EVENT_DELETED          @"Notification_event_deleted"

// Date Time

#define DEFAULT_DATE_FORMAT                 @"yyyy-MM-dd"
#define DEFAULT_TIME_FORMAT                 @"HH:mm"


