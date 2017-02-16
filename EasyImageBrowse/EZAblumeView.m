//
//  EZAblumeView.m
//  EasyBrowseDome
//
//  Created by mofang2 on 17/2/16.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#define  EZ_WIDTH [UIScreen mainScreen].bounds.size.width
#define  EZ_HEIGHT [UIScreen mainScreen].bounds.size.height
#import "EZAblumeView.h"
#import "EYPhotoManger.h"
static NSString *cellIDF = @"albumViewCellIdf";
@interface FJAlbumViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imgV;
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UIImageView *selctState;
@property (nonatomic, strong) EYPhotoListModel *listModel;
@end

@implementation FJAlbumViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    _imgV = [[UIImageView alloc]init];
    [self.contentView addSubview:_imgV];
    
    _textLab = [[UILabel alloc]init];
    _textLab.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_textLab];
    
    _numberLab = [[UILabel alloc]init];
    _numberLab.textAlignment = NSTextAlignmentCenter;
    _numberLab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_numberLab];
    
    _selctState = [[UIImageView alloc]init];
    [self.contentView addSubview:_selctState];
}


- (void)setListModel:(EYPhotoListModel *)listModel{
    _listModel = listModel;
    _imgV.frame = CGRectMake(8, 4, self.frame.size.height - 8, self.frame.size.height - 8);
    _textLab.text = listModel.title;
    [_textLab sizeToFit];
    _textLab.frame = CGRectMake(_imgV.frame.size.width + _imgV.frame.origin.x + 6, _imgV.frame.size.height * 0.5 - _textLab.frame.size.height * 0.5, _textLab.frame.size.width, _textLab.frame.size.height);
      _numberLab.frame = CGRectMake(_textLab.frame.size.width + _textLab.frame.origin.x,_textLab.frame.size.height,50,_textLab.frame.origin.y);
    _numberLab.text = [NSString stringWithFormat:@"%zd",listModel.photoNum];
    [[EYPhotoManger share]getImgUse:listModel.firstAsset akeSize:CGSizeMake(100, 100) makeResizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *img) {
        _imgV.image = img;
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.layer.masksToBounds = YES;
    }];
}

@end


@interface EZAblumeView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *backV;
@end
@implementation EZAblumeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, EZ_WIDTH  , EZ_HEIGHT)];
        _backV.backgroundColor = [UIColor blackColor];
        [self addSubview:_backV];
        [self setUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setUI{
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[FJAlbumViewCell class] forCellReuseIdentifier:cellIDF];
    [self addSubview:_tableView];
}


#pragma mark - public method
- (void)show{
    self.tableView.frame = CGRectMake(0, -EZ_WIDTH, EZ_WIDTH, EZ_WIDTH);
    _backV.alpha = 0.5;
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.tableView.frame = CGRectMake(0, 64, EZ_WIDTH, EZ_WIDTH);
    } completion:nil];
}

- (void)hiding:(void (^)())cartoonFinish{
    [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.tableView.frame = CGRectMake(0, -EZ_WIDTH, EZ_WIDTH, EZ_WIDTH);
    } completion:^(BOOL finished) {
        cartoonFinish();
    }];
    [UIView animateWithDuration:0.35 animations:^{
        _backV.alpha = 0;
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FJAlbumViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDF forIndexPath:indexPath];
    cell.listModel = self.arrModels[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(albumViewDidCliK:)]) {
        [self.delegate albumViewDidCliK:indexPath.row];
    }
}


#pragma mark - setter && getter
- (void)setArrModels:(NSArray *)arrModels{
    _arrModels = arrModels;
    [self.tableView reloadData];
}
@end
