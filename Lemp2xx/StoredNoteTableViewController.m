//
//  StoredNoteTableViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 9. 24..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "StoredNoteTableViewController.h"
#import "TimeLineCell.h"
#import "DetailViewController.h"
#import <objc/runtime.h>

@interface StoredNoteTableViewController ()

@end

const char paramNumber;
@implementation StoredNoteTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"보관함";
    }
    return self;
}

- (void)settingList:(NSMutableArray *)array{
    
    if(storedList){
//        [storedList release];
        storedList = nil;
    }
    if(originList){
//        [originList release];
        originList = nil;
    }
    
    storedList = [[NSMutableArray alloc]initWithArray:array];
    
    noteTag = 0;
    originList = [[NSMutableArray alloc]initWithArray:array];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    UIButton *button;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    closeButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = closeButton;
   
    
	button = [CustomUIKit buttonWithTitle:@"편집" fontSize:16 fontColor:[UIColor blackColor] target:self selector:@selector(toggleStatus) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
	editButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	self.navigationItem.rightBarButtonItem = editButton;
   
    
    
    
	button = [CustomUIKit buttonWithTitle:@"취소" fontSize:16 fontColor:[UIColor blackColor] target:self selector:@selector(toggleStatus) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
	cancelButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    
	CGRect tableFrame;
    
	    tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height); // 네비(44px) + 상태바(20px)

        
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
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
	[self.view addSubview:myTable];
    
//	NSString *delString = @"삭제(0)";
//	CGFloat fontSize = 16;
//	UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
//	CGSize stringSize;
//	if ([delString respondsToSelector:@selector(sizeWithAttributes:)]) {
//		stringSize = [delString sizeWithFont: systemFont];
//	} else {
//		stringSize = [delString sizeWithFont:systemFont];
//	}
//    
//	 button = [CustomUIKit buttonWithTitle:delString fontSize:fontSize fontColor:[UIColor redColor] target:self selector:@selector(deleteAction) frame:CGRectMake(0, 0, stringSize.width+3.0, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
//	deleteButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    
    NSLog(@"storedList %@",storedList);
//    self.tableView.rowHeight = 70;
   
    UIView *filterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
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
    
    dropView.frame = CGRectMake(13, 44 + 20 + filterView.frame.origin.y + filterView.frame.size.height - 10, topView.frame.size.width, bottomView.frame.origin.y + bottomView.frame.size.height);
    
    opt1Label = [CustomUIKit labelWithText:@"전체쪽지" fontSize:12 fontColor:[UIColor blackColor] frame:CGRectMake(10, 0, opt1View.frame.size.width-20, opt1View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [opt1View addSubview:opt1Label];
    
    opt2Label = [CustomUIKit labelWithText:@"받은쪽지" fontSize:12 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, opt2View.frame.size.width-20, opt2View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [opt2View addSubview:opt2Label];
    
    opt3Label = [CustomUIKit labelWithText:@"보낸쪽지" fontSize:12 fontColor:[UIColor darkGrayColor] frame:CGRectMake(10, 0, opt3View.frame.size.width-20, opt3View.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [opt3View addSubview:opt3Label];
    

    
	 myTable.allowsMultipleSelectionDuringEditing = YES;
    [myTable reloadData];
    
    
	searchList = [[NSMutableArray alloc]init];
    
    noteTag = 0;
    filterLabel.text = @"전체쪽지";
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self initFilterList];
    if([search isFirstResponder]){
        [search resignFirstResponder];
    }
    
}
#pragma mark - search

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar // 서치바 터치하는 순간 들어옴.
{
    
    
    
    
    [searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:UIButton.class]){
            [(UIButton*)subView setTitle:@"취소" forState:UIControlStateNormal];
        }
    }
    
    
    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    
    [searchBar setShowsCancelButton:NO animated:YES];
    
    [searchBar resignFirstResponder];
    
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText // 터치바에 글자 쓰기
{
    [searchList removeAllObjects];
    NSLog(@"searchList %@",searchList);
    NSLog(@"storedList %@",storedList);
    
    
    if([searchText length]>0)
    {
        
        
        searching = YES;
        for(int i = 0 ; i < [storedList count] ; i++)
        {
            
            TimeLineCell *dataItem = storedList[i];
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
                if([[name lowercaseString]rangeOfString:[searchText lowercaseString]].location != NSNotFound)
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
//
//- (void)cmdFilter2:(id)sender{
//    NSLog(@"cmdFilter");
//    
//    
//    UIActionSheet *actionSheet;
//    
//    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
//                                destructiveButtonTitle:nil otherButtonTitles:@"전체쪽지",@"받은쪽지",@"보낸쪽지", nil];
//    
//    [actionSheet showInView:SharedAppDelegate.window];
//    
//    
//    
//}
//

- (void)cmdFilterList:(id)sender{
    
    
    [self initFilterList];
    
    [storedList removeAllObjects];
    
    NSLog(@"originlist %@",originList);
    
    
    switch ([sender tag])
    {
        case 0:
        {
            [storedList setArray:originList];
            filterLabel.text = @"전체쪽지";
            
            
        }
            break;
        case 1:
        {
            
            for(TimeLineCell *cell in originList){
                
                if(![cell.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    [storedList addObject:cell];
                }
            }
            filterLabel.text = @"받은쪽지";
            
        }
            break;
        case 2:
        {
            for(TimeLineCell *cell in originList){
                if([cell.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    [storedList addObject:cell];
                }
            }
            filterLabel.text = @"보낸쪽지";
            
            
            
            
        }
            break;
    }
    
    if(searching){
        
        [self searchBar:search textDidChange:search.text];
    }
    
    
    
    noteTag = [sender tag];
    
    [myTable reloadData];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    if(buttonIndex == 3) // cancel
        return;
    
    [storedList removeAllObjects];
    
    
    switch (buttonIndex)
    {
        case 0:
        {
            [storedList setArray:originList];
            
            
        }
            break;
        case 1:
        {
            
            for(TimeLineCell *cell in originList){
                
                if(![cell.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    [storedList addObject:cell];
                }
            }
            
        }
            break;
        case 2:
        {
            for(TimeLineCell *cell in originList){
                if([cell.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    [storedList addObject:cell];
                }
            }
            
            
            
            
        }
            break;
    }
    
    if(searching){
        
        [self searchBar:search textDidChange:search.text];
    }
    
    
    noteTag = buttonIndex;
    
    [myTable reloadData];
    
}



- (void)cancel//:(id)sender
{
    if([storedList count] != [originList count])
    [SharedAppDelegate.root.note refreshTimeline];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleStatus
{
    NSLog(@"toggleStatus %@",myTable.editing?@"YES":@"NO");
    
    
	if (myTable.editing == NO) {
        
		if ([storedList count] == 0) {
			return;
		}
        
        if(deleteButton){
            
//            [deleteButton release];
            deleteButton = nil;
        }
        
        NSString *delString = @"삭제(0)";
        CGFloat fontSize = 16;
        UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
        CGSize stringSize;
//        if ([delString respondsToSelector:@selector(sizeWithAttributes:)]) {
//            stringSize = [delString sizeWithAttributes:@{NSFontAttributeName: systemFont}];
//        } else {
            stringSize = [delString sizeWithAttributes:@{NSFontAttributeName:systemFont}];
//        }
        
        UIButton *button = [CustomUIKit buttonWithTitle:delString fontSize:fontSize fontColor:[UIColor redColor] target:self selector:@selector(deleteAction) frame:CGRectMake(0, 0, stringSize.width+3.0, 32) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        deleteButton = [[UIBarButtonItem alloc] initWithCustomView:button];
      
        
		[self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
		[self.navigationItem setRightBarButtonItem:deleteButton animated:YES];
        
            [myTable setEditing:YES animated:YES];
        
        
	} else {
        
        [myTable setEditing:NO animated:YES];
        
            
        [self.navigationItem setLeftBarButtonItem:closeButton animated:YES];
		[self.navigationItem setRightBarButtonItem:editButton animated:YES];
        
//		UIButton *rightButton = (UIButton*)deleteButton.customView;
//		NSString *delString = @"삭제(0)";
//		CGFloat fontSize = 16;
//		UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
//		CGSize stringSize;
//		
//		if ([delString respondsToSelector:@selector(sizeWithAttributes:)]) {
//			stringSize = [delString sizeWithFont: systemFont];
//		} else {
//			stringSize = [delString sizeWithFont:systemFont];
//		}
//		CGRect rightFrame = rightButton.frame;
//		rightFrame.size.width = stringSize.width+3.0;
//		rightButton.frame = rightFrame;
//		[rightButton setTitle:delString forState:UIControlStateNormal];
        
	}
}

- (void)setCountForRightBar:(NSNumber*)count
{
	if (myTable.editing == YES) {
		NSString *titleString = [NSString stringWithFormat:@"삭제(%@)",count];
        //		self.navigationItem.rightBarButtonItem.title = titleString;
		
		UIButton *rightButton = (UIButton*)deleteButton.customView;
		CGFloat fontSize = 16;
		UIFont *systemFont = [UIFont systemFontOfSize:fontSize];
		CGSize stringSize;
		
//		if ([titleString respondsToSelector:@selector(sizeWithAttributes:)]) {
//            stringSize = [titleString sizeWithAttributes:@{NSFontAttributeName: systemFont}];
//		} else {
            stringSize = [titleString sizeWithAttributes:@{NSFontAttributeName:systemFont}];
//		}
		
		CGRect rightFrame = rightButton.frame;
		rightFrame.size.width = stringSize.width+3.0;
		rightButton.frame = rightFrame;
		[rightButton setTitle:titleString forState:UIControlStateNormal];
		
	}
}


- (void)commitDelete
{
    NSLog(@"editing %@",myTable.editing?@"YES":@"NO");
    
	if (myTable.editing == YES && [storedList count] > 0) {
		if ([myTable.indexPathsForSelectedRows count] > 0) {
			NSMutableString *selectedIdx = [NSMutableString string];
			NSMutableString *selectedTarget = [NSMutableString string];
			
			NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
			NSInteger remainCount = 0;
			
			for (NSIndexPath *indexPath in myTable.indexPathsForSelectedRows) {
				TimeLineCell *dataItem = storedList[indexPath.row];
                
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
			
			
            
			[storedList removeObjectsAtIndexes:indexSet];
			
			if ([storedList count] == 0) {
				[myTable reloadData];
			} else {
				[myTable deleteRowsAtIndexPaths:[myTable indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
			}
            NSLog(@"commitDelete end");
			[self performSelector:@selector(toggleStatus)];
			
		} else {
			[CustomUIKit popupSimpleAlertViewOK:nil msg:@"선택된 쪽지가 없습니다." con:self];
		}
	}
}

#define kSingle 1
#define kMulti 2

- (void)deleteAction
{
	if ([self selectListCount] > 0) {
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
        alert.tag = kMulti;
//		[alert release];
	}
    }else {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"선택된 쪽지가 없습니다." con:self];
    }
}

- (void)confirmSingle:(int)row
{
    
    
    TimeLineCell *dataItem = storedList[row];
    [SharedAppDelegate.root modifyPost:dataItem.idx
                                modify:1 msg:@""
                           oldcategory:@""
                           newcategory:@"" oldgroupnumber:@"" newgroupnumber:@"" target:dataItem.targetdic replyindex:@"" viewcon:self];
    
    [storedList removeObjectAtIndex:row];
    
    [myTable reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		if(alertView.tag == kMulti)
			[self performSelector:@selector(commitDelete)];
        else if(alertView.tag == kSingle){
            
            NSString *rowString = objc_getAssociatedObject(alertView, &paramNumber);
            [self confirmSingle:[rowString intValue]];

            
        }
		}
	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        NSString *message;
        message = @"삭제된 쪽지는 다시 볼 수 없습니다.\n쪽지를 삭제하시겠습니까?";
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"삭제"
                                                                                     message:message
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okb = [UIAlertAction actionWithTitle:@"삭제"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            
                                                            
                                                            [self confirmSingle:(int)indexPath.row];
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
        objc_setAssociatedObject(alert, &paramNumber, [NSString stringWithFormat:@"%d",(int)indexPath.row], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        alert.tag = kSingle;
//		[alert release];
        }
        
        
//		NSString *message;
//        message = @"삭제된 쪽지는 다시 볼 수 없습니다.\n쪽지를 삭제하시겠습니까?";
//        
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"삭제" message:message delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"삭제", nil];
//        [alert show];
//        alert.tag = kMulti;
//		[alert release];
//        
//        TimeLineCell *dataItem = storedList[indexPath.row];
//        [SharedAppDelegate.root modifyPost:dataItem.idx
//                                    modify:1 msg:@""
//                               oldcategory:@""
//                               newcategory:@"" oldgroupnumber:@"" newgroupnumber:@"" target:dataItem.targetdic replyindex:@"" viewcon:self];
//        
//        [storedList removeObjectAtIndex:indexPath.row];
//        if([storedList count]==0)
//            [tableView reloadData];
//        else
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
}
- (NSUInteger)selectListCount
{
	return myTable?[myTable.indexPathsForSelectedRows count]:0;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(section == 1)
        return 35;
    
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section != 1)
        return nil;
    
	UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myTable.frame.size.width, 35)];
    headerView.backgroundColor = [UIColor grayColor];
    headerView.image = [CustomUIKit customImageNamed:@"headersectionbg.png"];
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 320-10-10, 20)];
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
    
    if(searching)
        headerLabel.text = [headerLabel.text stringByAppendingFormat:@" 검색결과 %d",(int)[searchList count]];
    else
        headerLabel.text = [headerLabel.text stringByAppendingFormat:@" %d",(int)[storedList count]];
    
    [headerView addSubview:headerLabel];
    
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
 
            return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 0)
        return 1;
    else{
    if(searching){
            return [searchList count];
    }
    else{
            return [storedList count]==0?1:[storedList count];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 45;
    else
        return 75;
    
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
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		
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
//		nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		nameLabel.tag = 2;
		nameLabel.font = [UIFont systemFontOfSize:15.0];
		nameLabel.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:nameLabel];
		
		UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(214.0, nameLabel.frame.origin.y, 100.0, 20.0)];
//		dateLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		dateLabel.tag = 3;
		dateLabel.font = [UIFont systemFontOfSize:12];
		dateLabel.textColor = [UIColor grayColor];
		dateLabel.textAlignment = NSTextAlignmentRight;
		dateLabel.backgroundColor = [UIColor clearColor];
		[cell.contentView addSubview:dateLabel];
		
		UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 34, 320-80-30, 15)];
//		msgLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
//        memberCountView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
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
	
    if(indexPath.section == 0 && indexPath.row == 0){
        
        memberCountView.hidden = YES;
        memberCountLabel.hidden = YES;
        memberCountView_icon.hidden = YES;
        profileView.hidden = YES;
        inImageView.hidden = YES;
        inImageView2.hidden = YES;
        inImageView3.hidden = YES;
        inImageView4.hidden = YES;
        profileView.image = nil;
        senderView.image = nil;
        nameLabel.text = nil;
        dateLabel.text = nil;
        roundingView.image = nil;
        msgLabel.text = @"";
        
        return cell;
    }
    if(indexPath.section == 1 && [storedList count]==0){
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
        msgLabel.frame = CGRectMake(105, 27, 160, 15);
            msgLabel.text = @"보관한 쪽지가 없습니다.";
            return cell;
        
    }
    
    if(searching){
        dataItem = searchList[indexPath.row];
        
    }
    else{
        
        dataItem = storedList[indexPath.row];
    }
    msgLabel.frame = CGRectMake(80, 34, 320-80-30, 15);
    
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
            toString = [toString substringToIndex:[toString length]-1];
      
			nameLabel.text = toString;
            CGSize nameSize = [nameLabel.text sizeWithAttributes:@{NSFontAttributeName:nameLabel.font}];
            if(nameSize.width > nameLabel.frame.size.width)
                nameSize.width = nameLabel.frame.size.width;
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
    if(indexPath.section == 0){
        return;
    }
    if([storedList count]==0){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    [self initFilterList];
    if (tableView.editing == YES) {
		// 삭제버튼 갱신
			NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
			[self performSelector:@selector(setCountForRightBar:) withObject:count];
		
	} else {
        TimeLineCell *dataItem = nil;
        
        
        if([storedList count]>0){
            dataItem = storedList[indexPath.row];
            
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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView.editing == YES) {
		// 삭제버튼 갱신
			NSNumber *count = [NSNumber numberWithInteger:[[tableView indexPathsForSelectedRows] count]];
			[self performSelector:@selector(setCountForRightBar:) withObject:count];
		
	}
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"canEdit");
    if(indexPath.section == 0)
        return NO;
    
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self initFilterList];
    filterLabel.text = @"전체쪽지";
    noteTag = 0;
    search.text = @"";
    searching = NO;
    [search setShowsCancelButton:NO animated:NO];
    [myTable reloadData];
}
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
