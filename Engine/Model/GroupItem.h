//
//  GroupItem.h
//  Schedule
//
//  Created by TanLong on 11/14/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupItem : NSObject

@property (nonatomic, retain) NSString * groupID;
@property (nonatomic, retain) NSString * name;

- (id) initWithDictionary: (NSDictionary *) dict;

@end
