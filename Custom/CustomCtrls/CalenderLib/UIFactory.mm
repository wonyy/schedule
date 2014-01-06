//
//  UIFactory.m
//  SmartMeeting
//
//  Created by luddong on 12-3-30.
//  Copyright (c) 2012年 Twin-Fish. All rights reserved.
//

#import "UIFactory.h"
#import <arpa/inet.h>


@implementation UIFactory

+ (id)createTextFieldWith:(CGRect)frame 
                 delegate:(id<UITextFieldDelegate>)delegate
            returnKeyType:(UIReturnKeyType)returnKeyType
          secureTextEntry:(BOOL)secureTextEntry
              placeholder:(NSString *)placeholder 
                     font:(UIFont *)font {
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    if (delegate != nil) {
        textField.delegate = delegate;
        textField.returnKeyType = returnKeyType;
        textField.secureTextEntry = secureTextEntry;
        textField.placeholder = placeholder;
        textField.font = font;
        // Default property
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.enablesReturnKeyAutomatically = YES;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return [textField autorelease];
}

+ (id)createLabelWith:(CGRect)frame text:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    return [label autorelease];
}

+ (id)createLabelWith:(CGRect)frame 
                 text:(NSString *)text 
       backgroundColor:(UIColor *)backgroundColor {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.backgroundColor = backgroundColor;
    return [label autorelease];
}

+ (id)createClearBackgroundLabelWith:(CGRect)frame 
                                text:(NSString *)text {
    return [UIFactory createLabelWith:frame 
                                 text:text 
                      backgroundColor:[UIColor clearColor]];
}

+ (id)createLabelWith:(CGRect)frame 
                text:(NSString *)text 
                 font:(UIFont *)font 
            textColor:(UIColor *)textColor 
      backgroundColor:(UIColor *)backgroundColor {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.textColor = textColor;
    label.backgroundColor = backgroundColor;
    return [label autorelease];
}

+ (UIImage*)resizableImageWithSize:(CGSize)size
                             image:(UIImage*)image {
    if (image == nil)
        return nil;
    
    if ([image respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        return [image resizableImageWithCapInsets:UIEdgeInsetsMake(size.height, size.width, size.height, size.width)];
    } else {
        return [image stretchableImageWithLeftCapWidth:size.width topCapHeight:size.height];
    }
}

+ (UIButton *)createButtonWithRect:(CGRect)frame 
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                          selected:(NSString *)clickIamge
                          selector:(SEL)selector
                            target:(id)target;
{    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (title != nil)
        [button setTitle:title forState:UIControlStateNormal];
    
    if (titleColor != nil)
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    if (font != nil)
        [button.titleLabel setFont:font];
    
    if (normalImage != nil)
        [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    
    if (clickIamge != nil)
        [button setBackgroundImage:[UIImage imageNamed:clickIamge] forState:UIControlStateSelected];
    
    if ((selector != nil) && (target != nil))
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)createButtonWithRect:(CGRect)frame 
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                         highlight:(NSString *)clickIamge
                          selector:(SEL)selector
                            target:(id)target;
{    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (title != nil)
        [button setTitle:title forState:UIControlStateNormal];
    
    if (titleColor != nil)
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    if (font != nil)
        [button.titleLabel setFont:font];
    
    if (normalImage != nil)
        [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    
    if (clickIamge != nil)
        [button setBackgroundImage:[UIImage imageNamed:clickIamge] forState:UIControlStateHighlighted];
    
    if ((selector != nil) && (target != nil))
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)createButtonWithRect:(CGRect)frame 
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                         highlight:(NSString *)clickIamge
                             fixed:(CGSize)fixedSize
                          selector:(SEL)selector
                            target:(id)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    if (title != nil)
        [button setTitle:title forState:UIControlStateNormal];
    
    if (titleColor != nil)
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    if (font != nil)
        [button.titleLabel setFont:font];
    
    if (normalImage != nil) {
        [button setBackgroundImage:[UIFactory resizableImageWithSize:fixedSize image:[UIImage imageNamed:normalImage]]
                          forState:UIControlStateNormal];
    }
    
    if (clickIamge != nil) {
        [button setBackgroundImage:[UIFactory resizableImageWithSize:fixedSize image:[UIImage imageNamed:clickIamge]]
                          forState:UIControlStateHighlighted];
    }
    
    if ((selector != nil) && (target != nil))
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIButton *)createButtonWithRect:(CGRect)frame 
                             title:(NSString *)title
                         titleFont:(UIFont *)font
                        titleColor:(UIColor *)titleColor
                            normal:(NSString *)normalImage
                         highlight:(NSString *)clickIamge
                          selected:(NSString *)selectedImage
                          selector:(SEL)selector
                            target:(id)target
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    
    if (title != nil)
        [button setTitle:title forState:UIControlStateNormal];
    
    if (titleColor != nil)
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    if (font != nil)
        [button.titleLabel setFont:font];
    
    if (normalImage != nil)
        [button setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    
    if (clickIamge != nil)
        [button setBackgroundImage:[UIImage imageNamed:clickIamge] forState:UIControlStateHighlighted];
    
    if (selectedImage != nil)
        [button setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    
    if ((selector != nil) && (target != nil))
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchDown];
    
    return button;
    
}

+ (UITextField *)createTextFieldWithRect:(CGRect)frame
                            keyboardType:(UIKeyboardType)keyboardType
                                  secure:(BOOL)secure
                             placeholder:(NSString *)placeholder
                                    font:(UIFont *)font
                                   color:(UIColor *)color
                                delegate:(id)delegate;
{
    UITextField *textField = [UIFactory createTextFieldWith:frame 
                                                   delegate:delegate 
                                              returnKeyType:UIReturnKeyNext 
                                            secureTextEntry:secure 
                                                placeholder:placeholder
                                                       font:font];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeNever;
    textField.keyboardType = keyboardType;
    if (color != nil)
        [textField setTextColor:color];
    
    return textField;
}

+ (NSString *)localized:(NSString *)key
{
    NSString *langCode = @"";
    
            langCode = @"en";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:langCode ofType:@"lproj"];
    NSBundle *languageBundle = [NSBundle bundleWithPath:path];
    return [languageBundle localizedStringForKey:key value:@"" table:nil];
}

+ (BOOL)isValidIPAddress:(NSString *)address
{
    if ([address length] < 1)
        return NO;
    
    struct in_addr addr;
    return (inet_aton([address UTF8String], &addr) == 1);
}

+ (BOOL)isValidPortAddress:(NSString *)address
{
    return [UIFactory checkIntValueRange:address min:1 max:65535];
}

+ (BOOL)checkIntValueRange:(NSString *)value min:(int)min max:(int)max
{
    if ([value length] < 1)
        return NO;
    
    NSScanner * scanner = [NSScanner scannerWithString:value];
    if ([scanner scanInt:nil] && [scanner isAtEnd]) {
        NSLog(@"min = %u, max = %u, value = %u %@", min, max, [value integerValue], value);
        return (min <= [value integerValue]) && ([value integerValue] <= max);
    }
    
    return NO;
}

@end
