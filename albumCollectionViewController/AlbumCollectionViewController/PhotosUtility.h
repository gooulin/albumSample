//
//  PhotosUtility.h
//  albumSample
//
//  Created by qrippo on 2016/8/12.
//  Copyright © 2016年 qrippo. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Photos;

@interface PhotosUtility : NSObject
+ (PHFetchResult*)fetchUserPhotoCollectionsWithAlbumName:(NSString*)albumName;
@end
