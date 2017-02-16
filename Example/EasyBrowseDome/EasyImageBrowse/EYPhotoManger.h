//
//  EYPhotoManger.h
//  EasyImageBrowse
//
//  Created by sy on 2017/2/15.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface EYPhotoModel : NSObject
@property(nonatomic,strong)PHAsset * asset; //通过asset取到照片
@property(nonatomic,strong)NSString * imageName; //照片的名字
@end

@interface EYPhotoListModel : NSObject
@property(nonatomic,strong)NSString * title; //  相册的名字
@property(nonatomic,assign)NSInteger  photoNum;//该相册的照片数量
@property(nonatomic,strong)PHAsset * firstAsset;//该相册的第一张图片
@property(nonatomic,strong)PHAssetCollection * assetCollection;//同过该属性可以取得该相册的所有照片
@property (nonatomic, strong) NSArray<EYPhotoModel *> *AssetArry;
@end
@interface EYPhotoManger : NSObject
+ (instancetype)share;
- (NSArray <EYPhotoListModel *>*)getAllPhotoList;//获得照片列表

- (NSArray<EYPhotoModel *> *)getAssetArryUse:(PHAssetCollection *)collect ascending:(BOOL)ascending;//获取相册模型

- (NSArray<EYPhotoModel *> *)getModelListAsset:(EYPhotoListModel *)listModel;

- (void)getImgUse:(PHAsset *)asset akeSize:(CGSize)size makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *))completion;

- (void)getImgQUse:(PHAsset *)asset akeSize:(CGSize)size makeResizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *))completion;

@end
