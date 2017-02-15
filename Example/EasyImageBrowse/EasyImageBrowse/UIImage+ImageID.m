//
//  UIImage+ImageID.m
//  EasyImageBrowse
//
//  Created by sy on 2017/2/15.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import "UIImage+ImageID.h"
#import <objc/runtime.h>

static char *imageIDKey = "imageIDKey";
@implementation UIImage (ImageID)

- (void)setImageID:(NSString *)imageID{
    objc_setAssociatedObject(self, imageIDKey, imageID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)imageID{
    return objc_getAssociatedObject(self, imageIDKey);
}
@end
