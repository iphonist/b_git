//
//  GoodMemberViewController.h
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 11. 12..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodMemberViewController : UITableViewController
{
    NSMutableArray *member;
    
}
@property (nonatomic, strong) NSMutableArray *member;

- (id)initWithMember:(NSMutableArray *)m;

@end
