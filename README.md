# collectionView
![样品](https://github.com/shutongit/Images/blob/master/collectionView-custormlayout.gif)
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

> 1、自定义横向布局

这里我们说下自定义横向布局`` CustormLayout ``的思路
首先我们要考虑的是如果怎么样才能让原本按照列的顺序排列的数据 按照我们自定义的行的顺序排列数据呢？布局的字面意思就是`frame`，既然是`frame`那就涉及到了`x,y,width,height`。我们这里`自定义layout`是知道了`width`和`height`的，那也就是说我们只需要处理`x，y`了。
那我们这里就用到了`+ (instancetype)indexPathForItem:(NSInteger)item inSection:(NSInteger)section NS_AVAILABLE_IOS(6_0)`这个方法了

```
for (int currentSection = 0; currentSection < self.collectionView.numberOfSections; currentSection ++)
{
for (NSInteger itemRow = 0; itemRow < count; itemRow++) { //获取每组的item
NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemRow inSection:currentSection];
//重写布局方法 用以自定义布局
[tmpAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
}
}
```
当然到了这里基本上基本的需求就算是做完了。当看到我这句话的时候你们应该就想到了后面应该还有个但是...，但是这个东西只是处理了一组数据的情况下，那么如果是多组数据的情况我们又要怎么处理呢？

这里我的处理方法是：记录组和组之间分割的那么一个刹那，就是如果该布局第二组的数据了，那么我就需要先拿到第一组总共有几页数据，然后在布局第一组的时候x轴在第一组所有的页码后面开始布局
```
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

```
> 具体实现请参考 `custormlayout`文件文件夹内容


















