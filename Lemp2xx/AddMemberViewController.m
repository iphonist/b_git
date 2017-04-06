//
//  ContactViewController.m
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "AddMemberViewController.h"
#import "ChatViewC.h"
//#import "FavoriteViewController.h"
#import "AddFavoriteViewController.h"
#import "SelectDeptViewController.h"


@implementation AddMemberViewController
@synthesize target;
@synthesize selector;
@synthesize myList;
@synthesize myTable;
@synthesize multiSelect;
//@synthesize disableViewOverlay;
//searchTableData;
//@synthesize willCheck;

#pragma mark -
#pragma mark Handle the custom alert


#define kChat 1
#define kModifyChat 2
#define kNewGroup 3
#define kModifyGroup 4
#define kAddGroup 5
#define kElse 1
#define kCall 7
#define kNote 100
#define kFavorite 200

#define kAllSelect 0
#define kDeptSelect 1


#define kFirstFilter 10
#define kSecondFilter 20

- (id)initWithTag:(int)t array:(NSMutableArray *)array add:(NSMutableArray *)wait
{
    self = [super init];
    if (self != nil)
    {
        
        NSLog(@"array %@  wait %@ ",array,wait);
        self.title = @"대상추가";
        self.multiSelect = YES;
        
        addArray = [[NSMutableArray alloc]init];//WithArray:array];
//        NSLog(@"addArray %@",addArray);
        //            [addArray addObjectsFromArray:wait];
        //            [self reloadCheck];
        alreadyArray = [[NSMutableArray alloc]init];//WithArray:array];
        if(t == kAddGroup || t == kModifyChat){
            [alreadyArray addObjectsFromArray:array];
            [alreadyArray addObjectsFromArray:wait];
        }
        else if (t == kCall) {
            self.multiSelect = NO;
        } else {
            [addArray addObjectsFromArray:array];
        }
        viewTag = t;
        
        if(t == kFavorite){
            if(key)
                key = nil;
            key = [[NSString alloc]initWithFormat:@"favorite"];
            [addArray removeAllObjects];
            [addArray setArray:array];
            [alreadyArray removeAllObjects];
//            for(NSString *uid in array){
//                if([uid length]>1){
//            [alreadyArray addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
//            }
//            }
        }
        else{
            if(key)
                key = nil;
            key = [[NSString alloc]initWithFormat:@"newfield2"];
        }
        NSLog(@"addArray %@",addArray);
        NSLog(@"alreadyArray %@",alreadyArray);
        
        
        selectMode = kAllSelect;
    }
    return self;
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
//
//		/*
//		 t=1:addSubview
//		 t=2:removeFromsuperview
//		 */
//
////		id AppID = [[UIApplication sharedApplication]delegate];
////
////		if(t == 1)
////				[self.view addSubview:[AppID showDisableViewX:0 Y:45 W:320 H:480-kSTATUS_HEIGHT-kNAVIBAR_HEIGHT]];
////
////		else if(t == 2)
////				[AppID hideDisableView];
//}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidScroll");
//    [search resignFirstResponder];
    
    if(dropFirstobj){
        [dropFirstobj removeFromSuperview];
        dropFirstobj = nil;
    }
    if(dropSecondobj){
        [dropSecondobj removeFromSuperview];
        dropSecondobj = nil;
    }
}


//- (void)backTo
//{
//    /****************************************************************
//     작업자 : 김혜민
//     작업일자 : 2012/06/04
//     작업내용 : 뒤로 버튼을 눌렀을 때. 한단계 위의 네비게이션컨트롤러로.
//     연관화면 : 없음
//     ****************************************************************/
//
//		[self.navigationController popViewControllerWithBlockGestureAnimated:YES];
//
//}
//





- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar // 서치바 터치하는 순간 들어옴.
{
    if (self.multiSelect == YES) {
        
        
#ifdef BearTalk
#else
        [UIView animateWithDuration:0.4
                         animations:^{
                             search.frame = CGRectMake(0,0,self.view.frame.size.width,45);
                             if(deptButton)
                             deptButton.frame = CGRectMake(-98-4, 0+6, 98, 33);
                         }];
#endif
        
    }
    [searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *subView in searchBar.subviews){
        if([subView isKindOfClass:UIButton.class]){
            [(UIButton*)subView setTitle:NSLocalizedString(@"cancel", @"cancel") forState:UIControlStateNormal];
        }
    }
    
    NSLog(@"searchBarTextDidBeginEditing %f",self.view.frame.size.height);
    //    [SharedAppDelegate.root coverDisableView:self.view x:0 y:44 w:320 h:self.view.frame.size.height];
    [self.view addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:CGRectMake(0, CGRectGetMaxY(searchView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(searchView.frame))]];
    
    
    if(chosungArray)
    {
//        [chosungArray release];
        chosungArray = nil;
    }
    
    NSString *name = @"";//[[NSString alloc]init];
    NSString *team = @"";
    chosungArray = [[NSMutableArray alloc]init];
    for(NSDictionary *forDic in myList)//int i = 0 ; i < [originList count] ; i ++)
    {
        name = forDic[@"name"];
        NSString *str = [self getUTF8String:name];//[AppID GetUTF8String:name];
        //        [chosungArray addObject:str];
        team = forDic[@"team"];
        NSString *str2 = [self getUTF8String:team];//[AppID GetUTF8String:name];
        [chosungArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"name",str2,@"team",nil]];
//        NSLog(@"str %@ str2 %@",str,str2);
    }
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 검색바를 터치하는 순간 들어오는 함수. 뒤의 화면을 불투명하게 해 주고 초성배열을 만든다.
     param - searchBar(UISearchBar *) : 검색바
     연관화면 : 검색
     ****************************************************************/
    
    
    
    //		if(searching)
    //				return;
    //
    //    id AppID = [[UIApplication sharedApplication]delegate];
    //		[self settingDisableViewOverlay:1];
    //
    //		[searchBar setShowsCancelButton:YES animated:YES];
    //
    //
    //		self.myTable.userInteractionEnabled = NO;
    //
    //		NSString *name = @"";//[[NSString alloc]init];
    //		chosungArray = [[NSMutableArray alloc]init];
    //		for(NSDictionary *forDic in myList)//int i = 0 ; i < [myList count] ; i ++)
    //		{
    //				name = [forDicobjectForKey:@"name"];
    //				NSString *str = [AppID GetUTF8String:name];
    //				[chosungArray addObject:str];
    //		}
    //
    //		searching = YES;
    
    
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
            textResult = [NSString stringWithFormat:@"%@%@", textResult, chosung[chosungIndex]];
        }
    }
    return textResult;
}




//
//- (void)enableCancelButton:(UISearchBar *)searchBar
//{
//
////		for (id subview in [searchBar subviews])
////		{
////				if([subview isKindOfClass:[UIButton class]])
////				{
////						[subview setEnabled:TRUE];
////				}
////		}
//}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText // 터치바에 글자 쓰기
{
    [copyList removeAllObjects];
    
    
    
    if([searchText length]>0)
    {
        NSMutableDictionary *searchDic;
        [SharedAppDelegate.root removeDisableView];
        
        myTable.userInteractionEnabled = YES;
        searching = YES;
        if([searchText hasPrefix:@"0"] || [searchText hasPrefix:@"1"] || [searchText hasPrefix:@"2"] || [searchText hasPrefix:@"3"] || [searchText hasPrefix:@"4"] || [searchText hasPrefix:@"5"] || [searchText hasPrefix:@"6"] || [searchText hasPrefix:@"7"] || [searchText hasPrefix:@"8"] || [searchText hasPrefix:@"9"]){
            
            for(int i = 0 ; i < [myList count] ; i++)
            {
                searchDic = myList[i];
                NSString *cellphone = [SharedAppDelegate.root getPureNumbers:searchDic[@"cellphone"]];
                NSString *companyphone = [SharedAppDelegate.root getPureNumbers:searchDic[@"companyphone"]];
                if([cellphone rangeOfString:searchText].location != NSNotFound
                   || [companyphone rangeOfString:searchText].location != NSNotFound
                   )
                {
                    if(viewTag == kFavorite){
                        
                        int catch = 0;
                        for(int j = 0; j < [addArray count];j++)
                        {
                            //                        NSString *chkUid = addArray[j][@"uniqueid"];
                            if([searchDic[@"uniqueid"] isEqualToString:addArray[j][@"uniqueid"]])
                                catch = 1;
                        }
                        if(catch == 1)
                        [searchDic setObject:[NSString stringWithFormat:@"%d",catch] forKey:key];
                        else
                            [searchDic setObject:[NSString stringWithFormat:@"%d",0] forKey:key];
                    }
                    else{
                    int catch = 0;
                    for(int j = 0; j < [addArray count];j++)
                    {
//                        NSString *chkUid = addArray[j][@"uniqueid"];
                        if([searchDic[@"uniqueid"] isEqualToString:addArray[j][@"uniqueid"]])
                            catch = 1;
                    }
                    for(int j = 0; j < [alreadyArray count];j++)
                    {
//                        NSString *chkUid = alreadyArray[j][@"uniqueid"];
                        if([searchDic[@"uniqueid"] isEqualToString:alreadyArray[j][@"uniqueid"]])
                            catch = 2;
                    }
                    
                    [searchDic setObject:[NSString stringWithFormat:@"%d",catch] forKey:key];
                    }
                    
                    [copyList addObject:searchDic];
                    
                }
            }
        }
        else{
            
            for(int i = 0 ; i < [myList count] ; i++)
            {
                searchDic = myList[i];
                NSString *chosungname = chosungArray[i][@"name"];
                NSString *chosungteam = chosungArray[i][@"team"];
                
                NSString *team = searchDic[@"team"];
                NSString *name = searchDic[@"name"];
                
                if([chosungname rangeOfString:searchText].location != NSNotFound // 초성 배열에 searchText가 있느냐
                   || [chosungteam rangeOfString:searchText].location != NSNotFound
                   || [[name lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound // 이름에 searchText가 있느냐
                   || [[team lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound
                   )
                {
                    if(viewTag == kFavorite){
                        
                        int catch = 0;
                        for(int j = 0; j < [addArray count];j++)
                        {
                            //                        NSString *chkUid = addArray[j][@"uniqueid"];
                            if([searchDic[@"uniqueid"] isEqualToString:addArray[j][@"uniqueid"]])
                                catch = 1;
                            else
                                [searchDic setObject:[NSString stringWithFormat:@"%d",0] forKey:key];
                        }
                        
                        [searchDic setObject:[NSString stringWithFormat:@"%d",catch] forKey:key];
                    }
                    else{
                        
                    int catch = 0;
//                    NSString *aUid = searchDic[@"uniqueid"];
                    for(int j = 0; j < [addArray count];j++)
                    {
//                        NSString *chkUid = addArray[j][@"uniqueid"];
                        if([searchDic[@"uniqueid"] isEqualToString:addArray[j][@"uniqueid"]])
                            catch = 1;
                    }
                    for(int j = 0; j < [alreadyArray count];j++)
                    {
//                        NSString *chkUid = alreadyArray[j][@"uniqueid"];
                        if([searchDic[@"uniqueid"] isEqualToString:alreadyArray[j][@"uniqueid"]])
                            catch = 2;
                    }
                    
                    [searchDic setObject:[NSString stringWithFormat:@"%d",catch] forKey:key];
                    
                    }
                    [copyList addObject:searchDic];
                    
                
                }
            }
            
        }
    }
    
    else
    {
        NSLog(@"text not exist %f",self.view.frame.size.height);
        
        [searchBar becomeFirstResponder];
        //        [SharedAppDelegate.root coverDisableView:self.view x:0 y:44 w:320 h:self.view.frame.size.height];
        [self.view addSubview:[SharedAppDelegate.root coverDisableViewWithFrame:CGRectMake(0, CGRectGetMaxY(searchView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(searchView.frame))]];
        myTable.userInteractionEnabled = NO;
        searching = NO;
        
    }
    
    [myTable reloadData];
    
//    myTable.frame = CGRectMake(0, searchView.frame.size.height + memberView.frame.size.height, 320, self.view.frame.size.height - searchView.frame.size.height - memberView.frame.size.height);
    
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
    //                       || [[[myListobjectatindex:i] [@"name"] rangeOfString:searchText].location != NSNotFound // 이름에 searchText가 있느냐
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

- (void)checkAdd:(NSString *)uid//:(NSMutableArray *)list
{
    
       NSLog(@"checkAdd  %@",uid);
    
    
    
    for(int j = 0; j<[copyList count];j++)
    {
//        NSDictionary *aDic = copyList[j];
//        NSString *aUid = copyList[j][@"uniqueid"];
        if([uid isEqualToString:copyList[j][@"uniqueid"]])
        {
            NSDictionary *newDic = [SharedFunctions fromOldToNew:copyList[j] object:@"1" key:key];
            [copyList replaceObjectAtIndex:j withObject:newDic];
            NSLog(@"copyList got it");
        }
        
        
    }
    
    for(int j = 0; j<[favList count];j++)
    {
//        NSDictionary *aDic = favList[j];
//        NSString *aUid = aDic[@"uniqueid"];
        if([uid isEqualToString:favList[j][@"uniqueid"]])
        {
            NSDictionary *newDic = [SharedFunctions fromOldToNew:favList[j] object:@"1" key:key];
            [favList replaceObjectAtIndex:j withObject:newDic];
            NSLog(@"favList got it");
        }
        
        
    }
    for(int j = 0; j<[deptList count];j++)
    {
//        NSDictionary *aDic = deptList[j];
//        NSString *aUid = aDic[@"uniqueid"];
        if([uid isEqualToString:deptList[j][@"uniqueid"]])
        {
            NSDictionary *newDic = [SharedFunctions fromOldToNew:deptList[j] object:@"1" key:key];
            [deptList replaceObjectAtIndex:j withObject:newDic];
            NSLog(@"deptList got it");
        }
        
        
    }
    for(int j = 0; j<[addRestList count];j++)
    {
//        NSDictionary *aDic = addRestList[j];
//        NSString *aUid = aDic[@"uniqueid"];
        if([uid isEqualToString:addRestList[j][@"uniqueid"]])
        {
            NSDictionary *newDic = [SharedFunctions fromOldToNew:addRestList[j] object:@"1" key:key];
            [addRestList replaceObjectAtIndex:j withObject:newDic];
//            NSLog(@"addRestList got it");
        }
        
        
    }
}

- (void)checkDelete:(NSString *)uid
{
    NSLog(@"checkDelete %@",uid);
    
    if(selectMode == kAllSelect){
    for(int i = 0; i<[copyList count];i++)
    {
//        NSDictionary *aDic = copyList[i];
//        NSString *aUid = aDic[@"uniqueid"];
        if([copyList[i][@"uniqueid"] isEqualToString:uid])
        {
            NSLog(@"there copy");
            NSDictionary *newDic = [SharedFunctions fromOldToNew:copyList[i] object:@"0" key:key];
            [copyList replaceObjectAtIndex:i withObject:newDic];
        }
        
        
    }
    NSLog(@"favlist %@",favList);
    for(int i = 0; i<[favList count];i++)
    {
//        NSDictionary *aDic = favList[i];
//        NSString *aUid = aDic[@"uniqueid"];
        if([favList[i][@"uniqueid"] isEqualToString:uid])
        {
            NSLog(@"there fav");
            NSDictionary *newDic = [SharedFunctions fromOldToNew:favList[i] object:@"0" key:key];
            [favList replaceObjectAtIndex:i withObject:newDic];
        }
        
        
    }
    for(int i = 0; i<[deptList count];i++)
    {
//        NSDictionary *aDic = deptList[i];
//        NSString *aUid = aDic[@"uniqueid"];
        if([deptList[i][@"uniqueid"] isEqualToString:uid])
        {
            NSLog(@"there dept");
            NSDictionary *newDic = [SharedFunctions fromOldToNew:deptList[i] object:@"0" key:key];
            [deptList replaceObjectAtIndex:i withObject:newDic];
        }
        
        
    }
    for(int i = 0; i<[addRestList count];i++)
    {
//        NSDictionary *aDic = addRestList[i];
//        NSString *aUid = aDic[@"uniqueid"];
        if([addRestList[i][@"uniqueid"] isEqualToString:uid])
        {
            NSLog(@"there addrest");
            NSDictionary *newDic = [SharedFunctions fromOldToNew:addRestList[i] object:@"0" key:key];
            [addRestList replaceObjectAtIndex:i withObject:newDic];
        }
        
        
    }
    }
    else{
        for(int i = 0; i<[deptContactList count];i++)
        {
            //        NSDictionary *aDic = addRestList[i];
            //        NSString *aUid = aDic[@"uniqueid"];
            if([deptContactList[i][@"uniqueid"] isEqualToString:uid])
            {
                NSLog(@"there addrest");
                NSDictionary *newDic = [SharedFunctions fromOldToNew:deptContactList[i] object:@"0" key:key];
                [deptContactList replaceObjectAtIndex:i withObject:newDic];
            }
            
            
        }
        
    }
    
}





// 취소 버튼 누르면 키보드 내려가기
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    if (self.multiSelect == YES) {
#ifdef BearTalk
#else
        [UIView animateWithDuration:0.4
                         animations:^{
                             search.frame = CGRectMake(103,0,320-103,45);
                             deptButton.frame = CGRectMake(4, 0+6, 98, 33);
#ifdef Batong
                             
                             
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
                             if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] < 70){
                             deptButton.hidden = YES;
                             search.frame = CGRectMake(0, 0, 320, 45);
                             }
#endif
         
                         }];
        
#endif
        
    }
    [searchBar setShowsCancelButton:NO animated:YES];
    //
    //		searchBar.text = @"";
    //		[searchBar resignFirstResponder]; // 키보드 내리기
    //
    //		searching = NO;
    //		self.myTable.userInteractionEnabled = YES;
    //		[self settingDisableViewOverlay:2];
    //		[myTable reloadData];
    search.text = @"";
    [search resignFirstResponder];
    [myTable setUserInteractionEnabled:YES];
    [SharedAppDelegate.root removeDisableView];
    searching = NO;
    [myTable reloadData];
    [self reloadCheck];
    
}


// 키보드의 검색 버튼을 누르면
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [search resignFirstResponder];
    //		search.showsCancelButton = YES;
    //		searching = YES;
    //
    //		[searchBar resignFirstResponder];
    //
    //		[self settingDisableViewOverlay:2];
    //    self.myTable.userInteractionEnabled = YES;
    //    [self performSelector:@selector(enableCancelButton:) withObject:searchBar afterDelay:0.0];
    
    [self reloadCheck];
}




// 섹션에 몇 개의 셀이 있는지.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSLog(@"numberofRow");
    if(searching)
    {
        return [copyList count];
    }
    else
    {
    if(selectMode == kAllSelect) {
 
#ifdef Batong
        
        if(section == 0)
            return [deptList count]==0?1:[deptList count];
        else
            return addRest?[addRestList count]:1;
        
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
          if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] == 60)
          {
              if(section == 0)
                  return [deptList count]==0?1:[deptList count];
              else
                  return addRest?[addRestList count]:1;
                  
          }
        if(section == 0)
            return addRest?[addRestList count]:1;
#elif BearTalk
        if(viewTag == kFavorite){
            
            if(section == 0){
                return [deptList count]==0?1:[deptList count];
                //                    if([deptList count]>0)
                //                        return addRest?[deptList count]:[deptList count]+1;
                //                    else
                //                    {
                //                        return addRest?[addRestList count]:1;
                //
                //                    }
            }
            else if(section == 1){
                return addRest?[addRestList count]:1;
            }
        }
        else{
            if(section == 0)
            {
                return [favList count]==0?1:[favList count];
            }
            else if(section == 1){
                return [deptList count]==0?1:[deptList count];
                //                    if([deptList count]>0)
                //                        return addRest?[deptList count]:[deptList count]+1;
                //                    else
                //                    {
                //                        return addRest?[addRestList count]:1;
                //
                //                    }
            }
            else if(section == 2){
                return addRest?[addRestList count]:1;
            }
        }
#else
        
        if(section == 0)
        {
            return [favList count]==0?1:[favList count];
        }
        else if(section == 1){
            return [deptList count]==0?1:[deptList count];
            //                    if([deptList count]>0)
            //                        return addRest?[deptList count]:[deptList count]+1;
            //                    else
            //                    {
            //                        return addRest?[addRestList count]:1;
            //
            //                    }
        }
        else if(section == 2){
            return addRest?[addRestList count]:1;
        }
#endif
    }
    else{
        return [deptContactList count]>0?[deptContactList count]:1;
    }
    }
    return 0;
    
}


// 몇 개의 섹션이 있는지. // 얘가 먼저 호출됨.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberofSec");
    NSInteger sec = 0;
    
    if(searching)
        sec = 1;
    
    else
    {
    if(selectMode == kAllSelect) {
 
#ifdef Batong
        sec = 2;
        
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
                 if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] == 60)
                     sec = 2;
        else
        sec = 1;
#elif BearTalk
     if(viewTag == kFavorite)
         sec = 2;
        else
        sec = 3;
#else
        
        sec = 3;
#endif
        //    if([deptList count]>0 && addRest)
        //        sec += 1;
        //    if(addRest)
        //        sec += 1;
        
    }
    
    else{
        sec = 1;
    }
    }
    NSLog(@"viewTag %d selectmode %d",(int)viewTag,(int)selectMode);
    NSLog(@"sec %d",(int)sec);
    
    return sec;
}



// 해당 뷰가 생성될 때 한 번만 호출
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    //    dragging = NO;
    
    //    id AppID = [[UIApplication sharedApplication]delegate];
    //    if(viewTag == 1)
    //    {
    //		self.title = @"즐겨찾기선택";
    //
    //
    //		UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(backTo) frame:CGRectMake(0, 0, 50, 32)
    //																	 imageNamedBullet:nil imageNamedNormal:@"n00_globe_cancel_button_01_01.png" imageNamedPressed:@"n00_globe_cancel_button_01_02.png"];
    //
    //    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    //    self.navigationItem.leftBarButtonItem = btnNavi;
    //    [btnNavi release];
    //		[button release];
    //
    //		button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(addOK) frame:CGRectMake(0, 0, 50, 32)
    //												 imageNamedBullet:nil imageNamedNormal:@"n00_globe_check_button_01_01.png" imageNamedPressed:@"n00_globe_check_button_01_02.png"];
    //    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    //    self.navigationItem.rightBarButtonItem = btnNavi;
    //    [btnNavi release];
    //
    //		[button release];
    //    }
    //    else
    //        if(viewTag == 2) {
    //
    //    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
//    UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(exitView)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    //    [button release];
    UIButton *button;
    UIBarButtonItem *btnNavi;

    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(exitView)];

    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    if (self.multiSelect == YES) {
#ifdef BearTalk
        
        if(viewTag == kFavorite)
            button = nil;
        else
        button = [CustomUIKit emptyButtonWithTitle:@"actionbar_btn_organization.png" target:self selector:@selector(selectDept)];
#else
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(closeView)];
#endif
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = btnNavi;
//        [btnNavi release];
    }
    
    //    [button release];
    
    
    
    //    }
    //        else if(viewTag == 3) {
    //		self.title = @"벤치비";
    //
    //		UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
    //                                                                         style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    //
    //		self.navigationItem.leftBarButtonItem = cancelButton;
    //        [cancelButton release];
    //
    //	}
    
    
    buttonView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,0)];
    [self.view addSubview:buttonView];
    
#ifdef BearTalk
    
    
    if(self.multiSelect == NO || viewTag == kFavorite){
        
        buttonView.frame = CGRectMake(0,0,self.view.frame.size.width,0);
        
    }
    else{
    
    NSLog(@"kViewDept %@",[[NSUserDefaults standardUserDefaults] boolForKey:@"kViewDept"]?@"YES":@"NO");
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"kViewDept"] == YES){
    buttonView.frame = CGRectMake(0,0,self.view.frame.size.width,49);
    buttonView.userInteractionEnabled = YES;
    buttonView.backgroundColor = [UIColor whiteColor];
        
    
        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    leftButton = [CustomUIKit buttonWithTitle:@"전체보기" fontSize:16 fontColor:[NSKeyedUnarchiver unarchiveObjectWithData:colorData] target:self selector:@selector(viewAllList) frame:CGRectMake(0,0, buttonView.frame.size.width/2, buttonView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];

        
        

        [buttonView addSubview:leftButton];
        
    
    rightButton = [CustomUIKit buttonWithTitle:@"직급자보기" fontSize:16 fontColor:RGB(51,51,51) target:self selector:@selector(viewDeptContactList) frame:CGRectMake(CGRectGetMaxX(leftButton.frame),leftButton.frame.origin.y,leftButton.frame.size.width,leftButton.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [buttonView addSubview:rightButton];
        
        
    leftImage = [[UIImageView alloc] init];
    leftImage.frame = CGRectMake(0.0f, leftButton.frame.size.height-3,leftButton.frame.size.width,2);
    leftImage.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    [leftButton addSubview:leftImage];
        
    
    rightImage = [[UIImageView alloc] init];
    rightImage.frame = CGRectMake(0.0f, rightButton.frame.size.height-3,rightButton.frame.size.width,2);
    rightImage.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    [rightButton addSubview:rightImage];
        
    
    rightImage.hidden = YES;
    
//    [buttonView release];
        
        
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0,buttonView.frame.size.height-1,buttonView.frame.size.width,1)];
        [buttonView addSubview:lineView];
        lineView.backgroundColor = RGB(219, 223, 224);
        
    }
    else{
        buttonView.frame = CGRectMake(0,0,self.view.frame.size.width,0);
        
    }
        
    }
#else
    
    buttonView.frame = CGRectMake(0,0,self.view.frame.size.width,0);
    
#endif
    
    
    
    

    
#ifdef BearTalk
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    UIColor *themeColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    NSLog(@"buttonView %@",NSStringFromCGRect(buttonView.frame));
    
    searchView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(buttonView.frame),self.view.frame.size.width, 48)];
    searchView.backgroundColor = RGB(242,242,242);
    [self.view addSubview:searchView];
    //    [searchView release];
    searching = NO;
    
    
    
    
    memberView = [[UIImageView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height - 56,self.view.frame.size.width,0)];
    //    memberView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
    memberView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:memberView];
    
    memberView.layer.borderColor = RGB(234, 234, 234).CGColor;
    memberView.layer.borderWidth = 1.0;
    memberView.userInteractionEnabled = YES;
    
    memberView.hidden = YES;
    
    
    NSLog(@"addArray count5 %d",(int)[addArray count]);
    viewMemberButton = [CustomUIKit buttonWithTitle:[NSString stringWithFormat:@"선택된 멤버 %d",(int)[addArray count]] fontSize:14 fontColor:[NSKeyedUnarchiver unarchiveObjectWithData:colorData] target:self selector:@selector(viewMember:) frame:CGRectMake(16,9, memberView.frame.size.width/2, memberView.frame.size.height-17) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    viewMemberButton.layer.borderWidth = 1;
    viewMemberButton.layer.borderColor = themeColor.CGColor;
    viewMemberButton.clipsToBounds = YES;
    viewMemberButton.layer.cornerRadius = 2.0f;
    [memberView addSubview:viewMemberButton];
    
    doneButton = [CustomUIKit buttonWithTitle:@"선택 완료" fontSize:14 fontColor:[UIColor whiteColor] target:self selector:@selector(closeView) frame:CGRectMake(CGRectGetMaxX(viewMemberButton.frame)+8, 9, memberView.frame.size.width - 16 - (CGRectGetMaxX(viewMemberButton.frame)+8),viewMemberButton.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    doneButton.layer.borderWidth = 1;
    doneButton.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    doneButton.layer.borderColor = themeColor.CGColor;
    doneButton.clipsToBounds = YES;
    doneButton.layer.cornerRadius = 2.0f;
    [memberView addSubview:doneButton];
    
    
    
    
    
    filterTag = 0;
    subfilterTag = 0;
  
    filterView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(buttonView.frame),320,48)];
    filterView.backgroundColor = RGB(238, 242, 245);
    [self.view addSubview:filterView];

    
    NSLog(@"multiSelect %@",self.multiSelect==YES?@"YES":@"NO");
   
    memberAllSelectButton = [CustomUIKit buttonWithTitle:@"전체 선택" fontSize:14 fontColor:RGB(91, 103, 114) target:self selector:@selector(memberAllSelect:) frame:CGRectMake(12, 9, 75, 30) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [filterView addSubview:memberAllSelectButton];
//    [memberAllSelectButton setBackgroundImage:[[UIImage imageNamed:@"button_note_filter.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:10] forState:UIControlStateNormal];
    memberAllSelectButton.backgroundColor = [UIColor whiteColor];
//    [memberAllSelectButton release];
    
    memberAllSelectButton.layer.borderColor = RGB(203,208,209).CGColor;
    memberAllSelectButton.layer.borderWidth = 1.0f;
    memberAllSelectButton.layer.cornerRadius = 4.0f;
    memberAllSelectButton.clipsToBounds = YES;
    
    NSLog(@"memberall %@",NSStringFromCGRect(memberAllSelectButton.frame));
    
    
    
    filterImageView = [[UIImageView alloc]init];
    filterImageView.layer.borderColor = RGB(203,208,209).CGColor;
    filterImageView.layer.borderWidth = 1.0f;
    filterImageView.layer.cornerRadius = 4.0;
    filterImageView.clipsToBounds = YES;
    filterImageView.backgroundColor = [UIColor whiteColor];
    [filterView addSubview:filterImageView];
//    [filterImageView release];
    filterImageView.userInteractionEnabled = YES;
    filterLabel = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:RGB(91, 103, 114) frame:CGRectMake(10, 5, 320-30, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [filterImageView addSubview:filterLabel];
    filterLabel.text = @"전체 회사";
    
    
    
//    filterLabel.frame = CGRectMake(5, 5, filterImageView.frame.size.width - 5, 20);
    
    filterButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showFilterActionSheet:) frame:CGRectMake(0, 0, filterImageView.frame.size.width, filterImageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    filterButton.tag = kFirstFilter;
    [filterImageView addSubview:filterButton];
  
    subfilterImageView = [[UIImageView alloc]init];
    
    subfilterImageView.layer.borderColor = RGB(203,208,209).CGColor;
    subfilterImageView.layer.borderWidth = 1.0f;
    subfilterImageView.layer.cornerRadius = 4.0;
    subfilterImageView.backgroundColor = [UIColor whiteColor];
    subfilterImageView.clipsToBounds = YES;
    [filterView addSubview:subfilterImageView];
//    [subfilterImageView release];
    subfilterImageView.userInteractionEnabled = YES;
    
    subfilterLabel = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:RGB(91, 103, 114) frame:CGRectMake(10, 14, 320-30, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [subfilterImageView addSubview:subfilterLabel];
    subfilterLabel.text = @"전체 직급";
    
//    subfilterLabel.frame = CGRectMake(5, 5, subfilterImageView.frame.size.width - 5, 20);
    
    subfilterButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showFilterActionSheet:) frame:CGRectMake(0, 0, subfilterImageView.frame.size.width, subfilterImageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    subfilterButton.tag = kSecondFilter;
    [subfilterImageView addSubview:subfilterButton];
    
    subfilterImageView.frame = CGRectMake(filterView.frame.size.width - 12 - 100, memberAllSelectButton.frame.origin.y, 100, memberAllSelectButton.frame.size.height);
    filterImageView.frame = CGRectMake(CGRectGetMaxX(memberAllSelectButton.frame)+4, memberAllSelectButton.frame.origin.y, subfilterImageView.frame.origin.x - CGRectGetMaxX(memberAllSelectButton.frame) - 4*2, memberAllSelectButton.frame.size.height);
    filterLabel.frame = CGRectMake(10, 0, filterImageView.frame.size.width - 20 - 20, filterImageView.frame.size.height);
    subfilterLabel.frame = CGRectMake(10, 0, subfilterImageView.frame.size.width - 20 - 20, subfilterImageView.frame.size.height);
    filterButton.frame = CGRectMake(0, 0, filterImageView.frame.size.width, filterImageView.frame.size.height);
    subfilterButton.frame = CGRectMake(0, 0, subfilterImageView.frame.size.width, subfilterImageView.frame.size.height);
    
    UIImageView *arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(filterImageView.frame.size.width - 10 - 12, 9, 12, 12)];
    arrowImage.image = [UIImage imageNamed:@"selectbox_arrow.png"];
    [filterImageView addSubview:arrowImage];
    
    
    arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(subfilterImageView.frame.size.width - 10 - 12, 9, 12, 12)];
    arrowImage.image = [UIImage imageNamed:@"selectbox_arrow.png"];
    [subfilterImageView addSubview:arrowImage];
    
    NSLog(@"searchview1 %@",NSStringFromCGRect(searchView.frame));
    
#else
    
    
    
    
    memberView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,0)];
    //    memberView.image = [CustomUIKit customImageNamed:@"n09_gtalkmnbar.png"];
    memberView.backgroundColor = RGB(249, 180, 78);
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    memberView.backgroundColor = GreenTalkColor;
#endif
    [self.view addSubview:memberView];
    memberView.userInteractionEnabled = YES;
    
    memberView.hidden = YES;
    //    [memberView release];
    
    //    NSLog(@"addArray %@",addArray);
    NSLog(@"addArray count6 %d",(int)[addArray count]);
    memberCountLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"선택된 멤버 %d명",(int)[addArray count]] fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(5, 0, 120, memberView.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [memberView addSubview:memberCountLabel];
    
    detailMember = [[UIImageView alloc]initWithFrame:CGRectMake(320-20,16,7,11)];
    detailMember.image = [UIImage imageNamed:@"n06_nocal_ary.png"];
    [memberView addSubview:detailMember];
    //    [detailMember release];
    
    viewMemberLabel = [CustomUIKit labelWithText:@"전체보기" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(320-5-20-5-100, 0, 100, memberView.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentRight];
    [memberView addSubview:viewMemberLabel];
    
    
//    UIButton *viewMemberButton;
    viewMemberButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(viewMember:) frame:CGRectMake(0,0, memberView.frame.size.width, memberView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
    [memberView addSubview:viewMemberButton];
    //    [viewMemberButton release];
    
    searchView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(buttonView.frame),320,45)];
    searchView.backgroundColor = RGB(242,242,242);
    [self.view addSubview:searchView];
    //    [searchView release];
    searching = NO;
    
    NSLog(@"searchview2 %@",NSStringFromCGRect(searchView.frame));
    filterView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(buttonView.frame),320,0)];
    [self.view addSubview:filterView];
//    [filterView release];
    
#endif
    
    NSLog(@"searchview3 %@",NSStringFromCGRect(searchView.frame));
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
    search.placeholder = @"멤버 검색";
    [searchView addSubview:search];
//    [search release];
    search.delegate = self;
    search.layer.borderWidth = 1;
    search.layer.borderColor = [RGB(242,242,242) CGColor];
    
  
    
        search.tintColor = [UIColor grayColor];
        if ([search respondsToSelector:@selector(barTintColor)]) {
            search.barTintColor = RGB(242,242,242);
        }
   
    
#ifdef BearTalk
    
     search.placeholder = @"이름(초성), 부서, 전화번호 검색";
    search.frame = CGRectMake(0,0,self.view.frame.size.width,48);
    
    if ([search respondsToSelector:@selector(barTintColor)]) {
        
        search.barTintColor = RGB(238, 242, 245);
    }
    search.layer.borderWidth = 1;
    search.layer.borderColor = [RGB(234, 237, 239) CGColor];
    
    for(int i =0; i<[search.subviews count]; i++) {
        
        if([[search.subviews objectAtIndex:i] isKindOfClass:[UITextField class]])
            
            [(UITextField*)[search.subviews objectAtIndex:i] setFont:[UIFont systemFontOfSize:13]];
        
    }
    NSLog(@"searchview5 %@",NSStringFromCGRect(searchView.frame));
#else
    
    UIView *lineView;
    CGRect rect = search.frame;
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height-2,rect.size.width, 2)];
    lineView.backgroundColor = RGB(242,242,242);
    [search addSubview:lineView];
    NSLog(@"searchview4 %@",NSStringFromCGRect(searchView.frame));
    
#endif
    
//    [lineView release];
    
    searchView.hidden = NO;
    filterView.hidden = YES;
//    
//    NSShadow *shadow = [NSShadow new];
//    [shadow setShadowOffset: CGSizeMake(0.0f, 1.0f)];
//    
//    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,shadow,NSShadowAttributeName,nil] forState:UIControlStateNormal];
//    
    if (self.multiSelect == YES) {
#ifdef BearTalk
#else
        search.frame = CGRectMake(103,0,320-103,45);
        deptButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(selectDept) frame:CGRectMake(4, 0+6, 98, 33)
                                 imageNamedBullet:nil imageNamedNormal:@"button_selectmemberbydept.png" imageNamedPressed:nil];
        [searchView addSubview:deptButton];
#ifdef Batong
        
#elif  defined(GreenTalk) || defined(GreenTalkCustomer)
        
        if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] < 70){
        deptButton.hidden = YES;
        search.frame = CGRectMake(0, 0, 320, 45);
        }
#endif
        
#endif
    }
    
    //  search.tintColor = RGB(183, 186, 165);
    
    
    // remove line under searchbar
    //    CGRect rect = search.frame;
    //    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, rect.size.height-2,rect.size.width, 2)];
    //    lineView.backgroundColor = RGB(242,242,242);
    //    [search addSubview:lineView];
    //    [lineView release];
    
    // remove line above searchbar
    
    
    myTable = [[UITableView alloc]init];//WithFrame:CGRectMake(0, search.frame.size.height + memberView.frame.size.height, 320, self.view.frame.size.height - search.frame.size.height - search.frame.size.height) style:UITableViewStylePlain];

    
    myTable.dataSource = self;
    myTable.delegate = self;
    myTable.rowHeight = 50;
#ifdef BearTalk
    myTable.rowHeight = 10+42+10;
#endif
    
    [self.view addSubview:myTable];
//    [myTable release];
    //    myTable.scrollsToTop = YES;
    
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    myList = [[NSMutableArray alloc]init];
    favList = [[NSMutableArray alloc]init];
    deptList = [[NSMutableArray alloc]init];
    addRestList = [[NSMutableArray alloc]init];
    
#ifdef Batong
    [myList setArray:[[ResourceLoader sharedInstance] allContactList]];
    
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    
    
    
    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue]<70)
        [myList setArray:[[ResourceLoader sharedInstance] myDeptList]];
    else
        [myList setArray:[[ResourceLoader sharedInstance] allContactList]];
    
    
#else
    [myList setArray:[[ResourceLoader sharedInstance] allContactList]];
#endif
    
    for(int i = 0; i < [myList count]; i++){
//        NSString *aUid = myList[i][@"uniqueid"];
        if([myList[i][@"uniqueid"] isEqualToString:[ResourceLoader sharedInstance].myUID])
            [myList removeObjectAtIndex:i];
    }
    
    
    //    [addRestList removeAllObjects];
    [favList removeAllObjects];
    [deptList removeAllObjects];
    
    addRest = YES;
    
    
    NSString *mydeptcode = [SharedAppDelegate readPlist:@"myinfo"][@"deptcode"];
//    
//    for(NSDictionary *dic in myList){
//        NSString *favorite = dic[key];
//        NSString *uniqueid = dic[@"uniqueid"];
//        if([favorite isEqualToString:@"1"] && ![uniqueid isEqualToString:[ResourceLoader sharedInstance].myUID]){
//            NSLog(@"fav! %@",dic[@"name"]);
//            [favList addObject:dic];
//        }
//        //        else{
//        //            if([dic[@"deptcode"]isEqualToString:mydeptcode])
//        //            {
//        //                NSLog(@"dept! %@",dic[@"name"]);
//        //                [deptList addObject:dic];
//        //            }else{ //if()
//        //                //                NSLog(@"addRest! %@",[dicobjectForKey:@"name"]);
//        //                //                [addRestList addObject:dic];
//        //            }
//        //        }
//    }
    
    for(NSString *uid in [ResourceLoader sharedInstance].favoriteList){
        if(![uid isEqualToString:[ResourceLoader sharedInstance].myUID]){
            if([[SharedAppDelegate.root searchContactDictionary:uid]count]>0)
                [favList addObject:[SharedAppDelegate.root searchContactDictionary:uid]];
        }
    }
    
    for(NSDictionary *dic in myList){
        
        NSString *deptcode = dic[@"deptcode"];
        NSString *uniqueid = dic[@"uniqueid"];
        if([deptcode isEqualToString:mydeptcode] && ![uniqueid isEqualToString:[ResourceLoader sharedInstance].myUID])
        {
            NSLog(@"dept! %@",dic[@"name"]);
            [deptList addObject:dic];
        }
    }
    
    
    copyList = [[NSMutableArray alloc]init];
    
    NSLog(@"favlist1 %@",favList);
    NSLog(@"favlist2 %@",alreadyArray);
    NSLog(@"favlist3 %@",addArray);
    
    for(int i = 0; i < [favList count]; i++)
    {
        int catch = 0;
//        NSDictionary *aDic = favList[i];
        
        for(int j = 0; j < [alreadyArray count];j++)
        {
//            NSString *aUid = aDic[@"uniqueid"];
//            NSString *chkUid = alreadyArray[j][@"uniqueid"];
            if([favList[i][@"uniqueid"] isEqualToString:alreadyArray[j][@"uniqueid"]])
                catch = 2;
        }
        for(int j = 0; j < [addArray count];j++)
        {
//            NSString *aUid = aDic[@"uniqueid"];
//            NSString *chkUid = addArray[j][@"uniqueid"];
            if([favList[i][@"uniqueid"] isEqualToString:addArray[j][@"uniqueid"]])
                catch = 1;
        }
        
        NSLog(@"catch %d %@",catch,favList[i]);
        NSDictionary *newDic = [SharedFunctions fromOldToNew:favList[i] object:[NSString stringWithFormat:@"%d",catch] key:key];
        [favList replaceObjectAtIndex:i withObject:newDic];
        
    }
    
    NSLog(@"favlist4 %@",favList);
    NSLog(@"favlist5 %@",deptList);
    for(int i = 0; i < [deptList count]; i++)
    {
        int catch = 0;
//        NSDictionary *aDic = deptList[i];
        
        for(int j = 0; j < [alreadyArray count];j++)
        {
//            NSString *aUid = deptList[i][@"uniqueid"];
//            NSString *chkUid = alreadyArray[j][@"uniqueid"];
            if([deptList[i][@"uniqueid"] isEqualToString:alreadyArray[j][@"uniqueid"]])
                catch = 2;
        }
        for(int j = 0; j < [addArray count];j++)
        {
//            NSString *aUid = deptList[i][@"uniqueid"];
//            NSString *chkUid = addArray[j][@"uniqueid"];
            if([deptList[i][@"uniqueid"] isEqualToString:addArray[j][@"uniqueid"]])
                catch = 1;
        }
        //        if(catch)
        NSLog(@"catch %d %@",catch,deptList[i]);
        NSDictionary *newDic = [SharedFunctions fromOldToNew:deptList[i] object:[NSString stringWithFormat:@"%d",catch] key:key];
        [deptList replaceObjectAtIndex:i withObject:newDic];
        
        //        else
        //            [deptList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[deptListobjectatindex:i] object:@"0" key:key]];
        
    }
    
    NSLog(@"favlist6 %@",deptList);
    [self setRestList];
    
#ifdef BearTalk
    
    deptContactList = [[NSMutableArray alloc]init];
    
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"고문"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    
    
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"담당임원"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"대표이사"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"사업부장"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"사업부장대행"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"사외이사"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"센터장"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"센터장대행"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"소장"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"소장대행"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"실장"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"실장대행"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"연구소장"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"예비(최고)소장"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"지사장"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"최고소장"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
    for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                
                if([gradeArray[1]isEqualToString:@"팀장"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }   for(NSDictionary *dic in myList){
        if([dic[@"position"]length]>0){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
            if([gradeArray count]>1){
                if([gradeArray[1]isEqualToString:@"팀장대행"]){
                    [deptContactList addObject:dic];
                }
            }
        }
    }
 
    for(int i = 0; i < [deptContactList count]; i++)
    {
        int catch = 0;
        //        NSDictionary *aDic = favList[i];
        
        for(int j = 0; j < [alreadyArray count];j++)
        {
            //            NSString *aUid = aDic[@"uniqueid"];
            //            NSString *chkUid = alreadyArray[j][@"uniqueid"];
            if([deptContactList[i][@"uniqueid"] isEqualToString:alreadyArray[j][@"uniqueid"]])
                catch = 2;
        }
        for(int j = 0; j < [addArray count];j++)
        {
            //            NSString *aUid = aDic[@"uniqueid"];
            //            NSString *chkUid = addArray[j][@"uniqueid"];
            if([deptContactList[i][@"uniqueid"] isEqualToString:addArray[j][@"uniqueid"]])
                catch = 1;
        }
        
        NSDictionary *newDic = [SharedFunctions fromOldToNew:deptContactList[i] object:[NSString stringWithFormat:@"%d",catch] key:key];
        [deptContactList replaceObjectAtIndex:i withObject:newDic];
        
    }
    allDepterList = [[NSMutableArray alloc]initWithArray:deptContactList];
    selectedDepterList = [[NSMutableArray alloc]initWithArray:deptContactList];
    
    NSLog(@"deptContactList %@",deptContactList);
    
    if(selectedTeamList){
//        [selectedTeamList release];
        selectedTeamList = nil;
    }
    selectedTeamList = [[NSMutableArray alloc]init];
    
    for(NSDictionary *dic in deptContactList){
        
        NSString *grade2 = dic[@"grade2"];
        NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
        if([gradeArray count]>1)
        [selectedTeamList addObject:gradeArray[1]];
    }
    
    [selectedTeamList setArray:[[NSOrderedSet orderedSetWithArray:selectedTeamList] array]];;
    
#endif
    //    }
    //    else if(viewTag == 3) {
    //        for(int i = 0; i < [myList count]; i++)
    //        {
    //            BOOL catch = NO;
    //
    //            for(int j = 0; j < [alreadyArray count]; j++)
    //            {
    //                if([[[myListobjectatindex:i]objectForKey:@"uniqueid"]isEqualToString:[alreadyArrayobjectatindex:j]])
    //                    catch = YES;
    //            }
    //            if(catch) {
    //                [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[myListobjectatindex:i] object:@"1" key:key]];
    //				[addArray addObject:[myListobjectatindex:i]];
    //			} else {
    //                [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[myListobjectatindex:i] object:@"0" key:key]];
    //			}
    //        }
    //		[self reloadCheck];
    //    }
    
    
    
    //    for(int i = 0; i < [myList count]; i++)
    //    {
    //        BOOL catch = NO;
    //
    //        for(int j = 0; j < [alreadyArray count];j++)
    //        {
    //            if([[[myListobjectatindex:i]objectForKey:@"uniqueid"]isEqualToString:[[alreadyArrayobjectatindex:j]objectForKey:@"uniqueid"]])
    //                catch = YES;
    //        }
    //        if(catch)
    //            [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[myListobjectatindex:i] object:@"2" key:key]];
    //
    //        else
    //            [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:[myListobjectatindex:i] object:@"0" key:key]];
    //
    //    }
    //	[copyList setArray:myList];
    
    [self reloadCheck];
    //	[self reloadCheck];
    
    
    float viewY = 64;
    
    NSLog(@"searchview7 %@",NSStringFromCGRect(searchView.frame));
        myTable.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), 320, self.view.frame.size.height - CGRectGetMaxY(searchView.frame) - viewY - memberView.frame.size.height);
    
#ifdef BearTalk
    
    NSLog(@"mytable %@",NSStringFromCGRect(myTable.frame));
    
    
    if(viewTag == kFavorite){
        NSLog(@"favlist count %d",(int)[addArray count]);
        if([addArray count]>0){
            memberView.frame = CGRectMake(0, self.view.frame.size.height - VIEWY - 56, self.view.frame.size.width, 56);
            memberView.hidden = NO;
            NSString *memberCount = [NSString stringWithFormat:@"즐겨찾기 멤버 %d",(int)[addArray count]];
            [viewMemberButton setTitle:memberCount forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            viewMemberButton.frame = CGRectMake(16,9, memberView.frame.size.width-32, memberView.frame.size.height-17);
            doneButton.frame = CGRectMake(16,0, memberView.frame.size.width-32, 0);
        
        }
        else{
            
            memberView.frame = CGRectMake(0, self.view.frame.size.height - VIEWY - 56, self.view.frame.size.width, 0);
            memberView.hidden = YES;
            [viewMemberButton setTitle:@"" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            viewMemberButton.frame = CGRectMake(16,9, memberView.frame.size.width-32, memberView.frame.size.height-17);
            doneButton.frame = CGRectMake(16,0, memberView.frame.size.width-32, 0);
        }
    }
    else{
        if([addArray count]>0){
            memberView.hidden = NO;
            memberView.frame = CGRectMake(0, self.view.frame.size.height - VIEWY - 56, self.view.frame.size.width, 56);
            NSString *memberCount = [NSString stringWithFormat:@"선택된 멤버 %d",(int)[addArray count]];
            
            [viewMemberButton setTitle:memberCount forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            NSLog(@"addArray count7 %d",(int)[addArray count]);
            viewMemberButton.frame = CGRectMake(16,9, memberView.frame.size.width/2, memberView.frame.size.height-17);
            doneButton.frame = CGRectMake(CGRectGetMaxX(viewMemberButton.frame)+8, 9, memberView.frame.size.width - 16 - (CGRectGetMaxX(viewMemberButton.frame)+8),viewMemberButton.frame.size.height);

            
        }
        else{
            
            memberView.hidden = YES;
            memberView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
            
        }
    }
    NSLog(@"mytable %@",NSStringFromCGRect(myTable.frame));
    myTable.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(searchView.frame) - memberView.frame.size.height - VIEWY);
    
#endif
}

- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData{
    
}
- (void)DropDownListViewDidCancel{
    
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex{
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
//    NSLog(@"anIndex %d count %d",anIndex,[dropdownListView._kDropDownOption count]);
    if(dropdownListView.tag == kFirstFilter){
        
        
        if(anIndex == [dropdownListView._kDropDownOption count]-1){
            [dropdownListView fadeOut];
            return;
        }
        else if(anIndex == 0){
            if(filterTag == 0){
                [dropdownListView fadeOut];
                return;
            }
            
            filterTag = anIndex;
            
            
            [deptContactList setArray:allDepterList];
            
            NSLog(@"addarray %@",addArray);
            for(int i = 0; i < [deptContactList count]; i++)
            {
                int catch = 0;
                //        NSDictionary *aDic = favList[i];
                
                for(int j = 0; j < [alreadyArray count];j++)
                {
                    //            NSString *aUid = aDic[@"uniqueid"];
                    //            NSString *chkUid = alreadyArray[j][@"uniqueid"];
                    if([deptContactList[i][@"uniqueid"] isEqualToString:alreadyArray[j][@"uniqueid"]])
                        catch = 2;
                }
                for(int j = 0; j < [addArray count];j++)
                {
                    //            NSString *aUid = aDic[@"uniqueid"];
                    //            NSString *chkUid = addArray[j][@"uniqueid"];
                    if([deptContactList[i][@"uniqueid"] isEqualToString:addArray[j][@"uniqueid"]])
                        catch = 1;
                }
                
                NSDictionary *newDic = [SharedFunctions fromOldToNew:deptContactList[i] object:[NSString stringWithFormat:@"%d",catch] key:key];
                [deptContactList replaceObjectAtIndex:i withObject:newDic];
                
            }
            
            [myTable reloadData];
            filterLabel.text = @"전체 회사";
            
            
        }
        else{
            
            if(filterTag == anIndex){
                [dropdownListView fadeOut];
                return;
            }
            
            filterTag = anIndex;
            NSMutableArray *tempArray = [NSMutableArray array];
            
            for(NSDictionary *dic in allDepterList){
                if([dropdownListView._kDropDownOption[anIndex] isEqualToString:dic[@"position"]]) {
                    [tempArray addObject:dic];
                }
            }
            [deptContactList setArray:tempArray];
            
            
            for(int i = 0; i < [deptContactList count]; i++)
            {
                int catch = 0;
                //        NSDictionary *aDic = favList[i];
                
                for(int j = 0; j < [alreadyArray count];j++)
                {
                    //            NSString *aUid = aDic[@"uniqueid"];
                    //            NSString *chkUid = alreadyArray[j][@"uniqueid"];
                    if([deptContactList[i][@"uniqueid"] isEqualToString:alreadyArray[j][@"uniqueid"]])
                        catch = 2;
                }
                for(int j = 0; j < [addArray count];j++)
                {
                    //            NSString *aUid = aDic[@"uniqueid"];
                    //            NSString *chkUid = addArray[j][@"uniqueid"];
                    if([deptContactList[i][@"uniqueid"] isEqualToString:addArray[j][@"uniqueid"]])
                        catch = 1;
                }
                
                NSDictionary *newDic = [SharedFunctions fromOldToNew:deptContactList[i] object:[NSString stringWithFormat:@"%d",catch] key:key];
                [deptContactList replaceObjectAtIndex:i withObject:newDic];
                
            }
            
            
            [myTable reloadData];
            filterLabel.text = [NSString stringWithFormat:@"%@",dropdownListView._kDropDownOption[anIndex]];
        }
        
        subfilterTag = 0;
        subfilterLabel.text = @"전체 직급";
//        filterImageView.frame = CGRectMake(CGRectGetMaxX(memberAllSelectButton.frame)+7, 7, [SharedFunctions textViewSizeForString:filterLabel.text font:filterLabel.font width:200 realZeroInsets:NO].width+5, 30);
////        filterLabel.frame = CGRectMake(5, 5, filterImageView.frame.size.width - 5, 20);
//        subfilterImageView.frame = CGRectMake(CGRectGetMaxX(filterImageView.frame)+7, filterImageView.frame.origin.y, [SharedFunctions textViewSizeForString:subfilterLabel.text font:subfilterLabel.font width:200 realZeroInsets:NO].width+5, 30);
////        subfilterLabel.frame = CGRectMake(5, 5, subfilterImageView.frame.size.width - 5, 20);
//        
//        filterButton.frame = CGRectMake(0, 0, filterImageView.frame.size.width, filterImageView.frame.size.height);
//        subfilterButton.frame = CGRectMake(0, 0, subfilterImageView.frame.size.width, subfilterImageView.frame.size.height);
        
        [selectedDepterList setArray:deptContactList];
        
        if(selectedTeamList){
//            [selectedTeamList release];
            selectedTeamList = nil;
        }
        selectedTeamList = [[NSMutableArray alloc]init];
        
        for(NSDictionary *dic in deptContactList){
            
            NSString *grade2 = dic[@"grade2"];
            NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
                if([gradeArray count]>1)
            [selectedTeamList addObject:gradeArray[1]];
        }
        
        [selectedTeamList setArray:[[NSOrderedSet orderedSetWithArray:selectedTeamList] array]];;
        
        
        
        
        BOOL allSelected = YES;
        for(NSDictionary *dic in deptContactList){
            if([dic[key] isEqualToString:@"0"])
            {
                allSelected = NO;
                
            }
        }
        
        if(allSelected){
            [memberAllSelectButton setTitle:@"해제" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            memberAllSelectButton.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
            [memberAllSelectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            
            
        }
        else{
            [memberAllSelectButton setTitle:@"전체 선택" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            memberAllSelectButton.backgroundColor = [UIColor whiteColor];//RGB(237,236,237);
            [memberAllSelectButton setTitleColor:RGB(91, 103, 114) forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//            memberAllSelectButton.titleLabel.textColor = RGB(91, 103, 114);
            
        }
    
    
    }
    else if(dropdownListView.tag == kSecondFilter){
        
        if(anIndex == [dropdownListView._kDropDownOption count]-1){
            [dropdownListView fadeOut];
            return;
        }
        else if(anIndex == 0){
            
            if(subfilterTag == 0){
                [dropdownListView fadeOut];
                return;
            }
            
            subfilterTag = anIndex;
            
            [deptContactList setArray:selectedDepterList];
            
            
            for(int i = 0; i < [deptContactList count]; i++)
            {
                int catch = 0;
                //        NSDictionary *aDic = favList[i];
                
                for(int j = 0; j < [alreadyArray count];j++)
                {
                    //            NSString *aUid = aDic[@"uniqueid"];
                    //            NSString *chkUid = alreadyArray[j][@"uniqueid"];
                    if([deptContactList[i][@"uniqueid"] isEqualToString:alreadyArray[j][@"uniqueid"]])
                        catch = 2;
                }
                for(int j = 0; j < [addArray count];j++)
                {
                    //            NSString *aUid = aDic[@"uniqueid"];
                    //            NSString *chkUid = addArray[j][@"uniqueid"];
                    if([deptContactList[i][@"uniqueid"] isEqualToString:addArray[j][@"uniqueid"]])
                        catch = 1;
                }
                
                NSDictionary *newDic = [SharedFunctions fromOldToNew:deptContactList[i] object:[NSString stringWithFormat:@"%d",catch] key:key];
                [deptContactList replaceObjectAtIndex:i withObject:newDic];
                
            }
            [myTable reloadData];
            subfilterLabel.text = @"전체 직급";
        }
        else{
            
            if(subfilterTag == anIndex){
                [dropdownListView fadeOut];
                return;
            }
            
            
            subfilterTag = anIndex;
            NSMutableArray *tempArray = [NSMutableArray array];
            for(NSDictionary *dic in selectedDepterList){
                NSArray *gradeArray = [dic[@"grade2"]componentsSeparatedByString:@"/"];
                if([gradeArray count]>1){
                if([dropdownListView._kDropDownOption[anIndex] isEqualToString:gradeArray[1]]) {
                    [tempArray addObject:dic];
                }
                }
            }
            [deptContactList setArray:tempArray];
            
            
            for(int i = 0; i < [deptContactList count]; i++)
            {
                int catch = 0;
                //        NSDictionary *aDic = favList[i];
                
                for(int j = 0; j < [alreadyArray count];j++)
                {
                    //            NSString *aUid = aDic[@"uniqueid"];
                    //            NSString *chkUid = alreadyArray[j][@"uniqueid"];
                    if([deptContactList[i][@"uniqueid"] isEqualToString:alreadyArray[j][@"uniqueid"]])
                        catch = 2;
                }
                for(int j = 0; j < [addArray count];j++)
                {
                    //            NSString *aUid = aDic[@"uniqueid"];
                    //            NSString *chkUid = addArray[j][@"uniqueid"];
                    if([deptContactList[i][@"uniqueid"] isEqualToString:addArray[j][@"uniqueid"]])
                        catch = 1;
                }
                
                NSDictionary *newDic = [SharedFunctions fromOldToNew:deptContactList[i] object:[NSString stringWithFormat:@"%d",catch] key:key];
                [deptContactList replaceObjectAtIndex:i withObject:newDic];
                
            }
            [myTable reloadData];
            subfilterLabel.text = [NSString stringWithFormat:@"%@",dropdownListView._kDropDownOption[anIndex]];
        }
        
        
//        subfilterImageView.frame = CGRectMake(CGRectGetMaxX(filterImageView.frame)+7, filterImageView.frame.origin.y, [SharedFunctions textViewSizeForString:subfilterLabel.text font:subfilterLabel.font width:200 realZeroInsets:NO].width+5, 30);
//        subfilterLabel.frame = CGRectMake(5, 5, subfilterImageView.frame.size.width - 5, 20);
//        
//        filterButton.frame = CGRectMake(0, 0, filterImageView.frame.size.width, filterImageView.frame.size.height);
//        subfilterButton.frame = CGRectMake(0, 0, subfilterImageView.frame.size.width, subfilterImageView.frame.size.height);
        
        
        
        
        BOOL allSelected = YES;
        for(NSDictionary *dic in deptContactList){
            if([dic[key] isEqualToString:@"0"])
            {
                allSelected = NO;
                
            }
        }
        
        if(allSelected){
            [memberAllSelectButton setTitle:@"해제" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            memberAllSelectButton.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
            [memberAllSelectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//            memberAllSelectButton.titleLabel.textColor = [UIColor whiteColor];
            
            
        }
        else{
            [memberAllSelectButton setTitle:@"전체 선택" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            memberAllSelectButton.backgroundColor = [UIColor whiteColor];//RGB(237,236,237);
            [memberAllSelectButton setTitleColor:RGB(91, 103, 114) forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//            memberAllSelectButton.titleLabel.textColor = RGB(91, 103, 114);
            
        }
    }
    
}
- (void)showFilterActionSheet:(id)sender{
    
    if([sender tag] == kFirstFilter){
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:@"전체 회사"];
        for(NSDictionary *dic in [ResourceLoader sharedInstance].myDeptList){
            [array addObject:dic[@"name"]];
        }
        NSLog(@"[ResourceLoader sharedInstance].myDeptList %@",[ResourceLoader sharedInstance].myDeptList);
        NSLog(@"array %@",array);
        [array addObject:NSLocalizedString(@"cancel", @"cancel")];
        
        NSLog(@"dropFirstobj %@",dropFirstobj);
        if(dropFirstobj){
            [dropFirstobj removeFromSuperview];
            dropFirstobj = nil;
        }
        if(dropSecondobj){
            [dropSecondobj removeFromSuperview];
            dropSecondobj = nil;
        }
    dropFirstobj = [[DropDownListView alloc] initWithTitle:@"" options:array
                                                        xy:CGPointMake(filterView.frame.origin.x + filterImageView.frame.origin.x + 5, filterView.frame.origin.y + filterImageView.frame.size.height+10) size:CGSizeMake(150, 250) isMultiple:NO rowHeight:44];
        dropFirstobj.delegate = self;
        dropFirstobj.tag = [sender tag];
    [dropFirstobj showInView:self.view animated:YES];
    
    /*----------------Set DropDown backGroundColor-----------------*/
    [dropFirstobj SetBackGroundDropDown_R:255.0 G:255.0 B:255.0 alpha:1.0];//
    }
    else{
        
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:@"전체 직급"];
        [array addObjectsFromArray:selectedTeamList];
        [array addObject:NSLocalizedString(@"cancel", @"cancel")];
        
        if(dropFirstobj){
            [dropFirstobj removeFromSuperview];
            dropFirstobj = nil;
        }
        if(dropSecondobj){
            [dropSecondobj removeFromSuperview];
            dropSecondobj = nil;
        }
        dropSecondobj = [[DropDownListView alloc] initWithTitle:@"" options:array
                                                             xy:CGPointMake(filterView.frame.origin.x + subfilterImageView.frame.origin.x + 5, filterView.frame.origin.y + filterImageView.frame.size.height+10) size:CGSizeMake(150, 250) isMultiple:NO rowHeight:44];
        dropSecondobj.delegate = self;
        dropSecondobj.tag = [sender tag];
        [dropSecondobj showInView:self.view animated:YES];
        
        /*----------------Set DropDown backGroundColor-----------------*/
        [dropSecondobj SetBackGroundDropDown_R:255.0 G:255.0 B:255.0 alpha:1.0];//
    }
}



- (void)memberAllSelect:(id)sender{
    
    NSLog(@"memberAllSelect");
    
    BOOL allSelected = YES;
    
    for(int i = 0; i < [deptContactList count]; i++){
        
    if([deptContactList[i][key] isEqualToString:@"0"])
    {
        allSelected = NO;
        
        
        
    }
    }
    
    
    if(allSelected){
        // 현재 다 선택되어있는데 전체선택을 누름
        
        //        memberAllSelectButton.titleLabel.textColor = [UIColor whiteColor];
//        memberAllSelectButton.titleLabel.textColor = RGB(91, 103, 114);
        [memberAllSelectButton setTitleColor:RGB(91, 103, 114) forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
        [memberAllSelectButton setTitle:@"전체 선택" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
        memberAllSelectButton.backgroundColor = [UIColor whiteColor];//RGB(237,236,237);
        for(int i = 0; i < [deptContactList count]; i++){
            NSString *contactuid = deptContactList[i][@"uniqueid"];
            
            for(int j = 0; j < [addArray count]; j++){
                NSString *checkUid = addArray[j][@"uniqueid"];
                if([contactuid isEqualToString:checkUid])
                    [addArray removeObjectAtIndex:j];
            }
            
            NSDictionary *newDic = [SharedFunctions fromOldToNew:deptContactList[i] object:@"0" key:key];
            [deptContactList replaceObjectAtIndex:i withObject:newDic];
          
        
        }
    }
    else{
        // 현재 다 선택되어있지 않는데 전체선택을 누름
        
        //        memberAllSelectButton.titleLabel.textColor = [UIColor blackColor];
        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
//        memberAllSelectButton.titleLabel.textColor = [UIColor whiteColor];
        [memberAllSelectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
        [memberAllSelectButton setTitle:@"해제" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
        memberAllSelectButton.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        for(int i = 0; i < [deptContactList count]; i++){
            NSString *contactuid = deptContactList[i][@"uniqueid"];
        
        NSDictionary *newDic = [SharedFunctions fromOldToNew:deptContactList[i] object:@"1" key:key];
        [deptContactList replaceObjectAtIndex:i withObject:newDic];
        //                NSLog(@"addRestList got it");
            BOOL existAddArray = NO;
            for(int j = 0; j < [addArray count]; j++){
                NSString *checkUid = addArray[j][@"uniqueid"];
                if([contactuid isEqualToString:checkUid])
                    existAddArray = YES;
            }
        
            if(existAddArray == NO)
        [addArray addObject:deptContactList[i]];
        
    }
    }
    
    [self reloadCheck];
}
#define kSelectedMember 6
#define kFavoriteMember 7
- (void)viewMember:(id)sender{
    
    if(viewTag == kFavorite){
        
            if([addArray count]==0)
                return;
            
            
            EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:addArray from:kFavoriteMember];
            
            [controller setDelegate:self selector:@selector(confirmArray:)];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
            [self presentViewController:nc animated:YES completion:nil];
       
        
        

    }
    else{
//    NSLog(@"addArray %@",addArray);
    if([addArray count]==0)
        return;
    
    
//    NSLog(@"addArray %@",addArray);
    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:addArray from:kSelectedMember];
    [controller setDelegate:self selector:@selector(confirmArray:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
    }
}



- (void)confirmArray:(NSMutableArray *)list{
    
    NSLog(@"list %d",(int)[list count]);
    NSLog(@"list %@",list);
    if(viewTag == kFavorite){
        
        [addArray removeAllObjects];
        
        for(NSDictionary *dic in list){
            NSString *favorite = dic[key];
            if([favorite isEqualToString:@"1"])
                [addArray addObject:dic];
        }
        
        
//        BOOL allSelected = YES;
        NSLog(@"selectMode %d",selectMode);
        for(int i = 0; i < [list count]; i++)
        {
            
            if(selectMode == kAllSelect){
                if(searching && [copyList count]>0){
                    for(int j = 0; j < [copyList count]; j++){
                        
                        
                        if([list[i][@"uniqueid"] isEqualToString:copyList[j][@"uniqueid"]])
                        {
                            [copyList replaceObjectAtIndex:j withObject:list[i]];
                            
                        }
                    }
                }
                else{
                    if([favList count]>0)
                    {
                        for(int j = 0; j < [favList count]; j++){
                            //                    NSString *chkUid = favList[j][@"uniqueid"];
                            if([list[i][@"uniqueid"] isEqualToString:favList[j][@"uniqueid"]])
                            {
                                [favList replaceObjectAtIndex:j withObject:list[i]];
                                
                            }
                        }
                    }
                    if([deptList count]>0)
                    {
                        for(int j = 0; j < [deptList count]; j++){
                            //                    NSString *chkUid = deptList[j][@"uniqueid"];
                            if([list[i][@"uniqueid"] isEqualToString:deptList[j][@"uniqueid"]])
                            {
                                [deptList replaceObjectAtIndex:j withObject:list[i]];
                                
                            }
                        }
                    }
                    if([addRestList count]>0){
                        
                        for(int j = 0; j < [addRestList count]; j++){
                            //                    NSString *chkUid = addRestList[j][@"uniqueid"];
                            if([list[i][@"uniqueid"] isEqualToString:addRestList[j][@"uniqueid"]])
                            {
                                [addRestList replaceObjectAtIndex:j withObject:list[i]];
                                
                            }
                        }
                    }
                    
                }
            }
            else{
                
                if([deptContactList count]>0)
                {
                    for(int j = 0; j < [deptContactList count]; j++){
                        //                    NSString *chkUid = favList[j][@"uniqueid"];
                        if([list[i][@"uniqueid"] isEqualToString:deptContactList[j][@"uniqueid"]])
                        {
                            [deptContactList replaceObjectAtIndex:j withObject:list[i]];
                            
                        }
                    }
                }
            }
        }
        
        
        
        
        
        [self reloadCheck];
        

        
        
    }
    else{
    NSLog(@"confirmArray %@",list);
    
    
        
    [addArray removeAllObjects];
    
    for(NSDictionary *dic in list){
        NSString *newfield2 = dic[key];
        if([newfield2 isEqualToString:@"1"])
            [addArray addObject:dic];
    }
        
    
    
    BOOL allSelected = YES;
    for(int i = 0; i < [list count]; i++)
    {
        
        if(selectMode == kAllSelect){
        if(searching && [copyList count]>0){
            for(int j = 0; j < [copyList count]; j++){
                
                
                if([list[i][@"uniqueid"] isEqualToString:copyList[j][@"uniqueid"]])
                {
                    [copyList replaceObjectAtIndex:j withObject:list[i]];
                    
                }
            }
        }
        else{
            if([favList count]>0)
            {
                for(int j = 0; j < [favList count]; j++){
//                    NSString *chkUid = favList[j][@"uniqueid"];
                    if([list[i][@"uniqueid"] isEqualToString:favList[j][@"uniqueid"]])
                    {
                        [favList replaceObjectAtIndex:j withObject:list[i]];
                        
                    }
                }
            }
            if([deptList count]>0)
            {
                for(int j = 0; j < [deptList count]; j++){
//                    NSString *chkUid = deptList[j][@"uniqueid"];
                    if([list[i][@"uniqueid"] isEqualToString:deptList[j][@"uniqueid"]])
                    {
                        [deptList replaceObjectAtIndex:j withObject:list[i]];
                        
                    }
                }
            }
            if([addRestList count]>0){
                
                for(int j = 0; j < [addRestList count]; j++){
//                    NSString *chkUid = addRestList[j][@"uniqueid"];
                    if([list[i][@"uniqueid"] isEqualToString:addRestList[j][@"uniqueid"]])
                    {
                        [addRestList replaceObjectAtIndex:j withObject:list[i]];
                        
                    }
                }
            }
            
        }
        }
        else{
            
            if([deptContactList count]>0)
            {
                for(int j = 0; j < [deptContactList count]; j++){
                    //                    NSString *chkUid = favList[j][@"uniqueid"];
                    if([list[i][@"uniqueid"] isEqualToString:deptContactList[j][@"uniqueid"]])
                    {
                        [deptContactList replaceObjectAtIndex:j withObject:list[i]];
                        
                    }
                }
            }
        }
    }
    
    
    if(selectMode == kDeptSelect){
    for(NSDictionary *dic in deptContactList){
        if([dic[key] isEqualToString:@"0"])
        {
            allSelected = NO;
            
        }
    }
    
        if(allSelected){
            NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        [memberAllSelectButton setTitle:@"해제" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
        memberAllSelectButton.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        [memberAllSelectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//        memberAllSelectButton.titleLabel.textColor = [UIColor whiteColor];
        
        
        
    }
    else{
        [memberAllSelectButton setTitle:@"전체 선택" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
        memberAllSelectButton.backgroundColor = [UIColor whiteColor];//RGB(237,236,237);
        [memberAllSelectButton setTitleColor:RGB(91, 103, 114) forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//        memberAllSelectButton.titleLabel.textColor = RGB(91, 103, 114);
    }
    }
    
    
    
    
    [self reloadCheck];
    
    
    
}

}
- (void)viewAllList{
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    if(dropFirstobj){
        [dropFirstobj removeFromSuperview];
        dropFirstobj = nil;
    }
    if(dropSecondobj){
        [dropSecondobj removeFromSuperview];
        dropSecondobj = nil;
    }
    
//    rightButton.backgroundColor = [UIColor clearColor];
//    leftButton.backgroundColor = [UIColor whiteColor];
    [rightButton setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
    [leftButton setTitleColor:[NSKeyedUnarchiver unarchiveObjectWithData:colorData] forState:UIControlStateNormal];
    
    rightImage.hidden = YES;
    leftImage.hidden = NO;
    
    for(int i = 0; i < [favList count]; i++)
    {
        
        NSDictionary *newDic = [SharedFunctions fromOldToNew:favList[i] object:@"0" key:key];
        [favList replaceObjectAtIndex:i withObject:newDic];
        
    }
    
    
    for(int i = 0; i < [deptList count]; i++)
    {
        
        NSDictionary *newDic = [SharedFunctions fromOldToNew:deptList[i] object:@"0" key:key];
        [deptList replaceObjectAtIndex:i withObject:newDic];
        
    }
    
    
    for(int i = 0; i < [addRestList count]; i++)
    {
        
        NSDictionary *newDic = [SharedFunctions fromOldToNew:addRestList[i] object:@"0" key:key];
        [addRestList replaceObjectAtIndex:i withObject:newDic];
        
    }
    
    [addArray removeAllObjects];
    
    
    [memberAllSelectButton setTitle:@"전체 선택" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    memberAllSelectButton.backgroundColor = [UIColor whiteColor];//RGB(237,236,237);
    [memberAllSelectButton setTitleColor:RGB(91, 103, 114) forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//    memberAllSelectButton.titleLabel.textColor = RGB(91, 103, 114);
    
    [self reloadCheck];
    
    searchView.hidden = NO;
    filterView.hidden = YES;
    myTable.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), 320, self.view.frame.size.height - CGRectGetMaxY(searchView.frame));
    
    selectMode = kAllSelect;
    
    
    
#ifdef BearTalk
    
    
    
    if(viewTag == kFavorite){
        NSLog(@"favlist count %d",(int)[addArray count]);
        if([addArray count]>0){
            memberView.frame = CGRectMake(0, self.view.frame.size.height - 56, self.view.frame.size.width, 56);
            memberView.hidden = NO;
            NSString *memberCount = [NSString stringWithFormat:@"즐겨찾기 멤버 %d",(int)[addArray count]];
            [viewMemberButton setTitle:memberCount forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            viewMemberButton.frame = CGRectMake(16,9, memberView.frame.size.width-32, memberView.frame.size.height-17);
            doneButton.frame = CGRectMake(16,0, memberView.frame.size.width-32, 0);
            
        }
        else{
            
            memberView.frame = CGRectMake(0, self.view.frame.size.height - 56, self.view.frame.size.width, 0);
            memberView.hidden = YES;
            [viewMemberButton setTitle:@"" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            viewMemberButton.frame = CGRectMake(16,9, memberView.frame.size.width-32, memberView.frame.size.height-17);
            doneButton.frame = CGRectMake(16,0, memberView.frame.size.width-32, 0);
        }
        
        
    }
    else{
        if([addArray count]>0){
            memberView.hidden = NO;
            memberView.frame = CGRectMake(0, self.view.frame.size.height - 56, self.view.frame.size.width, 56);
            NSString *memberCount = [NSString stringWithFormat:@"선택된 멤버 %d",(int)[addArray count]];
            
            [viewMemberButton setTitle:memberCount forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            NSLog(@"addArray count7 %d",(int)[addArray count]);
            viewMemberButton.frame = CGRectMake(16,9, memberView.frame.size.width/2, memberView.frame.size.height-17);
            doneButton.frame = CGRectMake(CGRectGetMaxX(viewMemberButton.frame)+8, 9, memberView.frame.size.width - 16 - (CGRectGetMaxX(viewMemberButton.frame)+8),viewMemberButton.frame.size.height);
            
            
        }
        else{
            
            memberView.hidden = YES;
            memberView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
            
        }
        
    }
    myTable.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(searchView.frame) - memberView.frame.size.height);
    myTable.contentOffset = CGPointMake(myTable.contentOffset.x, 0);
    
#endif
    
    [myTable reloadData];
}
- (void)viewDeptContactList{
    NSLog(@"viewDeptContactList");
    selectMode = kDeptSelect;
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    
    if(dropFirstobj){
        [dropFirstobj removeFromSuperview];
        dropFirstobj = nil;
    }
    if(dropSecondobj){
        [dropSecondobj removeFromSuperview];
        dropSecondobj = nil;
    }
    
//    leftButton.backgroundColor = [UIColor clearColor];
//    rightButton.backgroundColor = [UIColor whiteColor];
    [leftButton setTitleColor:RGB(51,51,51) forState:UIControlStateNormal];
    [rightButton setTitleColor:[NSKeyedUnarchiver unarchiveObjectWithData:colorData] forState:UIControlStateNormal];

    
    leftImage.hidden = YES;
    rightImage.hidden = NO;
    for(int i = 0; i < [deptContactList count]; i++)
    {
        
        NSDictionary *newDic = [SharedFunctions fromOldToNew:deptContactList[i] object:@"0" key:key];
        [deptContactList replaceObjectAtIndex:i withObject:newDic];
        
    }
    [addArray removeAllObjects];
    
    [memberAllSelectButton setTitle:@"전체 선택" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    memberAllSelectButton.backgroundColor = [UIColor whiteColor];//RGB(237,236,237);
    [memberAllSelectButton setTitleColor:RGB(91, 103, 114) forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//    memberAllSelectButton.titleLabel.textColor = RGB(91, 103, 114);
    
    [self reloadCheck];
    
    myTable.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), 320, self.view.frame.size.height - CGRectGetMaxY(searchView.frame));
    
    [self searchBarCancelButtonClicked:search];
    
    [myTable reloadData];
    
    
    if(viewTag == kFavorite){
        NSLog(@"favlist count %d",(int)[addArray count]);
        if([addArray count]>0){
            doneButton.hidden = YES;
            memberView.frame = CGRectMake(0, self.view.frame.size.height  - 56, self.view.frame.size.width, 56);
            memberView.hidden = NO;
            NSString *memberCount = [NSString stringWithFormat:@"즐겨찾기 멤버 %d",(int)[addArray count]];
            [viewMemberButton setTitle:memberCount forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            viewMemberButton.frame = CGRectMake(16,9, memberView.frame.size.width-32, memberView.frame.size.height-17);
        }
        else{
            
            doneButton.hidden = YES;
            memberView.frame = CGRectMake(0, self.view.frame.size.height  - 56, self.view.frame.size.width, 0);
            memberView.hidden = YES;
            [viewMemberButton setTitle:@"" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            viewMemberButton.frame = CGRectMake(16,9, memberView.frame.size.width-32, memberView.frame.size.height-17);
        }
        myTable.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), 320, self.view.frame.size.height - CGRectGetMaxY(searchView.frame) - memberView.frame.size.height );
    }
    myTable.contentOffset = CGPointMake(myTable.contentOffset.x, 0);
    
    searchView.hidden = YES;
    filterView.hidden = NO;
}
- (void)selectDept{

    
    SelectDeptViewController *selectDeptController = [[SelectDeptViewController alloc] initWithTag:(int)viewTag];
	selectDeptController.rootTitle = self.title;
    selectDeptController.selectedDeptList = [NSMutableArray array];
    [selectDeptController setDelegate:self selector:@selector(selectArray:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:selectDeptController];
    [self presentViewController:nc animated:YES completion:nil];
//    [selectDeptController release];
//    [nc release];
}


- (void)selectArray:(NSArray *)list
{
    NSLog(@"selectArray %@",list);
    NSMutableArray *selectMembers = [NSMutableArray array];
    for (NSDictionary *dic in [[ResourceLoader sharedInstance].contactList copy]) {
        if (![dic[@"uniqueid"] isEqualToString:[ResourceLoader sharedInstance].myUID] && [list containsObject:dic[@"deptcode"]]) {
            [selectMembers addObject:dic];
        }
    }
    NSLog(@"selectMembers %@",selectMembers);
    NSLog(@"alreadyArray %@",alreadyArray);
    
    if ([selectMembers count] > 0) {
        
        for(int i = 0; i < [selectMembers count]; i++)
        {
//            NSDictionary *aDic = selectMembers[i];
//            NSString *aUid = selectMembers[i][@"uniqueid"];
            int catch = 1;
            
            for(int j = 0; j < [alreadyArray count];j++)
            {
//                NSString *chkUid = alreadyArray[j][@"uniqueid"];
                if([selectMembers[i][@"uniqueid"] isEqualToString:alreadyArray[j][@"uniqueid"]])
                    catch = 2;
            }
            NSDictionary *newDic = [SharedFunctions fromOldToNew:selectMembers[i] object:[NSString stringWithFormat:@"%d",catch] key:key];
            [selectMembers replaceObjectAtIndex:i withObject:newDic];
        }
        
        for(int i = 0; i < [selectMembers count]; i++){
            NSString *newfield2 = selectMembers[i][key];
            if([newfield2 isEqualToString:@"2"])
                [selectMembers removeObjectAtIndex:i];
        }
        
        for(NSDictionary *dic in selectMembers){
            //            if(![dic[key]isEqualToString:@"2"])
            [self checkAdd:dic[@"uniqueid"]];
        }
        
        NSLog(@"addArray %d",(int)[addArray count]);
        NSLog(@"selectMembers %d",(int)[selectMembers count]);
        [addArray addObjectsFromArray:selectMembers];
        NSArray *newArray = [[NSOrderedSet orderedSetWithArray:addArray] array];
        NSLog(@"newArray %d",(int)[newArray count]);
        [addArray setArray:newArray];
//        NSLog(@"addArray %@",addArray);
        
        [self reloadCheck];
        
        
    } else {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"선택한 부서에 포함된 직원이 없습니다!" con:self];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
#ifdef Batong
    
    if(selectMode == kAllSelect)
        return 28;
    else
        return 0;
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] == 60)
        return 28;
    
    if(searching)
        return 28;
    else
    return 0;
#elif BearTalk
    if(selectMode == kAllSelect)
        return 7+12+7;
    else
        return 0;
#endif
    if(selectMode == kAllSelect)
    return 28;
    else
    return 0;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *viewHeader = [UIView.alloc initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    viewHeader.backgroundColor = RGB(249, 249, 249);
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(6, 0, 320-12, 28)];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:13]];
    [lblTitle setTextColor:[UIColor blackColor]];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    NSString *headerTitle = @"";
    
    if(searching)
        headerTitle = [NSString stringWithFormat:@"검색결과 %d",(int)[copyList count]];
    else{
#ifdef Batong
        if(section == 0){
            //        if([deptList count]>0)
            
            NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
            headerTitle = [NSString stringWithFormat:@"내 부서: %@ %d",mydic[@"team"],(int)[deptList count]];
            //            return [SharedAppDelegate readPlist:@"myinfo"][@"deptname"];
            //        else if(addRest)
            //            return @"모든 직원";
        }
        else if(section == 1)
        {
            headerTitle = [NSString stringWithFormat:@"모든 직원 %d",(int)[addRestList count]];
            
            //        if(addRest)
            //            return @"모든 직원";
            
        }
        else
            headerTitle = @"";
        

#elif defined(GreenTalk) || defined(GreenTalkCustomer)
        if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] == 60){
        if(section == 0)
              headerTitle = [NSString stringWithFormat:@"내 가맹점 %d",(int)[deptList count]];
        else
     headerTitle = [NSString stringWithFormat:@"가맹점주 %d",(int)[addRestList count]];
        }
        else{
            headerTitle = @"";
        }
#elif BearTalk
        if(viewTag == kFavorite){
            if(section == 0){
                //        if([deptList count]>0)
                
                NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
                headerTitle = [NSString stringWithFormat:@"내 부서: %@ %d",mydic[@"team"],(int)[deptList count]];
                //            return [SharedAppDelegate readPlist:@"myinfo"][@"deptname"];
                //        else if(addRest)
                //            return @"모든 직원";
            }
            else if(section == 1)
            {
                headerTitle = [NSString stringWithFormat:@"모든 직원 %d",(int)[addRestList count]];
                
                //        if(addRest)
                //            return @"모든 직원";
                
            }
            else
                headerTitle = @"";
        }
        else{
            if(section == 0){
                
                headerTitle = [NSString stringWithFormat:@"즐겨찾기 %d",(int)[favList count]];
            }
            else if(section == 1){
                //        if([deptList count]>0)
                
                NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
                headerTitle = [NSString stringWithFormat:@"내 부서: %@ %d",mydic[@"team"],(int)[deptList count]];
                //            return [SharedAppDelegate readPlist:@"myinfo"][@"deptname"];
                //        else if(addRest)
                //            return @"모든 직원";
            }
            else if(section == 2)
            {
                headerTitle = [NSString stringWithFormat:@"모든 직원 %d",(int)[addRestList count]];
                
                //        if(addRest)
                //            return @"모든 직원";
                
            }
            else
                headerTitle = @"";
        }
#else
        if(section == 0){
            
            headerTitle = [NSString stringWithFormat:@"즐겨찾기 %d",(int)[favList count]];
        }
        else if(section == 1){
            //        if([deptList count]>0)
            
            NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
            headerTitle = [NSString stringWithFormat:@"내 부서: %@ %d",mydic[@"team"],(int)[deptList count]];
            //            return [SharedAppDelegate readPlist:@"myinfo"][@"deptname"];
            //        else if(addRest)
            //            return @"모든 직원";
        }
        else if(section == 2)
        {
            headerTitle = [NSString stringWithFormat:@"모든 직원 %d",(int)[addRestList count]];
            
            //        if(addRest)
            //            return @"모든 직원";
            
        }
        else
            headerTitle = @"";
        
#endif
        
    }
    
#ifdef BearTalk
    viewHeader.frame = CGRectMake(0, 0, myTable.frame.size.width, 7+12+7);
    viewHeader.backgroundColor = RGB(238, 242, 245);
    lblTitle.frame = CGRectMake(16, 7, 100, 12);
    lblTitle.font = [UIFont systemFontOfSize:11];
    lblTitle.textColor = RGB(132, 146, 160);
#endif
    
    lblTitle.text = headerTitle;
    
    [viewHeader addSubview:lblTitle];
    return viewHeader;
}


#define kExit 3

- (void)exitView
{
    
//    NSLog(@"addArray %@",addArray);
    if(viewTag != kFavorite && [addArray count]>0){
        
        
//        UIAlertView *alert;
        NSString *msg = @"이전 화면 이동 시, 선택 된 항목들이 모두 초기화 됩니다. 이동하시겠습니까?";
//        alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:@"이동", nil];
//        alert.tag = kExit;
//        [alert show];
//        [alert release];
        
        [CustomUIKit popupAlertViewOK:nil msg:msg delegate:self tag:kExit sel:@selector(confirmExitView) with:nil csel:nil with:nil];
    }
    else{
        [self confirmExitView];
    }
}

- (void)confirmExitView{
    
    
    NSLog(@"exitView");
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
    }
}

- (void)closeView
{
    //    for(NSDictionary *dic in alreadyArray)
    //        [addArray addObject:dic];
    //    [target performSelector:selector withObject:scrollView];
    NSLog(@"target %@",target);
    
    //    if([target isKindOfClass:[SharedAppDelegate.root.callManager class]]){
    //        if([addArray count]>1){
    //
    //            [CustomUIKit popupAlertViewOK:nil msg:@"1명만 선택할 수 있습니다."];
    //            return;
    //        }
    //    }
    
//    NSLog(@"addArray %@",addArray);
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    
    if([addArray count]<1) {
        if(viewTag != kNewGroup){
            [CustomUIKit popupSimpleAlertViewOK:nil msg:NSLocalizedString(@"there_is_no_selected_room", @"there_is_no_selected_room") con:self];
            return;
        }
        
    }
#else
    if([addArray count]<1) {
        if(viewTag == kNewGroup)
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"소셜에 초대할 멤버를 선택하지 않으셨습니다. 최소 1명 이상의 멤버를 초대하셔야 새로운 소셜을 만드실 수 있습니다." con:self];
        //      else if(viewTag == kModifyGroup)
        //          [CustomUIKit popupAlertViewOK:nil msg:@"그룹에 초대할 멤버를 선택하지 않으셧습니다. 최소 1명 이상의 멤버를 초대하셔야 새로운 소셜을 만드실 수 있습니다."];
        else
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"1명 이상 추가하셔야 합니다." con:self];
        
        return;
    }
    
#endif
//    NSLog(@"addArray + alreadyArray %@",addArray);
    if([target isKindOfClass:[MemberViewController class]]){
        [self checkArray:addArray];
        return;
    }
    
    else if([target isKindOfClass:[ChatViewC class]]){
        if (self.presentingViewController) {
            [target performSelector:selector withObject:addArray];
            [self dismissViewControllerAnimated:YES completion:nil];
            //        [self dismissViewControllerAnimated:NO completion:^(void){
            //        }];
        } else {
            [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:NO];
            [target performSelector:selector withObject:addArray];
        }
        return;
    }
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:NO completion:^(void){
            [target performSelector:selector withObject:addArray];
        }];
    } else {
        [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:NO];
        [target performSelector:selector withObject:addArray];
    }
    
}


#define kAlertAdd 1
#define kAlertCall 2

- (void)checkArray:(NSArray *)list
{
    NSString *names = @"";
    
//    NSLog(@"addArray %@",addArray);
    if ([addArray count] == 1) {
        names = [NSString stringWithString:addArray[0][@"name"]];
    } else if ([addArray count] == 2) {
        names = [NSString stringWithFormat:@"%@, %@",addArray[0][@"name"],addArray[1][@"name"]];
    } else {
        names = [NSString stringWithFormat:@"%@, %@ 외 %d명",addArray[0][@"name"],addArray[1][@"name"],(int)[addArray count]-2];
    }
    
//    UIAlertView *alert;
    NSString *msg = [NSString stringWithFormat:@"%@ 멤버를 추가하시겠습니까?",names];
//    alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//    alert.tag = kAlertAdd;
//    [alert show];
//    [alert release];
    
    [CustomUIKit popupAlertViewOK:@"멤버초대" msg:msg delegate:self tag:kAlertAdd sel:@selector(confirmAdd) with:nil csel:nil with:nil];
}

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{
    
    self.target = aTarget;
    self.selector = aSelector;
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
    NSLog(@"scrollViewWillBeginDragging");
    if([search isFirstResponder])
    {
        //            [self settingDisableViewOverlay:2];
        [search resignFirstResponder];
        [self reloadCheck];
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    //    dragging = NO;
    [myTable reloadData];
}      // called when scroll view grinds to a halt



- (void)addSelectSection:(int)section row:(int)rowOfButton
{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 선택한 사람의 favorite이 0이면 1로 교체하고 DB에도 추가할 준비를 하기 위해 addArray에 추가한다. 1이면 0으료 교체하고 addArray에서 삭제한다.
     param - sender(id) : tag를 넘겨 몇 번째 사람인지 알 수 있게 한다.
     연관화면 : 즐겨찾기 추가
     ****************************************************************/
    
    
    NSLog(@"addSelectselection %d row %d",section,rowOfButton);
    
    NSDictionary *dic = nil;

    
    if(selectMode == kAllSelect){
    if(searching)
    {
        dic = copyList[rowOfButton];
        
        
        [search resignFirstResponder];
        [self reloadCheck];
        
    }
    else
    {
#ifdef Batong
        
        if(section == 0){
            dic = deptList[rowOfButton];
            
        }
        else if(section == 1){
            dic = addRestList[rowOfButton];
            
            
        }
        
        
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
        if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] == 60){
            if(section == 0){
                dic = deptList[rowOfButton];
                
            }
            else if(section == 1){
                dic = addRestList[rowOfButton];
                
                
            }
        }
        else{
        dic = addRestList[rowOfButton];
        }
#else
        if(section == 0){
            
            dic = favList[rowOfButton];
            
            
        }
        else if(section == 1){
            dic = deptList[rowOfButton];
            
        }
        else if(section == 2){
            dic = addRestList[rowOfButton];
            
            
        }
        
#endif
        
        
    }
    }
    else{
        dic = deptContactList[rowOfButton];
        
    }
    
    NSLog(@"dic %@",dic);
    
    if([dic[key]isEqualToString:@"2"])
        return;
    
    
    
    NSString *uid = dic[@"uniqueid"];
    NSLog(@"uid %@",uid);
    
    if([dic[key] isEqualToString:@"0"])
    {
        NSDictionary *catchDic;
        
        if(selectMode == kAllSelect){
        for(int j = 0; j<[copyList count];j++)
        {
            
//            NSDictionary *aDic = copyList[j];
//            NSString *aUid = copyList[j][@"uniqueid"];
            if([uid isEqualToString:copyList[j][@"uniqueid"]])
            {
                NSDictionary *newDic = [SharedFunctions fromOldToNew:copyList[j] object:@"1" key:key];
                [copyList replaceObjectAtIndex:j withObject:newDic];
                NSLog(@"copyList got it");
                catchDic = copyList[j];
            }
            
            
        }
        
        for(int j = 0; j<[favList count];j++)
        {
//            NSDictionary *aDic = favList[j];
//            NSString *aUid = favList[j][@"uniqueid"];
            if([uid isEqualToString:favList[j][@"uniqueid"]])
            {
                NSDictionary *newDic = [SharedFunctions fromOldToNew:favList[j] object:@"1" key:key];
                [favList replaceObjectAtIndex:j withObject:newDic];
                NSLog(@"favList got it");
                catchDic = favList[j];
            }
            
            
        }
        for(int j = 0; j<[deptList count];j++)
        {
            
//            NSDictionary *aDic = ;
//            NSString *aUid = deptList[j][@"uniqueid"];
            if([uid isEqualToString:deptList[j][@"uniqueid"]])
            {
                NSDictionary *newDic = [SharedFunctions fromOldToNew:deptList[j] object:@"1" key:key];
                [deptList replaceObjectAtIndex:j withObject:newDic];
                NSLog(@"deptList got it");
                catchDic = deptList[j];
            }
            
            
        }
        for(int j = 0; j<[addRestList count];j++)
        {
            
//            NSDictionary *aDic = addRestList[j];
//            NSString *aUid = addRestList[j][@"uniqueid"];
            if([uid isEqualToString:addRestList[j][@"uniqueid"]])
            {
                NSDictionary *newDic = [SharedFunctions fromOldToNew:addRestList[j] object:@"1" key:key];
                [addRestList replaceObjectAtIndex:j withObject:newDic];
//                NSLog(@"addRestList got it");
                catchDic = addRestList[j];
            
            }
            
            
        }
        }
        else{
            
            for(int j = 0; j<[deptContactList count];j++)
            {
                
                //            NSDictionary *aDic = addRestList[j];
                //            NSString *aUid = addRestList[j][@"uniqueid"];
                if([uid isEqualToString:deptContactList[j][@"uniqueid"]])
                {
                    NSDictionary *newDic = [SharedFunctions fromOldToNew:deptContactList[j] object:@"1" key:key];
                    [deptContactList replaceObjectAtIndex:j withObject:newDic];
                    //                NSLog(@"addRestList got it");
                    catchDic = deptContactList[j];
                    
                }
                
                
            }
        }
        if(catchDic != nil)
        [addArray addObject:catchDic];
        
        
        
        
        BOOL allSelected = YES;
        for(NSDictionary *dic in deptContactList){
            if([dic[key] isEqualToString:@"0"])
            {
                allSelected = NO;
                
            }
        }
        
        if(allSelected){
            
            NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
            [memberAllSelectButton setTitle:@"해제" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            memberAllSelectButton.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
            [memberAllSelectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//            memberAllSelectButton.titleLabel.textColor = [UIColor whiteColor];
            
            
        }
        else{
            [memberAllSelectButton setTitle:@"전체 선택" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            memberAllSelectButton.backgroundColor = [UIColor whiteColor];//RGB(237,236,237);
            [memberAllSelectButton setTitleColor:RGB(91, 103, 114) forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//            memberAllSelectButton.titleLabel.textColor = RGB(91, 103, 114);
            
        }
    }
    else
    {
        [memberAllSelectButton setTitle:@"전체 선택" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
        memberAllSelectButton.backgroundColor = [UIColor whiteColor];//RGB(237,236,237);
//        memberAllSelectButton.titleLabel.textColor = RGB(91, 103, 114);
        [memberAllSelectButton setTitleColor:RGB(91, 103, 114) forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
        
//        NSLog(@"addArray %@",addArray);
        for(int i = 0; i < [addArray count]; i++){
            NSString *checkUid = addArray[i][@"uniqueid"];
            if([uid isEqualToString:checkUid]){
                
                [addArray removeObjectAtIndex:i];

            }
        }
        
//        NSLog(@"addArray %@",addArray);
        [self checkDelete:uid];
    }
    
    
    
    if (self.multiSelect == NO) {
        return;
    }
    [self reloadCheck];
    
}


- (void)setRestList{
    NSLog(@"setRestList");
    
    
    //    [addRestList setArray:[SharedAppDelegate.root addRestList]];
    
#ifdef Batong
    [addRestList setArray:[[ResourceLoader sharedInstance] allContactList]];
    
#elif  defined(GreenTalk) || defined(GreenTalkCustomer)
    
    
    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue]<70)
        [addRestList setArray:[[ResourceLoader sharedInstance] myDeptList]];
    else
        [addRestList setArray:[[ResourceLoader sharedInstance] allContactList]];
    
    
    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] == 60){
        
        [addRestList removeAllObjects];
        NSString *mydeptcode = [SharedAppDelegate readPlist:@"myinfo"][@"deptcode"];
        for(NSDictionary *dic in myList){
            
            NSString *deptcode = dic[@"deptcode"];
            NSString *uniqueid = dic[@"uniqueid"];
            if([deptcode isEqualToString:mydeptcode] && ![uniqueid isEqualToString:[ResourceLoader sharedInstance].myUID])
            {
                
            }
            else{
                [addRestList addObject:dic];
            }
        }
        
    }
#else
    [addRestList setArray:[[ResourceLoader sharedInstance] allContactList]];
    
#endif
    
    for(int i = 0; i < [addRestList count]; i++){
//        NSString *aUid = addRestList[i][@"uniqueid"];
        if([addRestList[i][@"uniqueid"] isEqualToString:[ResourceLoader sharedInstance].myUID])
            [addRestList removeObjectAtIndex:i];
    }
    
    NSLog(@"addRestList count] %d",(int)[addRestList count]);
    for(int i = 0; i < [addRestList count]; i++)
    {
//        NSDictionary *aDic = addRestList[i];
//        NSString *aUid = addRestList[i][@"uniqueid"];
        int catch = 0;
        
        for(int j = 0; j < [alreadyArray count];j++)
        {
//            NSString *chkUid = alreadyArray[j][@"uniqueid"];
            if([addRestList[i][@"uniqueid"] isEqualToString:alreadyArray[j][@"uniqueid"]])
                catch = 2;
        }
        for(int j = 0; j < [addArray count];j++)
        {
//            NSString *chkUid = addArray[j][@"uniqueid"];
            if([addRestList[i][@"uniqueid"] isEqualToString:addArray[j][@"uniqueid"]])
                catch = 1;
        }
        
        NSDictionary *newDic = [SharedFunctions fromOldToNew:addRestList[i] object:[NSString stringWithFormat:@"%d",catch] key:key];
        [addRestList replaceObjectAtIndex:i withObject:newDic];
    }
    
    //    addRest = YES;
    [myTable reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
#ifdef Batong
    NSLog(@"didsel");
    if(dropFirstobj){
        [dropFirstobj removeFromSuperview];
        dropFirstobj = nil;
    }
    if(dropSecondobj){
        [dropSecondobj removeFromSuperview];
        dropSecondobj = nil;
    }
    
    if(selectMode == kAllSelect){
        NSLog(@"1");
        if(!searching){
            NSLog(@"2");
            
            if(indexPath.section == 0 && [deptList count] == 0){
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }
            if(indexPath.section == 1 && [addRestList count] == 0){
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }
        }
        if (self.multiSelect == NO) {
            NSLog(@"3");
            
            BOOL isEnable = YES;
            
            if (searching) {
                if([copyList[indexPath.row][@"available"] isEqualToString:@"0"] || [copyList[indexPath.row][@"available"] isEqualToString:@"4"]) {
                    isEnable = NO;
                }
            } else {
                if(indexPath.section == 0) {
                    if([deptList count] > 0) {
                        if(indexPath.row < [deptList count]) {
                            if([deptList[indexPath.row][@"available"]isEqualToString:@"0"] || [deptList[indexPath.row][@"available"] isEqualToString:@"4"]) {
                                isEnable = NO;
                            }
                        }
                    }
                } else {
                    if(addRest) {
                        if([addRestList[indexPath.row][@"available"]isEqualToString:@"0"] || [addRestList[indexPath.row][@"available"]isEqualToString:@"4"]) {
                            isEnable = NO;
                        }
                    }
                    
                }
            }
            
            
            if (isEnable == YES) {
                //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"무료통화를 하시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
                //            alert.tag = kAlertCall;
                //            [alert show];
                //            [alert release];
                
                [CustomUIKit popupAlertViewOK:@"무료통화" msg:@"무료통화를 하시겠습니까?" delegate:self tag:kAlertCall sel:@selector(confirmCall) with:nil csel:nil with:nil];
            } else {
                [SVProgressHUD showErrorWithStatus:@"무료통화가 불가능한 대상입니다!"];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        } else {
            NSLog(@"4");
            
            if([addArray count] == 99 && viewTag == kNote){
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"100명 이상 선택할 수 없습니다." con:self];
            }
            else
                [self addSelectSection:(int)indexPath.section row:(int)indexPath.row];
        }
    }
    else{
        NSLog(@"5");
        if([deptContactList count]>0){
            NSLog(@"6");
            
            NSDictionary *dic = deptContactList[indexPath.row];
            if (self.multiSelect == NO) {
                
                BOOL isEnable = YES;
                
                
                if([dic[@"available"] isEqualToString:@"0"] || [dic[@"available"] isEqualToString:@"4"]) {
                    isEnable = NO;
                }
                
                
                
                if (isEnable == YES) {
                    
                    [CustomUIKit popupAlertViewOK:@"무료통화" msg:@"무료통화를 하시겠습니까?" delegate:self tag:kAlertCall sel:@selector(confirmCall) with:nil csel:nil with:nil];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"무료통화가 불가능한 대상입니다!"];
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
            } else {
                
                if([addArray count] == 99 && viewTag == kNote){
                    [CustomUIKit popupSimpleAlertViewOK:nil msg:@"100명 이상 선택할 수 없습니다." con:self];
                }
                else
                    [self addSelectSection:(int)indexPath.section row:(int)indexPath.row];
            }
        }
        else{
            NSLog(@"7");
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
    }

#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    
    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] == 60){
        
        if(!searching){
            
            if(indexPath.section == 0 && [deptList count] == 0){
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }
            if(indexPath.section == 1 && [addRestList count] == 0){
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }
        }
        if (self.multiSelect == NO) {
            
            BOOL isEnable = YES;
            
            if (searching) {
                if([copyList[indexPath.row][@"available"] isEqualToString:@"0"] || [copyList[indexPath.row][@"available"] isEqualToString:@"4"]) {
                    isEnable = NO;
                }
            } else {
         
                if(indexPath.section == 0){
                    if([deptList count] > 0) {
                        if(indexPath.row < [deptList count]) {
                            if([deptList[indexPath.row][@"available"]isEqualToString:@"0"] || [deptList[indexPath.row][@"available"] isEqualToString:@"4"]) {
                                isEnable = NO;
                            }
                        }
                    }
                } else {
                    if(addRest) {
                        if([addRestList[indexPath.row][@"available"]isEqualToString:@"0"] || [addRestList[indexPath.row][@"available"]isEqualToString:@"4"]) {
                            isEnable = NO;
                        }
                    }
                    
                }
            }
            
            
            if (isEnable == YES) {
                //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"무료통화를 하시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
                //            alert.tag = kAlertCall;
                //            [alert show];
                //            [alert release];
                
                [CustomUIKit popupAlertViewOK:@"무료통화" msg:@"무료통화를 하시겠습니까?" delegate:self tag:kAlertCall sel:@selector(confirmCall) with:nil csel:nil with:nil];
            } else {
                [SVProgressHUD showErrorWithStatus:@"무료통화가 불가능한 대상입니다!"];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        } else {
            
            if([addArray count] == 99 && viewTag == kNote){
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"100명 이상 선택할 수 없습니다." con:self];
            }
            else
                [self addSelectSection:(int)indexPath.section row:(int)indexPath.row];
        }
        
    }
    else{
        if(!searching){
            
            if(indexPath.section == 0 && [addRestList count] == 0){
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }
        }
        if (self.multiSelect == NO) {
            
            BOOL isEnable = YES;
            
            if (searching) {
                if([copyList[indexPath.row][@"available"] isEqualToString:@"0"] || [copyList[indexPath.row][@"available"] isEqualToString:@"4"]) {
                    isEnable = NO;
                }
            } else {
                if(indexPath.section == 0) {
                
                    
                    
                    if(addRest) {
                        if([addRestList[indexPath.row][@"available"]isEqualToString:@"0"] || [addRestList[indexPath.row][@"available"]isEqualToString:@"4"]) {
                            isEnable = NO;
                        }
                    }

                    
                }
                
            }
            
            
            if (isEnable == YES) {
                //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"무료통화를 하시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
                //            alert.tag = kAlertCall;
                //            [alert show];
                //            [alert release];
                
                [CustomUIKit popupAlertViewOK:@"무료통화" msg:@"무료통화를 하시겠습니까?" delegate:self tag:kAlertCall sel:@selector(confirmCall) with:nil csel:nil with:nil];
            } else {
                [SVProgressHUD showErrorWithStatus:@"무료통화가 불가능한 대상입니다!"];
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        } else {
            
            if([addArray count] == 99 && viewTag == kNote){
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"100명 이상 선택할 수 없습니다." con:self];
            }
            else
                [self addSelectSection:(int)indexPath.section row:(int)indexPath.row];
        }
    }
    
#elif BearTalk
    if(viewTag == kFavorite){
        NSLog(@"didsel");
        if(dropFirstobj){
            [dropFirstobj removeFromSuperview];
            dropFirstobj = nil;
        }
        if(dropSecondobj){
            [dropSecondobj removeFromSuperview];
            dropSecondobj = nil;
        }
        
        if(searching){
            [self addOrClear:copyList[indexPath.row]];
        }
        
        else{
            
        if(selectMode == kAllSelect){
          
            
                if(indexPath.section == 1-1){
                    if([deptList count]>0)
                        [self addOrClear:deptList[indexPath.row]];
                    
                }
                else{
                    if([addRestList count]>0)
                        [self addOrClear:addRestList[indexPath.row]];
                }
            
    
            
        }
        else{
            if([deptContactList count]>0){
                
                
                [self addOrClear:deptContactList[indexPath.row]];
                
            }
            else{
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }
        }
        }

    }
    else{
        NSLog(@"didsel");
        if(dropFirstobj){
            [dropFirstobj removeFromSuperview];
            dropFirstobj = nil;
        }
        if(dropSecondobj){
            [dropSecondobj removeFromSuperview];
            dropSecondobj = nil;
        }
        
        if(selectMode == kAllSelect){
            if(!searching){
                
                if(indexPath.section == 0 && [favList count] == 0){
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    return;
                }
                if(indexPath.section == 1 && [deptList count] == 0){
                    
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    return;
                }
                if(indexPath.section == 2 && [addRestList count] == 0){
                    
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    return;
                }
            }
            if (self.multiSelect == NO) {
                
                BOOL isEnable = YES;
                
                if (searching) {
                    if([copyList[indexPath.row][@"available"] isEqualToString:@"0"] || [copyList[indexPath.row][@"available"] isEqualToString:@"4"]) {
                        isEnable = NO;
                    }
                } else {
                    if(indexPath.section == 0) {
                        if([favList count] > 0) {
                            if([favList[indexPath.row][@"available"] isEqualToString:@"0"] || [favList[indexPath.row][@"available"] isEqualToString:@"4"]) {
                                isEnable = NO;
                            }
                        }
                    } else if(indexPath.section == 1){
                        if([deptList count] > 0) {
                            if(indexPath.row < [deptList count]) {
                                if([deptList[indexPath.row][@"available"]isEqualToString:@"0"] || [deptList[indexPath.row][@"available"] isEqualToString:@"4"]) {
                                    isEnable = NO;
                                }
                            }
                        }
                    } else {
                        if(addRest) {
                            if([addRestList[indexPath.row][@"available"]isEqualToString:@"0"] || [addRestList[indexPath.row][@"available"]isEqualToString:@"4"]) {
                                isEnable = NO;
                            }
                        }
                        
                    }
                }
                
                
                if (isEnable == YES) {
                    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"무료통화를 하시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
                    //            alert.tag = kAlertCall;
                    //            [alert show];
                    //            [alert release];
                    
                    [CustomUIKit popupAlertViewOK:@"무료통화" msg:@"무료통화를 하시겠습니까?" delegate:self tag:kAlertCall sel:@selector(confirmCall) with:nil csel:nil with:nil];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"무료통화가 불가능한 대상입니다!"];
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
            } else {
                
                if([addArray count] == 99 && viewTag == kNote){
                    [CustomUIKit popupSimpleAlertViewOK:nil msg:@"100명 이상 선택할 수 없습니다." con:self];
                }
                else
                    [self addSelectSection:(int)indexPath.section row:(int)indexPath.row];
            }
        }
        else{
            if([deptContactList count]>0){
                
                NSDictionary *dic = deptContactList[indexPath.row];
                if (self.multiSelect == NO) {
                    
                    BOOL isEnable = YES;
                    
                    
                    if([dic[@"available"] isEqualToString:@"0"] || [dic[@"available"] isEqualToString:@"4"]) {
                        isEnable = NO;
                    }
                    
                    
                    
                    if (isEnable == YES) {
                        
                        [CustomUIKit popupAlertViewOK:@"무료통화" msg:@"무료통화를 하시겠습니까?" delegate:self tag:kAlertCall sel:@selector(confirmCall) with:nil csel:nil with:nil];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"무료통화가 불가능한 대상입니다!"];
                        [tableView deselectRowAtIndexPath:indexPath animated:YES];
                    }
                } else {
                    
                    if([addArray count] == 99 && viewTag == kNote){
                        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"100명 이상 선택할 수 없습니다." con:self];
                    }
                    else
                        [self addSelectSection:(int)indexPath.section row:(int)indexPath.row];
                }
            }
            else{
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }
        }

    }
#else
    
    NSLog(@"didsel");
    if(dropFirstobj){
        [dropFirstobj removeFromSuperview];
        dropFirstobj = nil;
    }
    if(dropSecondobj){
        [dropSecondobj removeFromSuperview];
        dropSecondobj = nil;
    }
    
    if(selectMode == kAllSelect){
    if(!searching){
        
    if(indexPath.section == 0 && [favList count] == 0){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if(indexPath.section == 1 && [deptList count] == 0){
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if(indexPath.section == 2 && [addRestList count] == 0){
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    }
    if (self.multiSelect == NO) {
        
        BOOL isEnable = YES;
        
        if (searching) {
            if([copyList[indexPath.row][@"available"] isEqualToString:@"0"] || [copyList[indexPath.row][@"available"] isEqualToString:@"4"]) {
                isEnable = NO;
            }
        } else {
            if(indexPath.section == 0) {
                if([favList count] > 0) {
                    if([favList[indexPath.row][@"available"] isEqualToString:@"0"] || [favList[indexPath.row][@"available"] isEqualToString:@"4"]) {
                        isEnable = NO;
                    }
                }
            } else if(indexPath.section == 1){
                if([deptList count] > 0) {
                    if(indexPath.row < [deptList count]) {
                        if([deptList[indexPath.row][@"available"]isEqualToString:@"0"] || [deptList[indexPath.row][@"available"] isEqualToString:@"4"]) {
                            isEnable = NO;
                        }
                    }
                }
            } else {
                if(addRest) {
                    if([addRestList[indexPath.row][@"available"]isEqualToString:@"0"] || [addRestList[indexPath.row][@"available"]isEqualToString:@"4"]) {
                        isEnable = NO;
                    }
                }
                
            }
        }
        
        
        if (isEnable == YES) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"무료통화를 하시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//            alert.tag = kAlertCall;
//            [alert show];
//            [alert release];
            
            [CustomUIKit popupAlertViewOK:@"무료통화" msg:@"무료통화를 하시겠습니까?" delegate:self tag:kAlertCall sel:@selector(confirmCall) with:nil csel:nil with:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"무료통화가 불가능한 대상입니다!"];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else {
        
        if([addArray count] == 99 && viewTag == kNote){
             [CustomUIKit popupSimpleAlertViewOK:nil msg:@"100명 이상 선택할 수 없습니다." con:self];
        }
        else
        [self addSelectSection:(int)indexPath.section row:(int)indexPath.row];
    }
    }
    else{
        if([deptContactList count]>0){
            
            NSDictionary *dic = deptContactList[indexPath.row];
            if (self.multiSelect == NO) {
                
                BOOL isEnable = YES;
                
                    
                            if([dic[@"available"] isEqualToString:@"0"] || [dic[@"available"] isEqualToString:@"4"]) {
                                isEnable = NO;
                            }
                
                
                
                if (isEnable == YES) {
                    
                    [CustomUIKit popupAlertViewOK:@"무료통화" msg:@"무료통화를 하시겠습니까?" delegate:self tag:kAlertCall sel:@selector(confirmCall) with:nil csel:nil with:nil];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"무료통화가 불가능한 대상입니다!"];
                    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                }
            } else {
                
                if([addArray count] == 99 && viewTag == kNote){
                    [CustomUIKit popupSimpleAlertViewOK:nil msg:@"100명 이상 선택할 수 없습니다." con:self];
                }
                else
                    [self addSelectSection:(int)indexPath.section row:(int)indexPath.row];
            }
        }
        else{
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
    }
#endif
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 화면 닫기, 딜리게이트 호출, 전화 시작
        
        if(alertView.tag == kAlertCall){
          
            [self confirmCall];
        }
        else if(alertView.tag == kAlertAdd){
         
            [self confirmAdd];
//            NSLog(@"addArray %@",addArray);
            
        }
        else if(alertView.tag == kExit){
            [self confirmExitView];
        }
    } else {
        if(alertView.tag == kExit)
            return;
        
        [myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];
    }
    
}
                                                                                                                      
                                                                                                                      - (void)confirmCall{
                                                                                                                          [self addSelectSection:(int)[myTable indexPathForSelectedRow].section row:(int)[myTable indexPathForSelectedRow].row];
                                                                                                                          [self closeView];
                                                                                                                      }


- (void)confirmAdd{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:NO completion:^(void){
            [target performSelector:selector withObject:addArray];
        }];
    } else {
        [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:NO];
        [target performSelector:selector withObject:addArray];
    }
    
}
- (void)reloadCheck{
    NSLog(@"reloadCHeck");
    NSLog(@"addArray count1 %d",(int)[addArray count]);
    NSLog(@"multiSelect %@",self.multiSelect==YES?@"YES":@"NO");
    [myTable reloadData];
    NSLog(@"addArray count2 %d",(int)[addArray count]);
    
    if(self.multiSelect == NO)
        return;
    
    
#ifdef BearTalk
    
    if(viewTag == kFavorite){
        NSLog(@"favlist count %d",(int)[addArray count]);
        if([addArray count]>0){
            memberView.frame = CGRectMake(0, self.view.frame.size.height - 56, self.view.frame.size.width, 56);
            memberView.hidden = NO;
            NSString *memberCount = [NSString stringWithFormat:@"즐겨찾기 멤버 %d",(int)[addArray count]];
            [viewMemberButton setTitle:memberCount forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            viewMemberButton.frame = CGRectMake(16,9, memberView.frame.size.width-32, memberView.frame.size.height-17);
            doneButton.frame = CGRectMake(16,0, memberView.frame.size.width-32, 0);
            
        }
        else{
            
            memberView.frame = CGRectMake(0, self.view.frame.size.height - 56, self.view.frame.size.width, 0);
            memberView.hidden = YES;
            [viewMemberButton setTitle:@"" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
            viewMemberButton.frame = CGRectMake(16,9, memberView.frame.size.width-32, memberView.frame.size.height-17);
            doneButton.frame = CGRectMake(16,0, memberView.frame.size.width-32, 0);
        }
    }
    else{
    
    if([addArray count]>0){
        memberView.hidden = NO;
        memberView.frame = CGRectMake(0, self.view.frame.size.height - 56, self.view.frame.size.width, 56);
        NSString *memberCount = [NSString stringWithFormat:@"선택된 멤버 %d",(int)[addArray count]];
        
        [viewMemberButton setTitle:memberCount forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
        NSLog(@"addArray count7 %d",(int)[addArray count]);
        viewMemberButton.frame = CGRectMake(16,9, memberView.frame.size.width/2, memberView.frame.size.height-17);
        doneButton.frame = CGRectMake(CGRectGetMaxX(viewMemberButton.frame)+8, 9, memberView.frame.size.width - 16 - (CGRectGetMaxX(viewMemberButton.frame)+8),viewMemberButton.frame.size.height);
        
        
    }
    else{
        
        memberView.hidden = YES;
        memberView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
        
    }
    }
#else
    if([addArray count]>0){
        NSLog(@"addArray count3 %d",(int)[addArray count]);
        memberView.hidden = NO;
        memberView.frame = CGRectMake(0, self.view.frame.size.height-45, 320, 45);

        memberCountLabel.text = [NSString stringWithFormat:@"선택된 멤버 %d명",(int)[addArray count]];
    
        searchView.frame = CGRectMake(0,0,320,45);
//        UIButton *viewMemberButton;
        viewMemberButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(viewMember:) frame:CGRectMake(0,0, memberView.frame.size.width, memberView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        [memberView addSubview:viewMemberButton];
        
        memberCountLabel.frame = CGRectMake(5, 0, 120, memberView.frame.size.height);
        detailMember.frame = CGRectMake(320-20,16,7,11);
        viewMemberLabel.frame = CGRectMake(320-5-20-5-100, 0, 100, memberView.frame.size.height);

    }
    else{
        NSLog(@"addarray count 0");
        

        memberView.hidden = YES;
        memberView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
        searchView.frame = CGRectMake(0,CGRectGetMaxY(memberView.frame),320,45);

        
    }
#endif
    
    NSLog(@"memberView %@ %@",memberView,NSStringFromCGRect(memberView.frame));
    NSLog(@"selectmode %d",selectMode);
    
    if(selectMode == kAllSelect){
        searchView.hidden = NO;
        filterView.hidden = YES;
    }
    else{
        searchView.hidden = YES;
        filterView.hidden = NO;
        
        
    }

    
    myTable.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(searchView.frame) - memberView.frame.size.height);

    
    
}




//- (void)addOK
//{
//
////		id AppID = [[UIApplication sharedApplication]delegate];
//	if (viewTag != 3) {
//		for(int i = 0; i < [addArray count]; i++)
//		{
//			[SharedAppDelegate.root updateFavorite:@"1" uniqueid:[[addArrayobjectatindex:i]objectForKey:@"uniqueid"]];
//		}
//
//	}
//
//		[self backTo];
//}


// 뷰가 나타날 때마다 호출
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    
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
    
    NSLog(@"cellforrow");
    static NSString *CellIdentifier = @"Cell";
    
    //		NSString *email;
    UILabel *name, *team, *lblStatus;
    //    UIButton *invite;
    UIImageView *profileView, *disableView;
    UIImageView *checkView, *checkAddView;
    UIButton *allViewButton;
    
    UIImageView *roundingView;
    
    //		id AppID = [[UIApplication sharedApplication]delegate];
    
    CGFloat xPadding = 10.0;
    if (self.multiSelect == YES) {
        
#ifdef BearTalk
        xPadding = 16 + 24 + 10;
#else
        xPadding = 40.0;
  
#endif
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (self.multiSelect == YES) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        profileView = [[UIImageView alloc]initWithFrame:CGRectMake(xPadding,5,40,40)];
        profileView.tag = 1;
        [cell.contentView addSubview:profileView];
//        [profileView release];
        
        name = [[UILabel alloc]init];//WithFrame:CGRectMake(55+xPadding, 5, 115, 20)];
        name.backgroundColor = [UIColor clearColor];
        //        name.font = [UIFont systemFontOfSize:15];
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
        lblStatus.tag = 7;
        [disableView addSubview:lblStatus];
//        [lblStatus release];
        
        roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        [profileView addSubview:roundingView];
        roundingView.tag = 21;
//        [roundingView release];
        

#ifdef BearTalk
        
//        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        checkView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 20, 24, 24)];
        checkView.tag = 5;
        checkView.layer.borderWidth = 1.0;
        checkView.layer.cornerRadius = checkView.frame.size.width/2;
//        checkView.backgroundColor = RGB(249,249,249);
//        checkView.layer.borderColor = [RGB(223, 223, 223)CGColor];
        [cell.contentView addSubview:checkView];
        
        checkAddView = [[UIImageView alloc]init];
        checkAddView.tag = 51;
//        checkAddView.backgroundColor = RGB(251,251,251);
//        checkAddView.image = [UIImage imageNamed:@"select_check_white.png"];
//        checkAddView.backgroundColor = [UIColor clearColor];
        [checkView addSubview:checkAddView];
#else
        checkView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 13, 23, 23)];
        checkView.tag = 5;
        [cell.contentView addSubview:checkView];
#endif
        allViewButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        allViewButton.backgroundColor = RGB(241, 243, 242);
        //        [allViewButton setBackgroundImage:[CustomUIKit customImageNamed:@"allviewlist_btn.png"] forState:UIControlStateNormal];
        [allViewButton addTarget:self action:@selector(setRestList) forControlEvents:UIControlEventTouchUpInside];
        allViewButton.tag = 6;
        [cell.contentView addSubview:allViewButton];
//        [allViewButton release];
        
        
        UILabel *allViewLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        allViewLabel.textAlignment = NSTextAlignmentCenter;
        allViewLabel.textColor = RGB(54, 139, 250);
        allViewLabel.backgroundColor = [UIColor clearColor];
        allViewLabel.font = [UIFont boldSystemFontOfSize:18];
        [allViewButton addSubview:allViewLabel];
        allViewLabel.text = @"모든 직원 보기";
//        [allViewLabel release];
        
#ifdef BearTalk
        profileView.frame = CGRectMake(xPadding, 10, 42, 42);
        disableView.frame = CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height);
        roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
#endif

        
    }
    else{
        profileView = (UIImageView *)[cell viewWithTag:1];
        name = (UILabel *)[cell viewWithTag:2];
        //            position = (UILabel *)[cell viewWithTag:3];
        team = (UILabel *)[cell viewWithTag:3];
        disableView = (UIImageView *)[cell viewWithTag:11];
        lblStatus = (UILabel *)[cell viewWithTag:7];
        checkView = (UIImageView *)[cell viewWithTag:5];
        //        invite = (UIButton *)[cell viewWithTag:4];
        allViewButton = (UIButton *)[cell viewWithTag:6];
        roundingView = (UIImageView *)[cell viewWithTag:21];
#ifdef BearTalk
        checkAddView = (UIImageView *)[cell viewWithTag:51];
#endif
    }
    
    roundingView.hidden = NO;

    if (self.multiSelect == NO) {
        checkView.hidden = YES;
#ifdef BearTalk
        checkAddView.hidden = YES;
#endif
    }
    
    NSDictionary *dic = nil;
    
    if(searching)
    {
        dic = copyList[indexPath.row];
        
    }
    else
    {
    if(selectMode == kAllSelect) {
        NSLog(@"cellforrow %d %d %d %@",(int)[favList count],(int)[deptList count],(int)[addRestList count],addRest?@"YES":@"NO");
        NSLog(@"sect %d row %d",(int)indexPath.section,(int)indexPath.row);
#ifdef Batong
       if(indexPath.section == 0){
            
            
            if([deptList count]>0){
                dic = deptList[indexPath.row];
                
                
                
            }
            else{
                dic = nil;
                allViewButton.hidden = YES;
                disableView.hidden = YES;
                profileView.image = nil;
                name.textAlignment = NSTextAlignmentCenter;
                name.numberOfLines = 1;
                name.frame = CGRectMake(15, 14, 290, 20);
                name.font = [UIFont systemFontOfSize:13];
                name.text = @"내 부서에 등록된 나 이외의 직원이 없습니다.";
                team.text = @"";
                //                    invite.hidden = YES;
                checkView.image = nil;
                name.textColor = [UIColor grayColor];
                lblStatus.text = @"";
                
                
            }
        }
        else{
            
            if(addRest){
                
                
                dic = addRestList[indexPath.row];
                
                
            }
            else{
                dic = nil;
                disableView.hidden = YES;
                allViewButton.hidden = NO;
                profileView.image = nil;
                name.textAlignment = NSTextAlignmentCenter;
                name.numberOfLines = 1;
                name.frame = CGRectMake(15, 14, 290, 20);
                name.font = [UIFont systemFontOfSize:13];
                name.text = @"";
                team.text = @"";
                //                invite.hidden = YES;
                checkView.image = nil;
                lblStatus.text = @"";
                name.textColor = [UIColor grayColor];
            }
        }
        

#elif defined(GreenTalk) || defined(GreenTalkCustomer)
        
        if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] == 60){
            
         
            if(indexPath.section == 0){
                
                
                if([deptList count]>0){
                    dic = deptList[indexPath.row];
                    
                    
                    
                }
                else{
                    dic = nil;
                    allViewButton.hidden = YES;
                    disableView.hidden = YES;
                    profileView.image = nil;
                    name.textAlignment = NSTextAlignmentCenter;
                    name.numberOfLines = 1;
                    name.frame = CGRectMake(15, 14, 290, 20);
                    name.font = [UIFont systemFontOfSize:13];
                    name.text = @"내 가맹점에 등록된 나 이외의 직원이 없습니다.";
                    team.text = @"";
                    //                    invite.hidden = YES;
                    checkView.image = nil;
                    name.textColor = [UIColor grayColor];
                    lblStatus.text = @"";
                    
                    
                }
            }
            else{
                
                if(addRest){
                    
                    
                    dic = addRestList[indexPath.row];
                    
                    
                }
                else{
                    dic = nil;
                    disableView.hidden = YES;
                    allViewButton.hidden = NO;
                    profileView.image = nil;
                    name.textAlignment = NSTextAlignmentCenter;
                    name.numberOfLines = 1;
                    name.frame = CGRectMake(15, 14, 290, 20);
                    name.font = [UIFont systemFontOfSize:13];
                    name.text = @"";
                    team.text = @"";
                    //                invite.hidden = YES;
                    checkView.image = nil;
                    lblStatus.text = @"";
                    name.textColor = [UIColor grayColor];
                }
            }
        }
        else{
            if(addRest){
                
                
                dic = addRestList[indexPath.row];
                
                
            }
            else{
                dic = nil;
                disableView.hidden = YES;
                allViewButton.hidden = NO;
                profileView.image = nil;
                name.textAlignment = NSTextAlignmentCenter;
                name.numberOfLines = 1;
                name.frame = CGRectMake(15, 14, 290, 20);
                name.font = [UIFont systemFontOfSize:13];
                name.text = @"";
                team.text = @"";
                //                invite.hidden = YES;
                checkView.image = nil;
                lblStatus.text = @"";
                name.textColor = [UIColor grayColor];
            }
        }
        
#elif BearTalk
        if(viewTag == kFavorite){
           if(indexPath.section == 0){
               
                if([deptList count]>0){
                    dic = deptList[indexPath.row];
                    
                    
                    
                }
                else{
                    dic = nil;
                    allViewButton.hidden = YES;
                    disableView.hidden = YES;
                    profileView.image = nil;
                    name.textAlignment = NSTextAlignmentCenter;
                    name.numberOfLines = 1;
                    name.frame = CGRectMake(15, 14, 290, 20);
                    name.font = [UIFont systemFontOfSize:13];
                    name.text = @"내 부서에 등록된 나 이외의 직원이 없습니다.";
                    team.text = @"";
                    //                    invite.hidden = YES;
                    checkView.image = nil;
                    checkView.backgroundColor =[UIColor clearColor];
                    
                    checkAddView.image = nil;
                    checkView.hidden = YES;
                    checkAddView.hidden = YES;
                    
                    name.textColor = [UIColor grayColor];
                    lblStatus.text = @"";
                    
                    
                }
               
        
            }
            else{
                
                if(addRest){
                    
                    
                    dic = addRestList[indexPath.row];
                    
                    
                }
                else{
                    dic = nil;
                    disableView.hidden = YES;
                    allViewButton.hidden = NO;
                    profileView.image = nil;
                    name.textAlignment = NSTextAlignmentCenter;
                    name.numberOfLines = 1;
                    name.frame = CGRectMake(15, 14, 290, 20);
                    name.font = [UIFont systemFontOfSize:13];
                    name.text = @"";
                    team.text = @"";
                    //                invite.hidden = YES;
                    checkView.image = nil;
                    checkView.backgroundColor =[UIColor clearColor];
                    checkView.hidden = YES;
                    checkAddView.hidden = YES;
                    checkAddView.image = nil;
                    lblStatus.text = @"";
                    name.textColor = [UIColor grayColor];
                }
            }
        }
        else{
            if(indexPath.section == 0){
                
                if([favList count]>0)
                {
                    dic = favList[indexPath.row];
                }
                else{
                    
                    dic = nil;
                    lblStatus.text = @"";
                    allViewButton.hidden = YES;
                    disableView.hidden = YES;
                    profileView.image = nil;
                    name.textAlignment = NSTextAlignmentCenter;
                    name.numberOfLines = 2;
                    name.frame = CGRectMake(15, 13, 290, 34);
                    name.font = [UIFont systemFontOfSize:13];
                    name.text = @"주소록에서 즐겨찾기를 선정하면,\n원하는 대상을 쉽게 찾을 수 있습니다.";
                    team.text = @"";
                    //                invite.hidden = YES;
                    name.textColor = [UIColor grayColor];
                    
                    checkView.image = nil;
                    checkView.backgroundColor =[UIColor clearColor];
                    
                    checkAddView.image = nil;
                    checkView.hidden = YES;
                    checkAddView.hidden = YES;
                }
            }
            else if(indexPath.section == 1){
                
                
                if([deptList count]>0){
                    dic = deptList[indexPath.row];
                    
                    
                    
                }
                else{
                    dic = nil;
                    allViewButton.hidden = YES;
                    disableView.hidden = YES;
                    profileView.image = nil;
                    name.textAlignment = NSTextAlignmentCenter;
                    name.numberOfLines = 1;
                    name.frame = CGRectMake(15, 14, 290, 20);
                    name.font = [UIFont systemFontOfSize:13];
                    name.text = @"내 부서에 등록된 나 이외의 직원이 없습니다.";
                    team.text = @"";
                    //                    invite.hidden = YES;
                    checkView.image = nil;
                    checkView.backgroundColor =[UIColor clearColor];
                    
                    checkAddView.image = nil;
                    checkView.hidden = YES;
                    checkAddView.hidden = YES;
                    
                    name.textColor = [UIColor grayColor];
                    lblStatus.text = @"";
                    
                    
                }
            }
            else{
                
                if(addRest){
                    
                    
                    dic = addRestList[indexPath.row];
                    
                    
                }
                else{
                    dic = nil;
                    disableView.hidden = YES;
                    allViewButton.hidden = NO;
                    profileView.image = nil;
                    name.textAlignment = NSTextAlignmentCenter;
                    name.numberOfLines = 1;
                    name.frame = CGRectMake(15, 14, 290, 20);
                    name.font = [UIFont systemFontOfSize:13];
                    name.text = @"";
                    team.text = @"";
                    //                invite.hidden = YES;
                    checkView.image = nil;
                    checkView.backgroundColor =[UIColor clearColor];
                    checkAddView.image = nil;
                    lblStatus.text = @"";
                    name.textColor = [UIColor grayColor];
                    checkView.hidden = YES;
                    checkAddView.hidden = YES;
                }
            }
        }
#else
        if(indexPath.section == 0){
            
            if([favList count]>0)
            {
                dic = favList[indexPath.row];
            }
            else{
                
                dic = nil;
                lblStatus.text = @"";
                allViewButton.hidden = YES;
                disableView.hidden = YES;
                profileView.image = nil;
                name.textAlignment = NSTextAlignmentCenter;
                name.numberOfLines = 2;
                name.frame = CGRectMake(15, 9, 290, 34);
                name.font = [UIFont systemFontOfSize:13];
                name.text = @"주소록에서 즐겨찾기를 선정하면,\n원하는 대상을 쉽게 찾을 수 있습니다.";
                team.text = @"";
                //                invite.hidden = YES;
                name.textColor = [UIColor grayColor];

                checkView.image = nil;
                checkView.backgroundColor =[UIColor clearColor];

              //  checkAddView.image = nil;
            }
        }
        else if(indexPath.section == 1){
            
            
            if([deptList count]>0){
                dic = deptList[indexPath.row];
                
                
                
            }
            else{
                dic = nil;
                allViewButton.hidden = YES;
                disableView.hidden = YES;
                profileView.image = nil;
                name.textAlignment = NSTextAlignmentCenter;
                name.numberOfLines = 1;
                name.frame = CGRectMake(15, 14, 290, 20);
                name.font = [UIFont systemFontOfSize:13];
                name.text = @"내 부서에 등록된 나 이외의 직원이 없습니다.";
                team.text = @"";
                //                    invite.hidden = YES;
                checkView.image = nil;
                checkView.backgroundColor =[UIColor clearColor];

       //         checkAddView.image = nil;
                
                name.textColor = [UIColor grayColor];
                lblStatus.text = @"";
                
                
            }
        }
        else{
            
            if(addRest){
                
                
                dic = addRestList[indexPath.row];
                
                
            }
            else{
                dic = nil;
                disableView.hidden = YES;
                allViewButton.hidden = NO;
                profileView.image = nil;
                name.textAlignment = NSTextAlignmentCenter;
                name.numberOfLines = 1;
                name.frame = CGRectMake(15, 14, 290, 20);
                name.font = [UIFont systemFontOfSize:13];
                name.text = @"";
                team.text = @"";
                //                invite.hidden = YES;
                checkView.image = nil;
                checkView.backgroundColor =[UIColor clearColor];
         //       checkAddView.image = nil;
                lblStatus.text = @"";
                name.textColor = [UIColor grayColor];
            }
        }
        
#endif
        
    }
    else{
        NSLog(@"sect %d row %d",(int)indexPath.section,(int)indexPath.row);
//        NSLog(@"deptContactList %@",deptContactList);
        if([deptContactList count]>0){
        dic = deptContactList[indexPath.row];
        }
        else{
                dic = nil;
                allViewButton.hidden = YES;
                disableView.hidden = YES;
                profileView.image = nil;
                name.textAlignment = NSTextAlignmentCenter;
                name.numberOfLines = 1;
                name.frame = CGRectMake(15, 14, 290, 20);
                name.font = [UIFont systemFontOfSize:13];
                name.text = @"직급자가 없습니다.";
                team.text = @"";
                //                    invite.hidden = YES;
            checkView.image = nil;
            checkView.backgroundColor =[UIColor clearColor];
            checkAddView.image = nil;
            
                name.textColor = [UIColor grayColor];
                lblStatus.text = @"";
                
                
            

        }
    }
    }
    
    NSLog(@"dic %@",dic);
    if(dic != nil){
        allViewButton.hidden = YES;
        [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"profile_photo.png" view:profileView scale:0];
        name.textAlignment = NSTextAlignmentLeft;
        name.numberOfLines = 1;
        name.textColor = [UIColor blackColor];
        name.frame = CGRectMake(55+xPadding, 5, 320-60-xPadding, 20);
        name.font = [UIFont systemFontOfSize:15];
        name.text = dic[@"name"];//?[[copyListobjectatindex:indexPath.row]objectForKey:@"grade2"]:

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
        
        
        team.frame = CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width, 20);
        
        
#ifdef BearTalk
        
        
        if (self.multiSelect == NO) {
            checkView.hidden = YES;
            checkAddView.hidden = YES;

        }
        else{
            checkView.hidden = NO;
            checkAddView.hidden = NO;
            
        }
        name.frame = CGRectMake(CGRectGetMaxX(profileView.frame)+10, 10, cell.contentView.frame.size.width - (CGRectGetMaxX(profileView.frame)+10) - 16, 19);
        name.font = [UIFont systemFontOfSize:14];
        name.textColor = RGB(32, 32, 32);
        team.font = [UIFont systemFontOfSize:12];
        team.frame = CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), name.frame.size.width, 19);
        team.textColor = RGB(151,152,157);
        
#endif
        
        if([dic[@"available"]isEqualToString:@"0"])
        {
            //            name.textColor = [UIColor grayColor];
            disableView.hidden = NO;
            lblStatus.text = NSLocalizedString(@"not_installed", @"not_installed");
            //            if([[SharedAppDelegate.root getPureNumbers:copyList[indexPath.row][@"cellphone"]]length]>0)
            //				invite.hidden = NO;
            //            else
            //                invite.hidden = YES;
        }
        else if([dic[@"available"]isEqualToString:@"4"]){
            
            //            name.textColor = [UIColor grayColor];
            disableView.hidden = NO;
            lblStatus.text = NSLocalizedString(@"logout", @"logout");
            //            invite.hidden = YES;
        }
        else
        {
            disableView.hidden = YES;
            //            invite.hidden = YES;
            lblStatus.text = @"";
        } //            lblStatus.text = @"";
        
#ifdef BearTalk
        
        if(viewTag == kFavorite){
            checkAddView.frame = CGRectMake(checkView.frame.size.width/2-30/2, checkView.frame.size.height/2-30/2-1, 30, 30);
            
            if([dic[key]isEqualToString:@"1"]){
                checkView.backgroundColor = RGB(249,249,249);
                checkView.layer.borderColor = [RGB(223, 223, 223)CGColor];
                checkAddView.image = [CustomUIKit customImageNamed:@"btn_bookmark_on.png"];
            }
            else{
                checkView.backgroundColor = RGB(249,249,249);
                checkView.layer.borderColor = [RGB(223, 223, 223)CGColor];
                checkAddView.image = [CustomUIKit customImageNamed:@"btn_bookmark_off.png"];
                
            }
        }
        else{
            checkAddView.frame = CGRectMake(checkView.frame.size.width/2-16/2, checkView.frame.size.height/2-13/2, 16, 13);
        if([dic[key]isEqualToString:@"1"]){
            
//            NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
            checkView.backgroundColor = BearTalkColor;//[NSKeyedUnarchiver unarchiveObjectWithData:colorData];
            checkView.layer.borderColor = checkView.backgroundColor.CGColor;
            
            checkAddView.image = [CustomUIKit customImageNamed:@"select_check_white.png"];
        }
        else if([dic[key]isEqualToString:@"2"]){
            checkView.backgroundColor = RGB(235,235,235);
            checkView.layer.borderColor = [RGB(223, 223, 223)CGColor];

            checkAddView.image = [CustomUIKit customImageNamed:@"select_check_white.png"];
        }
        else{
            checkView.backgroundColor = RGB(249,249,249);
            checkView.layer.borderColor = [RGB(223, 223, 223)CGColor];
            checkAddView.image = nil;
        }
        }
        
        
#else
        if([dic[key]isEqualToString:@"1"])
            checkView.image = [CustomUIKit customImageNamed:@"button_check.png"];
        else if([dic[key]isEqualToString:@"2"])
            checkView.image = [CustomUIKit customImageNamed:@"button_checked.png"];
        else
            checkView.image = [CustomUIKit customImageNamed:@"button_nocheck.png"];
        
#endif
        
    }
    
    return cell;
    
}


- (void)addOrClear:(NSDictionary *)d
{
    NSLog(@"addOrClear %@",d);
   
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:d];
    
    
    
    NSString *type = @"";
    
    //            }
    if([dic[key]isEqualToString:@"0"]){
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
    
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
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
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:method URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setfavorite.lemp" parameters:parameters];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
#ifdef BearTalk
        
        NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
        
        if([dic[key]isEqualToString:@"0"]){
            [addArray addObject:dic];
            [[ResourceLoader sharedInstance].favoriteList addObject:dic[@"uniqueid"]];
        }
        else {//if([[dicobjectForKey:key]isEqualToString:@"1"]){
            [addArray removeObject:dic];
            [[ResourceLoader sharedInstance].favoriteList removeObject:dic[@"uniqueid"]];
            
        }
        
        [self reloadCheck];
        
        [SharedAppDelegate.root setFavoriteList];
        
#else
        if([[operation.responseString objectFromJSONString]isKindOfClass:[NSArray class]] && [[operation.responseString objectFromJSONString]count]>0){
            NSLog(@"[operation.responseString objectFromJSONString] %@",[operation.responseString objectFromJSONString]);
            
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if([dic[key]isEqualToString:@"0"]){
                [SQLiteDBManager updateFavorite:@"1" uniqueid:dic[@"uniqueid"]];
                [addArray addObject:dic];
            }
            else {//if([[dicobjectForKey:key]isEqualToString:@"1"]){
                [SQLiteDBManager updateFavorite:@"0" uniqueid:dic[@"uniqueid"]];
                [addArray removeObject:dic];
                
            }
            
            [self reloadCheck];
        }
        else {
            
            
            //            [SharedAppDelegate.root updateFavorite:[dicobjectForKey:key] uniqueid:[dicobjectForKey:@"uniqueid"]];
            [self reloadList:dic[@"uniqueid"] fav:dic[key]];
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        }
        
#endif
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
       
        
        //        [SharedAppDelegate.root updateFavorite:[dicobjectForKey:key] uniqueid:[dicobjectForKey:@"uniqueid"]];
        [self reloadList:dic[@"uniqueid"] fav:dic[key]];
        
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
    
    
    NSLog(@"ReloadList %@ %@",uid,fav);
    
    
    for(int j = 0; j<[copyList count];j++)
    {
        NSDictionary *aDic = copyList[j];
        NSString *aUid = aDic[@"uniqueid"];
        if([uid isEqualToString:aUid])
        {
            NSLog(@"searching %@",fav);
            NSDictionary *newDic = [SharedFunctions fromOldToNew:aDic object:fav key:key];
            [copyList replaceObjectAtIndex:j withObject:newDic];
        }
    }
    
    
    for(int j = 0; j<[deptList count];j++)
    {
        NSDictionary *aDic = deptList[j];
        if([uid isEqualToString:deptList[j][@"uniqueid"]])
        {
            NSLog(@"deptList %@",fav);
            NSDictionary *newDic = [SharedFunctions fromOldToNew:aDic object:fav key:key];
            [deptList replaceObjectAtIndex:j withObject:newDic];
        }
    }
    
    for(int j = 0; j<[addRestList count];j++)
    {
        NSDictionary *aDic = addRestList[j];
        NSString *aUid = addRestList[j][@"uniqueid"];
        if([uid isEqualToString:aUid])
        {
            NSLog(@"addRestList %@",fav);
            NSDictionary *newDic = [SharedFunctions fromOldToNew:aDic object:fav key:key];
            [addRestList replaceObjectAtIndex:j withObject:newDic];
        }
    }
    
    
    //    }
    
    for(int j = 0; j<[myList count];j++)
    {
        NSDictionary *aDic = myList[j];
        NSString *aUid = myList[j][@"uniqueid"];
        if([uid isEqualToString:aUid])
        {
            NSLog(@"myList %@",fav);
            NSDictionary *newDic = [SharedFunctions fromOldToNew:aDic object:fav key:key];
            [myList replaceObjectAtIndex:j withObject:newDic];
        }
    }
    
    for(int j = 0; j<[deptContactList count];j++)
    {
        NSDictionary *aDic = deptContactList[j];
        NSString *aUid = deptContactList[j][@"uniqueid"];
        if([uid isEqualToString:aUid])
        {
            NSLog(@"myList %@",fav);
            NSDictionary *newDic = [SharedFunctions fromOldToNew:aDic object:fav key:key];
            [deptContactList replaceObjectAtIndex:j withObject:newDic];
        }
    }
    
    [myTable reloadData];
}

//- (void)saveImage:(NSDictionary *)dic
//{
//
//    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[dic [@"path"]];
//    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[dic [@"urlString"]]];
//
//    [imgData writeToFile:filePath atomically:YES];
//
//    [imageThread cancel];
//
//    if(imageThread)
//        SAFE_RELEASE(imageThread);
//}



/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */



/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    NSLog(@"didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


//- (void)dealloc {
//    [myList release];
//    [copyList release];
//    [favList release];
//    [deptList release];
//    [addRestList release];
//    [addArray release];
//    [alreadyArray release];
//    [super dealloc];
//}

@end
