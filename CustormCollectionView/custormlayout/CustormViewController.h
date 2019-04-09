//
//  CustormViewController.h
//  CustormCollectionView
//
//  Created by shutong on 2019/4/9.
//  Copyright © 2019 shutong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CellDirectionNone,
    CellDirectionLeft,
    CellDirectionRight,
    CellDirectionUp,
    CellDirectionDown,
} CellDirection;

@interface CustormViewController : UIViewController
/**
 移动的方向
 */
@property (nonatomic, assign) CellDirection direction;

@end

NS_ASSUME_NONNULL_END
