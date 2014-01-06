/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"

#define PROFILER 0
#if PROFILER
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>
void mach_absolute_difference(uint64_t end, uint64_t start, struct timespec *tp)
{
    uint64_t difference = end - start;
    static mach_timebase_info_data_t info = {0,0};

    if (info.denom == 0)
        mach_timebase_info(&info);
    
    uint64_t elapsednano = difference * (info.numer / info.denom);
    tp->tv_sec = elapsednano * 1e-9;
    tp->tv_nsec = elapsednano - (tp->tv_sec * 1e9);
}
#endif

NSString *const KalDataSourceChangedNotification = @"KalDataSourceChangedNotification";

@interface KalViewController ()
@property (nonatomic, retain, readwrite) NSDate *initialDate;
@property (nonatomic, retain, readwrite) NSDate *selectedDate;
- (KalView*)calendarView;
@end

@implementation KalViewController

@synthesize dataSource, delegate, initialDate, selectedDate,selectDelegate;

- (id)initWithSelectedDate:(NSDate *)date
{
  if ((self = [super init])) {
    logic = [[KalLogic alloc] initForDate:date];
    self.initialDate = date;
    self.selectedDate = date;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataWithCurrentDate) name:KalDataSourceChangedNotification object:nil];
      [tableView setBackgroundColor:[UIColor clearColor]];
  }
  return self;
}

- (id)initPopWithSelectedDate:(NSDate*)date
{
    if ((self = [super init])) {
        logic = [[KalLogic alloc] initForDate:date];
        self.initialDate = date;
        self.selectedDate = date;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChangeOccurred) name:UIApplicationSignificantTimeChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataWithCurrentDate) name:KalDataSourceChangedNotification object:nil];
        [tableView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (id)init
{
  return [self initWithSelectedDate:[NSDate date]];
}

- (id)initWithTabSize:(CGSize)tabSize withViewSize:(CGSize)viewSize withParentDelegate:(id)reciver
{
    clanderViewType = 0;
    m_tabSize = tabSize;
    m_viewSize = viewSize;
    selectDelegate = reciver;
    return [self initWithSelectedDate:[NSDate date]];
}

- (id)initPopWithTabSize:(CGSize)tabSize withViewSize:(CGSize)viewSize withParentDelegate:(id)reciver
{
    clanderViewType = 1;
    m_tabSize = tabSize;
    m_viewSize = viewSize;
    selectDelegate = reciver;
    return [self initPopWithSelectedDate:[NSDate date]];
}

- (KalView*)calendarView { return (KalView*)self.view; }

- (void)setDataSource:(id<KalDataSource>)aDataSource
{
  if (dataSource != aDataSource) {
    dataSource = aDataSource;
    tableView.dataSource = dataSource;
  }
}

- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
  if (delegate != aDelegate) {
    delegate = aDelegate;
    tableView.delegate = delegate;
  }
}

- (void)clearTable
{
  [dataSource removeAllItems];
  [tableView reloadData];
}

- (void) reloadDataWithCurrentDate {
    [logic recalculateVisibleDays];
    [[self calendarView] jumpToSelectedMonth];

    [self reloadData];
}

- (void)reloadData
{
    [[self calendarView] refreshHeadView];

  [dataSource presentingDatesFrom:logic.fromDate to:logic.toDate delegate:self];
}

- (void)significantTimeChangeOccurred
{
  [[self calendarView] jumpToSelectedMonth];
  [self reloadData];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate *)date interaction:(BOOL)clicked {
  self.selectedDate = [date nsDate];
  NSDate *from = [[date nsDate] cc_dateByMovingToBeginningOfDay];
  NSDate *to = [[date nsDate] cc_dateByMovingToEndOfDay];
  [self clearTable];
  [dataSource loadItemsFromDate:from toDate:to];
  [tableView reloadData];
  [tableView flashScrollIndicators];
  if (clicked == YES)
    [self.selectDelegate dateWasSelected:date];
}

- (void)showPreviousMonth {
  [self clearTable];
  [logic retreatToPreviousMonth];
  [[self calendarView] slideDown];
  [self reloadData];
}

- (void)showFollowingMonth {
  [self clearTable];
  [logic advanceToFollowingMonth];
  [[self calendarView] slideUp];
  [self reloadData];
}

// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
  NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
  NSMutableArray *dates = [[markedDates mutableCopy] autorelease];
  for (int i=0; i<[dates count]; i++)
    [dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:[dates objectAtIndex:i]]];
  
  [[self calendarView] markTilesForDates:dates];
  [self didSelectDate:self.calendarView.selectedDate interaction:NO];
}

// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
  if ([[self calendarView] isSliding])
    return;
  
  [logic moveToMonthForDate:date];
  
#if PROFILER
  uint64_t start, end;
  struct timespec tp;
  start = mach_absolute_time();
#endif
  
  [[self calendarView] jumpToSelectedMonth];
  
#if PROFILER
  end = mach_absolute_time();
  mach_absolute_difference(end, start, &tp);
  printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
  
  [[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
  [self reloadData];
}

- (NSDate *)selectedDate {
  return [self.calendarView.selectedDate nsDate];
}


// -----------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)didReceiveMemoryWarning {
  self.initialDate = self.selectedDate; // must be done before calling super
  [super didReceiveMemoryWarning];
}

- (void)loadView {
  if (!self.title)
    self.title = @"Calendar";
    KalView *kalView;
    if(clanderViewType == 1)
        kalView = [[[KalView alloc] initPopWithFrame:CGRectMake(0, 0, m_viewSize.width, m_viewSize.height) delegate:self logic:logic withTabSize:m_tabSize] autorelease];
    else
        kalView = [[[KalView alloc] initWithFrame:CGRectMake(0, 0, m_viewSize.width, m_viewSize.height) delegate:self logic:logic withTabSize:m_tabSize] autorelease];
    self.view = kalView;
    tableView = kalView.tableView;
    tableView.dataSource = dataSource;
    tableView.delegate = delegate;
    [tableView retain];
    [kalView selectDate:[KalDate dateFromNSDate:self.initialDate]];
    [self reloadData];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [tableView release];
  tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [tableView flashScrollIndicators];
}

#pragma mark -

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:KalDataSourceChangedNotification object:nil];
  [initialDate release];
  [selectedDate release];
  [logic release];
  [tableView release];
  [super dealloc];
}

@end
