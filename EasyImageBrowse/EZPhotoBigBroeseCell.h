//
//  EZPhotoBigBroeseCell.h
//  EasyBrowseDome
//
//  Created by mofang2 on 17/2/16.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EZPhotoBigBroeseCellDelegate <NSObject>
- (void)EZPhotoCellDidClick:(UIImage *)image withNeedAdd:(BOOL) needAdd;
- (BOOL)arrIsfill;
@end

@interface EZPhotoBigBroeseCell : UICollectionViewCell
@property (nonatomic, weak) id<EZPhotoBigBroeseCellDelegate> delegate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL selectState;
- (void)scrollScrollView:(CGPoint)p;
@end
