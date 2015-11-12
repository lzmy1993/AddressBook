//
//  UIColor+AddColor.h
//  paopao
//
//  Created by Li on 14-3-3.
//  Copyright (c) 2014年 yite. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIColor (AddColor)

+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *)randomColor;

@end
