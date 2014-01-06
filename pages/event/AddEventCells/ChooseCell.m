//
//  ChooseCell.m
//  Schedule
//
//  Created by TanLong on 10/29/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "ChooseCell.h"

@implementation ChooseCell

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
    [_m_labelValue release];
    [_m_imgViewGuest1 release];
    [_m_imgViewGuest2 release];
    [super dealloc];
}

- (void) setEnable: (BOOL) bEnable {
    if (bEnable == NO) {
        [self setUserInteractionEnabled: NO];
        
        [_m_labelName setTextColor: [UIColor lightGrayColor]];
        [_m_labelValue setTextColor: [UIColor lightGrayColor]];
    } else {
        [self setUserInteractionEnabled: YES];
        
        [_m_labelName setTextColor: [UIColor darkGrayColor]];
        [_m_labelValue setTextColor: [UIColor blackColor]];
    }
}

#pragma mark - Set Image to cell

- (void) refreshImage1 {
    [NSThread detachNewThreadSelector:@selector(getImage1) toTarget:self withObject:nil];
}

- (void) getImage1 {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    UIImage *image = [dataKeeper getImage: _m_strImgURL1];
    
    if (image != nil) {
        [_m_imgViewGuest1 setImage: image];
        
        [CUtils makeCircleImage: _m_imgViewGuest1];
    }
    
    [autoreleasePool release];
}

- (void) refreshImage2 {
    [NSThread detachNewThreadSelector:@selector(getImage2) toTarget:self withObject:nil];
}

- (void) getImage2 {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    UIImage *image = [dataKeeper getImage: _m_strImgURL2];
    
    if (image != nil) {
        [_m_imgViewGuest2 setImage: image];
        
        [CUtils makeCircleImage: _m_imgViewGuest2];
    }
    
    [autoreleasePool release];
}
@end
