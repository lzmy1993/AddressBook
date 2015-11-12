//
//  ArrowShapeFlowLayout.h
//  testApp
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArrowShapeFlowLayout : UICollectionViewLayout
@property (readwrite, nonatomic, assign) NSInteger cellCount;
@property (readwrite, nonatomic, assign) CGSize    cellSize;
@property (readwrite, nonatomic, assign) CGFloat   horizontalSpace;
@property (readwrite, nonatomic, assign) CGFloat   verticalSpace;
@property (readwrite, nonatomic, assign) CGFloat   headViewHeight;
@property (readwrite, nonatomic, assign) CGFloat   headViewSpaceWithTop;

- (id)initWithItemSize:(CGSize)cellSize HorizontalSapce:(CGFloat)hspace VerticalSapce:(CGFloat)vspace headViewHeight:(CGFloat)HeadHeight headViewSpaceWithTop:(CGFloat)HCSpace;
@end
