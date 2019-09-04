//
//  MH_PhotoAddCollectionViewCell.m
//  GxMentalHealth
//
//  Created by li on 2019/9/3.
//  Copyright © 2019 社会主义接班人. All rights reserved.
//

#import "MH_PhotoAddCollectionViewCell.h"
#import <Masonry.h>
//颜色
#define K_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000)>>16))/255.0 green:((float)((rgbValue & 0xFF00)>>8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface MH_PhotoAddCollectionViewCell()
@property (nonatomic,strong) UILabel *countLabel;
@end
@implementation MH_PhotoAddCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.borderColor = K_UIColorFromRGB(0xc1c1c1).CGColor;
        self.contentView.layer.borderWidth = 1;
        
        UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo_add"]];
        [self.contentView addSubview:imgv];
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(36);
            make.height.mas_equalTo(31);
            make.centerY.mas_equalTo(-5);
            make.centerX.mas_equalTo(0);
        }];
        
        UILabel *countLabel = [[UILabel alloc] init];
        countLabel.textColor = K_UIColorFromRGB(0xc1c1c1);
        countLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:countLabel];
        [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(imgv.mas_bottom).offset(0);
        }];
        self.countLabel = countLabel;
    }
    return self;
}

-(void)setCurrentCount:(int)currentCount{
    _currentCount = currentCount;
    self.countLabel.text = [NSString stringWithFormat:@"%d/%d",_currentCount,_maxCount];
}
-(void)setMaxCount:(int)maxCount{
    _maxCount = maxCount;
    self.countLabel.text = [NSString stringWithFormat:@"%d/%d",_currentCount,_maxCount];
}
@end
