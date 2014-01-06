//
//  UIFactory.h
//  SmartMeeting
//
//  Created by luddong on 12-3-30.
//  Copyright (c) 2012年 Twin-Fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFactory : NSObject

/**--------------------------------
 * Create UITextField
 *
 * frame            :CGRect
 * delegate         :id<UITextFieldDelegate>
 * returnKeyType    :UIReturnKeyType
 * secureTextEntry  :BOOL
 * placeholder      :NSString
 * font             :UIFont
 *
 */
+ (id)createTextFieldWith:(CGRect)frame 
                 delegate:(id<UITextFieldDelegate>)delegate
            returnKeyType:(UIReturnKeyType)returnKeyType
          secureTextEntry:(BOOL)secureTextEntry
              placeholder:(NSString *)placeholder 
                     font:(UIFont *)font;


/**--------------------------------
 * Create UILabel
 *
 * frame :CGRect
 * label :NSString
 *
 */
+ (id)createLabelWith:(CGRect)frame 
                text:(NSString *)text;

/**--------------------------------
 * Create UILabel
 *
 * frame :CGRect
 * label :NSString
 *
 */
+ (id)createClearBackgroundLabelWith:(CGRect)frame 
                                text:(NSString *)text;

/**--------------------------------
 * Create UILabel
 *
 * frame            :CGRect
 * label            :NSString
 * backgroundColor  :UIColor
 *
 */
+ (id)createLabelWith:(CGRect)frame 
                text:(NSString *)text 
      backgroundColor:(UIColor *)backgroundColor;

/**--------------------------------
 * Create UILabel
 *
 * frame            :CGRect
 * label            :NSString
 * font             :UIFont
 * textColor        :UIColor
 * backgroundColor  :UIColor
 *
 */
+ (id)createLabelWith:(CGRect)frame 
                text:(NSString *)text 
                 font:(UIFont *)font 
            textColor:(UIColor *)textColor 
      backgroundColor:(UIColor *)backgroundColor;

/**--------------------------------
 * Convert Resizable (Stretchable) Image;
 *
 *  title           :NSString *
 *  message         :NSString *
 */
+ (UIImage*)resizableImageWithSize:(CGSize)size
                             image:(UIImage*)image;

+ (UIButton *)createButtonWithRect:(CGRect)frame 
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                          selected:(NSString *)clickIamge
                          selector:(SEL)selector
                            target:(id)target;

+ (UIButton *)createButtonWithRect:(CGRect)frame 
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                         highlight:(NSString *)clickIamge
                          selector:(SEL)selector
                            target:(id)target;

+ (UIButton *)createButtonWithRect:(CGRect)frame 
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                         highlight:(NSString *)clickIamge
                             fixed:(CGSize)fixedSize
                          selector:(SEL)selector
                            target:(id)target;

+ (UIButton *)createButtonWithRect:(CGRect)frame 
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                         highlight:(NSString *)clickIamge
                          selected:(NSString *)selectedImage
                          selector:(SEL)selector
                            target:(id)target;


+ (UITextField *)createTextFieldWithRect:(CGRect)frame
                            keyboardType:(UIKeyboardType)keyboardType
                                  secure:(BOOL)secure
                             placeholder:(NSString *)placeholder
                                    font:(UIFont *)font
                                   color:(UIColor *)color
                                delegate:(id)delegate;

+ (NSString *)localized:(NSString *)key;

/**--------------------------------
 * Check Network Address Validation
 *
 *  address           :NSString *
 */
+ (BOOL)isValidIPAddress:(NSString *)address;
+ (BOOL)isValidPortAddress:(NSString *)address;
+ (BOOL)checkIntValueRange:(NSString *)value min:(int)min max:(int)max;

@end
