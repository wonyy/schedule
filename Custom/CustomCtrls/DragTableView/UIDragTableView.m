//
//  UIDragTableView.m
//  Schedule
//
//  Created by TanLong on 11/28/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "UIDragTableView.h"

@implementation UIDragTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (touch.view.tag >= 1000) {
        ptOrigianl = touch.view.center;
        touchOffset = [touch locationInView: touch.view];
        self.scrollEnabled = NO;
    }
    
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    float newY;

    if (touch.view.tag >= 1000) {
        CGPoint location = [touch locationInView: self];
        
        newY = location.y - touchOffset.y;
        
        if (newY < touch.view.frame.origin.y && newY < self.contentOffset.y && newY > 0) {
            [self setContentOffset: CGPointMake(self.contentOffset.x, newY)];
        } else if (newY > touch.view.frame.origin.y && newY + touch.view.frame.size.height > self.contentOffset.y + self.frame.size.height && self.contentOffset.y + self.frame.size.height < self.contentSize.height) {
            [self setContentOffset: CGPointMake(self.contentOffset.x, newY + touch.view.frame.size.height - self.frame.size.height)];
        }
        
        if (newY < 0) {
            newY = 0;
        } else if (newY > self.contentSize.height - touch.view.frame.size.height) {
            newY = self.contentSize.height - touch.view.frame.size.height;
        }
        
        
        [touch.view setFrame: CGRectMake(touch.view.frame.origin.x, newY, touch.view.frame.size.width, touch.view.frame.size.height)];
        
        [self.dragdelegate SubItemTouchMove:touch.view.tag - 1000 view: touch.view nStart: newY nEnd: newY + touch.view.frame.size.height];
    }
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];

    if (touch.view.tag >= 1000) {
        self.scrollEnabled = YES;
        
        [self.dragdelegate SubItemTouchEnd:touch.view.tag - 1000];
    }
}

@end
