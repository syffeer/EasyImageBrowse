//
//  EZPhotoBigBroeseController.h
//  EasyBrowseDome
//
//  Created by mofang2 on 17/2/16.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EZPhotoBigBroeseControllerDelegate <NSObject>
- (void)PhotoBroeseSelectBackImg:(NSArray <UIImage *>*)photoModels;
@end

@interface EZPhotoBigBroeseController : UIViewController
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, weak) id<EZPhotoBigBroeseControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger ScrollIndex;
+ (instancetype)photoBigBroeseWithImageArr:(NSArray <UIImage *>*)photoModels dateArr:(NSArray *)arr;

@end
