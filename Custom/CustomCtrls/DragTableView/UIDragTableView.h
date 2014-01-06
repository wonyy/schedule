//
//  UIDragTableView.h
//  Schedule
//
//  Created by TanLong on 11/28/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIDragTableViewDelegate

- (void) SubItemTouchMove: (NSInteger) nIndex view: (UIView *) curview nStart: (float) start nEnd: (float) end;
- (void) SubItemTouchEnd: (NSInteger) nIndex;

@end

@interface UIDragTableView : UITableView {
    CGPoint ptOrigianl;
    CGPoint touchOffset;
}

@property (retain, nonatomic) IBOutlet id<UIDragTableViewDelegate> dragdelegate;

@end
