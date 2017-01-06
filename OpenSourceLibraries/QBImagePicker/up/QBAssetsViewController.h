//
//  QBAssetsViewController.h
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000



#import <UIKit/UIKit.h>

@class QBImagePickerController;
@class PHAssetCollection;

@interface QBAssetsViewController : UICollectionViewController

@property (nonatomic, weak) QBImagePickerController *imagePickerController;
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@end



#endif
