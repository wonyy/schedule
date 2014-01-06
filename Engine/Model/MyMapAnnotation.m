//
//  MyMapAnnotation.m
//  Schedule
//
//  Created by wony on 08/22/13.
//  Copyright 2011 wony. All rights reserved.
//

#import "MyMapAnnotation.h"


@implementation MyMapAnnotation

@synthesize coordinate, title, subtitle, image, m_nIndex, distance;

- (void)dealloc{
	[title release];
    [subtitle release];
    [image release];
	[super dealloc];
}

@end
