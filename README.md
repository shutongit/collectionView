# collectionView
> collectionView长按删除、移动，自定义layout，瀑布流

首先我们要知道自定义layout需要做哪些操作，和使用哪些api
自定义这玩意吧 在我看来就是按照自己想要的布局来设置点，不然直接用系统的就好了哦
当然了系统该有的东西我们还是要有的

```
//每次布局都会调用
- (void)prepareLayout;
//布局完成后设置contentSize
- (CGSize)collectionViewContentSize;
//返回每个item的属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;
//返回所有item属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
```
![样品](https://github.com/shutongit/Images/blob/master/collectionView-custormlayout.gif)
