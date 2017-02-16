//
//  EZPhotoBigBroeseController.m
//  EasyBrowseDome
//
//  Created by mofang2 on 17/2/16.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//
#define  EZ_WIDTH [UIScreen mainScreen].bounds.size.width
#define  EZ_HEIGHT [UIScreen mainScreen].bounds.size.height
#import "EZPhotoBigBroeseController.h"
#import "EZPhotoBigBroeseCell.h"
#import "EYPhotoManger.h"
#import "UIImage+ImageID.h"
static NSString *cellIdf = @"BrowseCellIdef";



@interface EZPhotoBigBroeseController ()<UICollectionViewDelegate,UICollectionViewDataSource,EZPhotoBigBroeseCellDelegate>
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation EZPhotoBigBroeseController{
    BOOL _isFill;
}

+ (instancetype)photoBigBroeseWithImageArr:(NSArray <UIImage *>*)photoModels dateArr:(NSArray *)arr{
    EZPhotoBigBroeseController *vc = [[self alloc]init];
    vc.imageArr = [NSMutableArray arrayWithArray:photoModels];
    vc.dataArr = arr;
    return vc;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self _configCollect];
    [self _nav];
}

- (void)_configCollect{
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64,EZ_WIDTH , EZ_HEIGHT - 64) collectionViewLayout:self.flowLayout];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.pagingEnabled = YES;
    [_collectView registerClass:[EZPhotoBigBroeseCell class] forCellWithReuseIdentifier:cellIdf];
    _collectView.contentOffset = CGPointMake(self.ScrollIndex * EZ_WIDTH, 0);
    [self.view addSubview:_collectView];
}

- (void)_setGesture{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exitTap)];
    [self.view addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollTap:)];
    tap2.numberOfTapsRequired = 2;
    [tap1 requireGestureRecognizerToFail: tap2];
    [self.view addGestureRecognizer:tap2];
}


- (void)_nav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)scrollTap:(UITapGestureRecognizer *)tap{
    EZPhotoBigBroeseCell *Cell = [[self.collectView visibleCells] firstObject];
    CGPoint point = [tap locationInView:self.view];
    [Cell scrollScrollView:point];
}

#pragma mark - event method
- (void)back{
    if ([self.delegate respondsToSelector:@selector(PhotoBroeseSelectBackImg:)]) {
        [self.delegate PhotoBroeseSelectBackImg:self.imageArr];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)exitTap{
    
}

#pragma mark - EZPhotoBigBroeseCellDelegate
- (void)EZPhotoCellDidClick:(UIImage *)image withNeedAdd:(BOOL) needAdd{
    if (needAdd) {
        [self.imageArr addObject:image];
    }else{
        UIImage *removeImage;
        for (UIImage *imageItems in self.imageArr) {
            if ([imageItems.imageID isEqualToString:image.imageID]) {
                removeImage = imageItems;
                break;
            }
        }
        [self.imageArr removeObject:removeImage];
    }
    if (self.imageArr.count >= self.maxCount) {
        _isFill = YES;
        
    }else{
        _isFill = NO;
    }
}

- (BOOL)arrIsfill{
    return _isFill;
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EZPhotoBigBroeseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdf forIndexPath:indexPath];
    EYPhotoModel *model = _dataArr[indexPath.row];
    [[EYPhotoManger share]getImgQUse:model.asset akeSize:CGSizeMake(200, 200) makeResizeMode:PHImageRequestOptionsResizeModeNone completion:^(UIImage *image) {
        cell.image = image;
        image.imageID = model.imageName;
    }];
    BOOL btnState = NO;
    for (UIImage *image in self.imageArr) {
        if ([model.imageName isEqualToString:image.imageID]) {
            btnState = YES;
            break;
        }
    }
    cell.delegate = self;
    cell.selectState = btnState;
    return cell;
}

#pragma mark - Setter && Getter
- (UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = self.view.bounds.size;
    }
    return _flowLayout;
}
@end
