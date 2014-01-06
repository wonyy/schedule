//
//  GroupItem.m
//  Schedule
//
//  Created by TanLong on 11/14/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "GroupItem.h"

@implementation GroupItem

@synthesize groupID;
@synthesize name;


- (id) init {
    if (self = [super init]) {
        self.groupID = @"";
        self.name = @"";
    }
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dict {
    if (self = [super init]) {
        
        self.groupID = [dict objectForKey:@"group_id"];
        self.name = [dict objectForKey:@"group_name"];
    }
    
    return self;
}


@end
