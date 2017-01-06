//
//  SocialSearchViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 12. 2..
//  Copyright © 2015년 BENCHBEE Co., Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "TimeLineCellSubViews.h"


@interface SocialSearchViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UITableView *myTable;
    NSMutableArray *searchArray;
    id sendLikeTarget;
    SEL sendLikeSelector;
    UISearchBar *search;
    BOOL searching;
    NSInteger isDetail;
}
- (void)sendLikeTarget:(id)target delegate:(SEL)selector;
- (void)sendLike:(NSString *)idx sender:(id)sender;
- (void)goReply:(NSString *)idx withKeyboard:(BOOL)popKeyboard;

- (void)didSelectImageScrollView:(NSString *)index;
- (void)reloadTimeline:(NSString *)index dic:(NSDictionary *)resultDic;
@end
