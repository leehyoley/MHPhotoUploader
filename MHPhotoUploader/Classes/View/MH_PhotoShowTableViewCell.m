//
//  MH_PhotoShowTableViewCell.m
//  GxMentalHealth
//
//  Created by li on 2019/9/5.
//  Copyright © 2019 社会主义接班人. All rights reserved.
//

#import "MH_PhotoShowTableViewCell.h"
#import "MH_PhotoCollectionViewCell.h"
#import "KSPhotoBrowser.h"
#import <Masonry.h>
#import <MHConfigure/Maros.h>//宏
#define PHOTO_ITEM_WIDTH ((K_Screen_Width-90-16-20)/3)
//颜色
#define K_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000)>>16))/255.0 green:((float)((rgbValue & 0xFF00)>>8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface MH_PhotoShowTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UILabel *mTitleLabel;
@property (nonatomic,strong) UILabel *mContentLabel;
@property (nonatomic,strong) UICollectionView *photoCollectionView;
@property (nonatomic,strong) NSArray<NSString *> *imgUrls;
@property (nonatomic, strong) NSMutableDictionary *imgvDic;

@end
@implementation MH_PhotoShowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *titleLable = UILabel.new;
        titleLable.text = @"附件资料";
        titleLable.textColor = K_UIColorFromRGB(0x999999);
        titleLable.font = [UIFont systemFontOfSize:15];
        [titleLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.contentView addSubview:titleLable];
        self.mTitleLabel = titleLable;
        
        UILabel *contentLabel = UILabel.new;
        contentLabel.numberOfLines = 0;
        contentLabel.text = @"暂无";
        contentLabel.textColor = K_UIColorFromRGB(0x333333);
        contentLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:contentLabel];
        self.mContentLabel = contentLabel;
        
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(16);
            make.left.mas_equalTo(self.contentView).offset(16);
        }];
        
        //content可能是多行，约束好，文字可以把它撑起来自适应
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(16);
            make.left.greaterThanOrEqualTo(self.contentView).offset(90);
            make.right.equalTo(self.contentView).offset(-16);
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-16);
            make.height.greaterThanOrEqualTo(titleLable.mas_height);
        }];
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = K_UIColorFromRGB(0xeeeeee);
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.height.mas_equalTo(1);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.itemSize = CGSizeMake(PHOTO_ITEM_WIDTH,PHOTO_ITEM_WIDTH);
        self.photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.photoCollectionView.backgroundColor = [UIColor clearColor];
        self.photoCollectionView.delegate = self;
        self.photoCollectionView.dataSource = self;
        [self.contentView addSubview:self.photoCollectionView];
        [self.photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(16);
            make.left.greaterThanOrEqualTo(self.contentView).offset(90);
            make.right.mas_equalTo(self.contentView).offset(-16);
            make.bottom.mas_lessThanOrEqualTo(self.contentView).offset(-6);
            make.height.mas_equalTo(0);
        }];
        [self.photoCollectionView registerClass:[MH_PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"MH_PhotoCollectionViewCell"];
    }
    return self;
}

-(void)setTitle:(NSString *)title andImageUrls:(NSArray<NSString*> *)imgUrls{
    self.mTitleLabel.text = title;
    self.mContentLabel.hidden = YES;
    if (imgUrls.count==0) {
        self.mContentLabel.hidden = NO;
    }
    
    self.imgUrls = imgUrls;
    int linenum = (int)(self.imgUrls.count+2)/3;
    int photoHeigh = linenum*PHOTO_ITEM_WIDTH+linenum*10;
    [self.photoCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(photoHeigh);
    }];
    [self.photoCollectionView reloadData];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgUrls.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MH_PhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MH_PhotoCollectionViewCell" forIndexPath:indexPath];
    cell.imgUrl = self.imgUrls[indexPath.row];
    self.imgvDic[@(indexPath.row)] = cell.imageView;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showPhotoBrowserWithIndex:indexPath.row];
}
-(void)showPhotoBrowserWithIndex:(NSInteger)idx{
    
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < self.imgUrls.count; ++i) {
        UIImageView *imgv = self.imgvDic[@(i)];
        KSPhotoItem *item = nil;
        if(self.imgUrls.count>i){
            item = [KSPhotoItem itemWithSourceView:imgv imageUrl:[NSURL URLWithString:self.imgUrls[i]]];
        } else{
            item = [KSPhotoItem itemWithSourceView:imgv image:imgv.image];
        }
        [photos addObject:item];

    }
    if (photos.count&&idx<photos.count){
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:photos selectedIndex:idx];
        UITableView *fatherView = (UITableView*)self.superview;
        [browser showFromViewController:(UIViewController*)fatherView.dataSource];
    }
}
@end
