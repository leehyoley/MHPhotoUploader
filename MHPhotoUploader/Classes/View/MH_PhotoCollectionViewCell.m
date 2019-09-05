

#import "MH_PhotoCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
@implementation MH_PhotoCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.layer.cornerRadius = 5;
        self.contentView.layer.masksToBounds = YES;
        UIImageView *imgv = [[UIImageView alloc] init];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:imgv];
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        self.imageView = imgv;
    }
    return self;
}
-(void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"defaultIcon"]];
}

@end
