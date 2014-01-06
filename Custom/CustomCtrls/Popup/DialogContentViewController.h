//
//  DialogContentViewController.h
//  UIXOverlayController
//
//  Created by Tan Hui on 8/29/13.
//  Copyright 2013 Cariloop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIXOverlayController.h"

@protocol DialogContentViewControllerDelegate <NSObject>

- (void) onYesPressed: (NSString *) strGroupName;

@end

@interface DialogContentViewController : UIXOverlayContentViewController {
    id <DialogContentViewControllerDelegate> delegate;

}

@property (retain, nonatomic) IBOutlet UITextField *m_textGroupName;
@property (nonatomic, assign) id <DialogContentViewControllerDelegate> delegate;


- (IBAction) yesPressed:(id) sender;
- (IBAction) noPressed:(id) sender;

- (IBAction)onTextDidEndExit:(id)sender;

@end
