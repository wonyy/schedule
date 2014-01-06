//
//  GroupCell.m
//  Schedule
//
//  Created by TanLong on 11/14/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "GroupCell.h"

@implementation GroupCell

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
    [_m_labelGroupName release];
    [super dealloc];
}
@end
