//
//  EditEventNameViewController.h
//  Schedule
//
//  Created by Galaxy39 on 8/17/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoteViewControllerDelegate

- (void)NoteEdited:(NSString*)notes;

@end

@interface NoteViewController : UIViewController

@property (nonatomic, retain) id<NoteViewControllerDelegate>delegate;
@property (retain, nonatomic) IBOutlet UITextView *txtView;
@property (retain, nonatomic) IBOutlet UIImageView *m_imgViewProfile;


- (IBAction)onAdd:(id)sender;
- (IBAction)onCancel:(id)sender;
@end
