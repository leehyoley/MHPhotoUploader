
#import "MHPhotoUploaderController.h"
#import "MH_PhotoCollectionCell.h"
#import "MH_PhotoAddCollectionViewCell.h"
#import "MH_AlbumModel.h"
#import "ZLPhotoBrowser/ZLPhotoBrowser.h"
#import <KSPhotoBrowser.h>
#import "MHPhotoUploaderHandle.h"
#import <Masonry.h>
#import "MBProgressHUD.h"
#import <MHConfigure/Maros.h>//宏
#define LeftMargine 16
#define RightMargine 16
#define CellMargine 16
#define TopMargine 16
@interface MHPhotoUploaderController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,KSPhotoBrowserDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSCache *imavs;
@property (nonatomic, strong) UIButton *conformBtn;
@property (nonatomic,strong) MHPhotoUploaderHandle *handle;
@property (nonatomic,assign) NSInteger maxCount;
@end

@implementation MHPhotoUploaderController


- (void)viewDidLoad {
    [super viewDidLoad];
    //默认设置为5张
    if (self.maxCount==0) {
        self.maxCount = 5;
    }
    
    [self setupUI];
    self.imavs = [[NSCache alloc] init];
    [self loadPics];
}

-(MHPhotoUploaderHandle*)handle{
    if (!_handle) {
        _handle = [[MHPhotoUploaderHandle alloc] init];
    }
    return _handle;
}

-(void)loadPics{
    if ([self.delegate respondsToSelector:@selector(getImageArray)]) {
            NSArray *arr = [self.delegate getImageArray];
            if (arr) {
                [self.handle addImageModelToRequestPool:arr];
            }
    }
    [self.collectionView reloadData];
}
-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"附件资料";
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, K_Top_Height, K_Screen_Width, K_Screen_Height)  collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(TopMargine,LeftMargine,0, RightMargine);
    [self.collectionView registerClass:[MH_PhotoCollectionCell class] forCellWithReuseIdentifier:@"MH_PhotoCollectionCell"];
    [self.collectionView registerClass:[MH_PhotoAddCollectionViewCell class] forCellWithReuseIdentifier:@"MH_PhotoAddCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    
    UIButton *putButton = [UIButton buttonWithType:UIButtonTypeCustom];
    putButton.frame = CGRectMake(0, 0, K_Screen_Width, 48);
    [putButton setTitle:@"保存" forState:UIControlStateNormal];
    [putButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    putButton.titleLabel.font = [UIFont systemFontOfSize:17];
    putButton.adjustsImageWhenHighlighted = NO;
    putButton.backgroundColor = K_TitleGray_Color;
    [putButton addTarget:self action:@selector(clickUpload) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:putButton];
    [putButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(K_IsIPhone_X_All ? 34 : 0));
        make.height.mas_equalTo(48);
    }];
    self.conformBtn = putButton;
    self.conformBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger count = [self.handle getImageCount];

    if (count<self.maxCount) {
        count+=1;
    }
    self.conformBtn.enabled = count>0;
    self.conformBtn.backgroundColor = self.conformBtn.enabled?K_BaseGreen_Color:K_TitleGray_Color;
    return count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *targetCell = nil;
    
    if (indexPath.row == [self.handle getImageCount]) {
        MH_PhotoAddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MH_PhotoAddCollectionViewCell" forIndexPath:indexPath];
        cell.maxCount = self.maxCount;
        cell.currentCount = (int)[self.handle getImageCount];
        targetCell = cell;
    }else{
        MH_PhotoCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MH_PhotoCollectionCell" forIndexPath:indexPath];
        MH_AlbumModel *model = [self.handle getModelForIndex:indexPath.row];
        cell.model = model;
        __weak typeof(self) weakSelf = self;
        cell.didCLickDelete = ^{
            [weakSelf.handle removeImageModelFromRequestPool:model];
            [weakSelf.collectionView reloadData];
        };
        [self.imavs setObject:cell.imageView forKey:@(indexPath.row)];
        targetCell = cell;
    }
    return targetCell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (K_Screen_Width-LeftMargine-RightMargine-3*CellMargine)/4.0;
    return CGSizeMake(width, width);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row==[self.handle getImageCount]) {
        [self chooseImage];
    }else{

        NSMutableArray *broArr  = [NSMutableArray array];
        for (int i=0;i<[self.handle getImageCount]; i++) {
            MH_AlbumModel *model = [self.handle getModelForIndex:i];//self.photoModelArray[i];
            KSPhotoItem *item = nil;
            if (model.image) {
                item = [KSPhotoItem itemWithSourceView:[self.imavs objectForKey:@(i)] image:model.image];
            }else{
            }
            [broArr addObject:item];
        }
        KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:broArr selectedIndex:indexPath.row];
        browser.delegate = self;
        [browser showFromViewController:self];
    }
    
}

- (void)clickUpload{
    
//    [self.view showProgressHudWithString:@"正在上传"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    [self.handle requestUpdateSuccess:^(NSArray<MH_AlbumModel *> * _Nonnull modelArray) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([weakSelf.delegate respondsToSelector:@selector(didSelectImageArray:)]) {
            [weakSelf.delegate didSelectImageArray:modelArray];
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//        [weakSelf.view showProgressHudWithString:@"上传失败，请稍后重试" duration:1];
    }];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//选择调取方式
- (void)chooseImage{

    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];

    // 相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount = self.maxCount - [self.handle getImageCount];
    ac.configuration.maxPreviewCount = 20;
    ac.configuration.allowSelectGif = NO;
    ac.configuration.allowSelectVideo = NO;
    ac.configuration.allowSelectOriginal = NO;
    ac.configuration.navBarColor = [UIColor whiteColor];
    ac.configuration.navTitleColor = [UIColor blackColor];

    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;

    // 选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        for (UIImage *image in images) {
            MH_AlbumModel *model = [[MH_AlbumModel alloc] init];
            model.image = image;
            [self.handle addImageModelToRequestPool:@[model]];
        }
        [self.collectionView reloadData];
        //your codes
    }];

    // 调用相册
    [ac showPreviewAnimated:YES];
    
}

-(void)setParamters:(NSDictionary*)paramters{
    [self.handle setParamters:paramters];
}
-(void)setUrlString:(NSString *)urlString{
    [self.handle setUrlString:urlString];
}


-(void)dealloc{
    [self.handle cancelAllUpload];
}

@end
