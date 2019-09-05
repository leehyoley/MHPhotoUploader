//
//  MHPhotoUploaderHandle.m
//  GxMentalHealth
//
//  Created by li on 2019/9/3.
//  Copyright © 2019 社会主义接班人. All rights reserved.
//

#import "MHPhotoUploaderHandle.h"
#import "VMNetWorking.h"
#import "MH_AlbumModel.h"
@interface MHPhotoUploaderHandle()
@property (nonatomic,strong) NSMutableArray<MH_AlbumModel*> *modelPoolArray;
@property (nonatomic,strong) NSTimer *uploadCheckTimer;
@property (nonatomic,assign) BOOL isRequseting;
@property (nonatomic,copy) void (^successBlock)(NSArray<MH_AlbumModel *> *modelArray);
@end
@implementation MHPhotoUploaderHandle{
    NSDictionary *_paramters;
    NSString *_urlString;
}

-(instancetype)init{
    if (self = [super init]) {
        self.modelPoolArray = [NSMutableArray array];
    }
    return self;
}
-(void)setParamters:(NSDictionary*)paramters{
    _paramters = paramters;
}
-(void)setUrlString:(NSString *)urlString{
    _urlString = urlString;
}
/**
 检测是否所有上传请求已完成

 @return 是否完成
 */
-(BOOL)isCompleteAllRequset{
    __block BOOL isComplete = YES;
    [self.modelPoolArray enumerateObjectsUsingBlock:^(MH_AlbumModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.fileId.length) {
            isComplete  = NO;
            *stop = YES;
        }
    }];
    return isComplete;
}
/**
 检查是否有需要上传的图片，若无，清除定时器
 */
-(void)checkModelPoolUploadIfNeed{
    if (!_urlString||!_paramters) {
        return;
    }
    
    if (self.isRequseting) {
        return;
    }
    
    __block MH_AlbumModel *currentModel = nil;
    
    [self.modelPoolArray enumerateObjectsUsingBlock:^(MH_AlbumModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.fileId.length) {
            currentModel = obj;
            *stop = YES;
        }
    }];
    
    if (!currentModel) {
        //都上传完成了
        //id池没id,废弃timer并销魂
        [self.uploadCheckTimer invalidate];
        self.uploadCheckTimer = nil;
        
        //若存在blocks，说明已经在等待数据，给回调
        if (self.successBlock) {
            self.successBlock(self.modelPoolArray);
            self.successBlock = nil;
        }
        return;
    }
    
    NSData *data = [self suitableDataForImage:currentModel.image];
    self.isRequseting = YES;
    [VMNetWorking.shareInit VM_Post_Image_ParameterJson_ResultJson:_urlString parameters:_paramters imageDataArray:@[data] partName:@"file" success:^(NSDictionary * _Nonnull resultDic) {
        
        currentModel.fileId = [resultDic[@"fileId"] description];
        currentModel.fileUrl = resultDic[@"fileUrl"];
        self.isRequseting = NO;
        
    } other:^(NSDictionary * _Nonnull resultDic) {
        self.isRequseting = NO;
        
    } failure:^(NSError * _Nonnull error) {
        self.isRequseting = NO;
        
    } resultMsg:^(NSString * _Nonnull errMsg) {
        self.isRequseting = NO;
    }];
}

-(void)addImageModelToRequestPool:(NSArray<MH_AlbumModel *> *)modelArray{
    [self.modelPoolArray addObjectsFromArray:modelArray];
    
    if (self.uploadCheckTimer==nil) {
        self.uploadCheckTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(checkModelPoolUploadIfNeed) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.uploadCheckTimer forMode:NSDefaultRunLoopMode];
    }
}

-(void)removeImageModelFromRequestPool:(MH_AlbumModel *)model{
    [self.modelPoolArray removeObject:model];
}

-(void)requestUpdateSuccess:(void (^)(NSArray<MH_AlbumModel *> *modelArray))success failure:(void (^)(void))failure{
    if ([self isCompleteAllRequset]) {
        success(self.modelPoolArray);
    }else{
        self.successBlock = success;
        //等5秒，还是不能成功，提示上传失败
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![self isCompleteAllRequset]) {
                self.successBlock = nil;
                failure();
            }
        });
    }
}

-(void)cancelAllUpload{
    [self.uploadCheckTimer invalidate];
    self.uploadCheckTimer = nil;
    self.successBlock = nil;
}

-(NSInteger)getImageCount{
    return self.modelPoolArray.count;
}

-(MH_AlbumModel *)getModelForIndex:(NSInteger)index{
    return self.modelPoolArray[index];
}

- (NSData *)suitableDataForImage:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    if (data.length>300000) {
        //大于300K，压缩下
        data = UIImageJPEGRepresentation(image, 0.5);
    }
    return data;
}
@end
