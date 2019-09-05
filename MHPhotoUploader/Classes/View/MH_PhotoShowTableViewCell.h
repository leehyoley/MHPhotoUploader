//
//  MH_PhotoShowTableViewCell.h
//  GxMentalHealth
//
//  Created by li on 2019/9/5.
//  Copyright © 2019 社会主义接班人. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MH_PhotoShowTableViewCell : UITableViewCell
-(void)setTitle:(NSString *)title andImageUrls:(NSArray<NSString*> *)imgUrls;
@end

NS_ASSUME_NONNULL_END
