//
//  RequestItem.m
//  Schedule
//
//  Created by TanLong on 10/28/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "RequestItem.h"

@implementation RequestItem


@synthesize requestID;
@synthesize profile_picture;
@synthesize click_event;
@synthesize message;


- (id) init {
    if (self = [super init]) {
        self.requestID = @"";
        self.profile_picture = @"";
        self.click_event = @"";
        self.message = @"";
    }
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dict {
    if (self = [super init]) {
        
        self.requestID = [dict objectForKey:@"request_id"];
        self.profile_picture = [dict objectForKey:@"profile_picture"];
        self.click_event = [dict objectForKey:@"click_event"];
        self.message = [dict objectForKey:@"message"];
    }
    
    return self;
}


@end
