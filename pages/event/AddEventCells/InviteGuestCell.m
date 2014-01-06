//
//  InviteCell.m
//  Schedule
//
//  Created by TanLong on 11/15/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "InviteGuestCell.h"

@implementation InviteGuestCell

@synthesize m_strImgURL;

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
    [_m_labelName release];
    [_m_labelOccupation release];
    [_m_imageView release];
    [super dealloc];
}

#pragma mark - Set Image to cell

- (void) refreshImage {
    [NSThread detachNewThreadSelector:@selector(getImage) toTarget:self withObject:nil];
}

- (void) getImage {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    UIImage *image = [dataKeeper getImage: m_strImgURL];
    
    if (image != nil) {
        [_m_imageView setImage: image];
        
        [CUtils makeCircleImage: _m_imageView];
    }
    
    [autoreleasePool release];
}

@end
