//
//  MHViewController.m
//  MHPhotoUploader
//
//  Created by leehyoley on 09/04/2019.
//  Copyright (c) 2019 leehyoley. All rights reserved.
//

#import "MHViewController.h"
#import "MHPhotoUploaderController.h"
@interface MHViewController ()

@end

@implementation MHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
