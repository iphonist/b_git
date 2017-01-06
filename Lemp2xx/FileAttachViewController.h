//
//  FileAttachViewController.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 3. 13..
//  Copyright (c) 2014년 BENCHBEE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropboxViewController.h"
#import "PostViewController.h"

@interface FileAttachViewController : UIViewController < UITableViewDataSource, UITableViewDelegate >
{
	UITableView *myTable;
}

@property (nonatomic, assign) PostViewController *postViewController;
@property (nonatomic, retain) NSArray *attachTypes;
@end
