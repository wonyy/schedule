//
//  EventCellView.m
//  Schedule
//
//  Created by Galaxy39 on 8/18/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "EventCellView.h"
#import "UIColor+expanded.h"

@implementation EventCellView
@synthesize cellItem;

- (id)init {
    NSArray * array;
    array = [[NSBundle mainBundle] loadNibNamed:@"EventCellView" owner:nil options:nil];
    self = [array objectAtIndex:0];
    if (self) {
        cellItem = [ScheduleItem new];
    }
    return self;
}

- (void)setInfo:(ScheduleItem *)item {
    cellItem = item;
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];

    NSDate *stDate = [CommonApi getDateTimeFromString: item.eventStartDay];
    NSDate *enDate = [CommonApi getDateTimeFromString: item.eventEndDay];
    
    [_lblFrom setText: [CommonApi getTime: stDate timeformat:dataKeeper.m_mySettingInfo.timeformat]];
    [_lblTo setText: [CommonApi getTime: enDate timeformat:dataKeeper.m_mySettingInfo.timeformat]];
    [_lblTitle setText: item.eventName];
    
    UIColor *eventColor;
    if ([item.eventType isEqualToString:@"Work"]) {
        eventColor = [UIColor colorWithHexString: [dataKeeper.m_mySettingInfo.workColor substringFromIndex:1]];
    } else if ([item.eventType isEqualToString:@"School"]) {
        eventColor = [UIColor colorWithHexString: [dataKeeper.m_mySettingInfo.schoolColor substringFromIndex:1]];
    } else if ([item.eventType isEqualToString:@"Personal"]) {
        eventColor = [UIColor colorWithHexString: [dataKeeper.m_mySettingInfo.personalColor substringFromIndex:1]];
    } else if ([item.eventType isEqualToString:@"Other"]) {
        eventColor = [UIColor colorWithHexString: [dataKeeper.m_mySettingInfo.otherColor substringFromIndex:1]];
    } else {
        eventColor = [UIColor colorWithHexString: [dataKeeper.m_mySettingInfo.otherColor substringFromIndex:1]];
    }
    
    [_m_eventTypeView setBackgroundColor: eventColor];
    [_lblTitle setTextColor: eventColor];
    
    NSInteger nGuestCount = [item.arrayGuests count];
    
    if (nGuestCount == 0) {
        [_m_imgViewProfile1 setHidden: YES];
        [_m_imgViewProfile2 setHidden: YES];
    } else if (nGuestCount == 1) {
        [_m_imgViewProfile2 setHidden: NO];
        [_m_imgViewProfile1 setHidden: YES];
        
        NSDictionary *friendItem2 = [item.arrayGuests objectAtIndex: 0];
        _m_strImgURL2 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem2 objectForKey:@"profile_picture"]];
        [self refreshImage2];
        
    } else if (nGuestCount == 2) {
        [_m_imgViewProfile2 setHidden: NO];
        [_m_imgViewProfile1 setHidden: NO];
        
        NSDictionary *friendItem2 = [item.arrayGuests objectAtIndex: 0];
        _m_strImgURL2 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem2 objectForKey:@"profile_picture"]];
        
        NSDictionary *friendItem1 = [item.arrayGuests objectAtIndex: 1];
        _m_strImgURL1 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem1 objectForKey:@"profile_picture"]];
        [self refreshImage1];
        [self refreshImage2];

    } else {
        [_m_imgViewProfile2 setHidden: NO];
        [_m_imgViewProfile1 setHidden: NO];
        
        NSDictionary *friendItem2 = [item.arrayGuests objectAtIndex: 0];
        _m_strImgURL2 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem2 objectForKey:@"profile_picture"]];
        
        NSDictionary *friendItem1 = [item.arrayGuests objectAtIndex: 1];
        _m_strImgURL1 = [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [friendItem1 objectForKey:@"profile_picture"]];
        [self refreshImage1];
        [self refreshImage2];

        [_m_btnSeeAll setHidden: NO];
    }



}

- (void)dealloc {
    [_lblTitle release];
    [_lblFrom release];
    [_lblTo release];
    [_m_eventTypeView release];
    [_m_imgViewProfile1 release];
    [_m_imgViewProfile2 release];
    [_m_btnSeeAll release];
    [_m_strImgURL1 release];
    [_m_strImgURL2 release];
    [super dealloc];
}

#pragma mark - Set Image to cell

- (void) refreshImage1 {
    [NSThread detachNewThreadSelector:@selector(getImage1) toTarget:self withObject:nil];
}

- (void) getImage1 {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    UIImage *image = [dataKeeper getImage: _m_strImgURL1];
    
    if (image != nil) {
        [_m_imgViewProfile1 setImage: image];
        
        [CUtils makeCircleImage: _m_imgViewProfile1];
    }
    
    [autoreleasePool release];
}

- (void) refreshImage2 {
    [NSThread detachNewThreadSelector:@selector(getImage2) toTarget:self withObject:nil];
}

- (void) getImage2 {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    UIImage *image = [dataKeeper getImage: _m_strImgURL2];
    
    if (image != nil) {
        [_m_imgViewProfile2 setImage: image];
        
        [CUtils makeCircleImage: _m_imgViewProfile2];
    }
    
    [autoreleasePool release];
}
@end
