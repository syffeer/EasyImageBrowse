//
//  EZPhotoBrowseController.m
//  EasyImageBrowse
//
//  Created by sy on 2017/2/15.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//
#define  EZ_WIDTH [UIScreen mainScreen].bounds.size.width
#define  EZ_HEIGHT [UIScreen mainScreen].bounds.size.height
#define HangCount 3
#import "EZPhotoBrowseController.h"
#import "EZPhotoBigBroeseController.h"
#import "EYPhotoManger.h"
#import "EZPhotoBrowseCell.h"
#import "UIImage+ImageID.h"
#import "EZAblumeView.h"
@interface EZPhotoBrowseController ()<UICollectionViewDelegate,UICollectionViewDataSource,EZPhotoCellDelegate,EZPhotoBigBroeseControllerDelegate,EZAblumeViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray <EYPhotoListModel *>* listModel;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) EZAblumeView *albumView;
@end

@implementation EZPhotoBrowseController{
    UIButton *_titleBtn;
    UIButton *_navSurebtn;
    NSInteger _listIndex;
    BOOL _camerastatus;
    BOOL _isFill;
    UIImagePickerController *_pick;
}

+ (instancetype)photoBrowseWithImageArr:(NSArray <UIImage *>*)photoModels{
    EZPhotoBrowseController *vc = [[self alloc]init];
    vc.imageArr = [NSMutableArray arrayWithArray:photoModels];
    vc.view.backgroundColor = [UIColor whiteColor];
    return vc;
}

//优先取出模型
- (instancetype)init{
    if (self = [super init]) {
        _listIndex = 0;
        [self Authorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                _listModel = [[EYPhotoManger share]getAllPhotoList];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [_listModel enumerateObjectsUsingBlock:^(EYPhotoListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     obj.AssetArry = [[EYPhotoManger share]getModelListAsset:obj];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (obj == [_listModel firstObject]) {
                                [self.collectView reloadData];
                            }
                        });
                    }];
                });
            }
        }];
        [self CameraAuth:^(BOOL status) {
            _camerastatus = status;
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _collect];
    [self setNav];
    [self changeNextBtn];
}

- (void)_collect{
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, EZ_WIDTH, EZ_HEIGHT) collectionViewLayout:self.flowLayout];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    _collectView.alwaysBounceVertical = YES;
    _collectView.backgroundColor = [UIColor clearColor];
    [_collectView registerClass:[EZPhotoBrowseCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
   [_collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"photo"];
    [self.view addSubview:_collectView];
}

- (void)setNav{
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backItem)];
    
    UIButton *leftButton = [[UIButton alloc]init];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftButton setTitle:@"完成(0/9)" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"main_noshandowbtn_normal"] forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"main_noshandowbtn_invalid"] forState:UIControlStateDisabled];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"main_noshandowbtn_click"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(nextItem) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 80, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    _navSurebtn = leftButton;
    _navSurebtn.enabled = NO;
    
    _titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 64)];
    _titleBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [_titleBtn setTitle:@"相机胶卷" forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:@"circles_release_albumchange_normal"] forState:UIControlStateNormal];
    [_titleBtn setImage:[UIImage imageNamed:@"circles_release_albumchange_click"] forState:UIControlStateSelected];
    [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    self.navigationItem.titleView = _titleBtn;
    _titleBtn.imageView.clipsToBounds = YES;
    [_titleBtn addTarget:self action:@selector(albSHow:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - event method
- (void)albSHow:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.view addSubview:self.albumView];
        [self.albumView show];
    }else{
        [self.albumView hiding:^{
            [self.albumView removeFromSuperview];
        }];
    }
    
}

- (void)nextItem{
    if (_titleBtn.selected) {
        [self.albumView hiding:^{
            [self.albumView removeFromSuperview];
        }];
    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    if ([self.delegate respondsToSelector:@selector(EZPhotoSelectBackImg:)]) {
        [self.delegate EZPhotoSelectBackImg:self.imageArr];
    }
}


- (void)backItem{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
//改变nextBtn状态
- (void)changeNextBtn{
    NSInteger photoNum = self.imageArr.count;
    NSString  *text = [NSString stringWithFormat:@"完成(%zd/9)",photoNum];
    if (photoNum == 0) {
        _navSurebtn.enabled = NO;
    }else{
        _navSurebtn.enabled = YES;
    }
    [_navSurebtn setTitle:text forState:UIControlStateNormal];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.listModel == nil||self.listModel.count <=0) {
        return 0;
    }
    EYPhotoListModel *model = self.listModel[_listIndex];
    return model.AssetArry.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EZPhotoBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"photo" forIndexPath:indexPath];
        cell.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"detail_Commenticon_photo_normal"].CGImage);
        return  cell;
    }else{
        EYPhotoListModel *listmodel = self.listModel[_listIndex];
        EYPhotoModel *model = listmodel.AssetArry[indexPath.row - 1];
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
        cell.selectState = btnState;
        cell.delegate = self;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self openCamera];
        return;
    }
    
    EYPhotoListModel *listmodel = self.listModel[_listIndex];
    EZPhotoBigBroeseController *vc = [EZPhotoBigBroeseController photoBigBroeseWithImageArr:self.imageArr dateArr:listmodel.AssetArry];
    vc.maxCount = self.maxCount;
    vc.ScrollIndex = indexPath.row - 1;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];

}


#pragma mark - FJPhotoCellDelegate
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
    [self changeNextBtn];
}

- (BOOL)arrIsfill{
    return _isFill;
}


#pragma mark - EZPhotoBigBroeseControllerDelegate
- (void)PhotoBroeseSelectBackImg:(NSArray <UIImage *>*)photoModels{
    self.imageArr = [NSMutableArray arrayWithArray:photoModels];
    [self.collectView reloadData];
      [self changeNextBtn];
    if (self.imageArr.count >= self.maxCount) {
        _isFill = YES;
        
    }else{
        _isFill = NO;
    }
}

//选择相册
#pragma mark - FJAlbumViewDelegate
- (void)albumViewDidCliK:(NSInteger)index{
    _listIndex = index;
    _titleBtn.selected = NO;
    EYPhotoListModel *model = self.listModel[_listIndex];
    [_titleBtn setTitle:model.title forState:UIControlStateNormal];
    [self.collectView reloadData];
    [self.albumView hiding:^{
        [self.albumView removeFromSuperview];
    }];
    
}

//打开相机
- (void)openCamera{
    if (_isFill) {
        return;
    }
    if (!_camerastatus) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告"
                                                                       message:@"未检测到摄像头"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    _pick = [[UIImagePickerController alloc]init];
    _pick.sourceType = UIImagePickerControllerSourceTypeCamera;
    _pick.delegate = self;
    [self presentViewController:_pick animated:YES completion:nil];
    
}

//照相
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSDate *date = [NSDate date];
    NSDateFormatter *fomatter = [[NSDateFormatter alloc]init];
    fomatter.dateFormat = @"HH-mm-ss";
    NSString *key = [fomatter stringFromDate:date];
    UIImage *image =  info[@"UIImagePickerControllerOriginalImage"];
    image.imageID = key;
    [self.imageArr addObject:image];
    [_pick dismissViewControllerAnimated:YES completion:^{
    }];
    [self changeNextBtn];
}


#pragma mark - setter && getter
- (UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat cellHW = (EZ_WIDTH - 6*HangCount +6)/HangCount-1;
        _flowLayout.itemSize = CGSizeMake(cellHW, cellHW);
        _flowLayout.minimumLineSpacing = 6;
        _flowLayout.minimumInteritemSpacing = 6;
    }
    return _flowLayout;
}

- (EZAblumeView *)albumView{
    if (_albumView == nil) {
        _albumView = [[EZAblumeView alloc]initWithFrame:CGRectMake(0, 0, EZ_WIDTH, EZ_HEIGHT)];
        _albumView.arrModels = self.listModel;
        _albumView.delegate = self;
        _albumView.backgroundColor = [UIColor clearColor];
    }
    return _albumView;
}

#pragma mark - 权限申请
- (void)authosPhoto:(void(^)(PHAuthorizationStatus))finsh{
    //获取相机权限
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined){ //用户还没有做出选择
        [self Authorization:^(PHAuthorizationStatus status) {
            finsh(status);
        }];
    }else{
        finsh(status);
    }
}

//申请相机权限
- (void)CameraAuth:(void(^)(BOOL))finsh{
    AVAuthorizationStatus authstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authstatus == AVAuthorizationStatusAuthorized) {//可以使用
        finsh(YES);
    }else if (authstatus == AVAuthorizationStatusNotDetermined){
        [self AuthorizationCamera:^(BOOL state) {
            finsh(state);
        }];
    }else{
        finsh(NO);
    }
}
//申请照片访问权限
- (void)Authorization:(void(^)(PHAuthorizationStatus))finsh{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        finsh(status);
    }];
    
}

//申请照相权限
- (void)AuthorizationCamera:(void(^)(BOOL))finsh{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        finsh(granted);
    }];
}

@end
