/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"


extern const CGSize kTileSize;

@implementation KalTileView

@synthesize date;

- (id)initWithFrame:(CGRect)frame
{
    dlg_type = 0;
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    origin = frame.origin;
    [self setIsAccessibilityElement:YES];
    [self setAccessibilityTraits:UIAccessibilityTraitButton];
    [self resetState];
  }
  return self;
}
- (id)initPopWithFrame:(CGRect)frame
{
    dlg_type = 1;
    if ((self = [super initWithFrame:frame])) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
        origin = frame.origin;
        [self setIsAccessibilityElement:YES];
        [self setAccessibilityTraits:UIAccessibilityTraitButton];
        [self resetState];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
  [self setBackgroundColor:[UIColor clearColor]];
    
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGFloat fontSize = 16.f;
  UIFont *font = [UIFont systemFontOfSize:fontSize];
  UIColor *textColor = nil;
  CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
      
  CGContextTranslateCTM(ctx, 0, kTileSize.height);
  CGContextScaleCTM(ctx, 1, -1);
  
    if (self.selected) {
        if (dlg_type == 1) {
            UIImage *image = [UIImage imageNamed:@"list_calendar_date_normal"];
            [image drawInRect:CGRectMake(1, 1, kTileSize.width - 2, kTileSize.height - 2)];
        } else {
            
            UIImage *image = [UIImage imageNamed:@"list_calendar_date_selected"];
            [image drawInRect:CGRectMake(3, 5, 35, 35)];
            
            textColor = [UIColor whiteColor];
        }
        
    } else {
        
        if (dlg_type == 1) {
            UIImage *image = [UIImage imageNamed:@"list_calendar_date_normal"];
            [image drawInRect:CGRectMake(1, 1, kTileSize.width - 2, kTileSize.height - 2)];
        } else {
            [self setBackgroundColor:[UIColor clearColor]];
        }
        
        if ([[UIDevice currentDevice].model hasPrefix:@"iPhone"])
            textColor = [UIColor blackColor];
        else
            textColor = [UIColor colorWithRed:117/255.0 green:105/255.0 blue:100/255.0 alpha:0.9];
    }
    
    if ([self isToday] /* && !self.selected */) {
      
      if (dlg_type == 1) {
          UIImage *image = [UIImage imageNamed:@"list_calendar_date_normal"];
          [image drawInRect:CGRectMake(1, 1, kTileSize.width - 2, kTileSize.height - 2)];
          if ([[UIDevice currentDevice].model hasPrefix:@"iPhone"])
              textColor = [UIColor colorWithRed:82/255.0 green:30/255.0 blue:4/255.0 alpha:1.0];
          else
              textColor = [UIColor colorWithRed:117/255.0 green:105/255.0 blue:100/255.0 alpha:0.9];

      } else {
          UIImage *image = [UIImage imageNamed:@"list_calendar_date_today"];
          [image drawInRect:CGRectMake(3, 5, 35, 35)];
          /*
          if ([[UIDevice currentDevice].model hasPrefix:@"iPhone"])
              textColor = [UIColor colorWithRed:200/255.0 green:63/255.0 blue:10/255.0 alpha:1.0];
          else
              textColor = [UIColor colorWithRed:197/255.0 green:63/255.0 blue:10/255.0 alpha:1.f];
           */
      }
      
  } else if (self.belongsToAdjacentMonth && self.isMarked) {
      [self setBackgroundColor:[UIColor clearColor]];
      
      textColor = [UIColor colorWithRed:117/255.0 green:105/255.0 blue:100/255.0 alpha:0.5];
      
      if (dlg_type == 1) {
          UIImage *image = [UIImage imageNamed:@"list_calendar_date_normal"];
          [image drawInRect:CGRectMake(2, 2, kTileSize.width - 4, kTileSize.height - 4)];
      } else {
          UIImage *image = [UIImage imageNamed:@"list_calendar_date_grey_marked"];
          [image drawInRect:CGRectMake(kTileSize.width / 2 - 3, 6, 6, 6)];
      }

      
  } else if (self.belongsToAdjacentMonth) {
      
      if (dlg_type == 1) {
          UIImage *image = [UIImage imageNamed:@"list_calendar_date_normal"];
          [image drawInRect:CGRectMake(1, 1, kTileSize.width - 2, kTileSize.height - 2)];
      }
      
      [self setBackgroundColor:[UIColor clearColor]];
      textColor = [UIColor colorWithRed:117/255.0 green:105/255.0 blue:100/255.0 alpha:0.5];
      
  } else if (self.isMarked) {
         
     if (dlg_type == 1) {
         UIImage *image = [UIImage imageNamed:@"list_calendar_date_normal"];
         [image drawInRect:CGRectMake(2, 2, kTileSize.width - 4, kTileSize.height - 4)];
     } else {
         UIImage *image = [UIImage imageNamed:@"list_calendar_date_marked"];
         [image drawInRect:CGRectMake(kTileSize.width / 2 - 3, 6, 6, 6)];
     }
     
 } 
    
  NSUInteger n = [self.date day];
  NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
  const char *day = [dayText cStringUsingEncoding:NSUTF8StringEncoding];
  CGSize textSize = [dayText sizeWithFont:font];
  CGFloat textX, textY;
  textX = roundf(0.5f * (kTileSize.width - textSize.width));
  textY = 4.f + roundf(0.5f * (kTileSize.height - textSize.height));

  [textColor setFill];
  CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
  
  if (self.highlighted) {
    [[UIColor colorWithWhite:0.25f alpha:0.3f] setFill];
    CGContextFillRect(ctx, CGRectMake(0.f, 0.f, kTileSize.width, kTileSize.height));
  }
}

- (void)resetState
{
  // realign to the grid
  CGRect frame = self.frame;
  frame.origin = origin;
  frame.size = kTileSize;
  self.frame = frame;
  
  [date release];
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
}

- (void)setDate:(KalDate *)aDate
{
  if (date == aDate)
    return;

  [date release];
  date = [aDate retain];

  [self setNeedsDisplay];
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)selected
{
  if (flags.selected == selected)
    return;

  // workaround since I cannot draw outside of the frame in drawRect:
  if (![self isToday]) {
    CGRect rect = self.frame;
    if (selected) {
      rect.origin.x--;
      rect.size.width++;
      rect.size.height++;
    } else {
      rect.origin.x++;
      rect.size.width--;
      rect.size.height--;
    }
    self.frame = rect;
  }
  
  flags.selected = selected;
  [self setNeedsDisplay];
}

- (BOOL)isHighlighted { return flags.highlighted; }

- (void)setHighlighted:(BOOL)highlighted
{
  if (flags.highlighted == highlighted)
    return;
  
  flags.highlighted = highlighted;
  [self setNeedsDisplay];
}

- (BOOL)isMarked { return flags.marked; }

- (void)setMarked:(BOOL)marked
{
  if (flags.marked == marked)
    return;
  
  flags.marked = marked;
  [self setNeedsDisplay];
}

- (KalTileType)type { return flags.type; }

- (void)setType:(KalTileType)tileType
{
  if (flags.type == tileType)
    return;
  
  // workaround since I cannot draw outside of the frame in drawRect:
  CGRect rect = self.frame;
  if (tileType == KalTileTypeToday) {
    rect.origin.x--;
    rect.size.width++;
    rect.size.height++;
  } else if (flags.type == KalTileTypeToday) {
    rect.origin.x++;
    rect.size.width--;
    rect.size.height--;
  }
  self.frame = rect;
  
  flags.type = tileType;
  [self setNeedsDisplay];
}

- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }

- (void)dealloc
{
  [date release];
  [super dealloc];
}

@end
