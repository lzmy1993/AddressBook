//
//  ArrowShapeFlowLayout.m
//  testApp
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ArrowShapeFlowLayout.h"
@implementation ArrowShapeFlowLayout
- (id)initWithItemSize:(CGSize)cellSize HorizontalSapce:(CGFloat)hspace VerticalSapce:(CGFloat)vspace headViewHeight:(CGFloat)HeadHeight headViewSpaceWithTop:(CGFloat)HCSpace{
    if ((self = [super init]) != NULL) {
        self.cellSize = cellSize;            //cell大小
        self.horizontalSpace = hspace;       //各个cell水平间距
        self.verticalSpace = vspace;         //各个cell垂直间距
        self.headViewHeight = HeadHeight;    //headView高度
        self.headViewSpaceWithTop = HCSpace;//headView距离view顶部的高度
    }
    return self;
}
- (void)prepareLayout{
    [super prepareLayout];
    _cellCount = [[self collectionView]numberOfItemsInSection:0];
}
- (CGSize)collectionViewContentSize{
    return CGSizeMake([self collectionView].frame.size.width, ceilf(_cellCount/3)*(_cellSize.height+_verticalSpace) +  _cellSize.height + _verticalSpace/2 + _headViewSpaceWithTop + IPHONE_CUSTOMTABBAR_HEIGHT + 40);
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *attributesArr = [NSMutableArray array];
    for (NSInteger i = 0; i < _cellCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributesArr addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
    //add supplementaryView
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:@"Supplementary" atIndexPath:indexPath];
    [attributesArr addObject:attributes];
    
    return attributesArr;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = CGSizeMake(_cellSize.width, _cellSize.height);
    CGPoint point;
    if (indexPath.item % 3 == 0) {
        point = CGPointMake(SCREEN_WIDTH/2-_cellSize.width-_horizontalSpace, _cellSize.height/2 + indexPath.item/3 * (_cellSize.height + _verticalSpace)+_headViewSpaceWithTop);
    }else if (indexPath.item % 3 == 1) {
        point = CGPointMake(SCREEN_WIDTH/2+_cellSize.width+_horizontalSpace, _cellSize.height/2 + (indexPath.item-1)/3 * (_cellSize.height + _verticalSpace)+_headViewSpaceWithTop);
    }else{
        point = CGPointMake((SCREEN_WIDTH)/2, _cellSize.height/2 + (2*indexPath.item - 1)/3 * (_cellSize.height+_verticalSpace)/2+_headViewSpaceWithTop);
    }
    attributes.center = point;
    return attributes;
    
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    attributes.frame = CGRectMake(0, 0, SCREEN_WIDTH, _headViewHeight);
    return attributes;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
@end
