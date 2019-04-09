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
    for (int i = 0; i < self.columnCount; i ++) {//默认每一列最大Y值
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    //获取item个数
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < itemCount; i ++) {
        //item的下标
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        //获取对应item的布局
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrasArray addObject:attrs];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrasArray;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat contentWidth = self.collectionView.frame.size.width - self.edgeInsets.left - self.edgeInsets.right;
    CGFloat itemWidth = (contentWidth - self.interitemMargin * (self.columnCount - 1)) / self.columnCount ;//计算item的宽度
    CGFloat itemHeight = [self.delegate waterfallLayout:self indexPath:indexPath itemWidth:itemWidth];//item的高度
    
    //找出最短的那一列
    NSInteger miniColumn = 0;
    CGFloat miniColumnHeight = [self.columnHeights[0] doubleValue];//默认是第一列
    for (NSInteger i = 1; i < self.columnHeights.count; i ++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (miniColumnHeight > columnHeight) {
            miniColumnHeight = columnHeight;
            miniColumn = i;
        }
    }
    //系统的布局只考虑从左往右的排序，而这里瀑布流使用的排序方式是从左往右的排序的同时也要考虑最小高度
    CGFloat x = self.edgeInsets.left + miniColumn * (itemWidth + self.interitemMargin);
    CGFloat y = miniColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.lineMargin;
    }
    attrs.frame = CGRectMake(x, y, itemWidth, itemHeight);
    
    //更新最短那列的高度
    self.columnHeights[miniColumn] = @(CGRectGetMaxY(attrs.frame));
    
    //拿到内容的最大高度
    CGFloat columnHeight = [self.columnHeights[miniColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
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
