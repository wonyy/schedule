//
//  WeatherCell.m
//  Schedule
//
//  Created by TanLong on 11/26/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "WeatherCell.h"

@implementation WeatherCell

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
    [_m_labelHigh release];
    [_m_labelRow release];
    [super dealloc];
}
@end
