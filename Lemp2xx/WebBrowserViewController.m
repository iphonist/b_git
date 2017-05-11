//
//  WebBrowserViewController.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 9. 13..
//  Copyright (c) 2013 BENCHBEE. All rights reserved.
//

#import "WebBrowserViewController.h"
#import "CustomProgressView.h"
#import "AFURLRequestSerialization.h"

@implementation UIApplication(WebBrowser)

- (BOOL)openURL:(NSURL *)url toSafari:(BOOL)safari
{
	if (safari) {
		return [self openURL:url];
	}
	
	BOOL isHttp = NO;
	
	NSString *scheme = [url.scheme lowercaseString];
	if ([scheme compare:@"http"] == NSOrderedSame
		|| [scheme compare:@"https"] == NSOrderedSame) {
		
		isHttp = [(id<WebBrowserDelegate>)self.delegate openURL:url];
		
	}
	
	if (!isHttp) {
		return [self openURL:url];
	} else {
		return YES;
	}
}
@end

@interface WebBrowserViewController ()
{
	NJKWebViewProgress *_progressProxy;
}
@property (nonatomic, strong, readonly) UIButton *backBarButtonItem;
@property (nonatomic, strong, readonly) UIButton *forwardBarButtonItem;
@property (nonatomic, strong, readonly) UIButton *refreshBarButtonItem;
@property (nonatomic, strong, readonly) UIButton *stopBarButtonItem;
@property (nonatomic, strong, readonly) UIButton *actionBarButtonItem;
@property (nonatomic, strong, readonly) UIButton *homeBarButtonItem;
@property (nonatomic, strong, readonly) UIButton *closeBarButtonItem;
//@property (nonatomic, strong, readonly) UIActionSheet *pageActionSheet;
@property (nonatomic, strong) CustomProgressView *progressBar;

- (void)goBackClicked:(UIButton *)sender;
- (void)goForwardClicked:(UIButton *)sender;
- (void)reloadClicked:(UIButton *)sender;
- (void)stopClicked:(UIButton *)sender;
- (void)homeClicked:(UIButton *)sender;
- (void)actionButtonClicked:(UIButton *)sender;
@end

@implementation WebBrowserViewController
@synthesize availableActions;
@synthesize URL, mainWebView, bodyString;
@synthesize backBarButtonItem, forwardBarButtonItem, refreshBarButtonItem, stopBarButtonItem, actionBarButtonItem, homeBarButtonItem, closeBarButtonItem;//, pageActionSheet;
@synthesize progressBar;
//@synthesize isSimpleMode;

#pragma mark - Initialization

- (id)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL {
    
    if(self = [super init]) {
        
        
        mainWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        //    mainWebView.delegate = self;
        [mainWebView.scrollView setContentInset:UIEdgeInsetsMake(0.0, 0.0, 38.0, 0.0)];
        [mainWebView.scrollView setScrollIndicatorInsets:mainWebView.scrollView.contentInset];
        //    mainWebView.scalesPageToFit = YES;
        
        _progressProxy = [[NJKWebViewProgress alloc] init];
        mainWebView.delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        
        //    [self loadURL:self.URL];
       
        
        self.URL = pageURL;
        //        self.availableActions = WebBrowserViewControllerAvailableActionsOpenInSafari | WebBrowserViewControllerAvailableActionsCopyLink | WebBrowserViewControllerAvailableActionsMailLink | WebBrowserViewControllerAvailableActionsOpenInChrome;
        boolLoaded = NO;
        postMethod = NO;
    }
    
    return self;
}

- (void)loadURL{
	NSLog(@"loadURL");
    
    postMethod = NO;
//    self.URL = [NSURL URLWithString:url];
    if (boolLoaded == NO){
        [self.mainWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
        boolLoaded = YES;
    } else {
        [self.mainWebView reload];
    }
}


- (void)loadURLwithBody:(NSString *)bd{
    
    NSLog(@"loadURL %@ body %@",self.URL,bd);
    self.bodyString = bd;
    
    postMethod = YES;
    if (boolLoaded == NO)
    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:self.URL];
        [request setHTTPMethod: @"POST"];
        
        NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        
        [request setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];

        
        [request setHTTPBody:[NSData dataWithBytes:[bd UTF8String] length:strlen([bd UTF8String])]];
        
        
        [self.mainWebView loadRequest: request];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        if(connection) {
            NSLog(@"connection %@",connection);
            [self.mainWebView loadRequest:request];
     
        }
    } else {
        NSLog(@"URL Request(reload) : %@\n", self.URL);
        [self.mainWebView reload];
    }
    mainWebView.scalesPageToFit = YES;
}


#pragma mark - View lifecycle

- (void)loadView {
}



- (void)viewDidLoad {
	[super viewDidLoad];
     self.view = mainWebView;
	[self.navigationController setNavigationBarHidden:YES];
//	self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
	self.view.backgroundColor = [UIColor clearColor];
	
	CGFloat statusBarHeight = 0.0;
    
	UIImageView *bottomBarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, self.view.bounds.size.height-38.0-statusBarHeight, self.view.bounds.size.width, 38.0)];
	[bottomBarBackground setImage:[UIImage imageNamed:@"webview_btnbg.png"]];
	[bottomBarBackground setUserInteractionEnabled:YES];

	backBarButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 3.0, 31.0, 31.0)];
	[backBarButtonItem addTarget:self action:@selector(goBackClicked:) forControlEvents:UIControlEventTouchUpInside];
	[backBarButtonItem setImage:[UIImage imageNamed:@"webview_btn_01_actv.png"] forState:UIControlStateNormal];
	[backBarButtonItem setImage:[UIImage imageNamed:@"webview_btn_01_disv.png"] forState:UIControlStateDisabled];
	
	forwardBarButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backBarButtonItem.frame)+30.0, 3.0, 31.0, 31.0)];
	[forwardBarButtonItem addTarget:self action:@selector(goForwardClicked:) forControlEvents:UIControlEventTouchUpInside];
	[forwardBarButtonItem setImage:[UIImage imageNamed:@"webview_btn_02_actv.png"] forState:UIControlStateNormal];
	[forwardBarButtonItem setImage:[UIImage imageNamed:@"webview_btn_02_disv.png"] forState:UIControlStateDisabled];

	homeBarButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(forwardBarButtonItem.frame)+30.0, 3.0, 31.0, 31.0)];
	[homeBarButtonItem addTarget:self action:@selector(homeClicked:) forControlEvents:UIControlEventTouchUpInside];
	[homeBarButtonItem setImage:[UIImage imageNamed:@"webview_btn_03.png"] forState:UIControlStateNormal];
	
	closeBarButtonItem = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-31.0-20.0, 3.0, 31.0, 31.0)];
	[closeBarButtonItem addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[closeBarButtonItem setImage:[UIImage imageNamed:@"webview_btn_04.png"] forState:UIControlStateNormal];

	[bottomBarBackground addSubview:backBarButtonItem];
	[bottomBarBackground addSubview:forwardBarButtonItem];
	[bottomBarBackground addSubview:homeBarButtonItem];
	[bottomBarBackground addSubview:closeBarButtonItem];
	
	progressBar = [[CustomProgressView alloc] initWithFrame:CGRectMake(0.0, -2.0, bottomBarBackground.frame.size.width, 2.0)];
	[progressBar setTrackColor:[UIColor colorWithWhite:0.75 alpha:1.0]];
	[progressBar setProgressColor:[UIColor colorWithRed:0.1 green:0.5 blue:1.0 alpha:1.0]];
	[bottomBarBackground addSubview:progressBar];
	[progressBar setAlpha:0.0];

	[self.view addSubview:bottomBarBackground];
//	[bottomBarBackground release];

    [self updateToolbarItems:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"WebBrowserViewController needs to be contained in a UINavigationController.");
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
//	[self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [mainWebView stopLoading];
//    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    
//    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
//}

//- (void)dealloc
//{
//    [mainWebView stopLoading];
// 	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    mainWebView.delegate = nil;
////	[mainWebView release];
//	[backBarButtonItem release];
//	[forwardBarButtonItem release];
//	[refreshBarButtonItem release];
//	[stopBarButtonItem release];
//	[actionBarButtonItem release];
//	[closeBarButtonItem release];
//	[homeBarButtonItem release];
//    [progressBar release];
//    mainWebView = nil;
//    backBarButtonItem = nil;
//    forwardBarButtonItem = nil;
//    refreshBarButtonItem = nil;
//    stopBarButtonItem = nil;
//    actionBarButtonItem = nil;
//    closeBarButtonItem = nil;
////    pageActionSheet = nil;
//    homeBarButtonItem = nil;
//    progressBar = nil;
//	[super dealloc];
//}


//- (UIActionSheet *)pageActionSheet {
//    
//    if(!pageActionSheet) {
//        pageActionSheet = [[UIActionSheet alloc]
//						   initWithTitle:self.mainWebView.request.URL.absoluteString
//						   delegate:self
//						   cancelButtonTitle:nil
//						   destructiveButtonTitle:nil
//						   otherButtonTitles:nil];
//		
//        if((self.availableActions & WebBrowserViewControllerAvailableActionsCopyLink)
//		   == WebBrowserViewControllerAvailableActionsCopyLink) {
//			[pageActionSheet addButtonWithTitle:@"URL 복사"];
//		}
//        
//		if([MFMailComposeViewController canSendMail]
//		   && (self.availableActions & WebBrowserViewControllerAvailableActionsMailLink)
//		   == WebBrowserViewControllerAvailableActionsMailLink) {
//            [pageActionSheet addButtonWithTitle:@"메일로 보내기"];
//        }
//
//        if((self.availableActions & WebBrowserViewControllerAvailableActionsOpenInSafari)
//		   == WebBrowserViewControllerAvailableActionsOpenInSafari) {
//            [pageActionSheet addButtonWithTitle:@"사파리로 열기"];
//        }
//		
//        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlechrome://"]]
//		   && (self.availableActions & WebBrowserViewControllerAvailableActionsOpenInChrome)
//		   == WebBrowserViewControllerAvailableActionsOpenInChrome) {
//            [pageActionSheet addButtonWithTitle:@"크롬으로 열기"];
//        }
//		
//        [pageActionSheet addButtonWithTitle:@"취소"];
//        pageActionSheet.cancelButtonIndex = [self.pageActionSheet numberOfButtons]-1;
//    }
//    
//    return pageActionSheet;
//}

#pragma mark - Toolbar

- (void)updateToolbarItems:(BOOL)isConnecting {
	if (isConnecting == YES) {
		[progressBar setAlpha:1.0];
	} else {
//		[progressBar setProgress:1.0];
		[UIView animateWithDuration:0.3 animations:^{
			[progressBar setAlpha:0.0];
		}];
	}

	self.backBarButtonItem.enabled = self.mainWebView.canGoBack;
    self.forwardBarButtonItem.enabled = self.mainWebView.canGoForward;
    
//	NSArray *items;
//	if (isSimpleMode) {
//		UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//		items = [NSArray arrayWithObjects:
//				 flexibleSpace,
//				 self.backBarButtonItem,
//				 flexibleSpace,
//				 self.forwardBarButtonItem,
//				 flexibleSpace,
//				 self.homeBarButtonItem,
//				 flexibleSpace,
//				 self.closeBarButtonItem,
//				 flexibleSpace,
//				 nil];
//		[flexibleSpace release];
//		
//	} else {
//		self.actionBarButtonItem.enabled = !isConnecting;
//		UIBarButtonItem *refreshStopBarButtonItem = isConnecting ? self.stopBarButtonItem : self.refreshBarButtonItem;
//	
//		if(self.availableActions == 0) {
//			UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//			items = [NSArray arrayWithObjects:
//					 flexibleSpace,
//					 self.backBarButtonItem,
//					 flexibleSpace,
//					 self.forwardBarButtonItem,
//					 flexibleSpace,
//					 refreshStopBarButtonItem,
//					 flexibleSpace,
//					 self.closeBarButtonItem,
//					 flexibleSpace,
//					 nil];
//			[flexibleSpace release];
//		} else {
//			UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//			UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//			fixedSpace.width = 5.0f;
//
//			items = [NSArray arrayWithObjects:
//					 fixedSpace,
//					 self.backBarButtonItem,
//					 flexibleSpace,
//					 self.forwardBarButtonItem,
//					 flexibleSpace,
//					 refreshStopBarButtonItem,
//					 flexibleSpace,
//					 self.actionBarButtonItem,
//					 flexibleSpace,
//					 self.closeBarButtonItem,
//					 fixedSpace,
//					 nil];
//			[flexibleSpace release];
//			[fixedSpace release];
//		}
//	}
//	self.toolbarItems = items;
}


#pragma mark -
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
      NSURL *url = [request URL];
    NSLog(@"redirect_url %@",url);
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems:NO];
	
	NSLog(@"ERROR CODE %i",(int)[error code]);
	if (error.code != NSURLErrorCancelled && error.code != 101) {
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:@"페이지에 연결할 수 없습니다.\n잠시 후 다시 시도해 주세요." delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil];
//		alert.tag = 999;
//		[alert show];
        
        [CustomUIKit popupSimpleAlertViewOK:@"오류" msg:@"페이지에 연결할 수 없습니다.\n잠시 후 다시 시도해 주세요." con:self];
//		NSString* errorString = [NSString stringWithFormat:
//                                 @"<html><center><font size=+7><br>페이지에 연결할 수 없습니다.<br>잠시 후 다시 시도해 주세요.<p>%@</font></center></html>",
//                                 error.localizedDescription];
//		[webView loadHTMLString:errorString baseURL:nil];
		
	}
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
	[progressBar setProgress:progress];

	if (progress == 0.0) {
		[self updateToolbarItems:YES];
	} else if (progress == 1.0) {
		[self updateToolbarItems:NO];
	}
}
#pragma mark - Target actions

- (void)goBackClicked:(UIBarButtonItem *)sender {
    [mainWebView goBack];
}

- (void)goForwardClicked:(UIBarButtonItem *)sender {
    [mainWebView goForward];
}

- (void)reloadClicked:(UIBarButtonItem *)sender {
    [mainWebView reload];
}

- (void)stopClicked:(UIBarButtonItem *)sender {
    [mainWebView stopLoading];
	[self updateToolbarItems:NO];
}

- (void)homeClicked:(UIBarButtonItem *)sender {
    if(postMethod){
        [self loadURLwithBody:self.bodyString];
    }
    else{
    [self loadURL];//:self.URL];
    }
}

//- (void)actionButtonClicked:(id)sender {
//    
//    if(pageActionSheet)
//        return;
//	
//	[self.pageActionSheet showFromToolbar:self.navigationController.toolbar];
//}

- (void)doneButtonClicked:(id)sender {
	[mainWebView stopLoading];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[progressBar setAlpha:0.0];
	
    [self dismissViewControllerAnimated:YES completion:^{
		NSLog(@"Webbrowser DID DissMiss");

//		[SharedAppDelegate.viewControllerForPresentation.view removeFromSuperview];
	}];
	
}

#pragma mark -
#pragma mark UIActionSheetDelegate

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//	NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
//	
//	if([title localizedCompare:@"사파리로 열기"] == NSOrderedSame) {
//        [[UIApplication sharedApplication] openURL:self.mainWebView.request.URL toSafari:YES];
//		
//    } else if([title localizedCompare:@"크롬으로 열기"] == NSOrderedSame) {
//        NSURL *inputURL = self.mainWebView.request.URL;
//        NSString *scheme = inputURL.scheme;
//        
//        NSString *chromeScheme = nil;
//        if ([scheme isEqualToString:@"http"]) {
//            chromeScheme = @"googlechrome";
//        } else if ([scheme isEqualToString:@"https"]) {
//            chromeScheme = @"googlechromes";
//        }
//        
//        if (chromeScheme) {
//            NSString *absoluteString = [inputURL absoluteString];
//            NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
//            NSString *urlNoScheme =
//            [absoluteString substringFromIndex:rangeForScheme.location];
//            NSString *chromeURLString =
//            [chromeScheme stringByAppendingString:urlNoScheme];
//            NSURL *chromeURL = [NSURL URLWithString:chromeURLString];
//            
//            [[UIApplication sharedApplication] openURL:chromeURL];
//        }
//    } else if([title localizedCompare:@"URL 복사"] == NSOrderedSame) {
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        pasteboard.string = self.mainWebView.request.URL.absoluteString;
//		[SVProgressHUD showSuccessWithStatus:@"URL이 클립보드에\n저장되었습니다."];
//		
//    } else if([title localizedCompare:@"메일로 보내기"] == NSOrderedSame) {
//		MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
//		mailViewController.mailComposeDelegate = self;
//        [mailViewController setSubject:[self.mainWebView stringByEvaluatingJavaScriptFromString:@"document.title"]];
//  		[mailViewController setMessageBody:self.mainWebView.request.URL.absoluteString isHTML:NO];
//		mailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
//        [self presentViewController:mailViewController animated:YES completion:NULL];
//		[mailViewController release];
//	}
//    
//    pageActionSheet = nil;
//	[pageActionSheet release];
//}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//	if (alertView.tag == 999) {
		[self doneButtonClicked:nil];
//	}
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
	switch (result)
    {
        case MFMailComposeResultSaved:
			[CustomUIKit popupSimpleAlertViewOK:nil msg:@"메일이 저장되었습니다.\n메일 앱의 '임시저장'에서 확인해보세요." con:self];
            break;
        case MFMailComposeResultSent:
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"메일을 성공적으로 전송하였습니다." con:self];
            break;
        case MFMailComposeResultFailed:
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"메일 전송에 실패하였습니다.\n잠시 후 다시 시도해 주세요." con:self];
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
