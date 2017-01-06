//
//  WebViewController.h
//  Skying
//
//  Created by 백인구 on 11. 5. 21..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, UITextFieldDelegate, UISearchBarDelegate> {
	UIWebView *myWebView;
	BOOL boolLoaded;
	BOOL progressing;
	NSString *currentTitle;
    UISearchBar *addressField;
    //	WebViewWithBefore *parent;
}

- (void)loadURL:(NSString *)url;
- (void)loadRequest:(NSURLRequest *)r;
- (void)loadFromDB:(NSString *)path;

@property (nonatomic, retain) UIWebView	*myWebView;
@end
