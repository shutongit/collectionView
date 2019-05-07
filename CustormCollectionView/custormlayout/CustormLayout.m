//
//  CustormLayout.m
//  CustormCollectionView
//
//  Created by shutong on 2019/4/9.
//  Copyright © 2019 shutong. All rights reserved.
//

#import "CustormLayout.h"

@interface CustormLayout ()
/**
 所有的布局
 */
@property (nonatomic, strong) NSMutableArray * attributArray;
/**
 列
 */
@property (nonatomic, assign) NSInteger line;
/**
 行
 */
@property (nonatomic, assign) NSInteger row;

/**
 列间隔
 */
@property (nonatomic, assign) CGFloat itemSpacing;
/**
 行间隔
 */
@property (nonatomic, assign) CGFloat lineSapcing;
/**
 计算页面
 */
@property (nonatomic, assign) NSInteger pageNumber;
/**
 下一组的页面从哪个页面开始计算
 */
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation CustormLayout

- (void)prepareLayout
{
    [super prepareLayout];
    //做什么都要有个初始化设置的
    [self.attributArray removeAllObjects];
    CGFloat itemWidth = self.itemSize.width;//item的宽
    CGFloat itemHeight = self.itemSize.height;//item的高
    CGFloat width = self.collectionView.frame.size.width;//collectionView的宽
    CGFloat height = self.collectionView.frame.size.height;//collectionView的高
    
    CGFloat contentWidth = width - self.sectionInset.left - self.sectionInset.right;//内容实际占有的宽
    CGFloat contentHeight = height - self.sectionInset.top - self.sectionInset.bottom;//内容实际占有的高
    
    //因为系统的item最小间隔就是通过item的大小和实际大小来计算的，所以这里处理一下item的间隔问题
    if (contentWidth >= 2 * itemWidth + self.minimumInteritemSpacing) {//如果collectionView大于等于两列
        //    在知道有n列的情况下算式是：(itemwidth + 间隔) * n - 间隔 = contentWidht 可以得出 n = contentWidth + 间隔 / (itemwidth + 间隔)
        NSInteger m = (contentWidth + self.minimumInteritemSpacing) / (self.minimumInteritemSpacing + itemWidth);
        _line = m; //这个算出来的是多少列
        
        //    这里我们要计算出还有多少尺寸被预留出来
        double offset = ((contentWidth + self.minimumInteritemSpacing) - _line * (itemWidth + self.minimumInteritemSpacing)) / _line;
        self.itemSpacing = self.minimumInteritemSpacing + offset;
    } else {
        self.itemSpacing = 0.f;
    }
    
    if (contentHeight >= 2 * itemHeight + self.minimumLineSpacing) {//如果collectionView大于等于两列
        //    在知道有n列的情况下算式是：(itemwidth + 间隔) * n - 间隔 = contentWidht 可以得出 n = contentWidth + 间隔 / (itemwidth + 间隔)
        NSInteger m = (contentHeight + self.minimumLineSpacing) / (self.minimumLineSpacing + itemHeight);
        _row = m; //这个算出来的是多少列
        
        //    这里我们要计算出还有多少尺寸被预留出来
        double offset = ((contentHeight + self.minimumLineSpacing) - _row * (itemHeight + self.minimumLineSpacing)) / _row;
        self.lineSapcing = self.minimumLineSpacing + offset;
    } else {
        self.lineSapcing = 0.f;
    }

    self.pageNumber = 0;
    self.currentPage = 0;
    int currentP = 0;//默认第1组
    NSMutableArray *tmpAttributes = [NSMutableArray new];
    for (int currentSection = 0; currentSection < self.collectionView.numberOfSections; currentSection ++)
    { //获取所有的组
        NSInteger count = [self.collectionView numberOfItemsInSection:currentSection];
        //计算总页码
        int itemNumber = 0;//总元素个数
        itemNumber = itemNumber + (int)[self.collectionView numberOfItemsInSection:currentSection];
        int pageCount = 0; //当前组 有多少页数据
        //计算有多少页面 (self.row * self.line)这个是一页的item个数
        pageCount = (itemNumber - 1) / (self.row * self.line) + 1;
        
        if (currentSection > currentP) { //当进入下一组的时候需要更换当前页面的数据源，用来计算item从第几页开始布局
            self.currentPage = self.pageNumber; //先获取到
            currentP = currentSection; //更新组
        }
        self.pageNumber += pageCount; //获取总页码，用以计算collectionView的contentSize
        
        
        for (NSInteger itemRow = 0; itemRow < count; itemRow++) { //获取每组的item
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemRow inSection:currentSection];
            //重写布局方法 用以自定义布局
            [tmpAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    self.attributArray = tmpAttributes;
}

/**
 所有item的布局

 @param rect rect description
 @return return value description
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attributArray;
}

//返回每个item的属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGRect frame;
    frame.size = self.itemSize; //尺寸大小
    //一个页面有多少元素
    NSInteger number = self.line * self.row;
    
    NSInteger p = 0; //页码
    NSInteger m = 0; //第几行
    NSInteger n = 0; //第几列
    if (indexPath.item >= number) { //如果不是当前页面
        p = indexPath.item / number; //计算页码
        m = (indexPath.item % number) / self.line;
    } else {
        m = indexPath.item / self.line;
    }
    n = indexPath.item % self.line;
    frame.origin = CGPointMake(n * (self.itemSize.width + self.itemSpacing) + self.sectionInset.left + (self.currentPage + p) * self.collectionView.frame.size.width,
                               m * self.itemSize.height + m * self.lineSapcing + self.sectionInset.top);
    attribute.frame = frame;
    return attribute;
}

//布局完成后设置contentSize
- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.bounds.size.width * self.pageNumber, self.collectionView.bounds.size.height);
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}
#pragma mark ************* lazy load *************
- (NSMutableArray *)attributArray
{
    if (!_attributArray) {
        _attributArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _attributArray;
}

@end
