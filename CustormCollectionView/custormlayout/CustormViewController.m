//
//  CustormViewController.m
//  CustormCollectionView
//
//  Created by shutong on 2019/4/9.
//  Copyright © 2019 shutong. All rights reserved.
//

#import "CustormViewController.h"
#import "CollectionViewCell.h"
#import "CustormLayout.h"

@interface CustormViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/**
 基础视图
 */
@property (nonatomic, strong) UICollectionView * collectionView;
/**
 系统布局
 */
@property (nonatomic, strong) CustormLayout * layout;
/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

/**
 选中的当前下标
 */
@property (nonatomic, strong) NSIndexPath * currentIndexPath;

/**
 移动的目标视图
 */
@property (nonatomic, strong) UIView * moveView;

/**
 处理自定义layout不能实现长按翻页的问题
 */
@property (nonatomic, strong) CADisplayLink *edgeTimer;
@property (nonatomic, strong) NSTimer *scrollerTimer;

@end
//上下左右的间距
static CGFloat topGap = 10;
static CGFloat leftGap = 10;
static CGFloat bottomGap = 10;
static CGFloat rightGap = 10;
static CGFloat lineSpace = 10.f;
static CGFloat InteritemSpace = 10.f;


#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


@implementation CustormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
    [self addLongPress];
    [self loadData];
}
#pragma mark ************* touch event *************

/**
 长按
 
 @param gesture press description
 */
- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            //获取此次点击的坐标，根据坐标获取cell对应的indexPath
            CGPoint point = [gesture locationInView:_collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            
            //当没有点击到cell的时候不进行处理
            if (indexPath == nil) {
                return;
            }
            self.currentIndexPath = indexPath;
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            if (cell == nil) {
                [self.collectionView layoutIfNeeded];//如果 cell 不是 visible 的 或者 indexPath 超过有效范围，就返回 nil。 性能上会有所牺牲
                cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            }
            cell.hidden = YES;//把当前选中的cell隐藏掉，不然效果达不到，可以去掉对比一下效果
            //得到当前cell的映射(截图)
            self.moveView = [cell snapshotViewAfterScreenUpdates:NO];
            //给截图添加上边框，如果不添加的话，截图有一部分是没有边框的，具体原因也没有找到
            self.moveView.layer.borderWidth = 0.5;
            self.moveView.layer.borderColor = [UIColor grayColor].CGColor;
            [self.collectionView addSubview:self.moveView];
            //放大截图
            self.moveView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.moveView.center = cell.center;
            //启动定时器
            [self configureEdgTimer];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture locationInView:self.collectionView];
            //更新cell的位置
            self.moveView.center = point;
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (indexPath == nil) {
                return;
            }
            //移动的方法
            [self.collectionView moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];//系统的移动方法
            [self custormMoveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];//自己的数据源替换方法
            self.currentIndexPath = indexPath;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                self.moveView.center = cell.center;
            } completion:^(BOOL finished) {
                [self stopEdgeTimer];
                [self.moveView removeFromSuperview];
                cell.hidden = NO;
                self.moveView = nil;
                self.currentIndexPath = nil;
            }];
        }
            break;
            
        default:
        {
            [self stopEdgeTimer];
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.currentIndexPath];
            cell.hidden = NO;
        }
            break;
    }
}


#pragma mark ************* collectionView data *************
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.text = self.dataSource[indexPath.item];
    return cell;
}
#pragma mark ************* load data *************
/**
 替换数据源
 
 @param indexPath indexPath description
 @param newIndexPath newIndexPath description
 */
- (void)custormMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath
{
    id content = self.dataSource[indexPath.item];
    [self.dataSource removeObjectAtIndex:indexPath.item];
    [self.dataSource insertObject:content atIndex:newIndexPath.item];
}

/**
 加载初始化数据
 */
- (void)loadData
{
    [self.dataSource addObjectsFromArray:@[@"数据0",@"数据1",@"数据2",@"数据3",@"数据4",@"数据5",@"数据6",@"数据7",@"数据8",@"数据9",@"数据10",@"数据11",@"数据12",@"数据13",@"数据14",@"数据15",@"数据16",@"数据17",@"数据18",@"数据19",@"数据20",@"数据21",@"数据22",@"数据23",@"数据24",@"数据25",@"数据26",@"数据27",@"数据28",@"数据29",@"数据30"]];
    [self.collectionView reloadData];
}

#pragma mark ************* creat UI *************
- (void)createUI
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
 
}
#pragma mark ************* private method *************
/**
 添加长按手势
 */
- (void)addLongPress
{
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    press.minimumPressDuration = 0.3;
    [self.collectionView addGestureRecognizer:press];
}
//这里处理一下自定义layout 长按不能翻页的问题
/**
 判断移动方向
 */
- (void)judgeScrollDirection
{
    self.direction = CellDirectionNone;
    if (self.collectionView.bounds.size.height + self.collectionView.contentOffset.y - self.moveView.center.y < self.moveView.bounds.size.height / 2 && self.collectionView.bounds.size.height + self.collectionView.contentOffset.y < self.collectionView.contentSize.height) {
        self.direction = CellDirectionDown;
    }
    if (self.moveView.center.y - self.collectionView.contentOffset.y < self.moveView.bounds.size.height / 2 && self.collectionView.contentOffset.y > 0) {
        self.direction = CellDirectionUp;
    }
    if (self.collectionView.bounds.size.width + self.collectionView.contentOffset.x - self.moveView.center.x < self.moveView.bounds.size.width / 2 && self.collectionView.bounds.size.width + self.collectionView.contentOffset.x < self.collectionView.contentSize.width) {
        self.direction = CellDirectionRight;
    }
    
    if (self.moveView.center.x - self.collectionView.contentOffset.x < self.moveView.bounds.size.width / 2 && self.collectionView.contentOffset.x > 0) {
        self.direction = CellDirectionLeft;
    }
}
#pragma mark ************* 定时器相关 *************

/**
 配置定时器
 */
- (void)configureEdgTimer
{
    if (!_edgeTimer) {
        _edgeTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(edgeScroll)];
        [_edgeTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}
/**
 取消定时器
 */
- (void)stopEdgeTimer{
    if (_edgeTimer) {
        [_edgeTimer invalidate];
        _edgeTimer = nil;
    }
}
/**
 定时器d方法
 */
- (void)edgeScroll
{
    [self judgeScrollDirection];
    if (self.direction) {
        if (self.scrollerTimer != nil) {
            return;
        }
        self.scrollerTimer = [NSTimer timerWithTimeInterval:0 target:self selector:@selector(handScrollCollection) userInfo:nil repeats:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollerTimer fire];
        });
        
    }
}
/**
 处理collectionView的contentOffset
 */
- (void)handScrollCollection
{
    switch (self.direction) {
        case CellDirectionLeft:
        {
            if (self.collectionView.contentOffset.x <= 0) {
                break;
            }
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x - self.collectionView.bounds.size.width, self.collectionView.contentOffset.y) animated:YES];
            self.moveView.center = CGPointMake(self.moveView.center.x - self.collectionView.bounds.size.width, self.moveView.center.y);
        }
            break;
        case CellDirectionRight:
        {
            if (self.collectionView.contentOffset.x > (self.collectionView.contentSize.width - self.collectionView.bounds.size.width)) {
                break;
            }
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + self.collectionView.bounds.size.width, self.collectionView.contentOffset.y) animated:YES];
            self.moveView.center = CGPointMake(self.moveView.center.x + self.collectionView.bounds.size.width, self.moveView.center.y);
            
        }
            break;
            
        default:
            break;
    }
    _scrollerTimer = nil;
    [_scrollerTimer invalidate];
}
#pragma mark ************* lazy load *************
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        self.layout = [[CustormLayout alloc]init];
        self.layout.minimumLineSpacing = lineSpace;
        self.layout.minimumInteritemSpacing = InteritemSpace;
        self.layout.itemSize = CGSizeMake(floorf((kWidth - leftGap - rightGap - InteritemSpace * 2) / 3), (kWidth - leftGap - rightGap) / 3);
        self.layout.sectionInset = UIEdgeInsetsMake(topGap, leftGap, bottomGap, rightGap);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 44, kWidth, kHeight - [UIApplication sharedApplication].statusBarFrame.size.height - 44) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

@end
