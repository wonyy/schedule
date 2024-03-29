//
//  CUtils.m
//  Schedule
//
//  Created by wony on 08/22/13.
//  Copyright 2013 wony. All rights reserved.
//

#import "CUtils.h"
#import "QuartzCore/QuartzCore.h"

@implementation CUtils

+ (NSString *)getDeviceID
{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    
    return uuidString;

}

+ (NSString *)getDocumentDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return documentsDirectory;
}

+ (NSString *)generateFileName: (BOOL) bMovie {
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"MMddyyyy_HH_mm_ss"];
    NSString *date_str = [dateFormatter stringFromDate:currDate];
    NSString *strFileName;
    
    NSInteger randomNumber = arc4random() % 10000;
    
    if (bMovie == YES) {
        strFileName = [NSString stringWithFormat:@"schedule%@.mp4", date_str];
    } else {
        strFileName = [NSString stringWithFormat:@"schedule%@_%d.jpg", date_str, randomNumber];
    }
    
    [strFileName retain];
    
    return strFileName;
}
	
+ (NSString *)getFilePath:(NSString *)fileName
{
	NSArray *fileComponents = [NSArray arrayWithArray:[fileName componentsSeparatedByString:@"."]];
	NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileComponents objectAtIndex:0] ofType:[fileComponents objectAtIndex:1]];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
	BOOL isAtPath = [fileManager fileExistsAtPath:path];
	
	if (isAtPath) {
		return path;
	} else {
		return filePath;
	}
	
}

+ (BOOL)isFileInDocumentDirectory:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isFileAtPath = [fileManager fileExistsAtPath:path];
	return isFileAtPath;
}

+ (void)copyFileToDocumentDirectory:(NSString *)fileName {
	NSString *pathOfFile = [self getFilePath:fileName];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *docDir = [self getDocumentDirectory];
	NSString *desFilePath = [docDir stringByAppendingPathComponent:fileName];
    
	if ([self isFileInDocumentDirectory:fileName]) {
		
	} else {
		[fileManager copyItemAtPath:pathOfFile toPath:desFilePath error:nil];
	}
}


+ (NSString *)convertToLocalTime:(NSString *)GMTtime {
    NSString *serverDateString = GMTtime;
    NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
    [serverDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromServer = [serverDateFormatter dateFromString:serverDateString];
    [serverDateFormatter release];
    
    NSDateFormatter *dateFormatConverter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatConverter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    /////////// GMT Logic ////
    NSDate* sourceDate = dateFromServer;
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
    /////// End GMT Logic /////
    
    NSString *localDate = [dateFormatConverter stringFromDate:destinationDate]; 
    
    return localDate;
    
}


+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

+ (NSString *)getCurrentTime {
    NSDate* date = [NSDate date];
    
  //  NSDate* newDate = [date addTimeInterval:3600*12];
    
    //Create the dateformatter object
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    //Set the required date format
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    //Get the string date
    
    NSString* str = [formatter stringFromDate:date];
    
    
    
    //Display on the console
  //  NSLog(@"%@", [formatter stringFromDate: newDate]);
    
    return str;
    
}

+ (NSString *)getStringforTime : (NSDate *) date {
    
    //  NSDate* newDate = [date addTimeInterval:3600*12];
    
    //Create the dateformatter object
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    //Set the required date format
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm a"];
    
    //Get the string date
    
    NSString* str = [formatter stringFromDate:date];
    
    
    //Display on the console
    //  NSLog(@"%@", [formatter stringFromDate: newDate]);
    
    return str;
    
}

+ (void) makeCircleImage: (UIImageView *)imageView {
    UIImage *image = imageView.image;
    CGSize imageSize = image.size;
    CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    
    // Create the clipping path and add it
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:imageRect];
    [path addClip];
    
    [image drawInRect:imageRect];
    
    CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    [path setLineWidth:2.0f];
    [path stroke];

    
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    imageView.image = roundedImage;
}


+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    float width = size.width;
    float height = size.height;
    
    UIGraphicsBeginImageContext(size);
  //  CGContextSetLineWidth(context, 2.0);

    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height;
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor;
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return smallImage;
}

+ (NSInteger)getAge:(NSString *)dateOfBirth {
    
    if (dateOfBirth == nil || [dateOfBirth length] < 9) {
        return 0;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *convertedDate = [df dateFromString:[dateOfBirth substringToIndex:[dateOfBirth length] - 9]];
    [df release];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:convertedDate];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
        return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
    } else {
        return [dateComponentsNow year] - [dateComponentsBirth year];
    }
}

// Check if current device is iPhone 5
// LOL, if height of screen is 568, yeah it's just iPhone 5!!!!!
+ (BOOL) isIphone5 {
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        return YES;
    }
    
    return NO;
}

// Make Rounded txet
+ (void) makeRoundedText: (UITextField *) textField {
    
    textField.layer.borderColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0].CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 10;
    textField.layer.masksToBounds = YES;

}

+ (BOOL) IsEmptyString : (NSString *) str {
    return ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0);
}


+ (CGFloat) getRealHeight: (NSString *) text size: (CGSize) textSize font: (UIFont *) font min_height: (float) minHeight lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    CGSize realSize = [text sizeWithFont:font constrainedToSize:textSize lineBreakMode:lineBreakMode];
    
    CGFloat ht = MAX(realSize.height, minHeight);
    
    return ht;

}

#pragma mark - Sha512

+ (NSString *) createSHA512:(NSString *)source {
    
    const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    
    CC_SHA512(keyData.bytes, keyData.length, digest);
    
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    
    return [out description];
}

#pragma mark - Sha1

+ (NSString *) createSHA1: (NSString *)source {
    NSData *data = [source dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}



#pragma mark - MD5
+ (NSString *) createMD5: (NSString *) source {
    const char *cStr = [source UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  [output uppercaseString];
    
}

+ (NSString*) getNonce : (NSInteger) nLength {
    static char table[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *output = [NSMutableString stringWithCapacity:nLength];
    
    NSInteger i;
    for (i = 0; i < nLength; i++) {
        [output appendFormat:@"%c", table[rand() % strlen(table)]];
    }
    
    return output;
}

#pragma mark - URL Encoding

+ (NSString *) URLEncoding: (NSString *) str {
    NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                   NULL,
                                                                                   (CFStringRef)str,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                   kCFStringEncodingUTF8 );
    
    return encodedString;
}

+ (NSString *) URLDecoding: (NSString *) str {
    return (NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                (CFStringRef) str,
                                                                                CFSTR(""),
                                                                                kCFStringEncodingUTF8);
}
    
@end
