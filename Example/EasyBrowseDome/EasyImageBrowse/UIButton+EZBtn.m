//
//  UIButton+EZBtn.m
//  EasyBrowseDome
//
//  Created by mofang2 on 17/5/22.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import "UIButton+EZBtn.h"
static NSString *rightStr;
@implementation UIButton (EZBtn)
- (void)btnImgAtRight{
    rightStr = @"right";
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if ([rightStr isEqualToString:@"right"]) {
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width + 6, 0, -self.titleLabel.bounds.size.width)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width, 0, self.imageView.bounds.size.width)];
    }
}

@end
