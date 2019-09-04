//
//  MHPhotoUploaderHandle.h
//  GxMentalHealth
//
//  Created by li on 2019/9/3.
//  Copyright © 2019 社会主义接班人. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MH_AlbumModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MHPhotoUploaderHandle : NSObject

-(void)setParamters:(NSDictionary*)paramters;
-(void)setUrlString:(NSString *)urlString;

-(void)addImageModelToRequestPool:(NSArray<MH_AlbumModel *> *)modelArray;
-(void)removeImageModelFromRequestPool:(MH_AlbumModel *)model;
-(void)requestUpdateSuccess:(void (^)(NSArray<MH_AlbumModel *> *modelArray))success failure:(void (^)(void))failure;
-(void)cancelAllUpload;
/**
 获取当前图片总数

 @return 当前图片数量
 */
-(NSInteger)getImageCount;

/**
 获取指定位置图片model

 @param index 下标
 @return 下标为index的model
 */
-(MH_AlbumModel *)getModelForIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
