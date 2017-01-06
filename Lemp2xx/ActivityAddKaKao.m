//
// OWTwitterActivity.m
// OWActivityViewController
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
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
//

#import "ActivityAddKaKao.h"
#import "OWActivityViewController.h"
#import "KaKaoLinkCenter.h"

@implementation ActivityAddKaKao

- (id)init
{
    self = [super initWithTitle:@"카카오톡"
                          image:[UIImage imageNamed:@"Icon_Kakao.png"]
                    actionBlock:nil];
    
    if (!self)
        return nil;
    
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(OWActivity *activity, OWActivityViewController *activityViewController) {
        UIViewController *presenter = activityViewController.presentingController;
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
       
        [activityViewController dismissViewControllerAnimated:YES completion:^{
            [weakSelf shareFromViewController:presenter
                                         text:userInfo[@"text"]];
            
        }];
    };
//        NSMutableDictionary * pasteboardDict = [NSMutableDictionary dictionary];
//        NSString *text = [userInfoobjectForKey:@"text"];
//    };
    
    return self;
}

- (void)shareFromViewController:(UIViewController *)viewController text:(NSString *)text
{

    
    if (![KakaoLinkCenter canOpenKakaoLink]) {
        return;
    }
    
    NSMutableArray *metaInfoArray = [NSMutableArray array];
//
//    
//    NSDictionary *metaInfoAndroid = [NSDictionary dictionaryWithObjectsAndKeys:
//                                     @"android", @"os",
//                                     @"phone", @"devicetype",
//                                     @"market://details?id=com.kakao.talk", @"installurl",
//                                     @"example://example", @"executeurl",
//                                     nil];
//    NSDictionary *metaInfoIOS = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 @"ios", @"os",
//                                 @"phone", @"devicetype",
//                                 @"https://itunes.apple.com/kr/app/laempeu/id674513922?mt=8", @"installurl",
//                                 @"LEMP://LEMP", @"executeurl",
//                                 nil];
//    
//    [metaInfoArray addObject:metaInfoAndroid];
//    [metaInfoArray addObject:metaInfoIOS];
    
    [KakaoLinkCenter openKakaoAppLinkWithMessage:text
                                             URL:@""
                                     appBundleID:[[NSBundle mainBundle] bundleIdentifier]
                                      appVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
                                         appName:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
                                   metaInfoArray:metaInfoArray];

    
//             if (text && [[KakaoLinkCenter defaultCenter] canOpenKakaoLink]) {
//                 [[KakaoLinkCenter defaultCenter] openKakaoLinkWithURL:@""
//                                                               appVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
//                                                              appBundleID:[[NSBundle mainBundle] bundleIdentifier]
//                                                                  apName:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]
//                                                                  message:text];
//                } else {
//                    NSLog(@"kakao not installed");
//            }

}

@end