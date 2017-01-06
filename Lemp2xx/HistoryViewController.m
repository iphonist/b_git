//
//  HistoryViewController.m
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 2. 10..
//  Copyright 2012 Benchbee. All rights reserved.
//

#import "HistoryViewController.h"
#import "MapViewController.h"
#import "PhotoViewController.h"
//#import "DetailHistoryViewController.h"

@implementation HistoryViewController
//@synthesize target;
//@synthesize selector;


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


- (id)init//WithTag:(int)tag
{
		self = [super init];
		if(self != nil)
		{

        
		}
		return self;
		
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	// photoView에서 버그 유발
//	if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//		self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//		self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//	}

//    [button release];
    myList = [[NSMutableArray alloc]init];//
    
    topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    topImageView.image = [CustomUIKit customImageNamed:@"history_tab.png"];
    [self.view addSubview:topImageView];
//    [topImageView release];

    
    UIImageView *subImage = [[UIImageView alloc]initWithFrame:CGRectMake(91, 11, 23, 13)];
    subImage.image = [CustomUIKit customImageNamed:@"history_title_01.png"];
    [self.view addSubview:subImage];
//    [subImage release];
    
    subImage = [[UIImageView alloc]initWithFrame:CGRectMake(192, 11, 23, 13)];
    subImage.image = [CustomUIKit customImageNamed:@"history_title_02.png"];
    [self.view addSubview:subImage];
//    [subImage release];
    
    subImage = [[UIImageView alloc]initWithFrame:CGRectMake(264, 11, 39, 13)];
    subImage.image = [CustomUIKit customImageNamed:@"history_title_03.png"];
    [self.view addSubview:subImage];
//    [subImage release];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(87, 12, 320-87, 15)];
//    label.font = [UIFont systemFontOfSize:16];
//    label.text = @"대상                날짜         수/발신";
//    label.textColor = [UIColor grayColor];
//    label.backgroundColor = [UIColor clearColor];
//    [topImageView addSubview:label];
//    [label release];
    
    myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, topImageView.frame.size.height, 320, self.view.frame.size.height-topImageView.frame.size.height - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
    
    
		myTable.dataSource = self;
		myTable.delegate = self;
		myTable.rowHeight = 50;
    [self.view addSubview:myTable];
//    [myTable release];
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    [self initTable];
}
- (void)cancel
{
    if(myTable.tag == 1)
        [self dismissViewControllerAnimated:YES completion:nil];
    else{
          [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
        [self initTable];
    }
}

- (void)initTable{
    
    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    topImageView.frame = CGRectMake(0, 0, 320, 0);
    myTable.frame = CGRectMake(0, topImageView.frame.size.height, 320, self.view.frame.size.height-topImageView.frame.size.height);
    self.title = @"채팅 히스토리";
    //    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
#ifdef BearTalk
    [myList setArray:[NSArray arrayWithObjects:@"음성메시지",@"사진",@"동영상",nil]];
#else
    [myList setArray:[NSArray arrayWithObjects:@"음성메시지",@"사진",@"동영상",@"위치",nil]];
#endif
    [myTable setTag:1];
    [myTable reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
//	[lastSelectedCell setSelected:NO animated:YES];
//    [myTable reloadData];
}
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [myList count];

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
    
    static NSString *titleTableIdentifier = @"TitleCell";
    static NSString *myTableIdentifier = @"Cell";
    
    if (myTable.tag == 1) {
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleTableIdentifier];
        
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [myList objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = cell.contentView.frame;
        btn.tag = indexPath.row;
        [btn addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        return cell;
        
    }

    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
        UIImageView *icon;
        UILabel *lblName, *lblDate, *lblStatus;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            icon = [[UIImageView alloc]init];
            icon.frame = CGRectMake(10, 7, 39, 33);
            icon.tag = 100;
            [cell.contentView addSubview:icon];
//            [icon release];
            
            
            lblName = [CustomUIKit labelWithText:nil fontSize:16 fontColor:[UIColor blackColor] frame:CGRectMake(50, 0, 100, 50) numberOfLines:1 alignText:NSTextAlignmentCenter];
            lblName.tag = 200;
            [cell.contentView addSubview:lblName];
//            [lblName release];
            
            
            lblDate = [CustomUIKit labelWithText:nil fontSize:16 fontColor:[UIColor blackColor] frame:CGRectMake(150, 0, 100, 50) numberOfLines:1 alignText:NSTextAlignmentCenter];
            lblDate.tag = 300;
            [cell.contentView addSubview:lblDate];
//            [lblDate release];
            
            
            lblStatus = [CustomUIKit labelWithText:nil fontSize:16 fontColor:[UIColor blackColor] frame:CGRectMake(250, 0, 65, 50) numberOfLines:1 alignText:NSTextAlignmentCenter];
            lblStatus.tag = 400;
            [cell.contentView addSubview:lblStatus];
//            [lblStatus release];
            
        }
        else{
            
            icon = (UIImageView *)[cell viewWithTag:100];
            lblName = (UILabel *)[cell viewWithTag:200];
            lblDate = (UILabel *)[cell viewWithTag:300];
            lblStatus = (UILabel *)[cell viewWithTag:400];
            
        }
        
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            lblName.text = [[SharedAppDelegate.root getLastDic:[[myList objectAtIndex:indexPath.row]objectForKey:@"roomkey"]]objectForKey:@"names"];
            lblDate.text = [[myList objectAtIndex:indexPath.row]objectForKey:@"date"];
            
            if(tableView.tag == 3) // voice
            {
                icon.image = [CustomUIKit customImageNamed:@"pref_icon_01.png"];
            }
            else if(tableView.tag == 2) // image
            {
                icon.image = [CustomUIKit customImageNamed:@"pref_icon_02.png"];
            }
            else if(tableView.tag == 5) // video
            {
                icon.image = [CustomUIKit customImageNamed:@"pref_icon_03.png"];
            }
            else if(tableView.tag == 4) // location
            {
                icon.image = [CustomUIKit customImageNamed:@"pref_icon_04.png"];
            }
            
            
            if([[[myList objectAtIndex:indexPath.row]objectForKey:@"direction"] isEqualToString:@"1"])
            {
                lblStatus.text = @"수신";
                lblStatus.textColor = RGB(80, 123, 192);
                
            }
            else{
                lblStatus.text = @"발신";
                lblStatus.textColor = RGB(249, 102, 107);
                
            }
        
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = cell.contentView.frame;
        btn.tag = indexPath.row;
        [btn addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
        return cell;
        
    }
    
    
}


- (void)backTo{
    
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}

- (void)didSelect:(id)sender{
    NSLog(@"sender tag %d mytable tag %d",(int)[sender tag],(int)myTable.tag);
    
    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(initTable)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    if(myTable.tag == 1){
        
        if([sender tag]==4){
            
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.navigationController.topViewController isKindOfClass:[SharedAppDelegate.root.recent class]])
            [self.navigationController pushViewController:SharedAppDelegate.root.recent animated:YES];
            });
            [SharedAppDelegate.root.recent setPushButton];
//            [SharedAppDelegate.root loadRecentWithAnimation];
//            [self.navigationController pushViewController:SharedAppDelegate.root.recent animated:YES];
            return;
        }
        topImageView.frame = CGRectMake(0, 0, 320, 35);
        myTable.frame = CGRectMake(0, topImageView.frame.size.height, 320, self.view.frame.size.height-topImageView.frame.size.height);
        
        
        switch ([sender tag]) {
            case 0:
                self.title = @"음성메시지";
//                [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
                [myList setArray:[SQLiteDBManager getMessageFromDB:@"0" type:@"3" number:0]];
                [myTable setTag:3];
                [myTable reloadData];
                break;
                
            case 1:
                self.title = @"사진";
//                [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
                [myList setArray:[SQLiteDBManager getMessageFromDB:@"0" type:@"2" number:0]];
           
                [myTable setTag:2];
                [myTable reloadData];
                break;
            case 2:
                self.title = @"동영상";
//                [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
                [myList setArray:[SQLiteDBManager getMessageFromDB:@"0" type:@"5" number:0]];
                [myTable setTag:5];
                [myTable reloadData];
                break;
            case 3:
                self.title = @"위치";
//                [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
                [myList setArray:[SQLiteDBManager getMessageFromDB:@"0" type:@"4" number:0]];
                [myTable setTag:4];
                [myTable reloadData];
                break;
            default:
                break;
                
                
        }
    }
    else{
        
        NSString *imageString = [[myList objectAtIndex:[sender tag]]objectForKey:@"message"];
     
        //	lastSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
        
        if([[[myList objectAtIndex:[sender tag]]objectForKey:@"direction"] isEqualToString:@"1"]) {
            NSLog(@"mylist objectatindex:sendr tag %@",[myList objectAtIndex:[sender tag]]);
            NSString *fileName = [[myList objectAtIndex:[sender tag]]objectForKey:@"msgindex"];
            if(myTable.tag == 3) // voice
            {
                UIButton *btn = (UIButton *)sender;
                [btn setTitle:fileName forState:UIControlStateSelected];
                [btn setTitle:imageString forState:UIControlStateDisabled];
                [SharedAppDelegate.root.chatView getAudio:btn];//[fileName stringByAppendingString:@".mp4"] roomkey:[[myList objectAtIndex:indexPath.row]objectForKey:@"roomkey"] server:fileServer];
            }
            else if(myTable.tag == 2) // image
            {
                NSDictionary *dic = [imageString objectFromJSONString];
                NSLog(@"dic %@",dic);
                NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@%@",[dic objectForKey:@"protocol"],[dic objectForKey:@"server"],[dic objectForKey:@"dir"],[[dic objectForKey:@"filename"]objectAtIndex:0]];
//                NSArray *arr = [imageString componentsSeparatedByString:@":"];
//                NSString *fileServer = [arr objectAtIndex:[arr count]-1];
                                   [self getMedia:2 fileName:[fileName stringByAppendingString:@".jpg"] roomkey:[[myList objectAtIndex:[sender tag]]objectForKey:@"roomkey"] server:imgUrl];
            }
            else if(myTable.tag == 5) // video
            {
                NSDictionary *dic = [imageString objectFromJSONString];
                NSLog(@"dic %@",dic);
                NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@%@",[dic objectForKey:@"protocol"],[dic objectForKey:@"server"],[dic objectForKey:@"dir"],[[dic objectForKey:@"filename"]objectAtIndex:0]];
//                NSArray *arr = [imageString componentsSeparatedByString:@":"];
//                NSString *fileServer = [arr objectAtIndex:[arr count]-1];
                                    [self getMedia:5 fileName:[fileName stringByAppendingString:@".mp4"] roomkey:[[myList objectAtIndex:[sender tag]]objectForKey:@"roomkey"] server:imgUrl];
            }
            else if(myTable.tag == 4) // location
            {
                
                NSDictionary *dic = [imageString objectFromJSONString];
                NSLog(@"dic %@",dic);
                NSString *location = [NSString stringWithFormat:@"%@,%@",[dic objectForKey:@"latitude"],[dic objectForKey:@"longitude"]];
                
                                    [self viewMap:location];
            }
        } else {
            
            if(myTable.tag == 3) // voice
            {
                [self viewMedia:(int)myTable.tag fileName:imageString];
            }
            else if(myTable.tag == 2) // image
            {
                [self viewMedia:(int)myTable.tag fileName:imageString];
            }
            else if(myTable.tag == 5) // video
            {
                [self viewMedia:(int)myTable.tag fileName:imageString];
            }
            else if(myTable.tag == 4) // location
            {
                [self viewMap:imageString];
            }
            
        }
    }
//    [myTable deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)getMedia:(int)t fileName:(NSString*)fileName roomkey:(NSString*)rk server:(NSString*)server
{
	NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath] && [[SQLiteDBManager getFileStatus:[fileName substringToIndex:[fileName length]-4]] isEqualToString:@"0"]) {
		[self playMedia:t withPath:filePath];
	} else {
        NSLog(@"else getMedia %d %@ %@ %@",(int)t,fileName,rk,server);
        PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithFileName:fileName image:nil type:t parentViewCon:self roomkey:rk server:server];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[photoViewCon class]]){
//            photoViewCon.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:photoViewCon animated:YES];
    }
        });
//		[photoViewCon release];
	}
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
   
    NSLog(@"original didselect");

}

//- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
//{
//    
//	self.target = aTarget;
//	self.selector = aSelector;
//}
- (void)viewMedia:(int)t fileName:(NSString*)fileName
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 사용자가 보낸 사진, 동영상, 음성 컨텐츠를 선택하면 실행
	 param	- t(int) : 컨텐츠 타입
     - fileName(NSString*) : 파일 경로
	 연관화면 : 히스토리
	 ****************************************************************/
    
	NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    
	
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
		[self playMedia:t withPath:filePath];
	}
	else {
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"미디어 파일을 찾을 수 없습니다!\n파일이 오래되어 삭제되거나, 다른 어플리케이션에 의해 삭제되었을 수 있습니다." con:self];
	}
}

-(void)playMedia:(int)type withPath:(NSString*)filePath
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 미디어 타입에 따른 컨텐츠 재생
	 param   - type(int) : 파일타입(2-사진, 5-동영상, 3-음성)
     - filePath(NSString*) : 파일 경로
	 연관화면 : 히스토리
	 ****************************************************************/
    
	if(type == 2 || type == 5)
	{
        PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithPath:filePath type:type];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[photoViewCon class]]){
//            photoViewCon.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:photoViewCon animated:YES];
    }
        });
//		[photoViewCon release];
	}
	else if(type == 3)
	{
	   	[SharedAppDelegate.root.chatView showVoicePlayerView:filePath fileDownload:NO roomkey:nil server:nil];
	}
    
}
- (void)viewMap:(NSString*)location
{
    NSLog(@"location %@",location);

    //	NSString *location = [NSString stringWithString:[sender titleForState:UIControlStateDisabled]];
	MapViewController *mvc = [[MapViewController alloc]initWithLocation:location];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:mvc];
    [self presentViewController:nc animated:YES completion:nil];
//    [mvc release];
//    [nc release];
}
#pragma mark -
#pragma mark Memory management


- (void)didReceiveMemoryWarning {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
    [super didReceiveMemoryWarning];
}


//- (void)dealloc {
//    [myList release];
//    [super dealloc];
//}


@end

