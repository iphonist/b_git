//
//  OrganizeViewController.m
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 2. 12..
//  Copyright 2012 Benchbee. All rights reserved.
//

#import "OrganizeViewController.h"
//#import "UIImageView+AsyncAndCache.h"

@implementation OrganizeViewController

@synthesize addArray, selectCodeList;
@synthesize tagInfo;
#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


- (id)init
{
		self = [super init];
		if(self != nil)
		{
            NSLog(@"init");
            myList = [[NSMutableArray alloc]init];
            selectCodeList = [[NSMutableArray alloc]init];
            addArray = [[NSMutableArray alloc]init];
			subPeopleList = [[NSMutableArray alloc]init];
            subList = [[NSMutableArray alloc]init];

			select = NO;
			
            self.view.backgroundColor = RGB(246,246,246);//[UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"n01_tl_background.png"]];
            
#ifdef BearTalk
            self.view.backgroundColor = RGB(238, 242, 245);
#endif
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProfiles) name:@"refreshProfiles" object:nil];

		}
		return self;
}

- (void)refreshProfiles
{
	[myTable reloadData];
}
//- (void)settingDisableViewOverlay:(int)t
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 태그에 따라 뒤에 불투명한 뷰를 크기를 조정해 붙이거나 떼어준다.
//     param - t(int) : 태그
//     연관화면 : 검색/상세정보/고객상세정보
//     ****************************************************************/
//    
//		/*
//		 t=1:addSubview
//		 t=2:removeFromsuperview
//		 */
//		
////		id AppID = [[UIApplication sharedApplication]delegate];
////		if(t ==1)
////				[self.view addSubview:[AppID showDisableViewX:0 Y:search.frame.size.height W:320 H:480-kSTATUS_HEIGHT-kNAVIBAR_HEIGHT-search.frame.size.height]];
////		
////		else if(t ==3)
////				[self.view addSubview:[AppID showDisableViewX:0 Y:0 W:320 H:480-kSTATUS_HEIGHT-kNAVIBAR_HEIGHT]];
////		
////		else if(t ==2)
////				[AppID hideDisableView];
//}


#define kOrganize 4
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"searchBarShouldBeginEditing");
    
    [SharedAppDelegate.root loadSearch:kOrganize];
    
    
    return NO;
}
- (void)loadSearch{
    
    [SharedAppDelegate.root loadSearch:kOrganize];
}
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar // 서치바 터치하는 순간 들어옴.
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 검색바를 터치하는 순간 들어오는 함수. 뒤의 화면을 불투명하게 해 주고 초성배열을 만든다.
//     param - searchBar(UISearchBar *) : 검색바
//     연관화면 : 검색
//     ****************************************************************/
//    
//    [SharedAppDelegate.root loadSearch:kSearch con:self];
//    
//
//    
////    if(searching)
////        return;
////    
////    
////    // 다른 어플들은, 서치바 클릭하는 순간, 뒤에 뷰는 터치가 불가능.	& 네비게이션 바가 사라진다.	
////    
////    
////    id AppID = [[UIApplication sharedApplication]delegate];
////    [self settingDisableViewOverlay:1];
////    
////    
////    [searchBar setShowsCancelButton:YES animated:YES];
////    
////    myTable.userInteractionEnabled = NO;	
////    
////    NSString *name = @"";//[[NSString alloc]init];
////    chosungArray = [[NSMutableArray alloc]init];
////    for(NSDictionary *forDic in originList)//int i = 0 ; i < [originList count] ; i ++)
////    {
////        name = [forDicobjectForKey:@"name"];
////        NSString *str = [AppID GetUTF8String:name];
////        [chosungArray addObject:str];
////    }
////    
////    searching = YES;
////    
//}
//
//
//
//
//- (void)enableCancelButton:(UISearchBar *)searchBar
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 취소 버튼을 활성화 시킴.
//     param - searchBar(UISearchBar *) : 검색바
//     연관화면 : 검색
//     ****************************************************************/
//    
//    		NSLog(@"enablecancelbutton");
//    for (id subview in [searchBar subviews])
//    {
//        if([subview isKindOfClass:[UIButton class]])
//        {
//            [subview setEnabled:TRUE];
//        }
//    }
//}
//
//
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText // 터치바에 글자 쓰기
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 검색바에 글자를 썼을 때 들어오는 함수. 들어온 스트링을 검색해 copyList라는 임시 검색결과배열에 추가한다.
//     param - searchBar(UISearchBar *) : 검색바 
//           - searchText(NSString *) : 검색하는 스트링
//     연관화면 : 검색
//     ****************************************************************/
//    
//    		NSLog(@"textdidchange");
//    [copyList removeAllObjects];
//    
//    
//    
//    if([searchText length]>0)
//    {
//        id AppID = [[UIApplication sharedApplication]delegate];
//        
//        
//        NSDictionary *temp;// = [[NSDictionary alloc]init];
////        [self settingDisableViewOverlay:2];
//        
//        myTable.userInteractionEnabled = YES;	
//        searching = YES;
//        for(int i = 0 ; i < [chosungArray count] ; i++)
//        {
//            if([[chosungArrayobjectatindex:i] rangeOfString:searchText].location != NSNotFound // 초성 배열에 searchText가 있느냐
//               || [[[originListobjectatindex:i]objectForKey:@"name"] rangeOfString:searchText].location != NSNotFound // 이름에 searchText가 있느냐
//               || [[AppID getPureNumbers:[[originListobjectatindex:i]objectForKey:@"cellphone"]] rangeOfString:searchText].location != NSNotFound // 핸드폰/집/회사 번호에 searchText가 있느냐
//               || [[AppID getPureNumbers:[[originListobjectatindex:i]objectForKey:@"companyphone"]] rangeOfString:searchText].location != NSNotFound
//               || [[[originListobjectatindex:i]objectForKey:@"team"] rangeOfString:searchText].location != NSNotFound)
//            {	
//                
//                temp = [NSDictionary dictionaryWithDictionary:[originListobjectatindex:i]];
//                [copyList addObject:temp];
//                
//            }
//        }
//    }
//    
//    else 
//    {					
//        				NSLog(@"text not exist");
//        
//        [searchBar becomeFirstResponder];
////        [self settingDisableViewOverlay:1];				
//        myTable.userInteractionEnabled = NO;
//        searching = NO;
//        
//    }
//    
//    [myTable reloadData];		
//    
//}
//
//
//
//// 취소 버튼 누르면 키보드 내려가기
//- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 취소 버튼을 눌렀을 때 들어오는 함수. 취소버튼을 없애고, 키보드를 내리고, 불투명한 뷰를 뗀다.
//     param - searchBar(UISearchBar *) : 검색바
//     연관화면 : 검색
//     ****************************************************************/
//    
//    		NSLog(@"cancelbuttonclicked");
//    
//    
//    [searchBar setShowsCancelButton:NO animated:YES];
//    
//    searchBar.text = @"";
//    [searchBar resignFirstResponder]; // 키보드 내리기
//    
//    searching = NO;
//    myTable.userInteractionEnabled = YES;	
////    [self settingDisableViewOverlay:2];
//    [myTable reloadData];
//}
//
//
//// 키보드의 검색 버튼을 누르면
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 검색 버튼을 눌렀을 때. 키보드를 내리고, 취소 버튼은 그대로 두고, 테이블뷰를 사용할 수 있게 한다.
//     param - searchBar(UISearchBar *) : 검색바
//     연관화면 : 검색
//     ****************************************************************/
//    
//    
//    		NSLog(@"searchbuttonclicked");
//    
//    search.showsCancelButton = YES;
//    searching = YES;
//    
//    [searchBar resignFirstResponder];
//    
////    [self settingDisableViewOverlay:2];
//    myTable.userInteractionEnabled = YES;
//    
//      [self performSelector:@selector(enableCancelButton:) withObject:searchBar afterDelay:0.0];
//   
//}







- (void)checkSameLevel:(NSString *)code
{
    /*
     
     mycode = deptcode
     parentcode = parenddeptcode
     shortname = deptname
     newfield1 = sequence
     newfield = member
     */
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 받은 조직코드가 parentcode인 조직들과, 받은 조직코드가 deptcode인 사람들을 찾는다.
     param - code(NSString *) : 조직코드
     연관화면 : 조직도
     ****************************************************************/
    
    
	//			id AppID = [[UIApplication sharedApplication]delegate];
    
    NSLog(@"checkSameLevel %@",code);
    [myList removeAllObjects];
    NSLog(@"myList %d",[myList count]);
	
	NSMutableArray *tempArray = [[NSMutableArray alloc]init];
	[tempArray setArray:[ResourceLoader sharedInstance].deptList];
	
	for(NSDictionary *forDic in tempArray)//int i = 0; i < [tempArray count]; i++)
	{
		if([forDic[@"parentcode"] isEqualToString:code])
		{
			
			[myList addObject:forDic];
		}
	}
    
    NSLog(@"myList %d",[myList count]);
    
    
#if defined(BearTalk) || defined(LempMobileNowon) || defined(IVTalk)
	for(NSDictionary *forDic in tempArray)//int i = 0; i < [tempArray count]; i++)
	{
		if([forDic[@"mycode"] isEqualToString:code])
		{
            NSLog(@"forDic %@",forDic);
			//                    NSArray *array = [[forDicobjectForKey:@"shortname"] componentsSeparatedByString:@","];
			self.title = forDic[@"shortname"];//[arrayobjectatindex:[array count]-1];
            
		}
	}
#else
    
    self.title = @"주소록";
#endif

//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
//    [tempArray release];
	[subPeopleList removeAllObjects];
#ifdef Batong
    for(int i = 0; i < [[ResourceLoader sharedInstance].contactList count]; i++) {
        if([[ResourceLoader sharedInstance].contactList[i][@"deptcode"] isEqualToString:code])
        {
            [subPeopleList addObject:[ResourceLoader sharedInstance].contactList[i]];
        }
    }
    
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    
    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue]<70){
        for(int i = 0; i < [[ResourceLoader sharedInstance].myDeptList count]; i++) {
            if([[ResourceLoader sharedInstance].myDeptList[i][@"deptcode"] isEqualToString:code])
            {
                [subPeopleList addObject:[ResourceLoader sharedInstance].myDeptList[i]];
            }
        }
    }
    else
    {
        
        for(int i = 0; i < [[ResourceLoader sharedInstance].contactList count]; i++) {
            
        if([[ResourceLoader sharedInstance].contactList[i][@"deptcode"] isEqualToString:code])
        {
            [subPeopleList addObject:[ResourceLoader sharedInstance].contactList[i]];
        }
    }
        
    }
        
   
    
#else
	for(int i = 0; i < [[ResourceLoader sharedInstance].contactList count]; i++) {
		if([[ResourceLoader sharedInstance].contactList[i][@"deptcode"] isEqualToString:code])
		{
			[subPeopleList addObject:[ResourceLoader sharedInstance].contactList[i]];
		}
	}
    
#endif
    NSLog(@"subpeoplelist %d",[subPeopleList count]);
    
    [myTable reloadData];
	
    
}


- (void)setFirstButton
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직도 최상위에서의 상단의 버튼들을 세팅한다.
     연관화면 : 조직도
     ****************************************************************/
    
//    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = nil;//btnNavi;
//    [btnNavi release];
    
    
    
//    button = [CustomUIKit closeRightButtonWithTarget:self selector:@selector(cancel)];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    if(timelineMode)
//        self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];

    
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadFavController) frame:CGRectMake(0, 0, 35, 32) 
//                         imageNamedBullet:nil imageNamedNormal:@"n09_gtalkcanlbt.png" imageNamedPressed:nil];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//    
//    [button release];
    
#if defined(BearTalk) || defined(LempMobileNowon) || defined(IVTalk)
    
    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
#endif
}

- (void)setFirst:(NSString *)first
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직도 최상위 타이틀을 세팅한다.
     param - first(NSString *) : 조직도 선택했을 때 첫 타이틀
     연관화면 : 조직도
     ****************************************************************/
    
    firstDept = first;
    
#if defined(BearTalk) || defined(LempMobileNowon) || defined(IVTalk)
    self.title = first;
#else
    self.title = @"주소록";
#endif
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self];
		
		
}


- (void)reloadCheck
{
    NSLog(@"reloadCheck");
    NSLog(@"addArray %@",self.addArray);
    NSLog(@"selectcodelist %@",self.selectCodeList);
    NSLog(@"taginfo %d",tagInfo);
	
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직도에서 하위단계로 내려갈 때마다 path를 보여주기 위한 함수.
     연관화면 : 조직도
     ****************************************************************/
    
//    [groupNameView release];
//#else
		UIImageView *groupNameView = [[UIImageView alloc]initWithFrame:CGRectMake(0, search.frame.size.height, 320, 40)];
//		groupNameView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
    groupNameView.backgroundColor = RGB(240, 240, 240);
		[self.view addSubview:groupNameView];
		groupNameView.userInteractionEnabled = YES;
		
    
				CGSize size;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    NSLog(@"1");
#ifdef BearTalk
#else
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
#endif
    
    NSLog(@"2");
    
    
#if defined(BearTalk)
    groupNameView.frame = CGRectMake(0, CGRectGetMaxY(search.frame), self.view.frame.size.width, 11+26+11);
    groupNameView.backgroundColor = RGB(244, 248, 251);
#elif defined(IVTalk)
    size = [@"조직도" boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
//    size = [@"조직도" sizeWithFont: constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
#elif MQM
    
    size = [@"홈" boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
  //  size = [@"홈" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
#elif Batong
    
    size = [@"ECMD" boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
  //  size = [@"ECMD" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
#else
    size = [@"홈" boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
  //  size = [@"홈" sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
#endif
    
    NSLog(@"3");
    
    
    if (scrollView) {
        //			[scrollView release];
        scrollView = nil;
    }
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, groupNameView.frame.size.height)];
    scrollView.delegate = self;
    [groupNameView addSubview:scrollView];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, groupNameView.frame.size.height - 1, groupNameView.frame.size.width, 1)];
    //		groupNameView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
    lineView.backgroundColor = RGB(229, 233, 234);
    [groupNameView addSubview:lineView];
    
    NSLog(@"4");
    int w = 0;
    
    
    UILabel *addName;
    UIButton *addNameImage;
    UILabel *pathLabel;
    
    UIImageView *pathImage;
    
    
    addNameImage = [[UIButton alloc]initWithFrame:CGRectMake(3, 3, size.width + 15, groupNameView.frame.size.height-6)];
    addNameImage.tag = 100;
    [addNameImage addTarget:self action:@selector(warp:) forControlEvents:UIControlEventTouchUpInside];
    addNameImage.layer.cornerRadius = 3; // this value vary as per your desire
    addNameImage.clipsToBounds = YES;
    [scrollView addSubview:addNameImage];
//    [addNameImage release];

    
    
    [addNameImage setBackgroundColor:RGB(224, 224, 222)];
    //						addNameImage.image = [CustomUIKit customImageNamed:@"n01_adress_useradd_name_01.png"];
    
    
    NSLog(@"5");
#if defined(BearTalk)
    
#elif defined(IVTalk)
    addName = [CustomUIKit labelWithText:@"조직도" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
#elif MQM
    
    addName = [CustomUIKit labelWithText:@"홈" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
#elif Batong
    
    addName = [CustomUIKit labelWithText:@"ECMD" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
#else
    
    addName = [CustomUIKit labelWithText:@"홈" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
#endif
				[addNameImage addSubview:addName];
    

    
    NSLog(@"6");
    
    
    UILabel *firstPathLabel = [[UILabel alloc]init];
//                firstPathLabel.backgroundColor = [UIColor blueColor];
    firstPathLabel.font = [UIFont systemFontOfSize:13];
    firstPathLabel.textAlignment = NSTextAlignmentCenter;
    firstPathLabel.frame = CGRectMake(CGRectGetMaxX(addNameImage.frame) + 5, 0, 15, groupNameView.frame.size.height);
    [scrollView addSubview:firstPathLabel];
//    [firstPathLabel release];
    
#ifdef BearTalk
    addNameImage.frame = CGRectMake(0,0,0,0);
    w = 12;
    firstPathLabel.hidden = YES;
#else
        w = CGRectGetMaxX(addNameImage.frame)+25;
#endif
    
    NSLog(@"7");
		for(int i = 0; i < [self.addArray count]; i++)
        {
            NSLog(@"firstpathlabel %@",firstPathLabel);
            firstPathLabel.text = @"〉";
            
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
            size = [self.addArray[i] boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
			//	size = [self.addArray[i] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
		
            addNameImage = [[UIButton alloc]initWithFrame:CGRectMake(w, 3, size.width + 15, groupNameView.frame.size.height-6)];

            
            addNameImage.tag = i;
			[addNameImage addTarget:self action:@selector(warp:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:addNameImage];
            addNameImage.layer.cornerRadius = 2; // this value vary as per your desire
            addNameImage.clipsToBounds = YES;
//            [addNameImage release];
            scrollView.contentOffset = CGPointMake(w, groupNameView.frame.size.height);
			
#ifdef BearTalk
            
            paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
            size = [self.addArray[i] boundingRectWithSize:CGSizeMake(300, groupNameView.frame.size.height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
   //         size = [self.addArray[i] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(300, groupNameView.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
            addNameImage.frame = CGRectMake(w, 11, size.width + 20, groupNameView.frame.size.height - 22);
            pathImage = [[UIImageView alloc]init];
            pathImage.frame = CGRectMake(CGRectGetMaxX(addNameImage.frame) + 6, 11+8, 6, 11);
            pathImage.image = [CustomUIKit customImageNamed:@"ic_arrow_right.png"];
            [scrollView addSubview:pathImage];
            
#else
            
            
            pathLabel = [[UILabel alloc]init];
            //            pathLabel.backgroundColor = [UIColor blueColor];
            pathLabel.font = [UIFont systemFontOfSize:13];
            pathLabel.text = @"〉";
            pathLabel.textAlignment = NSTextAlignmentCenter;
            pathLabel.frame = CGRectMake(CGRectGetMaxX(addNameImage.frame) + 5, 0, 15, groupNameView.frame.size.height);
            [scrollView addSubview:pathLabel];
#endif
//            [pathLabel release];
            
            NSLog(@"pathLabel %@",pathLabel);
            
//				pathImage = [[UIImageView alloc]init];
//				pathImage.image = [CustomUIKit customImageNamed:@"arr_ic.png"];
				
				
				if(i == [self.addArray count]-1)
				{
#if defined(GreenTalk) || defined(GreenTalkCustomer)
                    
                    [addNameImage setBackgroundColor:GreenTalkColor];
#else
                    [addNameImage setBackgroundColor:RGB(39, 128, 248)];
//                stretchableImageWithLeftCapWidth:25 topCapHeight:30] forState:UIControlStateNormal];
#endif
//                    [addNameImage setBackgroundImage:[CustomUIKit customImageNamed:@"adduser_02.png"] forState:UIControlStateNormal];
                    
//						addNameImage.image = [CustomUIKit customImageNamed:@"n01_adress_useradd_name_02.png"];
						
						addName = [CustomUIKit labelWithText:self.addArray[i] fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1
																			 alignText:NSTextAlignmentCenter];
             
#ifdef BearTalk
                    pathImage.hidden = YES;
                    addNameImage.backgroundColor = RGB(66,185,235);
                    addName.textColor = RGB(255,255,255);
                    addName.font = [UIFont systemFontOfSize:12];
                    addName.frame = CGRectMake(10, 8, size.width, addNameImage.frame.size.height - 16);
                    
#else
                    
                           pathLabel.hidden = YES;
#endif
//						pathImage.hidden = YES;
				}
				else
                {
                    
                    [addNameImage setBackgroundColor:RGB(224, 224, 222)];
//                    [addNameImage setBackgroundImage:[CustomUIKit customImageNamed:@"adduser_01.png"] forState:UIControlStateNormal];
//						addNameImage.image = [CustomUIKit customImageNamed:@"n01_adress_useradd_name_01.png"];
						
						addName = [CustomUIKit labelWithText:self.addArray[i] fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(0, 0, addNameImage.frame.size.width, addNameImage.frame.size.height) numberOfLines:1
																			 alignText:NSTextAlignmentCenter];
//						pathImage.hidden = NO;
                 
#ifdef BearTalk
                    pathImage.hidden = NO;
                    addNameImage.backgroundColor = RGB(106,127,137);
                    addName.textColor = RGB(255,255,255);
                    addName.font = [UIFont systemFontOfSize:12];
                    addName.frame = CGRectMake(10, 8, size.width, addNameImage.frame.size.height - 16);
                    
#else
                    
                       pathLabel.hidden = NO;
#endif
                    
				}
//            NSLog(@"addname %@ pathlabel %@",NSStringFromCGRect(addNameImage.frame),NSStringFromCGRect(pathLabel.frame));
				
				
#ifdef BearTalk
            w = CGRectGetMaxX(addNameImage.frame)+18;
#else
             w = CGRectGetMaxX(addNameImage.frame)+25;
            
#endif
//				pathImage.frame = CGRectMake(16 + w + 27*i, 7, 10, 14);
//				[scrollView addSubview:pathImage];
				scrollView.contentSize = CGSizeMake(w - 20, groupNameView.frame.size.height);
            
#ifdef BearTalk
            scrollView.contentSize = CGSizeMake(w - 18+12, groupNameView.frame.size.height);
#endif
				[addNameImage addSubview:addName];
//				[addNameImage release];
            //				[pathImage release];
				
		}
//		[groupNameView release];
//#endif
}


- (void)warp:(id)sender
{
    NSLog(@"warp %d",[sender tag]);
#if defined(LempMobileNowon)
#else
    if([sender tag]==100)
    {
        [self backTo];
        return;
    }
#endif
//    UIButton *button = (UIButton *)sender;
    NSLog(@"warp tag %d %@ %@",(int)[sender tag],self.addArray[(int)[sender tag]],selectCodeList[(int)[sender tag]]);
    int temp;
    temp = (int)[self.addArray count]-((int)[sender tag]+1);
    for(int i = 0; i < temp; i++)
    {
        [self upTo];
    }
    [self reloadCheck];
    
}

- (void)backTo
{
    NSLog(@"backTo");
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 최상위의 네비게이션컨트롤러로.
     연관화면 : 없음
     ****************************************************************/
    
	[(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:NO];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
		
- (void)upTo
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직도 하위단계에서 좌측 상단 버튼을 눌러 상위로 올라올 때.
     연관화면 : 조직도
     ****************************************************************/
    
//    if(pView)
//    {
//        [pView closePopup];
//        pView = nil;
//        [pView release];
//    }
    
    NSLog(@"taginfo %d",tagInfo);

		if(tagInfo == 0)
		{
            NSLog(@"0");
//				[CustomUIKit popupAlertViewOK:nil msg:@"최상위 그룹입니다."];
								return;

		}
    else if(tagInfo == 1)
    {
        NSLog(@"1");
        [self setFirstButton];
        NSLog(@"2");
        [self setFirst:firstDept];
        NSLog(@"3");
    }
    NSLog(@"4");
    myTable.contentOffset = CGPointMake(0, 0);
		
		[self checkSameLevel:self.selectCodeList[[self.selectCodeList count]-1]];
    
    NSLog(@"5");
		
		
		
		
    tagInfo --;
    NSLog(@"6");
    [self.selectCodeList removeLastObject];
    NSLog(@"7");
    [self.addArray removeLastObject];
    NSLog(@"8");
    [self reloadCheck];
    NSLog(@"9");
}



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    search = [[UISearchBar alloc]init];
    search.frame = CGRectMake(0,0,320,0);
    
#ifdef BearTalk
    search.frame = CGRectMake(0,0,self.view.frame.size.width,9+30+9);
    

    
#elif LempMobileNowon
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(showSearchPopup) frame:CGRectMake(0, 0, 21, 21) imageNamedBullet:nil imageNamedNormal:@"button_searchview_search.png" imageNamedPressed:nil];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
#else
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadSearch) frame:CGRectMake(0, 0, 26, 26) imageNamedBullet:nil imageNamedNormal:@"barbutton_search.png" imageNamedPressed:nil];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
#endif
   
    
        search.tintColor = [UIColor grayColor];
        if ([search respondsToSelector:@selector(barTintColor)]) {
            search.barTintColor = RGB(242,242,242);
        }
#ifdef BearTalk
    //    search.tintColor = RGB(234, 237, 239); // tint is cursor color
    if ([search respondsToSelector:@selector(barTintColor)]) {
        
        search.barTintColor = RGB(238, 242, 245);
    }
    search.layer.borderWidth = 1;
    search.layer.borderColor = [RGB(234, 237, 239) CGColor];
    
    for(int i =0; i<[search.subviews count]; i++) {
        
        if([[search.subviews objectAtIndex:i] isKindOfClass:[UITextField class]])
            
            [(UITextField*)[search.subviews objectAtIndex:i] setFont:[UIFont systemFontOfSize:13]];
        
    }

#endif
    

        
	//    search.backgroundImage = [CustomUIKit customImageNamed:@"n04_secbg.png"];
    search.placeholder = @"이름(초성), 부서, 전화번호 검색"; // text 가 아닌 placeholder이다.
    [self.view addSubview:search];
    search.delegate = self;
    
    
    UIImageView *groupNameView = [[UIImageView alloc]initWithFrame:CGRectMake(0, search.frame.size.height, 320, 40)];
//    groupNameView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
    
#ifdef BearTalk
    
    groupNameView.frame = CGRectMake(0, CGRectGetMaxY(search.frame), self.view.frame.size.width, 11+26+11);
    groupNameView.backgroundColor = RGB(244, 248, 251);
#elif LempMobileNowon
    groupNameView.frame = CGRectMake(0, search.frame.size.height, 320, 40);
     groupNameView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
#else
     groupNameView.backgroundColor = RGB(240, 240, 240);
#endif
    [self.view addSubview:groupNameView];
//    [groupNameView release];
    
    NSLog(@"tabbar %f",self.tabBarController.tabBar.frame.size.height);
	myTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0, 28+search.frame.size.height, 320, self.view.frame.size.height-search.frame.size.height-groupNameView.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
	myTable.delegate = self;
	myTable.dataSource = self;

    float viewY = 64;
    
    
    myTable.frame = CGRectMake(0, search.frame.size.height + groupNameView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - search.frame.size.height - groupNameView.frame.size.height - viewY - 49);
    
	
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
	[self.view addSubview:myTable];
	
	[self setFirstButton];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
#ifdef BearTalk
    NSLog(@"myList %d",[myList count]);
    if(section == 1 && [subPeopleList count]>0 && [myList count]>0)
        return 20;
    else
        return 0;
#else
        return 0;

#endif
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView;
    headerView = [[UIView alloc]init];
    headerView.frame = CGRectMake(0, 0, myTable.frame.size.width, 20);
    headerView.backgroundColor = RGB(238, 242, 245);

    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef BearTalk
    if(indexPath.section == 0)
    {
        return 10+42+10;
    }
    else
        return 14+24+14;
#else
    return 50;
#endif
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    NSLog(@"OrganizeView willAppear %f",self.tabBarController.tabBar.frame.size.height);
    NSLog(@"addArray %@",self.addArray);
	NSLog(@"TAGINFO %d",tagInfo);
    
    
    
    
#if defined(BearTalk) || defined(LempMobileNowon) || defined(IVTalk)
#else
    self.navigationItem.hidesBackButton = YES;
//    self.hidesBottomBarWhenPushed = NO;
#endif
    [self reloadCheck];
//    [self setFirstButton];
//		[myTable reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"OrganizeView viewWillDisappear");
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"OrganizeView viewDidDisappear");
    [super viewDidDisappear:animated];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



//- (void)scrollViewWillBeginDragging:(UIScrollView *)s
//{
//    
//    
//    if([search isFirstResponder])
//    {
////        [self settingDisableViewOverlay:2];
//        [search resignFirstResponder];
//    }
//    				
//}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    NSLog(@"numberOfSectionsInTableView");
    
    return 2;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.


//    if(searching)
//    {
////        double temp = (double)[copyList count]/2;
//        return [copyList count];
//	}
//    else if(tableView == myTable)
//		{   	
//            int temp3 = [subPeopleList count] + [myList count];
    
#ifdef Batong
    
    NSLog(@"Batong numberofrow %d %d",[subPeopleList count],[myList count]);
    if(section == 0)
        return [myList count];
    else
       return [subPeopleList count];
#else
    NSLog(@"section %d numberofrow %d %d",section,[subPeopleList count],[myList count]);
    if(section == 0)
        return [subPeopleList count];
        else
       return      [myList count];
#endif
//		}
//    else {
//        return 0;
//    }
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

#if defined(BearTalk) || defined(LempMobile) || defined(LempMobileNowon) || defined(IVTalk)



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cellforrow");
    static NSString *CellIdentifier = @"Cell";
    //		NSString *email;
    UILabel *name, *info, *department, *team, *lblStatus, *membercount; //*position,
    UIImageView *profileView, *bgView, *fav, *infoBgView, *disableView, *holiday;
    UIButton *invite;
    UIImageView *roundingView;
    
    UIImageView *checkView, *checkAddView;
    //		id AppID = [[UIApplication sharedApplication]delegate];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //    NSLog(@"searching %@ copylist count %d",searching?@"YES":@"NO",[copyList count]);
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        profileView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
        profileView.frame = CGRectMake(5, 5, 40, 40);//5, 10, 40, 40);
        profileView.tag = 1;
        profileView.image = nil;
        [cell.contentView addSubview:profileView];
//        [profileView release];
        
        
        
        name = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
        name.backgroundColor = [UIColor clearColor];
        //            name.adjustsFontSizeToFitWidth = YES;
        name.tag = 2;
        [cell.contentView addSubview:name];
//        [name release];
        
        department = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
        department.backgroundColor = [UIColor clearColor];
        department.font = [UIFont systemFontOfSize:15];
        //            name.adjustsFontSizeToFitWidth = YES;
        department.tag = 7;
        [cell.contentView addSubview:department];
//        [department release];
        
        team = [[UILabel alloc]init];//WithFrame:CGRectMake(180, 14, 140, 20)];
        team.font = [UIFont systemFontOfSize:12];
        team.textColor = [UIColor grayColor];
        team.backgroundColor = [UIColor clearColor];
        team.tag = 3;
        [cell.contentView addSubview:team];
//        [team release];
        
        disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
        disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
        
        //        disableView.backgroundColor = RGBA(0,0,0,0.64);
        disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
        [profileView addSubview:disableView];
        disableView.tag = 11;
//        [disableView release];
        
        lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
        lblStatus.font = [UIFont systemFontOfSize:10];
        lblStatus.textColor = [UIColor whiteColor];
        lblStatus.textAlignment = NSTextAlignmentCenter;
        lblStatus.backgroundColor = [UIColor clearColor];
        lblStatus.tag = 9;
        [disableView addSubview:lblStatus];
//        [lblStatus release];
        
        invite = [[UIButton alloc]initWithFrame:CGRectMake(320-5-54, 11, 54, 27)];
#ifdef BearTalk
        invite.frame = CGRectMake(320-16-54, 62/2-27/2, 54, 27);
#endif
        [invite setBackgroundImage:[CustomUIKit customImageNamed:@"button_contact_invite.png"] forState:UIControlStateNormal];
        //            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 11, 56, 26)];
        //            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"push_installbtn.png"] forState:UIControlStateNormal];
        [invite addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
        invite.tag = 4;
        [cell.contentView addSubview:invite];
//        [invite release];
        
//        bgView = [[UIImageView alloc]init];//WithFrame:CGRectMake(6,6,43,43)];
//        bgView.tag = 5;
//        cell.backgroundView = bgView;
//        [bgView release];
        //            cell.backgroundColor = [UIColor blackColor];
        
        infoBgView = [[UIImageView alloc]initWithFrame:CGRectMake(320-5-103,profileView.frame.origin.y,103,40)];
        infoBgView.tag = 10;
        [cell.contentView addSubview:infoBgView];
//        [infoBgView release];
        
        info = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(12, 0, infoBgView.frame.size.width-15, infoBgView.frame.size.height) numberOfLines:2 alignText:NSTextAlignmentLeft];
        info.tag = 6;
        [infoBgView addSubview:info];
        
        membercount = [CustomUIKit labelWithText:nil fontSize:14 fontColor:RGB(66,185,235) frame:CGRectMake(cell.contentView.frame.size.width - 16-15-80, 14, 80, 24) numberOfLines:1 alignText:NSTextAlignmentRight];
    
        membercount.tag = 100;
        [cell.contentView addSubview:membercount];
        
        
#ifdef BearTalk
        roundingView = [[UIImageView alloc]init];
        [profileView addSubview:roundingView];
        
        //            [roundingView release];
        roundingView.tag = 21;
#endif
        
        
        //        [fav release];
#ifdef BearTalk
        
        
        checkView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profileView.frame)-20/2, CGRectGetMaxY(profileView.frame)-20/2, 20, 20)];
        checkView.tag = 5;
        checkView.layer.borderWidth = 1.0;
        checkView.layer.borderColor = [RGB(223, 223, 223)CGColor];
        checkView.layer.cornerRadius = checkView.frame.size.width/2;
        checkView.backgroundColor = RGB(249,249,249);
        [cell.contentView addSubview:checkView];
        
        checkAddView = [[UIImageView alloc]init];
        checkAddView.tag = 51;
        checkAddView.image = [CustomUIKit customImageNamed:@"btn_bookmark_on.png"];
        checkAddView.frame = CGRectMake(checkView.frame.size.width/2-26/2, checkView.frame.size.height/2-26/2-1, 26, 26);
        checkAddView.backgroundColor = [UIColor clearColor];
        [checkView addSubview:checkAddView];

        
#else
        
        fav = [[UIImageView alloc]initWithFrame:CGRectMake(profileView.frame.size.width-20, profileView.frame.size.height-20, 20, 20)];
        fav.tag = 8;
        fav.image = [CustomUIKit customImageNamed:@"imageview_profile_add_favorite.png"];
        [profileView addSubview:fav];
#endif
        //        [holiday release];
        
        holiday = [[UIImageView alloc]initWithFrame:CGRectMake(0, profileView.frame.size.width-20, 20, 20)];
        holiday.tag = 81;
        [profileView addSubview:holiday];
    }
    else{
        profileView = (UIImageView *)[cell viewWithTag:1];
        holiday = (UIImageView *)[cell viewWithTag:81];
        name = (UILabel *)[cell viewWithTag:2];
        //            position = (UILabel *)[cell viewWithTag:3];
        team = (UILabel *)[cell viewWithTag:3];
        invite = (UIButton *)[cell viewWithTag:4];
//        bgView = (UIImageView *)[cell viewWithTag:5];
        info = (UILabel *)[cell viewWithTag:6];
        department = (UILabel *)[cell viewWithTag:7];
        infoBgView = (UIImageView *)[cell viewWithTag:10];
        disableView = (UIImageView *)[cell viewWithTag:11];
        lblStatus = (UILabel *)[cell viewWithTag:9];
        membercount = (UILabel *)[cell viewWithTag:100];
#ifdef BearTalk
        roundingView = (UIImageView *)[cell viewWithTag:21];
        checkView = (UIImageView *)[cell viewWithTag:5];
        checkAddView = (UIImageView *)[cell viewWithTag:51];
#else
        fav = (UIImageView *)[cell viewWithTag:8];
        
#endif
    }
    //	profileView.image = nil;

    
    if(indexPath.section == 0 && [subPeopleList count]>0)
    {
        NSLog(@"cellforrow section 0");
        membercount.hidden = YES;
        NSDictionary *dic = subPeopleList[indexPath.row];
//        bgView.backgroundColor = [UIColor whiteColor];
        
        [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
        name.frame = CGRectMake(profileView.frame.origin.x+profileView.frame.size.width+5, profileView.frame.origin.y, 155, 20);
        
        name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
        //            team.text = [NSString stringWithFormat:@"%@ | %@",subPeopleList[indexPath.row][@"grade2"],subPeopleList[indexPath.row][@"team"]];
        
        
        
        if([dic[@"grade2"]length]>0)
        {
            if([dic[@"team"]length]>0){
                team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
#ifdef Batong
                team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"team"],dic[@"grade2"]];
#endif
            }
            else
                team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
        }
        else if([dic[@"team"]length]>0)
            team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
        else{
            team.text = @"";
        }
        
        
        team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
        
        
        
        [[invite layer] setValue:dic[@"cellphone"] forKey:@"cellphone"];
        invite.titleLabel.text = dic[@"uniqueid"];
        
        
        
#ifdef BearTalk
        profileView.frame = CGRectMake(16, 10, 42, 42);
        disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        
        roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
        
        checkView.frame = CGRectMake(CGRectGetMaxX(profileView.frame)-20, CGRectGetMaxY(profileView.frame)-20, 20, 20);
        checkAddView.frame = CGRectMake(checkView.frame.size.width/2-26/2, checkView.frame.size.height/2-26/2, 26, 26);
        invite.hidden = YES;
        name.frame = CGRectMake(16+42+10, 10, 120, 19);
        name.font = [UIFont systemFontOfSize:14];
        name.textColor = RGB(32, 32, 32);
        team.font = [UIFont systemFontOfSize:12];
        team.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), 120, 19);
        team.textColor = RGB(151,152,157);
        
        //        CGSize teamSize = [team.text boundingRectWithSize:CGSizeMake(120, 19)
        //                                           options:NSStringDrawingUsesLineFragmentOrigin
        //                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
        //                                           context:nil].size;
        //
        //        CGSize nameSize = [name.text boundingRectWithSize:CGSizeMake(120, 19)
        //                                                  options:NSStringDrawingUsesLineFragmentOrigin
        //                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
        //                                                  context:nil].size;
        
        
        
        
#endif
        
        
        if([dic[@"available"]isEqualToString:@"0"])
        {
            disableView.hidden = NO;
            lblStatus.text = @"미설치";
            //				if([[SharedAppDelegate.root getPureNumbers:subPeopleList[indexPath.row][@"cellphone"]]length]>9)
            invite.hidden = NO;//                lblStatus.text = @"미설치";
            infoBgView.hidden = YES;
            info.text = @"";
            
        }
        else if([dic[@"available"]isEqualToString:@"4"]){
            disableView.hidden = NO;
            lblStatus.text = @"로그아웃";
            invite.hidden = YES;
            infoBgView.hidden = NO;
            info.text = dic[@"newfield1"];
#ifdef BearTalk
            
            
            infoBgView.image = [[UIImage imageNamed:@"bg_chatbubble_gray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(18,16,6,17)];
            
            //[info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
            info.textColor = RGB(41,181,240);
            
            
            
            
            CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(100, 19 + 19 + 4 - 16)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}
                                                      context:nil].size;
            
            info.frame = CGRectMake(13, 0, infoSize.width, 19+19+4);
            
            infoBgView.frame = CGRectMake(self.view.frame.size.width - 16 - infoSize.width - 20,
                                          8,
                                          infoSize.width + 20,
                                          19+19+4);
            NSLog(@"infoSize.width %f",infoSize.width);
            NSLog(@"cell.contentView.frame.size.width %f",cell.contentView.frame.size.width);
            NSLog(@"infobg %@",NSStringFromCGRect(infoBgView.frame));
        
            
#else
            infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info_logout.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSParagraphStyleAttributeName:paragraphStyle};
            CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(103-15, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            
 //           CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
            info.frame = CGRectMake(10, 0, infoSize.width, 40);
            infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
            info.textColor = RGB(146, 146, 146);
#endif
            NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([newString length]<1){
                infoBgView.hidden = YES;
            }
        }
        else
        {
            disableView.hidden = YES;
            invite.hidden = YES;
            lblStatus.text = @"";
            infoBgView.hidden = NO;
            info.text = dic[@"newfield1"];
#ifdef BearTalk
            
            
            
            infoBgView.image = [[UIImage imageNamed:@"bg_chatbubble_gray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(18,16,6,17)];
            
            //[info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
            info.textColor = RGB(41,181,240);
            
            
            
            
            CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(100, 19 + 19 + 4 - 16)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}
                                                      context:nil].size;
            
            info.frame = CGRectMake(13, 0, infoSize.width, 19+19+4);
            
            infoBgView.frame = CGRectMake(self.view.frame.size.width - 16 - infoSize.width - 20,
                                          8,
                                          infoSize.width + 20,
                                          19+19+4);
            
            NSLog(@"infoSize.width %f",infoSize.width);
            NSLog(@"cell.contentView.frame.size.width %f",cell.contentView.frame.size.width);
            NSLog(@"infobg %@",NSStringFromCGRect(infoBgView.frame));
            
#else
            name.font = [UIFont systemFontOfSize:15];
            infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
             NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSParagraphStyleAttributeName:paragraphStyle};
            CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(103-15, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
       //     CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
            info.frame = CGRectMake(10, 0, infoSize.width, 40);
            infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
            info.textColor = RGB(80, 80, 80);
#endif
            NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([newString length]<1){
                infoBgView.hidden = YES;
            }
        }
        
#ifdef BearTalk
        if([dic[@"favorite"]isEqualToString:@"0"]){
            
            checkView.hidden = YES;
            checkAddView.hidden = YES;
        }
        else{
            checkView.hidden = NO;
            checkAddView.hidden = NO;
        }
#else
        if([dic[@"favorite"]isEqualToString:@"0"])
            fav.hidden = YES;
        else
            fav.hidden = NO;
#endif
        
        
        NSString *leave_type = dic[@"newfield5"];
        if([leave_type length]>0){
            if([leave_type isEqualToString:@"출산"])
                holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_popup_baby.png"];
            else if([leave_type isEqualToString:@"육아"])
                holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_popup_feed.png"];
            else if([leave_type isEqualToString:@"개인질병"])
                holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_popup_disease.png"];
            else
                holiday.image = [CustomUIKit customImageNamed:@"imageview_profile_popup_etc.png"];
        }
        else{
            
            
            holiday.image = nil;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if(indexPath.section == 1 && [myList count]>0)
    {
        membercount.hidden = NO;
        NSDictionary *dic = myList[indexPath.row];
        NSLog(@"cellforrow section 1");
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        holiday.image = nil;
        disableView.hidden = YES;
        
        name.font = [UIFont systemFontOfSize:17];
        name.frame = CGRectMake(13, 14, 250, 20);
//        int subRow = (int)indexPath.row - (int)[subPeopleList count];
        //            profileView.image = nil;
        //            profileView.frame = CGRectMake(10, 12, 34, 23);
        //            profileView.image = [CustomUIKit customImageNamed:@"grp_icon.png"];
        profileView.image = nil;
        department.text = @"";
        team.text = @"";
        invite.hidden = YES;
        lblStatus.text = @"";
        
        info.text = @"";
        infoBgView.hidden = YES;
        
        //            cell.backgroundColor = [UIColor blackColor];//RGB(219,215,212);
//        bgView.backgroundColor = RGB(219,215,212);//[CustomUIKit customImageNamed:@"gp_background.png"];
        //            NSArray *array = [[Ofkd dusfkr[myList[subRow][@"shortname"] componentsSeparatedByString:@","];
        //            name.frame = CGRectMake(10, 14, 200, 20);
        //            name.font = [UIFont systemFontOfSize:18];
        
        
#ifdef BearTalk
        checkView.hidden = YES;
        checkAddView.hidden = YES;
//        checkAddView.image = nil;
        roundingView.image = nil;
        name.font = [UIFont systemFontOfSize:16];
        name.frame = CGRectMake(16, 16, 250, 20);
        name.text = [NSString stringWithFormat:@"%@",dic[@"shortname"]];//[arrayobjectatindex:[array count]-1];
        membercount.text = dic[@"newfield"];
        name.textColor = RGB(51,61,71);
#else
        fav.hidden = YES;
        name.text = [NSString stringWithFormat:@"%@",dic[@"shortname"]];//[arrayobjectatindex:[array count]-1];
        membercount.text = @"";
#endif
    }
    
    
    return cell;
}
#else
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"cellforrow");
    static NSString *CellIdentifier = @"Cell";
//		NSString *email;
    UILabel *name, *info, *department, *team, *lblStatus; //*position,
    UIImageView *profileView, *bgView, *fav, *infoBgView, *disableView;
    UIButton *invite;
    UIImageView *roundingView;
//		id AppID = [[UIApplication sharedApplication]delegate];
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    NSLog(@"searching %@ copylist count %d",searching?@"YES":@"NO",[copyList count]);
		
		if(cell == nil)
		{
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
            profileView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            profileView.frame = CGRectMake(5, 5, 40, 40);//5, 10, 40, 40);
            profileView.tag = 1;
            profileView.image = nil;
            [cell.contentView addSubview:profileView];
//            [profileView release];
            
            
            fav = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height)];
            fav.tag = 8;
            fav.image = [CustomUIKit customImageNamed:@"favorites_bg.png"];
            [profileView addSubview:fav];
//            [fav release];
            
            name = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
            name.backgroundColor = [UIColor clearColor];
//            name.adjustsFontSizeToFitWidth = YES;
            name.tag = 2;
            [cell.contentView addSubview:name];
//            [name release];
            
            department = [[UILabel alloc]init];//WithFrame:CGRectMake(55, 5, 120, 20)];
            department.backgroundColor = [UIColor clearColor];
            department.font = [UIFont systemFontOfSize:15];
            //            name.adjustsFontSizeToFitWidth = YES;
            department.tag = 7;
            [cell.contentView addSubview:department];
//            [department release];
            
            team = [[UILabel alloc]init];//WithFrame:CGRectMake(180, 14, 140, 20)];
            team.font = [UIFont systemFontOfSize:12];
            team.textColor = [UIColor grayColor];
            team.backgroundColor = [UIColor clearColor];
            team.tag = 3;
            [cell.contentView addSubview:team];
//            [team release];
            
            disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
            disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
            
            //        disableView.backgroundColor = RGBA(0,0,0,0.64);
            disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
            [profileView addSubview:disableView];
            disableView.tag = 11;
//            [disableView release];

            lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height)];
            lblStatus.font = [UIFont systemFontOfSize:10];
            lblStatus.textColor = [UIColor whiteColor];
            lblStatus.textAlignment = NSTextAlignmentCenter;
            lblStatus.backgroundColor = [UIColor clearColor];
            lblStatus.tag = 9;
            [disableView addSubview:lblStatus];
//            [lblStatus release];
            
            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-5-54, 11, 54, 27)];
            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"button_contact_invite.png"] forState:UIControlStateNormal];
//            invite = [[UIButton alloc]initWithFrame:CGRectMake(320-65, 11, 56, 26)];
//            [invite setBackgroundImage:[CustomUIKit customImageNamed:@"push_installbtn.png"] forState:UIControlStateNormal];
            [invite addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
            invite.tag = 4;
            [cell.contentView addSubview:invite];
//            [invite release];
            
            bgView = [[UIImageView alloc]init];//WithFrame:CGRectMake(6,6,43,43)];
            bgView.tag = 5;
            cell.backgroundView = bgView;
//            [bgView release];
//            cell.backgroundColor = [UIColor blackColor];
            
            infoBgView = [[UIImageView alloc]initWithFrame:CGRectMake(320-5-103,profileView.frame.origin.y,103,40)];
            infoBgView.tag = 10;
            [cell.contentView addSubview:infoBgView];
//            [infoBgView release];
            
            info = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(12, 0, infoBgView.frame.size.width-15, infoBgView.frame.size.height) numberOfLines:2 alignText:NSTextAlignmentLeft];
            info.tag = 6;
            [infoBgView addSubview:info];
//            [info release];
            
            
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
            [profileView addSubview:roundingView];
//            [roundingView release];
            roundingView.tag = 21;
            
            
        }
        else{
            profileView = (UIImageView *)[cell viewWithTag:1];
            fav = (UIImageView *)[cell viewWithTag:8];
            name = (UILabel *)[cell viewWithTag:2];
//            position = (UILabel *)[cell viewWithTag:3];
            team = (UILabel *)[cell viewWithTag:3];
            invite = (UIButton *)[cell viewWithTag:4];
            bgView = (UIImageView *)[cell viewWithTag:5];
            info = (UILabel *)[cell viewWithTag:6];
            department = (UILabel *)[cell viewWithTag:7];
            infoBgView = (UIImageView *)[cell viewWithTag:10];
            disableView = (UIImageView *)[cell viewWithTag:11];
            lblStatus = (UILabel *)[cell viewWithTag:9];
            roundingView = (UIImageView *)[cell viewWithTag:21];
        }
//	profileView.image = nil;
    
    roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
    
#ifdef Batong
    
    if(indexPath.section == 0)
    {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        disableView.hidden = YES;
        name.font = [UIFont systemFontOfSize:17];
        name.frame = CGRectMake(13, 14, 250, 20);
        profileView.image = nil;
        //            profileView.frame = CGRectMake(10, 12, 34, 23);
        //            profileView.image = [CustomUIKit customImageNamed:@"grp_icon.png"];
        
        //			[SharedAppDelegate.root getProfileImageWithURL:nil ifNil:@"department_ic.png" view:profileView scale:0];
        department.text = @"";
        team.text = @"";
        invite.hidden = YES;
        lblStatus.text = @"";
        fav.hidden = YES;
        info.text = @"";
        infoBgView.hidden = YES;
        bgView.backgroundColor = [UIColor whiteColor];//RGB(219,215,212);
        
        name.text = [NSString stringWithFormat:@"%@",myList[indexPath.row][@"shortname"]];//[arrayobjectatindex:[array count]-1];
    }
    else
    {
        name.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryNone;
//        int subRow = (int)indexPath.row - (int)[myList count];
        
        NSDictionary *dic = subPeopleList[indexPath.row];
        bgView.backgroundColor = [UIColor whiteColor];
        
        [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
        name.frame = CGRectMake(profileView.frame.origin.x+profileView.frame.size.width+5, profileView.frame.origin.y, 155, 20);
        
        name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
        //            team.text = [NSString stringWithFormat:@"%@ | %@",subPeopleList[indexPath.row][@"grade2"],subPeopleList[indexPath.row][@"team"]];
        
        
        
        
        if([dic[@"grade2"]length]>0)
        {
            if([dic[@"team"]length]>0){
                team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
#ifdef Batong
                team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"team"],dic[@"grade2"]];
#endif
            }
            else
                team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
        }
        else if([dic[@"team"]length]>0)
            team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
        else{
            team.text = @"";
        }
        
        
        
        team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
        
        
        
        [[invite layer] setValue:dic[@"cellphone"] forKey:@"cellphone"];
        invite.titleLabel.text = dic[@"uniqueid"];
        
        if([dic[@"available"]isEqualToString:@"0"])
        {
            disableView.hidden = NO;
            lblStatus.text = @"미설치";
            //				if([[SharedAppDelegate.root getPureNumbers:subPeopleList[indexPath.row][@"cellphone"]]length]>9)
            invite.hidden = NO;//                lblStatus.text = @"미설치";
            infoBgView.hidden = YES;
            info.text = @"";
            
        }
        else if([dic[@"available"]isEqualToString:@"4"]){
            disableView.hidden = NO;
            lblStatus.text = @"로그아웃";
            invite.hidden = YES;
            infoBgView.hidden = NO;
            infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info_logout.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            info.text = dic[@"newfield1"];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
             NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSParagraphStyleAttributeName:paragraphStyle};
            CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(103-15, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            
        //    CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
            info.frame = CGRectMake(10, 0, infoSize.width, 40);
            infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
            info.textColor = RGB(146, 146, 146);
            NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([newString length]<1){
                infoBgView.hidden = YES;
            }
        }
        else
        {
            disableView.hidden = YES;
            invite.hidden = YES;
            lblStatus.text = @"";
            infoBgView.hidden = NO;
            infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
            info.text = dic[@"newfield1"];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
             NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSParagraphStyleAttributeName:paragraphStyle};
            CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(103-15, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
       //     CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
            info.frame = CGRectMake(10, 0, infoSize.width, 40);
            infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
            info.textColor = RGB(80, 80, 80);
            NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([newString length]<1){
                infoBgView.hidden = YES;
            }
        }
        
        if([dic[@"favorite"]isEqualToString:@"0"])
            fav.hidden = YES;
        else
            fav.hidden = NO;
        
        
        
    }
    
    //    }
    
#else

        if(indexPath.section == 0)
        {
            name.font = [UIFont systemFontOfSize:15];
            NSDictionary *dic = subPeopleList[indexPath.row];
            bgView.backgroundColor = [UIColor whiteColor];
            
            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
            name.frame = CGRectMake(profileView.frame.origin.x+profileView.frame.size.width+5, profileView.frame.origin.y, 155, 20);
            
            name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
//            team.text = [NSString stringWithFormat:@"%@ | %@",subPeopleList[indexPath.row][@"grade2"],subPeopleList[indexPath.row][@"team"]];
 
            
            
            if([dic[@"grade2"]length]>0)
            {
                if([dic[@"team"]length]>0){
                    team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
#ifdef Batong
                    team.text = [NSString stringWithFormat:@"%@ | %@",dic[@"team"],dic[@"grade2"]];
#endif
                }
                else
                    team.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
            }
            else if([dic[@"team"]length]>0)
                team.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
            else{
                team.text = @"";
            }
            
            

            team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
            
            
       
            [[invite layer] setValue:dic[@"cellphone"] forKey:@"cellphone"];
            invite.titleLabel.text = dic[@"uniqueid"];
            
            if([dic[@"available"]isEqualToString:@"0"])
            {
                disableView.hidden = NO;
				lblStatus.text = @"미설치";
//				if([[SharedAppDelegate.root getPureNumbers:subPeopleList[indexPath.row][@"cellphone"]]length]>9)
					invite.hidden = NO;//                lblStatus.text = @"미설치";
                infoBgView.hidden = YES;
                info.text = @"";
                
			            }
            else if([dic[@"available"]isEqualToString:@"4"]){
                disableView.hidden = NO;
                lblStatus.text = @"로그아웃";
                invite.hidden = YES;
                infoBgView.hidden = NO;
                infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info_logout.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
                info.text = dic[@"newfield1"];
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                 NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSParagraphStyleAttributeName:paragraphStyle};
                CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(103-15, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                
         //       CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
                info.frame = CGRectMake(10, 0, infoSize.width, 40);
                infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
                info.textColor = RGB(146, 146, 146);
                NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                if([newString length]<1){
                    infoBgView.hidden = YES;
                }
            }
            else
            {
                disableView.hidden = YES;
                invite.hidden = YES;
				lblStatus.text = @"";
                infoBgView.hidden = NO;
                infoBgView.image = [[UIImage imageNamed:@"imageview_contact_info.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:20];
                info.text = dic[@"newfield1"];
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10], NSParagraphStyleAttributeName:paragraphStyle};
                CGSize infoSize = [info.text boundingRectWithSize:CGSizeMake(103-15, 40) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                
             //   CGSize infoSize = [info.text sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
                info.frame = CGRectMake(10, 0, infoSize.width, 40);
                infoBgView.frame = CGRectMake(320-5-info.frame.size.width-15,5,info.frame.size.width+15,40);
                              info.textColor = RGB(80, 80, 80);
                NSString *newString = [info.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                if([newString length]<1){
                    infoBgView.hidden = YES;
                }
			}
			
            if([dic[@"favorite"]isEqualToString:@"0"])
                fav.hidden = YES;
            else
                fav.hidden = NO;
        }
        else
        {
            name.font = [UIFont systemFontOfSize:17];
            disableView.hidden = YES;
            name.frame = CGRectMake(13, 14, 250, 20);
//            int subRow = (int)indexPath.row - (int)[subPeopleList count];
            profileView.image = nil;
//            profileView.frame = CGRectMake(10, 12, 34, 23);
//            profileView.image = [CustomUIKit customImageNamed:@"grp_icon.png"];
            
//			[SharedAppDelegate.root getProfileImageWithURL:nil ifNil:@"department_ic.png" view:profileView scale:0];
            department.text = @"";
            team.text = @"";
            invite.hidden = YES;
            lblStatus.text = @"";
            fav.hidden = YES;
            info.text = @"";
        infoBgView.hidden = YES;
//            cell.backgroundColor = [UIColor blackColor];//RGB(219,215,212);
            bgView.backgroundColor = [UIColor whiteColor];//RGB(219,215,212);//[CustomUIKit customImageNamed:@"gp_background.png"];
//            NSArray *array = [[[myList[subRow][@"shortname"] componentsSeparatedByString:@","];
//            name.frame = CGRectMake(10, 14, 200, 20);
//            name.font = [UIFont systemFontOfSize:18];
            name.text = [NSString stringWithFormat:@"%@",myList[indexPath.row][@"shortname"]];//[arrayobjectatindex:[array count]-1];
            
        }
#endif
    
     return cell;
}
#endif

//- (void)saveImage:(NSDictionary *)dic
//{
//    
//               NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[dicobjectForKey:@"path"]]; 
//    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dicobjectForKey:@"urlString"]]];
//   
//    [imgData writeToFile:filePath atomically:YES];
//    
//    [imageThread cancel];
//    
////    if(imageThread)
////        SAFE_RELEASE(imageThread);
//}
- (void)invite:(id)sender{
    
    NSLog(@"invite %@",sender);
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
     [SharedAppDelegate.root invite:sender];
#else
    if([[SharedAppDelegate.root getPureNumbers:[[sender layer]valueForKey:@"cellphone"]] length]>9){
        [SharedAppDelegate.root invite:sender];
        
    }
    else{
        
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"멤버의 휴대폰 정보가 없어 설치요청\nSMS를 발송할 수 없습니다." con:self];
        return;
        
    }
#endif
}
- (void)selectList:(int)rowOfButton
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직을 선택할 때마다 새로 세팅을 해 준다.
     param - sender(id) : tag를 이용해 몇 번째 조직인지 넘긴다.
     연관화면 : 조직도
     ****************************************************************/
    
		
//		int rowOfButton = [sender tag];
    myTable.contentOffset = CGPointMake(0, 0);
    
//    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(upTo)];
//
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = nil;//btnNavi;
//    [btnNavi release];
    
    
    
//    button = [CustomUIKit closeRightButtonWithTarget:self selector:@selector(cancel)];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    if(timelineMode)
//        self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];

    
//    [button release];
    
//    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadFavController) frame:CGRectMake(0, 0, 35, 32) 
//                         imageNamedBullet:nil imageNamedNormal:@"n09_gtalkcanlbt.png" imageNamedPressed:nil];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//    
//    [button release];
    
		
//		NSArray *array = [[[myListobjectatindex:rowOfButton]objectForKey:@"shortname"] componentsSeparatedByString:@","];
   
    if([myList count]<1)
        return;
    
    NSLog(@"myList %d",[myList count]);
#if defined(BearTalk) || defined(LempMobileNowon) || defined(IVTalk)
    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(upTo)];
    
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    self.title = myList[rowOfButton][@"shortname"];//[arrayobjectatindex:[array count]-1];
#else
    self.title = @"주소록";
    
#endif
    NSLog(@"myList %d",[myList count]);
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
    if(myList[rowOfButton][@"shortname"] != nil)
		[self.addArray addObject:myList[rowOfButton][@"shortname"]];
		[self reloadCheck];
    
		
	[subList removeAllObjects];
				
		
		NSMutableArray *tempArray = [[NSMutableArray alloc]init];
		[tempArray setArray:[ResourceLoader sharedInstance].deptList];
		
		
		for(NSDictionary *forDic in tempArray)//int i = 0; i < [tempArray count]; i++)
		{
				if([forDic[@"parentcode"] isEqualToString:myList[rowOfButton][@"mycode"]])
				{
						[subList addObject:forDic];
				}
		}
		 [self.selectCodeList addObject:myList[rowOfButton][@"parentcode"]];
		
#ifdef Batong
    
    [tempArray setArray:[ResourceLoader sharedInstance].contactList];
    
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    
    
    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue]<70){
    [tempArray setArray:[ResourceLoader sharedInstance].myDeptList];
    }
    else{
        [tempArray setArray:[ResourceLoader sharedInstance].contactList];
        
    }
#else
    [tempArray setArray:[ResourceLoader sharedInstance].contactList];
#endif
		
//    NSLog(@"tempArray %@",tempArray);
//    NSLog(@"mycode %@",myList[rowOfButton][@"mycode"]);
		
	[subPeopleList removeAllObjects];
	

		for(NSDictionary *forDic in tempArray)//int i = 0; i < [tempArray count]; i++)
		{
            
				if([forDic[@"deptcode"] isEqualToString:myList[rowOfButton][@"mycode"]])
				{
						[subPeopleList addObject:forDic];
				}
		}

//    [tempArray release];
//    for(int i = 0; i < [subPeopleList count]; i++){
//        
//        NSLog(@"uid %@ uid %@",[[subPeopleListobjectatindex:i]objectForKey:@"uniqueid"],[ResourceLoader sharedInstance].myUID);
//        
//        if([[[subPeopleListobjectatindex:i]objectForKey:@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
//            [subPeopleList removeObjectAtIndex:i];
//        }
//    }
    NSLog(@"subPeopleList count %d",(int)[subPeopleList count]);
    
    //    NSLog(@"subList %@",subList);
    NSLog(@"myList %d",[myList count]);
    [myList removeAllObjects];
    NSLog(@"myList %d",[myList count]);
    [myList setArray:subList];
    NSLog(@"myList %d",[myList count]);
    
    
		tagInfo++;
		
		[myTable reloadData];

}

- (void)loadFavController
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 우측상단에 즐겨찾기 버튼을 누르면 즐겨찾기 뷰컨트롤러를 호출.
     연관화면 : 즐겨찾기
     ****************************************************************/
    
//    FavoriteViewController *favController = [[FavoriteViewController alloc]init];
//    
//    [self.navigationController pushViewController:favController animated:YES]; // 현재는 임시로 푸쉬.
//    [favController release];
}


- (void)refreshSearchFavorite:(NSString *)uid fav:(NSString *)fav{
    
        for(int i = 0; i < [subPeopleList count]; i++){
            if([subPeopleList[i][@"uniqueid"]isEqualToString:uid]){
                [subPeopleList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:subPeopleList[i] object:fav key:@"favorite"]];
            }
        }
    
    [myTable reloadData];
}


- (void)selectContact:(int)rowOfButton
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 조직이 아닌 사람을 선택했을 때 프로필을 띄워준다.
     param - sender(id) : tag를 이용해 몇 번째 사람인지 넘긴다.
     연관화면 : 조직도
     ****************************************************************/
    
    
    NSLog(@"OrganizeViewController selectContact %d sub count %d",rowOfButton,(int)[subPeopleList count]);
    
    
//    [self settingDisableViewOverlay:3];
    
//    if([[[subPeopleListobjectatindex:rowOfButton]objectForKey:@"available"]isEqualToString:@"0"])
//        return;
    
    [SharedAppDelegate.root settingYours:subPeopleList[rowOfButton][@"uniqueid"] view:self.view];
//    [self dismissModalViewControllerAnimated:YES];
//    [SharedAppDelegate.root showSlidingViewAnimated:YES];
//    int rowOfButton = [sender tag];
    
    
//     pView = [[ProfileView alloc]initWithTag:100 other:1];
//    
//    if(searching)
//    {
//        [pView updateWithDic:[copyListobjectatindex:rowOfButton]];
//        [search resignFirstResponder];
//        
//    }
//    else{
//		[pView updateWithDic:[subPeopleListobjectatindex:rowOfButton]];
//		
//    }
//    [self.view addSubview:pView.view];
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

#ifdef Batong
    if(indexPath.section == 0)
    {
        [self selectList:(int)indexPath.row];
    }
    else{
//        int subRow = (int)indexPath.row - (int)[myList count];
        [self selectContact:indexPath.row];
    }
#else
    if(indexPath.section == 0)
    {
        [self selectContact:(int)indexPath.row];
    }
    else{
//        int subRow = (int)indexPath.row - (int)[subPeopleList count];
        [self selectList:(int)indexPath.row];
    }
#endif
}




#pragma mark -
#pragma mark Memory management



- (void)didReceiveMemoryWarning {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
}


- (void)dealloc {
//	if (scrollView) {
//		[scrollView release];
//	}
//	[myList release];
//	[search release];
//	[myTable release];
//	[subList release];
//	[subPeopleList release];
//    [selectCodeList release];
//    [addArray release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [super dealloc];
//    
}


@end

