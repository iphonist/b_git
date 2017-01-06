//
//  QBSlomoIconView.h
//  QBImagePicker
//
//  Created by Julien Chaumond on 22/04/2015.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000



#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface QBSlomoIconView : UIView

@property (nonatomic, strong) IBInspectable UIColor *iconColor;

@end



#endif
