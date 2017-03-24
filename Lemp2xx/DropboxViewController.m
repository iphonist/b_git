//
//  DropboxViewController.m
//  DBRoulette
//
//  Created by HyeongJun Park on 2014. 3. 6..
//
//

#import "DropboxViewController.h"

static NSUInteger const kDBSignInAlertViewTag = 1;
static NSUInteger const kDBDownloadAlertViewTag = 2;

@interface DropboxViewController ()
@end

@implementation DropboxViewController
@synthesize currentPath;
@synthesize warpPath;
@synthesize tableCellID;
@synthesize fileList;
@synthesize allowedFileTypes;
@synthesize shouldDisplaySearchBar;
@synthesize selectedFilePath;

static NSString *currentFileName = nil;

#pragma mark  - View Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(updateContent)
													 name:@"updateContent"
												   object:nil];
        self.fileList = [[NSMutableArray alloc] init];
        NSLog(@"init");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.navigationController.navigationBar.translucent = NO;
    
	if (self.title == nil || [self.title isEqualToString:@""]) {
		self.title = @"Dropbox";
	}
	
	NSLog(@"currentPath %@",self.currentPath);
	if (self.currentPath == nil || [self.currentPath isEqualToString:@""]) {
		self.currentPath = @"/";
	}
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"cancel", @"cancel") style:UIBarButtonItemStyleDone target:self action:@selector(removeDropboxBrowser)];
	self.navigationItem.rightBarButtonItem = rightButton;
//	[rightButton release];
    
    
    float viewY = 64;
    
    
    CGRect tableFrame;
    tableFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-viewY);
    
    finderTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    finderTableView.delegate = self;
    finderTableView.dataSource = self;
    
    if ([finderTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [finderTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([finderTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [finderTableView setLayoutMargins:UIEdgeInsetsZero];
    }
//	finderTableView.tableFooterView
	
	[self.view addSubview:finderTableView];
    [finderTableView reloadData];

	if (shouldDisplaySearchBar == YES) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -44, 320, 44)];
        searchBar.delegate = self;
        searchBar.placeholder = [NSString stringWithFormat:@"찾기 %@", self.title];
        finderTableView.tableHeaderView = searchBar;
		
		searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        searchController.searchResultsDataSource = self;
        searchController.searchResultsDelegate = self;
        searchController.delegate = self;
		finderTableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
		
//		[searchBar release];
    }
	
	
	NSArray *pathComponents = [self.warpPath pathComponents];
	NSLog(@"PATH %@",pathComponents);
	if ([pathComponents count] > 1) {
		NSString *appendString = @"/";
		
		for (int i = 1; i < [pathComponents count]; i++) {
			if (i == [pathComponents count] - 1) {
				[self pushToSubDirectory:warpPath pushAnimate:NO lastPath:YES];
			} else {
				appendString = [appendString stringByAppendingPathComponent:[pathComponents objectAtIndex:i]];
				[self pushToSubDirectory:appendString pushAnimate:NO lastPath:NO];
			}

		}
	} else if ([self.currentPath isEqualToString:@"/"]) {
		[self listDirectoryAtPath:currentPath];
	}
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    if (![[DBSession sharedSession] isLinked]) {
        NSLog(@"viewwill 1");
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Dropbox 연동 후 파일 첨부가 가능합니다. Dropbox에 연결하시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:@"연 결", nil];
//        alertView.tag = kDBSignInAlertViewTag;
//        [alertView show];
//		[alertView release];
        [CustomUIKit popupAlertViewOK:nil msg:@"Dropbox 연동 후 파일 첨부가 가능합니다. Dropbox에 연결하시겠습니까?" delegate:self tag:kDBSignInAlertViewTag sel:@selector(confirmDBSignOK) with:nil csel:@selector(confirmDBSignCancel) with:nil];
    } else {
        NSLog(@"viewwill 2");
		if ([self.fileList count] == 0 && self.currentPath != nil && ![SVProgressHUD isVisible]) {
            NSLog(@"viewwill 3");
			[self listDirectoryAtPath:currentPath];
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
//	// release objects.
//    NSLog(@"dealloc");
	[[NSNotificationCenter defaultCenter] removeObserver:self];
//	[searchController release];
//	[fileList release];
//	self.fileList = nil;
//	self.selectedFilePath = nil;
//	[restClient release];
//	[finderTableView release];
//	[newSubdirectoryController release];
//	[super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.fileList = nil;
//    self.selectedFilePath = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeDropboxBrowser {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pushToSubDirectory:(NSString*)path pushAnimate:(BOOL)animate lastPath:(BOOL)isLastPath
{
    NSLog(@"finderTableView 2 %@",finderTableView);
//    newSubdirectoryController = [[DropboxViewController alloc] init];
    NSLog(@"finderTableView 3 %@",finderTableView);
//	newSubdirectoryController.delegate = self.delegate;
	NSString *subpath = [currentPath stringByAppendingPathComponent:path];
	self.currentPath = subpath;
	self.title = [subpath lastPathComponent];
	self.shouldDisplaySearchBar = self.shouldDisplaySearchBar;
	self.allowedFileTypes = self.allowedFileTypes;
	self.tableCellID = self.tableCellID;
    if (isLastPath) {
        NSLog(@"finderTableView 21 %@",finderTableView);
        [self listDirectoryAtPath:subpath];
        NSLog(@"finderTableView 22 %@",finderTableView);

    }
    
//    if(![self.navigationController.topViewController isKindOfClass:[newSubdirectoryController class]])
//{
//	[(CBNavigationController *)self.navigationController pushViewController:newSubdirectoryController animated:animate];
    
    NSLog(@"finderTableView 4 %@",finderTableView);
//    }
//else{
//}

}

#pragma mark - Files and Directories

- (NSArray *)allowedFileTypes {
    if (allowedFileTypes == nil) {
        allowedFileTypes = [NSArray array];
    }
    return allowedFileTypes;
}


#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if ([fileList count] == 0) {
        return 2;
    } else {
        return [fileList count];
    }
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
    NSLog(@"cellforrow");
    
    
	if ([fileList count] == 0) {
		UITableViewCell *cell = [[UITableViewCell alloc] init] ;
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.textLabel.textColor = [UIColor darkGrayColor];

        if (indexPath.row == 0) {
			if (isSearching == YES) {
                cell.textLabel.text = nil;
            } else {
                cell.textLabel.text = @"지원되는 형식의 파일이 없습니다.";
			}
        } else if (indexPath.row == 1) {
			if (isSearching == YES) {
                cell.textLabel.text = @"검색된 결과가 없습니다.";
            } else {
				cell.textLabel.text = @"지원형식 : doc,xls,ppt,pdf,hwp";
            }
        }
		return cell;

    } else {
        if (!tableCellID || [tableCellID isEqualToString:@""]) {
            tableCellID = @"DropboxBrowserCell";
        }
        
        // Create the table view cell
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DropboxBrowserCell"] ;
        }
        
		if (indexPath.row >= [fileList count]) {
			return cell;
		}

        DBMetadata *file = (DBMetadata *)[fileList objectAtIndex:indexPath.row];
        cell.textLabel.text = file.filename;
		NSLog(@"icon %@",file.icon);
        cell.imageView.image = [UIImage imageNamed:file.icon];
        
//        NSLocale *locale = [NSLocale currentLocale];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//		[formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//        [formatter setLocale:locale];

        if ([file isDirectory]) {
            // Folder
            cell.detailTextLabel.text = nil;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            // File
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", [formatter stringFromDate:file.lastModifiedDate], file.humanReadableSize];
			cell.detailTextLabel.text = file.humanReadableSize;
			cell.accessoryType = UITableViewCellAccessoryNone;
        }
		
//		[formatter release];
	
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([fileList count] == 0 || indexPath.row >= [fileList count]) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        selectedFile = (DBMetadata *)[fileList objectAtIndex:indexPath.row];
        NSLog(@"selectedFile %@",selectedFile);
        if ([selectedFile isDirectory]) {
            NSLog(@"isDirectory");
            NSLog(@"finderTableView 5 %@",finderTableView);
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self pushToSubDirectory:selectedFile.filename pushAnimate:YES lastPath:YES];
            NSLog(@"finderTableView 6 %@",finderTableView);
			
        } else {
			NSLog(@"totalBytes %lld",selectedFile.totalBytes);
			if (selectedFile.totalBytes > 20971520) { // 20971520 byte = 20 Megabyte
				[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"파일의 용량이 너무 큽니다!\n최대 20MB까지 첨부할 수 있습니다."]];
				[tableView deselectRowAtIndexPath:indexPath animated:YES];

			} else {
				currentFileName = selectedFile.filename;
				
				NSString *fileName = [NSString stringWithFormat:@"%@_%@",selectedFile.rev,selectedFile.filename];
				NSString *localPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
				
				self.selectedFilePath = localPath;
				if (NO == [self downloadFile:selectedFile]) {
					if ([self.delegate respondsToSelector:@selector(dropboxBrowser:didSelectFile:)]) {
						[self.delegate dropboxBrowser:self didSelectFile:selectedFile];
					}
				}
			}
        }
    }
}

#pragma mark - SearchBar Delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	isSearching = YES;
    [searchBar resignFirstResponder];
	[[self restClient] searchPath:currentPath forKeyword:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    isSearching = NO;
    [searchBar resignFirstResponder];
    [self listDirectoryAtPath:currentPath];
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    isSearching = YES;
//    
//	NSLog(@"SEARCH %@",searchBar.text);
//   if (![searchBar.text isEqualToString:@" "] || ![searchBar.text isEqualToString:@""]) {
//        [[self restClient] searchPath:currentPath forKeyword:searchBar.text];
//   }
//}

- (void)confirmDBSignCancel{
    
    [(CBNavigationController *)self.navigationController popToRootViewControllerWithBlockGestureAnimated:YES];
}
- (void)confirmDBSignOK{
    
    [[DBSession sharedSession] linkFromController:self];
}
- (void)confirmDBDownCancel{
    
				[finderTableView deselectRowAtIndexPath:[finderTableView indexPathForSelectedRow] animated:YES];
}
- (void)confirmDBDownOK{
    
				[self startDownloadFile];
				[[self restClient] loadFile:selectedFile.path intoPath:selectedFilePath];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kDBSignInAlertViewTag) {
        switch (buttonIndex) {
            case 0:
                [self confirmDBSignCancel];
                break;
            case 1:
                [self confirmDBSignOK];
                break;
            default:
                break;
        }
    } else if (alertView.tag == kDBDownloadAlertViewTag) {
		switch (buttonIndex) {
			case 0:
                [self confirmDBDownCancel];
				break;
            case 1:
                [self confirmDBDownOK];
				break;
			default:
				break;
		}
	}
}

#pragma mark - Content Refresh

- (void)updateTableData {
    NSLog(@"updateTableData");
    NSLog(@"finderTableView 7 %@",finderTableView);
    
	[SVProgressHUD dismiss];
    [finderTableView deselectRowAtIndexPath:[finderTableView indexPathForSelectedRow] animated:YES];
    [finderTableView reloadData];
}

- (void)updateContent {
    NSLog(@"finderTableView 8 %@",finderTableView);
    [self listDirectoryAtPath:currentPath];
}

#pragma mark - DataController Delegate

- (void)downloadedFile {
    finderTableView.userInteractionEnabled = YES;

    [UIView animateWithDuration:0.75 animations:^{
        finderTableView.alpha = 1.0;
    }];
    
    [finderTableView deselectRowAtIndexPath:[finderTableView indexPathForSelectedRow] animated:YES];
	
	[SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@\n다운로드 완료", currentFileName]];
    
	if ([self.delegate respondsToSelector:@selector(dropboxBrowser:didSelectFile:)]) {
		[self.delegate dropboxBrowser:self didSelectFile:selectedFile];
	}
}

- (void)startDownloadFile {
	finderTableView.userInteractionEnabled = NO;
	
	[UIView animateWithDuration:0.75 animations:^{
		finderTableView.alpha = 0.8;
	}];

	[SVProgressHUD showProgress:0.0 status:[NSString stringWithFormat:@"%@\n다운로드 준비 중...", currentFileName] maskType:SVProgressHUDMaskTypeGradient];
}

- (void)downloadedFileFailed {
    finderTableView.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.75 animations:^{
        finderTableView.alpha = 1.0;
    }];
	[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@\n다운로드 실패!", currentFileName]];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"오류"
                                                                                 message:[NSString stringWithFormat:@"%@\n파일을 다운로드 하지 못했습니다. 잠시 후 다시 시도해 주세요!", currentFileName]
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"ok")
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"오류" message:[NSString stringWithFormat:@"%@\n파일을 다운로드 하지 못했습니다. 잠시 후 다시 시도해 주세요!", currentFileName] delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil];
	[alert show];
//	[alert release];
    }
    self.navigationItem.title = [currentPath lastPathComponent];
    [finderTableView deselectRowAtIndexPath:[finderTableView indexPathForSelectedRow] animated:YES];
}

- (void)updateDownloadProgressTo:(CGFloat)progress {
	[SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"%@\n다운로드 중(%.0f%%)",currentFileName,progress*100] maskType:SVProgressHUDMaskTypeGradient];
}

#pragma mark - Dropbox File and Directory Functions

- (BOOL)listDirectoryAtPath:(NSString *)path {
    if ([[DBSession sharedSession] isLinked]) {
        [SVProgressHUD showWithStatus:@"불러오는 중..."];
        NSLog(@"finderTableView 9 %@",finderTableView);
        [[self restClient] loadMetadata:path];
        return YES;
    } else {
        return NO;
    }
}


- (BOOL)isDropboxLinked {
    return [[DBSession sharedSession] isLinked];
}

- (BOOL)downloadFile:(DBMetadata *)file {
    BOOL downloadFile = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *fileName = [NSString stringWithFormat:@"%@_%@",file.rev,file.filename];
    NSString *localPath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];

    if ([fileManager fileExistsAtPath:localPath] == NO) {
		downloadFile = YES;
//		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Dropbox에서 파일을 다운로드 후 첨부할 수 있습니다. 다운로드 하시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:@"다운로드", nil];
//		alertView.tag = kDBDownloadAlertViewTag;
//		[alertView show];
//		[alertView release];
        [CustomUIKit popupAlertViewOK:nil msg:@"Dropbox에서 파일을 다운로드 후 첨부할 수 있습니다. 다운로드 하시겠습니까?" delegate:self tag:kDBDownloadAlertViewTag sel:@selector(confirmDBDownOK) with:nil csel:@selector(confirmDBDownCancel) with:nil];
    }
    return downloadFile;
}


#pragma mark - DBRestClientDelegate methods

- (DBRestClient *)restClient {
    if (!restClient) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    NSMutableArray *dirList = [NSMutableArray array];
    
    NSLog(@"finderTableView 10 %@",finderTableView);
   
    if (metadata.isDirectory) {
        for (DBMetadata *file in metadata.contents) {
			if ([file isDirectory] || allowedFileTypes.count == 0 || [allowedFileTypes containsObject:[file.filename pathExtension]] ) {
				[dirList addObject:file];
				NSLog(@"FILENAME %@,PATH %@,isDir %@",file.filename,file.path,file.isDirectory?@"TRUE":@"FALSE");
			}
        }
    }
		
	NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"isDirectory" ascending:NO];
	NSArray *sortedList = [dirList sortedArrayUsingDescriptors:@[sortDesc]];
	
    NSLog(@"sortedList %@",sortedList);
    NSLog(@"self.file %@",self.fileList);
	if (self.fileList) {
        NSLog(@"self.file %@",self.fileList);
		[fileList removeAllObjects];
	}
    [fileList addObjectsFromArray:sortedList];
    NSLog(@"self.file %@",self.fileList);
    [self updateTableData];
}

- (void)restClient:(DBRestClient *)client loadedSearchResults:(NSArray *)results forPath:(NSString *)path keyword:(NSString *)keyword {
    NSLog(@"finderTableView 11 %@",finderTableView);
	NSMutableArray *filteredList = [NSMutableArray array];
	
	for (DBMetadata *file in results) {
		if (![file isDirectory] && [allowedFileTypes containsObject:[file.filename pathExtension]] ) {
			[filteredList addObject:file];
		}
	}

	if (self.fileList) {
		[fileList removeAllObjects];
	}
	[fileList addObjectsFromArray:filteredList];
    [self updateTableData];
}

- (void)restClient:(DBRestClient *)restClient searchFailedWithError:(NSError *)error {
	NSLog(@"SEARCH FAIL %@",error.description);
	if (self.fileList) {
		[fileList removeAllObjects];
	}
    [self updateTableData];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"SEARCH FAIL %@",error.description);
    [self updateTableData];
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath {
    [self downloadedFile];
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    NSLog(@"SEARCH FAIL %@",error.description);
    [self downloadedFileFailed];
}

- (void)restClient:(DBRestClient *)client loadProgress:(CGFloat)progress forFile:(NSString *)destPath {
    [self updateDownloadProgressTo:progress];
}


@end
