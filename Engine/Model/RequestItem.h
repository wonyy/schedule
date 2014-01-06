//
//  RequestItem.h
//  Schedule
//
//  Created by TanLong on 10/28/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestItem : NSObject

@property (nonatomic, retain) NSString * requestID;
@property (nonatomic, retain) NSString * profile_picture;
@property (nonatomic, retain) NSString * click_event;
@property (nonatomic, retain) NSString * message;

- (id) initWithDictionary: (NSDictionary *) dict;

@end
