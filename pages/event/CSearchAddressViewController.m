//
//  CSearchAddressViewController.m
//  taxiboy
//
//  Created by Mountain on 10/8/13.
//  Copyright (c) 2013 wony. All rights reserved.
//

#import "CSearchAddressViewController.h"

@interface CSearchAddressViewController ()

@end

@implementation CSearchAddressViewController

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
    
    [_m_searchTextField becomeFirstResponder];
    
    arraySuggests = [[NSMutableArray alloc] init];
    
    googlePlacesConnection = [[GooglePlacesConnection alloc] initWithDelegate:self];
    
    [self refreshImage];
    
    // Set Timer for current Date
    [self setLabel];
    [self createTimer];
}

- (void)dealloc {
    [_m_searchTextField release];
    [_m_tableView release];
    [arraySuggests release];
    [googlePlacesConnection release];
    [_m_imgViewProfile release];
    [_m_labelCurrentDate release];
    [_m_labelCurrentTime release];
    
    if (m_timer != nil) {
        [m_timer release];
    }
    [super dealloc];
}

- (void)viewDidUnload {
    [self setM_searchTextField:nil];
    [self setM_tableView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arraySuggests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [[arraySuggests objectAtIndex:indexPath.row] objectForKey:@"description"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *strReference = [[arraySuggests objectAtIndex:indexPath.row] objectForKey:@"reference"];
    
    [googlePlacesConnection getGoogleObjectDetails: strReference];
}

#pragma mark - Touch Action

- (IBAction)onTouchCancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)onChangeSearchField:(id)sender {
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * proposedNewString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    
    
    [googlePlacesConnection getGoogleSuggestion: [CUtils URLEncoding: proposedNewString]];
    
    return YES;
}

//UPDATE - to handle filtering
- (void)googlePlacesConnection:(GooglePlacesConnection *)conn didFinishLoadingWithGooglePlacesObjects:(NSMutableArray *)objects
{
    
    if ([objects count] == 0) {
        /*
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are not near any restaurants"
                                                        message:@"Please try gain the next time you dine out"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
         */
    } else {
        if (conn.m_nCallType == 2) {
            [arraySuggests removeAllObjects];
            [arraySuggests addObjectsFromArray: objects];
        
            NSLog(@"suggestions = %@", objects);
        
            [_m_tableView reloadData];
        } else if (conn.m_nCallType == 3) {
            
            DataKeeper *dataKeeper = [DataKeeper sharedInstance];
            GooglePlacesObject *googledetailObj;
            
           /* NSDictionary *dict = (NSDictionary *) objects;
            
            DataKeeper *dataKeeper = [DataKeeper sharedInstance];
            
            [dataKeeper setM_curLocation: [dict objectForKey:@"formatted_address"]];
            [dataKeeper setM_curLatitude: [[[dict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"]];
            [dataKeeper setM_curLongitude: [[[dict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"]];
            
            */
            
            googledetailObj = [objects objectAtIndex: 0];
    
            [dataKeeper setM_curLocation: googledetailObj.formattedAddress];
            [dataKeeper setM_curLatitude: [NSString stringWithFormat:@"%f", googledetailObj.coordinate.latitude]];
            [dataKeeper setM_curLongitude: [NSString stringWithFormat:@"%f", googledetailObj.coordinate.longitude]];
            
            [self.delegate AddressSelected];
            
            [self.navigationController popViewControllerAnimated: YES];
        }
    }
}

- (void) googlePlacesConnection:(GooglePlacesConnection *)conn didFailWithError:(NSError *)error
{
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error finding place - Try again"
     message:[error localizedDescription]
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles: nil];
     */
    
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Try again"
                                                    message:@"We are having trouble finding places near you. Please try again."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
     */
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
