//
//  ViewController.m
//  CustormCollectionView
//
//  Created by shutong on 2019/4/9.
//  Copyright © 2019 shutong. All rights reserved.
//

#import "ViewController.h"
#import "SystemViewController.h"
#import "CustormViewController.h"
#import "WaterFallViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self loadData];
}

#pragma mark ************* tableView data *************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}


#pragma mark ************* tableView delegate *************
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        SystemViewController *system = [[SystemViewController alloc]init];
        [self.navigationController pushViewController:system animated:YES];
    } else if (indexPath.row == 1)
    {
        CustormViewController *custorm = [[CustormViewController alloc]init];
        [self.navigationController pushViewController:custorm animated:YES];
    } else {
        WaterFallViewController *water = [[WaterFallViewController alloc]init];
        [self.navigationController pushViewController:water animated:YES];
    }
}
#pragma mark ************* load data *************
- (void)loadData
{
    [self.dataSource addObjectsFromArray:@[@"系统横纵向",@"自定义横向",@"瀑布流"]];
    [self.tableView reloadData];
}

#pragma mark ************* create UI *************
- (void)creatUI
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark ************* lazy load *************
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
@end
