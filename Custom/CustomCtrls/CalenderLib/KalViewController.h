/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>
#import "KalView.h"       // for the KalViewDelegate protocol
#import "KalDataSource.h" // for the KalDataSourceCallbacks protocol

@class KalLogic, KalDate;

@protocol KalViewControllerDelegate
-(void)dateWasSelected:(KalDate*)date;
@end

@interface KalViewController : UIViewController <KalViewDelegate, KalDataSourceCallbacks>
{
  KalLogic *logic;
  UITableView *tableView;
  id <UITableViewDelegate> delegate;
  id <KalDataSource> dataSource;
  NSDate *initialDate;                    // The date that the calendar was initialized with *or* the currently selected date when the view hierarchy was torn down in order to satisfy a low memory warning.
  NSDate *selectedDate;                   // I cache the selected date because when we respond to a memory warning, we cannot rely on the view hierarchy still being alive, and thus we cannot always derive the selected date from KalView's selectedDate property.
    
    CGSize m_tabSize;
    CGSize m_viewSize;
    
    id<KalViewControllerDelegate> selectDelegate;
    
    int clanderViewType;
}

@property (nonatomic, assign) id<UITableViewDelegate> delegate;
@property (nonatomic, assign) id<KalDataSource> dataSource;
@property (nonatomic, assign) id<KalViewControllerDelegate> selectDelegate;
@property (nonatomic, retain, readonly) NSDate *selectedDate;

- (id)initWithTabSize:(CGSize)tabSize withViewSize:(CGSize)viewSize withParentDelegate:(id)reciver;
- (id)initPopWithTabSize:(CGSize)tabSize withViewSize:(CGSize)viewSize withParentDelegate:(id)reciver;
- (id)initWithSelectedDate:(NSDate *)selectedDate;  
- (id)initPopWithSelectedDate:(NSDate*)selectedDate;
- (void)reloadData;                                 // If you change the KalDataSource after the KalViewController has already been displayed to the user, you must call this method in order for the view to reflect the new data.
- (void)showAndSelectDate:(NSDate *)date;           // Updates the state of the calendar to display the specified date's month and selects the tile for that date.

@end
