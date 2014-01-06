/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalView.h"
#import "KalGridView.h"
#import "KalLogic.h"
#import "KalPrivate.h"
#import "QuartzCore/QuartzCore.h"
#import "UIFactory.h"

@interface KalView ()
- (void)addSubviewsToHeaderView:(UIView *)headerView;
- (void)addSubviewsToContentView:(UIView *)contentView withTabSize:(CGSize)tabSize;
- (void)setHeaderTitleText:(NSString *)text;
@end

static const CGFloat kHeaderHeight = 73.f;
static const CGFloat kMonthLabelHeight = 53.f;

@implementation KalView

@synthesize delegate, tableView;

- (id)initWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic withTabSize:(CGSize)tabSize
{
    calanderType = 0;
  if ((self = [super initWithFrame:CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height)])) {
    delegate = theDelegate;
    logic = [theLogic retain];
    [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
      
    UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, kHeaderHeight + 10, frame.size.width, frame.size.height - kHeaderHeight)] autorelease];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [contentView setBackgroundColor: [UIColor clearColor]];
    [self addSubviewsToContentView:contentView withTabSize:tabSize];
    [self addSubview:contentView];

    
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)] autorelease];
    headerView.backgroundColor = [UIColor clearColor];
      headerView.tag = 999;
    [self addSubviewsToHeaderView:headerView];
    [self addSubview:headerView];
            
    }
  
  return self;
}

- (void) refreshHeadView {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    if (startWeek == [dataKeeper.m_mySettingInfo.startweek integerValue]) {
        return;
    }
    
    UIView *newheaderView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, kHeaderHeight)] autorelease];
    newheaderView.backgroundColor = [UIColor clearColor];
    newheaderView.tag = 999;
    [self addSubviewsToHeaderView:newheaderView];
    
    UIView *oldheaderView = [self viewWithTag: 999];
    
    for (UIView *subView in oldheaderView.subviews) {
        [subView removeFromSuperview];
       // [subView release];
    }
    
    [oldheaderView removeFromSuperview];
    
    [self addSubview: newheaderView];
}

- (void) drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    
    [[UIColor whiteColor] setFill];
    
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFill);


    path = CGPathCreateWithRect(CGRectMake(15.f, 62, rect.size.width - 30, 310), NULL);
    
    [[UIColor whiteColor] setFill];
    [[UIColor grayColor] setStroke];
    
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);
    
}

- (id)initPopWithFrame:(CGRect)frame delegate:(id<KalViewDelegate>)theDelegate logic:(KalLogic *)theLogic withTabSize:(CGSize)tabSize
{
    calanderType = 1;
    
    if ((self = [super initWithFrame:CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height)])) {
        self.layer.cornerRadius = 10;
        delegate = theDelegate;
        logic = [theLogic retain];
        [logic addObserver:self forKeyPath:@"selectedMonthNameAndYear" options:NSKeyValueObservingOptionNew context:NULL];
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        
        tabSize = CGSizeMake((self.frame.size.width - 20) / 7, (self.frame.size.width - 20) / 7);
                
        UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, kHeaderHeight)] autorelease];
        headerView.backgroundColor = [UIColor clearColor];
        [self addSubviewsToHeaderView:headerView];
        [self addSubview:headerView];
        
        UIView *contentView = [[[UIView alloc] initWithFrame:CGRectMake(10.f, kHeaderHeight + 10, frame.size.width - 20, frame.size.height - kHeaderHeight)] autorelease];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self addSubviewsToContentView:contentView withTabSize:tabSize];
        [self addSubview:contentView];
        
        UIImageView * backView = [[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + tabSize.height * 2 + 10 - 65)] autorelease];
        [backView setBackgroundColor:[UIColor colorWithRed:82/255.0 green:30/255.0 blue:4/255.0 alpha:0.8]];
        
        UIImageView * super_backView = [[[UIImageView alloc]initWithFrame:CGRectMake(5, kMonthLabelHeight+ 10, backView.frame.size.width - 10, backView.frame.size.height - kMonthLabelHeight - 15 )] autorelease];
        [super_backView setBackgroundColor:[UIColor whiteColor]];
        [backView addSubview:super_backView];
        backView.layer.cornerRadius = 10;
        //////
        [self addSubview:backView];
        [self bringSubviewToFront:headerView];
        [self bringSubviewToFront:contentView];
    }
    
    return self;

}

- (id)initWithFrame:(CGRect)frame
{
  [NSException raise:@"Incomplete initializer" format:@"KalView must be initialized with a delegate and a KalLogic. Use the initWithFrame:delegate:logic: method."];
  return nil;
}

- (void)redrawEntireMonth { [self jumpToSelectedMonth]; }

- (void)slideDown { [gridView slideDown]; }
- (void)slideUp { [gridView slideUp]; }

- (void)showPreviousMonth
{
  if (!gridView.transitioning)
    [delegate showPreviousMonth];
}

- (void)showFollowingMonth
{
  if (!gridView.transitioning)
    [delegate showFollowingMonth];
}

- (void)addSubviewsToHeaderView:(UIView *)headerView
{
  const CGFloat kHeaderVerticalAdjust = 0.0f;
  
  // Header background gradient
    UIImageView *backgroundView = [[UIImageView alloc]init];
    if ([[UIDevice currentDevice].model hasPrefix:@"iPhone"] && calanderType != 1){
        [backgroundView setImage:[UIImage imageNamed:@"topbarback"]];
    } else {
        backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_calendar_date_bg"]];
    }
    if (calanderType == 1)
        [backgroundView setImage:[UIImage imageNamed:@""]];
    
    CGRect imageFrame = headerView.frame;
    imageFrame.origin = CGPointZero;
    backgroundView.frame = CGRectMake(0, 0, 320, 53);
    [headerView addSubview:backgroundView];
    [backgroundView release];
  
  // Create the previous month button on the left side of the view
    CGRect previousMonthButtonFrame = CGRectMake(self.left, kHeaderVerticalAdjust, 30, 30);
    UIButton *previousMonthButton = [UIFactory createButtonWithRect:previousMonthButtonFrame
                                                              title:nil
                                                          titleFont:nil
                                                         titleColor:nil
                                                             normal:@"list_calendar_arrow_l"
                                                          highlight:@"list_calendar_arrow_l"
                                                           selector:@selector(showPreviousMonth)
                                                             target:self];
    [headerView addSubview:previousMonthButton];
  
  // Draw the selected month name centered and at the top of the view    
    CGRect monthLabelFrame = CGRectMake((self.width / 2.0f) - (CGRectGetWidth(headerView.frame) / 2.0f),
                                        kHeaderVerticalAdjust,
                                        CGRectGetWidth(headerView.frame),
                                        53);
    headerTitleLabel = [UIFactory createLabelWith:monthLabelFrame
                                             text:[logic selectedMonthNameAndYear]
                                             font:[UIFont boldSystemFontOfSize:20.f]
                                        textColor:(calanderType == 1) ? [UIColor whiteColor] : [UIColor colorWithRed:117/255.0 green:105/255.0 blue:100/255.0 alpha:1.0]
                                  backgroundColor:[UIColor clearColor]];
    
    [headerTitleLabel setTextAlignment: NSTextAlignmentCenter];
    [headerView addSubview:headerTitleLabel];
    [headerTitleLabel setHidden: NO];
  
  // Create the next month button on the right side of the view  
    CGRect nextMonthButtonFrame = CGRectMake(CGRectGetWidth(headerView.frame) - self.left - 30, kHeaderVerticalAdjust, 30, 30);
    UIButton *nextMonthButton = [UIFactory createButtonWithRect:nextMonthButtonFrame
                                                          title:nil
                                                      titleFont:nil
                                                     titleColor:nil
                                                         normal:@"list_calendar_arrow_r"
                                                      highlight:@"list_calendar_arrow_r"
                                                       selector:@selector(showFollowingMonth)
                                                         target:self];
    [headerView addSubview:nextMonthButton];
    
    
    
  // Add column labels for each weekday (adjusting based on the current locale's first weekday)
    
    NSDateFormatter * m_dateFormatter = [[NSDateFormatter alloc] init];
    NSString *langCode = @"";
    
    langCode = @"en";
    [m_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:langCode]];
    NSArray *weekdayNames = [[m_dateFormatter autorelease] shortWeekdaySymbols];
    
    CGFloat margin = (calanderType == 1) ? 10.0f : 15.0f;
    CGFloat width = (headerView.width - margin * 2) / 7.0f;
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];

    startWeek = [dataKeeper.m_mySettingInfo.startweek integerValue];
    
    for (NSUInteger weekdayIndex = [[NSCalendar currentCalendar] firstWeekday] - 1; weekdayIndex < 7; weekdayIndex++) {
        
        CGRect weekdayFrame = CGRectMake(margin + width * weekdayIndex, kMonthLabelHeight + 10, width - 1, 30);
        UIColor *textColor = [UIColor colorWithRed:108/255.0 green:130/255.0 blue:141/255.0 alpha:1.f];
        
        NSUInteger realIndex = weekdayIndex;
        
        if (startWeek == 0) {
           realIndex = (weekdayIndex + 1) % 7;
        }
        UILabel *weekdayLabel = [UIFactory createLabelWith:weekdayFrame
                                                      text:[[weekdayNames objectAtIndex:realIndex] uppercaseString]
                                                      font:[UIFont boldSystemFontOfSize:10.f]
                                                 textColor:textColor
                                           backgroundColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:242.0f/255.0f]];
        [weekdayLabel setTextAlignment: NSTextAlignmentCenter];
        [headerView addSubview:weekdayLabel];
    }
}

- (void)addSubviewsToContentView:(UIView *)contentView withTabSize:(CGSize)tabSize
{
    CGRect fullWidthAutomaticLayoutFrame = CGRectMake(18.f, 10.f, self.width, 0.f);

  // The tile grid (the calendar body)
    if (calanderType == 1) {
        gridView = [[KalGridView alloc] initWithPopFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate withTabSize:tabSize];
    } else 
        gridView = [[KalGridView alloc] initWithFrame:fullWidthAutomaticLayoutFrame logic:logic delegate:delegate withTabSize:tabSize];
    [gridView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
    [contentView addSubview:gridView];
  
  // Trigger the initial KVO update to finish the contentView layout
    [gridView sizeToFit];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (object == gridView && [keyPath isEqualToString:@"frame"]) {
    CGFloat gridBottom = gridView.top + gridView.height;
    CGRect frame = tableView.frame;
    frame.origin.y = gridBottom;
    frame.size.height = tableView.superview.height - gridBottom;
    tableView.frame = frame;
    shadowView.top = gridBottom;
    
  } else if ([keyPath isEqualToString:@"selectedMonthNameAndYear"]) {
    [self setHeaderTitleText:[change objectForKey:NSKeyValueChangeNewKey]];
    
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)setHeaderTitleText:(NSString *)text
{
  [headerTitleLabel setText:text];
 // [headerTitleLabel sizeToFit];
 // headerTitleLabel.left = floorf(self.width/2.f - headerTitleLabel.width/2.f);
}

- (void)jumpToSelectedMonth { [gridView jumpToSelectedMonth]; }

- (void)selectDate:(KalDate *)date { [gridView selectDate:date]; }

- (BOOL)isSliding { return gridView.transitioning; }

- (void)markTilesForDates:(NSArray *)dates { [gridView markTilesForDates:dates]; }

- (KalDate *)selectedDate { return gridView.selectedDate; }

- (void)dealloc
{
  [logic removeObserver:self forKeyPath:@"selectedMonthNameAndYear"];
  [logic release];
  
  [headerTitleLabel release];
  [gridView removeObserver:self forKeyPath:@"frame"];
  [gridView release];
  [tableView release];
  [shadowView release];
  [super dealloc];
}

@end
