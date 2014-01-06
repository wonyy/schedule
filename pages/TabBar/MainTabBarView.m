//
//  MainTabBarView.m
//  Schedule
//
//  Created by suhae on 8/16/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "MainTabBarView.h"

@implementation MainTabBarView
@synthesize delegate;

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MainTabBarView" owner:self options:nil] objectAtIndex:0];
    if (self){
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (IBAction)onSelectType:(id)sender {

    NSInteger nType = [sender tag] - 100;
    
    for (NSInteger nIndex = 0; nIndex < 5; nIndex++) {
        if (nType == nIndex) {
            [(UIButton *)sender setSelected: YES];
        } else {
            [((UIButton *)[self viewWithTag: nIndex + 100]) setSelected: NO];
        }
    }
    

    [self.delegate MainTabBarViewDelegate_selectedAt:nType];

}

- (IBAction)onAddAction:(id)sender {
    [self.delegate MainTabBarViewDelegate_selectedAt:10];
}

- (IBAction)onShowMenu:(id)sender {
    [self.delegate ShowMenu];
}


@end
