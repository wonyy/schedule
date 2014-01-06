//
//  NoteCell.m
//  Schedule
//
//  Created by TanLong on 10/29/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "NoteCell.h"

@implementation NoteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_m_textViewNote release];
    [super dealloc];
}

- (void) AddPlaceHolder: (NSString *) strPlaceHolder {
    _labelPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, _m_textViewNote.frame.size.width - 10.0, 34.0)];
    [_labelPlaceHolder setText:strPlaceHolder];
    [_labelPlaceHolder setBackgroundColor:[UIColor clearColor]];
    [_labelPlaceHolder setTextColor:[UIColor lightGrayColor]];
    [_labelPlaceHolder setTag: 999];
    
    [_m_textViewNote addSubview:_labelPlaceHolder];
    
    if (![_m_textViewNote hasText]) {
        [_m_textViewNote viewWithTag: 999].hidden = NO;
    } else {
        [_m_textViewNote viewWithTag: 999].hidden = YES;
    }

}

@end
