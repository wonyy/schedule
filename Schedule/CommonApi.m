//
//  CommonApi.m
//  Schedule
//
//  Created by Galaxy39 on 8/17/13.
//  Copyright (c) 2013 suhae. All rights reserved.
//

#import "CommonApi.h"

@implementation CommonApi

+ (NSMutableArray*)getDateStringStartAndEndTime:(NSDate*)date endDate:(NSDate *) eDate
{
    NSDateFormatter * formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateString = [formatter stringFromDate:date];
    NSString * stDateString = [dateString stringByAppendingString:@" 00:00:00"];
    
    dateString = [formatter stringFromDate: eDate];
    NSString * edDateString = [dateString stringByAppendingString:@" 23:59:59"];

    NSDate *dateSt = [self getDateTimeFromStringWithCurrentTimeZone: stDateString];
    NSDate *dateEd = [self getDateTimeFromStringWithCurrentTimeZone: edDateString];
    
    stDateString = [self getStringFromDateTime: dateSt];
    edDateString = [self getStringFromDateTime: dateEd];

    return [[NSMutableArray alloc] initWithObjects:stDateString, edDateString, nil];
}

+ (NSMutableArray*)getDateStartAndEndTime:(NSDate*)date
{
    NSDateFormatter * formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateString = [formatter stringFromDate:date];
    NSString * stDateString = [dateString stringByAppendingString:@" 00:00:00"];
    NSString * edDateString = [dateString stringByAppendingString:@" 23:59:59"];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [[[NSMutableArray alloc] initWithObjects:[formatter dateFromString:stDateString], [formatter dateFromString:edDateString], nil] autorelease];
}


+ (BOOL)isContain:(NSDate*)oriDate :(NSDate*)stDate :(NSDate*)edDate
{
    if([oriDate timeIntervalSince1970]  >= [stDate timeIntervalSince1970] && [oriDate timeIntervalSince1970] <= [edDate timeIntervalSince1970])
        return YES;
    return NO;
}

+ (BOOL)compare:(NSDate*)oridate :(NSDate*)comDate
{
    if([oridate timeIntervalSince1970]  >= [comDate timeIntervalSince1970])
        return YES;
    return NO;
}

+ (NSString *)getWeekDay: (NSDate *)date {
    NSDateFormatter *myFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    [myFormatter setDateFormat:@"EEEE"];
    
    NSString *dayOfWeek = [myFormatter stringFromDate: date];
    
    return [dayOfWeek substringToIndex:3];
}

+ (NSString *) getTime: (NSDate *) date {
    NSDateFormatter * formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:@"hh:mm a"];
    return [formatter stringFromDate:date];
}

+ (NSString *) getTime: (NSDate *) date timeformat: (NSString *) timeFormat {
    NSDateFormatter * formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:timeFormat];
    return [formatter stringFromDate:date];
}

+ (NSString *) getDateTime: (NSDate *) date {
    NSDateFormatter * formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    return [formatter stringFromDate:date];
}

+ (NSString *) getGMTDateTime: (NSDate *) date {
    NSDateFormatter * formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [formatter setTimeZone: gmt];

    return [formatter stringFromDate:date];
}

+ (NSDate*)getDateFromString: (NSString*)date
{
    NSDateFormatter * formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:date];
}
+ (NSString*)getStringFromDate:(NSDate*)date
{
    NSDateFormatter * formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

+ (NSDate*)getDateTimeFromString:(NSString*)date
{
    NSDateFormatter * formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    return [formatter dateFromString:date];
}

+ (NSDate*)getDateTimeFromStringWithCurrentTimeZone:(NSString*)date
{
    NSDateFormatter * formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:date];
}

+ (NSDate*)getDateTimeFromStringForDailyView:(NSString*)date
{
    NSDateFormatter * formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd H:mm"];
    return [formatter dateFromString:date];
}

+ (NSString*)getStringFromDateTime:(NSDate*)date
{
    NSDateFormatter * formatter = [[NSDateFormatter new] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
    return [formatter stringFromDate:date];
}

+ (UIColor*)getColorFromIndex:(int)index
{   
    switch (index) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor blueColor];
        case 2:
            return [UIColor greenColor];
        case 3:
            return [UIColor yellowColor];
        case 4:
            return [UIColor brownColor];
        case 5:
            return [UIColor cyanColor];
        case 6:
            return [UIColor orangeColor];
        case 7:
            return [UIColor purpleColor];
        default:
            return [UIColor blackColor];
    }
}


+ (NSString*)getColorNameFromIndex:(int)index
{
    switch (index) {
        case 0:
            return @"Red";
        case 1:
            return @"Blue";
        case 2:
            return @"Green";
        case 3:
            return @"Yellow";
        case 4:
            return @"Brown";
        case 5:
            return @"Cyan";
        case 6:
            return @"Orange";
        case 7:
            return @"Purple";
        default:
            return @"None";
    }
}
+ (NSDate*)getBeforeDay:(NSDate*)day
{
    NSTimeInterval timeInterval = [day timeIntervalSince1970];
    timeInterval -= 24 * 60 * 60;
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}
+ (NSDate*)getAfterDay:(NSDate*)day
{
    NSTimeInterval timeInterval = [day timeIntervalSince1970];
    timeInterval += 24*60*60;
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}
+ (NSDate*)getBeforeWeekDay:(NSDate*)day
{
    NSTimeInterval timeInterval = [day timeIntervalSince1970];
    timeInterval -= 24*60*60*7;
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}
+ (NSDate*)getAfterWekDay:(NSDate*)day
{
    NSTimeInterval timeInterval = [day timeIntervalSince1970];
    timeInterval += 24*60*60*7;
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}
+ (NSDate*)getBeforeMonthDay:(NSDate*)day
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:day];
    components.month -= 1;    
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}
+(NSDate*)getAfterMonthDay:(NSDate*)day
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:day];
    components.month += 1;
    NSDate *date = [calendar dateFromComponents:components];
    return date;
}

+ (NSString *) getClientTimeFormat: (NSString *) serverTimeFormat {
    if ([serverTimeFormat isEqualToString:@"%Y-%n-%d"]) {
        return @"yyyy-MM-dd";
    } else if ([serverTimeFormat isEqualToString:@"%h:%i%a"]) {
        return @"h:mm a";
    } else if ([serverTimeFormat isEqualToString:@"%M %j %Y"]) {
        return @"MMM d yyyy";
    } else if ([serverTimeFormat isEqualToString:@"%G:%i"]) {
        return @"H:mm";
    }
    
    return serverTimeFormat;
}

+ (NSString *) getServerTimeFormat: (NSString *) clientTimeFormat {
    if ([clientTimeFormat isEqualToString:@"yyyy-MM-dd"]) {
        return @"%Y-%n-%d";
    } else if ([clientTimeFormat isEqualToString:@"h:mm a"]) {
        return @"%h:%i%a";
    } else if ([clientTimeFormat isEqualToString:@"MMM d yyyy"]) {
        return @"%M %j %Y";
    } else if ([clientTimeFormat isEqualToString:@"H:mm"]) {
        return @"%G:%i";
    }
    
    return clientTimeFormat;
}

+ (NSString *) ConvertWithNewFormat: (NSString *) strDate oldFormat: (NSString *) strold newFormat: (NSString *) strnew {
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat: strold];
    
    NSDate *date = [formatter dateFromString: strDate];
    
    [formatter setDateFormat: strnew];
    
    return [formatter stringFromDate: date];
}

@end
