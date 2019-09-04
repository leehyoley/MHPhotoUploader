

#import <UIKit/UIKit.h>
#import "MH_AlbumModel.h"
@interface MH_PhotoCollectionCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *imageView;
@property (strong,nonatomic) MH_AlbumModel *model;
@property (copy,nonatomic) void(^didCLickDelete)(void);
@end
