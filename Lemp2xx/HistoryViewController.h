//
//  HistoryViewController.h
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 2. 10..
//  Copyright 2012 Benchbee. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
		UITableView *myTable;
		NSMutableArray *myList;
    UIImageView *topImageView;
//		NSMutableArray *myImageList;
		
//		UITableViewCell *lastSelectedCell;
//    int viewTag;
//	id target;
//	SEL selector;
	
}
//@property (nonatomic, assign) id target;
//@property (nonatomic, assign) SEL selector;

@end
