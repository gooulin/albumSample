//
//  PhotosUtility.m
//  albumSample
//
//  Created by qrippo on 2016/8/12.
//  Copyright © 2016年 qrippo. All rights reserved.
//

#import "PhotosUtility.h"

@implementation PhotosUtility
+ (PHFetchResult*)fetchUserPhotoCollectionsWithAlbumName:(NSString*)albumName {
//    PHFetchOptions *potos_options = [[PHFetchOptions alloc] init];
//    potos_options.predicate = [NSPredicate predicateWithFormat:@"title = %@",albumName];
//
//    PHFetchResult *topLevelUserCollections = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:potos_options];
//
//    return topLevelUserCollections;
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    return allPhotos;
}
@end
