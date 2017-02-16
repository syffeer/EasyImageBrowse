//
//  ViewController.m
//  EasyBrowseDome
//
//  Created by mofang2 on 17/2/16.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import "ViewController.h"
#import "EZPhotoBrowseController.h"
@interface ViewController ()<FJPhotoSelectDelegate>
@property (nonatomic, strong) EZPhotoBrowseController *vc;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) UINavigationController *nav;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _nav = [[UINavigationController alloc]init];
    if (_arr == nil) {
            _vc = [EZPhotoBrowseController photoBrowseWithImageArr:@[]];
    }else{
        _vc = [EZPhotoBrowseController photoBrowseWithImageArr:self.arr];
    }

    _vc.delegate = self;
    _vc.maxCount = 9;
    [_nav pushViewController:_vc animated:YES];
    [self presentViewController:_nav animated:YES completion:nil];

}

- (void)FJPhotoSelectBackImg:(NSArray <UIImage *>*)photoModels{
    self.arr = photoModels;
}

@end
