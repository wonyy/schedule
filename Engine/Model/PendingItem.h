//
//  PendingItem.h
//  Schedule
//
//  Created by TanLong on 10/28/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingItem : NSObject

@property (nonatomic, retain) NSString * click_event;
@property (nonatomic, retain) NSString * message;

- (id) initWithDictionary: (NSDictionary *) dict;

@end
