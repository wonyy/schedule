//
//  NoteCell.h
//  Schedule
//
//  Created by TanLong on 10/29/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UITextView *m_textViewNote;
@property (retain, nonatomic) UILabel *labelPlaceHolder;

- (void) AddPlaceHolder: (NSString *) strPlaceHolder;

@end
