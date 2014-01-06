//
//  StartEndDateViewController.m
//  Schedule
//
//  Created by Galaxy39 on 8/19/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "StartEndDateViewController.h"

@interface StartEndDateViewController ()

@end

@implementation StartEndDateViewController

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
    
    [self refreshImage];
    
    // Do any additional setup after loading the view from its nib.
    if (sDate == nil) {
        sDate = [NSDate new];
    }
    
    if (eDate == nil) {
        eDate = [NSDate new];
    }
    
    selectedIndex = -1;
    
    [_picker setDate: sDate];
    
    _tblView.delegate = self;
    _tblView.dataSource = self;
    [_tblView reloadData];
    
    // Set Timer for current Date
    [self setLabel];
    [self createTimer];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tblView release];
    [_interval release];
    [_picker release];
    [_m_imgViewProfile release];
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    
    if (m_timer != nil) {
        [m_timer release];
    }
    [super dealloc];
}

#pragma mark - Actions

- (IBAction)onCancel:(id)sender {    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSave:(id)sender {
    [self.delegate StartEndDateEdited:sDate :eDate];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)intervalChanged:(id)sender {
    int type = [_interval selectedSegmentIndex];

    switch (type) {
        case 1:
            [_picker setMinuteInterval:5];
            break;
        case 2:
            [_picker setMinuteInterval:15];
            break;
        case 3:
            [_picker setMinuteInterval:30];
            break;
        case 4:
            [_picker setMinuteInterval:60];
            break;
        default:
            [_picker setMinuteInterval:1];            
    }
}

- (IBAction)dateChanged:(id)sender {
    if(selectedIndex == 0) {
        sDate = [[_picker date] retain];
        NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:0];
        [[_tblView cellForRowAtIndexPath:path].textLabel setText:[NSString stringWithFormat:@"Start date %@", [CommonApi getStringFromDateTime:sDate]]];
    } else if(selectedIndex == 1) {
        eDate = [[_picker date] retain];
        NSIndexPath * path = [NSIndexPath indexPathForRow:1 inSection:0];
        [[_tblView cellForRowAtIndexPath:path].textLabel setText:[NSString stringWithFormat:@" End date %@", [CommonApi getStringFromDateTime:eDate]]];
    }
}

- (void) SetDates: (NSDate *) startDate end: (NSDate *) endDate {
    sDate = [startDate retain];
    eDate = [endDate retain];
    
  //  [_tblView reloadData];
}

#pragma mark - Table View Delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSString * str = @"";
    if (indexPath.row == 0)
        cell.textLabel.text = @"None";
    
    switch (indexPath.row) {
        case 0:
            str = [NSString stringWithFormat:@"Start date %@", [CommonApi getStringFromDateTime:sDate]];
            break;
        case 1:
            str = [NSString stringWithFormat:@" End date %@", [CommonApi getStringFromDateTime:eDate]];;
            break;
        default:
            break;
    }
    
    cell.textLabel.text = str;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Availability";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    return @"";
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    
    if (selectedIndex == 0) {
        [_picker setDate: sDate];
    } else {
        [_picker setDate: eDate];
    }
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
