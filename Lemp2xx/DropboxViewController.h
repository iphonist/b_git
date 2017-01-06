//
//  DropboxViewController.h
//  DBRoulette
//
//  Created by HyeongJun Park on 2014. 3. 6..
//
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

/** @typedef kDBFileConflictError
 @abstract Error codes for file conflicts with Dropbox and Local files.
 @param kDBDropboxFileNewerError The Dropbox file was modified more recently than the local file, and is therefore newer.
 @param kDBDropboxFileOlderError The Dropbox file was modified after the local file, and is therefore older.
 @param kDBDropboxFileSameAsLocalFileError Both the Dropbox file and the local file were modified at the same time.
 @discussion These error codes are used with the \p dropboxBrowser:fileConflictWithLocalFile:withDropboxFile:withError: delegate method's error parameter. That delegate method is caled when there is a file conflict between a local file and a Dropbox file. */
typedef enum kDBFileConflictError : NSInteger {
    kDBDropboxFileNewerError = 1,
    kDBDropboxFileOlderError = 2,
    kDBDropboxFileSameAsLocalFileError = 3
} kDBFileConflictError;

@protocol DropboxDelegate;
@interface DropboxViewController : UIViewController < DBRestClientDelegate, UITableViewDataSource, UITableViewDelegate, DBRestClientDelegate, UISearchBarDelegate, UISearchDisplayDelegate >
{
	DBRestClient *restClient;
	DBMetadata *selectedFile;
	DropboxViewController *newSubdirectoryController;
	UITableView *finderTableView;
	BOOL isSearching;
	UISearchDisplayController *searchController;
}

- (DBRestClient *)restClient;
- (void)updateContent;
- (void)updateTableData;

- (void)downloadedFile;
- (void)startDownloadFile;
- (void)downloadedFileFailed;
- (void)updateDownloadProgressTo:(CGFloat)progress;

- (BOOL)listDirectoryAtPath:(NSString *)path;

@property (nonatomic, assign) id <DropboxDelegate> delegate;
@property (nonatomic, assign) BOOL shouldDisplaySearchBar;
@property (nonatomic, retain) NSString *currentPath;
@property (nonatomic, assign) NSString *warpPath;
@property (nonatomic, retain) NSString *selectedFilePath;
@property (nonatomic, retain) NSString *tableCellID;
@property (nonatomic, retain) NSMutableArray *fileList;
@property (nonatomic, retain) NSArray *allowedFileTypes;


- (BOOL)downloadFile:(DBMetadata *)file;
- (void)removeDropboxBrowser;

@end


@protocol DropboxDelegate <NSObject>

@optional
- (void)dropboxBrowser:(DropboxViewController *)browser didSelectFile:(DBMetadata*)metaData;

@end
