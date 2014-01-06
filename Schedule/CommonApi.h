//
//  CommonApi.h
//  Schedule
//
//  Created by Galaxy39 on 8/17/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonApi : NSObject

+ (NSMutableArray*)getDateStringStartAndEndTime:(NSDate*)date endDate:(NSDate *) eDate;
+ (NSMutableArray*)getDateStartAndEndTime:(NSDate*)date;
+ (BOOL)isContain:(NSDate*)oriDate :(NSDate*)stDate :(NSDate*)edDate;
+ (BOOL)compare:(NSDate*)oridate :(NSDate*)comDate;

+ (NSDate*)getDateFromString:(NSString*)date;
+ (NSString*)getStringFromDate:(NSDate*)date;

+ (NSDate*)getDateTimeFromString:(NSString*)date;
+ (NSString*)getStringFromDateTime:(NSDate*)date;
+ (NSDate*)getDateTimeFromStringWithCurrentTimeZone:(NSString*)date;
+ (NSDate*)getDateTimeFromStringForDailyView:(NSString*)date;

+ (UIColor*)getColorFromIndex:(int)index;
+ (NSString*)getColorNameFromIndex:(int)index;

+ (NSDate*)getBeforeDay:(NSDate*)day;
+ (NSDate*)getAfterDay:(NSDate*)day;
+ (NSDate*)getBeforeWeekDay:(NSDate*)day;
+ (NSDate*)getAfterWekDay:(NSDate*)day;
+ (NSDate*)getBeforeMonthDay:(NSDate*)day;
+ (NSDate*)getAfterMonthDay:(NSDate*)day;
+ (NSString *)getWeekDay: (NSDate *)date;

+ (NSString *) getTime: (NSDate *) date;
+ (NSString *) getTime: (NSDate *) date timeformat: (NSString *) timeFormat
;
+ (NSString *) getDateTime: (NSDate *) date;
+ (NSString *) getGMTDateTime: (NSDate *) date;

+ (NSString *) getClientTimeFormat: (NSString *) serverTimeFormat;
+ (NSString *) getServerTimeFormat: (NSString *) clientTimeFormat;
+ (NSString *) ConvertWithNewFormat: (NSString *) strDate oldFormat: (NSString *) strold newFormat: (NSString *) strnew;


@end

#define ISiPhone5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)