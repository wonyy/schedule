//
//  CheckCell.m
//  Schedule
//
//  Created by TanLong on 10/29/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "CheckCell.h"

@implementation CheckCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        NSLog(@"aaaa");
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) dealloc {
    [_switchCtrl release];
    [_m_labelTitle release];
    [super dealloc];
}

@end
