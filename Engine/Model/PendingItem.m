//
//  PendingItem.m
//  Schedule
//
//  Created by TanLong on 10/28/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "PendingItem.h"

@implementation PendingItem


@synthesize click_event;
@synthesize message;


- (id) init {
    if (self = [super init]) {

        self.click_event = @"";
        self.message = @"";
    }
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dict {
    if (self = [super init]) {
        self.click_event = [dict objectForKey:@"click_event"];
        self.message = [dict objectForKey:@"message"];
    }
    
    return self;
}


@end
