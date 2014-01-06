//
//  MyMapAnnotation.h
//  Schedule
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
#import "const.h"


@interface MyMapAnnotation : NSObject <MKAnnotation> {
	
	CLLocationCoordinate2D coordinate; 
	NSString *title; 
	NSString *subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *image;
@property (nonatomic) NSInteger m_nIndex;
@property (nonatomic) float distance;

@end
