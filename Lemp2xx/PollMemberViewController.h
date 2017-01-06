//
//  PollMemberViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 2. 17..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PollMemberViewController : UITableViewController
{
    NSArray *myList;
}


- (id)initWithArray:(NSArray *)array;
@end
