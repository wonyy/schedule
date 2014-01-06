//
//  RecurringEndDateViewController.m
//  Schedule
//
//  Created by TanLong on 12/24/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "RecurringEndDateViewController.h"

@interface RecurringEndDateViewController ()

@end

@implementation RecurringEndDateViewController

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
    
    [self refreshImage];
    
    // Set Timer for current Date
    [self setLabel];
    [self createTimer];
    
    if (eDate == nil) {
        bOnDate = NO;
    } else {
        bOnDate = YES;
        [_m_viewPicker setHidden: NO];
        [_m_pickerView setDate: eDate];
    }
    
    [_m_pickerView setMinimumDate: [NSDate date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    [_m_imgViewProfile release];
    
    if (m_timer != nil) {
        [m_timer release];
    }
    [_m_viewPicker release];
    [_m_pickerView release];
    [super dealloc];
}

- (void) SetEDate: (NSDate *) date {
    eDate = date;
}

#pragma mark - Touch Actions

- (IBAction)onTouchNavCancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnDateChanged:(id)sender {
    [self.delegate EndDateEdited: [CommonApi getStringFromDate:_m_pickerView.date]];
//    [self.delegate EndDateEdited:  _m_pickerView.date];
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

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Never";
        
        if (bOnDate == NO) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        cell.textLabel.text = @"On Date";
        
        if (bOnDate == YES) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (bOnDate == YES) {
            bOnDate = NO;
            _m_viewPicker.alpha = 1.0;
            [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 _m_viewPicker.alpha = 0.0;
                             }
                             completion:^(BOOL completion) {
                                 _m_viewPicker.hidden = YES;
                                 [self.delegate EndDateEdited: @"Never"];

                             }];
            
            [tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection: 0]].accessoryType = UITableViewCellAccessoryCheckmark;
            [tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:1 inSection: 0]].accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        if (bOnDate == NO) {
            bOnDate = YES;
            _m_viewPicker.alpha = 0.0;
             _m_viewPicker.hidden = NO;
            [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{


                                 _m_viewPicker.alpha = 1.0;
                             }
                             completion:^(BOOL completion) {
                                 [self OnDateChanged: nil];
                             }];
            [tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:0 inSection: 0]].accessoryType = UITableViewCellAccessoryNone;
            [tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:1 inSection: 0]].accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }

}



@end
