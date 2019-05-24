//
//  WaterFallLayout.m
//  CustormCollectionView
//
//  Created by shutong on 2019/4/9.
//  Copyright © 2019 shutong. All rights reserved.
//

#import "WaterFallLayout.h"
//默认列数
static const NSInteger STDefaultColumnCount = 3;
//默认列间隔
static const CGFloat STDefaultInteritemMargin = 10.f;
//默认行间隔
static const CGFloat STDefaultLineMargin = 10.f;
//边缘间距
static const UIEdgeInsets STDefaultEdgeInsets = {10, 10, 10, 10};

@interface WaterFallLayout ()
/**
 存放所有的cell布局属性
 */
@property (nonatomic, strong) NSMutableArray *attrasArray;
/**
 存放所有列当前最大Y值
 */
@property (nonatomic, strong) NSMutableArray *columnHeights;

/**
 存放内容的高度
 */
@property (nonatomic, assign) CGFloat contentHeight;
//声明一下 可以使用。语法
/**
 最小列间距
 
 @return return value description
 */
- (CGFloat)interitemMargin;
/**
 最小行间距
 
 @return return value description
 */
- (CGFloat)lineMargin;
/**
 当前视图多少列
 
 @return return value description
 */
- (NSInteger)columnCount;
/**
 边缘间距
 
 @return return value description
 */
- (UIEdgeInsets)edgeInsets;


@end


@implementation WaterFallLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    //初始化所有数据
    self.contentHeight = 0.f;
    [self.columnHeights removeAllObjects];
    [self.attrasArray removeAllObjects];
    
    for (int section = 0; section < [self.collectionView numberOfSections]; section ++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < self.columnCount; i ++) {//默认每一列最大Y值
            [sectionArray addObject:@(self.edgeInsets.top)];
        }
        [self.columnHeights addObject:sectionArray];
        
    }
    for (int section = 0; section < [self.collectionView numberOfSections]; section ++) {
        CGSize headSize = CGSizeMake(0, 0);
        headSize = [self.delegate waterfallLayout:self referenceSizeForHeaderInSection:section];//获取自定义的headView的宽高
        UICollectionViewLayoutAttributes * layoutHeader = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathWithIndex:section]]; //系统分配的头视图的尺寸
        
        layoutHeader.frame =CGRectMake(layoutHeader.frame.origin.x,self.contentHeight + self.edgeInsets.bottom, headSize.width, headSize.height);
        [self.attrasArray addObject:layoutHeader];
        
        //替换顶部视图y轴数据
        NSMutableArray *lastArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < self.columnCount; i ++) {//默认每一列最大Y值
            [lastArray addObject:@(layoutHeader.size.height + layoutHeader.frame.origin.y)];
        }
        [self.columnHeights replaceObjectAtIndex:section withObject:lastArray];
        
        //获取item个数
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (int row = 0; row < itemCount; row ++) {
            //item的下标
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            //获取对应item的布局
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrasArray addObject:attrs];
        }
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrasArray;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat contentWidth = self.collectionView.frame.size.width - self.edgeInsets.left - self.edgeInsets.right; //获取collectionView实际的大小
    CGFloat itemWidth = (contentWidth - self.interitemMargin * (self.columnCount - 1)) / self.columnCount ;//计算item的宽度
    CGFloat itemHeight = [self.delegate waterfallLayout:self indexPath:indexPath itemWidth:itemWidth];//item的高度
    
    
    
    
    //找出最短的那一列
    NSInteger miniColumn = 0;
    CGFloat miniColumnHeight = [self.columnHeights[indexPath.section][0] doubleValue];//默认是第一列
    if (indexPath.section > 0) {
        
        //如果不是第一组,我们需要获取到上一组的最大y值
        miniColumnHeight = miniColumnHeight + self.edgeInsets.top + self.edgeInsets.bottom + self.contentHeight;
    }

    NSArray *sectionArray = self.columnHeights[indexPath.section];
    for (int row = 0; row < sectionArray.count; row ++) {
        CGFloat columnHeight = [sectionArray[row] doubleValue];
        
        if (miniColumnHeight > columnHeight) {
            miniColumnHeight = columnHeight;//冒泡法儿来拿到最小的那个数值
            miniColumn = row; //获取最小值对应的下标
        }
    }

//系统的布局只考虑从左往右的排序，而这里瀑布流使用的排序方式是从左往右的排序的同时也要考虑最小高度
    CGFloat x = self.edgeInsets.left + miniColumn * (itemWidth + self.interitemMargin);
    CGFloat y = miniColumnHeight;
    if (y != self.edgeInsets.top && !(indexPath.item >= 0 && indexPath.item < self.columnCount)) {
        y += self.lineMargin;
    }
    attrs.frame = CGRectMake(x, y, itemWidth, itemHeight);
    
    //更新最短那列的高度
    self.columnHeights[indexPath.section][miniColumn] = @(CGRectGetMaxY(attrs.frame));
    
    //拿到内容的最大高度
    CGFloat columnHeight = [self.columnHeights[indexPath.section][miniColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    if (indexPath.item == ([self.collectionView numberOfItemsInSection:indexPath.section] > 0 ? [self.collectionView numberOfItemsInSection:indexPath.section] - 1 : 0)) {
        
        NSMutableArray *lastArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < self.columnCount; i ++) {//默认每一列最大Y值
            [lastArray addObject:@(self.edgeInsets.top + self.contentHeight)];
        }
        if (indexPath.section + 1 < [self.collectionView numberOfSections]) {
            [self.columnHeights replaceObjectAtIndex:indexPath.section + 1 withObject:lastArray];
        }
    }
    return attrs;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

#pragma mark ************* private method *************
- (CGFloat)interitemMargin
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(waterfallMinimumInteritemSpacingWithLayout:)]) {
        return [self.delegate waterfallMinimumInteritemSpacingWithLayout:self];
    } else {
        return STDefaultInteritemMargin;
    }
}
- (CGFloat)lineMargin
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(waterfallMinimumLineSpacingWithLayout:)]) {
        return [self.delegate waterfallMinimumLineSpacingWithLayout:self];
    } else {
        return STDefaultLineMargin;
    }
}
/**
 当前视图的列数
 
 @return return value description
 */
- (NSInteger)columnCount
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(waterfallColumnWithLayout:)]) {
        return [self.delegate waterfallColumnWithLayout:self];
    } else {
        return STDefaultColumnCount;
    }
}
- (UIEdgeInsets)edgeInsets
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(waterfallInsetWithLayout:)]) {
        return [self.delegate waterfallInsetWithLayout:self];
    } else {
        return STDefaultEdgeInsets;
    }
}

#pragma mark ************* lazy load *************
- (NSMutableArray *)attrasArray
{
    if (!_attrasArray) {
        _attrasArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _attrasArray;
}
- (NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray arrayWithCapacity:0];
    }
    return _columnHeights;
}

@end
