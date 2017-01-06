//
//  DetailViewController.m
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 11. 15..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ActivityTableViewCell.h"
#import "PhotoViewController.h"
#import "PostViewController.h"
#import <objc/runtime.h>
#import "PhotoTableViewController.h"
#import "UIImage+Resize.h"
#import "WebViewController.h"
#import "GoogleMapViewController.h"
#import "MapViewController.h"


#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

#define MAX_MESSAGEEND_LINE 3

static int g_viewSizeHeight[MAX_MESSAGEEND_LINE] = {61, 80, 99};
static int g_areaSizeHeight[MAX_MESSAGEEND_LINE] = {43, 62, 81};
static int g_textSizeHeight[MAX_MESSAGEEND_LINE] = {20, 39, 58};


@interface ActivityDetailViewController ()

@end

const char paramDic;
const char paramNumber;
const char paramUrl;

@implementation ActivityDetailViewController

@synthesize replyTextView;
@synthesize contentsData;

- (id)init//WithViewCon:(UIViewController *)viewcon//NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(refreshProfiles)
													 name:@"refreshProfiles"
												   object:nil];
		self.hidesBottomBarWhenPushed = YES;
		self.moveTab = NO;
        viewReply = NO;
	}
    return self;
}

- (void)refreshProfiles
{
	NSLog(@"refreshProfiles");
	[myTable reloadData];
}

- (void)dealloc
{
	[likeArray release];
    [readArray release];
    [replyArray release];
    [groupArray release];
	[myTable release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)setViewToReply{
    
    viewReply = YES;
}

- (void)backTo//:(id)sender
{
    
    NSLog(@"backTo");
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	if (YES == self.moveTab) {
		NSInteger selectTabIndex;
			selectTabIndex = kTabIndexSocial;
		
		
		if (selectTabIndex < 999) {
			UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
			if (SharedAppDelegate.root.mainTabBar.selectedIndex != selectTabIndex) {
				if ([SharedAppDelegate.root.mainTabBar.tabBar isHidden]) {
					[nv popToRootViewControllerWithBlockGestureAnimated:NO];
				}
				[SharedAppDelegate.root.mainTabBar setSelectedIndex:selectTabIndex];
				nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
				
				if ([nv.viewControllers count] > 1) {
					[nv popToRootViewControllerWithBlockGestureAnimated:NO];
				}
			}
			
			if (selectTabIndex == kTabIndexMessage) {
				[SharedAppDelegate.root.note setReserveRefresh:YES];
				if ([SharedAppDelegate.root.mainTabBar.viewControllers count] > kTabIndexMessage) {
					UINavigationController *naviCon = (UINavigationController*)[SharedAppDelegate.root.mainTabBar.viewControllers objectAtIndex:kTabIndexMessage];
					if ([[naviCon viewControllers] count] > 0) {
						MHTabBarController *subTab = (MHTabBarController*)[[naviCon viewControllers] objectAtIndex:0];
						[subTab setSelectedIndex:kSubTabIndexNote];
						
						UINavigationController *subNaviCon = (UINavigationController*)subTab.selectedViewController.navigationController;
						if ([[subNaviCon viewControllers] count] > 1) {
							[subNaviCon popToRootViewControllerWithBlockGestureAnimated:NO];
						}
					}
				}
			}
		}
	} else {
        
	}
	
	if (self.presentingViewController && [self.navigationController.viewControllers count] == 1) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		[self.navigationController popViewControllerWithBlockGestureAnimated:YES];
	}
    
    
    
    
    
}


#define kDeleteReply 100
#define kDeletePost 200

#define kEdit 1
#define kGroup 2
#define kReply 3
#define kPhoto 4
#define kActionReply 5

- (void)editPost
{
    NSLog(@"editPost");
    UIActionSheet *actionSheet;
    
    if(contentsData.isNotice == YES){// isEqualToString:@"1"]) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                        destructiveButtonTitle:nil otherButtonTitles:@"삭제", nil];
    } else{// if([contentsData.notice isEqualToString:@"0"]) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                        destructiveButtonTitle:nil otherButtonTitles:@"수정", @"삭제", nil];
        }
//        else {
//			return;
//		}
    
    
    [actionSheet showInView:SharedAppDelegate.window];
    actionSheet.tag = kEdit;
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == kGroup){
        
        if(buttonIndex == 0){
            [self movePostToCate:@"1" toGroup:@""];
        }
        else{
           
            if(buttonIndex == [groupArray count])
                return;
            
            NSLog(@"grouparray %@",groupArray);
            [self movePostToCate:@"2" toGroup:groupArray[buttonIndex][@"groupnumber"]];
            
            
        }
        
    }
    else if(actionSheet.tag == kEdit) {
        
        
        if(contentsData.isNotice == YES){//notice isEqualToString:@"0"]){
            
            switch (buttonIndex) {
                case 0:
                    [self deletePost];
                    break;
                default:
                    break;
            }
            }
            else{
                switch (buttonIndex) {
                    case 0:
                        [self modifyPost];
                        break;
//                    case 1:
//                        [self showGroupActionsheet];
//                        break;
                    case 1:
                        [self deletePost];
                        break;
                    default:
                        break;
                }
            }
        
    }
    else if(actionSheet.tag == kPhoto){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        switch (buttonIndex) {
            case 0:
                picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:picker animated:YES];
                break;
            case 1:
                [SharedAppDelegate.root launchQBImageController:1 con:self];
                break;
            default:
                break;
        }
    }
    else if(actionSheet.tag == kActionReply){
        switch (buttonIndex) {
            case 0:
                [self modifyReply:actionSheet];
                break;
            case 1:
                [self deleteReply:actionSheet];
                break;
            default:
                break;
        }
        
    }
   
}


- (void)movePostToCate:(NSString *)newcate toGroup:(NSString *)newnum{
    
//    [SharedAppDelegate.root
//     modifyPost:contentsData.idx
//     modify:3
//     msg:@""
//     oldcategory:[contentsData.targetdic objectFromJSONString][@"category"]
//     newcategory:newcate
//     oldgroupnumber:[contentsData.targetdic objectFromJSONString][@"categorycode"]
//     newgroupnumber:newnum target:@"" replyindex:@"" viewcon:self];
    
}

- (void)deletePost{
    
//    UIAlertView *alert;
//    
//    alert = [[UIAlertView alloc] initWithTitle:@"삭제" message:@"정말 삭제하시겠습니까?" delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
//    alert.tag = kDeletePost;
//    [alert show];
//    [alert release];
    
    [CustomUIKit popupAlertViewOK:@"삭제" msg:@"정말 삭제하시겠습니까?" delegate:self tag:kDeletePost];
    
}


#define kPost 2
#define kReply 3

- (void)modifyPost{
	
//    PostViewController *post = [[PostViewController alloc] initWithStyle:kPost];//WithViewCon:self];
//    
//    post.title = @"글 수정";
//    [post setModifyView:contentsData.contentDic[@"msg"] idx:contentsData.idx tag:kPost];
//    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
//    [self presentModalViewController:nc animated:YES];
//    [post release];
//    [nc release];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1)
    {
        if(alertView.tag == kDeletePost)
        {
            
//        [SharedAppDelegate.root modifyPost:contentsData.idx
//                                        modify:1 msg:@""
//                                   oldcategory:@""
//                                   newcategory:@"" oldgroupnumber:@"" newgroupnumber:@"" target:contentsData.targetdic replyindex:@"" viewcon:self];
    }
        else if(alertView.tag == kDeleteReply)     {
            NSString *number = objc_getAssociatedObject(alertView, &paramNumber);
            [self cmdDeleteReply:number];
        }
        
        
    }
    else{
    }
    
}

- (void)cmdDeleteReply:(NSString *)replyNum{
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
	[client setAuthorizationHeaderWithToken:[ResourceLoader sharedInstance].mySessionkey];

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                contentsData.cid,@"activity_id",
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                replyNum,@"id",
//                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                nil];
    NSLog(@"parameter %@",parameters);
    NSMutableURLRequest *request = [client requestWithMethod:@"DELETE" path:@"/capi/youwin/activity/reply" parameters:parameters];
    NSLog(@"request %@",request);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self getActivityReply];
        NSLog(@"ResulstDic %@",operation.responseString);
   
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
   
        
    }];
    
	[operation start];
//    [operation start];

}
- (void)showGroupActionsheet{
    
    groupArray = [[NSMutableArray alloc]init];
    
    
    for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
        NSLog(@"dic %@",dic);
        if([dic[@"accept"]isEqualToString:@"Y"])
        {
            [groupArray addObject:dic];
        }
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil
                                               destructiveButtonTitle:nil otherButtonTitles:nil];
    for(NSDictionary *dic in groupArray){
        [actionSheet addButtonWithTitle:dic[@"groupname"]];
    }
    [actionSheet addButtonWithTitle:@"취소"];
    [actionSheet setCancelButtonIndex:[groupArray count]];
    //    [actionSheet showInView:self.parentViewController.tabBarController.view];
    [actionSheet showInView:SharedAppDelegate.window];
    actionSheet.tag = kGroup;
    //    [array release];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"viewwillAppear");
    
    [self getActivityReply];
//  [self getReply];
    //    [self setSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //    [SharedAppDelegate.root.home getTimeline:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [replyTextView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



#define kNotFavorite 1
#define kFavorite 2
#define kNothing 3

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    self.title = @"활동 일지";
    
    NSLog(@"contentsdata %@",contentsData);
	
    NSLog(@"self.presenting %@",self.presentingViewController);
    
    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
    [btnNavi release];
	
    self.view.backgroundColor = RGB(255, 255, 255);//RGB(240, 235, 232);
    replyHeight = 0.0f;
    
    replyView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-61, 320, 0)];
    NSLog(@"replyview %@",NSStringFromCGRect(replyView.frame));
    replyView.userInteractionEnabled = YES;
    replyView.image = [[UIImage imageNamed:@"dv_btmtab_bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:30];//[UIImage imageNamed:@"n01_dt_writdtn_bg.png"];
    
    photoBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,replyView.frame.origin.y - 123,320,123)];
    photoBackgroundView.image = [UIImage imageNamed:@"btm_dropbg.png"];
    photoBackgroundView.userInteractionEnabled = YES;
    
    photoView = [[UIImageView alloc]init];
    [photoBackgroundView addSubview:photoView];
    [photoView release];
    
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(320-38,0,38,38)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"mmbtm_location_del.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closePhoto) forControlEvents:UIControlEventTouchUpInside];
    [photoBackgroundView addSubview:closeButton];
    [closeButton release];
    
    UIButton *photoButton = [[UIButton alloc]initWithFrame:CGRectMake(4,9,0,0)];//33,43)];
//    [photoButton setBackgroundImage:[UIImage imageNamed:@"photo_addbtn.png.png"] forState:UIControlStateNormal];
//    [photoButton addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
//    [replyView addSubview:photoButton];
    [photoButton release];
    
    replyTextViewBackground = [[UIImageView alloc]init];
    replyTextViewBackground.frame = CGRectMake(4+photoButton.frame.size.width+4-4, 9, 220+33+4, 43);
    replyTextViewBackground.image = [[UIImage imageNamed:@"comtviewbg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:15];//[UIImage imageNamed:@"n01_dt_writdtn.png"];
    replyTextViewBackground.userInteractionEnabled = YES;
    [replyView addSubview:replyTextViewBackground];
    [replyTextViewBackground release];
    
    replyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 12, replyTextViewBackground.frame.size.width - 5, replyTextViewBackground.frame.size.height - 23)];
	[replyTextView setFont:[UIFont systemFontOfSize:14]];
	[replyTextView setContentInset:UIEdgeInsetsMake(-8, 0, -8, 0)];
	[replyTextView setDelegate:self];
    [replyTextView setBackgroundColor:[UIColor clearColor]];
	[replyTextViewBackground addSubview:replyTextView];
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 9, replyTextView.frame.size.width-15, 20)];
	[placeHolderLabel setNumberOfLines:1];
	[placeHolderLabel setFont:[UIFont systemFontOfSize:14.0]];
	[placeHolderLabel setBackgroundColor:[UIColor clearColor]];
	[placeHolderLabel setLineBreakMode:UILineBreakModeCharacterWrap];
	[placeHolderLabel setTextColor:[UIColor grayColor]];
	[placeHolderLabel setText:@"댓글을 남기세요."];
	[replyTextView addSubview:placeHolderLabel];
    [replyTextView release];
    replyTextView.selectedRange = NSMakeRange(0,0);
    [placeHolderLabel release];
    
    sendButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(sendReply:) frame:CGRectMake(replyTextViewBackground.frame.origin.x+replyTextViewBackground.frame.size.width+4, 9, 50, 43) imageNamedBullet:nil imageNamedNormal:@"send_btn_dft.png" imageNamedPressed:nil];
    [replyView addSubview:sendButton];
    [sendButton release];
    
    [self.view addSubview:replyView];
    [replyView release];
    replyView.hidden = YES;
    
    replyArray = [[NSMutableArray alloc]init];
    readArray = [[NSMutableArray alloc]init];
    likeArray = [[NSMutableArray alloc]init];
    
    
    float viewY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewY = 44 + 20;
    } else {
        viewY = 44;
        
    }
    
	CGRect tableFrame;
	    tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY - self.tabBarController.tabBar.frame.size.height);
	
    
    myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    myTable.backgroundColor = [UIColor clearColor];
    myTable.bounces = NO;
    myTable.delegate = self;
    myTable.dataSource = self;
    myTable.scrollsToTop = YES;
    myTable.userInteractionEnabled = YES;
    [self.view addSubview:myTable];
    
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    //    [myTable release];
    
//    readLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 35, 200, 14)];
//    [readLabel setTextAlignment:UITextAlignmentLeft];
//    [readLabel setTextColor:[UIColor grayColor]];
//    [readLabel setFont:[UIFont systemFontOfSize:11]];
//    //		[nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
//    [readLabel setBackgroundColor:[UIColor clearColor]];
//    //	[readLabel setText:@"0명 읽음"];
//    [myTable addSubview:readLabel];
//    [readLabel release];
//    
//    favButton = [[UIButton alloc]initWithFrame:CGRectMake(320-36-10, 7, 36, 36)];
//    [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_dft.png"] forState:UIControlStateNormal];
//    [favButton addTarget:self action:@selector(addOrClear:) forControlEvents:UIControlEventTouchUpInside];
//    favButton.adjustsImageWhenHighlighted = NO;
//    favButton.tag = kNotFavorite;
//    [myTable addSubview:favButton];
//    [favButton release];
//    
//    if([contentsData.contentType isEqualToString:@"8"] || [contentsData.contentType isEqualToString:@"9"])
//        favButton.hidden = YES;
//    else
//        favButton.hidden = NO;
    
    [self.view addSubview:photoBackgroundView];
    [photoBackgroundView release];
    photoBackgroundView.hidden = YES;
    
    //    myTable.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"datview_bg.png"]];
    
    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    NSDictionary *tDic = [contentsData.targetdic objectFromJSONString];
//    NSLog(@"contentsData.targetdic %@",tDic);
//    self.title = tDic[@"categoryname"];
//    
//    if([tDic[@"category"]isEqualToString:@"1"] || [tDic[@"category"]isEqualToString:@"5"]){
//        
//        if([contentsData.idx intValue]>[[SharedAppDelegate readPlist:@"0"]intValue])
//            [SharedAppDelegate writeToPlist:@"0" value:contentsData.idx];
//        
//    }
//    else if([tDic[@"category"]isEqualToString:@"2"]){
//        
//        if([contentsData.idx intValue]>[[SharedAppDelegate readPlist:tDic[@"categorycode"]]intValue])
//            [SharedAppDelegate writeToPlist:tDic[@"categorycode"] value:contentsData.idx];
//    }
//    else if([tDic[@"category"]isEqualToString:@"3"]){
//        if([contentsData.contentType isEqualToString:@"7"]){
//            
//			[SharedAppDelegate.root.mainTabBar writeLastIndexForMode:@"lastnote" value:contentsData.idx];
//			if ([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]) {
//				self.title = @"보낸쪽지";
//			} else {
//				self.title = @"받은쪽지";
//			}
//            
//        }
//        else if([contentsData.contentType isEqualToString:@"8"]){
//            
//            [SharedAppDelegate.root.mainTabBar writeLastIndexForMode:@"lastschedule" value:contentsData.idx];
//      
//        }
//    }
    NSLog(@"detail viewDidLoad %@ %@",contentsData.uid,[ResourceLoader sharedInstance].myUID);
  
    
//    if([contentsData.uid isEqualToString:[ResourceLoader sharedInstance].myUID]){// && [contentsData.writeinfoType isEqualToString:@"1"]){
//        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editPost) frame:CGRectMake(0, 0, 32, 32)
//                             imageNamedBullet:nil imageNamedNormal:@"etcmenu_btn.png" imageNamedPressed:nil];
//        
//        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//        self.navigationItem.rightBarButtonItem = btnNavi;
//        [btnNavi release];
//        
//    }
    
    
    msgLineCount = 1;
    isResizing = NO;
    
    
    tagArray = [[NSMutableArray alloc]init];
    //    [myTable reloadData];
    
    
    //    [self getReply];
    
    
    
    
}


- (void)closePhoto{//:(id)sender{
    
	if (selectedImageData) {
		[selectedImageData release];
		selectedImageData = nil;
	}
    
    photoBackgroundView.hidden = YES;
}


- (void)addPhoto:(id)sender{
    
    UIActionSheet *actionSheet = nil;
    
    
    
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", nil];
    actionSheet.tag = kPhoto;
    
    
    [actionSheet showInView:SharedAppDelegate.window];
    
}



#pragma mark -
#pragma mark UIImagePicker Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    
	[picker dismissModalViewControllerAnimated:YES];
	[picker release];
}







- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    NSLog(@"ipicker %@",info);
    
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self sendPhoto:image];
        [picker dismissModalViewControllerAnimated:YES];
        [picker release];
    } else {
        
    }
    
    
}

- (void)qbimagePickerController:(QBImagePickerController *)picker didFinishPickingMediaWithInfo:(id)info
{
    NSLog(@"info %@",info);
    NSArray *mediaInfoArray = (NSArray *)info;
    UIImage *image = mediaInfoArray[0][UIImagePickerControllerOriginalImage];
    
    PhotoViewController *photoViewCon = [[[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] autorelease];
    [picker presentModalViewController:photoViewCon animated:YES];
}
- (void)sendPhoto:(UIImage*)image
{
	
	if(image.size.width > 640 || image.size.height > 960) {
		image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
	}
	
	if (selectedImageData) {
		[selectedImageData release];
		selectedImageData = nil;
	}
	selectedImageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
    
    
	CGSize imageSize = [UIImage imageWithData:selectedImageData].size;
	CGFloat imageScale = imageSize.height/100;
    imageSize.width = imageSize.width/imageScale;
    
    if(imageSize.width>290)
        imageSize.width = 290;
    
    
    
	photoView.frame = CGRectMake(10,10,imageSize.width, 100);
    photoView.image = image;
    
    
    photoBackgroundView.hidden = NO;
    
    
    
	
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightfor");
	NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
    
    
    if(indexPath.row == 0){
        float height = 0.0f;
        
        height += 6 + 35;
        
        height += 10 + 17;

        height += 5 + 150;
        
        
        
        NSString *content = contentsData.desc;//.contentDic[@"msg"];
        CGSize cSize = [SharedFunctions textViewSizeForString:content font:[UIFont systemFontOfSize:fontSize] width:295 realZeroInsets:NO];
        if([content length]>0)
            height += 10 + cSize.height + 5;
       
        NSArray *imageArray = contentsData.urlArray;//.contentDic[@"image"];
        
        
        
        if([imageArray count]>1)//imageString != nil && [imageString length]>0)
        {
            
//            CGFloat imageHeight = 0.0f;
//            for(int i = 1; i < [imageArray count]; i++){
//                UIImageView *inImageView = [[UIImageView alloc]init];
//                inImageView.backgroundColor = [UIColor blackColor];
//                [inImageView setContentMode:UIViewContentModeScaleAspectFill];//AspectFill];//AspectFit];//ToFill];
//                [inImageView setClipsToBounds:YES];
//                //                        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:imageArray[i] num:i thumbnail:YES];
//                NSURL *imgURL = [NSURL URLWithString:imageArray[i]];
//                NSLog(@"imageURL %@",imgURL);
//                [inImageView setImageWithURL:imgURL placeholderImage:nil options:SDWebImageRetryFailed success:^(UIImage *image, BOOL cached) {
//                    CGFloat imageScale = 0.0f;
//                    NSLog(@"inimageveiw %@",inImageView.image);
//                    if(inImageView.image.size.width>290.0f){
//                        imageScale = inImageView.image.size.width/290.0f;
//                    }
//                    else{
//                        imageScale = 290.0f/inImageView.image.size.width;
//                        
//                    }
//                    inImageView.frame = CGRectMake(0,imageHeight,290.0f,inImageView.image.size.height/imageScale);//imageScale *
//                    
//                } failure:^(NSError *error) {
//                    NSLog(@"fail %@",[error localizedDescription]);
//                    [HTTPExceptionHandler handlingByError:error];
//                    
//                }];
//                
//                NSLog(@"inimageview frame %@",NSStringFromCGRect(inImageView.frame));
//                imageHeight += inImageView.frame.size.height + 10;
//                
//                
//                
//                
//            }
//            height += imageHeight;

            height += 395 *([imageArray count]-1);
            
            
            
            
        }
        
        height += 10;
        
        return height;
    }
    
    else{
        
            if(indexPath.row == 1){
                
                return 41;
            }
            else{
                
                float height = 0;
                
                if([replyArray count]>0){
                    
                    NSDictionary *dic = replyArray[indexPath.row-2];
                    height += 5 + 16;
                    height += 2 + 16;
                    
                    
                    NSString *replyCon = dic[@"desc"];
                    for(NSDictionary *replyDic in replyArray){
                        
                        NSString *searchName = replyDic[@"username"];//[NSString stringWithFormat:@"@%@",[replyDic[@"writeinfo"]objectFromJSONString][@"name"]];
//                        NSLog(@"searchName %@",searchName);
                        NSRange range = [replyCon rangeOfString:searchName];
                        if (range.length > 0){
                            NSLog(@"String contains");
                            NSString *htmlString = [NSString stringWithFormat:@"<font color=\"#a01213\">%@</font>",[searchName substringWithRange:NSMakeRange(1,[searchName length]-1)]];
                            
                            replyCon = [replyCon stringByReplacingOccurrencesOfString:searchName withString:htmlString];
                         
                        }
                    }
                    
                    replyCon = [replyCon stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
          
                    
                     CGSize replySize = [SharedFunctions textViewSizeForString:replyCon font:[UIFont systemFontOfSize:fontSize] width:255 realZeroInsets:NO];
                    height += replySize.height + 2;
                    
                    
                    
                }
                return height;
                
            }
            
        
    }
    
    
}


#pragma mark - menu controller menu items



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return [replyArray count]+2;
}


#define kActivity 2

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"tagArray %@",tagArray);
    
        if(indexPath.row == 1 && [likeArray count]>0)
            [SharedAppDelegate.root.home pushGood:likeArray con:self tag:kActivity];
        
    
}

- (void)tagName:(id)sender{
    
    
    NSDictionary *replyDic = [SharedAppDelegate.root searchContactDictionary:[[sender titleLabel]text]];
    if([replyDic[@"uniqueid"]length]<1 || replyDic[@"uniqueid"]==nil)
    {
        [CustomUIKit popupAlertViewOK:nil msg:@"직원 정보가 없습니다."];
        return;
    }
    BOOL alreadyTag = NO;
    NSLog(@"tagArray %@",tagArray);
    for(NSDictionary *dic in tagArray){
        if([dic[@"uniqueid"]isEqualToString:[[sender titleLabel]text]])
            alreadyTag = YES;
    }
    NSLog(@"alreadyTag %@",alreadyTag?@"YES":@"NO");
    if(!alreadyTag)
        [tagArray addObject:replyDic];
    
    [placeHolderLabel setHidden:YES];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_prs.png"] forState:UIControlStateNormal];
    
    
    NSString *contentsToAdd = [NSString stringWithFormat:@"@%@",replyDic[@"name"]];
    NSLog(@"contentstoAdd %@",contentsToAdd);
    NSRange cursorPosition = [replyTextView selectedRange];
    NSLog(@"replytextview %@",replyTextView.text);
    NSMutableString *tfContent = [[NSMutableString alloc]initWithString:[replyTextView text]];
    NSLog(@"location %d",(int)cursorPosition.location);
    [tfContent insertString:contentsToAdd atIndex:cursorPosition.location];
    NSLog(@"replytextview %@",tfContent);
    [replyTextView setText:tfContent];
    [tfContent release];
    
    //    replyTextView.text = [replyTextView.text stringByAppendingFormat:@"@%@ ",replyDic[@"name"]];
    
    
    NSInteger oldLineCount = msgLineCount;
    
    NSInteger lineCount = (NSInteger)((replyTextView.contentSize.height - 16) / replyTextView.font.lineHeight);
    
    if (msgLineCount != lineCount) {
        if (lineCount > MAX_MESSAGEEND_LINE)
            msgLineCount = MAX_MESSAGEEND_LINE;
        else
            msgLineCount = lineCount;
    }
    
    if (msgLineCount != oldLineCount)
        [self viewResizeUpdate:msgLineCount];
    
    [replyTextView setSelectedRange:NSMakeRange([replyTextView.text length], 0)];
    
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
#define kLike 1
#define kDislike 2

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
    
    if(indexPath.row == 0){
        
        
        UIImageView *profileImageView;
        profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 35, 35)];
        NSLog(@"contentsdata.profile %@",contentsData.uid);
        profileImageView.userInteractionEnabled = YES;
        
        UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,profileImageView.frame.size.width,profileImageView.frame.size.height)];
        viewButton.adjustsImageWhenHighlighted = NO;
        [viewButton addTarget:self action:@selector(goToYourTimeline:) forControlEvents:UIControlEventTouchUpInside];
        viewButton.titleLabel.text = contentsData.uid;
        [profileImageView addSubview:viewButton];
        [viewButton release];
        
        contentView = [[UIImageView alloc]initWithFrame:CGRectMake(profileImageView.frame.origin.x, profileImageView.frame.origin.y + profileImageView.frame.size.height + 10, 308, 0)];
        
        UILabel *nameLabel;
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileImageView.frame.origin.x + profileImageView.frame.size.width + 5, 12, 80, 16)];
        [nameLabel setTextAlignment:UITextAlignmentLeft];
        //		[nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:14]];
        //		[nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        
        //
        UILabel *positionLabel;
        positionLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(nameLabel.frame.origin.x + [nameLabel.text length] * 14, nameLabel.frame.origin.y, 80, 16)];
        [positionLabel setBackgroundColor:[UIColor clearColor]];
        [positionLabel setTextColor:[UIColor grayColor]];
        [positionLabel setFont:[UIFont systemFontOfSize:14]];
        
        
        UILabel *teamLabel;
        teamLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(positionLabel.frame.origin.x + [positionLabel.text length] * 14, positionLabel.frame.origin.y, 80, 16)];
        [teamLabel setBackgroundColor:[UIColor clearColor]];
        [teamLabel setTextColor:[UIColor grayColor]];
        [teamLabel setFont:[UIFont systemFontOfSize:14]];

        
            [nameLabel setTextColor:RGB(87, 107, 149)];
        [nameLabel setText:[[ResourceLoader sharedInstance] getUserName:contentsData.uid]];
            CGSize size = [nameLabel.text sizeWithFont:nameLabel.font];
            positionLabel.frame = CGRectMake(nameLabel.frame.origin.x + (size.width+5>80?80:size.width+5), nameLabel.frame.origin.y, 80, 16);
        [positionLabel setText:contentsData.position];//personInfo[@"position"]];
            CGSize size2 = [positionLabel.text sizeWithFont:positionLabel.font];
            teamLabel.frame = CGRectMake(positionLabel.frame.origin.x + (size2.width+5>80?80:size2.width+5), positionLabel.frame.origin.y, 80, 16);
        [teamLabel setText:contentsData.deptName];//.personInfo[@"deptname"]];
            
			[SharedAppDelegate.root getProfileImageWithURL:contentsData.uid ifNil:@"profile_photo.png" view:profileImageView scale:24];
	
        
        
        
        timeLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(whLabel.frame.origin.x, contentImageView.frame.origin.y + contentImageView.frame.size.height + 6, whLabel.frame.size.width, 13)];//(3, 42, 38, 13)];
        NSString *linuxString = [NSString stringWithFormat:@"%.0f",contentsData.createdTimeInterval];
        [timeLabel setText:[NSString formattingDate:linuxString withFormat:@"yyyy년 MM월 dd일 a h시 mm분"]];//dateString];
        
        
        timeLabel.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 5, 300 - nameLabel.frame.origin.x, 13);
        [timeLabel setTextAlignment:UITextAlignmentLeft];
        [timeLabel setTextColor:[UIColor darkGrayColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:12]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        
        
        UIImageView *whImageView = [[UIImageView alloc]init];//WithFrame:CGRectMake(12, defaultView.frame.origin.y + defaultView.frame.size.height, 12, 17)];
        whImageView.image = [UIImage imageNamed:@"location_ic.png"];
         whImageView.frame = CGRectMake(10, 0, 12, 17);
        [contentView addSubview:whImageView];
        
        UILabel *whLabel;
        whLabel = [[UILabel alloc]init];
        [whLabel setTextAlignment:UITextAlignmentLeft];
        [whLabel setFont:[UIFont systemFontOfSize:14]];
        [whLabel setBackgroundColor:[UIColor clearColor]];
        [whLabel setTextColor:RGB(216, 68, 60)];
        whLabel.userInteractionEnabled = YES;
        [contentView addSubview:whLabel];
        
        whLabel.frame = CGRectMake(whImageView.frame.origin.x + whImageView.frame.size.width + 5, whImageView.frame.origin.y, 300 - whImageView.frame.origin.x - whImageView.frame.size.width, 16);
        
        
        
        UIButton *mapLabelButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0 - 5,whLabel.frame.size.width,whLabel.frame.size.height+5)];
        mapLabelButton.backgroundColor = [UIColor clearColor];
        [mapLabelButton addTarget:self action:@selector(viewMap:) forControlEvents:UIControlEventTouchUpInside];
        [whLabel addSubview:mapLabelButton];
        [mapLabelButton release];
        
        
//        NSDictionary *activityDic = nil; // ###
        
//        NSString *where = contentsData.contentDic[@"jlocation"];
//        NSDictionary *dic = [where objectFromJSONString];
        [whLabel setText:contentsData.address];//[NSString stringWithFormat:@"%@",dic[@"text"]]];//activityDic[@"address"]]];
       
         UIImageView *mapImageView;
         mapImageView = [[UIImageView alloc]init];
        mapImageView.userInteractionEnabled = YES;
        mapImageView.frame = CGRectMake(whImageView.frame.origin.x, whImageView.frame.origin.y + whImageView.frame.size.height + 5, 290, 150);
        
//        [mapImageView setContentMode:UIViewContentModeScaleAspectFill];
//        [mapImageView setClipsToBounds:YES];
//        NSLog(@"contentsData.type %@",contentsData.type);
        NSURL *imgURL = [NSURL URLWithString:contentsData.urlArray[0]];

        [mapImageView setImageWithURL:imgURL placeholderImage:nil options:SDWebImageRetryFailed success:^(UIImage *image, BOOL cached) {
            
        } failure:^(NSError *error) {
            NSLog(@"fail %@",[error localizedDescription]);
            [HTTPExceptionHandler handlingByError:error];
            
        }];
        
         [contentView addSubview:mapImageView];
        
        UIImageView *round = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,mapImageView.frame.size.width,mapImageView.frame.size.height)];
        round.image = [[CustomUIKit customImageNamed:@"gmapround.png"] stretchableImageWithLeftCapWidth:7 topCapHeight:7];
        [mapImageView addSubview:round];
        [round release];
        
        UIButton *viewImageButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,mapImageView.frame.size.width,mapImageView.frame.size.height)];
        [viewImageButton addTarget:self action:@selector(viewImage:) forControlEvents:UIControlEventTouchUpInside];
        viewImageButton.tag = 0;
        [mapImageView addSubview:viewImageButton];
        [viewImageButton release];
        
        
        UITextView *contentsTextView;
        contentsTextView = [[UITextView alloc] init];//WithFrame:CGRectMake(5, 0, 295, contentSize.height + 25)];
                [contentsTextView setTextAlignment:UITextAlignmentLeft];
        contentsTextView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        [contentsTextView setDataDetectorTypes:UIDataDetectorTypeLink];
        [contentsTextView setFont:[UIFont systemFontOfSize:fontSize]];
        [contentsTextView setBackgroundColor:[UIColor clearColor]];
        [contentsTextView setEditable:NO];
        [contentsTextView setDelegate:self];
        
        [contentsTextView setScrollEnabled:NO];
        [contentsTextView sizeToFit];
     
         
        NSString *content = contentsData.desc;//.contentDic[@"msg"];
         CGSize cSize = [SharedFunctions textViewSizeForString:content font:[UIFont systemFontOfSize:fontSize] width:295 realZeroInsets:NO];
         if([content length]>0)
         contentsTextView.frame = CGRectMake(mapImageView.frame.origin.x, mapImageView.frame.origin.y + mapImageView.frame.size.height + 10, 270, cSize.height + 5);
         else
         contentsTextView.frame = CGRectMake(mapImageView.frame.origin.x, mapImageView.frame.origin.y + mapImageView.frame.size.height, 270, 0);
         [contentsTextView setText:content];
         
         [contentView addSubview:contentsTextView];
        
        
        
        contentImageView = [[UIImageView alloc]init];
         [contentView addSubview:contentImageView];
        contentView.userInteractionEnabled = YES;
         
        NSArray *imageArray = contentsData.urlArray;//.contentDic[@"image"];
        
         
                if([imageArray count]>1)//imageString != nil && [imageString length]>0)
                {
                    contentImageView.userInteractionEnabled = YES;
                    
                    
//                    NSArray *imageArray = [imageString objectFromJSONString][@"thumbnail"];
                    CGFloat imageHeight = 0.0f;
                    for(int i = 1; i < [imageArray count]; i++){// imageScale * [sizeDic[@"height"]floatValue]);
//                        NSDictionary *sizeDic;
//                        if([[imageString objectFromJSONString][@"thumbnailinfoarray"]count]>0)
//                            sizeDic = [imageString objectFromJSONString][@"thumbnailinfoarray"][i];
//                        else
//                            sizeDic = [imageString objectFromJSONString][@"thumbnailinfo"];
//                        NSLog(@"sizeDic %@",sizeDic);
//                        imageScale = 290.0f/[sizeDic[@"width"]floatValue];
                        UIImageView *inImageView = [[UIImageView alloc]init];
                        inImageView.frame = CGRectMake(0,imageHeight,290.0f,385);//imageScale *
                        inImageView.backgroundColor = [UIColor blackColor];
                        [inImageView setContentMode:UIViewContentModeScaleAspectFill];//AspectFill];//AspectFit];//ToFill];
                        [inImageView setClipsToBounds:YES];
//                        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:imageArray[i] num:i thumbnail:YES];
                        NSURL *imgURL = [NSURL URLWithString:imageArray[i]];
                        NSLog(@"imageURL %@",imgURL);
                        [inImageView setImageWithURL:imgURL placeholderImage:nil options:SDWebImageRetryFailed success:^(UIImage *image, BOOL cached) {
//                            CGFloat imageScale = 0.0f;
//                            NSLog(@"inimageveiw %@",inImageView.image);
//                            if(inImageView.image.size.width>290.0f){
//                            imageScale = inImageView.image.size.width/290.0f;
//                        }
//                        else{
//                            imageScale = 290.0f/inImageView.image.size.width;
//                            
//                        }
							
						} failure:^(NSError *error) {
							NSLog(@"fail %@",[error localizedDescription]);
							[HTTPExceptionHandler handlingByError:error];
                            
						}];
						
                        NSLog(@"inimageview frame %@",NSStringFromCGRect(inImageView.frame));
                        imageHeight += inImageView.frame.size.height + 10;
                   
                        [contentImageView addSubview:inImageView];
                        inImageView.userInteractionEnabled = YES;
                        
                        UIButton *viewImageButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,inImageView.frame.size.width,inImageView.frame.size.height)];
                        //                        [viewImageButton setBackgroundImage:[UIImage imageNamed:@"datview_bg.png"] forState:UIControlStateNormal];
                        [viewImageButton addTarget:self action:@selector(viewImage:) forControlEvents:UIControlEventTouchUpInside];
                        viewImageButton.tag = i;
                        [inImageView addSubview:viewImageButton];
                        [viewImageButton release];
                        [inImageView release];
                       
                        
                    }
                    
                    
                    contentImageView.frame = CGRectMake(10, contentsTextView.frame.origin.y + contentsTextView.frame.size.height + 5, 290, imageHeight);
                    
                    
                    NSLog(@"contentImage %@",contentImageView);
                    //        defaultView.frame = CGRectMake(45.0, 5.0, 230.0, nameLabel.frame.size.height + contentsLabel.frame.size.height + 12 + 160);
                }
                else{
                    
                    contentImageView.frame = CGRectMake(10, contentsTextView.frame.origin.y + contentsTextView.frame.size.height, 290, 0);
                }
        
        
                
                contentView.frame = CGRectMake(profileImageView.frame.origin.x, profileImageView.frame.origin.y + profileImageView.frame.size.height + 10, 308, contentImageView.frame.origin.y + contentImageView.frame.size.height);
        
         
        
   
        
        
        
        [cell.contentView addSubview:profileImageView];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:timeLabel];
        [cell.contentView addSubview:teamLabel];
        [cell.contentView addSubview:positionLabel];
        
        [cell.contentView addSubview:contentView];

        [profileImageView release];
        [nameLabel release];
        [teamLabel release];
         [positionLabel release];
         [timeLabel release];
         
        [contentImageView release];
        [contentsTextView release];
        [whImageView release];
        [whLabel release];
         [mapImageView release];
        [contentView release];

        
        
    }
    else{
        
            if(indexPath.row == 1){
                NSLog(@"LIKE!!!!!!!!!!!");
                
                //        likeImageView = [[UIImageView alloc]init];
                //        likeImageView.userInteractionEnabled = YES;
                UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dv_good_tabbg.png"]];
                cell.backgroundView = image;
                [image release];
                //[UIImageView ][UIImage imageNamed:@"goodline_bg.png"];
                //        likeImageView.frame = CGRectMake(0,
                //                                         0,
                //                                         320,
                //                                         35);
                
                
                
                //        [cell.contentView addSubview:likeImageView];
                
                likeButton = [[UIButton alloc]init];
                [likeButton addTarget:self action:@selector(sendLike:) forControlEvents:UIControlEventTouchUpInside];
                likeButton.tag = kLike;
                
                likeButton.frame = CGRectMake(10, 6, 44, 28);
                [cell.contentView addSubview:likeButton];
                
                
                likeCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 0, 18, 26)];
                likeCountLabel.text = @"0";
                [likeCountLabel setFont:[UIFont systemFontOfSize:14.0]];
                [likeCountLabel setTextAlignment:UITextAlignmentCenter];
                [likeCountLabel setBackgroundColor:[UIColor clearColor]];
                [likeCountLabel setTextColor:[UIColor whiteColor]];
                [likeButton addSubview:likeCountLabel];
                
                detailLike = [[UIImageView alloc]init];
                detailLike.image = [UIImage imageNamed:@"n06_nocal_ary.png"];
                detailLike.frame = CGRectMake(315-10, 13, 7, 13);
                [cell.contentView addSubview:detailLike];
                
                
                
                
                likeCountLabel.text = [NSString stringWithFormat:@"%d",(int)[likeArray count]];
                
                [likeButton setBackgroundImage:[UIImage imageNamed:@"good_btn_dft.png"] forState:UIControlStateNormal];
                
                if([likeArray count]>0)
                {
                    for(NSDictionary *dic in likeArray){
                        if([dic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID]) {
                            [likeButton setBackgroundImage:[UIImage imageNamed:@"good_btn_prs.png"] forState:UIControlStateNormal];
                            likeButton.tag = kDislike;
							break;
						}
                    }
                    
                    
                    detailLike.hidden = NO;
                    
                    
                    
                    //    if([likeArray count] > 0)
                    //    {
                    UIImageView *thumbImageView;
                    UIImageView *likeProfileImageView;
                    for(int i = 0; i < [likeArray count]; i++)
                    {
                        if(i > 5)
                            break;
                        
                        likeProfileImageView = [[UIImageView alloc]init];
                        likeProfileImageView.frame = CGRectMake(60.0 + 35 * i, 7, 28, 28);
                        //            [likeProfileImageView setImage:[SharedAppDelegate.root getImage:[[array i]objectForKey:@"uid"] ifNil:@"n01_tl_list_profile.png"]];
						[SharedAppDelegate.root getProfileImageWithURL:likeArray[i][@"uid"] ifNil:@"goodnophoto.png" view:likeProfileImageView scale:0];
                        [cell.contentView addSubview:likeProfileImageView];
                        [likeProfileImageView release];
                        
                        
                        
                        thumbImageView = [[UIImageView alloc]init];
                        thumbImageView.frame = CGRectMake(0, 0, 28, 28);
                        [thumbImageView setImage:[UIImage imageNamed:@"goodphoto_cover.png"]];
                        [likeProfileImageView addSubview:thumbImageView];
                        [thumbImageView release];
                        
                    }
                    
                    if ([likeArray count] > 6) {
                        UIImageView *moreLike = [[UIImageView alloc]init];
                        moreLike.image = [UIImage imageNamed:@"n01_tl_list_profile_more.png"];
                        moreLike.frame = CGRectMake(315-10-32, 6, 26, 26);
                        [cell.contentView addSubview:moreLike];
                        [moreLike release];
                    }
                    //        replyImageView.frame = CGRectMake(defaultView.frame.origin.x,
                    //                                          defaultView.frame.size.height,
                    //                                          defaultView.frame.size.width-7,
                    //                                          likeImageView.frame.size.height + 5);
                    
                    
                    //    }
                    //    else{
                    //    }
                    //
                    UIButton *likeMemberButton;
                    likeMemberButton = [[UIButton alloc]initWithFrame:CGRectMake(40, 4, 315-40, 30)];
                    [likeMemberButton addTarget:self action:@selector(goodMember:) forControlEvents:UIControlEventTouchUpInside];
                    likeMemberButton.tag = [contentsData.likeArray count];
                    [cell.contentView addSubview:likeMemberButton];
                    
                }
                else{
                    detailLike.hidden = YES;
                }
                [likeButton release];
                [likeCountLabel release];
                [detailLike release];
                
                
                
            }
            else{
                
                //                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,cell.frame.size.width,cell.frame.size.height)];
                
                
                cell.contentView.backgroundColor = RGB(255, 255, 255);//RGB(246,246,246);
                
                
                //            double preHeight = 0.0f;
                if([replyArray count]>0){
                    NSDictionary *dic = replyArray[indexPath.row-2];
                    NSLog(@"replyArray dic %@",dic);
                    //            {
                    //                UIImageView *replyImageView;
                    //                replyImageView = [[UIImageView alloc]init];
                    //                replyImageView.userInteractionEnabled = YES;
                    //            replyImageView.image = [[UIImage imageNamed:@"datwrithe_bg.png"]stretchableImageWithLeftCapWidth:0 topCapHeight:22];
                    
//                    NSDictionary *infoDic = [dic[@"writeinfo"]objectFromJSONString];
                    
                    UIImageView *replyProfileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
                    //            [replyProfileImageView setImage:[SharedAppDelegate.root getImage:[dicobjectForKey:@"uid"] ifNil:@"n01_tl_list_profile.png"]];
                    replyProfileImageView.userInteractionEnabled = YES;
                    [cell.contentView addSubview:replyProfileImageView];
                    [replyProfileImageView release];
                    
                    UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
                    viewButton.adjustsImageWhenHighlighted = NO;
                    [viewButton addTarget:self action:@selector(goToReplyTimeline:) forControlEvents:UIControlEventTouchUpInside];
                    viewButton.titleLabel.text = dic[@"uid"];
                    viewButton.tag = 1;//[dic[@"writeinfotype"]intValue];
                    [replyProfileImageView addSubview:viewButton];
                    
                    
                    UILabel *replyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 80, 16)];
                    [replyNameLabel setBackgroundColor:[UIColor clearColor]];
                    [replyNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
                    [replyNameLabel setTextColor:RGB(87, 107, 149)];
                    replyNameLabel.userInteractionEnabled = YES;
                    [cell.contentView addSubview:replyNameLabel];
                    [replyNameLabel release];
                    
                    
                    UIButton *tagNameButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80, 20)];
                    tagNameButton.adjustsImageWhenHighlighted = NO;
//                    if([dic[@"writeinfotype"]isEqualToString:@"1"] &&
                       if(![dic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID])
                        [tagNameButton addTarget:self action:@selector(tagName:) forControlEvents:UIControlEventTouchUpInside];
                    tagNameButton.titleLabel.text = dic[@"uid"];
                    [replyNameLabel addSubview:tagNameButton];
                    [tagNameButton release];
                    
                    
                    UILabel *positionLabel;
                    positionLabel = [[UILabel alloc]init];
                    [positionLabel setBackgroundColor:[UIColor clearColor]];
                    [positionLabel setTextColor:[UIColor grayColor]];
                    [positionLabel setFont:[UIFont systemFontOfSize:14]];
                    [cell.contentView addSubview:positionLabel];
                    [positionLabel release];
                    
                    UILabel *teamLabel;
                    teamLabel = [[UILabel alloc]init];
                    [teamLabel setBackgroundColor:[UIColor clearColor]];
                    [teamLabel setTextColor:[UIColor grayColor]];
                    [teamLabel setFont:[UIFont systemFontOfSize:14]];
                    [cell.contentView addSubview:teamLabel];
                    [teamLabel release];
                    
                    [replyNameLabel setText:dic[@"username"]];//infoDic[@"name"]];
                    [positionLabel setText:dic[@"position"]];//infoDic[@"position"]];
                    [teamLabel setText:dic[@"deptname"]];//infoDic[@"deptname"]];
                    
                    CGSize size = [replyNameLabel.text sizeWithFont:replyNameLabel.font];
                    positionLabel.frame = CGRectMake(replyNameLabel.frame.origin.x + (size.width+5>80?80:size.width+5), replyNameLabel.frame.origin.y, 70, 16);
                    
                    CGSize size2 = [positionLabel.text sizeWithFont:positionLabel.font];
                    teamLabel.frame = CGRectMake(positionLabel.frame.origin.x + (size2.width+5>70?70:size2.width+5), replyNameLabel.frame.origin.y, 70, 16);
                    
                    UILabel *firstReplyLabel;
                    firstReplyLabel = [[UILabel alloc]init];
                    firstReplyLabel.frame = CGRectMake(320 - 5 - 60, teamLabel.frame.origin.y, 60, teamLabel.frame.size.height);
                    [firstReplyLabel setBackgroundColor:[UIColor clearColor]];
                    [firstReplyLabel setTextColor:[UIColor redColor]];
                    [firstReplyLabel setFont:[UIFont systemFontOfSize:14]];
                    firstReplyLabel.textAlignment = UITextAlignmentRight;
                    firstReplyLabel.text = @"";
                    [cell.contentView addSubview:firstReplyLabel];
                    firstReplyLabel.hidden = YES;
                    [firstReplyLabel release];
                    
                    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReplySort"] == 0) {
                        if(indexPath.row-2 == 0)
                            firstReplyLabel.hidden = NO;
                        
                    }
                    else{
                        if(indexPath.row-1 == [replyArray count])
                            firstReplyLabel.hidden = NO;
                        
                    }
                    UILabel *replyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, replyProfileImageView.frame.origin.y + replyProfileImageView.frame.size.height + 5, 40, 10)];
                    [replyTimeLabel setTextAlignment:UITextAlignmentCenter];
                    [replyTimeLabel setTextColor:[UIColor darkGrayColor]];
                    [replyTimeLabel setFont:[UIFont systemFontOfSize:10]];
                    [replyTimeLabel setBackgroundColor:[UIColor clearColor]];
                   NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                     [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                       NSDate *timeDate = [formatter dateFromString:dic[@"created"]];
                    NSString *linuxString = [NSString stringWithFormat:@"%.0f",[timeDate timeIntervalSince1970]];
                    //        id AppID = [[UIApplication sharedApplication]delegate];
                    
                     NSString *dateString = [NSString calculateDate:linuxString];// with:currentTime];
                    [replyTimeLabel setText:dateString];
                    [cell.contentView addSubview:replyTimeLabel];
                    [replyTimeLabel release];
                    
                    UILabel *replyDetailTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(replyNameLabel.frame.origin.x, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height+2.0, 220.0, 16.0)];
					[replyDetailTimeLabel setTextColor:[UIColor grayColor]];
					[replyDetailTimeLabel setBackgroundColor:[UIColor clearColor]];
					[replyDetailTimeLabel setFont:[UIFont systemFontOfSize:14.0]];
					
                     NSString *detailDateString = [NSString formattingDate:linuxString withFormat:@"yyyy년 M월 d일 a h시 m분"];
					[replyDetailTimeLabel setText:detailDateString];
					[cell.contentView addSubview:replyDetailTimeLabel];
					[replyDetailTimeLabel release];
					
                     NSString *replyCon = dic[@"desc"];//[dic[@"replymsg"]objectFromJSONString][@"msg"];
                    //            NSLog(@"replycont %@",replyCon);
                    
                    
                    //                    CGSize replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(255, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
                    CGSize replySize = [SharedFunctions textViewSizeForString:replyCon font:[UIFont systemFontOfSize:fontSize] width:255 realZeroInsets:NO];
                    
                     
                        for(NSDictionary *replyDic in replyArray){
                            
                            NSString *searchName = replyDic[@"username"];//[NSString stringWithFormat:@"@%@",[replyDic[@"writeinfo"]objectFromJSONString][@"name"]];
//                            NSLog(@"searchName %@",searchName);
                            NSRange range = [replyCon rangeOfString:searchName];
                            if (range.length > 0){
                                NSLog(@"String contains");
                                NSString *htmlString = [NSString stringWithFormat:@"<font color=\"#a01213\">%@</font>",[searchName substringWithRange:NSMakeRange(1,[searchName length]-1)]];
                                
                                //                            NSLog(@"replycon1 %@",replyCon);
                                //                            replyCon = [replyCon stringByReplacingCharactersInRange:range withString:htmlString];
                                replyCon = [replyCon stringByReplacingOccurrencesOfString:searchName withString:htmlString];
                                //                            NSLog(@"replycon2 %@",replyCon);
                            }
                        }
                    
                    
                    //                        NSLog(@"\n contains");
                    //                        NSLog(@"replycon3 %@",replyCon);
                    replyCon = [replyCon stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
                    //                        NSLog(@"replycon4 %@",replyCon);
                    
                    
                    NSLog(@"replySize.width height %f %f",replySize.width,replySize.height);
                    UITextView *replyContentsTextView = [[UITextView alloc]init];//WithFrame:CGRectMake(45, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, replySize.width, replySize.height + 10)];
                    [replyContentsTextView setTextAlignment:UITextAlignmentLeft];
                    [replyContentsTextView setFont:[UIFont systemFontOfSize:fontSize]];
                    [replyContentsTextView setBackgroundColor:[UIColor clearColor]];
                    [replyContentsTextView setDataDetectorTypes:UIDataDetectorTypeLink];
                    //                    [replyContentsTextView setBounces:NO];
                    [replyContentsTextView setScrollEnabled:NO];
                    [replyContentsTextView setEditable:NO];
                    [replyContentsTextView sizeToFit];
                    //            [replyContentsLabel setAdjustsFontSizeToFitWidth:NO];
                    //                    [replyContentsTextView sizeToFit];
                    //            [replyContentsTextView setUserInteractionEnabled:YES];
                    //            [replyContentsLabel setNumberOfLines:0];
                    //            [replyContentsLabel setLineBreakMode:UILineBreakModeCharacterWrap];
                    
                    if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0) {
						[replyContentsTextView setValue:replyCon forKey:@"contentToHTMLString"];
					} else {
						NSString *htmlString = [NSString stringWithFormat:@"<html> \n"
												"<head> \n"
												"<style type=\"text/css\"> \n"
												"body {font-family: \"%@\"; font-size: %i; height: auto; }\n"
												"</style> \n"
												"</head> \n"
												"<body>%@</body> \n"
												"</html>", replyContentsTextView.font.fontName, (int)fontSize, replyCon];
						
						NSData *htmlDATA = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
						NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:htmlDATA options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
						[replyContentsTextView setAttributedText:attrStr];
						[attrStr release];
					}
                    
                    replyContentsTextView.frame = CGRectMake(45, replyDetailTimeLabel.frame.origin.y + replyDetailTimeLabel.frame.size.height, 255, replySize.height + 2);
                    
                    UIImageView *replyPhotoView = [[UIImageView alloc]initWithFrame:CGRectMake(0,replyContentsTextView.frame.size.height + replyContentsTextView.frame.origin.y, 100, 0)];
                    replyPhotoView.userInteractionEnabled = YES;
                    
                    NSString *replyPhotoUrl = [dic[@"replymsg"]objectFromJSONString][@"image"];
                    NSLog(@"replyPhotourl %@",replyPhotoUrl);
                    if([replyPhotoUrl length]>0){
                        
                        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:replyPhotoUrl num:0 thumbnail:YES];
                        
						[replyPhotoView setImageWithURL:imgURL placeholderImage:nil options:SDWebImageRetryFailed success:^(UIImage *image, BOOL cached) {
							
						} failure:^(NSError *error) {
							NSLog(@"fail %@",[error localizedDescription]);
							[HTTPExceptionHandler handlingByError:error];
                            
						}];
                        
                        NSDictionary *sizeDic = [replyPhotoUrl objectFromJSONString][@"thumbnailinfo"];
                        
                        CGFloat imageScale = 0.0f;
                        if([sizeDic[@"width"]floatValue]>120.0f){
                            imageScale = [sizeDic[@"width"]floatValue]/120.0f;
                            NSLog(@"imageScale %f",imageScale);
                            replyPhotoView.frame = CGRectMake(replyContentsTextView.frame.origin.x + 10,
                                                              replyContentsTextView.frame.size.height + replyContentsTextView.frame.origin.y,
                                                              120, [sizeDic[@"height"]floatValue]/imageScale);
                            NSLog(@"imageScale %f",[sizeDic[@"height"]floatValue]/imageScale);
                        }
                        else{
                            imageScale = 120.0f/[sizeDic[@"width"]floatValue];
                            replyPhotoView.frame = CGRectMake(replyContentsTextView.frame.origin.x + 10,
                                                              replyContentsTextView.frame.size.height + replyContentsTextView.frame.origin.y,
                                                              120, [sizeDic[@"height"]floatValue]*imageScale);
                            
                        }
                        NSLog(@"////////////////frame %@",NSStringFromCGRect(replyPhotoView.frame));
                        
                        
                        UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,replyPhotoView.frame.size.width,replyPhotoView.frame.size.height)];
                        viewButton.adjustsImageWhenHighlighted = NO;
                        [viewButton addTarget:self action:@selector(viewReplyImage:) forControlEvents:UIControlEventTouchUpInside];
                        viewButton.titleLabel.text = replyPhotoUrl;
                        [replyPhotoView addSubview:viewButton];
                        [viewButton release];
                        
                        
                        
                        replyPhotoView.backgroundColor = [UIColor blackColor];
                        
                    }
                  
                     NSLog(@"dic uid %@",dic[@"uid"]);
						[SharedAppDelegate.root getProfileImageWithURL:dic[@"uid"] ifNil:@"profile_photo.png" view:replyProfileImageView scale:24];
                    
                    [cell.contentView addSubview:replyContentsTextView];
                    [replyContentsTextView release];
                    
                    [cell.contentView addSubview:replyPhotoView];
                    [replyPhotoView release];
                    
                    //                UIImageView *bound = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"datview_bg.png"]];
                    //                bound.frame = CGRectMake(0,replyContentsTextView.frame.size.height+replyContentsTextView.frame.origin.y - 1,320,1);
                    //                [view addSubview:bound];
                    //                [bound release];
                     if([dic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){// && [dic[@"writeinfotype"]isEqualToString:@"1"]){
                        NSLog(@"dic %@",dic);
                        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(320-33,(replyPhotoView.frame.size.height+replyPhotoView.frame.origin.y)/2-16,33,33)];
                        [deleteButton setBackgroundImage:[UIImage imageNamed:@"replayedit_btn.png"] forState:UIControlStateNormal];
                        [deleteButton addTarget:self action:@selector(actionReply:) forControlEvents:UIControlEventTouchUpInside];
                        deleteButton.tag = indexPath.row-2;
                        //                        deleteButton.titleLabel.text = dic[@"replyindex"];
                        [cell.contentView addSubview:deleteButton];
                    }
                    
                    CGRect messageFrame = cell.contentView.frame;
                    messageFrame.size.height = replyPhotoView.frame.size.height+replyPhotoView.frame.origin.y;
                    
                    if([replyPhotoUrl length]>0)
                        messageFrame.size.height += 10;
                    
                    [cell.contentView setFrame:messageFrame];
                    
                    
                    UIImageView *bound = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"datview_bg.png"]];
                    bound.frame = CGRectMake(0,cell.contentView.frame.size.height-1,320,1);
                    [cell.contentView addSubview:bound];
                    [bound release];
                    
                    
                }
                //                UIImageView *bound = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"datview_bg.png"]];
                //                bound.frame = CGRectMake(0,cell.contentView.frame.origin.y+cell.contentView.frame.size.height-1,320,1);
                //                [cell.contentView addSubview:bound];
                //                [bound release];
                
                
                //                [cell.contentView addSubview:view];
                //                    [view setUserInteractionEnabled:YES];
                
                
                
                
            }
            
        
        
    }
    
    
    
    return cell;
    
}

- (void)actionReply:(id)sender{
    
    
    
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                destructiveButtonTitle:nil otherButtonTitles:@"댓글 수정", @"댓글 삭제", nil];
    
    [actionSheet showInView:SharedAppDelegate.window];
    NSDictionary *dic = replyArray[[sender tag]];
    objc_setAssociatedObject(actionSheet, &paramDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    actionSheet.tag = kActionReply;
    
}

#define kActivityReply 4

- (void)modifyReply:(id)sender{
	
    PostViewController *post = [[PostViewController alloc]initWithStyle:kPost];//WithViewCon:self];
    //    post.title = [NSString stringWithFormat:@"%@",self.title];
    post.title = @"댓글수정";
    NSDictionary *dic = objc_getAssociatedObject(sender, &paramDic);
    [post setActivityModifyView:dic[@"desc"] idx:dic[@"id"] conIdx:contentsData.cid tag:kActivityReply];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
    [self presentModalViewController:nc animated:YES];
    [post release];
    [nc release];
}
- (void)deleteReply:(id)sender{

    NSDictionary *dic = objc_getAssociatedObject(sender, &paramDic);
    NSLog(@"number %@",dic[@"id"]);
    UIAlertView *alert;
    //    NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 거시겠습니까?",number];
    alert = [[UIAlertView alloc] initWithTitle:@"댓글삭제" message:@"정말 삭제하시겠습니까?" delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
    alert.tag = kDeleteReply;
    objc_setAssociatedObject(alert, &paramNumber, dic[@"id"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [alert show];
    [alert release];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)view {
    pointNow = view.contentOffset;
}

-(void)scrollViewDidScroll:(UIScrollView *)view {
    if (view.contentOffset.y<pointNow.y && [view isKindOfClass:[UITableView class]]) {
        NSLog(@"down");
        [replyTextView resignFirstResponder];
    } else if (view.contentOffset.y>pointNow.y) {
        NSLog(@"up");
    }
}

- (void)addOrClear:(id)sender
{
    
    [MBProgressHUD showHUDAddedTo:sender label:nil animated:YES];
    
    NSString *type = @"";
    
    if([sender tag]==kNotFavorite){
        type = @"1";
    }
    else{
        type = @"2";
    }
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                type,@"type",@"2",@"category",contentsData.cid,@"contentindex",
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                @"",@"member",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",nil];
    NSLog(@"parameter %@",parameters);
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setfavorite.lemp" parameters:parameters];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResulstDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if([sender tag] == kNotFavorite){
                [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_prs.png"] forState:UIControlStateNormal];
                favButton.tag = kFavorite;
            }
            else{
                [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_dft.png"] forState:UIControlStateNormal];
                favButton.tag = kNotFavorite;
                
            }
            
            NSLog(@"category %@",SharedAppDelegate.root.home.category);
            
            //            if([SharedAppDelegate.root.home.category isEqualToString:@"10"])
            [SharedAppDelegate.root setNeedsRefresh:YES];
            //                [SharedAppDelegate.root.home refreshTimeline];
            
            
            [MBProgressHUD hideHUDForView:sender animated:YES];
            
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupAlertViewOK:nil msg:msg];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            [MBProgressHUD hideHUDForView:sender animated:YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [MBProgressHUD hideHUDForView:sender animated:YES];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"즐겨찾기 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
    
}



- (void)viewMap:(id)sender{
//    NSString *location = [NSString stringWithString:[sender titleForState:UIControlStateDisabled]];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
    
        NSString *location = [NSString stringWithFormat:@"%f,%f",contentsData.latitude,contentsData.longitude];
        MapViewController *mvc = [[MapViewController alloc]initWithLocation:location];
        [mvc setCurrentFromActivity];
        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:mvc];
        [self presentModalViewController:nc animated:YES];
        [mvc release];
        [nc release];
    }
    else{
	GoogleMapViewController *mvc = [[GoogleMapViewController alloc]initForDownload];//:location];
    [mvc readyForDownloadWithLatitude:contentsData.latitude longitude:contentsData.longitude];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:mvc];
	[self presentModalViewController:nc animated:YES];
    [mvc release];
    [nc release];
    }
}
- (void)viewImage:(id)sender{
    
    NSArray *imageArray = contentsData.urlArray;//.contentDic[@"image"];
//    NSDictionary *imgDic = [imageString objectFromJSONString];
    NSString *imgUrl = imageArray[[sender tag]];//[NSString stringWithFormat:@"https://%@%@%@",imgDic[@"server"],imgDic[@"dir"],imgDic[@"filename"][[sender tag]]];
    NSLog(@"imgUrl %@",imgUrl);
    
    
    
    UIViewController *photoCon;
    
            photoCon = [[PhotoTableViewController alloc]initFromActivity:contentsData.urlArray parent:self index:(int)[sender tag]];
    
    

    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoCon];
    
    //    [self.navigationController pushViewController:photoViewCon animated:YES];
	[self presentModalViewController:nc animated:YES];
    //    [SharedAppDelegate.root anywhereModal:nc];
    [nc release];
    [photoCon release];
    
    
}
- (void)viewReplyImage:(id)sender{
    
    //    UIButton *button = (UIButton *)sender;
    
    NSString *imageString = [[sender titleLabel]text];//[contentsData.contentDicobjectForKey:@"image"];
    NSDictionary *imgDic = [imageString objectFromJSONString];
    NSString *imgUrl = [NSString stringWithFormat:@"https://%@%@%@",imgDic[@"server"],imgDic[@"dir"],imgDic[@"filename"][0]];
    NSLog(@"imgUrl %@",imgUrl);
    
    
    PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithFileName:imgDic[@"filename"][0] image:nil type:12 parentViewCon:self roomkey:@"" server:imgUrl];
    
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoViewCon];
    
    //    [self.navigationController pushViewController:photoViewCon animated:YES];
	[self presentModalViewController:nc animated:YES];
    //    [SharedAppDelegate.root anywhereModal:nc];
    [nc release];
    [photoViewCon release];
    
    
}
- (void)goToNoteReplyTimeline:(id)sender{
    
    
    [replyTextView resignFirstResponder];
    [SharedAppDelegate.root settingYours:[[sender titleLabel]text] view:self.view];
    
    //    [SharedAppDelegate.root.home goToYourTimeline:[[sender titleLabel]text]];
    //    NSLog(@"parentViewCon %@",parentViewCon);
}

- (void)goToReplyTimeline:(id)sender{
    
    if([sender tag]!=1)
        return;
    
    [replyTextView resignFirstResponder];
    [SharedAppDelegate.root settingYours:[[sender titleLabel]text] view:self.view];
    
    //    [SharedAppDelegate.root.home goToYourTimeline:[[sender titleLabel]text]];
    //    NSLog(@"parentViewCon %@",parentViewCon);
}
- (void)goToYourTimeline:(id)sender{
    
//    if(![contentsData.writeinfoType isEqualToString:@"1"])
//        return;
    
    [replyTextView resignFirstResponder];
    [SharedAppDelegate.root settingYours:[[sender titleLabel]text] view:self.view];
    
    //    [SharedAppDelegate.root.home goToYourTimeline:[[sender titleLabel]text]];
    //    NSLog(@"parentViewCon %@",parentViewCon);
}



            

- (void)getActivityReply{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
	[client setAuthorizationHeaderWithToken:[ResourceLoader sharedInstance].mySessionkey];

    
    NSString *path = [NSString stringWithFormat:@"/capi/youwin/activity/detail/id/%@",contentsData.cid]; // ########
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:nil];
    
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"2");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD hideHUDForView:myTable animated:YES];
  
        NSDictionary *resultDic = [operation.responseString objectFromJSONString];
        
        NSDictionary *dic = resultDic[@"contents"];
        NSLog(@"dic %@",resultDic[@"contents"]);
        
        contentsData.cid = dic[@"id"];
        contentsData.uid = dic[@"uid"];
        contentsData.position = dic[@"position"];
        contentsData.deptName = dic[@"deptname"];
        contentsData.createdTimeInterval = [dic[@"created"] length] > 0 ? [dic[@"created"] doubleValue] : 0.0;
        
        contentsData.address = dic[@"address"];
        contentsData.desc = dic[@"desc"];
        contentsData.urlArray = dic[@"url"];
        contentsData.fileCount = [dic[@"num_files"] length] > 0 ? [dic[@"num_files"] integerValue] : 0;
        
        contentsData.replyArray = dic[@"reply"];
        contentsData.likeArray = dic[@"like"];
        
        contentsData.latitude = [dic[@"latitude"] length] > 0 ? [dic[@"latitude"] doubleValue] : 0.0;
        contentsData.longitude = [dic[@"longitude"] length] > 0 ? [dic[@"longitude"] doubleValue] : 0.0;
        contentsData.zoomLevel = [dic[@"zoomlevel"] length] > 0 ? [dic[@"zoomlevel"] integerValue] : 0;
        contentsData.isNotice = ([dic[@"is_notice"] length] > 0 && [dic[@"is_notice"] isEqualToString:@"1"]) ? YES : NO;
        contentsData.createdTimeString = dic[@"created_datetime"];
        
        [likeArray setArray:dic[@"like"]];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReplySort"] == 0) {
            [replyArray setArray:dic[@"reply"]];
        } else {
            [replyArray setArray:[[dic[@"reply"] reverseObjectEnumerator] allObjects]];
        }
        
        [replyTextView resignFirstResponder];
        replyTextView.text = @"";
        
        NSLog(@"replyHeight %f",replyHeight);
        if(replyHeight == 0.0f)
            replyHeight = 61.0f;
        replyView.frame = CGRectMake(0, self.view.frame.size.height-replyHeight, 320, replyHeight);
        photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 123, 320, 123);
        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-replyView.frame.size.height);
        replyView.hidden = NO;
        NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
        
        [myTable reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [MBProgressHUD hideHUDForView:myTable animated:YES];
		[HTTPExceptionHandler handlingByError:error];
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"댓글을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}

//
//- (void)checkNoti:(NSDictionary *)dic{
//    NSLog(@"checkNoti %@",dic);
//    
//    //    if([contentsData.profileImage isEqualToString:myUID])
//    //        return;
//    
//    
//    if([dic[@"attendance"]isEqualToString:@"0"]){ // member check no
//        
//        NSLog(@"member check no");
//        [self regiNoti:dic];
//    }
//    else{
//        NSLog(@"member check YES");
//        BOOL isAttend = NO;
//        for(int i = 0; i < [readArray count]; i++){
//            NSDictionary *readdic = [readArray[i]objectFromJSONString];
//            if([readdic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID])
//            {
//                
//                if([readdic[@"attendance"]isEqualToString:@"2"]){
//                    isAttend = YES;
//                }
//            }
//        }
//        if(isAttend){
//            NSLog(@"isAttend");
//            [self regiNoti:dic];
//            
//        }
//        
//        
//    }
//}


- (void)keyboardWillShow:(NSNotification *)noti
{
    NSLog(@"keyboardWasShwo %f",replyView.frame.size.height);
    
    
    
	NSDictionary *info = [noti userInfo];
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	CGRect endFrame;
	
	[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
	//    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    //    CGFloat currentKeyboardHeight;
    currentKeyboardHeight = endFrame.size.height;
    // 416
    //    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey]doubleValue]
    //                     animations:^{
    //                         replyView.frame = CGRectMake(0, self.view.frame.size.height-replyView.frame.size.height-currentKeyboardHeight, 320, replyView.frame.size.height);
    //                         photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 123, 320, 123);
    //                         myTable.frame = CGRectMake(0, 0, 320, replyView.frame.origin.y);
    //                     }];
    //    NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
	[UIView animateWithDuration:animationDuration
						  delay:0
						options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 replyView.frame = CGRectMake(0, self.view.frame.size.height-replyView.frame.size.height-currentKeyboardHeight, 320, replyView.frame.size.height);
                         photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 123, 320, 123);
                         myTable.frame = CGRectMake(0, 0, 320, replyView.frame.origin.y);
					 } completion:nil];
    //    myTable.contentSize = CGSizeMake(320, myTable.contentSize.height+currentKeyboardHeight);
    //    NSLog(@"keyboardWasShwon %f",scrollView.contentSize.height);
    
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    //    if([replyTextView isFirstResponder])
    //        return;
    NSLog(@"keyboardWillHide %f",replyHeight);
    NSLog(@"keyboardWillHide %f",replyTextViewBackground.frame.size.height);
    
    if(replyHeight == 0.0f)
        replyHeight = 61.0f;
    
	
    NSDictionary *info = [noti userInfo];
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	CGRect endFrame;
	
	[[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	[[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
	
    //    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    //    CGFloat currentKeyboardHeight;
    currentKeyboardHeight = endFrame.size.height;
    // 416
	[UIView animateWithDuration:animationDuration
						  delay:0
						options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 replyView.frame = CGRectMake(0, self.view.frame.size.height-replyHeight, 320, replyHeight);
                         photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 123, 320, 123);
                         myTable.frame = CGRectMake(0, 0, 320, replyView.frame.origin.y);
					 } completion:nil];
	
    //    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey]doubleValue]
    //                     animations:^{
    //                         replyView.frame = CGRectMake(0, self.view.frame.size.height-replyHeight, 320, replyHeight);
    //                         photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 123, 320, 123);
    //                         myTable.frame = CGRectMake(0, 0, 320, replyView.frame.origin.y);
    //                     }];
    NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
    //    myTable.contentSize = CGSizeMake(320, myTable.contentSize.height-currentKeyboardHeight);
    //    NSLog(@"keyboardWillHide %f",scrollView.contentSize.height);
    
}
# pragma - TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	[textView becomeFirstResponder];
    NSString *newString = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([newString length]<1){
        [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_dft.png"] forState:UIControlStateNormal];
    }
    else
        [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_prs.png"] forState:UIControlStateNormal];
    
    //    [sendButton setEnabled:YES];
    [placeHolderLabel setHidden:YES];
    
    
    float keyboardHiddenHeight = self.view.frame.size.height - replyView.frame.size.height;
    float keyboardShownHeight = self.view.frame.size.height - currentKeyboardHeight - replyView.frame.size.height;
    
    if(myTable.contentSize.height > keyboardHiddenHeight) {
        [myTable setContentOffset:CGPointMake(0, myTable.contentOffset.y + currentKeyboardHeight)];
	} else if(myTable.contentSize.height > keyboardShownHeight) {
		
		[myTable setContentOffset:CGPointMake(0, myTable.contentOffset.y + (myTable.contentSize.height - keyboardShownHeight))];
    }
}


- (void)textViewDidChange:(UITextView *)textView
{
    NSString *newString = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([newString length]<1){
        [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_dft.png"] forState:UIControlStateNormal];
    }
    else
        [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_prs.png"] forState:UIControlStateNormal];
    
    
    
    
    NSInteger oldLineCount = msgLineCount;
    
    NSInteger lineCount = (NSInteger)((textView.contentSize.height - 16) / textView.font.lineHeight);
    NSLog(@"textview.contentsize.height %f",textView.contentSize.height);
    
    
    if (msgLineCount != lineCount) {
        if (lineCount > MAX_MESSAGEEND_LINE)
            msgLineCount = MAX_MESSAGEEND_LINE;
        else
            msgLineCount = lineCount;
    }
    
    
    if (msgLineCount != oldLineCount)
        [self viewResizeUpdate:msgLineCount];
	
    [SharedFunctions adjustContentOffsetForTextView:textView];
    [textView scrollRangeToVisible:textView.selectedRange];
    
}
- (void)viewResizeUpdate:(NSInteger)lineCount
{
	/****************************************************************
	 작업자 : 박형준
	 작업일자 : 2012/06/04
	 작업내용 : 채팅 입력창 동작 제어 - 입력창에 입력된 라인 수량에 따른 입력창 및 관련뷰 크기 조절 수행
	 param	- lineCount(NSInteger) : 현재 라인 수
	 연관화면 : 채팅
	 ****************************************************************/
    
    NSLog(@"1");
    if (lineCount > MAX_MESSAGEEND_LINE)
		return;
    NSLog(@"2");
    
	lineCount--;
    
    
    
	CGRect viewFrame = replyView.frame;
	NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
	viewFrame.size.height = g_viewSizeHeight[lineCount];
	if([replyTextView isFirstResponder]) {
        NSLog(@"3");
		viewFrame.origin.y = self.view.frame.size.height - currentKeyboardHeight - g_viewSizeHeight[lineCount];
	} else {
        NSLog(@"4");
		viewFrame.origin.y = self.view.frame.size.height - g_viewSizeHeight[lineCount];
	}
    NSLog(@"5");
	CGRect textFrame = replyTextView.frame;
	textFrame.size.height = g_textSizeHeight[lineCount];
	
    NSLog(@"6");
	CGRect areaFrame = replyTextViewBackground.frame;
	areaFrame.size.height = g_areaSizeHeight[lineCount];
	
    NSLog(@"7");
	isResizing = YES;
	
    NSLog(@"8");
    //	[UIView animateWithDuration:0.25f
    //                          delay:0
    //                        options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
    //                     animations:^{
    [replyView setFrame:viewFrame];
    [replyTextViewBackground setFrame:areaFrame];
    [replyTextView setFrame:textFrame];
    photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 123, 320, 123);
    myTable.frame = CGRectMake(0, 0, 320, replyView.frame.origin.y);
    //                     }
    //                     completion:^(BOOL finished){
    //                         // 리사이징 해제.
    isResizing = NO;
    //                     }];
    
    NSLog(@"9");
    replyHeight = replyView.frame.size.height;
    NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
    
    if(replyHeight == 0)
        replyHeight = 61.0f;
    NSLog(@"viewResizeUpdate %f",replyView.frame.size.height);
    NSLog(@"viewResizeUpdate %f",replyTextViewBackground.frame.size.height);
}

- (void)goodMember:(id)sender
{
    if([likeArray count]<1)
        return;
    //    if(contentsData.likeCount==0)
    //        return;
    //
    //    NSLog(@"goodMember");
    [SharedAppDelegate.root.home pushGood:likeArray con:self tag:kActivity];
    //    [parentViewCon pushGood:[sender tag]];
    
}
- (void)sendLike:(id)sender
{
    //    if(contentsData.likeCountUse == 1){
    //        [CustomUIKit popupAlertViewOK:nil msg:@"이미 좋아요 하셨습니다."];
    //        return;
    //    }
//    NSLog(@"contentsdata.idx %@",contentsData.cid);
    [MBProgressHUD showHUDAddedTo:sender label:nil animated:YES];
//    [SharedAppDelegate.root.home sendLikeTarget:self delegate:@selector(sendLikeResult:)];
//    [SharedAppDelegate.root.home sendLike:contentsData.cid sender:sender];
   
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
	[client setAuthorizationHeaderWithToken:[ResourceLoader sharedInstance].mySessionkey];

    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
    
    NSDictionary *parameters = nil;
    NSMutableURLRequest *request;
    
    if([sender tag] == kLike){
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                contentsData.cid,@"activity_id",
                                dic[@"uid"],@"uid",
                                dic[@"name"],@"username",
                                dic[@"position"],@"position",
                                dic[@"deptname"],@"deptname",
                                //                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  nil];
        request = [client requestWithMethod:@"POST" path:@"/capi/youwin/activity/like" parameters:parameters];
    }
    else{
        
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                      contentsData.cid,@"activity_id",
                      dic[@"uid"],@"uid",
//                                                      [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                      nil];
//        NSString *path = [NSString stringWithFormat:@"/capi/youwin/activity/like/uid/%@/activity_id/%@/sessionkey/%@",dic[@"uid"],contentsData.cid,[ResourceLoader sharedInstance].mySessionkey];
        NSString *path = @"/capi/youwin/activity/like";
        request = [client requestWithMethod:@"DELETE" path:path parameters:parameters];
    }
    NSLog(@"parameter %@",parameters);
    NSLog(@"request %@",request);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  [MBProgressHUD hideHUDForView:sender animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"ResulstDic %@",operation.responseString);
        [self getActivityReply];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [MBProgressHUD hideHUDForView:sender animated:YES];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];

    
    
    
}
- (void)sendLikeResult:(NSDictionary *)dic{
    NSLog(@"sendLikeResult %@",dic);
    //    [self drawLikes:[dic @"goodmember"]];
    [likeArray setArray:dic[@"goodmember"]];
    [myTable reloadData];
}

- (void)sendReply:(id)sender
{
    NSString *newString = [replyTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([newString length]<1){
        [CustomUIKit popupAlertViewOK:nil msg:@"내용을 입력해주세요."];
        return;
    }
    if([replyTextView.text length]>4000){
        [CustomUIKit popupAlertViewOK:nil msg:@"4000자까지 전송할 수 있습니다."];
        return;
    }
    NSLog(@"replyTextView.text %@",replyTextView.text);
    NSLog(@"tagArrahy %@",tagArray);
    NSString *noticeUID;
    noticeUID = @"";
    
    for(NSDictionary *dic in tagArray){
        NSString *searchName = [NSString stringWithFormat:@"@%@",[dic[@"writeinfo"]objectFromJSONString][@"name"]];
//        NSLog(@"searchName %@",searchName);
        NSRange range = [replyTextView.text rangeOfString:searchName];
        if (range.length > 0){
            NSLog(@"String contains");
            noticeUID = [noticeUID stringByAppendingFormat:@"%@,",dic[@"uid"]];
        }
        else {
            NSLog(@"No found in string");
        }
    }
    NSLog(@"noticeuid %@",noticeUID);
    [tagArray removeAllObjects];
    
    
    [MBProgressHUD showHUDAddedTo:sender label:nil animated:YES];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_dft.png"] forState:UIControlStateNormal];
    //    [sender setEnabled:NO];
    [replyTextView resignFirstResponder];
    [self viewResizeUpdate:1];
    
    NSMutableURLRequest *request;
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
//    NSString *writeinfotype = @"1";
    
//    for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
//        if([dic[@"groupnumber"]isEqualToString:[contentsData.targetdic objectFromJSONString][@"categorycode"]]){
//            NSLog(@"self.groupnum %@ group attribute %@",[contentsData.targetdic objectFromJSONString][@"categorycode"],dic[@"groupattribute"]);
//            NSMutableArray *array = [NSMutableArray array];
//            for (int i = 0; i < [dic[@"groupattribute"] length]; i++) {
//                
//                [array addObject:[NSString stringWithFormat:@"%C", [dic[@"groupattribute"]characterAtIndex:i]]];
//                
//            }
//            
//            if([array count]>2){
//                if([array[2]isEqualToString:@"1"])
//                    writeinfotype = @"10";
//            }
//        }
//    }
    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                dic[@"uid"],@"uid",
                                dic[@"name"],@"username",
                                dic[@"position"],@"position",
                                dic[@"deptname"],@"deptname",
//                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                replyTextView.text,@"desc",
                                contentsData.cid,@"activity_id",
//                                noticeUID,@"noticeuid",
                                nil];//@{ @"uniqueid" : @"c110256" };
    NSLog(@"parameters %@",parameters);
    
    
//    if([selectedImageData length]>0)
//    {
//        [MBProgressHUD showHUDAddedTo:photoBackgroundView label:nil animated:YES];
//        
//        NSString *timeStamp = [[NSString alloc]initWithFormat:@"%.0f.jpg",[[NSDate date] timeIntervalSince1970]];
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        request = [client multipartFormRequestWithMethod:@"POST" path:@"/lemp/timeline/write/reply.lemp" parameters:parameters JSONKey:@"" JSONParameter:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//            [formData appendPartWithFileData:selectedImageData name:@"filename" fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
//        }];
//        
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//        
//        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
//        }];
//        [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id  responseObject) {
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            [MBProgressHUD hideHUDForView:sender animated:YES];
//            [MBProgressHUD hideHUDForView:photoBackgroundView animated:YES];
//            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
//            NSLog(@"resultDic %@",resultDic);
//            NSString *isSuccess = resultDic[@"result"];
//            if ([isSuccess isEqualToString:@"0"]) {
//                
//                myTable.contentOffset = CGPointMake(0, myTable.contentSize.height);
//                
//                [likeArray setArray:resultDic[@"goodmember"]];
//                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReplySort"] == 0) {
//					[replyArray setArray:resultDic[@"replymsg"]];
//				} else {
//					[replyArray setArray:[[resultDic[@"replymsg"] reverseObjectEnumerator] allObjects]];
//				}
//                [myTable reloadData];
//                [SharedAppDelegate.root.home reloadTimeline:contentsData.idx dic:resultDic];
//                replyTextView.text = @"";
//                [self closePhoto];
//                
//            }
//            else{
//                NSString *msg = [NSString stringWithFormat:@"오류: %@ %@",isSuccess,resultDic[@"resultMessage"]];
//                [CustomUIKit popupAlertViewOK:nil msg:msg];
//                NSLog(@"not success but %@",isSuccess);
//            }
//            
//        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [MBProgressHUD hideHUDForView:sender animated:YES];
//            [MBProgressHUD hideHUDForView:photoBackgroundView animated:YES];
//            //        [sender setEnabled:YES];
//            
//            NSLog(@"FAIL : %@",operation.error);
//            //        [MBProgressHUD hideHUDForView:self.view animated:YES];
//			[HTTPExceptionHandler handlingByError:error];
//        }];
//        
//        
//        [operation start];
//        
//    }
//    else
//    {
        request = [client requestWithMethod:@"POST" path:@"/capi/youwin/activity/reply" parameters:parameters];
    NSLog(@"request %@",request);
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [MBProgressHUD hideHUDForView:sender animated:YES];
            //        [sender setEnabled:YES];
            //        [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"ResultDic %@",operation.responseString);
            [self getActivityReply];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:sender animated:YES];
            //        [sender setEnabled:YES];
            
            NSLog(@"FAIL : %@",operation.error);
            //        [MBProgressHUD hideHUDForView:self.view animated:YES];
			[HTTPExceptionHandler handlingByError:error];
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"댓글을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            //?        [alert show];
            
        }];
        
        [operation start];
    //}
}


//    [sender setEnabled:NO];

            
- (void)viewDidUnload{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
