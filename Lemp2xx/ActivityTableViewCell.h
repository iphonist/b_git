//
//  ActivityTableViewCell.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 4. 4..
//  Copyright (c) 2014년 BENCHBEE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell
{
	NSMutableArray *likeArray;
	NSMutableArray *replyArray;
	NSMutableArray *urlArray;
	
	NSString *cid;
	NSString *uid;
	NSString *address;
	NSString *desc;
	NSString *position;
	NSString *deptName;
	NSString *createdTimeString;
	
	NSURL *mapImageURL;
	
	CGFloat latitude;
	CGFloat longitude;
	NSTimeInterval createdTimeInterval;

	NSInteger zoomLevel;
	NSInteger fileCount;

	BOOL isNotice;
}

@property (retain) NSMutableArray *likeArray;
@property (retain) NSMutableArray *replyArray;
@property (retain) NSMutableArray *urlArray;

@property (retain) NSString *cid;
@property (retain) NSString *uid;
@property (retain) NSString *address;
@property (retain) NSString *desc;
@property (retain) NSString *position;
@property (retain) NSString *deptName;
@property (retain) NSString *createdTimeString;

@property (retain) NSURL *mapImageURL;

@property CGFloat latitude;
@property CGFloat longitude;
@property NSTimeInterval createdTimeInterval;

@property NSInteger zoomLevel;
@property NSInteger fileCount;

@property BOOL isNotice;

@end
