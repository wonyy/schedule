//
//  EventTypeViewController.m
//  Schedule
//
//  Created by TanLong on 11/1/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "EventTypeViewController.h"

@interface EventTypeViewController ()

@end

@implementation EventTypeViewController

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
    
    eventType = @"";
    
    [self refreshImage];
    
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
    [_m_imgViewProfile release];
    [_tblView release];
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    
    if (m_timer != nil) {
        [m_timer release];
    }
    [super dealloc];
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSString * str = @"";
    
    switch (indexPath.row) {
        case 0:
            str = @"Work";
            break;
        case 1:
            str = @"School";
            break;
        case 2:
            str = @"Personal";
            break;
        case 3:
            str = @"Other";
            break;
        default:
            break;
    }
    
    cell.textLabel.text = str;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Event Type";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    return @"";
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    eventType = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.delegate EventTypeEdited:eventType];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Touch Actions

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
