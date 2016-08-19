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
    //[fmmc setImageSourceMode:RemoteImageUrlMode];
    fmmc.delegate = self;
    [self presentViewController:fmmc animated:YES completion:nil];
}
-(void)fetchRemoteImageDataSources:(FetchRemoteImagesCompleteHandle)cb
{
    fakeRemoteObj* f1 = [fakeRemoteObj initWithUrl:@"https://2.bp.blogspot.com/-37aHgrklStY/V4hODFCZRsI/AAAAAAAACvY/BQ3j2hKAnoce-PaFvVUnCPfdWMB1_MGpwCLcB/s320/%25E8%259E%25A2%25E5%25B9%2595%25E5%25BF%25AB%25E7%2585%25A7%2B2016-07-13%2B%25E4%25B8%258A%25E5%258D%25889.45.38.png" AtDate:[NSDate date]];
    fakeRemoteObj* f2 = [fakeRemoteObj initWithUrl:@"https://2.bp.blogspot.com/-kcfDUsok6EA/V4hODjSvHTI/AAAAAAAACvc/zAEXScaQRLgFdXWSu3WyYHxU45169DwEACLcB/s320/%25E8%259E%25A2%25E5%25B9%2595%25E5%25BF%25AB%25E7%2585%25A7%2B2016-07-13%2B%25E4%25B8%258A%25E5%258D%25889.45.51.png" AtDate:[NSDate dateWithTimeIntervalSinceNow:-2400000]];
    fakeRemoteObj* f3 = [fakeRemoteObj initWithUrl:@"https://1.bp.blogspot.com/-5bTHfXX2tek/V4hODgeMeOI/AAAAAAAACvg/9GtyPn39PdcfJQYf0dF9iIRBPDmKL6A3gCLcB/s320/%25E8%259E%25A2%25E5%25B9%2595%25E5%25BF%25AB%25E7%2585%25A7%2B2016-07-13%2B%25E4%25B8%258A%25E5%258D%25889.46.00.png" AtDate:[NSDate dateWithTimeIntervalSinceNow:-2400000]];
        fakeRemoteObj* f4 = [fakeRemoteObj initWithUrl:@"https://1.bp.blogspot.com/-5bTHfXX2tek/V4hODgeMeOI/AAAAAAAACvg/9GtyPn39PdcfJQYf0dF9iIRBPDmKL6A3gCLcB/s320/%25E8%259E%25A2%25E5%25B9%2595%25E5%25BF%25AB%25E7%2585%25A7%2B2016-07-13%2B%25E4%25B8%258A%25E5%258D%25889.46.00.png" AtDate:[NSDate dateWithTimeIntervalSinceNow:-24000000]];
            fakeRemoteObj* f5 = [fakeRemoteObj initWithUrl:@"https://1.bp.blogspot.com/-5bTHfXX2tek/V4hODgeMeOI/AAAAAAAACvg/9GtyPn39PdcfJQYf0dF9iIRBPDmKL6A3gCLcB/s320/%25E8%259E%25A2%25E5%25B9%2595%25E5%25BF%25AB%25E7%2585%25A7%2B2016-07-13%2B%25E4%25B8%258A%25E5%258D%25889.46.00.png" AtDate:[NSDate dateWithTimeIntervalSinceNow:-24000000]];
    
    if (cb)
        cb(@[f5,f4,f3,f2,f1],nil);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
