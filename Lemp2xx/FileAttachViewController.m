//
//  FileAttachViewController.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 3. 13..
//  Copyright (c) 2014년 BENCHBEE. All rights reserved.
//

#import "FileAttachViewController.h"
#import <DropboxSDK/DropboxSDK.h>

static NSUInteger const kDBSignInAlertViewTag = 1;

@interface FileAttachViewController ()

@end

@implementation FileAttachViewController
@synthesize attachTypes;
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
		attachTypes = [[NSArray alloc] init];
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.translucent = NO;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
	
//	if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//		self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//		self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//	}
	
    self.view.backgroundColor = RGB(251,251,251);
    
#ifdef BearTalk
    self.view.backgroundColor = RGB(238, 242, 245);
#endif
	self.title = @"첨부 파일";
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"취소" style:UIBarButtonItemStyleDone target:self action:@selector(close)];
	self.navigationItem.rightBarButtonItem = rightButton;
//	[rightButton release];
    
    
    float viewY = 64;
    
	CGRect tableFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-viewY);
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//		tableFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-44.0-20.0);
//	}
	
	myTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	myTable.delegate = self;
	myTable.dataSource = self;
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
	myTable.rowHeight = 50.0;
	[self.view addSubview:myTable];
	
	NSLog(@"self.navigationController.presentingViewController %@",self.navigationController.presentingViewController);
	
	if (self.postViewController.dropboxLastPath) {
		[self openDropboxBrowser:YES];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc
//{
////	[attachTypes release];
//	attachTypes = nil;
//	
//	[myTable release];
//	[super dealloc];
//}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    attachTypes = nil;
}
- (void)close
{
	if (self.postViewController.dropboxLastPath) {
//		[self.postViewController.dropboxLastPath release];
		self.postViewController.dropboxLastPath = nil;
	}
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger numberOfRow = [attachTypes count];
	// table Row
	
	return numberOfRow;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
		// alloc Cell
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	// set Cell
	cell.textLabel.text = attachTypes[indexPath.row];
	
	if ([cell.textLabel.text isEqualToString:@"Dropbox"]) {
		cell.imageView.image = [UIImage imageNamed:@"dropboxlogo.png"];
	} else {
		cell.imageView.image = nil;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// cell select action
	
	if ([attachTypes[indexPath.row] isEqualToString:@"Dropbox"]) {
		if (![[DBSession sharedSession] isLinked]) {
//			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Dropbox 로그인 후 파일 첨부가 가능합니다. Dropbox에 연결하시겠습니까?" message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"연 결", nil];
//			alertView.tag = kDBSignInAlertViewTag;
//			[alertView show];
//			[alertView release];
            [CustomUIKit popupAlertViewOK:nil msg:@"Dropbox 로그인 후 파일 첨부가 가능합니다. Dropbox에 연결하시겠습니까?" delegate:self tag:kDBSignInAlertViewTag sel:@selector(confirmDBSignOK) with:nil csel:nil with:nil];
		} else {
			[self openDropboxBrowser:NO];
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
	}
}

- (void)confirmDBSignOK{
    
				[[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(goDropbox)
                                                             name:@"updateContent"
                                                           object:nil];
    [[DBSession sharedSession] linkFromController:self];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kDBSignInAlertViewTag) {
		[myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];

        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                [self confirmDBSignOK];
                break;
            default:
                break;
        }
    }
}

- (void)goDropbox
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self openDropboxBrowser:NO];
}
#pragma mark - Open Browser
- (void)openDropboxBrowser:(BOOL)warpPath
{
	DropboxViewController *dropView = [[DropboxViewController alloc] init];
	dropView.shouldDisplaySearchBar = NO;
	dropView.delegate = self.postViewController;
	// 워드 엑셀 pdf ppt hwp

    
    dropView.allowedFileTypes = @[@"doc",@"docx",@"xls",@"xlsx",@"ppt",@"pptx",@"pdf",@"hwp"];

	if (warpPath) {
		dropView.warpPath = self.postViewController.dropboxLastPath;
	}
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[dropView class]])
	[self.navigationController pushViewController:dropView animated:!warpPath];
    });
//	[dropView release];
	
}
@end
