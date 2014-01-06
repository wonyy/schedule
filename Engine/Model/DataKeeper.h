//
//  DataKeeper.h
//  Schedule
//
//  Created by wony on 08/22/13.
//  Copyright 2013 wony. All rights reserved.
//  

#import "SingletonClass.h"
#import "Communication.h"
#import "SettingItem.h"
#import "ScheduleItem.h"

@interface DataKeeper : SingletonClass {
    
    // communicator
    Communication *communication;
    
    NSString    *m_strLastErrorMessage;
    
    NSMutableDictionary *m_dictLocalImageCaches;
}
// Device Token
@property (nonatomic, retain) NSString *m_strDeviceToken;

@property (nonatomic, retain) NSString *m_strUserSecurity;


// User Login Information
@property (nonatomic, retain) NSString *m_strUserName;
@property (nonatomic, retain) NSString *m_strUserEmail;
@property (nonatomic, retain) NSString *m_strUserMobile;
@property (nonatomic, retain) NSString *m_strUserHomeAddress;
@property (nonatomic, retain) NSString *m_strUserLatitude;
@property (nonatomic, retain) NSString *m_strUserLongitude;

@property (nonatomic, retain) SettingItem *m_mySettingInfo;

@property (nonatomic, retain) NSString *m_strPickDate;

@property (nonatomic)       float    fcurrent_x;
@property (nonatomic)       float    fcurrent_y;

//
@property (nonatomic, retain) NSString *m_curLocation;
@property (nonatomic, retain) NSString *m_curLatitude;
@property (nonatomic, retain) NSString *m_curLongitude;

@property (nonatomic, retain) NSMutableArray *m_arraySearchResults;

@property (nonatomic, retain) Communication *communication;

@property (nonatomic, retain) NSString    *m_strLastErrorMessage;
@property (nonatomic, retain) NSMutableDictionary *m_dictLocalImageCaches;



@property (nonatomic) BOOL m_bLogin;
@property (nonatomic) BOOL m_bAvailable;

// communication APIs

// Auth
- (NSInteger) Login: (NSString *)strEmail strPass: (NSString *) strPassword;


- (BOOL) Signup: (NSString *) strEmail firstname: (NSString *) firstname lastname: (NSString *) lastname;
- (BOOL) Signup2: (NSString *) strEmail first: (NSString *) strFirst last: (NSString *) strLast password: (NSString *) strpass accounttype: (NSString *) strAcctType birthdate: (NSString *) strBirthdate phone: (NSString *) strphone address: (NSString *) straddr occupation: (NSString *) stroccu aboutme: (NSString *) strabout photo: (NSData *) photodata;
 
- (BOOL) ForgotPassword: (NSString *)strEmail;

- (NSInteger) Sync: (NSString *) events;

- (NSInteger) AddEvent: (NSString *) date_time_start datetimeend: (NSString *) date_time_end eventname: (NSString *) event_name ical_event_id: (NSString *) ical_event_id location: (NSString *) location latitude: (NSString *) location_lat longitude: (NSString *) location_lon description: (NSString *) description eventtype: (NSString *) event_type guestlist: (NSString *) guest_list reminder: (NSString *) reminder avail: (NSString *) availability recurring: (NSString *) recurring event_length: (NSString *) eventlength ;

- (NSInteger) AddEvent: (ScheduleItem *) newEvent;

- (NSInteger) EditEvent: (NSString *) event_id datetimestart: (NSString *) date_time_start datetimeend: (NSString *) date_time_end eventname: (NSString *) event_name ical_event_id: (NSString *) ical_event_id location: (NSString *) location latitude: (NSString *) location_lat longitude: (NSString *) location_lon description: (NSString *) description eventtype: (NSString *) event_type guestlist: (NSString *) guest_list reminder: (NSString *) reminder avail: (NSString *) availability recurring: (NSString *) recurring event_length: (NSString *) eventlength event_pid: (NSString *) eventpid;

- (NSInteger) DeleteEvent: (NSString *) event_id;

- (NSInteger) UpdateStatus: (NSString *) status;

- (NSInteger) Search: (NSString *) search_string;

- (BOOL) GetFriendEvents: (NSString *) member_id;

- (BOOL) AddFriend: (NSString *) member_id;
- (BOOL) DeleteFriend: (NSString *) member_id;
- (BOOL) EditFriendSettings: (NSString *) member_id setting: (NSString *)strSetting;
- (BOOL) AcceptFriendRequest: (NSString *) friend_request_id;
- (BOOL) DeclineFriendRequest: (NSString *) friend_request_id;
- (BOOL) AcceptEventInvite: (NSString *) event_invite_id;
- (BOOL) DeclineEventInvite: (NSString *) event_invite_id;

- (BOOL) ReadNotification: (NSString *) notification_id;

- (BOOL) UpdateSettings: (NSString *)strFirstName lastname: (NSString *) strLastName phone: (NSString *) strphone address: (NSString *) straddr occupation: (NSString *) stroccupation aboutme: (NSString *) straboutme birthdate: (NSString *) strbirthdate eventcolor: (NSString *) streventcolor timepreference: (NSString *) strtimepreference groupsettings: (NSString *)strgroupsettings;

- (BOOL) ChangePassword: (NSString *)strcurrent newpassword: (NSString *) strnew;

- (NSString *) getProfileImageURL;
- (UIImage *)getImage: (NSString *) strURL;
- (UIImage *)getLocalImage: (NSString *) strURL;

- (BOOL)saveDataToFile;
- (BOOL)loadDataFromFile;
- (NSString*)dataFilePath;


- (void) CreateThreadDownloadImages;
- (void) DownloadImages;

@end
