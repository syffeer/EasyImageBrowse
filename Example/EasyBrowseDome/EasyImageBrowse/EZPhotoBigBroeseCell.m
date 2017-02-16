//
//  EZPhotoBigBroeseCell.m
//  EasyBrowseDome
//
//  Created by mofang2 on 17/2/16.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import "EZPhotoBigBroeseCell.h"

@interface EZPhotoBigBroeseCell()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *backView;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation EZPhotoBigBroeseCell
#pragma mark -UI
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _setUI];
        
    }
    return self;
}

- (void)_setUI{
    _backView = [[UIScrollView alloc]init];
    _backView.delegate = self;
    _backView.bouncesZoom = YES;
    _backView.maximumZoomScale = 3;
    _backView.multipleTouchEnabled = YES;
    _backView.alwaysBounceVertical = NO;
    _backView.showsVerticalScrollIndicator = YES;
    _backView.showsHorizontalScrollIndicator = NO;
    _backView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:_backView];
    
    _imageV = [[UIImageView alloc]init];
    [_backView addSubview:_imageV];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
    
    _selectBtn = [[UIButton alloc]init];
    [_selectBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
    [_selectBtn setImage:[UIImage imageNamed:@"detail_Commenticon_selectphotobtn_normal"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"circles_release_photoselectbtn_selected"] forState:UIControlStateSelected];
    [self.contentView addSubview:_selectBtn];
    
    _selectBtn.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _selectBtn.layer.shadowOffset = CGSizeMake(1,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _selectBtn.layer.shadowOpacity = 0.4;//阴影透明度，默认0
    _selectBtn.layer.shadowRadius = 1;//阴影半径，默认3

}

- (void)layoutSubviews{
    [super layoutSubviews];
    _backView.frame = self.bounds;
    _selectBtn.frame = CGRectMake(self.frame.size.width - 58, 8, 50, 50);
    _imageV.frame = self.backView.frame;
}

#pragma mark - event method
- (void)selectClick{
    BOOL fill = [self.delegate arrIsfill];
    if (fill && !_selectBtn.selected) {
        return;
    }
    _selectBtn.selected = !_selectBtn.selected ;
    _selectState =  _selectBtn.selected;
    if ([self.delegate respondsToSelector:@selector(FJPhotoCellDidClick:withNeedAdd:)]) {
        [self.delegate FJPhotoCellDidClick:self.image withNeedAdd:_selectState];
    }
}


#pragma mark - public Method
- (void)setImage:(UIImage *)image{
    _image = image;
    _imageV.image = image;

}

- (void)setSelectState:(BOOL)selectState{
    _selectState = selectState;
    _selectBtn.selected = selectState;
}


- (void)scrollScrollView:(CGPoint)p{
    if (_backView.zoomScale > 1) {
        [_backView setZoomScale:1 animated:YES];
    }else{
        CGFloat maxScale = _backView.maximumZoomScale;
        CGFloat xSzie = self.frame.size.width/maxScale;
        CGFloat ySize = self.frame.size.height/maxScale;
        [_backView zoomToRect:CGRectMake(p.x - xSzie * 0.5, p.y - ySize * 0.5, xSzie, ySize) animated:YES];
    }
}

#pragma mark prvate method
- (void)resizeSubuViewSize{
    UIImage *imge = _imageV.image;
    if (!imge) return;
    CGSize imgVSize;
    imgVSize = CGSizeMake(self.frame.size.width, self.frame.size.width/imge.size.width * imge.size.height);
    _backView.contentSize = CGSizeMake(self.frame.size.width, MAX(self.frame.size.height, imgVSize.height));
    if (imgVSize.height > self.frame.size.height) {
        _imageV.frame = CGRectMake(0, 0, imgVSize.width, imgVSize.height);
    }else{
        CGFloat imgY = (self.frame.size.height - imgVSize.height)*0.5;
        _imageV.frame = CGRectMake(0, imgY, imgVSize.width, imgVSize.height);
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageV;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    _imageV.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

@end
