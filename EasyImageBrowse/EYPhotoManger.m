//
//  EYPhotoManger.m
//  EasyImageBrowse
//
//  Created by sy on 2017/2/15.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import "EYPhotoManger.h"
#import "UIImage+ImageID.h"
@implementation EYPhotoModel

@end


@implementation EYPhotoListModel

@end

@implementation EYPhotoManger
+ (instancetype)share{
    static dispatch_once_t onceToken;
    static EYPhotoManger *instance;
    dispatch_once(&onceToken, ^{
        instance = [[EYPhotoManger alloc]init];
    });
    return instance;
}

#pragma mark - pubulic method
//遍历相册列表
- (NSArray <EYPhotoListModel *>*)getAllPhotoList{
    NSMutableArray <EYPhotoListModel *>* photoList = [NSMutableArray array];
    //列出所有相册智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!([collection.localizedTitle isEqualToString:@"Recently Deleted"] || [collection.localizedTitle isEqualToString:@"Videos"])){
            PHFetchResult *res = [self fetchAssetsInAssetCollection:collection ascending:NO];
            if (res.count > 0) {
                EYPhotoListModel *list = [[EYPhotoListModel alloc]init];
                list.title = [self transformAblumTitle:collection.localizedTitle];
                list.photoNum = res.count;
                list.firstAsset = res.firstObject;
                list.assetCollection = collection;
                if ([list.title isEqualToString:@"相机胶卷"]) {
                    [photoList insertObject:list atIndex:0];
                }else{
                    [photoList addObject:list];
                }
                
            }
        }
    }];
    
    PHFetchResult *userAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    [userAlbum enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL * _Nonnull stop) {
        PHFetchResult *res = [self fetchAssetsInAssetCollection:collection ascending:NO];
        if (res.count > 0) {
            EYPhotoListModel *list = [[EYPhotoListModel alloc]init];
            list.title = [self transformAblumTitle:collection.localizedTitle];
            list.photoNum = res.count;
            list.firstAsset = res.firstObject;
            list.assetCollection = collection;
            if ([list.title isEqualToString:@"相机胶卷"]) {
                [photoList insertObject:list atIndex:0];
            }else{
                [photoList addObject:list];
            }
        }
    }];
    return photoList.copy;
}

//通过PHCollect取到PHassect
- (NSArray<EYPhotoModel *> *)getAssetArryUse:(PHAssetCollection *)collect ascending:(BOOL)ascending{
    NSMutableArray<EYPhotoModel *> *arr = [NSMutableArray array];
    PHFetchResult *res = [self fetchAssetsInAssetCollection:collect ascending:ascending];
    [res enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EYPhotoModel *model = [[EYPhotoModel alloc]init];
        model.asset = obj;
        model.imageName = [obj valueForKeyPath:@"filename"];
        [arr addObject:model];
    }];
    return arr;
}

//通过PHAssect取到图片
- (void)getImgUse:(PHAsset *)asset akeSize:(CGSize)size makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *))completion{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    options.resizeMode = resizeMode;//控制照片尺寸
    //option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;//控制照片质量
    //option.synchronous = YES;
    options.networkAccessAllowed = YES;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        completion(image);
    }];
}


- (void)getImgQUse:(PHAsset *)asset akeSize:(CGSize)size makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *))completion{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
    /**
     resizeMode：对请求的图像怎样缩放。有三种选择：None，不缩放；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
     deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
     这个属性只有在 synchronous 为 true 时有效。
     */
    options.resizeMode = resizeMode;//控制照片尺寸
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;//控制照片质量
    //option.synchronous = YES;
    options.networkAccessAllowed = YES;
    //param：targetSize 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (downloadFinined) {
            completion(image);
        }
        
    }];
}

- (NSArray<EYPhotoModel *> *)getModelListAsset:(EYPhotoListModel *)listModel{
    return [self getAssetArryUse:listModel.assetCollection ascending:NO];
}



#pragma mark - private mehod
//通过列表PHFetchOptions: 获取资源时的参数
- (PHFetchResult *)fetchAssetsInAssetCollection:(PHAssetCollection *)collect ascending:(BOOL)asceding{
    PHFetchOptions *options = [[PHFetchOptions alloc]init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:asceding]];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collect options:options];
    return result;
}

- (NSString *)transformAblumTitle:(NSString *)title
{
    if ([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if ([title isEqualToString:@"Recently Added"]) {
        return @"最近添加";
    } else if ([title isEqualToString:@"Favorites"]) {
        return @"最爱";
    } else if ([title isEqualToString:@"Recently Deleted"]) {
        return @"最近删除";
    } else if ([title isEqualToString:@"Videos"]) {
        return @"视频";
    } else if ([title isEqualToString:@"All Photos"]) {
        return @"所有照片";
    } else if ([title isEqualToString:@"Selfies"]) {
        return @"自拍";
    } else if ([title isEqualToString:@"Screenshots"]) {
        return @"屏幕快照";
    } else if ([title isEqualToString:@"Camera Roll"]) {
        return @"相机胶卷";
    }else if ([title isEqualToString:@"My Photo Stream"]){
        return @"我的照片流";
    }
    return title;
}
@end
