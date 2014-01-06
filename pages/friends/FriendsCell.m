//
//  FriendsCell.m
//  Schedule
//
//  Created by Mountain on 10/1/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "FriendsCell.h"

@implementation FriendsCell

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
    [_m_labelDistance release];
    [_m_imageView release];
    [_m_labelGroup release];
    [_m_btnCellPhone release];
    [_m_btnEmail release];
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
        
     //   [CUtils makeCircleImage: _m_imageView];
    }
    
    [autoreleasePool release];
}
@end
