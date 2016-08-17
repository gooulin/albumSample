//
//  ViewController.m
//  albumSample
//
//  Created by qrippo on 2016/8/10.
//  Copyright © 2016年 qrippo. All rights reserved.
//

#import "ViewController.h"
#import "FMMosaicCollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    FMMosaicCollectionViewController *fmmc = [[FMMosaicCollectionViewController alloc] init];
    [self presentViewController:fmmc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
