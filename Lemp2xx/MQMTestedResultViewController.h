//
//  MQMTestedResultViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2016. 6. 7..
//  Copyright © 2016년 BENCHBEE Co., Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MQMTestedResultViewController : UITableViewController
{
    NSDictionary *myDic;
    NSMutableArray *myList;
    BOOL requested;
    
}


- (id)initWithDictionary:(NSDictionary *)dic;

@end
