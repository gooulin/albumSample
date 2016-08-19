//
// FMMosaicCollectionViewController.m
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

#import "FMMosaicCollectionViewController.h"
#import "FMMosaicCellView.h"
#import "FMMosaicLayout.h"
#import "FMHeaderView.h"
#import "FMFooterView.h"

#import "PhotosUtility.h"

static const CGFloat kFMHeaderFooterHeight  = 44.0;
static const NSInteger kFMMosaicColumnCount = 1;

@interface AssetWithMeta : NSObject

@property (nonatomic, strong) id asset;
@property (nonatomic) BOOL isSelected;

@end

@implementation AssetWithMeta
@end

@implementation fakeRemoteObj
+ (fakeRemoteObj*)initWithUrl:(NSString*)url AtDate:(NSDate*)creationDate {
    
    fakeRemoteObj * f = [[fakeRemoteObj alloc] init];
    f.url = url;
    f.creationDate = creationDate;
    return f;
}
@end

@interface FMMosaicCollectionViewController () <FMMosaicLayoutDelegate,PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) NSMutableArray *imagesAssetPerSection;
@property (nonatomic, strong) NSMutableArray *titlePerSection;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) NSArray *remoteImages;
@property (nonatomic, strong) PHFetchResult *assetsFetchResults;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic) AlbumMode albumMode;
@property (nonatomic) ImageSourceMode imageSourceMode;

@end

@implementation FMMosaicCollectionViewController

- (instancetype)init
{
    FMMosaicLayout *layout = [[FMMosaicLayout alloc] init];
    return [super initWithCollectionViewLayout:layout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //configure collection view
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FMHeaderView" bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:[FMHeaderView reuseIdentifier]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FMFooterView" bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                 withReuseIdentifier:[FMFooterView reuseIdentifier]];
    [self.collectionView registerClass:[FMMosaicCellView class] forCellWithReuseIdentifier:[FMMosaicCellView reuseIdentifier]];
    [self adjustContentInsets];
    
    //get image asset from system photos
    self.imageManager = [[PHCachingImageManager alloc] init];
    self.imagesAssetPerSection = [[NSMutableArray alloc] init];
    self.titlePerSection = [[NSMutableArray alloc] init];

    if (self.imageSourceMode == RemoteImageUrlMode) {
        [self.delegate fetchRemoteImageDataSources:^(NSArray *objects, NSError *error) {
            self.remoteImages = objects;
            [self insertPhotosToSections];
        }];
    } else {
        self.assetsFetchResults = [PhotosUtility fetchUserPhotoCollectionsWithAlbumName:@"M"];
        [self insertPhotosToSections];
        
        //monitor album change
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        
    }

    self.albumMode = AlbumBrowseMode;
    self.selectedAssets = [[NSMutableArray alloc] init];
    [self startSelectedMode];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

static CGSize AssetGridThumbnailSize;
//
//
//- (void)dealloc {
//    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
//}

- (void)adjustContentInsets {
    UIEdgeInsets insets = UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height, 0, 0, 0);
    self.collectionView.contentInset = insets;
    self.collectionView.scrollIndicatorInsets = insets;
}

//#pragma mark configure album mode
//
//-(void)setAlbumMode:(AlbumMode)albumMode {
//    self.albumMode = albumMode;
//}
//-(void)setImageSourceMode:(ImageSourceMode)imageSourceMode {
//    self.imageSourceMode = imageSourceMode;
//}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.titlePerSection.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return ((NSMutableArray*)self.imagesAssetPerSection[section]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMMosaicCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FMMosaicCellView reuseIdentifier] forIndexPath:indexPath];
    
    // Configure the cell
    //cell.titleLabel.text = [NSString stringWithFormat:@"%ld", (long   )indexPath.item + 1];
    //PHAsset *asset = self.assetsFetchResults[indexPath.item % self.assetsFetchResults.count];
    AssetWithMeta *am = self.imagesAssetPerSection[indexPath.section][indexPath.item];
    // Determine the size of the thumbnails to request from the PHCachingImageManager
    if (self.imageSourceMode == LocalAlbumMode) {
    CGFloat scale = 1;
    CGSize cellSize = ((FMMosaicLayout*)self.collectionViewLayout).smallCellSize; //((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    
    // Request an image for the asset from the PHCachingImageManager.
    [self.imageManager requestImageForAsset:am.asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {

                                      cell.imageView.image = result;
                              }];
    }
    if (self.imageSourceMode == RemoteImageUrlMode) {
        fakeRemoteObj *f = am.asset;
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:f.url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            cell.imageView.image = [UIImage imageWithData:data];
        }];
    }
    if (am.isSelected)
        [cell setSelectedEffect];
    else
        [cell setUnSelectedEffect];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.albumMode == AlbumSelectedMode) {
        FMMosaicCellView *cell = (FMMosaicCellView*)[collectionView cellForItemAtIndexPath:indexPath];
        AssetWithMeta *am = self.imagesAssetPerSection[indexPath.section][indexPath.item];
        if (![self.selectedAssets containsObject:am]) {
            [self.selectedAssets addObject:am];
            am.isSelected = TRUE;
            [cell setSelectedEffect];
            
        } else {
            am.isSelected = FALSE;
            [self.selectedAssets removeObject:am];
            [cell setUnSelectedEffect];
        }
    }
    NSLog(@"seletc:%@ count:%lu",self.selectedAssets,(unsigned long)self.selectedAssets.count);
    
//    if (self.selectedAssets.count > 2)
//    {
//        NSMutableArray *asset_list = [[NSMutableArray alloc] init];
//        for (AssetWithMeta *am in self.selectedAssets) {
//            [asset_list addObject:am.asset];
//        }
//        [self deletePhotoWithAssets:asset_list];
//        [self stopSelectedMode];
//    }
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        FMHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind
                              withReuseIdentifier:[FMHeaderView reuseIdentifier] forIndexPath:indexPath];
        
        headerView.titleLabel.text = [NSString stringWithFormat:@"%@", self.titlePerSection[indexPath.section]];
        reusableView = headerView;
        
    } else if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        FMFooterView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind
                               withReuseIdentifier:[FMFooterView reuseIdentifier] forIndexPath:indexPath];
        
        NSInteger assetCount = [self collectionView:self.collectionView numberOfItemsInSection:indexPath.section];
        footerView.titleLabel.text = assetCount == 1 ? @"1 ASSET" : [NSString stringWithFormat:@"%ld ASSETS", (long)assetCount];
        reusableView = footerView;
    }
    
    return reusableView;
}

#pragma mark photos operation
- (void)insertPhotosToSections {
    
    [self.imagesAssetPerSection removeAllObjects];
    [self.titlePerSection removeAllObjects];
    
    if (self.imageSourceMode == RemoteImageUrlMode) {
        NSString *last_asset_date = nil;
        for (fakeRemoteObj *asset in self.remoteImages) {

            //enumerate assets already sort by creation date
            //seperate asset by date for each sections

            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd,MMM YYYY"];
            NSString *date_string = [formatter stringFromDate:asset.creationDate];
            AssetWithMeta *am = [[AssetWithMeta alloc] init];
            am.asset = asset;
            am.isSelected = FALSE;

            //create new section if date is different from previous assets
            //latest date on the top
            if (![date_string isEqualToString:last_asset_date]) {
                [self.titlePerSection insertObject:date_string atIndex:0];
                NSMutableArray *list = [[NSMutableArray alloc] init];
                [list addObject:am];
                [self.imagesAssetPerSection insertObject:list atIndex:0];
                last_asset_date = date_string;
            } else {
                [((NSMutableArray*)self.imagesAssetPerSection[0]) addObject:am];
            }
        };
    }
    
    if (self.imageSourceMode == LocalAlbumMode) {
        NSString *last_asset_date = nil;
        for (PHAsset *asset in self.assetsFetchResults) {

            //enumerate assets already sort by creation date
            //seperate asset by date for each sections

            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd,MMM YYYY"];
            NSString *date_string = [formatter stringFromDate:asset.creationDate];
            AssetWithMeta *am = [[AssetWithMeta alloc] init];
            am.asset = asset;
            am.isSelected = FALSE;

            //create new section if date is different from previous assets
            //latest date on the top
            if (![date_string isEqualToString:last_asset_date]) {
                [self.titlePerSection insertObject:date_string atIndex:0];
                NSMutableArray *list = [[NSMutableArray alloc] init];
                [list addObject:am];
                [self.imagesAssetPerSection insertObject:list atIndex:0];
                last_asset_date = date_string;
            } else {
                NSUInteger index = self.imagesAssetPerSection.count - 1;
                [((NSMutableArray*)self.imagesAssetPerSection[index]) addObject:am];
            }
        }
    }
}

-(void)deletePhotoWithAssets:(NSArray*)deleteAssets {
  
    if (deleteAssets.count > 0)
    {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest deleteAssets:deleteAssets];
        } completionHandler:^(BOOL success, NSError *error) {
            NSLog(@"Finished deleting asset");
        }];
    }
}

#pragma mark selected mode

-(void)startSelectedMode {
    self.albumMode = AlbumSelectedMode;
}

-(void)stopSelectedMode {
    
    self.albumMode = AlbumBrowseMode;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
}

- (void)removeAllSelectedItems {
    for (AssetWithMeta *am in self.selectedAssets) {
        am.isSelected = FALSE;
    };
    [self.selectedAssets removeAllObjects];
}

#pragma mark <FMMosaicLayoutDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
        numberOfColumnsInSection:(NSInteger)section {
    return kFMMosaicColumnCount;
}

- (FMMosaicCellSize)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
        mosaicCellSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //return (indexPath.item % 12 == 0) ? FMMosaicCellSizeBig : FMMosaicCellSizeSmall;
    return FMMosaicCellSizeSmall;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout
        interitemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
   heightForHeaderInSection:(NSInteger)section {
    return kFMHeaderFooterHeight;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
//   heightForFooterInSection:(NSInteger)section {
//    return kFMHeaderFooterHeight;
//}

- (BOOL)headerShouldOverlayContentInCollectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout {
    return NO;
}

- (BOOL)footerShouldOverlayContentInCollectionView:(UICollectionView *)collectionView layout:(FMMosaicLayout *)collectionViewLayout {
    return NO;
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // Check if there are changes to the assets we are showing.
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }
    
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Get the new fetch result.
        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        [self insertPhotosToSections];
        [self.collectionView reloadData];
        
//        UICollectionView *collectionView = self.collectionView;
//        
//        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
//            // Reload the collection view if the incremental diffs are not available
//            [collectionView reloadData];
//            
//        } else {
//            /*
//             Tell the collection view to animate insertions and deletions if we
//             have incremental diffs.
//             */
//            [collectionView performBatchUpdates:^{
//                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
//                if ([removedIndexes count] > 0) {
//                    [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
//                }
//                
//                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
//                if ([insertedIndexes count] > 0) {
//                    [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
//                }
//                
//                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
//                if ([changedIndexes count] > 0) {
//                    [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
//                }
//            } completion:NULL];
//        }
        
        //[self resetCachedAssets];
    });
}

#pragma mark - Status Bar

-(void)clickSelectedButton {
    [self startSelectedMode];
}
-(void)clickCancelButton {
    [self stopSelectedMode];
}
-(void)clickDeleteLocalImagesButton {
    if (self.selectedAssets.count > 0)
    {
        NSMutableArray *asset_list = [[NSMutableArray alloc] init];
        for (AssetWithMeta *am in self.selectedAssets) {
            [asset_list addObject:am.asset];
        }
        [self deletePhotoWithAssets:asset_list];
        [self stopSelectedMode];
    }
}
-(NSArray*)getSeletedItems {
    NSMutableArray *asset_list = [[NSMutableArray alloc] init];
    if (self.selectedAssets.count > 0)
    {
        for (AssetWithMeta *am in self.selectedAssets) {
            [asset_list addObject:am.asset];
        }
    }
    return asset_list;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
