//
//  WaterFallViewController.m
//  CustormCollectionView
//
//  Created by shutong on 2019/4/9.
//  Copyright © 2019 shutong. All rights reserved.
//

#import "WaterFallViewController.h"
#import "CollectionViewCell.h"
#import "WaterFallLayout.h"
#import "CollectionHeadReusableView.h"

@interface WaterFallViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,WaterFallLayoutDelegate>
/**
 基础视图
 */
@property (nonatomic, strong) UICollectionView * collectionView;
/**
 系统布局
 */
@property (nonatomic, strong) WaterFallLayout * layout;
/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@implementation WaterFallViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
    
    [self loadData];
}

#pragma mark ************* collectionView data *************
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.text = [NSString stringWithFormat:@"第%d组%@",indexPath.section,self.dataSource[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 50);
}
- (CGSize)waterfallLayout:(WaterFallLayout *)layout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.view.frame.size.width, 50);;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeadReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionHeadReusableView" forIndexPath:indexPath];
        
        return headView;
    }
    return nil;
}
#pragma mark ************* WaterFallLayoutDelegate *************
- (CGFloat)waterfallLayout:(WaterFallLayout *)layout indexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    
    int y = 5 + arc4random() % 10;
    
    return itemWidth * y / 10;
}

/**
 加载初始化数据
 */
- (void)loadData
{
    [self.dataSource addObjectsFromArray:@[@"数据0",@"数据1",@"数据2",@"数据3",@"数据4",@"数据5",@"数据6",@"数据7",@"数据8",@"数据9",@"数据10",@"数据11",@"数据12",@"数据13",@"数据14",@"数据15",@"数据16",@"数据17",@"数据18",@"数据19",@"数据20",@"数据21",@"数据22",@"数据23",@"数据24",@"数据25",@"数据26",@"数据27",@"数据28",@"数据29",@"数据30",@"数据0",@"数据1",@"数据2",@"数据3",@"数据4",@"数据5",@"数据6",@"数据7",@"数据8",@"数据9",@"数据10",@"数据11",@"数据12",@"数据13",@"数据14",@"数据15",@"数据16",@"数据17",@"数据18",@"数据19",@"数据20",@"数据21",@"数据22",@"数据23",@"数据24",@"数据25",@"数据26",@"数据27",@"数据28",@"数据29",@"数据30"]];
    [self.collectionView reloadData];
}

#pragma mark ************* creat UI *************
- (void)createUI
{
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionHeadReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeadReusableView"];
    
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
        self.layout = [[WaterFallLayout alloc]init];
        self.layout.delegate = self;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 44, kWidth, kHeight - [UIApplication sharedApplication].statusBarFrame.size.height - 44) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

@end
