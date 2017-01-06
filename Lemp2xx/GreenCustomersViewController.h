//
//  GreenCustomersViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 4. 13..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GreenCustomersViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSInteger viewTag;
    NSMutableArray *myList;
    UITableView *myTable;
}

- (id)initWithTag:(int)tag;
@end
