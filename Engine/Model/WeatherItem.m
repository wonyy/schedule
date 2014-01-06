//
//  WeatherItem.m
//  Schedule
//
//  Created by TanLong on 10/28/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "WeatherItem.h"

@implementation WeatherItem

@synthesize day;
@synthesize keyword;
@synthesize high;
@synthesize low;


- (id) init {
    if (self = [super init]) {
        self.day = @"";
        self.keyword = @"";
        self.high = @"";
        self.low = @"";
    }
    return self;
}

- (id) initWithDictionary: (NSDictionary *) dict {
    if (self = [super init]) {
        
        self.day = [dict objectForKey:@"day"];
        self.keyword = [dict objectForKey:@"keyword"];
        self.high = [dict objectForKey:@"high"];
        self.low = [dict objectForKey:@"low"];
    }
    
    return self;
}


@end
