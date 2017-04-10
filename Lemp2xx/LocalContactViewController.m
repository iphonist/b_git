//
//  ContactViewController.m
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "LocalContactViewController.h"
#import "ChatViewC.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
//#import "FavoriteViewController.h"

@implementation LocalContactViewController
//@synthesize target;
//@synthesize selector;
//@synthesize myList;
//@synthesize myTable;
//@synthesize disableViewOverlay;
//searchTableData;
//@synthesize willCheck;

#pragma mark -
#pragma mark Handle the custom alert



#define kSearch 1
#define kAll 2
#define kRequest 14
#define kSendContact 10

@synthesize mTarget;
@synthesize mSelector;



- (id)initWithTag:(int)t
{
    self = [super init];
    if (self != nil)
    {
        self.view.tag = t;
        
        
        
        UIButton *button;
        UIBarButtonItem *btnNavi;
        
        
        
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(closeView)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
 //       [btnNavi release];
        
        search = [[UISearchBar alloc]initWithFrame:CGRectMake(320*0, 0, 320, 0)];
        
        if(self.view.tag == kSearch){
            self.title = @"휴대폰 주소록 검색";
            searching = NO;
            
        }
        else{
            self.title = NSLocalizedString(@"contacts", @"contacts");
            
            if(self.view.tag == kRequest){
                self.title = NSLocalizedString(@"invite_customer", @"invite_customer");
                
               button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(inviteDone) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"barbutton_done.png" imageNamedPressed:nil];
                UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                self.navigationItem.rightBarButtonItem = btnNavi;
//                [btnNavi release];
                
                search.frame = CGRectMake(320*0, 0, 320, 44);
                search.delegate = self;
                searching = NO;
//                if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
//                    search.tintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//                    if ([search respondsToSelector:@selector(barTintColor)]) {
//                        search.barTintColor = [UIColor colorWithWhite:0.8 alpha:1.0];
//                    }
//                }
                [self.view addSubview:search];
                
                if(checkNumberArray){
                    //            [checkNumberArray release];
                    checkNumberArray = nil;
                }
                
                checkNumberArray = [[NSMutableArray alloc]init];
        
                
                
            }
            else if(self.view.tag == kSendContact){
                self.title = @"연락처";
                
                search.frame = CGRectMake(self.view.frame.size.width*0, 0, self.view.frame.size.width, 48);
                search.delegate = self;
                searching = NO;
                
                search.tintColor = [UIColor grayColor];
                
                if ([search respondsToSelector:@selector(barTintColor)]) {
                    
                    search.barTintColor = RGB(238, 242, 245);
                }
                search.layer.borderWidth = 1;
                search.layer.borderColor = [RGB(234, 237, 239) CGColor];
                
                for(int i =0; i<[search.subviews count]; i++) {
                    
                    if([[search.subviews objectAtIndex:i] isKindOfClass:[UITextField class]])
                        
                        [(UITextField*)[search.subviews objectAtIndex:i] setFont:[UIFont systemFontOfSize:13]];
                    
                }

                
                [self.view addSubview:search];
                
            }
            
        }
        
        
        
        
        float viewY = 64;
        
        CGRect tableFrame;
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            tableFrame = CGRectMake(0, search.frame.size.height + 0, 320, self.view.frame.size.height - viewY - search.frame.size.height); // 네비(44px) + 상태바(20px)
//        } else {
//            tableFrame = CGRectMake(0, search.frame.size.height, 320, self.view.frame.size.height - 44 - search.frame.size.height); // 네비(44px)
//        }
        myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
        myTable.dataSource = self;
        myTable.delegate = self;
        myTable.rowHeight = 50;
        [self.view addSubview:myTable];
//        [myTable release];
        //    myTable.scrollsToTop = YES;
        
        if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [myTable setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [myTable setLayoutMargins:UIEdgeInsetsZero];
        }
        
        myList = [[NSMutableArray alloc]init];
        // Request authorization to Address Book
        
        copyList = [[NSMutableArray alloc]init];
        
        if(self.view.tag == kRequest){
            countButton = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 44 - viewY, 320, 44)];
            countButton.backgroundColor = GreenTalkColor;
            [self.view addSubview:countButton];
              [countButton addTarget:self action:@selector(inviteDone) forControlEvents:UIControlEventTouchUpInside];
            
            countLabel = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(5, 5, 320 - 10, 44 - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
            [countButton addSubview:countLabel];
            
            countButton.hidden = YES;
            
        }
    }
    return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [search resignFirstResponder];
}






- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar // 서치바 터치하는 순간 들어옴.
{
    [searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:UIButton.class]){
            [(UIButton*)subView setTitle:NSLocalizedString(@"cancel", @"cancel") forState:UIControlStateNormal];
        }
    }
    
    NSLog(@"searchBarTextDidBeginEditing %f",self.view.frame.size.height);
    //    [SharedAppDelegate.root coverDisableView:self.view x:0 y:44 w:320 h:self.view.frame.size.height];
    [self.view addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)]];
    
    NSString *name = @"";//[[NSString alloc]init];
    if(chosungArray)
    {
//        [chosungArray release];
        chosungArray = nil;
    }
    chosungArray = [[NSMutableArray alloc]init];
    for(NSDictionary *forDic in myList)//int i = 0 ; i < [originList count] ; i ++)
    {
        name = forDic[@"name"];//[forDicobjectForKey:@"name"];
        NSString *str = [self getUTF8String:name];//[AppID GetUTF8String:name];
        [chosungArray addObject:str];
    }
    
    
}

- (NSString *)getUTF8String:(NSString *)hanggulString{
    
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 받은 스트링에서 초성을 빼내어 돌려준다.
     param - hanggulString(NSString *) : 한글로 된 스트링
     연관화면 : 검색
     ****************************************************************/
    
    
    NSArray *chosung = [[NSArray alloc] initWithObjects:@"ㄱ",@"ㄲ",@"ㄴ",@"ㄷ",@"ㄸ",@"ㄹ",@"ㅁ",@"ㅂ",@"ㅃ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅉ",@"ㅊ",@"ㅋ",@"ㅌ",@"ㅍ",@"ㅎ",nil];
    NSString *textResult = @"";
    for (int i=0;i<[hanggulString length];i++) {
        NSInteger code = [hanggulString characterAtIndex:i];
        if (code >= 44032 && code <= 55203) {
            NSInteger uniCode = code - 44032;
            NSInteger chosungIndex = uniCode / 21 / 28;
            textResult = [NSString stringWithFormat:@"%@%@", textResult, chosung[chosungIndex]];//[chosungobjectatindex:chosungIndex]];
        }
    }
    return textResult;
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText // 터치바에 글자 쓰기
{
    [copyList removeAllObjects];
    
    
    
    if([searchText length]>0)
    {
        NSDictionary *searchDic;
        [SharedAppDelegate.root removeDisableView];
        
        myTable.userInteractionEnabled = YES;
        searching = YES;
        for(int i = 0 ; i < [chosungArray count] ; i++)
        {
            if([chosungArray[i] rangeOfString:searchText].location != NSNotFound // 초성 배열에 searchText가 있느냐
               || [[myList[i][@"name"]lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound)
            {
                
                searchDic = myList[i];
                
                
                [copyList addObject:searchDic];
                
            }
        }
    }
    
    else
    {
        NSLog(@"text not exist %f",self.view.frame.size.height);
        
        [searchBar becomeFirstResponder];
        //        [SharedAppDelegate.root coverDisableView:self.view x:0 y:44 w:320 h:self.view.frame.size.height];
        [self.view addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)]];
        myTable.userInteractionEnabled = NO;
        searching = NO;
        
    }
    
    [myTable reloadData];
    //		[copyList removeAllObjects];
    //
    //
    //		if([searchText length]>0)
    //		{
    //
    //            id AppID = [[UIApplication sharedApplication]delegate];
    //
    //            NSDictionary *temp;// = [[NSDictionary alloc]init];
    //				[self settingDisableViewOverlay:2];
    //				self.myTable.userInteractionEnabled = YES;
    //				searching = YES;
    //				for(int i = 0 ; i < [chosungArray count] ; i++)
    //				{
    //                    if([[chosungArrayobjectatindex:i] rangeOfString:searchText].location != NSNotFound // 초성 배열에 searchText가 있느냐
    //                       || [[[myListobjectatindex:i]objectForKey:@"name"] rangeOfString:searchText].location != NSNotFound // 이름에 searchText가 있느냐
    //                       || [[AppID getPureNumbers:[[myListobjectatindex:i]objectForKey:@"cellphone"]] rangeOfString:searchText].location != NSNotFound // 핸드폰/집/회사 번호에 searchText가 있느냐
    //                       || [[AppID getPureNumbers:[[myListobjectatindex:i]objectForKey:@"companyphone"]] rangeOfString:searchText].location != NSNotFound
    //                       || [[[myListobjectatindex:i]objectForKey:@"team"] rangeOfString:searchText].location != NSNotFound)
    //						{
    //								temp = [NSDictionary dictionaryWithDictionary:[myListobjectatindex:i]];
    //								[copyList addObject:temp];
    //
    //						}
    //				}
    //
    //		}
    //
    //		else
    //		{
    //
    //				[searchBar becomeFirstResponder];
    //				[self settingDisableViewOverlay:1];
    //				searching = NO;
    //				self.myTable.userInteractionEnabled = NO;
    //
    //		}
    //
    //		[myTable reloadData];
    
}





// 취소 버튼 누르면 키보드 내려가기
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    
    [searchBar setShowsCancelButton:NO animated:YES];
    //
    //		searchBar.text = @"";
    [search resignFirstResponder];
    [myTable setUserInteractionEnabled:YES];
    [SharedAppDelegate.root removeDisableView];
    
}


// 키보드의 검색 버튼을 누르면
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [search resignFirstResponder];
    
}




// 섹션에 몇 개의 셀이 있는지.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if([myList count]==0)
        return 1;
    else{
    if(searching)
    {
        return [copyList count];
    }
    else
    {
        return [myList count];
		
    }
    }
}


// 몇 개의 섹션이 있는지. // 얘가 먼저 호출됨.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sec = 0;
    
    if(searching)
        sec = 1;
    
    else
    {
        sec = 1;
    }
    return sec;
}



// 해당 뷰가 생성될 때 한 번만 호출
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
  
	
}

- (NSArray *)getAllocAddressBook{
   
     NSLog(@"getAllocAddressBook");
    NSMutableArray *contactList = [[ResourceLoader sharedInstance] allContactList];
    NSMutableArray *phoneNumberList = [[NSMutableArray alloc]init];
    NSArray *returnList = [[NSMutableArray alloc]init];

    ABAddressBookRef addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        NSLog(@"Access to contacts %@ by user", granted ? @"granted" : @"denied");
    });
    
    // Get all contacts in the addressbook
	NSArray *allPeople = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    ABMultiValueRef phoneNumbers;
	for (id person in allPeople) {
        // Get all phone numbers of a contact
        phoneNumbers = ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonPhoneProperty);
  
        // If the contact has multiple phone numbers, iterate on each of them
        
        for (int i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
          
            NSString *phoneNumber; //(__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            phoneNumber = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, i);
            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
     //       phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"82" withString:@"0"];
            phoneNumber = [SharedAppDelegate.root getPureNumbers:phoneNumber];
            NSString *firstName = (__bridge_transfer NSString *)(ABRecordCopyValue((__bridge ABRecordRef)person, kABPersonFirstNameProperty));
            NSString *lastName = (__bridge_transfer NSString *)(ABRecordCopyValue((__bridge ABRecordRef)person, kABPersonLastNameProperty));
            NSString *name = [[lastName length]>0?lastName:@"" stringByAppendingFormat:@"%@",[firstName length]>0?firstName:@""];
            if([phoneNumber length]>0 && [name length]>0)
            [phoneNumberList addObject:[NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"number",name,@"name",@"0",@"check",@"0",@"compare",nil]];
        }
    }
    
    if(self.view.tag == kSearch){
    for(NSDictionary *dic in contactList){
        NSString *compareNumber = [SharedAppDelegate.root getPureNumbers:dic[@"cellphone"]];
    for(NSDictionary *adic in phoneNumberList){
        if([adic[@"number"] isEqualToString:compareNumber])
               [(NSMutableArray *)returnList addObject:dic];
        }
    }
    }
    else if(self.view.tag == kRequest){
        NSLog(@"Request");
     
        for(NSDictionary *dic in contactList){
            NSString *compareNumber = [SharedAppDelegate.root getPureNumbers:dic[@"cellphone"]];
            for(int i = 0; i < [phoneNumberList count]; i++){
                NSDictionary *adic = phoneNumberList[i];
                NSString *originNumber = adic[@"number"];
                
                if([originNumber isEqualToString:compareNumber])
                {
                    
                    NSDictionary *newDic = [SharedFunctions fromOldToNew:adic object:@"1" key:@"compare"];
                    NSLog(@"newDic %@",newDic);
                    [phoneNumberList replaceObjectAtIndex:i withObject:newDic];
                }
                  
            }
        }
        
        [(NSMutableArray *)returnList setArray:phoneNumberList];
      
    }
    else{
        NSSortDescriptor *sortName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCompare:)];
        [phoneNumberList sortUsingDescriptors:[NSArray arrayWithObjects:sortName,nil]];
        [(NSMutableArray *)returnList setArray:phoneNumberList];
    }
    
    returnList = [[NSSet setWithArray: returnList] allObjects];
    return returnList;
}


- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{
    
    self.mTarget = aTarget;
    self.mSelector = aSelector;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
      return nil;
    
}

- (void)closeView
{
	if (self.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		[(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
	}
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 검색하고나서 뷰를 드래깅하면, 불투명한 뷰를 제거하고 키보드를 내려준다.
     param - scrollView(UIScrollView *) : 스크롤뷰
     연관화면 : 검색
     ****************************************************************/
    
    //    dragging = YES;
    
    if([search isFirstResponder])
    {
        //            [self settingDisableViewOverlay:2];
        [search resignFirstResponder];
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //    dragging = NO;
    [myTable reloadData];
}      // called when scroll view grinds to a halt





#define kNotFavorite 1
#define kFavorite 2


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([myList count]==0)
        return;
    else{
        if(self.view.tag == kAll){
            
        }
        else if(self.view.tag == kSendContact){
            NSLog(@"mTarget %@",mTarget);
            NSLog(@"myListDic %@",myList[indexPath.row]);
            if (mTarget && mSelector) {
                if(searching){
                [mTarget performSelector:mSelector withObject:copyList[indexPath.row]];
                }
                else{
                    [mTarget performSelector:mSelector withObject:myList[indexPath.row]];
                    
                }
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else if(self.view.tag == kRequest){
            
            if(searching){
                NSDictionary *dic = copyList[indexPath.row];
               [self reloadCheckList:dic];
            }
            else{
                NSDictionary *dic = myList[indexPath.row];
                [self reloadCheckList:dic];
            }
        }
        else{
    if(searching){
        
        [self addOrClear:copyList[indexPath.row]];
    }
    else{
                [self addOrClear:myList[indexPath.row]];
                   }
        }
    }
    
}


- (void)addOrClear:(NSDictionary *)d
{
    if(progressing)
        return;
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    progressing = YES;
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:d];
    
    NSLog(@"dic %@",dic);
    
    
    NSString *type = @"";
    
    //            }
    if([dic[@"favorite"]isEqualToString:@"0"]){
        //        [SharedAppDelegate.root updateFavorite:@"1" uniqueid:[dicobjectForKey:@"uniqueid"]];
        [self reloadList:dic[@"uniqueid"] fav:@"1"];
        type = @"1";
        
    }
    else{
        //        [SharedAppDelegate.root updateFavorite:@"0" uniqueid:[dicobjectForKey:@"uniqueid"]];
        [self reloadList:dic[@"uniqueid"] fav:@"0"];
        type = @"2";
        
#ifdef BearTalk
        type = @"0";
#endif
        

        
    }
    
    
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    
    NSString *urlString;
    NSString *method;
#ifdef BearTalk
    urlString = [NSString stringWithFormat:@"%@/api/emps/favorite/",BearTalkBaseUrl];
    method = @"PUT";
#else
    urlString = [NSString stringWithFormat:@"https://%@/lemp/info/setfavorite.lemp",[SharedAppDelegate readPlist:@"was"]];
    method = @"POST";
    
#endif

    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters;
#ifdef BearTalk
    
    parameters = @{
                   @"act" : type,
                   @"uid" : [ResourceLoader sharedInstance].myUID,
                   @"favuid" : dic[@"uniqueid"],
                   };
#else
    
    parameters = @{
                                 @"type" : type,
                                 @"uid" : [ResourceLoader sharedInstance].myUID,
                                 @"member" : dic[@"uniqueid"],
                                 @"category" : @"1",
                                 @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey
                                 };
#endif
    NSLog(@"parameter %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setfavorite.lemp" parameters:parameters];
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:method URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        progressing = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        
#ifdef BearTalk
        
        if([dic[@"favorite"]isEqualToString:@"0"]){
            [SQLiteDBManager updateFavorite:@"1" uniqueid:dic[@"uniqueid"]];
            
        }
        else {//if([[dicobjectForKey:@"favorite"]isEqualToString:@"1"]){
            [SQLiteDBManager updateFavorite:@"0" uniqueid:dic[@"uniqueid"]];
            
        }
        
#else

        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if([dic[@"favorite"]isEqualToString:@"0"]){
                [SQLiteDBManager updateFavorite:@"1" uniqueid:dic[@"uniqueid"]];
                
            }
            else {//if([[dicobjectForKey:@"favorite"]isEqualToString:@"1"]){
                [SQLiteDBManager updateFavorite:@"0" uniqueid:dic[@"uniqueid"]];
                
            }
            
        }
        else {
            
            
            //            [SharedAppDelegate.root updateFavorite:[dicobjectForKey:@"favorite"] uniqueid:[dicobjectForKey:@"uniqueid"]];
            [self reloadList:dic[@"uniqueid"] fav:dic[@"favorite"]];
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
#endif
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        progressing = NO;
        
        //        [SharedAppDelegate.root updateFavorite:[dicobjectForKey:@"favorite"] uniqueid:[dicobjectForKey:@"uniqueid"]];
        [self reloadList:dic[@"uniqueid"] fav:dic[@"favorite"]];
        
        NSLog(@"FAIL : %@",operation.error);
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"즐겨찾기 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
		[HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
//    [dic release];
    
}

- (void)reloadList:(NSString *)uid fav:(NSString *)fav{
    
    
    
    for(int j = 0; j<[copyList count];j++)
    {
        if([uid isEqualToString:copyList[j][@"uniqueid"]])
        {
            NSLog(@"searching %@",fav);
            [copyList replaceObjectAtIndex:j withObject:[SharedFunctions fromOldToNew:copyList[j] object:fav key:@"favorite"]];
        }
    }
    
    
    
    for(int j = 0; j<[myList count];j++)
    {
        if([uid isEqualToString:myList[j][@"uniqueid"]])
        {
            NSLog(@"myList %@",fav);
            [myList replaceObjectAtIndex:j withObject:[SharedFunctions fromOldToNew:myList[j] object:fav key:@"favorite"]];
        }
    }
    
    [myTable reloadData];
}

- (void)reloadCheckList:(NSDictionary *)dic{
    
    NSLog(@"reloadCheckList %@",dic);
    
    NSString *checkedNumber = [NSString stringWithFormat:@"%@",dic[@"number"]];
    NSLog(@"checkedNumber %@",checkedNumber);
    
    NSLog(@"check %@",dic[@"check"]);
    NSString *check = [NSString stringWithFormat:@"%@",[dic[@"check"]isEqualToString:@"0"]?@"1":@"0"];
    NSLog(@"check %@",check);
    
    BOOL exist = NO;
    NSLog(@"copyList %@",copyList);
    for(int j = 0; j<[copyList count];j++)
    {
        if([checkedNumber isEqualToString:copyList[j][@"number"]])
        {
            exist = YES;
            [copyList replaceObjectAtIndex:j withObject:[SharedFunctions fromOldToNew:copyList[j] object:check key:@"check"]];
       
        }
    }
    NSLog(@"exist1 %@",exist?@"YES":@"NO");
    
    
    NSLog(@"myList %@",myList);
    for(int j = 0; j<[myList count];j++)
    {
        if([checkedNumber isEqualToString:myList[j][@"number"]])
        {
            exist = YES;
            [myList replaceObjectAtIndex:j withObject:[SharedFunctions fromOldToNew:myList[j] object:check key:@"check"]];
    
        }
    }
    NSLog(@"exist2 %@",exist?@"YES":@"NO");
    
    if(exist){
    if([check isEqualToString:@"1"]){
        [checkNumberArray addObject:checkedNumber];
    }
    else{
        [checkNumberArray removeObject:checkedNumber];
    }
    }
    
    
        NSLog(@"checkNumberArray %@",checkNumberArray);
    if([checkNumberArray count] == 0){
        countButton.hidden = YES;
        [countLabel setText:@""];
    }
    else{
        countButton.hidden = NO;
        [countLabel setText:[NSString stringWithFormat:@"%d명 초대",(int)[checkNumberArray count]]];
    }
    [myTable reloadData];
}




// 뷰가 나타날 때마다 호출
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    fetching = NO;
    [SVProgressHUD showWithStatus:@"주소록 불러오는중"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0){
        [self fetchListOver9];
    }
    else{
    [self fetchList];
    }
}

- (void)fetchListOver9{
    NSLog(@"fetchListOver9")
    ;
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if( status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted)
    {
        NSLog(@"access denied");
    }
    else
    {
        //Create repository objects contacts
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        
        //Select the contact you want to import the key attribute  ( https://developer.apple.com/library/watchos/documentation/Contacts/Reference/CNContact_Class/index.html#//apple_ref/doc/constant_group/Metadata_Keys )
        
        NSArray *keys = [[NSArray alloc]initWithObjects:CNContactIdentifierKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactViewController.descriptorForRequiredKeys, nil];
        
        // Create a request object
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
        request.predicate = nil;
        [myList removeAllObjects];
        [contactStore enumerateContactsWithFetchRequest:request
                                                  error:nil
                                             usingBlock:^(CNContact* __nonnull contact, BOOL* __nonnull stop)
         {
             // Contact one each function block is executed whenever you get
             NSString *phoneNumber = @"";
             if( contact.phoneNumbers)
                 phoneNumber = [[[contact.phoneNumbers firstObject] value] stringValue];
             
             NSLog(@"phoneNumber = %@", phoneNumber);
             NSLog(@"givenName = %@", contact.givenName);
             NSLog(@"familyName = %@", contact.familyName);
             NSLog(@"email = %@", contact.emailAddresses);
             
             
             phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
      //       phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"82" withString:@"0"];
             phoneNumber = [SharedAppDelegate.root getPureNumbers:phoneNumber];
             
             NSLog(@"phoneNumber = %@", phoneNumber);
             
             NSString *name = [[contact.familyName length]>0?contact.familyName:@"" stringByAppendingFormat:@"%@",[contact.givenName length]>0?contact.givenName:@""];
             
             if([phoneNumber length]>0 && [name length]>0)
             [myList addObject:[NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"number",name,@"name",@"0",@"check",@"0",@"compare",nil]];
             
//             [myList addObject:contact];
         }];
        
        
        fetching = YES;
        [myTable reloadData];
        [SVProgressHUD showSuccessWithStatus:@"완료"];
    }
}
- (void)fetchList{
    progressing = NO;
    
    NSLog(@"fetchList");
    
//    
//    [myList setArray:[[ResourceLoader sharedInstance] allContactList]];
//    
//    for(int i = 0; i < [myList count]; i++){
//        if([myList[i][@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID])
//            [myList removeObjectAtIndex:i];
//    }
//    
//    
//    
//    
//    [myTable reloadData];
//
    
    [SVProgressHUD showWithStatus:@"주소록 불러오는중"];
    
    NSLog(@"fetchList 1");
    __block BOOL userDidGrantAddressBookAccess;
    CFErrorRef addressBookError = NULL;
    ABAddressBookRef addressBookRef =  ABAddressBookCreateWithOptions(NULL, NULL);
    NSLog(@"fetchList 2");
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        NSLog(@"Access to contacts %@ by user", granted ? @"granted" : @"denied");
    });
    
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted) {
//        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
//            if (granted) {
//                // First time access has been granted, add the contact
//                NSLog(@"granted");
//                [self fetchList];
//            } else {
                // 처음 접근 팝업 거절 했을 때
                NSLog(@"NOTgranted");
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"연락처에 접근할 수 없습니다.\n설정>개인정보 보호>연락처에서 스위치를 켜 주세요." con:self];
                // User denied access
                // Display an alert telling user the contact could not be added
//            }
//        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized ||
             ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        // The user has previously given access, add the contact
        
        
        addressBookRef = ABAddressBookCreateWithOptions(NULL, &addressBookError);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            userDidGrantAddressBookAccess = granted;
            dispatch_semaphore_signal(sema);
            
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        NSLog(@"userDidGrantAddressBookAccess %@",userDidGrantAddressBookAccess?@"Y":@"N");
        
        NSLog(@"authorized");
        [myList setArray:[self getAllocAddressBook]];
    }
    else {
        // 이미 접근 거절 후 또다시 접근 하려고 할 때
        NSLog(@"denied");
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"연락처에 접근할 수 없습니다.\n설정>개인정보 보호>연락처에서 스위치를 켜 주세요." con:self];
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    
    
    //    [myList setArray:[[ResourceLoader sharedInstance] allContactList]];
    //
    //    for(int i = 0; i < [myList count]; i++){
    //        if([myList[i][@"uniqueid"] isEqualToString:[ResourceLoader sharedInstance].myUID])
    //            [myList removeObjectAtIndex:i];
    //    }
    
    
    
    fetching = YES;
    [myTable reloadData];
    [SVProgressHUD showSuccessWithStatus:@"완료"];

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

// 셀 정의 함수.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    
    UILabel *name, *team, *lblStatus;
    UIButton *callButton;
    UIImageView *profileView, *disableView, *roundingView;
    UIImageView *checkView;
    UIImageView *compareView;
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
        profileView = [[UIImageView alloc]init];//WithFrame:CGRectMake(40,0,50,50)];
        profileView.tag = 1;
        [cell.contentView addSubview:profileView];
//        [profileView release];
        
        name = [[UILabel alloc]init];//WithFrame:CGRectMake(40+55, 5, 320-100, 20)];
        name.backgroundColor = [UIColor clearColor];
        name.font = [UIFont systemFontOfSize:15];
        //        name.adjustsFontSizeToFitWidth = YES;
        name.tag = 2;
        [cell.contentView addSubview:name];
//        [name release];
        
        
        team = [[UILabel alloc]init];//WithFrame:CGRectMake(name.frame.origin.x, 27, 140, 20)];
        team.font = [UIFont systemFontOfSize:12];
        team.textColor = [UIColor grayColor];
        team.backgroundColor = [UIColor clearColor];
        team.tag = 3;
        [cell.contentView addSubview:team];
//        [team release];
        
        disableView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 7, 35, 35)];
        
        //        disableView.backgroundColor = RGBA(0,0,0,0.64);
        disableView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
        [profileView addSubview:disableView];
        disableView.tag = 11;
//        [disableView release];
        
        lblStatus = [[UILabel alloc]init];//WithFrame:CGRectMake(0, 15, disableView.frame.size.width, 20)];
        lblStatus.font = [UIFont systemFontOfSize:10];
        lblStatus.textColor = [UIColor whiteColor];
        lblStatus.textAlignment = NSTextAlignmentCenter;
        lblStatus.backgroundColor = [UIColor clearColor];
        lblStatus.tag = 6;
        [disableView addSubview:lblStatus];
//        [lblStatus release];
        
        checkView = [[UIImageView alloc]init];//WithFrame:
        checkView.tag = 5;
        [cell.contentView addSubview:checkView];
//        [checkView release];
        
        compareView = [[UIImageView alloc]init];//WithFrame:
        compareView.tag = 7;
        [cell.contentView addSubview:compareView];
//        [compareView release];
        
        callButton = [[UIButton alloc]initWithFrame:CGRectMake(320-70, 10, 57, 25)];
        [callButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_profilepopup_call.png"] forState:UIControlStateNormal];
        [callButton addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        callButton.tag = 4;
        [cell.contentView addSubview:callButton];
//        [callButton release];
        
        roundingView = [[UIImageView alloc]init];
        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        [profileView addSubview:roundingView];
        roundingView.tag = 10;
//        [roundingView release];

        
    }
    else{
        profileView = (UIImageView *)[cell viewWithTag:1];
        roundingView = (UIImageView *)[cell viewWithTag:10];
        name = (UILabel *)[cell viewWithTag:2];
        //            position = (UILabel *)[cell viewWithTag:3];
        team = (UILabel *)[cell viewWithTag:3];
        disableView = (UIImageView *)[cell viewWithTag:11];
        lblStatus = (UILabel *)[cell viewWithTag:6];
        checkView = (UIImageView *)[cell viewWithTag:5];
        compareView = (UIImageView *)[cell viewWithTag:7];
        callButton = (UIButton *)[cell viewWithTag:4];
    }

    
    roundingView.hidden = NO;

    
	profileView.image = nil;
    
//    NSLog(@"mylist count %d",[myList count]);
    if([myList count]==0){
        
        profileView.image = nil;
        callButton.hidden = YES;
        name.textAlignment = NSTextAlignmentCenter;
        name.frame = CGRectMake(15, 9, 290, 34);
        name.font = [UIFont systemFontOfSize:13];
        team.text = @"";
//        invite.hidden = YES;
        lblStatus.text = @"";
        checkView.image = nil;
        compareView.image = nil;
        disableView.hidden = YES;
        if(fetching){
            
            if(self.view.tag == kSearch){
            name.text = @"휴대폰 주소록과 일치하는 멤버가 없습니다.";
              
          
        }
        else{
            name.text = @"휴대폰에 주소록을 불러올 수 없습니다.";
        }
        
        }
        else{
            name.text = @"";
        }
    }
    else{
        NSDictionary *dic = nil;
    if(searching)
    {
        dic = copyList[indexPath.row];
        
           }
    else
    {
        
            if([myList count]>0){
                dic = myList[indexPath.row];
            
                                       
                                       
                                       }
        
        
        
    }
//        NSLog(@"dic %@",dic);
        
        
        if(dic != nil){
            
            if(self.view.tag == kSearch){
                
                
                callButton.hidden = YES;
                callButton.titleLabel.text = @"";
                profileView.frame = CGRectMake(40,5,40,40);
                roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
                name.frame = CGRectMake(40+55, 5, 320-100, 20);
                disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
                lblStatus.frame = CGRectMake(0, 0, disableView.frame.size.width, disableView.frame.size.height);
                checkView.frame = CGRectMake(0, 0, 40, 50);
                compareView.frame = CGRectMake(0, 0, 0, 0);
                compareView.image = nil;
            
            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
            name.frame = CGRectMake(40+55, 5, 320-100, 20);
            name.textAlignment = NSTextAlignmentLeft;
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
        
        
        if([dic[@"available"]isEqualToString:@"0"])
        {
            disableView.hidden = NO;
            lblStatus.text = NSLocalizedString(@"not_installed", @"not_installed");
            
        }
        else if([dic[@"available"]isEqualToString:@"4"]){
            lblStatus.text = NSLocalizedString(@"logout", @"logout");
            disableView.hidden = NO;
            //            invite.hidden = YES;
        }
        else
        {
            disableView.hidden = YES;
            //            invite.hidden = YES;
			lblStatus.text = @"";
        } //            lblStatus.text = @"";
        
        if([dic[@"favorite"]isEqualToString:@"1"]){
            [MBProgressHUD hideHUDForView:checkView animated:YES];
            checkView.image = [CustomUIKit customImageNamed:@"favorite_prs.png"];
        }
        else{
            [MBProgressHUD hideHUDForView:checkView animated:YES];
            checkView.image = [CustomUIKit customImageNamed:@"favorite_dtt.png"];
        }
    }
            else if(self.view.tag == kRequest){
                
                callButton.hidden = YES;
                callButton.titleLabel.text = @"";
                profileView.frame = CGRectMake(0,0,0,0);
                roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
                disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
                name.frame = CGRectMake(10, 5, 320-100, 20);
                lblStatus.frame = CGRectMake(0, 0, 0, 0);
                checkView.frame = CGRectMake(320-35, 10, 23, 23);
                compareView.frame = CGRectMake(320-35-35, 12, 23, 23);
                
                if([dic[@"compare"]isEqualToString:@"1"]){
                    compareView.image = [CustomUIKit customImageNamed:@"imageview_mini_icon.png"];
                }
                else{
                    compareView.image = nil;
                }
                
                if([dic[@"check"]isEqualToString:@"1"]){
                    checkView.image = [CustomUIKit customImageNamed:@"button_check.png"];
                }
                else{
                    
                    checkView.image = [CustomUIKit customImageNamed:@"button_nocheck.png"];
                }
                profileView.image = nil;
                
                name.textAlignment = NSTextAlignmentLeft;
                name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
                        team.text = [NSString stringWithFormat:@"%@",dic[@"number"]];
                team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
                
                
                    disableView.hidden = YES;
                    lblStatus.text = @"";
                
              
            }  else if(self.view.tag == kSendContact){
                
                callButton.hidden = YES;
                callButton.titleLabel.text = @"";
                profileView.frame = CGRectMake(0,0,0,0);
                roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
                disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
                name.frame = CGRectMake(16, 5, self.view.frame.size.width-100, 20);
                lblStatus.frame = CGRectMake(0, 0, 0, 0);
                checkView.frame = CGRectMake(320-90, 10, 0, 0);
                checkView.image = nil;
                profileView.image = nil;
                compareView.frame = CGRectMake(0, 0, 0, 0);
                compareView.image = nil;
                
                name.textAlignment = NSTextAlignmentLeft;
                name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
                team.text = [NSString stringWithFormat:@"%@",dic[@"number"]];
                team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
                
                
                disableView.hidden = YES;
                lblStatus.text = @"";
                
                
            }
            else{
                
                callButton.hidden = NO;
                callButton.titleLabel.text = dic[@"number"];
                profileView.frame = CGRectMake(0,0,0,0);
                roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
                disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
                name.frame = CGRectMake(10, 5, 320-100, 20);
                lblStatus.frame = CGRectMake(0, 0, 0, 0);
                checkView.frame = CGRectMake(320-90, 10, 80, 35);
                checkView.image = nil;
                profileView.image = nil;
                compareView.frame = CGRectMake(0, 0, 0, 0);
                compareView.image = nil;
                
                name.textAlignment = NSTextAlignmentLeft;
                name.text = [NSString stringWithFormat:@"%@",dic[@"name"]];
                team.text = [NSString stringWithFormat:@"%@",dic[@"number"]];
                team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, name.frame.size.height);
                
                
                disableView.hidden = YES;
                lblStatus.text = @"";
                
                
            }
        }
    }
    
    return cell;
    
}




- (void)inviteDone
{
    
    
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/pulmuone_invite.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    NSLog(@"baseUrl %@",baseUrl);
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"client %@",client);

    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSLog(@"check %@",checkNumberArray);
    NSLog(@"SharedAppDelegate.root.home.groupnum %@",SharedAppDelegate.root.home.groupnum);
    NSDictionary *param = @{    @"cellphone" : checkNumberArray,
                                 @"uid" : [ResourceLoader sharedInstance].myUID,
                                 @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                                 @"groupnumber" : SharedAppDelegate.root.home.groupnum};
    NSLog(@"parameter %@",param);
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/pulmuone_invite.lemp" parametersJson:param key:@"param"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        progressing = NO;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"operation.responseString %@",operation.responseString);
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            [self closeView];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"성공적으로 초대 메시지를 발송하였습니다." con:self];
//            OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"성공적으로 초대 메시지를 발송하였습니다."];
//            
//            toast.position = OLGhostAlertViewPositionCenter;
//            
//            toast.style = OLGhostAlertViewStyleDark;
//            toast.timeout = 2.0;
//            toast.dismissible = YES;
//            [toast show];
//            [toast release];
            
            
        }
        else {
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        progressing = NO;
        
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
    
    
}

#define kNumber 3
- (void)call:(id)sender{
    
    UIView *view = [SharedAppDelegate.root.callManager setFullOutgoing:[[sender titleLabel]text] usingUid:kNumber];
    [SharedAppDelegate.window addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //		[myTable release];
}


//- (void)dealloc {
//    
//    
//    [myList release];
//    [copyList release];
//    [super dealloc];
//}

@end
