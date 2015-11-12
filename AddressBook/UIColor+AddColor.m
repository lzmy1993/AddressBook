//
//  UIColor+AddColor.m
//  paopao
//
//  Created by yite on 14-3-3.
//  Copyright (c) 2014年 yite. All rights reserved.
//

#import "UIColor+AddColor.h"

@implementation UIColor (AddColor)

//将16进制RGB值转换成iOS认识的RGB颜色
+ (UIColor *)colorWithHexString:(NSString *)color {
	return [UIColor colorWithHexString:color alpha:1.f];
}

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
	NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	// String should be 6 or 8 characters
	if ([cString length] < 6) {
		return [UIColor clearColor];
	}
	// strip 0X if it appears
	if ([cString hasPrefix:@"0X"])
		cString = [cString substringFromIndex:2];
	if ([cString hasPrefix:@"#"])
		cString = [cString substringFromIndex:1];
	if ([cString length] != 6)
		return [UIColor clearColor];
	// Separate into r, g, b substrings
	NSRange range;
	range.location = 0;
	range.length = 2;
	//r
	NSString *rString = [cString substringWithRange:range];
	//g
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	//b
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor *)randomColor {
	static BOOL seed = NO;
	if (!seed) {
		seed = YES;
		srandom((unsigned int)time(NULL));
	}
	CGFloat red = (CGFloat)random() / (CGFloat)RAND_MAX;
	CGFloat green = (CGFloat)random() / (CGFloat)RAND_MAX;
	CGFloat blue = (CGFloat)random() / (CGFloat)RAND_MAX;
	if (red == 255 && green == 255 && blue == 0) {
		red = (CGFloat)random() / (CGFloat)RAND_MAX;
		green = (CGFloat)random() / (CGFloat)RAND_MAX;
		blue = (CGFloat)random() / (CGFloat)RAND_MAX;
	}
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];//alpha为1.0,颜色完全不透明
}

@end
