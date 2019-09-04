

#import "MH_BaseViewController.h"
#import "MH_AlbumModel.h"
@protocol MHPhotoUploaderControllerDelegate <NSObject>

/**
 提供上次已经选择的图片,进入图片选择页面后，会展示上次选好的
 @return 已选择的图片
 */
@optional
-(NSArray<MH_AlbumModel *> *)getImageArray;

/**
 点击确认选择后的图片回调

 @param imageArray 图片数组
 */
@required
-(void)didSelectImageArray:(NSArray<MH_AlbumModel *> *)imageArray;
@end


/**
 图片选择控制器，选择图片后会自动上传到服务器并生成id，设置prefix和type并实现delegate即可使用
 */
@interface MHPhotoUploaderController : MH_BaseViewController
@property (nonatomic,weak) id<MHPhotoUploaderControllerDelegate> delegate;

/**
  上传图片参数

 @param paramters 参数
 */
-(void)setParamters:(NSDictionary*)paramters;

/**
  上传图片url

 @param urlString url
 */
-(void)setUrlString:(NSString *)urlString;
@end
