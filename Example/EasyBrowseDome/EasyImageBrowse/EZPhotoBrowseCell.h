//
//  EZPhotoBrowseCell.h
//  EasyBrowseDome
//
//  Created by mofang2 on 17/2/16.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EZPhotoBrowseController.h"
@protocol FJPhotoCellDelegate <NSObject>
- (void)FJPhotoCellDidClick:(UIImage *)image withNeedAdd:(BOOL) needAdd;
- (BOOL)arrIsfill;
@end

@interface EZPhotoBrowseCell : UICollectionViewCell

@property (nonatomic, weak) id<FJPhotoCellDelegate> delegate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL selectState;
@end
