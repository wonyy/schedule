//
//  EditEventNameViewController.m
//  Schedule
//
//  Created by Galaxy39 on 8/17/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()

@end

@implementation NoteViewController
@synthesize delegate;
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
    [_txtView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {    
    [_txtView release];
    [_m_imgViewProfile release];
    [super dealloc];
}

- (IBAction)onAdd:(id)sender {
    NSString * note = [_txtView text];
    if(note.length > 0){        
        [self.delegate NoteEdited:note];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)onCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
