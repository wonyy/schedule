//
//  InviteListViewController.m
//  Schedule
//
//  Created by TanLong on 11/21/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "InviteListViewController.h"

@interface InviteListViewController ()

@end

@implementation InviteListViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_tableView release];
    [_m_GuestCell release];
    [super dealloc];
}

#pragma mark - Touch Actions

- (IBAction)onTouchNavBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - Table View Delegate

// Set the height of each cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

// Set Cell Count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_m_arrayGuests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSBundle mainBundle] loadNibNamed:@"GuestCell" owner:self options:nil];
    
    NSDictionary *item = [_m_arrayGuests objectAtIndex: indexPath.row];
    
    [_m_GuestCell.m_guestName setText: [item objectForKey:@"full_name"]];
        
    [_m_GuestCell setM_strImgURL: [NSString stringWithFormat:@"%@%@", WEBAPI_URL, [item objectForKey:@"profile_picture"]]];
    
    [_m_GuestCell refreshImage];
        
    return _m_GuestCell;
}


@end
