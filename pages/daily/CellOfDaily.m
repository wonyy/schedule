//
//  CellOfDaily.m
//  Schedule
//
//  Created by Galaxy39 on 8/17/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "CellOfDaily.h"
#import <QuartzCore/QuartzCore.h>

@implementation CellOfDaily

- (id)init {
    NSArray * array;
    array = [[NSBundle mainBundle] loadNibNamed:@"CellOfDaily" owner:nil options:nil];
    self = [array objectAtIndex:0];
    if (self) {
        self.layer.cornerRadius = 10;
        UITapGestureRecognizer * recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelected)];
        [self addGestureRecognizer:recog];
    }
    return self;
}

- (void)onSelected {
    [self.delegate CellOfDailyDelegate_Selected:eventID];
}

- (void)setEventID:(int)idx {
    eventID = idx;
}

- (void)setTitle:(NSString*)title {
    [_lbl_titleLabel setText:title];
}

- (void)setColor:(UIColor*)color {
    [self setBackgroundColor: color];
}

- (void)dealloc {
    [_lbl_titleLabel release];
    [super dealloc];
}

@end
