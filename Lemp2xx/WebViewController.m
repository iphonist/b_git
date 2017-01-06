//
//  WebViewController.m
//  Skying
//
//  Created by 백인구 on 11. 5. 21..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "WebViewController.h"
@implementation WebViewController
@synthesize myWebView;


- (void)loadURL:(NSString *)url
{
    NSLog(@"loadURL %@",url);
	myWebView.hidden = TRUE;
	if (boolLoaded == NO)
	{
		NSLog(@"URL Request : %@\n", url);
        
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
		NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		if(connection) {
            //			[self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
			[self.myWebView loadRequest:request];
			boolLoaded = YES;
            
            
		}
		
	} else {
		NSLog(@"URL Request(reload) : %@\n", url);
		[self.myWebView reload];
	}
}

- (void)loadFromDB:(NSString *)path{
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *r = [NSURLRequest requestWithURL:url];
    NSLog(@"url %@ r %@",url,r);
    [self loadRequest:r];
}


- (void)loadRequest:(NSURLRequest *)r
{
	if (boolLoaded == NO){
		[self.myWebView loadRequest:r];
		boolLoaded = YES;
	} else {
		[self.myWebView reload];
	}
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (void)backTo{
    NSLog(@"backto");
    NSLog(@"self.presentingViewController %@",self.presentingViewController);
if (self.presentingViewController) {
    [self dismissViewControllerAnimated:YES completion:nil];
} else {
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	NSLog(@"webViewDidStartLoad %@",self.myWebView.request.URL.absoluteString);
    //    NSLog(@"webViewDidStartLoad searchBar %@",addressField.text);
    
	if(progressing == NO) {
		MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
		hud.animationType = MBProgressHUDAnimationZoom;
		hud.mode = MBProgressHUDModeIndeterminate;
		hud.userInteractionEnabled = NO;
		hud.opacity = 0.4;
		progressing = YES;
	}
	// starting the load, show the activity indicator in the status bar
    //	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //	[activity startAnimating];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSLog(@"FIniSH Load");
//    [addressField setText:self.myWebView.request.URL.absoluteString];
//    currentTitle = [[NSString alloc]initWithFormat:@"%@",[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
//    NSLog(@"currentTitle %@",currentTitle);
    NSLog(@"webViewDidFinishLoad %@",self.myWebView.request.URL.absoluteString);
    //    NSLog(@"webViewDidFinishLoad searchBar %@",addressField.text);
	if (progressing == YES)
	{
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		progressing = NO;
	}
    
    //	id AppID = [[UIApplication sharedApplication] delegate];
    //	[AppID closeHudProgress];
	
	
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //	[activity stopAnimating];
    
	myWebView.hidden = FALSE;
	

    
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //	[activity stopAnimating];
	
	NSLog(@"error code %d",(int) [error code]);
	if (progressing == YES)
	{
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		progressing = NO;
	}	
	// report the error inside the webview
	if ([error code] != -999) {
		NSString* errorString = [NSString stringWithFormat:
                                 @"<html><center><font size=+7 color='red'>연결 상태가 좋지 않습니다.<br>잠시 후 다시 시도해 주세요.<p>%@</font></center></html>",
                                 //@"<html><center><font size=+5 color='red'>SORRY<br><img src='file://popup_levelup_12.png'><br>SORRY<p></font></center></html>",
                                 error.localizedDescription];
		[self.myWebView loadHTMLString:errorString baseURL:nil];
	}
}


#pragma mark NSURLConnection delegate
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}



#pragma mark -
#pragma mark UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
//	self.myWebView.delegate = self;	// setup the delegate as the web view is shown
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	//[self.myWebView stopLoading];	// in case the web vie is still loading its content
//	self.myWebView.delegate = nil;	// disconnect the delegate as the webview is hidden
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	// we support rotation in this view controller
//	return NO;
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
    self.view.backgroundColor = [UIColor blackColor];
    
//    addressField = [[UISearchBar alloc]init];
    
    //	CGRect webFrame = [[UIScreen mainScreen] applicationFrame];
    //		webFrame.origin.y -= 20.0;
    //		self.myWebView = [[UIWebView alloc]initWithFrame:webFrame];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoStarted:) name:@"UIMoviePlayerControllerDidEnterFullcreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished:) name:@"UIMoviePlayerControllerDidExitFullcreenNotification" object:nil];
    
}


#pragma mark - browser

- (id)init//WithAddress:(BOOL)address //url:(NSString *)url
{
    self = [super init];
    if(self != nil)
    {
		
		boolLoaded = NO;
		progressing = NO;
		
		self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
		self.myWebView.backgroundColor = [UIColor whiteColor];
		self.myWebView.scalesPageToFit = YES;
		self.myWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		self.myWebView.delegate = self;
		
		[self.view addSubview:self.myWebView];

//        if(address) // 주소창
//        {
//            self.title = @"브라우저";
//            
//            UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self.viewDeckController selector:@selector(toggleLeftView) frame:CGRectMake(0, 0, 35, 32) 
//                                           imageNamedBullet:nil imageNamedNormal:@"n02_chat_menu06_normal.png" imageNamedPressed:nil];
//            UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//            self.navigationItem.leftBarButtonItem = btnNavi;
//            [btnNavi release];
//            [button release];
//            
//            [self updateToolbar];
//            [self setAddressBar];
//        
//            if(url != nil && [url length]>0)
//                [self gotoAddress:url];
//        }
    }
    return self;
    
}
//
//
//
//- (void)updateToolbar
//{
//    // toolbar
//    //    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 480 - 50, 320, 50)];
//    
//    
//    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goBack:)];
//    UIBarButtonItem* forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(goForward:)];
//    
//    
////    UIBarButtonItem* stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopLoading:)];
//    
//    
//    UIBarButtonItem* reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];
//    
//    UIBarButtonItem* bookmarkButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(loadBookmark:)];
//    
//    UIBarButtonItem* pickButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet:)];
//    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 480-kNAVIBAR_HEIGHT-kSTATUS_HEIGHT-44, 320, 44)];
//    
//    [toolbar setItems:[NSArray arrayWithObjects:backButton, flexibleSpace, forwardButton, flexibleSpace, reloadButton, flexibleSpace, bookmarkButton, flexibleSpace, pickButton, nil]];
//    
//    [self.view addSubview:toolbar];
//    
//    
//    
//}
//
//
//- (void)setAddressBar
//{
//    
//    //    UITextField *addressField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 280, 35)];
//    //    
//    //    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
//    //    
//    //    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    //    
//    //    UIToolbar *addressBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, kNAVIBAR_HEIGHT+kSTATUS_HEIGHT, 320, 44)];
//    //    
//    //    [addressBar setItems:[NSArray arrayWithObjects:addressField, cancelButton, nil]];
//    //    
//    //    [self.view addSubview:addressBar];
//    addressField.frame = CGRectMake(0, 0, 320, 35);
//    addressField.keyboardType = UIKeyboardTypeURL;
//    addressField.placeholder = @"URL을 입력하세요.";
//    addressField.delegate = self;
//    addressField.showsCancelButton = NO;
//    [self.view addSubview:addressField];
//    
//    self.myWebView.frame = CGRectMake(0, addressField.frame.size.height, 320, 480-kSTATUS_HEIGHT-addressField.frame.size.height);
//    
//}
//# pragma mark - searchBar Delegate
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar // 서치바 터치하는 순간 들어옴.
//{
//    //    NSLog(@"searchBarTextDidBeginEditing %@",self.myWebView.request.URL.absoluteString);
//    //    searchBar.text = @"http://";
//    [searchBar setShowsCancelButton:YES animated:YES];
//}	
//
//
//// 취소 버튼 누르면 키보드 내려가기
//- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 취소 버튼을 눌렀을 때 들어오는 함수. 키보드를 내린다.
//     param - searchBar(UISearchBar *) : 검색바
//     연관화면 : 검색
//     ****************************************************************/
//    
//    [searchBar resignFirstResponder]; // 키보드 내리기
//    [searchBar setShowsCancelButton:NO animated:YES];
//    
//}
//
//// 키보드의 검색 버튼을 누르면
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    //    NSLog(@"searchBarSearchButtonClicked %@",self.myWebView.request.URL.absoluteString);
//    //    NSLog(@"searchBarSearchButtonClicked searchBar %@",addressField.text);
//    
//    NSString *sendUrl = searchBar.text;
//    
//    if(![sendUrl hasPrefix:@"http"])
//        sendUrl = [@"http://" stringByAppendingString:searchBar.text];
//    
//    [self gotoAddress:sendUrl];
//    
//}
//
//- (void)gotoAddress:(NSString *)address
//{
//        NSLog(@"gotoAddress %@",address);
//    //    NSLog(@"gotoAddress searchBar %@",addressField.text);
//    //       [self loadURL:address];
//    
//    NSURL *url = [NSURL URLWithString:address];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.myWebView loadRequest:request];
//    [addressField resignFirstResponder];
//    
//}
//
//
//
//
//- (void)reload:(id)sender
//{
//    [self.myWebView reload];
//}
//
//- (void)goBack:(id)sender
//{
//    [self.myWebView goBack];   
//}
//- (void)goForward:(id)sender
//{
//    [self.myWebView goForward];
//}
//- (void)stopLoading:(id)sender
//{
//    [self.myWebView stopLoading];
//}
//
//- (void)loadBookmark:(id)sender
//{
//    HistoryViewController *historyController = [[HistoryViewController alloc]initWithTag:2];
//    [historyController setDelegate:self selector:@selector(sendBookmark:)];
//    UINavigationController *nc = [[[CBNavigationController alloc]initWithRootViewController:historyController]autorelease];
//    [historyController release];
//    [self.navigationController presentViewController:nc animated:YES];
//    
//}
//- (void)sendBookmark:(NSString*)url
//{
//    [self gotoAddress:url];
//}
//- (void)showActionSheet:(id)sender
//{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
//                                               destructiveButtonTitle:nil otherButtonTitles:@"타임라인에 올리기", @"채팅 메시지로 보내기", @"책갈피에 추가하기",nil];
//    //    [actionSheet showInView:self.parentViewController.tabBarController.view];
//    [actionSheet showInView:self.view];
//    [actionSheet release];
//    
//}

#pragma mark - ActionSheet Delegate
//-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 내 사진을 눌렀을 때의 액션시트에서 선택한 버튼에 따른 동작을 설정
//     param  - actionSheet(UIActionSheet *) : 액션시트
//     - buttonIndex(NSInteger) : 액션시트 몇 번째 버튼인지
//     연관화면 : 내 상태 변경
//     ****************************************************************/
//    
//  
//    
//        if(buttonIndex == 0)
//        {
//            [CustomUIKit popupAlertViewOK:nil msg:@"현재 제공되지 않는 기능입니다."];
//    
//        }
//        else if(buttonIndex == 1)
//        { 
//        if(self.myWebView.request.URL.absoluteString == nil || [self.myWebView.request.URL.absoluteString length]<1)
//                [CustomUIKit popupAlertViewOK:nil msg:@"보낼 URL이 없습니다."];    
//         
//        else{
//            
//            UrlContactController *urlController;
//            UINavigationController *nc;
////            NSLog(@"currentTitle %@",currentTitle);
//            NSString *titleMsg = [NSString stringWithFormat:@"%@ %@",[self.myWebView stringByEvaluatingJavaScriptFromString:@"document.title"],self.myWebView.request.URL.absoluteString];
//            NSLog(@"msg %@",titleMsg);
//            urlController = [[UrlContactController alloc]initWithMsg:titleMsg];
//            nc = [[[CBNavigationController alloc]initWithRootViewController:urlController]autorelease];
//            [urlController release];
//            [self.navigationController presentViewController:nc animated:YES];
//        }
//        }
//    
//    else if(buttonIndex == 2){
//        
//            if(self.myWebView.request.URL.absoluteString == nil || [self.myWebView.request.URL.absoluteString length]<1)
//                [CustomUIKit popupAlertViewOK:nil msg:@"추가할 URL이 없습니다."];    
//            else{
//            
//            
//                NSMutableArray *bookmarks = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"Bookmarks"] mutableCopy];
//                                if (!bookmarks){
//                    bookmarks = [[NSMutableArray alloc] init];
//                }
//                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[self.myWebView stringByEvaluatingJavaScriptFromString:@"document.title"],@"title",self.myWebView.request.URL.absoluteString,@"url", nil];
//                [bookmarks addObject:dic];//elf.myWebView.request.URL.absoluteString];
//                NSLog(@"addBookmark %@",bookmarks);
//                [[NSUserDefaults standardUserDefaults] setObject:bookmarks forKey:@"Bookmarks"];
//                [bookmarks release];
//
//                [CustomUIKit popupAlertViewOK:nil msg:@"책갈피에 추가되었습니다."];
//        }
//        }
//
//    
//}




- (void)videoStarted:(NSNotification*)noti
{
    self.tabBarController.view.hidden = YES;
}

- (void)videoFinished:(NSNotification*)noti
{
    self.tabBarController.view.hidden = NO;
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    //	NSLog(@"WebViewController dealloc (release)\n");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIMoviePlayerControllerDidEnterFullcreenNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIMoviePlayerControllerDidExitFullcreenNotification" object:nil];
//	myWebView.delegate = nil;
//    [myWebView release];
//    myWebView = nil;
//	[super dealloc];
}


@end
