//
//  EmptyCell.m
//  Schedule
//
//  Created by TanLong on 10/29/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "EmptyCell.h"

@implementation EmptyCell

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

@end
