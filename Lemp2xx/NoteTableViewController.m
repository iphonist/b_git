//
//  NoteTableViewController.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 2013. 12. 10..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//

#import "NoteTableViewController.h"
#import "DetailViewController.h"
#import "SendNoteViewController.h"
#import "TimeLineCell.h"
//#import "LKBadgeView.h"
#import "AddMemberViewController.h"
#import "SelectDeptViewController.h"
#import "SVPullToRefresh.h"
#import "CustomTableViewCell.h"

@interface NoteTableViewController ()

@end

@implementation NoteTableViewController
@synthesize readList;
@synthesize originList;
@synthesize storedList;
@synthesize searchList;
@synthesize myTable;
@synthesize reserveRefresh;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
//		from = [[NSString alloc]initWithString:@"2"];
		lastInteger = 0;
        svc = [[StoredNoteTableViewController alloc]init];

//        self.title = @"쪽지";
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(refreshProfiles)
													 name:@"refreshProfiles"
												   object:nil];
		reserveRefresh = YES;
//		CGRect bound = self.view.bounds;
//		bound.size.height -= 50.0;
//		tableView.frame = bound;
//		self.view.frame = bound;

    }
    return self;
}


- (void)refreshProfiles
{

    [myTable reloadData];

    
}

- (void)dealloc
{
//    self.myTable = nil;
//    self.readList = nil;
//    //    self.unreadList = nil;
//    self.storedList = nil;
////	[unreadList release];
//    [storedList release];
//    [readList release];
//	[myTable release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
//	[super dealloc];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (myTable.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (void)cancel//:(id)sender
{
    NSLog(@"cancel");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#define kNotEditing 1
#define kEditing 2

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//	myTable.contentInset = UIEdgeInsetsMake(0.0, 0.0, 48.0, 0.0);
//	myTable.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 48.0, 0.0);
//	self.view.backgroundColor = RGB(246,246,246);
	
    
    float viewY = 64;
    
    
    
	CGRect tableFrame;
	    tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY - 49.0 - 48.0); // 네비(44px) + 상태바(20px) + 탭바(49px) + 서브탭바(48px)

	NSLog(@"TableViewFrame %@",NSStringFromCGRect(tableFrame));
	
	myTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    
    

    
//	myTable.backgroundColor = [UIColor clearColor];
	myTable.scrollsToTop = YES;
	myTable.delegate = self;
    myTable.dataSource = self;
	myTable.allowsMultipleSelectionDuringEditing = YES;
    myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
		[myTable setSeparatorInset:UIEdgeInsetsZero];
	}
	
	[self.view addSubview:myTable];
   
    filterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    filterView.backgroundColor = RGB(227,227,227);
    [myTable addSubview:filterView];
//    [filterView release];
    
    
    UIButton *filterButton = [[UIButton alloc]initWithFrame:CGRectMake(13, 7, 79, 30)];
     [filterButton setBackgroundImage:[UIImage imageNamed:@"button_note_filter.png"] forState:UIControlStateNormal];
    [filterButton setBackgroundColor:[UIColor clearColor]];
    [filterButton addTarget:self action:@selector(showFilterList:) forControlEvents:UIControlEventTouchUpInside];
     filterButton.adjustsImageWhenHighlighted = NO;
    [filterView addSubview:filterButton];
//    [filterButton release];
	
    
    filterLabel = [CustomUIKit labelWithText:@"" fontSize:12 fontColor:[UIColor blackColor] frame:CGRectMake(10, 0, 50, filterButton.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [filterButton addSubview:filterLabel];
    
    filterSubImage = [[UIImageView alloc]initWithFrame:CGRectMake(filterLabel.frame.origin.x + filterLabel.frame.size.width, 12, 9, 6)];
    [filterSubImage setImage:[UIImage imageNamed:@"button_note_filter_down.png"]];
    [filterSubImage setBackgroundColor:[UIColor clearColor]];
    [filterButton addSubview:filterSubImage];
//    [filterSubImage release];
	
    
	searching = NO;
	search = [[UISearchBar alloc]init];
    search.frame = CGRectMake(filterButton.frame.origin.x + filterButton.frame.size.width + 10,0,320-(filterButton.frame.origin.x + filterButton.frame.size.width + 10),45);
    search.layer.borderWidth = 1;
    search.layer.borderColor = [RGB(227,227,227) CGColor];
    //	search.tintColor = RGB(248, 248, 248);//RGB(136, 122, 112);
	
  
    
        search.tintColor = [UIColor grayColor];
        if ([search respondsToSelector:@selector(barTintColor)]) {
            search.barTintColor = RGB(227,227,227);
        }
   
        
    [search setSearchFieldBackgroundImage:[CustomUIKit customImageNamed:@"button_note_filter.png"] forState:UIControlStateNormal];
 
	search.placeholder = @"보낸사람, 받은사람 검색";
	[filterView addSubview:search];
//    [search release];
	search.delegate = self;
    
//	refreshControl = (id)[[ISRefreshControl alloc] init];
//    [myTable addSubview:refreshControl];
//    [refreshControl addTarget:self action:@selector(refreshTimeline) forControlEvents:UIControlEventValueChanged];
	
    __weak typeof(self) _self = self;
    
	[myTable addPullToRefreshWithActionHandler:^{
		[_self refreshTimeline];
	}];
    
    [filterSubImage setImage:[UIImage imageNamed:@"button_note_filter_down.png"]];
    dropView = [[UIView alloc]init];
    [self.view addSubview:dropView];
    dropView.hidden = YES;
    
    UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 81, 9)];
    topView.image = [CustomUIKit customImageNamed:@"imageview_note_filter_top.png"];
    [dropView addSubview:topView];
//    [topView release];
    
    UIImageView *opt1View = [[UIImageView alloc]initWithFrame:CGRectMake(0, topView.frame.origin.y + topView.frame.size.height, topView.frame.size.width, 24)];
    opt1View.image = [CustomUIKit customImageNamed:@"imageview_note_filter_middle.png"];
    [dropView addSubview:opt1View];
//    [opt1View release];
    opt1View.userInteractionEnabled = YES;
    
    UIButton *transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdFilterList:)
                                                   frame:CGRectMake(0, 0, opt1View.frame.size.width, opt1View.frame.size.height) imageNamedBullet:nil // 179
                                        imageNamedNormal:nil imageNamedPressed:nil];
    transButton.tag = 0;
    [opt1View addSubview:transButton];
//    [transButton release];
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, opt1View.frame.origin.y + opt1View.frame.size.height, opt1View.frame.size.width, 1)];
    lineView.image = [CustomUIKit customImageNamed:@"imageview_note_filter_line.png"];
    [dropView addSubview:lineView];
//    [lineView release];
    
    UIImageView *opt2View = [[UIImageView alloc]initWithFrame:CGRectMake(0, lineView.frame.origin.y + lineView.frame.size.height, lineView.frame.size.width, opt1View.frame.size.height)];
    opt2View.image = [CustomUIKit customImageNamed:@"imageview_note_filter_middle.png"];
    [dropView addSubview:opt2View];
//    [opt2View release];
    opt2View.userInteractionEnabled = YES;
    
    
    transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdFilterList:)
                                         frame:CGRectMake(0, 0, opt2View.frame.size.width, opt2View.frame.size.height) imageNamedBullet:nil // 179
                              imageNamedNormal:nil imageNamedPressed:nil];
    transButton.tag = 1;
    [opt2View addSubview:transButton];
//    [transButton release];
    
    
    UIImageView *lineView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, opt2View.frame.origin.y + opt2View.frame.size.height, opt2View.frame.size.width, 1)];
    lineView2.image = [CustomUIKit customImageNamed:@"imageview_note_filter_line.png"];
    [dropView addSubview:lineView2];
//    [lineView2 release];
    
    UIImageView *opt3View = [[UIImageView alloc]initWithFrame:CGRectMake(0, lineView2.frame.origin.y + lineView2.frame.size.height, lineView2.frame.size.width, opt2View.frame.size.height)];
    opt3View.image = [CustomUIKit customImageNamed:@"imageview_note_filter_middle.png"];
    [dropView addSubview:opt3View];
//    [opt3View release];
    opt3View.userInteractionEnabled = YES;
    
    transButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdFilterList:)
                                         frame:CGRectMake(0, 0, opt3View.frame.size.width, opt3View.frame.size.height) imageNamedBullet:nil // 179
                              imageNamedNormal:nil imageNamedPressed:nil];
    transButton.tag = 2;
    [opt3View addSubview:transButton];
//    [transButton release];
    
    UIImageView *bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, opt3View.frame.origin.y + opt3View.frame.size.height, opt3View.frame.size.width, 6)];
    bottomView.image = [CustomUIKit customImageNamed:@"imageview_note_filter_bottom.png"];
    [dropView addSubview:bottomView];
//    [bottomView release];
    
    dropView.frame = CGRectMake(13, viewY + 45-9, topView.frame.size.width, bottomView.frame.origin.y + bottomView.frame.size.height);
    
    opt1Label = [CustomUIKit labelWithText:@"전체쪽지" fontSize:12 fontColor:[UIColor blackColor] frame:CGRectMake(10, 0, opt1View.frame.size.width-20, opt1View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [opt1View addSubview:opt1Label];
    
    opt2Label = [CustomUIKit labelWithText:@"받은쪽지" fontSize:12 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, opt2View.frame.size.width-20, opt2View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [opt2View addSubview:opt2Label];
    
    opt3Label = [CustomUIKit labelWithText:@"보낸쪽지" fontSize:12 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, opt3View.frame.size.width-20, opt3View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [opt3View addSubview:opt3Label];

    
    
    self.view.userInteractionEnabled = YES;
    
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    
    dropView.frame = CGRectMake(13, 45-9, topView.frame.size.width, bottomView.frame.origin.y + bottomView.frame.size.height);
    
    
    self.title = @"쪽지";
    myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
    
 
    #ifdef MQM
    
    #else
    UIButton *newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(writeNote) frame:CGRectMake(320 - 81, self.view.frame.size.height - 81 - viewY, 81, 81) imageNamedBullet:nil imageNamedNormal:@"button_newnote.png" imageNamedPressed:nil];
    [self.view addSubview:newbutton];
    

    //    #endif

    #endif
    
    
    editB = [CustomUIKit buttonWithTitle:@"편집" fontSize:16 fontColor:[UIColor blackColor] target:self selector:@selector(toggleStatus) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    editB.tag = kNotEditing;
    editButton = [[UIBarButtonItem alloc]initWithCustomView:editB];
    
    
    UIButton *cancelB = [CustomUIKit buttonWithTitle:@"취소" fontSize:16 fontColor:[UIColor blackColor] target:self selector:@selector(toggleStatus) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancelB];
    
    
    NSString *delString = @"삭제(0)";
    CGFloat fontSize = 16;
    UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
    CGSize stringSize;
    stringSize = [delString sizeWithAttributes:@{NSFontAttributeName: systemFont}];
    
    
    UIButton *delButton = [CustomUIKit buttonWithTitle:delString fontSize:fontSize fontColor:[UIColor redColor] target:self selector:@selector(deleteAction) frame:CGRectMake(0, 0, stringSize.width+3.0, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    deleteButton = [[UIBarButtonItem alloc] initWithCustomView:delButton];

    UIButton *leftcloseButton;
    leftcloseButton = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    closeButton = [[UIBarButtonItem alloc]initWithCustomView:leftcloseButton];
    self.navigationItem.leftBarButtonItem = closeButton;

#ifdef MQM
    UIButton *button;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(tempFunc) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    
    storeButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
//        self.navigationItem.rightBarButtonItem = editButton;
    
#else
    UIButton *button;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(goStoredList) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"barbutton_note_favorite.png" imageNamedPressed:nil];
    
    storeButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    
#endif
    
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:editButton, storeButton, nil]; // 순서는 거꾸로
    self.navigationItem.rightBarButtonItems = arrBtns;
    
//    [arrBtns release];
   
    
    [myTable reloadData];
#else
    UIButton *newbutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self.parentViewController selector:@selector(newCommunicate) frame:CGRectMake(320 - 81, self.view.frame.size.height - viewY - 48 - 81 - 49, 81, 81) imageNamedBullet:nil imageNamedNormal:@"button_newnote.png" imageNamedPressed:nil];
    [self.view addSubview:newbutton];
#endif
//    unreadList = [[NSMutableArray alloc]init];
//    storedList = [[NSMutableArray alloc]init];
//    readList = [[NSMutableArray alloc]init];
    didFetch = NO;
    
    
    originList = [[NSMutableArray alloc]init];
	searchList = [[NSMutableArray alloc]init];
    noteTag = 0;
    filterLabel.text = @"전체쪽지";
}

- (void)tempFunc{
    NSLog(@"tempFunc");
}


#pragma mark - search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar // 서치바 터치하는 순간 들어옴.
{
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
				[self performSelector:@selector(initAction)];
#else
    
				[self.parentViewController performSelector:@selector(initAction)];
#endif
    [searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:UIButton.class]){
            [(UIButton*)subView setTitle:@"취소" forState:UIControlStateNormal];
        }
    }
    

    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    searching = NO;
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [searchBar resignFirstResponder];
    
    searchBar.text = @"";
    
    [myTable reloadData];
    
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText // 터치바에 글자 쓰기
{
    [searchList removeAllObjects];
    NSLog(@"searchList %@",searchList);
    NSLog(@"self.readList %@",self.readList);
    
    
    if([searchText length]>0)
    {
        
        
        searching = YES;
        for(int i = 0 ; i < [self.readList count] ; i++)
        {
            TimeLineCell *dataItem = self.readList[i];
            BOOL catch = NO;
            if([[dataItem.contentDic[@"from"][0]objectFromJSONString][@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
                // 내가 보냄 // 받은 사람만 검색
                
                
                NSArray *toArray = dataItem.contentDic[@"to"];
                NSLog(@"toArray %@",toArray);
                for(int j = 0; j < [toArray count]; j++){
                    NSString *name = [toArray[j]objectFromJSONString][@"name"];
                    NSLog(@"name %@",name);
                    if([[name lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound)
                    {
                        
                        catch = YES;
                    }
                }
            }
            else{
                // 받음 // 보낸 사람만 검색
                NSString *name = [dataItem.contentDic[@"from"][0]objectFromJSONString][@"name"];
                if([[name lowercaseString] rangeOfString:[searchText lowercaseString ]].location != NSNotFound)
                {
                    catch = YES;
                    
                }
            }
         
        
            
            if(catch)
            [searchList addObject:dataItem];
    }
    }
    else
    {
        NSLog(@"text not exist %f",self.view.frame.size.height);
        
        [searchBar becomeFirstResponder];

        searching = NO;
        
    }
    
    [myTable reloadData];
		
    
}


- (void)showFilterList:(id)sender{
    
    if(dropView.hidden == YES){
        dropView.hidden = NO;
        [filterSubImage setImage:[UIImage imageNamed:@"button_note_filter_up.png"]];
        filterLabel.textColor = [UIColor lightGrayColor];
        
        if(noteTag == 0)
        {
            opt1Label.textColor = [UIColor blackColor];
            opt2Label.textColor = [UIColor darkGrayColor];
            opt3Label.textColor = [UIColor darkGrayColor];
        }
        else if(noteTag == 1)
        {
            opt1Label.textColor = [UIColor darkGrayColor];
            opt2Label.textColor = [UIColor blackColor];
            opt3Label.textColor = [UIColor darkGrayColor];
            
        }
        else if(noteTag == 2)
        {
            opt1Label.textColor = [UIColor darkGrayColor];
            opt2Label.textColor = [UIColor darkGrayColor];
            opt3Label.textColor = [UIColor blackColor];
            
        }
    }
    else{
        
        [self initFilterList];
    }
}



- (void)initFilterList{
    
    if(dropView.hidden == NO){
        
        dropView.hidden = YES;
        [filterSubImage setImage:[UIImage imageNamed:@"button_note_filter_down.png"]];
        filterLabel.textColor = [UIColor blackColor];
    }
    
}


- (void)cmdFilterList:(id)sender{
 
    
    [self initFilterList];
    
    [self.readList removeAllObjects];
    
    
    
    
    switch ([sender tag])
    {
        case 0:
        {
            [self.readList setArray:originList];
            filterLabel.text = @"전체쪽지";
            
            
        }
            break;
        case 1:
        {
            
            for(TimeLineCell *cell in originList){
                
                if(![cell.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    [self.readList addObject:cell];
                }
            }
            filterLabel.text = @"받은쪽지";
            
        }
            break;
        case 2:
        {
            for(TimeLineCell *cell in originList){
                if([cell.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    [self.readList addObject:cell];
                }
            }
            filterLabel.text = @"보낸쪽지";
            
            
            
            
        }
            break;
    }
    
    if(searching){
        
        [self searchBar:search textDidChange:search.text];
    }
    
    NSLog(@"self.readlist %@",self.readList);
    
    noteTag = [sender tag];
    
    [myTable reloadData];

}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    if(buttonIndex == 3) // cancel
        return;

    [self.readList removeAllObjects];
    


        
    switch (buttonIndex)
		{
			case 0:
			{
                [self.readList setArray:originList];
                filterLabel.text = @"전체쪽지";
                
                
            }
                break;
            case 1:
            {
                
                for(TimeLineCell *cell in originList){
                    
                    if(![cell.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                        [self.readList addObject:cell];
                    }
                }
                filterLabel.text = @"받은쪽지";

            }
                break;
            case 2:
            {
                for(TimeLineCell *cell in originList){
                if([cell.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    [self.readList addObject:cell];
                }
                    filterLabel.text = @"보낸쪽지";
            }
                
               

                
            }
                break;
        }
    
    if(searching){
        
        [self searchBar:search textDidChange:search.text];
    }
    
    NSLog(@"self.readlist %@",self.readList);
    
    noteTag = buttonIndex;
    

    [myTable reloadData];
    
    
}
- (void)goStoredList{
    
    [svc settingList:storedList];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:svc];
    [self presentViewController:nc animated:YES completion:nil];
//     [nc release];
}


- (void)setReserveRefresh:(BOOL)_reserveRefresh
{
	if (_reserveRefresh == YES && SharedAppDelegate.root.mainTabBar.selectedIndex == kTabIndexMessage) {
		UINavigationController *naviCon = (UINavigationController*)[SharedAppDelegate.root.mainTabBar.viewControllers objectAtIndex:kTabIndexMessage];
		if ([[naviCon viewControllers] count] > 0) {
			MHTabBarController *subTab = (MHTabBarController*)[[naviCon viewControllers] objectAtIndex:0];
			if (subTab.selectedIndex == kSubTabIndexNote) {
				[self getTimeline:@"" send:@"2"];
				_reserveRefresh = NO;
			}
		}
	}
	reserveRefresh = _reserveRefresh;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
#ifdef MQM
    
    [SharedAppDelegate.root getPushCount];//:@""];
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    [self initFilterList];
    [self initAction];
    [SharedAppDelegate.root getPushCount];//:@""];
    NSLog(@"reserveRefresh %@",self.reserveRefresh?@"oo":@"xx");
#ifdef MQM
    	[self refreshTimeline];
#else
	if (YES == self.reserveRefresh || [self.readList count] == 0) {
		[self refreshTimeline];
    } else {

        [myTable reloadRowsAtIndexPaths:[myTable indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
        
    }
#endif
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
//	[from release];
}



- (void)writeNote{
     [self loadMember:0];
}
- (void)loadMember:(int)mode
{
	switch (mode) {
		case 0:
		{
			AddMemberViewController *addController = [[AddMemberViewController alloc] initWithTag:100 array:nil add:nil];
			[addController setDelegate:self selector:@selector(selectedMember:)];
			addController.title = @"쪽지 대상 선택";
			UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:addController];
			[self presentViewController:nc animated:YES completion:nil];
//			[addController release];
//			[nc release];
			break;
		}
			
		case 1:
		{
            SelectDeptViewController *selectDeptController = [[SelectDeptViewController alloc] initWithTag:100];
			selectDeptController.rootTitle = @"쪽지 대상 선택";
			selectDeptController.selectedDeptList = [NSMutableArray array];
			[selectDeptController setDelegate:self selector:@selector(selectedGroup:)];
			UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:selectDeptController];
			[self presentViewController:nc animated:YES completion:nil];
//			[selectDeptController release];
//			[nc release];
			break;
		}
		
	}
}

#define kNote 1
#define kNoteGroup 3

- (void)selectedMember:(NSMutableArray*)members
{
	SendNoteViewController *post = [[SendNoteViewController alloc]initWithStyle:kNote];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
    post.title = @"쪽지 보내기";
    [post saveArray:members];
	[self presentViewController:nc animated:YES completion:nil];
//    [post release];
//    [nc release];
}

- (void)selectedGroup:(NSMutableArray*)dept
{
	SendNoteViewController *post = [[SendNoteViewController alloc]initWithStyle:kNoteGroup];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
    post.title = @"쪽지 보내기";
    [post selectArray:dept];
	[self presentViewController:nc animated:YES completion:nil];
//    [post release];
//    [nc release];
}


- (void)refreshTimeline
{
    NSLog(@"refreshTimeline");
	self.reserveRefresh = NO;
    [self getTimeline:@"" send:@"2"];
}


- (void)getTimeline:(NSString *)idx send:(NSString *)send
{
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    didFetch = NO;
//	from = [[NSString alloc]initWithFormat:@"%@",send];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/categorymsg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters;
    if(idx != nil && [idx length]>5) {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                      [ResourceLoader sharedInstance].myUID,@"uid",
                      @"7",@"contenttype",send,@"send",@"3",@"category",idx,@"time",
                      @"",@"targetuid",
                      @"",@"groupnumber",nil];
	} else {
        idx = @"";
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                      [ResourceLoader sharedInstance].myUID,@"uid",
                      @"7",@"contenttype",send,@"send",@"3",@"category",
                      @"0",@"time",
                      @"",@"targetuid",
                      @"",@"groupnumber",nil];
    }
	
    NSLog(@"urlString %@",urlString);
    NSLog(@"parameters %@",parameters);
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/categorymsg.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    NSLog(@"timeout: %f", request.timeoutInterval);
	
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        didFetch = YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResultDic %@",resultDic);
		
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            NSMutableArray *resultArray = resultDic[@"past"];
            
            if(idx == nil || [idx length] < 1) {
                if([resultArray count] > 0 && [send isEqualToString:@"0"]) {
                    NSString *lastNote = resultArray[0][@"contentindex"];
					[SharedAppDelegate.root.mainTabBar writeLastIndexForMode:@"lastnote" value:lastNote];
				}
            }
            self.readList = [NSMutableArray array];
//            self.unreadList = [NSMutableArray array];
            self.storedList = [NSMutableArray array];
            
//            for(NSDictionary *dic in resultArray){
////                if(![dic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID] && [[dic[@"target"]objectFromJSONString][@"read"]isEqualToString:@"0"])
////                   [unreadList addObject:dic];
////                else
//                if([dic[@"favorite"]isEqualToString:@"1"])
//                    [storedList addObject:dic];
//                else
//                    [readList addObject:dic];
//            }
//            NSLog(@"storedList %d",[storedList count]);
//            NSMutableArray *parsingArray = [NSMutableArray array];
            if([resultArray count]>0) {
                for (NSDictionary *dic in resultArray) {
                    TimeLineCell *cellData = [[TimeLineCell alloc] init];
                    cellData.idx = dic[@"contentindex"];
                    cellData.writeinfoType = dic[@"writeinfotype"];
                    cellData.personInfo = [dic[@"writeinfo"]objectFromJSONString];
                    cellData.currentTime = resultDic[@"time"];
                    cellData.time = dic[@"operatingtime"];
                    cellData.writetime = dic[@"writetime"];
                    lastInteger = [cellData.time intValue];
                    cellData.profileImage = dic[@"uid"]!=nil?dic[@"uid"]:@"";
                    cellData.readArray = dic[@"readcount"];
                    cellData.targetdic = dic[@"target"];
                    
                    NSDictionary *contentDic = [dic[@"content"][@"msg"]objectFromJSONString];
                    cellData.contentDic = contentDic;
                    cellData.contentType = dic[@"contenttype"];
                    cellData.type = dic[@"type"];
                    cellData.likeCount = [dic[@"goodmember"]count];
                    cellData.likeArray = dic[@"goodmember"];
                    cellData.replyCount = [dic[@"replymsgcount"]intValue];
                    cellData.replyArray = dic[@"replymsg"];
                    
//                    if(![dic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID] && [[dic[@"target"]objectFromJSONString][@"read"]isEqualToString:@"0"])
//                        [unreadList addObject:cellData];
                     if([dic[@"favorite"]isEqualToString:@"1"])
                        [storedList addObject:cellData];
                    else
                        [readList addObject:cellData];
//                    [parsingArray addObject:cellData];
//                    [cellData release];
                }
                
                [svc settingList:storedList];
            }
//            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:idx,@"idx",parsingArray,@"array",nil];
            [self performSelectorOnMainThread:@selector(handleContents) withObject:nil waitUntilDone:NO];
         
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        didFetch = YES;
        NSLog(@"FAIL : %@",operation.error);
		[HTTPExceptionHandler handlingByError:error];

    }];
    
    [operation start];
    
}

- (void)handleContents
{
//    [refreshControl endRefreshing];
	[myTable.pullToRefreshView stopAnimating];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    noteTag = 0;
    filterLabel.text = @"전체쪽지";
    [originList setArray:self.readList];
  
    [myTable reloadData];
    
    
    
	if (myTable.editing == YES) {
		// 삭제버튼 갱신
        
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        
        NSNumber *count = [NSNumber numberWithInteger:[[myTable indexPathsForSelectedRows] count]];
        [self performSelector:@selector(setCountForRightBar:) withObject:count];
        
#else
		if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
			NSNumber *count = [NSNumber numberWithInteger:[[myTable indexPathsForSelectedRows] count]];
			[self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
		}
#endif
	}

}

- (NSUInteger)myListCount
{
	if ([readList count] == 1) {
		TimeLineCell *cellData = [readList lastObject];
		if ([cellData.type isEqualToString:@"6"]) {
			return 0;
		}
	}
	return readList?[readList count]:0;
}

- (NSUInteger)selectListCount
{
	return myTable?[myTable.indexPathsForSelectedRows count]:0;
}
                                                                                                                                                                                                                                                                                                         
- (void)startEditing
{
    NSLog(@"startEditing");
    

    [search resignFirstResponder];
    [myTable setEditing:YES animated:YES];
    [myTable reloadData];
    myTable.showsPullToRefresh = NO;
    filterView.hidden = YES;
    
}

- (void)endEditing
{
	[myTable setEditing:NO animated:YES];
	myTable.showsPullToRefresh = YES;
    
    [myTable reloadData];
    filterView.hidden = NO;
}

- (void)commitDelete
{
    NSLog(@"commitDelete");
    
    int selectedCount;
    
    
        selectedCount = (int)[readList count];
	if (myTable.editing == YES && selectedCount != 0) {
		if ([myTable.indexPathsForSelectedRows count] > 0) {
			NSMutableString *selectedIdx = [NSMutableString string];
			NSMutableString *selectedTarget = [NSMutableString string];
			
			NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
			NSInteger remainCount = 0;
			
			for (NSIndexPath *indexPath in myTable.indexPathsForSelectedRows) {
                
                TimeLineCell *dataItem;
                    dataItem  = readList[indexPath.row];

				if ([selectedIdx length] > 0) {
					[selectedIdx appendString:@","];
				}
				[selectedIdx appendString:dataItem.idx];
					
				if ([selectedTarget length] == 0) {
					[selectedTarget appendString:@"["];
				}
				[selectedTarget appendString:dataItem.targetdic];
				[selectedTarget appendString:@","];
//				[targetArray addObject:dataItem.targetdic];

				[indexSet addIndex:indexPath.row];
				
				if([[dataItem.targetdic objectFromJSONString][@"read"] isEqualToString:@"0"]) {
					remainCount++;
				}
			}
			
			if ([selectedTarget length] > 0) {
				[selectedTarget replaceCharactersInRange:NSMakeRange([selectedTarget length]-1, 1) withString:@"]"];
			}
			
			NSLog(@"TARGETDIC %@",selectedTarget);

			[SharedAppDelegate.root modifyPost:selectedIdx
										modify:1 msg:@""
								   oldcategory:@""
								   newcategory:@"" oldgroupnumber:@"" newgroupnumber:@"" target:selectedTarget replyindex:@"" viewcon:self];
			
			// 통신 완료 후
            
      
            
			[SharedAppDelegate.root.mainTabBar setNoteBadgeCount:SharedAppDelegate.root.mainTabBar.noteBadgeCount -= remainCount];
        
			[readList removeObjectsAtIndexes:indexSet];
            
            [originList setArray:readList];
            
                if ([readList count] == 0) {
                    TimeLineCell *tempCell = [[TimeLineCell alloc] init];
                    tempCell.type = @"6";
#ifdef MQM
                    tempCell.contentDic = @{@"msg" : @"쪽지가 없습니다."};
#else
                    tempCell.contentDic = @{@"msg": @"개별 혹은 부서를 선택하여 쪽지를 보낼 수 있습니다."};
#endif
                    [readList addObject:tempCell];
                    //				[tempCell release];
                    [myTable reloadData];
                } else {
                    [myTable reloadData];
                    //				[myTable deleteRowsAtIndexPaths:[myTable indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
                }
            
			
            
#if defined(GreenTalk) || defined(GreenTalkCustomer)
            [self performSelector:@selector(toggleStatus)];
            
#else
			if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
				[self.parentViewController performSelector:@selector(toggleStatus)];
			}
#endif
		}
        else {
			[CustomUIKit popupSimpleAlertViewOK:nil msg:@"선택된 쪽지가 없습니다." con:self];
		}
	}
}




#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(myTable.editing){
        if(section == 0)
            return 35;
       
        return 0;
    }
    else{
    if(section == 1)
    return 35;
    
    return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(myTable.editing){
        if(section == 1)
            return nil;
    }
    else{
    if(section != 1)
        return nil;
    }
	UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myTable.frame.size.width, 35)];
    headerView.backgroundColor = [UIColor grayColor];
    headerView.image = [CustomUIKit customImageNamed:@"headersectionbg.png"];
    
    headerView.userInteractionEnabled = YES;
    float xPadding = 0;
#ifdef MQM
    
    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(8, 6, 23, 23)];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"button_nocheck.png"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(allCheck:) forControlEvents:UIControlEventTouchUpInside];
    checkButton.selected = NO;
    [headerView addSubview:checkButton];
    if(tableView.editing){
        checkButton.hidden = NO;
        xPadding = 8 + 23;
        
    }
    else{
        checkButton.hidden = YES;
        xPadding = 0;
        
    }
#endif
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(xPadding+10, 8, 320-(xPadding+10)-10, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont systemFontOfSize:16];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    if(noteTag == 0)
        headerLabel.text = @"전체쪽지";//[NSString stringWithFormat:@"전체쪽지 %d",[self.readList count]];
    else if(noteTag == 1)
        headerLabel.text = @"받은쪽지";//[NSString stringWithFormat:@"받은쪽지 %d",[self.readList count]];
    else if(noteTag == 2)
        headerLabel.text = @"보낸쪽지";//[NSString stringWithFormat:@,[self.readList count]];
    
    if(searching && tableView.editing == NO)
        headerLabel.text = [headerLabel.text stringByAppendingFormat:@" 검색결과 %d",(int)[searchList count]];
    else{
        if([readList count]>0){
            TimeLineCell *dataItem = readList[0];
        if([dataItem.type isEqualToString:@"6"]){
            headerLabel.text = [headerLabel.text stringByAppendingString:@" 0"];
        }
        else
        headerLabel.text = [headerLabel.text stringByAppendingFormat:@" %d",(int)[readList count]];
    }
    }
    [headerView addSubview:headerLabel];
    
    
    return headerView;
}
- (void)allCheck:(id)sender{
    NSLog(@"allCheck %@",sender);
    NSLog(@"myTable %@",myTable);
    if(checkButton.selected == NO){
        
         checkButton.selected = YES;
        [checkButton setBackgroundImage:[UIImage imageNamed:@"button_check.png"] forState:UIControlStateNormal];
        

        
            for (int j = 0; j < [myTable numberOfRowsInSection:0]; j++) {
                
                [myTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]
                                            animated:NO
                                      scrollPosition:UITableViewScrollPositionNone];
                
            }
        
        
    }
    else{
         checkButton.selected = NO;
        [checkButton setBackgroundImage:[UIImage imageNamed:@"button_nocheck.png"] forState:UIControlStateNormal];
        
        
        for (int j = 0; j < [myTable numberOfRowsInSection:0]; j++) {
            
            [myTable deselectRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:0]
                                 animated:NO];
            
        }
    }
    
    NSNumber *count = [NSNumber numberWithInteger:[[myTable indexPathsForSelectedRows] count]];
    [self performSelector:@selector(setCountForRightBar:) withObject:count];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    NSLog(@"mytable editing %@",myTable.editing?@"YES":@"NO");
    if(myTable.editing){
        
        if([self.readList count]>3)
            return 2;
        else
            return 1;
    }

    
    if(searching){
        
        if([searchList count]>3)
            return 3;
        else
            return 2;
    }
    else{
    if([self.readList count]>3)
        return 3;
    else
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(myTable.editing == YES){
        if(section == 0)
            return [self.readList count]==0?1:[self.readList count];
        else
            return 1;
            
    }
    else{
    if(searching){
        
        if(section == 0 || section == 2)
            return 1;
        else
        return [searchList count];
    }
    else{
    if(section == 0 || section == 2)
        return 1;
    else{
        return [self.readList count]==0?1:[self.readList count];
    }
    }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(myTable.editing == YES){
        if(indexPath.section == 0)
            return 75;
        else
            return 83;
    }
    else{
    if(indexPath.section == 0)
        return 45;
    else if(indexPath.section == 1)
        return 75;
    else
        return 83;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    
    UIImageView *badge;
    UILabel *badgeLabel;
    UIImageView *inImageView, *inImageView2, *inImageView3, *inImageView4;
    UIImageView *roundingView;
    if (nil == cell) {
		cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleDefault reuseIdentifier:CellIdentifier];
        
//        UIView *selctionView = [[[UIView alloc] initWithFrame:CGRectMake(100, 0, 320-100, 75)] autorelease];
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = selctionView.bounds;
//        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor], (id)[[UIColor grayColor] CGColor], nil];
//        [selctionView.layer insertSublayer:gradient atIndex:0];
//        [cell setSelectedBackgroundView:selctionView];
//        
		UIImageView *profileView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 69, 69)];
		profileView.contentMode = UIViewContentModeScaleAspectFit;
		profileView.tag = 1;
		[cell.contentView addSubview:profileView];
        
        inImageView = [[UIImageView alloc]init];
        [cell.contentView addSubview:inImageView];
        [inImageView setContentMode:UIViewContentModeScaleAspectFill];
        [inImageView setClipsToBounds:YES];
        inImageView.tag = 100;
//        [inImageView release];
        
        inImageView2 = [[UIImageView alloc]init];
        [cell.contentView addSubview:inImageView2];
        [inImageView2 setContentMode:UIViewContentModeScaleAspectFill];
        [inImageView2 setClipsToBounds:YES];
        inImageView2.tag = 200;
//        [inImageView2 release];
        
        inImageView3 = [[UIImageView alloc]init];
        [cell.contentView addSubview:inImageView3];
        [inImageView3 setContentMode:UIViewContentModeScaleAspectFill];
        [inImageView3 setClipsToBounds:YES];
        inImageView3.tag = 300;
//        [inImageView3 release];
        
        inImageView4 = [[UIImageView alloc]init];
        [cell.contentView addSubview:inImageView4];
        [inImageView4 setContentMode:UIViewContentModeScaleAspectFill];
        [inImageView4 setClipsToBounds:YES];
        inImageView4.tag = 400;
//        [inImageView4 release];
        
		roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(0,0,69,69);
        roundingView.tag = 500;
		[cell.contentView addSubview:roundingView];
//        [roundingView release];
        
		UIImageView *senderView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 69, 69.0)];
		senderView.tag = 11;
		[cell.contentView addSubview:senderView];
		
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 8, 160.0, 20.0)];
		nameLabel.tag = 2;
		nameLabel.font = [UIFont systemFontOfSize:15.0];
		nameLabel.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:nameLabel];
		
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(214.0, nameLabel.frame.origin.y, 100.0, 20.0)];
		dateLabel.tag = 3;
		dateLabel.font = [UIFont systemFontOfSize:12];
		dateLabel.textColor = [UIColor grayColor];
		dateLabel.textAlignment = NSTextAlignmentRight;
		dateLabel.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:dateLabel];
		
		UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 34, 320-80-30, 15)];
		msgLabel.tag = 4;
		msgLabel.font = [UIFont systemFontOfSize:12];
		msgLabel.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:msgLabel];
		
//		LKBadgeView *badge = [[LKBadgeView alloc] initWithFrame:CGRectMake(290.0, 24.0+2.0, 26.0, 20.0)];
//		badge.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//		badge.widthMode = LKBadgeViewWidthModeSmall;
//		badge.heightMode = LKBadgeViewHeightModeStandard;
//		badge.horizontalAlignment = LKBadgeViewHorizontalAlignmentRight;
//		badge.outline = NO;F
//		badge.shadow = NO;
//		badge.textColor = [UIColor whiteColor];
//		badge.badgeColor = [UIColor colorWithRed:0.838 green:0.074 blue:0.079 alpha:1.000];
//		badge.tag = 1005;
//		badge.text = @"N";
//		badge.hidden = YES;
//		[cell.contentView addSubview:badge];
        
        
        UIImageView *memberCountView = [[UIImageView alloc] init];
		memberCountView.tag = 2000;
        memberCountView.image = [CustomUIKit customImageNamed:@"imageview_membercount.png"];
		[cell.contentView addSubview:memberCountView];
		
		UIImageView *memberCountView_icon = [[UIImageView alloc] init];
		memberCountView_icon.tag = 2002;
        memberCountView_icon.image = [CustomUIKit customImageNamed:@"imageview_membercount_icon.png"];
		[memberCountView addSubview:memberCountView_icon];
        
		UILabel *memberCountLabel = [[UILabel alloc] init];
		memberCountLabel.tag = 2001;
		memberCountLabel.font = [UIFont systemFontOfSize:10];
        memberCountLabel.textColor = RGB(78,78,78);
		memberCountLabel.backgroundColor = [UIColor clearColor];
        memberCountLabel.textAlignment = NSTextAlignmentCenter;
		[memberCountView addSubview:memberCountLabel];
        
        
        badge = [[UIImageView alloc] initWithFrame:CGRectMake(320.0 - 5 - 23, msgLabel.frame.origin.y, 23, 17)];
		badge.image = [CustomUIKit customImageNamed:@"imageview_badge_background.png"];
		[cell.contentView addSubview:badge];
        badge.tag = 1000;
        
		badgeLabel = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 23, 17) numberOfLines:1 alignText:NSTextAlignmentCenter];
        badgeLabel.tag = 1001;
		[badge addSubview:badgeLabel];
        
	}
	
    UIImageView *profileView = (UIImageView*)[cell.contentView viewWithTag:1];
    inImageView = (UIImageView *)[cell viewWithTag:100];
    inImageView2 = (UIImageView *)[cell viewWithTag:200];
    inImageView3 = (UIImageView *)[cell viewWithTag:300];
    inImageView4 = (UIImageView *)[cell viewWithTag:400];
	UIImageView *senderView = (UIImageView*)[cell.contentView viewWithTag:11];
	UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:2];
	UILabel *dateLabel = (UILabel*)[cell.contentView viewWithTag:3];
	UILabel *msgLabel = (UILabel*)[cell.contentView viewWithTag:4];
//	LKBadgeView *badge = (LKBadgeView*)[cell.contentView viewWithTag:5];
	UIImageView *memberCountView = (UIImageView*)[cell.contentView viewWithTag:2000];
	UIImageView *memberCountView_icon = (UIImageView*)[cell.contentView viewWithTag:2002];
	UILabel *memberCountLabel = (UILabel*)[cell.contentView viewWithTag:2001];
    roundingView = (UIImageView *)[cell viewWithTag:500];
    badge = (UIImageView*)[cell.contentView viewWithTag:1000];
    badgeLabel = (UILabel *)[cell viewWithTag:1001];
	badge.hidden = YES;
    badgeLabel.text = nil;
	cell.textLabel.text = nil;

	TimeLineCell *dataItem = nil;
	
    if(myTable.editing == YES){
        
        
        
        if(indexPath.section == 0){
            dataItem = readList[indexPath.row];
            
        }
        else if(indexPath.section == 1 && indexPath.row == 0){
            
            memberCountView.hidden = YES;
            memberCountLabel.hidden = YES;
            memberCountView_icon.hidden = YES;
            profileView.hidden = YES;
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            profileView.image = nil;
            senderView.image = nil;
            nameLabel.text = nil;
            dateLabel.text = nil;
            roundingView.image = nil;
            msgLabel.text = nil;
            
            
            inImageView.hidden = NO;
            inImageView.frame = CGRectMake(120, 5, 71, 71);
            inImageView.image = [UIImage imageNamed:@"imageview_list_restview_logo.png"];
            
            return cell;
        }
    }
    else{
        
        
    if(indexPath.section == 0 && indexPath.row == 0){
        
        memberCountView.hidden = YES;
        memberCountLabel.hidden = YES;
        memberCountView_icon.hidden = YES;
        profileView.hidden = YES;
        inImageView2.hidden = YES;
        inImageView3.hidden = YES;
        inImageView4.hidden = YES;
        profileView.image = nil;
        senderView.image = nil;
        nameLabel.text = nil;
        dateLabel.text = nil;
        roundingView.image = nil;
        msgLabel.text = nil;
        inImageView.hidden = YES;
        inImageView.image = nil;
        
        return cell;
    }
    if(indexPath.section == 2 && indexPath.row == 0){
        
        memberCountView.hidden = YES;
        memberCountLabel.hidden = YES;
        memberCountView_icon.hidden = YES;
        profileView.hidden = YES;
        inImageView2.hidden = YES;
        inImageView3.hidden = YES;
        inImageView4.hidden = YES;
        profileView.image = nil;
        senderView.image = nil;
        nameLabel.text = nil;
        dateLabel.text = nil;
        roundingView.image = nil;
        msgLabel.text = nil;
        
        
        inImageView.hidden = NO;
        inImageView.frame = CGRectMake(120, 5, 71, 71);
        inImageView.image = [UIImage imageNamed:@"imageview_list_restview_logo.png"];
        
        return cell;
    }
    
    if(searching){
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    if([readList count]==0){
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            memberCountView.hidden = YES;
            memberCountLabel.hidden = YES;
            memberCountView_icon.hidden = YES;
            profileView.hidden = NO;
            inImageView.hidden = YES;
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            profileView.image = nil;
            senderView.image = nil;
            nameLabel.text = nil;
            dateLabel.text = nil;
            roundingView.image = nil;
            msgLabel.text = nil;
			cell.textLabel.font = [UIFont systemFontOfSize:15.0];
			cell.textLabel.numberOfLines = 1;
			cell.textLabel.textAlignment = NSTextAlignmentCenter;
			cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumScaleFactor = 10.0/[UIFont labelFontSize];
        if(didFetch == YES){
            
#ifdef MQM
            cell.textLabel.text = @"쪽지가 없습니다.";
#else
            cell.textLabel.text = @"개별 혹은 부서를 선택하여 쪽지를 보낼 수 있습니다.";
#endif
        }
            return cell;

    }
    if([readList count]==1){
        
        dataItem = readList[0];
        if([dataItem.type isEqualToString:@"6"]){
//        dataItem = readList[0];
        memberCountView.hidden = YES;
        memberCountLabel.hidden = YES;
        memberCountView_icon.hidden = YES;
        profileView.hidden = NO;
        inImageView.hidden = YES;
        inImageView2.hidden = YES;
        inImageView3.hidden = YES;
        inImageView4.hidden = YES;
        profileView.image = nil;
        senderView.image = nil;
        nameLabel.text = nil;
        dateLabel.text = nil;
            roundingView.image = nil;
            msgLabel.text = nil;
			cell.textLabel.font = [UIFont systemFontOfSize:15.0];
			cell.textLabel.numberOfLines = 1;
			cell.textLabel.textAlignment = NSTextAlignmentCenter;
			cell.textLabel.adjustsFontSizeToFitWidth = YES;
            cell.textLabel.minimumScaleFactor = 10.0/[UIFont labelFontSize];
#ifdef MQM
            cell.textLabel.text = @"쪽지가 없습니다.";
#else
        cell.textLabel.text = dataItem.contentDic[@"msg"];
#endif
        return cell;
        }
    }
    }
    
    if(searching)
    {
        dataItem = searchList[indexPath.row];
    }
    else{
                       dataItem = readList[indexPath.row];
    }
    }
    
    
//    if(myTable.editing == YES){
//        
//            
//            badge.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//            memberCountView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//            msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//            nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//            dateLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    }
//    else{
//        
//            
//            
//            badge.autoresizingMask = UIViewAutoresizingNone;
//            memberCountView.autoresizingMask = UIViewAutoresizingNone;
//            msgLabel.autoresizingMask = UIViewAutoresizingNone;
//            nameLabel.autoresizingMask = UIViewAutoresizingNone;
//            dateLabel.autoresizingMask = UIViewAutoresizingNone;
//    }
	if([dataItem.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]) {
		msgLabel.textColor = [UIColor grayColor];
		// 발신	// dataItem.contentDic[@"to"]
		NSArray *toArray = dataItem.contentDic[@"to"];
		if ([toArray count] == 1) {
            memberCountView.hidden = YES;
            memberCountLabel.hidden = YES;
            memberCountView_icon.hidden = YES;
			// 일반메시지
            
            inImageView.hidden = YES;
            inImageView2.hidden = YES;
            inImageView3.hidden = YES;
            inImageView4.hidden = YES;
            profileView.hidden = NO;
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1_add.png"];
			[SharedAppDelegate.root getProfileImageWithURL:[toArray[0]objectFromJSONString][@"uid"] ifNil:@"profile_photo.png" view:profileView scale:0];
			
			NSDictionary *userInfo = [SharedAppDelegate.root searchContactDictionary:[toArray[0]objectFromJSONString][@"uid"]];
			NSString *grade = @"";
			if ([userInfo count] > 0) {
				grade = userInfo[@"grade2"];
			}
			NSString *name = [NSString stringWithFormat:@"%@ %@",[toArray[0]objectFromJSONString][@"name"],grade];
			nameLabel.text = name;
			
		} else {
            memberCountView.hidden = NO;
            memberCountLabel.hidden = NO;
            memberCountView_icon.hidden = NO;
			// 그룹 or 맛감
//			profileView.image = [UIImage imageNamed:@"group_photo.png"];
            
        if([toArray count] == 2){
                
                
                inImageView.frame = CGRectMake(0,0,34,69);
                [SharedAppDelegate.root getProfileImageWithURL:[toArray[0]objectFromJSONString][@"uid"] ifNil:@"profile_photo.png" view:inImageView scale:0];
                
                inImageView2.frame = CGRectMake(inImageView.frame.origin.x + inImageView.frame.size.width,inImageView.frame.origin.y,inImageView.frame.size.width,inImageView.frame.size.height);
            [SharedAppDelegate.root getProfileImageWithURL:[toArray[1]objectFromJSONString][@"uid"] ifNil:@"profile_photo.png" view:inImageView2 scale:0];
                
                inImageView.hidden = NO;
                inImageView2.hidden = NO;
                inImageView3.hidden = YES;
                inImageView4.hidden = YES;
            
            roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_2_add.png"];
            
            }
            else if([toArray count] == 3){
                inImageView.frame = CGRectMake(0,0,34,69);
                [SharedAppDelegate.root getProfileImageWithURL:[toArray[0]objectFromJSONString][@"uid"] ifNil:@"profile_photo.png" view:inImageView scale:0];
                
                inImageView2.frame = CGRectMake(inImageView.frame.origin.x + inImageView.frame.size.width,inImageView.frame.origin.y,inImageView.frame.size.width,34);
                [SharedAppDelegate.root getProfileImageWithURL:[toArray[1]objectFromJSONString][@"uid"] ifNil:@"profile_photo.png" view:inImageView2 scale:0];
                
                inImageView3.frame = CGRectMake(inImageView2.frame.origin.x,inImageView2.frame.origin.y + inImageView2.frame.size.height,inImageView2.frame.size.width,inImageView2.frame.size.height);
                [SharedAppDelegate.root getProfileImageWithURL:[toArray[2]objectFromJSONString][@"uid"] ifNil:@"profile_photo.png" view:inImageView3 scale:0];
                
                inImageView.hidden = NO;
                inImageView2.hidden = NO;
                inImageView3.hidden = NO;
                inImageView4.hidden = YES;
                
                roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_3_add.png"];
            }
            else{
                inImageView.frame = CGRectMake(0,0,34,34);
                [SharedAppDelegate.root getProfileImageWithURL:[toArray[0]objectFromJSONString][@"uid"] ifNil:@"profile_photo.png" view:inImageView scale:0];
                
                inImageView2.frame = CGRectMake(inImageView.frame.origin.x + inImageView.frame.size.width,inImageView.frame.origin.y,inImageView.frame.size.width,inImageView.frame.size.height);
                [SharedAppDelegate.root getProfileImageWithURL:[toArray[1]objectFromJSONString][@"uid"] ifNil:@"profile_photo.png" view:inImageView2 scale:0];
                
                inImageView3.frame = CGRectMake(inImageView.frame.origin.x,inImageView.frame.origin.y + inImageView.frame.size.height,inImageView.frame.size.width,inImageView.frame.size.height);
                [SharedAppDelegate.root getProfileImageWithURL:[toArray[2]objectFromJSONString][@"uid"] ifNil:@"profile_photo.png" view:inImageView3 scale:0];
                
                inImageView4.frame = CGRectMake(inImageView.frame.origin.x + inImageView.frame.size.width,inImageView.frame.origin.y + inImageView.frame.size.height,inImageView.frame.size.width,inImageView.frame.size.height);
                [SharedAppDelegate.root getProfileImageWithURL:[toArray[3]objectFromJSONString][@"uid"] ifNil:@"profile_photo.png" view:inImageView4 scale:0];
                
                inImageView.hidden = NO;
                inImageView2.hidden = NO;
                inImageView3.hidden = NO;
                inImageView4.hidden = NO;
                roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_4_add.png"];
            }
			
			NSString *toString = @"";
            NSLog(@"toArray %@",toArray);
            for(int i = 0; i < [toArray count]; i++)
            {
                toString = [toString stringByAppendingFormat:@"%@,",[toArray[i]objectFromJSONString][@"name"]];
            }
            if(IS_NULL(toString))
                toString = @"";
            else
            toString = [toString substringToIndex:[toString length]-1];
//			if([toArray count]==2) {
//				toString = [NSString stringWithFormat:@"%@, %@",[toArray[0]objectFromJSONString][@"name"],[toArray[1]objectFromJSONString][@"name"]];
//			} else if([toArray count]>2) {
//				toString = [NSString stringWithFormat:@"%@, %@ 외 %d명",[toArray[0]objectFromJSONString][@"name"],[toArray[1]objectFromJSONString][@"name"],[toArray count]-2];
//			}
			nameLabel.text = toString;
            CGSize nameSize = [nameLabel.text sizeWithAttributes:@{NSFontAttributeName:nameLabel.font}];
            if(nameSize.width > 155)
                nameSize.width = 155;
            memberCountView.frame = CGRectMake(nameLabel.frame.origin.x + nameSize.width + 5, nameLabel.frame.origin.y, 25, 20);
            memberCountView_icon.frame = CGRectMake(2, 6, 9, 8);
            memberCountLabel.frame = CGRectMake(10, 0, memberCountView.frame.size.width-12, memberCountView.frame.size.height);
            memberCountLabel.text = [NSString stringWithFormat:@"%d",(int)[toArray count]];
		}
		senderView.image = [UIImage imageNamed:@"imageview_note_send.png"];
     
	} else {
        memberCountView.hidden = YES;
        memberCountView_icon.hidden = YES;
        memberCountLabel.hidden = YES;
        profileView.hidden = NO;
        inImageView.hidden = YES;
        inImageView2.hidden = YES;
        inImageView3.hidden = YES;
        inImageView4.hidden = YES;
        roundingView.image = [UIImage imageNamed:@"imageview_profile_rounding_1_add.png"];
//		// 수신 // dataItem.contentDic[@"from"]
//		if (([self.readList count] == 1 && [dataItem.type isEqualToString:@"6"])) {
//			profileView.image = nil;
//			senderView.image = nil;
//			nameLabel.text = nil;
//			dateLabel.text = nil;
//            msgLabel.text = nil;
//            roundingView.image = nil;
//			cell.textLabel.font = [UIFont systemFontOfSize:15.0];
//			cell.textLabel.numberOfLines = 1;
//			cell.textLabel.textAlignment = NSTextAlignmentCenter;
//			cell.textLabel.adjustsFontSizeToFitWidth = YES;
//			cell.textLabel.minimumFontSize = 10.0;
//			cell.textLabel.text = dataItem.contentDic[@"msg"];
//			return cell;
//        }
		[SharedAppDelegate.root getProfileImageWithURL:dataItem.profileImage ifNil:@"profile_photo.png" view:profileView scale:0];
		NSString *name = [NSString stringWithFormat:@"%@ %@",dataItem.personInfo[@"name"],dataItem.personInfo[@"position"]];
		nameLabel.text = name;
		senderView.image = [UIImage imageNamed:@"imageview_note_receive.png"];
		msgLabel.textColor = [UIColor grayColor];
		if ([[dataItem.targetdic objectFromJSONString][@"read"] isEqualToString:@"0"]) {
			badge.hidden = NO;
            badgeLabel.text = @"N";
            msgLabel.textColor = [UIColor blackColor];
		}
	}

    NSTimeInterval linuxTime = [dataItem.time floatValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:linuxTime];
    NSLog(@"date %@",date);
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];//시작 yyyy.M.d (EEEE)"];
    
    if([[formatter stringFromDate:now]isEqualToString:[formatter stringFromDate:date]]) // same day
    {
        [formatter setDateFormat:@"a h:mm"];
        dateLabel.text = [formatter stringFromDate:date];
    }
    else{
        [formatter setDateFormat:@"yy.MM.dd"];
        dateLabel.text = [formatter stringFromDate:date];
    }
//    [formatter release];
    
	msgLabel.text = dataItem.contentDic[@"msg"];
    CGSize msgSize = [msgLabel.text sizeWithAttributes:@{NSFontAttributeName:msgLabel.font}];
    if(msgSize.width > 320-80-30){
        msgLabel.frame = CGRectMake(80, 34, 320-80-30, 30);
        msgLabel.numberOfLines = 2;
        
    }
    else{
        
        msgLabel.frame = CGRectMake(80, 34, 320-80-30, 15);
        msgLabel.numberOfLines = 1;
    }
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"didsel %@",tableView.editing?@"YES":@"NO");
    if(tableView.editing == YES){
     if(indexPath.section == 1)
         return;
    }
    else{
    if(indexPath.section == 2 || indexPath.section == 0)
        return;
    }
    [self initFilterList];
    
	if (tableView.editing == YES) {
		// 삭제버튼 갱신
        
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        
        NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
        [self performSelector:@selector(setCountForRightBar:) withObject:count];
        
#else
		if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
			NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
			[self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
		}
#endif
        NSLog(@"editing %@",tableView.editing?@"YES":@"NO");
	} else {
        
        
        if([self.readList count]==0)
        {
#ifdef MQM
#else
            [self writePost];
#endif
            return;
        }
        TimeLineCell *dataItem = nil;
            if([self.readList count]>0){
                dataItem = self.readList[indexPath.row];
                NSLog(@"dataitem.type %@",dataItem.type);
                if([self.readList count] == 1 && [dataItem.type isEqualToString:@"6"]){
#ifdef MQM
#else
                    [self writePost];
#endif
                    return;
                }
                
            }
        
        
        DetailViewController *contentsViewCon = [[DetailViewController alloc] init];//WithViewCon:self];
        contentsViewCon.contentsData = dataItem;
//        [contentsViewCon setHidesBottomBarWhenPushed:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[contentsViewCon class]]){
//            contentsViewCon.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:contentsViewCon animated:YES];
        }
        });
//        [contentsViewCon release];
	
    }
}

- (void)resetViews{
    [myTable reloadData];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView.editing == YES) {
		// 삭제버튼 갱신
        
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
        [self performSelector:@selector(setCountForRightBar:) withObject:count];
#else
        
        
		if ([self.parentViewController isKindOfClass:[CommunicateViewController class]]) {
			NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
			[self.parentViewController performSelector:@selector(setCountForRightBar:) withObject:count];
		}
        
#endif
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if(myTable.editing == YES){
        if(indexPath.section == 1)
            return NO;
        
    }
    else{
    if(indexPath.section == 2 || indexPath.section == 0)
        return NO;
   
    if([readList count]==0)
        return NO;
    
        if([readList count]>0){
        TimeLineCell *dataItem = self.readList[indexPath.row];
        if (([self.readList count] == 1 && [dataItem.type isEqualToString:@"6"])) {
            return NO;
        }
    }
    }
    
    
  
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TimeLineCell *dataItem = nil;//self.readList[indexPath.row];
  
            if([readList count]>0)
                dataItem = readList[indexPath.row];
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
		[SharedAppDelegate.root modifyPost:dataItem.idx
									modify:1 msg:@""
							   oldcategory:@""
							   newcategory:@"" oldgroupnumber:@"" newgroupnumber:@"" target:dataItem.targetdic replyindex:@"" viewcon:self];
		
		if ([[dataItem.targetdic objectFromJSONString][@"read"] isEqualToString:@"0"]) {
			[SharedAppDelegate.root.mainTabBar setNoteBadgeCount:SharedAppDelegate.root.mainTabBar.noteBadgeCount-=1];
		}
        [self.readList removeObject:dataItem];
        
        [originList setArray:self.readList];
		if ([self.readList count] == 0) {
			TimeLineCell *tempCell = [[TimeLineCell alloc] init];
			tempCell.type = @"6";
            
#ifdef MQM
            tempCell.contentDic = @{@"msg" : @"쪽지가 없습니다."};
#else
			tempCell.contentDic = @{@"msg": @"개별 혹은 부서를 선택하여 쪽지를 보낼 수 있습니다."};
#endif
			[self.readList addObject:tempCell];
//			[tempCell release];
            didFetch = YES;
			[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		} else {
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
		}
		
	}
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//    if(buttonIndex == 1)
//    {
//        TimeLineCell *dataItem = self.readList[alertView.tag];
//        NSLog(@"alertview.tag %d",alertView.tag);
//		[SharedAppDelegate.root modifyPost:dataItem.idx
//									modify:1 msg:@""
//							   oldcategory:@""
//							   newcategory:@"" oldgroupnumber:@"" newgroupnumber:@"" target:dataItem.targetdic replyindex:@"" viewcon:self];
//		if ([[dataItem.targetdic objectFromJSONString][@"read"] isEqualToString:@"0"]) {
//			[SharedAppDelegate.root.mainTabBar setNoteBadgeCount:SharedAppDelegate.root.mainTabBar.noteBadgeCount-=1];
//		}
//        [self.readList removeObject:dataItem];
//		if ([self.readList count] == 0) {
//			TimeLineCell *tempCell = [[TimeLineCell alloc] init];
//			tempCell.type = @"6";
//			tempCell.contentDic = @{@"msg": @"우측상단 버튼을 눌러 동료에게 쪽지를 보내보세요."};
//			[self.readList addObject:tempCell];
//			[tempCell release];
//		}
//        [myTable reloadData];
//    }
//}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"scrollviewdidscroll");

    [self initFilterList];
    if([search isFirstResponder]){
        [search resignFirstResponder];
    }
    

    
}


- (void)toggleStatus
{
    
    
    if (editB.tag == kNotEditing) {
        NSUInteger myListCount = (NSUInteger)[self performSelector:@selector(myListCount)];
        if (myListCount == 0) {
            return;
        }
        
        NSLog(@"toggleStatus");
        [self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
        [self.navigationItem setRightBarButtonItem:deleteButton animated:YES];
        [self performSelector:@selector(startEditing)];
        editB.tag = kEditing;
        
    } else {
        
        [self initAction];
    }
}
- (void)initAction{
    [self performSelector:@selector(endEditing)];
    
    
    [self.navigationItem setLeftBarButtonItem:closeButton animated:YES];
    
    
    
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    
    
    NSLog(@"initAction");
    UIButton *rightButton = (UIButton*)deleteButton.customView;
    NSString *delString = @"삭제(0)";
    CGFloat fontSize = 16;
    UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
    CGSize stringSize;
    
    stringSize = [delString sizeWithAttributes:@{NSFontAttributeName: systemFont}];
  
        
    CGRect rightFrame = rightButton.frame;
    rightFrame.size.width = stringSize.width+3.0;
    rightButton.frame = rightFrame;
    [rightButton setTitle:delString forState:UIControlStateNormal];
    editB.tag = kNotEditing;
    
}

- (void)deleteAction
{
    NSLog(@"deleteAction");
    NSUInteger selectedCount = (NSUInteger)[self performSelector:@selector(selectListCount)];
    NSLog(@"selectedCount %d",selectedCount);
    if (selectedCount > 0) {
        NSString *message;
        
       message = @"삭제된 쪽지는 다시 볼 수 없습니다.\n쪽지를 삭제하시겠습니까?";
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"삭제"
                                                                                     message:message
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okb = [UIAlertAction actionWithTitle:@"삭제"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            
                                                            
                                                            
                                                            [self performSelector:@selector(commitDelete)];
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
            
            UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"취소"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){
                                                                [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                            }];
            
            [alertcontroller addAction:cancelb];
            [alertcontroller addAction:okb];
            [self presentViewController:alertcontroller animated:YES completion:nil];
            
        }
        else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"삭제" message:message delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"삭제", nil];
        [alert show];
//        [alert release];
    }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self performSelector:@selector(commitDelete)];
        
    }
}

- (void)setCountForRightBar:(NSNumber*)count
{
    
    NSLog(@"setCountForRightBar");
    if (editB.tag == kEditing) {
        NSLog(@"setCountForRightBar kEditing");
        NSString *titleString = [NSString stringWithFormat:@"삭제(%@)",count];
        //		self.navigationItem.rightBarButtonItem.title = titleString;
        
        UIButton *rightButton = (UIButton*)deleteButton.customView;
        CGFloat fontSize = 16;
        UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
        CGSize stringSize;
        
        
        stringSize = [titleString sizeWithAttributes:@{NSFontAttributeName: systemFont}];
        
            
        
        CGRect rightFrame = rightButton.frame;
        rightFrame.size.width = stringSize.width+3.0;
        rightButton.frame = rightFrame;
        [rightButton setTitle:titleString forState:UIControlStateNormal];
        
        
#ifdef MQM
        int selectedCount = [count intValue];
        NSLog(@"count %@ selectedCount %d",count,selectedCount);
     
        
            NSLog(@"readList %d",[readList count]);
            if(selectedCount < [readList count]){
                 checkButton.selected = NO;
                [checkButton setBackgroundImage:[UIImage imageNamed:@"button_nocheck.png"] forState:UIControlStateNormal];
            }
            else{
                 checkButton.selected = YES;
                [checkButton setBackgroundImage:[UIImage imageNamed:@"button_check.png"] forState:UIControlStateNormal];
            }
        
#endif
        
    }
}


#define kNote 1
#define kNoteGroup 3

- (void)writePost{
		[self loadMember:0];
//    UIActionSheet *objectSelectSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"개별 쪽지",@"부서 쪽지", nil];
//	[objectSelectSheet showInView:self.tabBarController.view];
//	[objectSelectSheet release];
}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//	if (buttonIndex == 0 || buttonIndex == 1) {
//		[self loadMember:buttonIndex];
////		int style;
////		switch (buttonIndex) {
////			case 0:
////				style = kNote;
////				break;
////				
////			case 1:
////				style = kNoteGroup;
////				break;
////		}
////		
////		SendNoteViewController *post = [[SendNoteViewController alloc]initWithStyle:style];
////		UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
////		post.title = @"쪽지 보내기";
////		[self presentViewController:nc animated:YES];
////		[post release];
////		[nc release];
//	}
//	[myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];
//}

@end
