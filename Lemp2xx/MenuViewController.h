//
//  MenuViewController.h
//  ViewDeckExample
//


#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController<UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *myList;
    UITableView *myTable;
    NSMutableArray *newChatList;
    NSMutableArray *joinGroupList;
    NSMutableArray *unjoinGroupList;
    UILabel *statusLabel;
    UIImageView *myProfileView;
    NSInteger notiNumber;
    
}
//@property (nonatomic, retain) NSMutableArray *newChatList;
@property (nonatomic, retain) UITableView *myTable;

- (void)reloadProfileImage;
- (void)refreshNewChatList:(NSArray *)array;
- (void)addJoinGroup:(NSDictionary *)dic;
- (void)fromUnjoinToJoin:(NSDictionary *)dic;
- (void)fromJoinToUnjoin:(NSDictionary *)dic;

@end
