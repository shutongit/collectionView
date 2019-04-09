//
//  WaterFallLayout.h
//  CustormCollectionView
//
//  Created by shutong on 2019/4/9.
//  Copyright © 2019 shutong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WaterFallLayout;

@protocol WaterFallLayoutDelegate <NSObject>

@required
/**
 根据宽度获取高度

 @param layout layout description
 @param indexPath indexPath description
 @param itemWidth itemWidth description
 @return return value description
 */
- (CGFloat)waterfallLayout:(WaterFallLayout *)layout indexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional
/**
 组偏移量

 @param layout layout description
 @return return value description
 */
- (UIEdgeInsets)waterfallInsetWithLayout:(WaterFallLayout *)layout;
/**
 最小行间隔

 @param layout layout description
 @return return value description
 */
- (CGFloat)waterfallMinimumLineSpacingWithLayout:(WaterFallLayout *)layout;
/**
 最小列间隔

 @param layout layout description
 @return return value description
 */
- (CGFloat)waterfallMinimumInteritemSpacingWithLayout:(WaterFallLayout *)layout;
/**
 列数

 @param layout layout description
 @return return value description
 */
- (NSInteger)waterfallColumnWithLayout:(WaterFallLayout *)layout;
//
@end

@interface WaterFallLayout : UICollectionViewLayout


@property (nonatomic, weak) id <WaterFallLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
