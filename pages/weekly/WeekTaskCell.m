//
//  WeekTaskCell.m
//  Schedule
//
//  Created by Galaxy39 on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "WeekTaskCell.h"

@implementation WeekTaskCell

- (void)onSelected {
    [self.delegate WeekTaskCellDelegate_Seleted:eventID];
}

- (void)setInfo:(NSString *)time :(NSString*)title :(UIColor*)color :(int)idx
{
    _lblTime.text = time;
    _lblTitle.text = title;
    _lblTitle.textColor = [UIColor whiteColor];
    [_m_imgViewBackground setBackgroundColor: color];
    eventID = idx;
    UITapGestureRecognizer * recog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelected)];
    [self addGestureRecognizer:recog];
}

- (void)dealloc {
    [_lblTime release];
    [_lblTitle release];
    [_m_imgViewBackground release];
    [super dealloc];
}
@end
