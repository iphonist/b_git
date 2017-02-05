//
//  PersonalViewController.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 2013. 11. 14..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "PersonalViewController.h"
#import "ScheduleCalendarViewController.h"
#import "MemoListViewController.h"
#import "HomeTimelineViewController.h"
#import "SetupViewController.h"
#import "PhotoViewController.h"
#import "SubSetupViewController.h"
#import "WriteScheduleViewController.h"
#import "ScheduleViewController.h"
#import "WriteMemoViewController.h"
//#import "GoogleMapViewController.h"
#import "MapViewController.h"
#import "WebBrowserViewController.h"
#import "OLGhostAlertView.h"

//#import <GoogleMaps/GoogleMaps.h>
#import "AESExtention.h"
//#import "GKImagePicker.h"

@interface PersonalViewController ()<GKImagePickerDelegate>

@end


#define kMemo 1
#define kMyWriting 2
#define kBookmark 3
#define kSchedule 4

@implementation PersonalViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        NSLog(@"personal init");
        self.title = @"나";
        
        //        noticeList = [[NSMutableArray alloc]init];
        //        noticeTable = [[UITableView alloc]init];
        //        noticeTable.delegate = self;
        //        noticeTable.dataSource = self;
        //        noticeTable.bounces = NO;
        //        noticeTable.scrollEnabled = NO;
        //		if ([noticeTable respondsToSelector:@selector(setSeparatorInset:)]) {
        //			[noticeTable setSeparatorInset:UIEdgeInsetsZero];
        //		}
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMyInfoView) name:@"refreshProfiles" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSetupButton) name:@"refreshPushAlertStatus" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dayChanged) name:UIApplicationSignificantTimeChangeNotification object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewwillAppear %f",self.tabBarController.tabBar.frame.size.height);
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    //    if (profileView) {
    //		[SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"mynophoto.png" view:profileView scale:0];
    //	}
    [self setMyInfoView];
    [self getMyInfo];
//    [self refreshSetupButton];
    
}


- (void)getMyInfo{
//#ifdef GreenTalk
//    return;
//#endif
#ifdef BearTalk
    return;
#endif
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/myinfo.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    

    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           nil];
    //
    //    NSError *error;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:0 error:&error];
    //    NSString *jsonString = [param JSONString];//[[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    //    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSLog(@"jsonString as string:\n%@", [[ResourceLoader sharedInstance].myUID JSONString]);
    //    NSLog(@"jsonString as string:\n%@", [[ResourceLoader sharedInstance].mySessionkey JSONString]);
    //    NSString *jsonString = [NSString stringWithFormat:@"uid:%@,sessionkey:%@",[[ResourceLoader sharedInstance].myUID JSONString],[[ResourceLoader sharedInstance].mySessionkey JSONString]];
    //    NSLog(@"jsonString as string:\n%@", jsonString);
    
    //    NSString *jsonString = [param JSONString];
    //    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    //    NSLog(@"jsonString %@", jsonString);
    //    jsonString = [jsonString substringWithRange:NSMakeRange(1,[jsonString length]-2)];
    //    NSLog(@"jsonString %@", jsonString);
    //    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:param,@"param",nil];
    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    NSLog(@"jsonString %@",jsonString);
    //    return;
    
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/myinfo.lemp" parametersJson:param key:@"param"];
    NSLog(@"request %@",request);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
#ifdef IVTalk
            
            
            if([resultDic[@"call_count"]intValue]>0){
                NSLog(@"count>0");
                [linkButton setBackgroundImage:[UIImage imageNamed:@"barbutton_main_link_new.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            }
            else{
                NSLog(@"count=0");
                [linkButton setBackgroundImage:[UIImage imageNamed:@"barbutton_main_link.png"] forState:UIControlStateNormal];
                //        [btnNaviNotice setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            }
#endif
            
            NSLog(@"mymemo %@",resultDic[@"my_memo_count"]);
            memoCount.text = resultDic[@"my_memo_count"];
            mineCount.text = resultDic[@"my_write_count"];
            bookmarkCount.text = resultDic[@"my_bookmark_count"];
#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(BearTalk)
            [SharedAppDelegate.root.main setNewNoticeBadge:[resultDic[@"my_notice_count"]intValue]];
#else
           [SharedAppDelegate.root.mainTabBar setMeBadgeCount:[resultDic[@"my_notice_count"]intValue]];

            if([resultDic[@"my_notice_count"]intValue]>0){

                nBadge.hidden = NO;
                nLabel.text = [NSString stringWithFormat:@"%d",(int)[resultDic[@"my_notice_count"]intValue]];
                if([resultDic[@"my_notice_count"]intValue]>99)
                    nLabel.text = @"99+";
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:11], NSParagraphStyleAttributeName:paragraphStyle};
                CGSize size = [nLabel.text boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                
 //               CGSize size = [nLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:11] constrainedToSize:CGSizeMake(100, 14) lineBreakMode:NSLineBreakByWordWrapping];
                nBadge.frame = CGRectMake(18, 0, (size.width+12)<24?24:(size.width+12), 24);
                nLabel.frame = CGRectMake(0, 0, nBadge.frame.size.width-2, nBadge.frame.size.height-2);

            }
            else{
                nBadge.hidden = YES;
                nLabel.text = @"";
            }
            
#endif
 
            
            NSArray *array = resultDic[@"my_calender_count"];
            NSLog(@"array %@",array);
            labelToday.text = array[0][@"count"];
            label1st.text = array[1][@"count"];
            label2nd.text = array[2][@"count"];
            label3rd.text = array[3][@"count"];
            label4th.text = array[4][@"count"];
            label5th.text = array[5][@"count"];
       
            
            
            
        }
        else {
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
    
}


#define kCalendar 2
- (void)showSchedule:(id)sender{
    NSLog(@"showSchedule");
    
    [SharedAppDelegate.root settingScheduleList];
    [SharedAppDelegate.root.scal fromWhere:kCalendar];
}
- (void)loadNotice:(id)sender{
    nBadge.hidden = YES;
    [SharedAppDelegate.root settingNotiList];
    
}
#define kWrite 1
#define kProfile 2
#define kCover 3
#define kProfileNoPhoto 4


#define kWrite 1
#define kMine 0
#define kMeeting 2

- (void)writeActionSheet:(id)sender{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"개인 일정 등록"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kMine];
                            schedule.title = @"개인 일정 등록";
                            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
                            [SharedAppDelegate.root anywhereModal:nc];
//                            [schedule release];
//                            [nc release];
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"그룹 일정 등록"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kMeeting];
                            schedule.title = @"그룹 일정 등록";
                            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
                            [SharedAppDelegate.root anywhereModal:nc];
//                            [schedule release];
//                            [nc release];
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"메모 작성"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            WriteMemoViewController *memo = [[WriteMemoViewController alloc]initWithTitle:@"메모 쓰기" tag:kWrite content:@"" length:@"0" index:@"" image:nil];
                            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:memo];
                            [SharedAppDelegate.root anywhereModal:nc];
//                            [memo release];
//                            [nc release];
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else{
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                destructiveButtonTitle:nil otherButtonTitles:@"개인 일정 등록", @"그룹 일정 등록", @"메모 작성", nil];
    actionSheet.tag = kWrite;
    [actionSheet showInView:SharedAppDelegate.window];
}
}

- (void)profileActionSheet:(id)sender{
    
    NSString *profileImageInfo = [ResourceLoader checkProfileImageWithUID:[ResourceLoader sharedInstance].myUID];
    NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:profileImageInfo num:0 thumbnail:NO];

    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"사진 크게 보기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            NSString *profileImageInfo = [ResourceLoader checkProfileImageWithUID:[ResourceLoader sharedInstance].myUID];
                            NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:profileImageInfo num:0 thumbnail:NO];
                            NSLog(@"profileImageInfo %@ imgurl %@",profileImageInfo,imgURL);
                            if(imgURL == nil){
                                OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"프로필 사진을 등록하세요."];
                                //    if ([replyTextView isFirstResponder]) {
                                //        toast.position = OLGhostAlertViewPositionCenter;
                                //    } else {
                                toast.position = OLGhostAlertViewPositionBottom;
                                //    }
                                toast.style = OLGhostAlertViewStyleDark;
                                toast.timeout = 1.0;
                                toast.dismissible = YES;
                                [toast show];
                                //                                    [toast release];
                                return;
                            }
                            
                            PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithJSONdata:profileImageInfo image:profileView.image type:2 parentViewCon:self uniqueID:[ResourceLoader sharedInstance].myUID];
                            
                            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoViewCon];
                            //                [SharedAppDelegate.root anywherePush:photoViewCon];
                            [SharedAppDelegate.root anywhereModal:nc];
                            //                                [photoViewCon release];
                            //                                [nc release];
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"사진 찍기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.width-20);
                            gkpicker.delegate = self;
                            gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                            //                                [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                            //Do some thing here
                            //                                [view dismissViewControllerAnimated:YES completion:nil];
                            [SharedAppDelegate.root anywhereModal:gkpicker.imagePickerController];
                            
                        }];
        [view addAction:actionButton];
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"앨범에서 사진 선택"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            gkpicker.cropSize = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.width-20);
                            gkpicker.delegate = self;
                            gkpicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                            //                                [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                            //Do some thing here
                            //                                [view dismissViewControllerAnimated:YES completion:nil];
                            [SharedAppDelegate.root anywhereModal:gkpicker.imagePickerController];
                            
                        }];
        [view addAction:actionButton];
        
        
        if(imgURL != nil){
            actionButton = [UIAlertAction
                            actionWithTitle:@"사진 삭제"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                
                                NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",[ResourceLoader sharedInstance].myUID];
                                NSLog(@"getMyProfile!!!! %@",documentPath);
                                
                                UIImage *image = [UIImage imageWithContentsOfFile:documentPath];
                                
                                NSLog(@"image %@",image);
                                
                                if(image != nil){
                                    
                                    [self changeUserImage:nil];
                                }
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
        }
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    
        
    }
    else{
        UIActionSheet *actionSheet;
        if(imgURL == nil){
            UIActionSheet *actionSheet;
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                        destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", nil];
            actionSheet.tag = kProfileNoPhoto;
            [actionSheet showInView:SharedAppDelegate.window];
        }
        else{
            UIActionSheet *actionSheet;
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                        destructiveButtonTitle:nil otherButtonTitles:@"사진 크게 보기", @"사진 찍기", @"앨범에서 사진 선택", @"사진삭제", nil];
            actionSheet.tag = kProfile;
            [actionSheet showInView:SharedAppDelegate.window];

        }
        
        //    [actionSheet showInView:self.parentViewController.tabBarController.view];
        [actionSheet showInView:self.parentViewController.view];
        //    [actionSheet release];
    }

}

- (void)coverActionSheet:(id)sender{
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        
        
        UIAlertAction *actionButton;
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"사진 찍기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            isCoverChanging = YES;
                            
                            gkpicker.cropSize = CGSizeMake(320, coverView.frame.size.height);
                            gkpicker.delegate = self;
                            gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"앨범에서 사진 선택"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            isCoverChanging = YES;
                            
                            gkpicker.cropSize = CGSizeMake(320, coverView.frame.size.height);
                            gkpicker.delegate = self;
                            
                            
                            gkpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                            [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                            
                            
                        }];
        [view addAction:actionButton];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else{
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", nil];
    actionSheet.tag = kCover;
    [actionSheet showInView:SharedAppDelegate.window];
    }
}


-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if(actionSheet.tag == kWrite){
        switch (buttonIndex) {
            case 0:{
                
                WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kMine];
                schedule.title = @"개인 일정 등록";
                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
                [SharedAppDelegate.root anywhereModal:nc];
//                [schedule release];
//                [nc release];
            }
                break;
            case 1:
            {
                
                WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kMeeting];
                schedule.title = @"그룹 일정 등록";
                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
                [SharedAppDelegate.root anywhereModal:nc];
//                [schedule release];
//                [nc release];
            }
                break;
            case 2:
            {
                
                //            WriteMemoViewController *memo = [[WriteMemoViewController alloc]initWithTitle:@"메모 쓰기" content:@"" length:@"0" index:@""];
                WriteMemoViewController *memo = [[WriteMemoViewController alloc]initWithTitle:@"메모 쓰기" tag:kWrite content:@"" length:@"0" index:@"" image:nil];
                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:memo];
                [SharedAppDelegate.root anywhereModal:nc];
//                [memo release];
//                [nc release];
            }
                break;
            default:
                break;
        }
    }
    else if(actionSheet.tag == kProfileNoPhoto){
      
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        
        
        switch (buttonIndex) {
            case 0:
                
                gkpicker.cropSize = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.width-20);
                gkpicker.delegate = self;
                gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                
                break;
            case 1:
                
                //            [SharedAppDelegate.root launchQBImageController:1 con:self];
                
                gkpicker.cropSize = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.width-20);
                gkpicker.delegate = self;
                gkpicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                break;
                //
            default:
                break;
        }

    }
    else if(actionSheet.tag == kProfile){
     
        
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
        
        
                
                switch (buttonIndex) {
                        
                    case 0:
                    {
                        NSString *profileImageInfo = [ResourceLoader checkProfileImageWithUID:[ResourceLoader sharedInstance].myUID];
                        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:profileImageInfo num:0 thumbnail:NO];
                        NSLog(@"profileImageInfo %@ imgurl %@",profileImageInfo,imgURL);
                        if(imgURL == nil){
                            OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"프로필 사진을 등록하세요."];
                            //    if ([replyTextView isFirstResponder]) {
                            //        toast.position = OLGhostAlertViewPositionCenter;
                            //    } else {
                            toast.position = OLGhostAlertViewPositionBottom;
                            //    }
                            toast.style = OLGhostAlertViewStyleDark;
                            toast.timeout = 1.0;
                            toast.dismissible = YES;
                            [toast show];
                            //                    [toast release];
                            return;
                        }
                        
                        PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithJSONdata:profileImageInfo image:profileView.image type:2 parentViewCon:self uniqueID:[ResourceLoader sharedInstance].myUID];
                        
                        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoViewCon];
                        //                [SharedAppDelegate.root anywherePush:photoViewCon];
                        [SharedAppDelegate.root anywhereModal:nc];
                        //                [photoViewCon release];
                        //                [nc release];
                    }
                        break;
                    case 1:
                        gkpicker.cropSize = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.width-20);
                        gkpicker.delegate = self;
                        gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//                        [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                          [SharedAppDelegate.root anywhereModal:gkpicker.imagePickerController];
                        break;
                    case 2:
                        
                        //            [SharedAppDelegate.root launchQBImageController:1 con:self];
                        
                        
                        gkpicker.cropSize = CGSizeMake(self.view.frame.size.width-20, self.view.frame.size.width-20);
                        gkpicker.delegate = self;
                        gkpicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//                        [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
                        [SharedAppDelegate.root anywhereModal:gkpicker.imagePickerController];
                        break;
                    case 3:
                    {
                        
                        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",[ResourceLoader sharedInstance].myUID];
                        NSLog(@"getMyProfile!!!! %@",documentPath);
                        
                        UIImage *image = [UIImage imageWithContentsOfFile:documentPath];
                        
                        NSLog(@"image %@",image);
                        
                        if(image != nil){
                            
                            [self changeUserImage:nil];
                        }
                    }
                        break;
                        //
                    default:
                        break;
                }

    }
    else if(actionSheet.tag == kCover){
        
        switch (buttonIndex) {
            case 0:{
                isCoverChanging = YES;
                
                
                gkpicker.cropSize = CGSizeMake(320, coverView.frame.size.height);
                gkpicker.delegate = self;
                gkpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
            }
                break;
            case 1:
            {
                isCoverChanging = YES;
                
                
                gkpicker.cropSize = CGSizeMake(320, coverView.frame.size.height);
                gkpicker.delegate = self;
                
                
                gkpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:gkpicker.imagePickerController animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}




#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"assets count %d",(int)[assets count]);
    PHImageManager *imageManager = [PHImageManager new];
    
 //   NSMutableArray *infoArray = [NSMutableArray array];
//    for (PHAsset *asset in assets) {
        [imageManager requestImageDataForAsset:assets[0]
                                       options:0
                                 resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                                     if([imageData length]<1){
                                         
                                         [CustomUIKit popupSimpleAlertViewOK:nil msg:@"이미지가 너무 작습니다." con:self];
                                         return;
                                     }
                                     
                                     UIImage *image = [UIImage imageWithData:imageData];
                                     
                                         PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] ;
                                       [picker presentViewController:photoViewCon animated:YES completion:nil];
                                 }];
//    }
    
    
    
    
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    NSLog(@"qb_imagePickerControllerDidCancel");
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}

#else


- (void)qbimagePickerController:(QBImagePickerController *)picker didFinishPickingMediaWithInfo:(id)info
{
    NSLog(@"qbimage didFinishPickingMediaWithInfo");
    NSArray *mediaInfoArray = (NSArray *)info;
    UIImage *image = mediaInfoArray[0][UIImagePickerControllerEditedImage];//UIImagePickerControllerEditedImage
    
    PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] ;
    [picker presentViewController:photoViewCon animated:YES completion:nil];
}

#endif
- (void)sendPhoto:(UIImage*)image
{
    NSLog(@"sendPhoto ");
    [self changeUserImage:image];
}

- (void)imagePickerDidCancel:(GKImagePicker *)imagePicker{
    
    NSLog(@"imagePickerDidCancel");
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    
    NSLog(@"gkimage picking");
    
    
    [imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    //    [imagePicker.imagePickerController release];
    
    NSLog(@"3");
    if(isCoverChanging){
        isCoverChanging = NO;
        [self changeCoverImage:image];
    }
    else{
        [self changeUserImage:image];
    }

}


#pragma mark - ImagePickerController Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    NSLog(@"imagePickerControllerDidCancel");
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 모달로 올라온 이미지피커에서 사진 촬영 또는 앨범에서 선택하는 컨트롤러에서 취소했을 때 이미지 피커 내려줌.
     param - picker(UIImagePickerController *) : 이미지피커
     연관화면 : 내 상태 변경
     ****************************************************************/
    isCoverChanging = NO;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    [picker release];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    NSLog(@"didFinishPickingMediaWithInfo");
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 모달로 올라온 이미지피커에서 사진 촬영 또는 앨범에서 선택해 사진을 변경할 때.
     param  - picker(UIImagePickerController *) : 이미지피커
     - info(NSDictionary *) : 사진 정보가 담긴 dictionary
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //    [picker release];
    
    
    [self changeUserImage:image];
}



- (void)changeUserImage:(UIImage*)image
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 사진 눌러 나온 액션시트에서 사진 삭제를 선택하거나 사진을 변경할 때.
     param  - image(UIImage *) : 이미지
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    //    id AppID = [[UIApplication sharedApplication]delegate];
    //
    //
    //
    NSString *fullPathToFile = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
    NSLog(@"fullPath %@",fullPathToFile);
    NSLog(@"4");
    if(image == nil) {
        UIImage *image = [UIImage imageWithContentsOfFile:fullPathToFile];
        NSLog(@"image %@",image);
        if(image){
            [SharedAppDelegate.root setMyProfileDelete:self];// deleteProfileImage];
        }
    }
    else
    {
        UIImage *newImage = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(320, 320)];
        UIImage *newImage2 = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(640, 640)];
        
        NSLog(@"5");
        NSLog(@"new %@ 2 %@",newImage,newImage2);
        // 이미지 로컬의 도큐멘트 폴더에 저장
        // 서버 업로드 관련은 맥부기에 이미지 post 로 검색해볼 것
        //        NSData* UIImageJPEGRepresentation (UIImage *image, CGFloat compressionQuality);
        
        NSData *saveImage = UIImageJPEGRepresentation(newImage, 0.8);
        [saveImage writeToFile:fullPathToFile atomically:YES];
        NSData* originImage = UIImageJPEGRepresentation(newImage2, 0.8);
        NSLog(@"new %@ 2 %@",saveImage,originImage);
        NSLog(@"6");
        [SharedAppDelegate.root setMyProfile:originImage filename:@"filename"];
        
        NSLog(@"7");
        [profileView setImage:newImage];
        
    }
    
    //    [self reloadImage];
}

- (void)deleteProfileImage{
    [profileView setImage:[CustomUIKit customImageNamed:@"imageview_defaultprofile.png"]];
}


//- (void)setMyProfileDelete
//{
//    NSString *urlString = [NSString stringWithFormat:@"http://%@:62230/",[SharedAppDelegate readPlist:@"con"]];
//    NSLog(@"urlString %@",urlString);
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
//
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uniqueid",@"delete",@"profileimage",[SharedAppDelegate readPlist:@"skey"],@"sessionkey",[SharedAppDelegate readPlist:@"was"],@"Was",nil];
//    NSLog(@"parameters %@",parameters);
//
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"setMyProfile.xfon" parameters:parameters];
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//
//    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSDictionary *resultDic = [[operation.responseString objectFromJSONString]objectatindex:0];
//        NSLog(@"resultDic %@",resultDic);
//        NSString *isSuccess = [resultDicobjectForKey:@"result"];
//        if ([isSuccess isEqualToString:@"0"]) {
//
//            NSString *fullPathToFile = [NSString stringWithFormat:@"%@/Documents/%@.JPG",NSHomeDirectory(),[[SharedAppDelegate readPlist:@"myinfo"]objectForKey:@"uniqueid"]];
//            NSLog(@"fullPathToFile %@",fullPathToFile);
//            NSFileManager *fm = [NSFileManager defaultManager];
//            if([fm removeItemAtPath:fullPathToFile error:nil]){
//                NSLog(@"if here");
//                [self reloadImage];
//            }
//
//        }
//        else {
//            NSString *msg = [NSString stringWithFormat:@"오류: %@ %@",isSuccess,[resultDicobjectForKey:@"resultMessage"]];
//            [CustomUIKit popupAlertViewOK:nil msg:msg];
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"FAIL : %@",operation.error);
//        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"사진을 삭제하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
////        [alert show];
//
//    }];
//
//    [operation start];
//
//
//
//}


- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 내 사진을 변경할 때 바로 서버와 통신하지 않고 사이즈 조절 후 통신하기 위해 사이즈를 조절.
     param  - sourceImage(UIImage *) : 변경할 이미지
     - newSize(CGSize) : 변경할 사이즈
     연관화면 : 내 상태 변경
     ****************************************************************/
    
    //    CGFloat targetWidth = newSize.width;
    //    CGFloat targetHeight = newSize.height;
    //
    //    CGImageRef imageRef = [sourceImage CGImage];
    //    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    //    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    //
    //    if (bitmapInfo == kCGImageAlphaNone) {
    //        bitmapInfo = kCGImageAlphaNoneSkipLast;
    //    }
    //
    //    CGContextRef bitmap;
    //
    //    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
    //        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    //
    //    } else {
    //        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
    //
    //    }
    //
    //    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
    //        CGContextRotateCTM (bitmap, radians(90));
    //        CGContextTranslateCTM (bitmap, 0, -targetHeight);
    //
    //    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
    //        CGContextRotateCTM (bitmap, radians(-90));
    //        CGContextTranslateCTM (bitmap, -targetWidth, 0);
    //
    //    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
    //        // NOTHING
    //    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
    //        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
    //        CGContextRotateCTM (bitmap, radians(-180.));
    //    }
    //
    //    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    //    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    //    UIImage* newImage = [UIImage imageWithCGImage:ref];
    //
    //    CGContextRelease(bitmap);
    //    CGImageRelease(ref);
    //
    //    return newImage;
    
    if (CGSizeEqualToSize(sourceImage.size, newSize))
    {
        return sourceImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
    
    //draw
    [sourceImage drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}



- (void)changeCoverImage:(UIImage *)image{
    NSLog(@"coverView.frame %@",NSStringFromCGRect(coverView.frame));
    
        NSLog(@"coverView image %@",coverView.image);
    UIImage *newImage = [SharedAppDelegate.root imageWithImage:image scaledToSize:CGSizeMake(320, coverView.frame.size.height)];

    NSData *saveImage = UIImageJPEGRepresentation(newImage, 0.8);
    [SharedAppDelegate.root setMyProfile:saveImage filename:@"timeline"];
//    [coverView setImage:newImage];
//    [self setMyInfoView];
    NSLog(@"coverView image %@",coverView.image);
    
}


- (void)refreshSetupButton
{
    
    NSLog(@"refresh!");
//    UIRemoteNotificationType types;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//        types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
//    }else{
//        types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//    }
//    
//    BOOL currentStatus = (types==UIRemoteNotificationTypeNone)?NO:YES;
    
    BOOL currentStatus = [SharedAppDelegate checkRemoteNotificationActivate];
    
    NSLog(@"currentStatus %@",currentStatus?@"YES":@"NO");
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
//        
//        currentStatus =  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
//    }
//    else{
//        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
//        if (types & UIRemoteNotificationTypeAlert)
//        {
//            currentStatus = YES;
//        }
//    }

    
//    UIButton *button = (UIButton*)[self.navigationItem.leftBarButtonItem.customView viewWithTag:32];
//    UIImageView *alertImage;
//    alertImage = [[UIImageView alloc]initWithFrame:CGRectMake(3,3,31,31)];
//    alertImage.image = [CustomUIKit customImageNamed:@"refresh.png"];
//    [button addSubview:alertImage];
//    [alertImage release];
//
    NSString *imageName;
    if (currentStatus == YES) {
//        alertImage.hidden = YES;
#ifdef BearTalk
        imageName = @"actionbar_btn_setting.png";
#else
        
        imageName = @"barbutton_main_setup.png";
#endif
    } else {
        //        alertImage.hidden = NO;
        imageName = @"barbutton_main_setup_alert.png";
//        		[setupButton setBackgroundImage:[UIImage imageNamed:@"barbutton_main_setup_alert.png"] forState:UIControlStateNormal];
        
    }
    [self performSelectorOnMainThread:@selector(changeSetup:) withObject:imageName waitUntilDone:NO];
    
}

- (void)changeSetup:(NSString *)imagename{
    [setupButton setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad");
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    [self setLempView];
    
}


- (void)setLempView{
    
    
    gkpicker = [[GKImagePicker alloc] init];
    if(scrollView){
        [scrollView removeFromSuperview];
//        [scrollView release];
        scrollView = nil;
    }
    
    scrollView = [[UIScrollView alloc]init];
    
    NSLog(@"setLempView self.view %@",NSStringFromCGRect(self.view.frame));
    
    
    float viewY = 64;
    
    
    scrollView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 49 - viewY);
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//        scrollView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height - 49 - 44 - 20);
    
    
#ifdef BearTalk
    
    setupButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadSetup:) frame:CGRectMake(0, 0, 25, 25) imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_setting.png" imageNamedPressed:nil];
    
    [self refreshSetupButton];
#else
    setupButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadSetup:) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"barbutton_main_setup.png" imageNamedPressed:nil];
#endif
    UIBarButtonItem *setupButtonItem = [[UIBarButtonItem alloc]initWithCustomView:setupButton];
    self.navigationItem.leftBarButtonItem = setupButtonItem;
//    [setupButtonItem release];
    [self refreshSetupButton];
    
    
#ifdef BearTalk
#else
    UIButton *noticeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadNotice:) frame:CGRectMake(0, 0, 33, 29) imageNamedBullet:nil imageNamedNormal:@"barbutton_main_notice.png" imageNamedPressed:nil];
    
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:noticeButton];
    linkButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadLink) frame:CGRectMake(0, 0, 26, 26)
                             imageNamedBullet:nil imageNamedNormal:@"barbutton_main_link.png" imageNamedPressed:nil];
#endif
    
#ifdef BearTalk
//    NSArray *arrBtns = [[NSArray alloc]initWithObjects:btnNavi, btnNaviLink, nil]; // 순서는 거꾸로
    self.navigationItem.rightBarButtonItem = setupButtonItem;
    self.navigationItem.leftBarButtonItem = nil;
#elif IVTalk
    UIBarButtonItem *btnNaviLink;
    btnNaviLink = [[UIBarButtonItem alloc]initWithCustomView:linkButton];
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:btnNavi, btnNaviLink, nil]; // 순서는 거꾸로
    self.navigationItem.rightBarButtonItems = arrBtns;
#else
    self.navigationItem.rightBarButtonItem = btnNavi;
#endif
//    [btnNavi release];
//    [noticeButton release];
//    [linkbutton release];
//    [btnNaviLink release];
//    [arrBtns release];
    
#ifdef BearTalk
#else
    nBadge = [[UIImageView alloc]init];
    nBadge.image = [[CustomUIKit customImageNamed:@"redbj.png"]stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [noticeButton addSubview:nBadge];
//    [nBadge release];
    nBadge.hidden = YES;
    
    nLabel = [[UILabel alloc]init];//WithImage:[UIImage imageNamed:@"push_top_badge.png"]];
    nLabel.frame = CGRectMake(4, 4, 15, 14);
    nLabel.text = @"";
    nLabel.textAlignment = NSTextAlignmentCenter;
    nLabel.textColor = [UIColor whiteColor];
    nLabel.backgroundColor = [UIColor clearColor];
    nLabel.font = [UIFont boldSystemFontOfSize:11];
    [nBadge addSubview:nLabel];
//    [nLabel release];
    
#endif
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:11], NSParagraphStyleAttributeName:paragraphStyle};
     CGSize size = [nLabel.text boundingRectWithSize:CGSizeMake(100, 14) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    CGSize size = [nLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:11] constrainedToSize:CGSizeMake(100, 14) lineBreakMode:NSLineBreakByWordWrapping];
    nBadge.frame = CGRectMake(18, 0, (size.width+12)<24?24:(size.width+12), 24);
    nLabel.frame = CGRectMake(0, 0, nBadge.frame.size.width-2, nBadge.frame.size.height-2);
    
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    self.view.backgroundColor = [UIColor whiteColor];//RGB(231, 232, 234);//RGB(223,220,217);
    scrollView.backgroundColor = [UIColor clearColor];
    
    
    NSDate *now = [NSDate date];;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    coverView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 174)];
    if(IS_HEIGHT568){
        coverView.frame = CGRectMake(0, 0, 320, 221);
        
    }
    
    [coverView setContentMode:UIViewContentModeScaleAspectFill];
    coverView.userInteractionEnabled = YES;
    [scrollView addSubview:coverView];
//    [coverView release];
    
    
    UIImageView *roundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,coverView.frame.size.width,coverView.frame.size.height)];
    roundView.userInteractionEnabled = YES;
    if(IS_HEIGHT568){
        roundView.image = [UIImage imageNamed:@"imageview_covergradation.png"];
    }
    else{
        roundView.image = [UIImage imageNamed:@"imageview_covergradation_480h.png"];
        
    }
    [coverView addSubview:roundView];
//    [roundView release];
    
    UIButton *button;
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(coverActionSheet:)
                                    frame:CGRectMake(0, 0, roundView.frame.size.width, roundView.frame.size.height) imageNamedBullet:nil
                         imageNamedNormal:nil imageNamedPressed:nil];
    
    [roundView addSubview:button];
//    [button release];
    
    
    myInfoView = [[UIImageView alloc]init];
    if(IS_HEIGHT568){
        myInfoView.frame = CGRectMake(0,coverView.frame.size.height+15-87,320,87+10+84);
    }
    else{
        myInfoView.frame = CGRectMake(0,coverView.frame.size.height+15-87,320,87+10+53);
        
    }
    myInfoView.userInteractionEnabled = YES;
    myInfoView.backgroundColor = [UIColor clearColor];
    
    
    profileView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 87, 87)];
    profileView.userInteractionEnabled = YES;
    //	[self reloadImage];
    [myInfoView addSubview:profileView];
    //	[SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"mynophoto.png" view:profileView scale:0];
    
    roundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height)];
    roundView.userInteractionEnabled = YES;
    roundView.image = [UIImage imageNamed:@"imageview_profileborder.png"];
    [profileView addSubview:roundView];
    
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(profileActionSheet:)
                                    frame:CGRectMake(0, 0, roundView.frame.size.width, roundView.frame.size.height) imageNamedBullet:nil
                         imageNamedNormal:nil imageNamedPressed:nil];
    
    [profileView addSubview:button];
//    [button release];
    
    name = [CustomUIKit labelWithText:@""
                             fontSize:20 fontColor:[UIColor whiteColor]
                                frame:CGRectMake(profileView.frame.origin.x + profileView.frame.size.width + 10, profileView.frame.origin.y + 6, 320 - profileView.frame.origin.x - profileView.frame.size.width - 10 - 10, 27) numberOfLines:1 alignText:NSTextAlignmentLeft];
    name.font = [UIFont boldSystemFontOfSize:20];
    [myInfoView addSubview:name];
    
    
    position = [CustomUIKit labelWithText:@""
                                 fontSize:12 fontColor:[UIColor whiteColor]
                                    frame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height, name.frame.size.width-30, 18) numberOfLines:1 alignText:NSTextAlignmentLeft];
    
    [myInfoView addSubview:position];
    
    //    team = [CustomUIKit labelWithText:@""
    //                             fontSize:14 fontColor:RGB(154, 157, 161)
    //                                frame:CGRectMake(name.frame.origin.x, name.frame.origin.y + name.frame.size.height + 2, 70, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
    //    [myInfoView addSubview:team];
    //
    
    UIButton *miniSetup = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadMyInfoSetup:) frame:CGRectMake(320-30, position.frame.origin.y+5, 30, 30) imageNamedBullet:nil imageNamedNormal:@"button_minipreference.png" imageNamedPressed:nil];
    [myInfoView addSubview:miniSetup];
    
    
    email = [CustomUIKit labelWithText:@""
                              fontSize:12 fontColor:[UIColor whiteColor]
                                 frame:CGRectMake(position.frame.origin.x, position.frame.origin.y + position.frame.size.height, position.frame.size.width, 18) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [myInfoView addSubview:email];
    
    
    message = [CustomUIKit labelWithText:@""
                                fontSize:11 fontColor:[UIColor blackColor]
                                   frame:CGRectMake(email.frame.origin.x, email.frame.origin.y + email.frame.size.height +2, name.frame.size.width, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [myInfoView addSubview:message];
    
    //    [self setMyInfoView];
    
    
    
    
    button = [[UIButton alloc]init];
    [button addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
    if(IS_HEIGHT568){
        button.frame = CGRectMake(9, 87+10, 95, 84);
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"imageview_mysocial.png"] forState:UIControlStateNormal];
        
    }
    else{
        button.frame = CGRectMake(9, 87+10, 95, 53);
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"imageview_mysocial_480h.png"] forState:UIControlStateNormal];
    }
    [myInfoView addSubview:button];
    button.tag = kMyWriting;
//    [button release];
    
    UILabel *label = [CustomUIKit labelWithText:@"내가쓴글"
                                       fontSize:14 fontColor:RGB(130, 130, 130)
                                          frame:CGRectMake(5, 30, 85, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    if(IS_HEIGHT568){
        label.frame = CGRectMake(5, 48, 85, 20);
        
    }
    [button addSubview:label];
    
    mineCount = [CustomUIKit labelWithText:@""
                                  fontSize:24 fontColor:[UIColor blackColor]
                                     frame:CGRectMake(5,0,85,30) numberOfLines:1 alignText:NSTextAlignmentCenter];
    if(IS_HEIGHT568){
        mineCount.frame = CGRectMake(5,15,85,30);
        
    }
    [button addSubview:mineCount];
    
    
    
    button = [[UIButton alloc]init];
    [button addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
    if(IS_HEIGHT568){
        button.frame = CGRectMake(9+95+9, 87+10, 95, 84);
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"imageview_mysocial.png"] forState:UIControlStateNormal];
        
    }
    else{
        button.frame = CGRectMake(9+95+9, 87+10, 95, 53);
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"imageview_mysocial_480h.png"] forState:UIControlStateNormal];
    }
    //    [CustomUIKit customImageNamed:@"comtviewbtn_02.png" block:^(UIImage *image) {
    //		[button setBackgroundImage:image forState:UIControlStateNormal];
    //	}];
    [myInfoView addSubview:button];
    button.tag = kBookmark;
//    [button release];
    label = [CustomUIKit labelWithText:@"북마크"
                              fontSize:14 fontColor:RGB(130, 130, 130)
                                 frame:CGRectMake(5, 30, 85, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    if(IS_HEIGHT568){
        label.frame = CGRectMake(5, 48, 85, 20);
        
    }
    [button addSubview:label];
    
    bookmarkCount = [CustomUIKit labelWithText:@""
                                      fontSize:24 fontColor:[UIColor blackColor]
                                         frame:mineCount.frame numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:bookmarkCount];
    
    
    button = [[UIButton alloc]init];
    [button addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventTouchUpInside];
    if(IS_HEIGHT568){
        button.frame = CGRectMake(9+95+9+95+9, 87+10, 95, 84);
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"imageview_mysocial.png"] forState:UIControlStateNormal];
        
    }
    else{
        button.frame = CGRectMake(9+95+9+95+9, 87+10, 95, 53);
        [button setBackgroundImage:[CustomUIKit customImageNamed:@"imageview_mysocial_480h.png"] forState:UIControlStateNormal];
    }
    [myInfoView addSubview:button];
    button.tag = kMemo;
//    [button release];
    label = [CustomUIKit labelWithText:@"메모"
                              fontSize:14 fontColor:RGB(130, 130, 130)
                                 frame:CGRectMake(5, 30, 85, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    if(IS_HEIGHT568){
        label.frame = CGRectMake(5, 48, 85, 20);
        
    }
    [button addSubview:label];
    
    memoCount = [CustomUIKit labelWithText:@""
                                  fontSize:24 fontColor:[UIColor blackColor]
                                     frame:bookmarkCount.frame numberOfLines:1 alignText:NSTextAlignmentCenter];
    [button addSubview:memoCount];
    
    
    
    

    scrollView.bounces = YES;
    scrollView.alwaysBounceVertical = YES;
    
    isCoverChanging = NO;
    
    scheduleView = [[UIImageView alloc]initWithFrame:CGRectMake(myInfoView.frame.origin.x, myInfoView.frame.origin.y + myInfoView.frame.size.height + 10, myInfoView.frame.size.width,28+67)];
    scheduleView.userInteractionEnabled = YES;
    scheduleView.backgroundColor = [UIColor clearColor];
    
    
    button = [[UIButton alloc]initWithFrame:CGRectMake(0,0,scheduleView.frame.size.width,scheduleView.frame.size.height)];
    [button addTarget:self action:@selector(showSchedule:) forControlEvents:UIControlEventTouchUpInside];
    [scheduleView addSubview:button];
//    [button release];
    
    
    UIImageView *tab = [[UIImageView alloc]initWithFrame:CGRectMake(9,0,302,28)];
    tab.image = [UIImage imageNamed:@"imageview_scheduletab.png"];
    [scheduleView addSubview:tab];
//    [tab release];
    
    
    
    labelSchedule = [CustomUIKit labelWithText:@"일정"
                                      fontSize:15 fontColor:[UIColor grayColor]
                                         frame:CGRectMake(10, 0, 100,28) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [tab addSubview:labelSchedule];
    
    
    UIImageView *closure = [[UIImageView alloc]initWithFrame:CGRectMake(tab.frame.size.width-9-10,7,9,14)];
    closure.image = [UIImage imageNamed:@"imageview_disclosure.png"];
    [tab addSubview:closure];
//    [closure release];
    
    UIImageView *body = [[UIImageView alloc]initWithFrame:CGRectMake(tab.frame.origin.x,tab.frame.size.height,tab.frame.size.width,67)];
    body.image = [UIImage imageNamed:@"imageview_schedulebody.png"];
    [scheduleView addSubview:body];
//    [body release];
    
    
    UIImageView *todayBody = [[UIImageView alloc]initWithFrame:CGRectMake(7,7,89, 53)];
    todayBody.image = [UIImage imageNamed:@"imageview_scheduletoday.png"];
    [body addSubview:todayBody];
//    [todayBody release];
    
    
    
    [formatter setDateFormat:@"MM/dd EE"];
    
    nowDate = [CustomUIKit labelWithText:[NSString stringWithString:[formatter stringFromDate:now]]
                                fontSize:16 fontColor:RGB(30, 111, 192)
                                   frame:CGRectMake(5, 5, todayBody.frame.size.width - 10, 24) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [todayBody addSubview:nowDate];
    
    
    int daysToAdd = 1;
    NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    [formatter setDateFormat:@"EE"];
    
    
    label1 = [CustomUIKit labelWithText:[formatter stringFromDate:newDate1]
                               fontSize:16 fontColor:RGB(108, 108, 108)
                                  frame:CGRectMake(todayBody.frame.origin.x + todayBody.frame.size.width + 5, todayBody.frame.origin.y + nowDate.frame.origin.y, 38, nowDate.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [body addSubview:label1];
    
    
    daysToAdd = 2;
    NSDate *newDate2 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    
    label2 = [CustomUIKit labelWithText:[formatter stringFromDate:newDate2]
                               fontSize:16 fontColor:label1.textColor
                                  frame:CGRectMake(label1.frame.origin.x + label1.frame.size.width, label1.frame.origin.y, label1.frame.size.width, label1.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [body addSubview:label2];
    
    
    daysToAdd = 3;
    NSDate *newDate3 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    
    
    label3 = [CustomUIKit labelWithText:[formatter stringFromDate:newDate3]
                               fontSize:16 fontColor:label2.textColor
                                  frame:CGRectMake(label2.frame.origin.x + label2.frame.size.width, label2.frame.origin.y, label2.frame.size.width, label2.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [body addSubview:label3];
    
    
    
    daysToAdd = 4;
    NSDate *newDate4 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    
    
    label4 = [CustomUIKit labelWithText:[formatter stringFromDate:newDate4]
                               fontSize:16 fontColor:label3.textColor
                                  frame:CGRectMake(label3.frame.origin.x + label3.frame.size.width, label3.frame.origin.y, label3.frame.size.width, label3.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [body addSubview:label4];
    
    
    UILabel *label5 = [CustomUIKit labelWithText:@"미래"
                                        fontSize:16 fontColor:label4.textColor
                                           frame:CGRectMake(label4.frame.origin.x + label4.frame.size.width, label4.frame.origin.y, label4.frame.size.width, label4.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [body addSubview:label5];
    
    //    UILabel *label6 = [CustomUIKit labelWithText:@"미래"
    //                                        fontSize:16 fontColor:label5.textColor
    //                                           frame:CGRectMake(label5.frame.origin.x + label5.frame.size.width, label5.frame.origin.y, label5.frame.size.width, label5.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    //    [body addSubview:label6];
    
    
    
    
    labelToday = [CustomUIKit labelWithText:@""
                                   fontSize:20 fontColor:RGB(30, 111, 192)
                                      frame:CGRectMake(nowDate.frame.origin.x, nowDate.frame.origin.y + nowDate.frame.size.height, nowDate.frame.size.width, nowDate.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [todayBody addSubview:labelToday];
    
    
    label1st = [CustomUIKit labelWithText:@""
                                 fontSize:20 fontColor:RGB(108, 108, 108)
                                    frame:CGRectMake(label1.frame.origin.x, label1.frame.origin.y + label1.frame.size.height, label1.frame.size.width, label1.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [body addSubview:label1st];
    
    label2nd = [CustomUIKit labelWithText:@""
                                 fontSize:20 fontColor:label1st.textColor
                                    frame:CGRectMake(label2.frame.origin.x, label2.frame.origin.y + label2.frame.size.height, label2.frame.size.width, label2.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [body addSubview:label2nd];
    label3rd = [CustomUIKit labelWithText:@""
                                 fontSize:20 fontColor:label1st.textColor
                                    frame:CGRectMake(label3.frame.origin.x, label3.frame.origin.y + label3.frame.size.height, label3.frame.size.width, label3.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [body addSubview:label3rd];
    label4th = [CustomUIKit labelWithText:@""
                                 fontSize:20 fontColor:label1st.textColor
                                    frame:CGRectMake(label4.frame.origin.x, label4.frame.origin.y + label4.frame.size.height, label4.frame.size.width, label4.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [body addSubview:label4th];
    label5th = [CustomUIKit labelWithText:@""
                                 fontSize:20 fontColor:label1st.textColor
                                    frame:CGRectMake(label5.frame.origin.x, label5.frame.origin.y + label5.frame.size.height, label5.frame.size.width, label5.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [body addSubview:label5th];
    
    //    label6th = [CustomUIKit labelWithText:@""
    //                                 fontSize:20 fontColor:label1st.textColor
    //                                    frame:CGRectMake(label6.frame.origin.x, label6.frame.origin.y + label6.frame.size.height, label6.frame.size.width, label6.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    //    [body addSubview:label6th];
    
    labelSum = [CustomUIKit labelWithText:@"모두보기"
                                 fontSize:15 fontColor:[UIColor grayColor]
                                    frame:CGRectMake(0, 0, closure.frame.origin.x - 5, tab.frame.size.height)//CGRectMake(320-100-10-25-10,4+2,100,20)
                            numberOfLines:1 alignText:NSTextAlignmentRight];
    [tab addSubview:labelSum];
    
    
    
    
    
    [scrollView addSubview:myInfoView];
    [scrollView addSubview:scheduleView];
    
    
    
    
//    [myInfoView release];
//        [buttonView release];
//    [scheduleView release];
    
//    [formatter release];
    
    NSLog(@"end");
}

- (void)setMyInfoView{
    
    NSLog(@"setMyInfoView");
    
    
    
    NSDictionary *mydic = [SharedAppDelegate readPlist:@"myinfo"];
    NSDictionary *dic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
    NSLog(@"mydic %@",mydic);
    NSLog(@"dic %@",dic);
    [SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"imageview_defaultprofile.png" view:profileView scale:0];
    
    
    name.text = dic[@"name"];
    
    
    if([dic[@"grade2"]length]>0)
    {
        if([dic[@"team"]length]>0){
            position.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
#ifdef Batong
            position.text = [NSString stringWithFormat:@"%@ | %@",dic[@"team"],dic[@"grade2"]];
#endif
        }
        else
            position.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
    }
    else if([dic[@"team"]length]>0)
        position.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
    else{
        position.text = @"";
    }
    NSLog(@"team %@",position.text);
    
    email.text = dic[@"email"];
    message.text = [SharedAppDelegate readPlist:@"employeinfo"];
    
    
//    NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@_privatetimelinetemp.JPG",NSHomeDirectory(),dic[@"uid"]];
//    NSLog(@"filePath %@",filePath);
//    coverView.image = [UIImage imageWithContentsOfFile:filePath];
//    //    coverView.image = [CustomUIKit customImageNamed:@"imageview_defaultcover.png"];
//    NSLog(@"coverView image %@",coverView.image);
    //
//    if(coverView.image == nil){
//        NSURL *url = [ResourceLoader resourceURLfromJSONString:[SharedAppDelegate readPlist:@"privatetimelineimage"] num:0 thumbnail:NO];
//        UIImage *image = [CustomUIKit customImageNamed:@"imageview_defaultcover_480h.png"];
//        
//        if(IS_HEIGHT568){
//            image = [CustomUIKit customImageNamed:@"imageview_defaultcover.png"];
//        }
//            [coverView sd_setImageWithPreviousCachedImageWithURL:url andPlaceholderImage:image options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b)  {
//            }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
//                NSLog(@"fail %@",[error localizedDescription]);
//                NSData *data = UIImageJPEGRepresentation(image, 1.0);
//                [data writeToFile:filePath atomically:YES];
//                
//                [HTTPExceptionHandler handlingByError:error];
//                
//            }];
//    
//        
//    }
    
    [SharedAppDelegate.root getCoverImage:[ResourceLoader sharedInstance].myUID view:coverView ifnil:@""];
    
}

- (void)dayChanged{
    NSDate *now = [NSDate date];
    NSLog(@"now %@",now);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"EEEE"];
    //    nowDay.text = [formatter stringFromDate:now];
    [formatter setDateFormat:@"MM/dd EE"];
    nowDate.text = [formatter stringFromDate:now];
    
    NSLog(@"nowDay %@ nowDate %@",nowDay.text,nowDate.text);
    
    
    int daysToAdd = 1;
    NSDate *newDate = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    [formatter setDateFormat:@"EE"];
    label1.text = [formatter stringFromDate:newDate];
    daysToAdd++;
    newDate = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    label2.text = [formatter stringFromDate:newDate];
    daysToAdd++;
    newDate = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    label3.text = [formatter stringFromDate:newDate];
    daysToAdd++;
    newDate = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    label4.text = [formatter stringFromDate:newDate];
    
    NSLog(@"label1 %@ label2 %@ label3 %@ label4 %@",label1.text,label2.text,label3.text,label4.text);
//    [formatter release];
}

- (void)callWebView:(id)sender
{
    NSURL *url;
    UIButton *button = (UIButton*)sender;
    if (button.tag == 1 || button.tag == 5) {
        url = [NSURL URLWithString:@"http://www.nec.go.kr"];
    } else if (button.tag == 4 || button.tag == 6) {
        url = myHomeURL;
    } else {
        url = nil;
    }
    
    if (url == nil || [[url absoluteString] length] == 0 || !([[url scheme] isEqualToString:@"http"] || [[url scheme] isEqualToString:@"https"])) {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"홈페이지가 준비되지 않았습니다." con:self];
        return;
    }
    WebBrowserViewController *webViewController = [[WebBrowserViewController alloc] initWithURL:url];
    //	webViewController.isSimpleMode = YES;
    [webViewController loadURL];
    UINavigationController *navigationViewController = [[CBNavigationController alloc] initWithRootViewController:webViewController];
    navigationViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    navigationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navigationViewController animated:YES completion:nil];
    
//    [webViewController release];
//    [navigationViewController release];
}



- (void)cmdButton:(id)sender{
    
    switch ([sender tag]) {
        case kSchedule:
        {
            //			[SharedAppDelegate.root settingScheduleList];
            //			ScheduleCalendarViewController *sCalView = [[ScheduleCalendarViewController alloc] initWithNibName:nil bundle:nil];
            //			[self.navigationController pushViewController:sCalView animated:YES];
            //			[sCalView release];
            //			ScheduleCalendarViewController *sCalView = [[ScheduleCalendarViewController alloc] initWithNibName:nil bundle:nil];
            [SharedAppDelegate.root.scal setNeedsRefresh:YES];
            [SharedAppDelegate.root.scal setCallTodayCalendar:YES];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.scal];
            [SharedAppDelegate.root anywhereModal:nc];
            //			[sCalView release];
//            [nc release];
            break;
        }
        case kMemo:
        {
            //			[SharedAppDelegate.root settingMemoList];
            MemoListViewController *mlist = [[MemoListViewController alloc]init];
            //			[self.navigationController pushViewController:mlist animated:YES];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:mlist];
            [SharedAppDelegate.root anywhereModal:nc];
//            [mlist release];
//            [nc release];
            break;
        }
        case kBookmark:
        {
            //            [SharedAppDelegate.root settingMine];
#ifdef BearTalk
            
            [SharedAppDelegate.root settingBookmark:nil];
#else
            HomeTimelineViewController *myHome = [[HomeTimelineViewController alloc] init];
            //            SharedAppDelegate.root.home.timeLineCells = nil;
            myHome.title = @"북마크";
            myHome.titleString = myHome.title;
            [myHome getTimeline:@"" target:@"" type:@"10" groupnum:@""];
            //			[self.navigationController pushViewController:myHome animated:YES];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:myHome];
            [SharedAppDelegate.root anywhereModal:nc];
//            [myHome release];
//            [nc release];
#endif
            break;
        }
        case kMyWriting:
        {
            //			[SharedAppDelegate.root settingBookmark];
            
#ifdef BearTalk
            
            [SharedAppDelegate.root settingMine:nil];
#else
            HomeTimelineViewController *myHome = [[HomeTimelineViewController alloc] init];
            //            SharedAppDelegate.root.home.timeLineCells = nil;
            myHome.title = @"내가 쓴 글";//[SharedAppDelegate readPlist:@"myinfo"][@"name"];
            myHome.titleString = myHome.title;
            [myHome getTimeline:@"" target:[ResourceLoader sharedInstance].myUID type:@"3" groupnum:@""];
            //			[self.navigationController pushViewController:myHome animated:YES];
            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:myHome];
            [SharedAppDelegate.root anywhereModal:nc];
//            [myHome release];
//            [nc release];
#endif
            break;
        }
            //		case 5:
            //		{
            ////			[SharedAppDelegate.root loadSetup];
            //            break;
            //		}
    }
}

- (void)loadLink{
    
    NSString *urlString;
#ifdef IVTalk
    urlString = @"http://scmw.ivplus.co.kr:8282/mobileLogin.do?";
    NSString *bodyString = [NSString stringWithFormat:@"userId=%@&isLemp=Y",[SharedAppDelegate readPlist:@"myinfo"][@"uid"]];
    
    NSString *absoluteString = [urlString stringByAppendingString:bodyString];
    
    BOOL chromeInstalled = [[UIApplication sharedApplication] openURL:
                            [NSURL URLWithString:@"googlechrome://"]];;
    
    NSString *chromeScheme = nil;
    if ([absoluteString hasPrefix:@"http"]) {
        chromeScheme = @"googlechrome";
    } else if ([absoluteString hasPrefix:@"https"]) {
        chromeScheme = @"googlechromes";
    }
    
    
    NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
    NSString *urlNoScheme = [absoluteString substringFromIndex:rangeForScheme.location];
    NSString *chromeURLString = [chromeScheme stringByAppendingString:urlNoScheme];
    
    NSURL *chromeURL = [NSURL URLWithString:chromeURLString];
    NSLog(@"chromeinstall %@",chromeInstalled?@"YES":@"NO");
    NSLog(@"chromeURL %@",chromeURL);
    if(chromeInstalled){
        [[UIApplication sharedApplication] openURL:chromeURL];
        
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:absoluteString]];
        
    }
    
    return;
#else
    
//    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": userAgent}];
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *callDate = [formatter stringFromDate:now];
    urlString = @"https://www.daewoong.co.kr/daewoongkr/background/sso.web";
    NSString *aesCallDate = [AESExtention aesEncryptStringWithKey:@"#TALKTODAEWOONG$" text:callDate];
//    NSString *encodeCallDate = [aesCallDate stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *dwgroup = [AESExtention aesEncryptStringWithKey:@"#TALKTODAEWOONG$" text:@"dwgroup"];
//    NSString *encodedwgroup = [dwgroup stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *aesURL = [AESExtention aesEncryptStringWithKey:@"#TALKTODAEWOONG$" text:@"https://www.daewoong.co.kr/daewoongkr/promote/promote_membersvideo_list.web"];
//    NSString *encodeURL = [aesURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    
    
    NSString *encodeCallDate = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                     NULL,
                                                                                                     (CFStringRef)aesCallDate,
                                                                                                     NULL,
                                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                     kCFStringEncodingUTF8 ));
    NSString *encodedwgroup = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)dwgroup,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    NSString *encodeURL = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                NULL,
                                                                                                (CFStringRef)aesURL,
                                                                                                NULL,
                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                kCFStringEncodingUTF8 ));
    
    NSString *bodyString = [NSString stringWithFormat:@"callDate=%@&id=%@&url=%@",encodeCallDate,encodedwgroup,encodeURL];
    
#endif
    NSURL *url;
        url = [NSURL URLWithString:urlString];
    WebBrowserViewController *webViewController = [[WebBrowserViewController alloc] initWithURL:url];
    
    [webViewController loadURLwithBody:bodyString];
    UINavigationController *navigationViewController = [[CBNavigationController alloc] initWithRootViewController:webViewController];
    navigationViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    navigationViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navigationViewController animated:YES completion:nil];
    
//    [webViewController release];
//    [navigationViewController release];
}
#define kSubStatus 100

- (void)loadMyInfoSetup:(id)sender{
    
    SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubStatus];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
    [self presentViewController:nc animated:YES completion:nil];
//    [sub release];
//    [nc release];
}

- (void)loadSetup:(id)sender{
    
//    SetupViewController *setup = [[SetupViewController alloc] init];
    //			[self.navigationController pushViewController:setup animated:YES];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.setup];
    [SharedAppDelegate.root anywhereModal:nc];
//    [setup release];
//    [nc release];
}



#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    return 70;
//}
//
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [noticeList count]==0?1:[noticeList count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"cellforrow");
//
//    static NSString *myTableIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
//
//
//    UILabel *nameT, *lastWordT, *positionT, *timeT, *teamT, *toLabelT, *arrLabelT;
//    UIImageView *profileViewT;//, *bgView;
//
//
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myTableIdentifier]autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//
//
//        //        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//
//		nameT = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(55, 7, 70, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        nameT.tag = 1;
//        nameT.font = [UIFont boldSystemFontOfSize:14];
//		[cell.contentView addSubview:nameT];
//        //        [name release];
//
//		lastWordT = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(55, 23, 240, 46) numberOfLines:2 alignText:NSTextAlignmentLeft];
//        lastWordT.tag = 2;
//		[cell.contentView addSubview:lastWordT];
//        //        [lastWord release];
//
//		positionT = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(55, 5, 60, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        positionT.tag = 3;
//		[cell.contentView addSubview:positionT];
//        //        [position release];
//
//		teamT = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(55, 5, 60, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        teamT.tag = 6;
//		[cell.contentView addSubview:teamT];
//        //        [team release];
//
//		toLabelT = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(120, 5, 55, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        toLabelT.tag = 5;
//        toLabelT.font = [UIFont systemFontOfSize:14];
//		[cell.contentView addSubview:toLabelT];
//
//        arrLabelT = [CustomUIKit labelWithText:nil fontSize:14 fontColor:RGB(64,88,115) frame:CGRectMake(120, 5, 55, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        arrLabelT.tag = 9;
//        arrLabelT.font = [UIFont systemFontOfSize:14];
//        [cell.contentView addSubview:arrLabelT];
//
//		profileViewT = [[UIImageView alloc]init];
//		profileViewT.frame = CGRectMake(0, 0, 50, 50);
//        profileViewT.tag = 4;
//		[cell.contentView addSubview:profileViewT];
//        [profileViewT release];
//
//		timeT = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(5, 50+3, 40, 12) numberOfLines:1 alignText:NSTextAlignmentCenter];
//        timeT.tag = 8;
//		[cell.contentView addSubview:timeT];
//
//
//        //		time = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(5, 44, 40, 15) numberOfLines:1 alignText:NSTextAlignmentCenter];
//        //        time.tag = 8;
//        //		[cell.contentView addSubview:time];
//
//
//    }
//
//    else{
//        nameT = (UILabel *)[cell viewWithTag:1];
//        lastWordT = (UILabel *)[cell viewWithTag:2];
//        toLabelT = (UILabel *)[cell viewWithTag:5];
//        arrLabelT = (UILabel *)[cell viewWithTag:9];
//        positionT = (UILabel *)[cell viewWithTag:3];
//        teamT = (UILabel *)[cell viewWithTag:6];
//        profileViewT = (UIImageView *)[cell viewWithTag:4];
//        timeT = (UILabel *)[cell viewWithTag:8];
//    }
//
//    if([noticeList count]==0){
//        NSLog(@"noticeList %@",noticeList);
//        nameT.text = @"새로운 알림이 없습니다.";
//        lastWordT.text = @"";
//        positionT.text = @"";
//        teamT.text = @"";
//        profileViewT.image = nil;
//        nameT.frame = CGRectMake(0, 25, 300, 16);
//        nameT.textAlignment = NSTextAlignmentCenter;
//        timeT.text = @"";
//        toLabelT.text = @"";
//        arrLabelT.text = @"";
//
//    }
//
//    else{
//        nameT.frame = CGRectMake(55, 7, 70, 16);
//        nameT.textAlignment = NSTextAlignmentLeft;
//        NSDictionary *dic = noticeList[indexPath.row];
//        timeT.text = [NSString calculateDate:dic[@"operatingtime"]];
//        lastWordT.text = dic[@"noticemsg"];
//
//        NSString *infoType = dic[@"writeinfotype"];
//
//        NSDictionary *personDic = [dic[@"writeinfo"]objectFromJSONString];
//
//        if([infoType isEqualToString:@"2"]){
//
//            nameT.text = personDic[@"deptname"];
//            //        name.textColor = RGB(160, 18, 19);
//            positionT.text = @"";
//            teamT.text = @"";
//            //        [SharedAppDelegate.root getThumbImageWithURL:personDic[@"image"] ifNil:@"sns_profile_company.png" view:noticeProfileView scale:0];
//            NSURL *url = [ResourceLoader resourceURLfromJSONString:personDic[@"image"] num:0 thumbnail:YES];
//
//            [profileViewT setImageWithURL:url placeholderImage:[UIImage imageNamed:@"sns_profile_company.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly success:^(UIImage *image, BOOL cached) {
//
//            } failure:^(NSError *error) {
//                NSLog(@"fail %@",[error localizedDescription]);
//                [HTTPExceptionHandler handlingByError:error];
//
//            }];
//        }
//        else if([infoType isEqualToString:@"3"]){
//
//
//            nameT.text = personDic[@"companyname"];
//            //        name.textColor = RGB(160, 18, 19);
//            positionT.text = @"";
//            teamT.text = @"";
//            //        [SharedAppDelegate.root getThumbImageWithURL:personDic[@"image"] ifNil:@"sns_profile_company.png" view:noticeProfileView scale:0];
//            NSURL *url = [ResourceLoader resourceURLfromJSONString:personDic[@"image"] num:0 thumbnail:YES];
//            [profileViewT setImageWithURL:url placeholderImage:[UIImage imageNamed:@"sns_profile_company.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly success:^(UIImage *image, BOOL cached) {
//
//            } failure:^(NSError *error) {
//                NSLog(@"fail %@",[error localizedDescription]);
//                [HTTPExceptionHandler handlingByError:error];
//
//            }];
//        }
//        else if([infoType isEqualToString:@"4"]){
//
//
//            nameT.text = personDic[@"text"];
//            //        name.textColor = RGB(160, 18, 19);
//            positionT.text = @"";
//            teamT.text = @"";
//            //        [SharedAppDelegate.root getThumbImageWithURL:personDic[@"image"] ifNil:@"sns_systeam.png" view:noticeProfileView scale:0];
//            NSURL *url = [ResourceLoader resourceURLfromJSONString:personDic[@"image"] num:0 thumbnail:YES];
//            [profileViewT setImageWithURL:url placeholderImage:[UIImage imageNamed:@"sns_systeam.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly success:^(UIImage *image, BOOL cached) {
//                
//            } failure:^(NSError *error) {
//                NSLog(@"fail %@",[error localizedDescription]);
//                [HTTPExceptionHandler handlingByError:error];
//                
//            }];
//        }
//        else if([infoType isEqualToString:@"1"]){
//            nameT.text = personDic[@"name"];
//            //        name.textColor = RGB(87, 107, 149);
//            positionT.text = personDic[@"position"];
//            teamT.text = personDic[@"deptname"];
//            [SharedAppDelegate.root getProfileImageWithURL:dic[@"uid"] ifNil:@"profile_photo.png" view:profileViewT scale:0];
//            
//        }
//        else if([infoType isEqualToString:@"10"]){
//            nameT.text = @"";
//            positionT.text = @"";
//            teamT.text = @"";
//            [profileViewT setImage:[UIImage imageNamed:@"profile_photo.png"]];
//            
//        }
//        
//        CGSize size = [nameT.text sizeWithFont:nameT.font];
//        positionT.frame = CGRectMake(nameT.frame.origin.x + (size.width+5>70?70:size.width+5), nameT.frame.origin.y, 60, 16);
//        
//        CGSize size2 = [positionT.text sizeWithFont:positionT.font];
//        teamT.frame = CGRectMake(positionT.frame.origin.x + (size2.width+5>60?60:size2.width+5), positionT.frame.origin.y, 60, 16);
//        CGSize size3 = [teamT.text sizeWithFont:teamT.font];
//        arrLabelT.frame = CGRectMake(teamT.frame.origin.x + (size3.width+5>60?60:size3.width+5), teamT.frame.origin.y, 15, 16);
//        toLabelT.frame = CGRectMake(teamT.frame.origin.x + (size3.width+5>60?60:size3.width+5) +15, teamT.frame.origin.y, 60 -5, 16);
//        
//        
//        if([[dic[@"target"]objectFromJSONString][@"category"]isEqualToString:@"1"]){
//            toLabelT.text = @"";
//            arrLabelT.text = @"";
//        }
//        else{
//            toLabelT.text = [NSString stringWithFormat:@"%@",[dic[@"target"]objectFromJSONString][@"categoryname"]];
//            arrLabelT.text = @"➤";
//        }
//        
//        
//    }
//    return cell;
//}
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//    if([noticeList count] == 0){
//        
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        
//        return;
//    }
//    NSLog(@"indexpath.row %@",noticeList[indexPath.row]);
//    [SharedAppDelegate.root.home loadDetail:noticeList[indexPath.row][@"contentindex"] inModal:NO con:self];
//    
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}

@end
