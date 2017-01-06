//
//  WebBrowserViewController.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 9. 13..
//  Copyright (c) 2013 BENCHBEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
enum {
    WebBrowserViewControllerAvailableActionsNone             = 0,
    WebBrowserViewControllerAvailableActionsOpenInSafari     = 1 << 0,
    WebBrowserViewControllerAvailableActionsMailLink         = 1 << 1,
    WebBrowserViewControllerAvailableActionsCopyLink         = 1 << 2,
    WebBrowserViewControllerAvailableActionsOpenInChrome     = 1 << 3
};
typedef NSUInteger WebBrowserViewControllerAvailableActions;


@interface UIApplication(WebBrowser)
- (BOOL)openURL:(NSURL *)url toSafari:(BOOL)safari;
@end

@protocol WebBrowserDelegate <NSObject>
- (BOOL)openURL:(NSURL*)url;
@end

@interface WebBrowserViewController : UIViewController < UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UIAlertViewDelegate, NJKWebViewProgressDelegate >{
    BOOL boolLoaded;
    BOOL postMethod;
}
- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;
- (void)loadURL;//:(NSURL*)URL;
- (void)loadURLwithBody:(NSString *)bd;
- (void)updateToolbarItems:(BOOL)isConnecting;

- (void)settingUserAgent:(NSString *)ua;

@property (nonatomic, readwrite) WebBrowserViewControllerAvailableActions availableActions;
@property (nonatomic, strong) UIWebView *mainWebView;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *bodyString;
//@property (nonatomic, assign) BOOL isSimpleMode;
@end
