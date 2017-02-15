//
//  EZPhotoBrowseController.h
//  EasyImageBrowse
//
//  Created by sy on 2017/2/15.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FJPhotoSelectDelegate <NSObject>

- (void)FJPhotoSelectBackImg:(NSArray <UIImage *>*)photoModels;

@end
@interface EZPhotoBrowseController : UIViewController
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, weak) id<FJPhotoSelectDelegate> delegate;

- (instancetype)photoBrowseWithImageArr:(NSArray <UIImage *>*)photoModels;
- (void)reloadImageArr:(NSArray <UIImage *>*)photoModels;
@end
