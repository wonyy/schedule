//
//  WeatherViewController.m
//  Schedule
//
//  Created by TanLong on 11/26/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "WeatherViewController.h"
#import "DBConnector.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    DBConnector *dbConn = [[DBConnector new] autorelease];
    
    m_aryWeathers = [dbConn getAllWeathers];

    
    // Set Profile Image
    [self refreshImage];
    
    // Set Timer for current Date
    [self setLabel];
    [self createTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    
    if (m_timer != nil) {
        [m_timer release];
    }
    
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    [_m_imgViewProfile release];
    [_m_weatherCell release];
    [super dealloc];
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 17;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 17)] autorelease];
    
    [view setBackgroundColor: [UIColor colorWithRed:0.0f/255.0f green:181.0f/255.0f blue:203.0f/255.0f alpha: 1.0f]];
    
    WeatherItem *weatherItem = [m_aryWeathers objectAtIndex: section];
    
    UILabel *labelDay = [[[UILabel alloc] initWithFrame:CGRectMake(200, 0, 100, 17)] autorelease];
    
    NSInteger nDay = [weatherItem.day integerValue];
    
    if (nDay == 0) {
        [labelDay setText: @"Today"];
    } else if (nDay == 1) {
         [labelDay setText: @"Tomorrow"];
    } else {
        [labelDay setText: [NSString stringWithFormat:@"day %d", nDay]];
    }
    
    [labelDay setTextColor: [UIColor whiteColor]];
    [labelDay setBackgroundColor: [UIColor clearColor]];
    
    [labelDay setTextAlignment: NSTextAlignmentRight];
    [labelDay setFont: [UIFont systemFontOfSize: 13.0f]];
    
    [view addSubview: labelDay];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [m_aryWeathers count];
}

// Set the height of each cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

// Set Cell Count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSBundle mainBundle] loadNibNamed:@"WeatherCell" owner:self options:nil];
    
    WeatherItem *weatherItem = [m_aryWeathers objectAtIndex: indexPath.section];
    
    [_m_weatherCell.m_labelHigh setText: [NSString stringWithFormat:@"%@°", weatherItem.high]];
    [_m_weatherCell.m_labelRow setText: [NSString stringWithFormat:@"%@°", weatherItem.low]];
    
        
    return _m_weatherCell;
}


#pragma mark - Touch Actions

- (IBAction)onTouchNavBackBtn:(id)sender {
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Set Image to cell

- (void) refreshImage {
    [NSThread detachNewThreadSelector:@selector(getImage) toTarget:self withObject:nil];
}

- (void) getImage {
    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    UIImage *image = [dataKeeper getImage: [dataKeeper getProfileImageURL]];
    
    if (image != nil) {
        [_m_imgViewProfile setImage: image];
        
        [CUtils makeCircleImage: _m_imgViewProfile];
    }
    
    [autoreleasePool release];
}


#pragma mark - Date/Time Functions
- (void) createTimer {
    m_timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setLabel) userInfo:nil repeats: YES];
}

- (void)setLabel {
    DataKeeper *dataKeeper = [DataKeeper sharedInstance];
    
    NSDate * toDay = [NSDate date];
    NSDateFormatter * dateformatter = [[NSDateFormatter new] autorelease];
    
    [dateformatter setDateFormat:dataKeeper.m_mySettingInfo.dateformat];
    NSString * dateString = [dateformatter stringFromDate:toDay];
    dateformatter.dateFormat = @"EEE";
    
    NSString * dayString = [[dateformatter stringFromDate:toDay] capitalizedString];
    [_m_labelCurrentDate setText:[NSString stringWithFormat:@"%@, %@", dayString, dateString]];
    
    
    dateformatter.dateFormat = dataKeeper.m_mySettingInfo.timeformat;
    NSString * timeString = [dateformatter stringFromDate:toDay];
    [_m_labelCurrentTime setText:timeString];
    
    //   NSLog(@"---- setLabel -----");
}


@end
