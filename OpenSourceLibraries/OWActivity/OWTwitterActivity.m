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

#import "OWTwitterActivity.h"
#import "OWActivityViewController.h"
#import <Twitter/Twitter.h>

@implementation OWTwitterActivity

- (id)init
{
    self = [super initWithTitle:@"트위터"
                          image:[UIImage imageNamed:@"OWActivityViewController.bundle/Icon_Twitter"]
                    actionBlock:nil];
    
    if (!self)
        return nil;
    
    __typeof(&*self) __weak weakSelf = self;
    self.actionBlock = ^(OWActivity *activity, OWActivityViewController *activityViewController) {
        UIViewController *presenter = activityViewController.presentingController;
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;
        
        [activityViewController dismissViewControllerAnimated:YES completion:^{
            [weakSelf shareFromViewController:presenter
                                         text:[userInfo objectForKey:@"text"]
                                        image:[userInfo objectForKey:@"image"]];
            
        }];
    };
    
    return self;
}


- (void)shareFromViewController:(UIViewController *)viewController text:(NSString *)text image:(NSMutableArray *)array
{
    
id twitterViewComposer = nil;
    
//    if( NSClassFromString (@"UIActivityViewController") ) {
        // ios 6
        twitterViewComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        if (!twitterViewComposer) {
            return;
        }
        
        ((SLComposeViewController*)twitterViewComposer).completionHandler = ^(SLComposeViewControllerResult result) {
            [viewController dismissViewControllerAnimated:YES completion:nil];
        };
//    } else {
//        // ios 5
//        twitterViewComposer = [[TWTweetComposeViewController alloc] init];
//    }
    
    if (twitterViewComposer) {
        viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        if (text)
            [twitterViewComposer setInitialText:text];
        if([array count]>0){
            NSDictionary *dic = array[0];
//        if (image)
//            for(NSDictionary *dic in array){
                if(dic[@"image"])
            [twitterViewComposer addImage:dic[@"image"]];
//            }
        }
        [viewController presentViewController:twitterViewComposer animated:YES completion:nil];
    }
}

@end
