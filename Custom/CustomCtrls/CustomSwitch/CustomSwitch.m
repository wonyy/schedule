//
//  CustomSwitch.m
//  Schedule
//
//  Created by TanLong on 11/2/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "CustomSwitch.h"

@implementation CustomSwitch

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _m_imgViewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 43, 24)];
        [_m_imgViewBackground setImage:[UIImage imageNamed:@"switch_background_off.png"]];
        [_m_imgViewBackground setUserInteractionEnabled: YES];
        
        _m_imgViewThumb = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 20, 21)];
        [_m_imgViewThumb setImage:[UIImage imageNamed:@"switch_knob.png"]];
        [_m_imgViewThumb setUserInteractionEnabled: YES];
        
        [self addSubview: _m_imgViewBackground];
        [self addSubview: _m_imgViewThumb];
    }
    return self;
}

- (void) dealloc {
    [_m_imgViewBackground release];
    [_m_imgViewThumb release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setValue : (BOOL) bValue withUI: (BOOL) withUI {
    
    if (_m_bValue != bValue) {
        _m_bValue = bValue;
        
        if (withUI == YES) {
            [delegate performSelector:@selector(onValueChanged:) withObject: self];
        }
    }
    
    if (_m_bValue == YES) {
        [_m_imgViewThumb setFrame:CGRectMake(22, 1, 20, 21)];
        [_m_imgViewBackground setImage: [UIImage imageNamed:@"switch_background_on.png"]];

    } else {
        [_m_imgViewThumb setFrame:CGRectMake(1, 1, 20, 21)];
        [_m_imgViewBackground setImage: [UIImage imageNamed:@"switch_background_off.png"]];

    }
    
 //   [delegate performSelector:@selector(onTimeSlide)];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    float x, y;
    
    if (touch.view == _m_imgViewThumb) {
        
        CGPoint location = [touch locationInView: self];
        
        x = MAX(location.x, 0);
        x = MIN(x, 22);
        
        y = 1;
        
        [_m_imgViewThumb setFrame: CGRectMake(x, y, _m_imgViewThumb.frame.size.width, _m_imgViewThumb.frame.size.height)];
        
        
        if (x == 22) {
            [_m_imgViewBackground setImage: [UIImage imageNamed:@"switch_background_on.png"]];
        } else if (x == 1) {
            [_m_imgViewBackground setImage: [UIImage imageNamed:@"switch_background_off.png"]];
        }
        NSLog(@"(%f,%f)", x, y);
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    float x, y;
    
    if (touch.view == _m_imgViewThumb) {
        x = _m_imgViewThumb.frame.origin.x;
        y = _m_imgViewThumb.frame.origin.y;
        
        if (x < 11) {
            [self setValue: NO withUI: YES];
        } else {
            [self setValue: YES withUI: YES];
        }
        
       // [self setFromValue: x / (206.0f / 1439.0f)];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

@end
