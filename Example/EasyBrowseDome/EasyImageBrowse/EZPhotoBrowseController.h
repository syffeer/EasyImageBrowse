//
//  EZPhotoBrowseController.h
//  EasyImageBrowse
//
//  Created by sy on 2017/2/15.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EZPhotoSelectDelegate <NSObject>

- (void)EZPhotoSelectBackImg:(NSArray <UIImage *>*)photoModels;

@end
@interface EZPhotoBrowseController : UIViewController
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, weak) id<EZPhotoSelectDelegate> delegate;
+ (instancetype)photoBrowseWithImageArr:(NSArray <UIImage *>*)photoModels;
@end
