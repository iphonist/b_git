//
//  ContactViewController.h
//  ViewDeckExample
//

#import <UIKit/UIKit.h>


@interface MemberViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    NSMutableArray *memberList;
    NSMutableArray *waitList;
//    NSMutableArray *favList;
//    NSMutableArray *chatList;
    UITableView *myTable;
    
//    UISearchBar *search;
//    UIButton *cancelBtn;
    
//    NSMutableArray *copyList;
//    NSString *groupnum;
//    NSString *groupInfo;
//    NSString *groupMaster;
//    NSString *groupImage;
    NSDictionary *groupDic;
    NSMutableArray *newArray;
    NSString *newAlert;
    NSString *replyAlert;
    NSInteger kSocial;
    NSInteger kMember;
    NSInteger kNotice;
    NSInteger kOut;
    
    NSInteger kConfig;
    
}

//@property (nonatomic, retain) NSMutableArray *favList;
//@property (nonatomic, retain) IBOutlet UITableView* tableView;
//@property (nonatomic, retain) IBOutlet UIButton* pushButton;
//
//- (IBAction)defaultCenterPressed:(id)sender;
//- (IBAction)swapLeftAndCenterPressed:(id)sender;
//- (IBAction)centerNavController:(id)sender;
//- (IBAction)pushOverCenter:(id)sender;
- (void)addWaitmember:(NSString *)member;
- (void)setGroup:(NSDictionary *)dic;
- (void)setRegi:(NSString *)yn;
- (void)setFromGreen;

@end
