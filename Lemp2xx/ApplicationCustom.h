//
//  ApplicationCustom.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 9. 12..
//  Copyright (c)BENCHBEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ApplicationCustom : UIApplication

- (BOOL)openURL:(NSURL *)url;
- (BOOL)openURL:(NSURL *)url toSafari:(BOOL)safari;

@end
