//
//  WeatherItem.h
//  Schedule
//
//  Created by TanLong on 10/28/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherItem : NSObject

@property (nonatomic, retain) NSString * day;
@property (nonatomic, retain) NSString * keyword;
@property (nonatomic, retain) NSString * high;
@property (nonatomic, retain) NSString * low;

- (id) initWithDictionary: (NSDictionary *) dict;

@end
