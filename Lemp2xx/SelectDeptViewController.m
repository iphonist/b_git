//
//  SelectDeptViewController.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 10. 17..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "SelectDeptViewController.h"

@interface SelectDeptViewController ()

@end

@implementation SelectDeptViewController
@synthesize target;
@synthesize selector;
@synthesize selectedDeptList;
@synthesize rootTitle;

- (id)initWithTag:(int)t
{
	self = [super init];
	if(self != nil)
	{
		
		selectCodeList = [[NSMutableArray alloc]init];
		addArray = [[NSMutableArray alloc]init];
		myList = [[NSMutableArray alloc]init];
//		selectedDeptList = [[NSMutableArray alloc] init];
		tempSavedDeptList = [[NSMutableArray alloc] init];
		self.rootTitle = @"대상 부서 선택";
		tagInfo = 0;
        self.view.backgroundColor = RGB(246,246,246);
        
#ifdef BearTalk
        self.view.backgroundColor = RGB(238, 242, 245);
#endif
        viewTag = t;
	}
	return self;
}

#define kNote 100

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
//    UIImageView *groupNameView = [[UIImageView alloc]initWithFrame:CGRectMake(0, search.frame.size.height, 320, 40)];
//    //    groupNameView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
//    groupNameView.backgroundColor = RGB(240, 240, 240);
//    [self.view addSubview:groupNameView];
//    groupNameView.userInteractionEnabled = YES;
//    
//#ifdef BearTalk
//    
//    groupNameView.frame = CGRectMake(0, CGRectGetMaxY(search.frame), self.view.frame.size.width, 11+26+11);
//    groupNameView.backgroundColor = RGB(244, 248, 251);
//#endif
//    
//    UILabel *addName;
//    UIButton *addNameImage;
//    //		UIImageView *pathImage;
//    
//				CGSize size;
//    size = [@"홈" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
//#ifdef MQM
//#elif Batong
//    
//    size = [@"ECMD" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
//#endif
//    addNameImage = [[UIButton alloc]initWithFrame:CGRectMake(3, 3, size.width + 15, groupNameView.frame.size.height-6)];
//    addNameImage.tag = 100;
//    //    [addNameImage addTarget:self action:@selector(warp:) forControlEvents:UIControlEventTouchUpInside];
//    addNameImage.layer.cornerRadius = 3; // this value vary as per your desire
//    addNameImage.clipsToBounds = YES;
//    [groupNameView addSubview:addNameImage];
//
//#ifdef BearTalk
//#elif LempMobileNowon
//    [addNameImage setBackgroundColor:RGB(39, 128, 248)];
//#else
//    
//    [addNameImage setBackgroundColor:GreenTalkColor];
//#endif
//    
//    
//    
//    addName = [CustomUIKit labelWithText:@"홈" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
//    
//#ifdef MQM
//#elif Batong
//    
//    addName = [CustomUIKit labelWithText:@"ECMD" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
//#endif
//				[addNameImage addSubview:addName];
//
//    
//#ifdef BearTalk
//    
//    
//    size = [@"조직도" sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
//    addNameImage.backgroundColor = RGB(106,127,137);
//    addName.textColor = RGB(255,255,255);
//    addName.font = [UIFont systemFontOfSize:12];
//    addName.frame = CGRectMake(10, 8, size.width, addNameImage.frame.size.height - 16);
//    addNameImage.frame = CGRectMake(12, 11, size.width + 20, groupNameView.frame.size.height - 22);
//    
//#endif
    
    float viewY = 64;
    
	CGRect tableFrame;
    
	    tableFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - viewY - self.tabBarController.tabBar.frame.size.height - 0);

    
	myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
	myTable.delegate = self;
	myTable.dataSource = self;
	myTable.rowHeight = 50;
#ifdef BearTalk
    myTable.rowHeight = 14+24+14;
#endif
	[self.view addSubview:myTable];
//	[myTable release];
	
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
	UIButton *button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(done:)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];

	[self setFirstButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
	[self checkSameLevel:@"0"];
    [self reloadCheck];
}

//- (void)dealloc {
//    
//	self.rootTitle = nil;
//    [selectCodeList release];
//    [addArray release];
//	[myList release];
////	[selectedDeptList release];
//	[tempSavedDeptList release];
//	target = nil;
//    [super dealloc];
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    NSLog(@"searchBarShouldBeginEditing");
//    
////    [SharedAppDelegate.root loadSearch:4 con:self];
//    
//    return NO;
//}

- (void)done:(id)sender
{
    NSLog(@"selectedDeptList count %d",(int)[selectedDeptList count]);
    if([selectedDeptList count]<1) {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"선택된 부서가 없습니다." con:self];
        return;
    }
    
//	[self dismissViewControllerAnimated:NO completion:nil];
//    [target performSelector:selector withObject:selectedDeptList];
    
    if (self.presentingViewController) {
        NSLog(@"self.presenting %@",self.presentingViewController);
        [self dismissViewControllerAnimated:NO completion:^(void){
            [target performSelector:selector withObject:selectedDeptList];
        }];
    } else {
        NSLog(@"else");
        [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:NO];
        [target performSelector:selector withObject:selectedDeptList];
    }
}

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{    
	self.target = aTarget;
	self.selector = aSelector;
}

- (void)checkSameLevel:(NSString *)code
{
	[myList removeAllObjects];
//	[myDeptList removeAllObjects];
				
	for(NSDictionary *forDic in [ResourceLoader sharedInstance].deptList) {
		if ([code isEqualToString:@"0"]) {
			        self.title = @"대상 부서 선택";
		} else if([forDic[@"mycode"] isEqualToString:code]) {
			self.title = forDic[@"shortname"];
		}
		if([forDic[@"parentcode"] isEqualToString:code]) {
			[myList addObject:forDic];
		}
	}
	
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];

    [myTable reloadData];
	    
}


- (void)setFirstButton
{
//    UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(goHome)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(goHome)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    
}

- (void)setFirst:(NSString *)first
{
    
    firstDept = [[NSString alloc]initWithFormat:@"%@",first];
          self.title = @"대상 부서 선택";
}



- (void)reloadCheck
{
    NSLog(@"reloadCheck");
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직도에서 하위단계로 내려갈 때마다 path를 보여주기 위한 함수.
     연관화면 : 조직도
     ****************************************************************/

    UIImageView *groupNameView = [[UIImageView alloc]initWithFrame:CGRectMake(0, search.frame.size.height, 320, 40)];
    //		groupNameView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
    groupNameView.backgroundColor = RGB(240, 240, 240);
    [self.view addSubview:groupNameView];
    groupNameView.userInteractionEnabled = YES;
    
#ifdef BearTalk
    
    groupNameView.frame = CGRectMake(0, CGRectGetMaxY(search.frame), self.view.frame.size.width, 11+26+11);
    groupNameView.backgroundColor = RGB(244, 248, 251);
    
#endif
    
    myTable.frame = CGRectMake(0, CGRectGetMaxY(groupNameView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(groupNameView.frame));
    
    
    
    if (scrollView) {
//        [scrollView release];
        scrollView = nil;
    }
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, groupNameView.frame.size.height)];
    scrollView.delegate = self;
    [groupNameView addSubview:scrollView];
    
    int w = 0;
    
    UILabel *addName;
    UIButton *addNameImage;
    UILabel *pathLabel;
    //		UIImageView *pathImage;
    
				CGSize size;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
    size = [@"홈" boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
  //  size = [@"홈" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    
    
#ifdef MQM
#elif Batong
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
    size = [@"ECMD" boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
 //   size = [@"ECMD" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
#endif
    
    
    addNameImage = [[UIButton alloc]initWithFrame:CGRectMake(3, 3, size.width + 15, groupNameView.frame.size.height-6)];
    addNameImage.tag = 100;
    [addNameImage addTarget:self action:@selector(warp:) forControlEvents:UIControlEventTouchUpInside];
    addNameImage.layer.cornerRadius = 3; // this value vary as per your desire
    addNameImage.clipsToBounds = YES;
    [addNameImage setBackgroundColor:RGB(224, 224, 222)];
    [scrollView addSubview:addNameImage];
    
     addName = [CustomUIKit labelWithText:@"홈" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
				[addNameImage addSubview:addName];
    
#ifdef BearTalk
    
    addName.text = @"조직도";
    paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
    size = [@"조직도" boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    size = [@"조직도" sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    addNameImage.backgroundColor = RGB(106,127,137);
    addName.textColor = RGB(255,255,255);
    addName.font = [UIFont systemFontOfSize:12];
    addNameImage.frame = CGRectMake(12, 11, size.width + 20, groupNameView.frame.size.height - 22);
    addName.frame = CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height);
#elif MQM
#elif Batong
    addName.text = @"ECMD";
#endif
    
    
    
    UILabel *firstPathLabel = [[UILabel alloc]init];
    //            pathLabel.backgroundColor = [UIColor blueColor];
    firstPathLabel.font = [UIFont systemFontOfSize:13];
    firstPathLabel.textAlignment = NSTextAlignmentCenter;
    firstPathLabel.frame = CGRectMake(CGRectGetMaxX(addNameImage.frame) + 5, 0, 15, groupNameView.frame.size.height);
    [scrollView addSubview:firstPathLabel];

    
#ifdef BearTalk
    w = CGRectGetMaxX(addNameImage.frame)+6;
    
    firstPathLabel.hidden = YES;
    UIImageView *pathImage;
#else
    
    w += 3+addNameImage.frame.size.width + 25;

#endif
    
    
    for(int i = 0; i < [addArray count]; i++)
    {
        firstPathLabel.text = @"〉";
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
        size = [addArray[i] boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
//        size = [addArray[i] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
        
        addNameImage = [[UIButton alloc]initWithFrame:CGRectMake(w, 3, size.width + 15, groupNameView.frame.size.height-6)];
        addNameImage.tag = i;
        [addNameImage addTarget:self action:@selector(warp:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:addNameImage];
        addNameImage.layer.cornerRadius = 3; // this value vary as per your desire
        addNameImage.clipsToBounds = YES;
//        [addNameImage release];
        scrollView.contentOffset = CGPointMake(w, groupNameView.frame.size.height);
        

        pathLabel = [[UILabel alloc]init];
        //            pathLabel.backgroundColor = [UIColor blueColor];
        pathLabel.font = [UIFont systemFontOfSize:13];
        pathLabel.text = @"〉";
        pathLabel.textAlignment = NSTextAlignmentCenter;
        pathLabel.frame = CGRectMake(CGRectGetMaxX(addNameImage.frame) + 5, 0, 15, groupNameView.frame.size.height);
        [scrollView addSubview:pathLabel];
#ifdef BearTalk
        
        paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
        size = [addArray[i] boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        
//        size = [addArray[i] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
        
        pathImage = [[UIImageView alloc]init];
        pathImage.frame = CGRectMake(w, 11+8, 6, 11);
        pathImage.image = [CustomUIKit customImageNamed:@"ic_arrow_right.png"];
        [scrollView addSubview:pathImage];
        
        addNameImage.frame = CGRectMake(CGRectGetMaxX(pathImage.frame)+6, 11, size.width + 20, groupNameView.frame.size.height - 22);
        pathLabel.hidden = YES;
#endif
        
        if(i == [addArray count]-1)
        {
            
#ifdef LempMobileNowon
        
            
            [addNameImage setBackgroundColor:RGB(39, 128, 248)];
#else
            
            [addNameImage setBackgroundColor:GreenTalkColor];
#endif
            pathLabel.hidden = YES;
            
#ifdef BearTalk
            
            addName = [CustomUIKit labelWithText:addArray[i] fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1
                                       alignText:NSTextAlignmentCenter];
            addNameImage.backgroundColor = RGB(66,185,235);
#else
            
            addName = [CustomUIKit labelWithText:addArray[i] fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1
                                       alignText:NSTextAlignmentCenter];
#endif
            
        }
        else
        {
            

            
#ifdef BearTalk
            
            addName = [CustomUIKit labelWithText:addArray[i] fontSize:12 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1
                                       alignText:NSTextAlignmentCenter];
            addNameImage.backgroundColor = RGB(106,127,137);
                  pathLabel.hidden = YES;
#else
            
            addName = [CustomUIKit labelWithText:addArray[i] fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1
                                       alignText:NSTextAlignmentCenter];
            
            [addNameImage setBackgroundColor:RGB(224, 224, 222)];
            pathLabel.hidden = NO;
            
#endif
            
        }
        NSLog(@"addname %@ pathlabel %@",NSStringFromCGRect(addNameImage.frame),NSStringFromCGRect(pathLabel.frame));
        w += addNameImage.frame.size.width + 25;
        scrollView.contentSize = CGSizeMake(w - 20, groupNameView.frame.size.height);
        #ifdef BearTalk
        w = CGRectGetMaxX(addNameImage.frame)+6;
        scrollView.contentSize = CGSizeMake(w, groupNameView.frame.size.height);
#endif
        [addNameImage addSubview:addName];
        
        
    }
    

    
}


- (void)warp:(id)sender
{
    
    if([sender tag]==100)
    {
        tagInfo = 0;
        [self checkSameLevel:@"0"];
        [selectCodeList removeAllObjects];
        [addArray removeAllObjects];
        [self reloadCheck];
        
        [self setFirstButton];
//        [self setFirst:firstDept];
        self.title = @"대상 부서 선택";
        return;
    }
    
    int temp;
    temp = (int)[addArray count]-((int)[sender tag]+1);
    for(int i = 0; i < temp; i++)
    {
        [self upTo];
    }
    [self reloadCheck];
    
}

- (void)goHome
{
 	[self dismissViewControllerAnimated:YES completion:nil];
}


- (void)upTo
{
    
 	if(tagInfo == 0) {
		NSLog(@"0");
		return;
	}
    else if(tagInfo == 1)
    {
        [self setFirstButton];
        [self setFirst:firstDept];
    }

	tagInfo --;
    myTable.contentOffset = CGPointMake(0, 0);
	[self checkSameLevel:selectCodeList[[selectCodeList count]-1]];
	
    [selectCodeList removeLastObject];
    [addArray removeLastObject];
    [self reloadCheck];
}



- (void)selectList:(NSIndexPath*)indexPath
{
	NSMutableArray *tempArray = [[NSMutableArray alloc]init];
	
	NSString *myCode, *myName, *myParent;
	
	if (indexPath.section == 0) {
        if([myList count]<1)
            return;
            
		myCode = myList[indexPath.row][@"mycode"];
		myName = myList[indexPath.row][@"shortname"];
		myParent = myList[indexPath.row][@"parentcode"];
	} else {
        
        NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
		myCode = mydic[@"mycode"];
		myName = mydic[@"shortname"];
		myParent = @"0";
		
		NSLog(@"%@,%@",myCode,myName);
	}
	
	for(NSDictionary *forDic in [ResourceLoader sharedInstance].deptList) {
		if([forDic[@"parentcode"] isEqualToString:myCode]) {
			[tempArray addObject:forDic];
		}
	}
	
	if ([tempArray count] < 1) {
//		[SVProgressHUD showErrorWithStatus:@"최하위 부서입니다!"];
		UIButton *button = [[UIButton alloc] init];
		[button setTitle:[NSString stringWithFormat:@"%i",(int)indexPath.section] forState:UIControlStateApplication];
		[button setTitle:[NSString stringWithFormat:@"%i",(int)indexPath.row] forState:UIControlStateDisabled];
		
		[self addSelectList:button];
//		[button release];
		return;
	}
	
    myTable.contentOffset = CGPointMake(0, 0);
    
//    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(upTo)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = nil;//btnNavi;
//    [btnNavi release];
	
    self.title = myName;//[arrayobjectatindex:[array count]-1];
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
	[addArray addObject:self.title];
	[self reloadCheck];
	
	
	if (subList) {
//		[subList release];
		subList = nil;
	}
	subList = [[NSMutableArray alloc]initWithArray:tempArray];
//	[tempArray release];
	
	[selectCodeList addObject:myParent];
		
	[myList removeAllObjects];
	[myList setArray:subList];
	
	tagInfo++;
	
	[myTable reloadData];
	
}


- (void)refreshSearchFavorite:(NSString *)uid fav:(NSString *)fav{
    
//	for(int i = 0; i < [subPeopleList count]; i++){
//		if([subPeopleList[i][@"uniqueid"]isEqualToString:uid]){
//			[subPeopleList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:subPeopleList[i] object:fav key:@"favorite"]];
//		}
//	}
    
    [myTable reloadData];
}

- (void)addSelectList:(id)sender
{
	UIButton *button = (UIButton*)sender;
	NSString *sectionString = [button titleForState:UIControlStateApplication];
	NSString *rowString = [button titleForState:UIControlStateDisabled];
	NSInteger sectionIndex = [sectionString integerValue];
	NSInteger rowIndex = [rowString integerValue];
	
	[SVProgressHUD showWithStatus:@"처리 중..." maskType:SVProgressHUDMaskTypeClear];
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		NSString *myCode;
		if (sectionIndex == 0) {
			myCode = myList[rowIndex][@"mycode"];
		} else {
			myCode = [SharedAppDelegate readPlist:@"myinfo"][@"deptcode"];
		}
		NSMutableArray *selectedArray = (NSMutableArray*)[[ResourceLoader sharedInstance] deptRecursiveSearch:myCode];

		//back to main thread
//		dispatch_async(dispatch_get_main_queue(), ^{
			NSLog(@"seleceted %@",selectedArray);
			BOOL isExist = NO;
			
			for (NSString *code in selectedArray) {
				if ([selectedDeptList containsObject:code]) {
					[button setSelected:NO];
					[selectedDeptList removeObject:code];
					isExist = YES;
				}
			}
			[SVProgressHUD dismiss];
            
			if (!isExist) {
                
                
                
                
				[tempSavedDeptList removeAllObjects];
				[tempSavedDeptList addObjectsFromArray:selectedArray];
				
				if ([tempSavedDeptList count] == 1) {
					NSString *selectDept = [tempSavedDeptList objectAtIndex:0];
					if (![selectedDeptList containsObject:selectDept]) {
                        
                        [selectedDeptList addObject:selectDept];
                        
                        NSMutableArray *selectMembers = [NSMutableArray array];
                        for (NSDictionary *dic in [[ResourceLoader sharedInstance].contactList copy]) {
                            if (![dic[@"uniqueid"] isEqualToString:[ResourceLoader sharedInstance].myUID] && [selectedDeptList containsObject:dic[@"deptcode"]]) {
                                [selectMembers addObject:dic];
                            }
                        }
                        
                        NSLog(@"selectedDeptList %@",selectedDeptList);
                        NSLog(@"[selectMembers count] %d",(int)[selectMembers count]);
                        if([selectMembers count]>99 && viewTag == kNote){
                            
                            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"100명 이상 선택할 수 없습니다." con:self];
                            [selectedDeptList removeObject:selectDept];
                          
                        }
                        
					}
					[myTable reloadData];
                    
                    
                } else {
                    NSString *deptName = [[ResourceLoader sharedInstance] searchCode:tempSavedDeptList[0]];
                    NSString *msg = [NSString stringWithFormat:@"%@에 속한 부서도\n함께 선택하시겠습니까?",deptName];
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                        
                        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@""
                                                                                                 message:msg
                                                                                          preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * action){
                                                                        
                                                                        [self confirmSelectDeptContact];
                                                                        
                                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                                    }];
                        
                        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                                          style:UIAlertActionStyleDefault
                                                                        handler:^(UIAlertAction * action){
                                                                            
                                                                            [self confirmSelectDept];
                                                                            
                                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                                        }];
                        
                        [alertcontroller addAction:cancelb];
                        [alertcontroller addAction:okb];
                        [self presentViewController:alertcontroller animated:YES completion:nil];
                        
                    }
                    else{
					UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
					[alertView show];
					alertView.tag = 33;
//					[alertView release];
                    }
				}
			} else {
                
                
                
                // ######
                NSLog(@"here");
                
                
				[myTable reloadData];
                
                
			}
            
            
            
            
            
            
   
		
//        });
//	
//    });
    
}

- (void)confirmSelectDept{
    
				NSString *selectDept = [tempSavedDeptList objectAtIndex:0];
				if (![selectedDeptList containsObject:selectDept]) {
                    [selectedDeptList addObject:selectDept];
                    
                    
                }
				
				[myTable reloadData];
    
    
    
    
}
- (void)confirmSelectDeptContact{
    
				for (NSString *selectDept in tempSavedDeptList) {
                    if (![selectedDeptList containsObject:selectDept]) {
                        [selectedDeptList addObject:selectDept];
                        
                        
                        
                        
                    }
                }
    
    NSMutableArray *selectMembers = [NSMutableArray array];
    for (NSDictionary *dic in [[ResourceLoader sharedInstance].contactList copy]) {
        if (![dic[@"uniqueid"] isEqualToString:[ResourceLoader sharedInstance].myUID] && [selectedDeptList containsObject:dic[@"deptcode"]]) {
            [selectMembers addObject:dic];
        }
    }
    
    NSLog(@"[selectMembers count] %d",(int)[selectMembers count]);
    if([selectMembers count]>99 && viewTag == kNote){
        
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"100명 이상 선택할 수 없습니다." con:self];
        for (NSString *selectDept in tempSavedDeptList) {
            if ([selectedDeptList containsObject:selectDept]) {
                [selectedDeptList removeObject:selectDept];
                
                
                
            }
        }
    }
    
    
    
    //				[SVProgressHUD showWithStatus:@"추가 중..."];
    //				dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    //					NSArray *selectedArray = [SharedAppDelegate.root deptRecursiveSearch:myList[selectedRow][@"mycode"]];
    //					//back to main thread
    //					dispatch_async(dispatch_get_main_queue(), ^{
    //						NSLog(@"seleceted %@",selectedArray);
    //						[selectedDeptList removeAllObjects];
    //						[selectedDeptList addObjectsFromArray:selectedArray];
    //						[myTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    //						[SVProgressHUD dismiss];
    //					});
    //				});
				[myTable reloadData];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 33) {
		switch (buttonIndex) {
            case 0:{
                [self confirmSelectDept];
                
				break;
                
            }
			case 1:
			{
                
                [self confirmSelectDeptContact];
                
				break;
                
			}
		}
	}
}

#pragma mark -
#pragma mark Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(section == 1){
        
#ifdef BearTalk
        return 7+12+7;
#endif
        return 28;
    }
    else
        return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView.alloc initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    headerView.backgroundColor = RGB(249, 249, 249);
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 3, 320-12, 22)];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [headerLabel setTextColor:[UIColor blackColor]];
    [headerLabel setTextAlignment:NSTextAlignmentLeft];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    NSString *headerTitle = @"";
    
#ifdef BearTalk
    headerView.frame = CGRectMake(0, 0, myTable.frame.size.width, 7+12+7);
    headerView.backgroundColor = RGB(238, 242, 245);
    headerLabel.frame = CGRectMake(16, 7, 100, 12);
    headerLabel.font = [UIFont systemFontOfSize:13];
    headerLabel.textColor = RGB(161,176,191);
#endif
    
    
    if (section == 1) {
		headerTitle = @"내 부서";
	} else {
		headerTitle = @"";
	}
    
    headerLabel.text = headerTitle;
    
    [headerView addSubview:headerLabel];
    return headerView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	if (tagInfo < 1) {
		return 2;
	} else {
		return 1;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch (section) {
		case 1:
			return 1;
			break;
			
		default:
			return [myList count];
			break;
	}
//	return [myList count];
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
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UILabel *name;
    UIImageView *profileView, *bgView;
    UIImageView *accView;
	UIButton *checkButton;
    UIImageView *checkView, *checkAddView;
    float xPadding = 0.0f;
    
    UITableViewCell *cell = nil;//[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if(cell == nil)	{
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        

//        [checkButton release];
		

		profileView = [[UIImageView alloc]init];
		profileView.frame = CGRectMake(40, 12, 34, 23);
		profileView.tag = 1;
		profileView.image = nil;
		[cell.contentView addSubview:profileView];
//		[profileView release];

		name = [[UILabel alloc]init];
		name.frame = CGRectMake(85, 14, 220, 20);
		name.backgroundColor = [UIColor clearColor];
		name.font = [UIFont systemFontOfSize:15];
		name.tag = 2;
		[cell.contentView addSubview:name];
//		[name release];
		
		accView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arr_ic.png"]];
		accView.tag = 4;
		cell.accessoryView = accView;
//		[accView release];
		
		bgView = [[UIImageView alloc]init];
		bgView.tag = 5;
		cell.backgroundView = bgView;
//		[bgView release];
		
        
#ifdef BearTalk
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        xPadding = 16 + 24 + 10;
        profileView.frame = CGRectMake(0, 0, 0, 0);
        name.frame = CGRectMake(xPadding, 14, 250, 24);
        accView.hidden = YES;
        checkView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 14, 24, 24)];
        checkView.tag = 50;
        checkView.layer.borderWidth = 1.0;
        checkView.layer.cornerRadius = checkView.frame.size.width/2;
        checkView.backgroundColor = RGB(249,249,249);//[NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        checkView.layer.borderColor = checkView.backgroundColor.CGColor;
        [cell.contentView addSubview:checkView];
        
        checkAddView = [[UIImageView alloc]init];
        checkAddView.tag = 51;
        checkAddView.backgroundColor = RGB(251,251,251);
        checkAddView.image = [UIImage imageNamed:@"select_check_white.png"];
        checkAddView.frame = CGRectMake(checkView.frame.size.width/2-16/2, checkView.frame.size.height/2-13/2, 16, 13);
        checkAddView.backgroundColor = [UIColor clearColor];
        [checkView addSubview:checkAddView];
        
#endif
        
        checkButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 10, 29, 29)];
        checkButton.tag = 3;
        [checkButton setImage:[UIImage imageNamed:@"n09_gtalk_ch_dtf.png"] forState:UIControlStateNormal];
        //		[checkButton setImage:[UIImage imageNamed:@"n09_gtalk_ch_prs.png"] forState:UIControlStateHighlighted];
        [checkButton setImage:[UIImage imageNamed:@"n09_gtalk_ch_prs.png"] forState:UIControlStateSelected];
        [checkButton addTarget:self action:@selector(addSelectList:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:checkButton];
        
#ifdef BearTalk
        
        checkButton.frame = checkView.frame;
        [checkButton setImage:nil forState:UIControlStateNormal];
        [checkButton setImage:nil forState:UIControlStateSelected];
#endif

        
	} else {
		checkButton = (UIButton *)[cell viewWithTag:3];
		profileView = (UIImageView *)[cell viewWithTag:1];
		name = (UILabel *)[cell viewWithTag:2];
		bgView = (UIImageView *)[cell viewWithTag:5];
		accView = (UIImageView *)[cell viewWithTag:4];
#ifdef BearTalk
        checkView = (UIImageView *)[cell viewWithTag:50];
        checkAddView = (UIImageView *)[cell viewWithTag:51];
#endif
	}
    
    bgView.backgroundColor = RGB(219,215,212);

    profileView.image = [CustomUIKit customImageNamed:@"grp_icon.png"];
	[checkButton setTitle:[NSString stringWithFormat:@"%i",(int)indexPath.section] forState:UIControlStateApplication];
	[checkButton setTitle:[NSString stringWithFormat:@"%i",(int)indexPath.row] forState:UIControlStateDisabled];
	[checkButton setSelected:NO];
    
#ifdef BearTalk
    
    
    checkView.backgroundColor = RGB(249,249,249);
    checkView.layer.borderColor = [RGB(223, 223, 223)CGColor];
    checkAddView.image = nil;
    
    bgView.backgroundColor = [UIColor whiteColor];
    profileView.hidden = YES;
    
#endif
	NSString *deptCode;
	if (indexPath.section == 0) {
		name.text = myList[indexPath.row][@"shortname"];
		deptCode = myList[indexPath.row][@"mycode"];
	} else {
		name.text = [SharedAppDelegate readPlist:@"myinfo"][@"deptname"];
		deptCode = [SharedAppDelegate readPlist:@"myinfo"][@"deptcode"];
	}

	if ([selectedDeptList containsObject:deptCode]) {
		[checkButton setSelected:YES];
#ifdef BearTalk
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        checkView.backgroundColor = BearTalkColor;//[NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        checkView.layer.borderColor = checkView.backgroundColor.CGColor;
            checkAddView.image = [CustomUIKit customImageNamed:@"select_check_white.png"];
#endif
        
        
	}
	
	BOOL isExist = NO;
	for(NSDictionary *forDic in [ResourceLoader sharedInstance].deptList) {
		if([forDic[@"parentcode"] isEqualToString:deptCode]) {
			isExist = YES;
			break;
		}
	}
	
	if (isExist) {
        accView.hidden = NO;
#ifdef BearTalk
        accView.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
#endif
	} else {
        accView.hidden = YES;
#ifdef BearTalk
        accView.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
#endif
	}
	return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
	[self selectList:indexPath];
}


@end
