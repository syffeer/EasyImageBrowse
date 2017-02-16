//
//  EZAblumeView.h
//  EasyBrowseDome
//
//  Created by mofang2 on 17/2/16.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EZAblumeViewDelegate <NSObject>
- (void)albumViewDidCliK:(NSInteger)index;
@end

@interface EZAblumeView : UIView
@property (nonatomic, strong) NSArray *arrModels;
@property (nonatomic, weak) id<EZAblumeViewDelegate> delegate;

- (void)show;
- (void)hiding:(void(^)())cartoonFinish;

@end
