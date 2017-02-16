//
//  EZPhotoBrowseCell.m
//  EasyBrowseDome
//
//  Created by mofang2 on 17/2/16.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import "EZPhotoBrowseCell.h"
@interface EZPhotoBrowseCell ()
@property (nonatomic, strong) UIButton *stateBtn;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation EZPhotoBrowseCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_imageView];
        
        _stateBtn = [[UIButton alloc]init];
        [_stateBtn addTarget:self action:@selector(selectClick) forControlEvents:UIControlEventTouchUpInside];
        [_stateBtn setImage:[UIImage imageNamed:@"detail_Commenticon_selectphotobtn_normal"] forState:UIControlStateNormal];
        [_stateBtn setImage:[UIImage imageNamed:@"circles_release_photoselectbtn_selected"] forState:UIControlStateSelected];
        _stateBtn.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
        _stateBtn.layer.shadowOffset = CGSizeMake(1,1);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _stateBtn.layer.shadowOpacity = 0.4;//阴影透明度，默认0
        _stateBtn.layer.shadowRadius = 1;//阴影半径，默认3

        [self.contentView addSubview:_stateBtn];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
    _stateBtn.frame = CGRectMake(self.frame.size.width * 0.7 - 3, 3, self.frame.size.width * 0.3, self.frame.size.width * 0.3);
}


- (void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}

- (void)setSelectState:(BOOL)selectState{
    _selectState = selectState;
    _stateBtn.selected = selectState;
}

- (void)selectClick{
    BOOL fill = [self.delegate arrIsfill];
    if (fill && !_stateBtn.selected) {
        return;
    }
    _stateBtn.selected = !_stateBtn.selected ;
    _selectState =  _stateBtn.selected;
    if ([self.delegate respondsToSelector:@selector(EZPhotoCellDidClick:withNeedAdd:)]) {
        [self.delegate EZPhotoCellDidClick:self.image withNeedAdd:_selectState];
    }
}
@end
