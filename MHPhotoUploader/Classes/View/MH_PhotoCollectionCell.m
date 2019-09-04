
#import "MH_PhotoCollectionCell.h"
#import "UIImageView+WebCache.h"
#import <Masonry.h>
@interface MH_PhotoCollectionCell()
@property (strong, nonatomic) UIButton *delBtn;
@end
@implementation MH_PhotoCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imgv = [[UIImageView alloc] init];
        imgv.layer.cornerRadius = 5;
        imgv.layer.masksToBounds = YES;
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imgv];
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        self.imageView = imgv;
        
        UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
        [self.contentView addSubview:delBtn];
        [delBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:delBtn];
        [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-8);
            make.right.mas_equalTo(8);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
        }];
    }
    return self;
}
-(void)setModel:(MH_AlbumModel *)model{
    _model = model;
    self.imageView.image = model.image;
}

-(void)clickDeleteBtn{
    if (self.didCLickDelete) {
        self.didCLickDelete();
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    CGPoint buttonPoint = [self.delBtn convertPoint:point fromView:self];
    // 判断点在不在按钮上
    if ([self.delBtn pointInside:buttonPoint withEvent:event]) {
        return self.delBtn;
    }
    return result;
}
@end
