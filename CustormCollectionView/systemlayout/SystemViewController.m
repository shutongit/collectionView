//
//  SystemViewController.m
//  CustormCollectionView
//
//  Created by shutong on 2019/4/9.
//  Copyright © 2019 shutong. All rights reserved.
//

#import "SystemViewController.h"
#import "CollectionViewCell.h"

@interface SystemViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
/**
 基础视图
 */
@property (nonatomic, strong) UICollectionView * collectionView;
/**
 系统布局
 */
@property (nonatomic, strong) UICollectionViewFlowLayout * layout;
/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

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


@implementation SystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
    [self addLongPress];
    [self loadData];
}
#pragma mark ************* touch event *************
/**
 切换横竖屏滑动
 */
- (void)cutDirection
{
    if (self.layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    } else {
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    [self.collectionView reloadData];
}
/**
 长按

 @param gesture press description
 */
- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    //获取此次点击的坐标，根据坐标获取cell对应的indexPath
    CGPoint point = [gesture locationInView:_collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            //当没有点击到cell的时候不进行处理
            if (!indexPath) {
                break;
            }
            //开始移动
            [_collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //移动过程中更新位置坐标
            [_collectionView updateInteractiveMovementTargetPosition:point];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            //停止移动调用此方法
            [_collectionView endInteractiveMovement];
        }
            break;
            
        default:
        {
            //取消移动
            [_collectionView cancelInteractiveMovement];
        }
            break;
    }
}
#pragma mark ************* collectionView data *************
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
#pragma mark ************* collectionView delegate *************
//在开始移动时会调用此代理方法，
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
//    根据indexpath判断单元格是否可以移动，如果都可以移动，直接就返回YES ,不能移动的返回NO
    return YES;
}
//在移动结束的时候调用此代理方法
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    /**
     *sourceIndexPath 原始数据 indexpath
     * destinationIndexPath 移动到目标数据的 indexPath
     */
    id content = self.dataSource[sourceIndexPath.item];
    [self.dataSource removeObjectAtIndex:sourceIndexPath.item];
    [self.dataSource insertObject:content atIndex:destinationIndexPath.item];
    
}
#pragma mark ************* load data *************
- (void)loadData
{
    [self.dataSource addObjectsFromArray:@[@"数据0",@"数据1",@"数据2",@"数据3",@"数据4",@"数据5",@"数据6",@"数据7",@"数据8",@"数据9",@"数据10",@"数据11",@"数据12",@"数据13",@"数据14",@"数据15",@"数据16",@"数据17",@"数据18",@"数据19",@"数据20",@"数据21",@"数据22",@"数据23",@"数据24",@"数据25",@"数据26",@"数据27",@"数据28",@"数据29",@"数据30",@"数据0",@"数据1",@"数据2",@"数据3",@"数据4",@"数据5",@"数据6",@"数据7",@"数据8",@"数据9",@"数据10",@"数据11",@"数据12",@"数据13",@"数据14",@"数据15",@"数据16",@"数据17",@"数据18",@"数据19",@"数据20",@"数据21",@"数据22",@"数据23",@"数据24",@"数据25",@"数据26",@"数据27",@"数据28",@"数据29",@"数据30"]];
    [self.collectionView reloadData];
}

#pragma mark ************* creat UI *************
- (void)createUI
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"切换" style:UIBarButtonItemStylePlain target:self action:@selector(cutDirection)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark ************* private method *************
- (void)addLongPress
{
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    press.minimumPressDuration = 0.3;
    [self.collectionView addGestureRecognizer:press];
    
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
        self.layout = [[UICollectionViewFlowLayout alloc]init];
        self.layout.minimumLineSpacing = lineSpace;
        self.layout.minimumInteritemSpacing = InteritemSpace;
        self.layout.itemSize = CGSizeMake(floorf((kWidth - leftGap - rightGap - InteritemSpace * 2) / 3), (kWidth - leftGap - rightGap) / 3);
        self.layout.sectionInset = UIEdgeInsetsMake(topGap, leftGap, bottomGap, rightGap);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 44, kWidth, kHeight - [UIApplication sharedApplication].statusBarFrame.size.height - 44) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

@end
