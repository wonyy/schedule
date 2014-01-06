//
//  CUtils.h
//  Schedule
//
//  Created by wony on 08/22/13.
//  Copyright 2013 wony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>


@interface CUtils : NSObject {

}

+ (NSString *)getDeviceID;

+ (NSString *)getFilePath:(NSString *)fileName;
+ (BOOL)isFileInDocumentDirectory:(NSString *)fileName;
+ (void)copyFileToDocumentDirectory:(NSString *)fileName;
+ (NSString *)getDocumentDirectory;
+ (NSString *)generateFileName: (BOOL) bMovie;

+ (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

// Time and Date
+ (NSString *)convertToLocalTime:(NSString *)GMTtime;
+ (NSString *)getCurrentTime;
+ (NSString *)getStringforTime: (NSDate *) date;
+ (NSInteger)getAge:(NSString *)dateOfBirth;

// image
+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;

// iPhone 5
+ (BOOL) isIphone5;

+ (void) makeRoundedText: (UITextField *) textField;
+ (void) makeCircleImage: (UIImageView *)imageView;
+ (BOOL) IsEmptyString : (NSString *) str;

+ (CGFloat) getRealHeight: (NSString *) text size: (CGSize) textSize font: (UIFont *) font min_height: (float) minHeight lineBreakMode:(NSLineBreakMode)lineBreakMode;

+ (NSString *) createSHA512:(NSString *)source;
+ (NSString *) createSHA1: (NSString *)source;
+ (NSString *) createMD5:(NSString *)source;
+ (NSString*) getNonce : (NSInteger) nLength;

+ (NSString *) URLEncoding: (NSString *) str;
+ (NSString *) URLDecoding: (NSString *) str;

@end
