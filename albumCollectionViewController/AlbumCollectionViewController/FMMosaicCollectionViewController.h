//
// FMMosaicCollectionViewController.h
// FMMosaicLayout
//
// Created by Julian Villella on 2015-01-30.
// Copyright (c) 2015 Fluid Media. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
typedef void(^FetchRemoteImagesCompleteHandle)(NSArray *objects, NSError *error);

typedef NS_ENUM(NSUInteger, AlbumMode) {
    AlbumBrowseMode,
    AlbumSelectedMode
};

typedef NS_ENUM(NSUInteger, ImageSourceMode) {
    LocalAlbumMode,
    RemoteImageUrlMode
};

@interface fakeRemoteObj : NSObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDate *creationDate;
+ (fakeRemoteObj*)initWithUrl:(NSString*)url AtDate:(NSDate*)creationDate;
@end

@protocol FMMosaicCollectionViewDelegate <NSObject>
-(void)fetchRemoteImageDataSources:(FetchRemoteImagesCompleteHandle)cb;
@end

@interface FMMosaicCollectionViewController : UICollectionViewController
@property (nonatomic, weak) id<FMMosaicCollectionViewDelegate> delegate;

-(void)setAlbumMode:(AlbumMode)albumMode;
-(void)setImageSourceMode:(ImageSourceMode)imageSourceMode;

// For Action button
-(void)clickSelectedButton;
-(void)clickCancelButton;
-(void)clickDeleteLocalImagesButton;
-(NSArray*)getSeletedItems;
@end
