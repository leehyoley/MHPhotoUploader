//
//  ViewController.m
//  MH_AlbumUploadControllerDemo
//
//  Created by li on 2019/9/4.
//  Copyright © 2019 li. All rights reserved.
//

#import "ViewController.h"
#import "MHPhotoUploaderController.h"
@interface ViewController ()<MHPhotoUploaderControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    MHPhotoUploaderController *puc = [[MHPhotoUploaderController alloc] init];
//    [puc setUrlString:@"hello"];
//    [puc setParamters:@{@"lala":@"1"}];
    puc.delegate = self;
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:puc];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)didSelectImageArray:(NSArray<MH_AlbumModel *> *)imageArray {
    
}

@end
