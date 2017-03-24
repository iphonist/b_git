//
//  PostViewController.m
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 11. 15..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import "SendNoteViewController.h"
#import "MapViewController.h"
#import "AddMemberViewController.h"
#import "UIImage+Resize.h"
#import "PhotoTableViewController.h"
#import "SelectDeptViewController.h"
#import <objc/runtime.h>

#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

//#define kText 1
#define kPhoto 1
#define kLocation 2
//#define kPhotoExist 3

#define kAlertPost 100
#define kAlertPhoto 200

@interface SendNoteViewController ()

@end

const char paramNumber;

@implementation SendNoteViewController


//@synthesize parentViewCon;

#define kNote 1
#define kPost 2
#define kNoteGroup 3

- (id)initWithStyle:(int)style//WithViewCon:(UIViewController *)viewcon//NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //        self.title = @"글쓰기";
        //		parentViewCon = (HomeTimelineViewController *)viewcon;
        //        NSLog(@"parentViewCon %@",parentViewCon);
        postTag = style;
        //		selectedImageData = nil;
        self.view.backgroundColor = RGB(251,251,251);
        
		memberArray = [[NSMutableArray alloc]init];
		selectedDeptArray = [[NSMutableArray alloc]init];
        dataArray = [[NSMutableArray alloc]init];
	    notify = 0;
		targetuid = [[NSString alloc]init];
		category = [[NSString alloc]init];
        category = @"4";
		groupnum = [[NSString alloc]init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
	[contentsTextView becomeFirstResponder];
	if (memoString) {
		[contentsTextView setText:memoString];
//		[memoString release];
		memoString = nil;
		[self textViewDidChange:contentsTextView];
	}

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(keyboardWillHide:)
    //                                                 name:UIKeyboardWillHideNotification
    //                                               object:nil];
    
    //    [self drawSliding];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if (NO == [contentsTextView isFirstResponder]) {
		[contentsTextView becomeFirstResponder];
	}
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
	[contentsTextView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)fromMemoWithText:(NSString*)contentString images:(NSMutableArray*)imageArray
{
	if (imageArray && [imageArray count] > 0) {
		[dataArray addObjectsFromArray:imageArray];
	}
	
	if (contentString && [contentString length] > 0) {
		memoString = [[NSString alloc] initWithString:contentString];
	}
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    NSDictionary *mydic = [SharedAppDelegate.root searchContactDictionary:[ResourceLoader sharedInstance].myUID];
    NSLog(@"mydic %@",mydic);
    UIImageView *profileImageView;
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    [profileImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:profileImageView];
    
    [SharedAppDelegate.root getProfileImageWithURL:[ResourceLoader sharedInstance].myUID ifNil:@"profile_photo.png" view:profileImageView scale:24];
    
    //	[profileImageView setImage:[SharedAppDelegate.root getImageFromDB]];//:[mydicobjectForKey:@"uid"]]];// ifNil:@"n01_tl_list_profile.png"]];
    //    NSLog(@"myprofileview %@",profileImageView.image);
    //    if(profileImageView.image == nil){
    //
    //        [SharedAppDelegate.root getImageWithURL:[SharedAppDelegate readPlist:@"myinfo"][@"profileimage"] ifNil:@"n01_tl_list_profile.png" view:profileImageView scale:24];
    //
    ////        [profileImageView setImage:[SharedAppDelegate.root roundCornersOfImage:profileImageView.image scale:24]];
    //    }
    
    
    
    UILabel *name, *position, *team;
    name = [CustomUIKit labelWithText:mydic[@"name"] fontSize:14 fontColor:RGB(87, 107, 149) frame:CGRectMake(profileImageView.frame.origin.x + profileImageView.frame.size.width + 5, 14, 80, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [name setFont:[UIFont boldSystemFontOfSize:14.0]];
    [self.view addSubview:name];
    //    [name release];
    
    
    //    targetuid = //WithFormat:@"%@",SharedAppDelegate.root.home.targetuid];
    //    groupnum = [[NSString alloc]init];//WithFormat:@"%@",SharedAppDelegate.root.home.groupnum];
    //    category = [[NSString alloc]init];//WithFormat:@"%@",SharedAppDelegate.root.home.ctype];
    
    //    if(postTag == kPost){
    //
    //        targetuid = [[NSString alloc]initWithFormat:@"%@",SharedAppDelegate.root.home.targetuid];
    //        category = [[NSString alloc]initWithFormat:@"%@",SharedAppDelegate.root.home.ctype];
    //        groupnum = [[NSString alloc]initWithFormat:@"%@",SharedAppDelegate.root.home.groupnum];
    //
    //        NSLog(@"category %@",category);
    //        if(![category isEqualToString:@"3"]){
    //    noticeBtn = [[UIButton alloc]initWithFrame:CGRectMake(320-28-10, 11, 28, 28)];
    //    [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"btn_check_dft.png"] forState:UIControlStateNormal];
    //    [noticeBtn addTarget:self action:@selector(notice:) forControlEvents:UIControlEventTouchUpInside];
    //    noticeBtn.adjustsImageWhenHighlighted = NO;
    //    [self.view addSubview:noticeBtn];
    //    [noticeBtn release];
    //
    //    UILabel *notice = [CustomUIKit labelWithText:@"알림 :" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(noticeBtn.frame.origin.x - 37, noticeBtn.frame.origin.y + 3, 40, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    //    [self.view addSubview:notice];
    //
    //        }
    //    }
    //    else if(postTag == kNote || postTag == kNoteGroup){
    name.frame = CGRectMake(profileImageView.frame.origin.x + profileImageView.frame.size.width + 5, 5, 80, 20);
    
    NSString *message;
    if (postTag == kNote) {
        message = @"버튼을 눌러 수신자를 추가하세요.";
    } else {
        message = @"버튼을 눌러 부서를 추가하세요.";
    }
    UILabel *arrLabel = [CustomUIKit labelWithText:@"➤" fontSize:12 fontColor:RGB(64,88,115) frame:CGRectMake(name.frame.origin.x, name.frame.origin.y + 20, 15, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [self.view addSubview:arrLabel];
    toLabel = [CustomUIKit labelWithText:message fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(name.frame.origin.x + 15, name.frame.origin.y + 20, 220 - 15, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [self.view addSubview:toLabel];
    
    
    noticeBtn = [[UIButton alloc]initWithFrame:CGRectMake(320-37-8, 8, 36, 36)];
    [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"button_add_member.png"] forState:UIControlStateNormal];
    [noticeBtn addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
    //        noticeBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:noticeBtn];
//    [noticeBtn release];
    
    
    //    }
    NSLog(@"target %@ groupnum %@ category %@",targetuid,groupnum,category);
    
    CGSize size = [name.text sizeWithAttributes:@{NSFontAttributeName:name.font}];
    position = [CustomUIKit labelWithText:mydic[@"grade2"] fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(name.frame.origin.x + (size.width+5>80?80:size.width+5), name.frame.origin.y + 1, 80, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [self.view addSubview:position];
//        [position release];
    CGSize size2 = [position.text sizeWithAttributes:@{NSFontAttributeName:position.font}];
    team = [CustomUIKit labelWithText:mydic[@"team"] fontSize:12 fontColor:[UIColor grayColor] frame:CGRectMake(position.frame.origin.x + (size2.width+5>80?80:size2.width+5), position.frame.origin.y + 1, 80, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [self.view addSubview:team];
    //    [team release];
    
    
    //    [notice release];
    
    //    bgView = [[UIView alloc]initWithFrame:CGRectMake(50, 5, 266, self.view.frame.size.height - 44 - 10)];
    //    bgView.backgroundColor = [UIColor clearColor];
    //    bgView.userInteractionEnabled = YES;
    //    [self.view addSubview:bgView];
    
    
    //    UIImageView *topRoundImage = [[UIImageView alloc]initWithFrame:CGRectMake(6, 5 + profileImageView.frame.size.height + 5, 308, 15)];
    //    topRoundImage.image = [CustomUIKit customImageNamed:@"csectionwhite_up.png"];
    //    [self.view addSubview:topRoundImage];
    //    [profileImageView release];
    //
    //   contentView = [[UIImageView alloc]initWithFrame:CGRectMake(topRoundImage.frame.origin.x, topRoundImage.frame.origin.y + topRoundImage.frame.size.height, 308, self.view.frame.size.height - 44 - 216 - topRoundImage.frame.origin.y - topRoundImage.frame.size.height - 15)];
    //    contentView.image = [[CustomUIKit customImageNamed:@"csectionwhite_center.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    //    contentView.userInteractionEnabled = YES;
    //    [self.view addSubview:contentView];
    
    contentView = [[UIImageView alloc]init];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.frame = CGRectMake(profileImageView.frame.origin.x,
                                   profileImageView.frame.origin.y + profileImageView.frame.size.height + 10,
                                   320 - (profileImageView.frame.origin.x + 5),
                                   self.view.frame.size.height - 44 - 216 - 40 - (profileImageView.frame.origin.y + profileImageView.frame.size.height + 10));
    contentView.userInteractionEnabled = YES;
    [self.view addSubview:contentView];
//	[profileImageView release];
    //    bottomRoundImage = [[UIImageView alloc]initWithFrame:CGRectMake(topRoundImage.frame.origin.x, contentView.frame.origin.y + contentView.frame.size.height, 308, 9)];
    //    bottomRoundImage.image = [CustomUIKit customImageNamed:@"csectionwhite_down.png"];
    //    [self.view addSubview:bottomRoundImage];
    //    [topRoundImage release];
//        [bottomRoundImage release];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentView.frame)-90, contentView.frame.size.height-20, 80, 17)];
	[countLabel setNumberOfLines:1];
    [countLabel setTextAlignment:NSTextAlignmentRight];
	[countLabel setFont:[UIFont systemFontOfSize:9.0]];
	[countLabel setBackgroundColor:[UIColor clearColor]];
	[countLabel setLineBreakMode:NSLineBreakByCharWrapping];
	[countLabel setTextColor:[UIColor grayColor]];
	[countLabel setText:@"0/10,000"];
	[contentView addSubview:countLabel];
//    [countLabel release];
    
    photoCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, contentView.frame.origin.y + contentView.frame.size.height - 15, 80, 17)];
	[photoCountLabel setNumberOfLines:1];
    [photoCountLabel setTextAlignment:NSTextAlignmentLeft];
	[photoCountLabel setFont:[UIFont systemFontOfSize:9.0]];
	[photoCountLabel setBackgroundColor:[UIColor clearColor]];
	[photoCountLabel setLineBreakMode:NSLineBreakByCharWrapping];
	[photoCountLabel setTextColor:[UIColor grayColor]];
	[photoCountLabel setText:@"0/5"];
	[self.view addSubview:photoCountLabel];
    photoCountLabel.hidden = YES;
//    [photoCountLabel release];
    
    contentsTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, contentView.frame.size.width,
                                                                    contentView.frame.size.height - 17)];
   	[contentsTextView setFont:[UIFont systemFontOfSize:15.0]];
    contentsTextView.backgroundColor = [UIColor clearColor];
	[contentsTextView setBounces:NO];
	[contentsTextView setDelegate:self];
	[contentView addSubview:contentsTextView];
//    [contentView release];
    
    placeHolderLabel = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:[UIColor lightGrayColor] frame:CGRectMake(8, 4, contentsTextView.frame.size.width-16, 60) numberOfLines:3 alignText:NSTextAlignmentLeft];
    //    [placeHolderLabel1 setTextColor:[UIColor blueColor] range:[placeHolderLabel1 rangeOfString:@"작성 그룹을 변경하려면 상단 ▾ 버튼을 누르세요."]];
	[placeHolderLabel setText:@"쪽지 내용을 작성하세요.\n(쪽지는 공유되지 않고 수신자 개개인 별로 전달됩니다.)"];
	[contentsTextView addSubview:placeHolderLabel];
//    [contentsTextView release];
    //
    
	
	optionView = [[UIImageView alloc] initWithImage:[CustomUIKit customImageNamed:@"memo_btmbg.png"]];
    [optionView setFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];
    [optionView setUserInteractionEnabled:YES];
    [optionView setAlpha:0.8];
    [self.view addSubview:optionView];
	
	addPhoto = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(5, 2, 38, 38) imageNamedBullet:nil imageNamedNormal:@"mmbtm_photo_dft.png" imageNamedPressed:nil];
    addPhoto.tag = kPhoto;
    [optionView addSubview:addPhoto];
//    [addPhoto release];
    
#ifdef BearTalk
#else
    addLocation = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(addPhoto.frame.origin.x + addPhoto.frame.size.width + 5, addPhoto.frame.origin.y, addPhoto.frame.size.width, addPhoto.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"mmbtm_location_dft.png" imageNamedPressed:nil];
    addLocation.tag = kLocation;
    [optionView addSubview:addLocation];
//    [addLocation release];
#endif
    locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(addLocation.frame.origin.x + addLocation.frame.size.width, addLocation.frame.origin.y + 7, 160, 20)];
    locationLabel.textColor = [UIColor blackColor];
    locationLabel.font = [UIFont systemFontOfSize:14];
    [optionView addSubview:locationLabel];
    locationLabel.backgroundColor = [UIColor clearColor];
//    [locationLabel release];
    
    
    //    UIImageView *bgView = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"n00_globe_black_hide.png"]];
    //    bgView.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    //    bgView.hidden = YES;
    //    bgView.userInteractionEnabled = YES;
    //    [self.view addSubview:bgView];
    //    [bgView release];
    
    
    
//    UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
//        [button release];
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_done.png" target:self selector:@selector(tryPost)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    //    [button release];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"gestureRecognizer");
    if ([touch.view isKindOfClass:[UIButton class]]){
        return FALSE;
    }
    return TRUE;
}

//- (void)drawSliding{
//
//    [slidingMenuList removeAllObjects];
//
//    NSDictionary *dic;
////    dic = [NSDictionary dictionaryWithObjectsAndKeys:
////           @"",@"groupnumber",
////           @"모두 보기",@"groupname",
////           @"0",@"grouptype",
////           @"",@"groupmaster",
////           @"",@"groupicon",
////           @"",@"groupimage",
////           @"",@"groupexplain",
////           @"",@"accept",nil];
////    [slidingMenuList addObject:dic];
//
//    dic = [NSDictionary dictionaryWithObjectsAndKeys:
//           @"",@"groupnumber",
//           [SharedAppDelegate readPlist:@"myinfo"][@"name"],@"groupname",
//           @"",@"groupimage",
//           @"",@"groupmaster",
//           @"",@"groupicon",
//           @"0",@"grouptype",
//           @"",@"groupexplain",
//           @"",@"accept",nil];
//    [slidingMenuList addObject:dic];
//
//    NSLog(@"SharedAppDelegate.root.main.myList %@",SharedAppDelegate.root.main.myList);
//
//
//    for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
//                NSLog(@"dic %@",dic);
//        if([[dicobjectForKey:@"accept"]isEqualToString:@"Y"])
//        [slidingMenuList addObject:dic];
//    }
//
//
////if([slidingMenuList count]<)
//    slidingMenuTable.frame = CGRectMake(0, 0, 252, [slidingMenuList count]*37);
//    slidingImage.frame = CGRectMake(0, [slidingMenuList count]*37, 252, 25);
//    slidingMenuView.frame = CGRectMake(34, -400, 252, [slidingMenuList count]*37+25);
//
//    if([slidingMenuList count]>4){
//        slidingMenuTable.frame = CGRectMake(0, 0, 252, self.view.frame.size.height/2-75);
//        slidingImage.frame = CGRectMake(0, self.view.frame.size.height/2-75, 252, 25);
//        slidingMenuView.frame = CGRectMake(34, -400, 252, self.view.frame.size.height/2-50);
//    }
//
//
//}

//- (void)navigationBarTap:(UIGestureRecognizer*)recognizer {
//    NSLog(@"navigationBarTap");
//
////    [self slidingMenu];
//}

//- (void)slidingMenu
//{
//
//
//    if(showMenu)
//    {
//
//           bgView.hidden = YES;
//        NSLog(@"TapTap will hide");
//        [UIView animateWithDuration:0.25
//                         animations:^{
//
//                             slidingMenuView.frame = CGRectMake(34, -400, 252, [slidingMenuList count]*37+25);
//
//                             if([slidingMenuList count]>4){
//                                 slidingMenuView.frame = CGRectMake(34, -400, 252, self.view.frame.size.height/2-50);
//                             }
//                         }];
//        showMenu = NO;
//
//    }
//    else
//    {   bgView.hidden = NO;
//
//        NSLog(@"TapTap will show");
//        [UIView animateWithDuration:0.25
//                                                            animations:^{
//                                                                slidingMenuView.frame = CGRectMake(34, 0, 252, [slidingMenuList count]*37+25);
//
//                                                                if([slidingMenuList count]>4){
//                                                                    slidingMenuView.frame = CGRectMake(34, 0, 252, self.view.frame.size.height/2-50);
//                                                                }
//
//                                                            }];
//
//        showMenu = YES;
//    }
//
//}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return [slidingMenuList count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    if(indexPath.row == 0)
//    {
//        UIImageView *image = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"fitr_top_line.png"]];
//        cell.backgroundView = image;
//        [image release];
//    }
//    else{
//        UIImageView *image = [[UIImageView alloc]initWithImage:[CustomUIKit customImageNamed:@"fitr_top_line_02.png"]];
//        cell.backgroundView = image;
//        [image release];
//
//    }
//    cell.textLabel.text = [[slidingMenuListobjectatindex:indexPath.row]objectForKey:@"groupname"];
//    cell.textLabel.font = [UIFont systemFontOfSize:17];
////    cell.imageView.image = [CustomUIKit customImageNamed:[[[self menuArray]objectatindex:indexPath.row]objectForKey:@"image"]];
//    //    }// Configure the cell...
//
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    self.title = [NSString stringWithFormat:@"%@",[[slidingMenuListobjectatindex:indexPath.row]objectForKey:@"groupname"]];
//    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO];
////	[placeHolderLabel1 setText:[NSString stringWithFormat:@"지금 무슨 생각을 하나요?\n(%@ 타임라인에 소식이 공유됩니다.)",self.title]];//[self.title substringWithRange:NSMakeRange(7,[self.title length]-7)]]];
//
//    if(postTag == kPost){
//    NSString *msg = [NSString stringWithFormat:@"지금 어떤 생각을 하나요?\n(%@ 타임라인에 소식이 공유됩니다.",self.title];
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    NSLog(@"version %f",version);
//    if (version < 6.0){
//        placeHolderLabel.textColor = [UIColor grayColor];
//        [placeHolderLabel setText:msg];
//    }else{
//        NSArray *texts=[NSArray arrayWithObjects:@"지금 어떤 생각을 하나요?\n", @"(", self.title, @" 타임라인에 소식이 공유됩니다.)", nil];
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
//        [string addAttribute:NSForegroundColorAttributeName value:RGB(160, 18, 19) range:[msg rangeOfString:[textsobjectatindex:2]]];
////        [string addAttribute:NSForegroundColorAttributeName value:RGB(87, 107, 149) range:[msg rangeOfString:[textsobjectatindex:4]]];
//        [placeHolderLabel setAttributedText:string];
//    }
//    }
//    else{
//        placeHolderLabel.textColor = [UIColor grayColor];
//        [placeHolderLabel setText:@"쪽지 내용을 작성하세요.\n(쪽지는 공유되지 않고 수신자 개개인 별로 전달됩니다."];
//
//    }
//
//    NSLog(@"groupnum %@ targetuid %@",groupnum,targetuid);
//
////    if(groupnum){
////        [groupnum release];
////        groupnum = nil;
////    }
//    groupnum = [[NSString alloc]initWithFormat:@"%@",[[slidingMenuListobjectatindex:indexPath.row]objectForKey:@"groupnumber"]];
//    NSLog(@"groupnum %@ targetuid %@",groupnum,targetuid);
//    NSLog(@"indexpath.row %d",indexPath.row);
//    if(indexPath.row == 0)
//    {
//        targetuid = @"";
//        category = @"1";
//    }
//    else if(indexPath.row == 1)
//    {
////        if(targetuid){
////            [targetuid release];
////            targetuid = nil;
////        }
//
//        targetuid = [[NSString alloc]initWithFormat:@"%@",[ResourceLoader sharedInstance].myUID];
//        category = @"3";
//    }
//    else{
//        targetuid = @"";
//        category = @"2";
//    }
//    NSLog(@"target %@ type %@ num %@",targetuid,category,groupnum);
//    [self slidingMenu];
//
//}

- (void)notice:(id)sender{
    
    if(notify == 1){
        [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"checkokbtn_dft.png"] forState:UIControlStateNormal];
        notify = 0;
    }
    else{
        [noticeBtn setBackgroundImage:[CustomUIKit customImageNamed:@"checkokbtn_prs.png"] forState:UIControlStateNormal];
        notify = 1;
        
    }
}
- (void)addMember:(id)sender{
    switch (postTag) {
		case kNote:
		{
			AddMemberViewController *addController = [[AddMemberViewController alloc]initWithTag:1 array:memberArray add:nil];
			[addController setDelegate:self selector:@selector(saveArray:)];
			UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:addController];
			[self presentViewController:nc animated:YES completion:nil];
//			[nc release];
//			[addController release];
			break;
		}
		case kNoteGroup:
		{
            SelectDeptViewController *selectDeptController = [[SelectDeptViewController alloc] initWithTag:100];
			//			[selectDeptController setSelectedDeptList:selectedDeptArray];
			selectDeptController.rootTitle = @"쪽지 대상 선택";
			selectDeptController.selectedDeptList = [NSMutableArray arrayWithArray:(NSArray*)selectedDeptArray];
			[selectDeptController setDelegate:self selector:@selector(selectArray:)];
			UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:selectDeptController];
			[self presentViewController:nc animated:YES completion:nil];
//			[nc release];
//			[selectDeptController release];
			break;
		}
	}
}

- (void)selectArray:(NSArray *)list
{
	NSLog(@"list %@",list);
	[selectedDeptArray removeAllObjects];
	[selectedDeptArray addObjectsFromArray:list];
	
	NSMutableArray *selectMembers = [NSMutableArray array];
	for (NSDictionary *dic in [[ResourceLoader sharedInstance].contactList copy]) {
		if (![dic[@"uniqueid"] isEqualToString:[ResourceLoader sharedInstance].myUID] && [list containsObject:dic[@"deptcode"]]) {
			[selectMembers addObject:dic];
		}
	}
	
	if ([selectMembers count] > 0) {
		[self saveArray:selectMembers];
	} else {
		[CustomUIKit popupSimpleAlertViewOK:nil msg:@"선택한 부서에 포함된 직원이 없습니다!" con:self];
	}
	
}


- (void)saveArray:(NSArray *)list
{
    
    //    newArray = [[NSMutableArray alloc]initWithArray:list];
    //    NSLog(@"list %@",list);
    //
    //    for(NSDictionary *dic in list)
    //    {
    //        [memberArray addObject:dic];
    //
    //    }
    
    [memberArray removeAllObjects];
    [memberArray addObjectsFromArray:list];
    NSLog(@"memberarray %@",memberArray);
    
    NSString *toString = @"";
    if([memberArray count]==1)
        toString = [NSString stringWithFormat:@"%@",memberArray[0][@"name"]];
    
    
    else if([memberArray count]==2)
        toString = [NSString stringWithFormat:@"%@, %@",memberArray[0][@"name"],memberArray[1][@"name"]];
    
    
    else// if([memberArray count]>2)
    {
        toString = [NSString stringWithFormat:@"%@, %@ 외 %d명 [더보기]",memberArray[0][@"name"],memberArray[1][@"name"],(int)[memberArray count]-2];
        
        UIButton *viewButton = [[UIButton alloc]init];//WithFrame:CGRectMake(0,0,30,30)];
        viewButton.frame = toLabel.frame;
        //        viewButton.backgroundColor = [UIColor cl];
        //        viewButton.highlighted = NO;
        [viewButton addTarget:self action:@selector(viewList) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:viewButton];
//        [viewButton release];
        
    }
    [toLabel performSelectorOnMainThread:@selector(setText:) withObject:toString waitUntilDone:NO];
    
}


#define kNoteMember 2

- (void)viewList{
    
    EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:memberArray from:kNoteMember];
    NSLog(@"memberArray %@",memberArray);
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
//    [controller release];
//    [nc release];
}


- (void)tryPost//:(id)sender
{
    
    NSLog(@"trypost");
    NSLog(@"1");
    
    
    NSLog(@"2");
    
    NSString *newString = [contentsTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([newString length]<1 && [dataArray count] == 0 && [locationInfo length]<1){    NSLog(@"3");
        
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"내용을 입력해주세요." con:self];
        return;
    }
    if([contentsTextView.text length]>10000)
    {    NSLog(@"4");
        
        
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"10000자까지 전송할 수 있습니다." con:self];
        return;
    }
    if((postTag == kNote || postTag == kNoteGroup) && [memberArray count]==0){
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"대상을 추가하세요." con:self];
        return;
    }
    if(notify == 1){    NSLog(@"5");
        
        if([category isEqualToString:@"2"])
        {
            
//            UIAlertView *alert;
            NSString *msg = [NSString stringWithFormat:@"%@ 멤버에게 알림이 갑니다. 계속하시겠습니까?",self.title];
//            alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//			alert.tag = kAlertPost;
//            [alert show];
//            [alert release];
            [CustomUIKit popupAlertViewOK:@"" msg:msg delegate:self tag:kAlertPost sel:@selector(sendPost) with:nil csel:nil with:nil];
            return;
        }
        else if([category isEqualToString:@"0"] || [category isEqualToString:@"1"]){
            
//            UIAlertView *alert;
//            alert = [[UIAlertView alloc] initWithTitle:@"전체 직원에게 알림이 갑니다. 계속하시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//			alert.tag = kAlertPost;
//            [alert show];
//            [alert release];
            [CustomUIKit popupAlertViewOK:@"" msg:@"전체 직원에게 알림이 갑니다. 계속하시겠습니까?" delegate:self tag:kAlertPost sel:@selector(sendPost) with:nil csel:nil with:nil];
            return;
        }
    }
    else{    NSLog(@"6");
        NSLog(@"category %@",category);
        if([category isEqualToString:@"0"] || [category isEqualToString:@"1"]){
//            UIAlertView *alert;
//            alert = [[UIAlertView alloc] initWithTitle:@"전체 직원에게 공유됩니다. 계속하시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
//			alert.tag = kAlertPost;
//            [alert show];
//            [alert release];
            [CustomUIKit popupAlertViewOK:@"" msg:@"전체 직원에게 공유됩니다. 계속하시겠습니까?" delegate:self tag:kAlertPost sel:@selector(sendPost) with:nil csel:nil with:nil];
            return;
        }
    }
    NSLog(@"7");
    [self sendPost];
    
}

- (void)sendPost{
    
    NSLog(@"sendpost");
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
	
	UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
	[rightButton setEnabled:NO];
	[SVProgressHUD showWithStatus:@"전송 중" maskType:SVProgressHUDMaskTypeClear];

    
    
    NSLog(@"locationInfo %@",locationInfo);

    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/timeline.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    //    NSLog(@"selectedImageData %d",[selectedImageData length]);
//    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    //     = nil;
    NSMutableURLRequest *request;
    //    if(postType == kText)
    
    NSString *contenttype = @"1";
    NSString *type = @"1";
    NSString *writeinfotype = @"1";
    
    if(postTag == kNote || postTag == kNoteGroup){
        NSLog(@"member ");
        contenttype = @"7";
        type = @"5";
        targetuid = @"";
        targetuid = [targetuid stringByAppendingFormat:@"%@,",[ResourceLoader sharedInstance].myUID];
        for(NSDictionary *mdic in memberArray){
            targetuid = [targetuid stringByAppendingFormat:@"%@,",mdic[@"uniqueid"]];
        }
    }
    else{
        if([category isEqualToString:@"2"]){
            for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
                if([dic[@"groupnumber"]isEqualToString:groupnum]){
                    NSLog(@"group attribute %@",dic[@"groupattribute"]);
                    NSMutableArray *array = [NSMutableArray array];
                    for (int i = 0; i < [dic[@"groupattribute"] length]; i++) {
                        [array addObject:[NSString stringWithFormat:@"%C", [dic[@"groupattribute"] characterAtIndex:i]]];
                    }
                    
                    if([array count]>1){
                        if([array[1]isEqualToString:@"1"])
                            writeinfotype = @"10";
                    }
                    if([array count]>3){
                        type = array[3];
                    }
                }
            }
            
            
        }
    }
    
    if([category isEqualToString:@"0"])
        category = @"1";
    
    
    NSLog(@"category %@",category);
    NSLog(@"type %@",type);
    NSLog(@"contenttype %@",contenttype);
    NSLog(@"groupnum %@",groupnum);
    NSLog(@"targetuid %@",targetuid);
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:contentsTextView.text,@"msg",
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                category,@"category",
                                targetuid,@"targetuid",
                                [NSString stringWithFormat:@"%d",(int)notify],@"notify",
                                type,@"type",writeinfotype,@"writeinfotype",contenttype,@"contenttype",
                                locationInfo?locationInfo:@"",@"location",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                groupnum,@"groupnumber",
                                @"",@"privateuid",
                                @"1",@"replynotice",
                                @"",@"noticeuid",nil];
    
    NSLog(@"parameters %@",parameters);
    
    if([dataArray count]>0)//([selectedImageData length]>0)
    {
        
        NSLog(@"locationInfo %@ text %@",locationInfo,contentsTextView.text);
        
        NSString *timeStamp = [[NSString alloc]initWithFormat:@"%.0f.jpg",[[NSDate date] timeIntervalSince1970]];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        request = [client multipartFormRequestWithMethod:@"POST" path:@"/lemp/timeline/write/timeline.lemp" parameters:parameters JSONKey:@"" JSONParameter:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
        
        NSDictionary *paramdic = nil;
        request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"" JSONParameter:paramdic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        
            
            if([dataArray count] == 1){
                [formData appendPartWithFileData:dataArray[0][@"data"] name:@"filename" fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
            }
            else{
                for(int i = 0; i < [dataArray count]; i++){//NSData *imageData in dataArray){
                    [formData appendPartWithFileData:dataArray[i][@"data"] name:[NSString stringWithFormat:@"filename%d",i] fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
                }
            }
        }];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id  responseObject) {
            UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
            [rightButton setEnabled:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
			[SVProgressHUD dismiss];
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"resultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            if ([isSuccess isEqualToString:@"0"]) {
                //                [SharedAppDelegate.root.home getTimeline:nil];
                
                OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"쪽지가 성공적으로 발송되었습니다."];
            
                    toast.position = OLGhostAlertViewPositionCenter;
              
                toast.style = OLGhostAlertViewStyleDark;
                toast.timeout = 2.0;
                toast.dismissible = YES;
                [toast show];
//                [toast release];
                
                
                if(postTag == kPost){
                    
                    NSString *lastIndex = resultDic[@"resultMessage"];
                    if([lastIndex intValue]>[[SharedAppDelegate readPlist:groupnum]intValue])
                        [SharedAppDelegate writeToPlist:groupnum value:lastIndex];
                    
                    [SharedAppDelegate.root setNeedsRefresh:YES];
//                    [SharedAppDelegate.root.home refreshTimeline];//getTimeline:@"" target:SharedAppDelegate.root.home.targetuid type:SharedAppDelegate.root.home.ctype groupnum:SharedAppDelegate.root.home.groupnum];
                }
                else{
                    NSString *lastNote = resultDic[@"resultMessage"];
                    //                    if([lastNote intValue]>[[SharedAppDelegate readPlist:@"lastnote"]intValue])
                    //                    [SharedAppDelegate writeToPlist:@"lastnote" value:lastNote];
					[SharedAppDelegate.root.mainTabBar writeLastIndexForMode:@"lastnote" value:lastNote];
                    
                }
				[SharedAppDelegate.root.note setReserveRefresh:YES];
                [self cancel];
            }
            else{
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
                NSLog(@"not success but %@",isSuccess);
            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
            [rightButton setEnabled:YES];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
			[SVProgressHUD dismiss];
			[HTTPExceptionHandler handlingByError:error];
            NSLog(@"error: %@",  operation.responseString);
        }];
        
        
        [operation start];
        
    }
    else
    {
        
        NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/timeline.lemp",[SharedAppDelegate readPlist:@"was"]];
        NSURL *baseUrl = [NSURL URLWithString:urlString];
        
        
        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
        
        AFHTTPRequestOperation *operation;
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/timeline.lemp" parameters:parameters];
        
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
        
        
        operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
            [rightButton setEnabled:YES];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
			[SVProgressHUD dismiss];
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            
            NSString *isSuccess = resultDic[@"result"];
            NSLog(@"resultDic %@",resultDic);
            
            if ([isSuccess isEqualToString:@"0"]) {
                //                [SharedAppDelegate.root.home getTimeline:nil];
                if(postTag == kPost){
                    
                    NSString *lastIndex = resultDic[@"resultMessage"];
                    if([lastIndex intValue]>[[SharedAppDelegate readPlist:groupnum]intValue])
                        [SharedAppDelegate writeToPlist:groupnum value:resultDic[@"resultMessage"]];
                    
                    [SharedAppDelegate.root setNeedsRefresh:YES];
//                    [SharedAppDelegate.root.home refreshTimeline];//getTimeline:@"" target:SharedAppDelegate.root.home.targetuid type:SharedAppDelegate.root.home.ctype groupnum:SharedAppDelegate.root.home.groupnum];
                }
                else{
                    NSString *lastNote = resultDic[@"resultMessage"];
                    //                    if([lastNote intValue]>[[SharedAppDelegate readPlist:@"lastnote"]intValue])
                    //                    [SharedAppDelegate writeToPlist:@"lastnote" value:resultDic[@"resultMessage"]];
					[SharedAppDelegate.root.mainTabBar writeLastIndexForMode:@"lastnote" value:lastNote];
                    
                }
				[SharedAppDelegate.root.note setReserveRefresh:YES];
                [self cancel];
                
            }else {
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
                NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
            [rightButton setEnabled:YES];
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
			[SVProgressHUD dismiss];
            NSLog(@"FAIL : %@",operation.error);
			[HTTPExceptionHandler handlingByError:error];
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"글쓰기를 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
            //            [alert show];
            
        }];
        
        [operation start];
    }
    
    //    else if{
    //
    //        parameters = [NSDictionary dictionaryWithObjectsAndKeys:
    //                      [dicobjectForKey:@"uniqueid"],@"uid",
    //                      @"1",@"category",
    //                      [NSString stringWithFormat:@"%d",notify],@"notify",
    //                      [NSString stringWithFormat:@"%d",postType],@"messagetype",
    //    @"",@"scheduletitle",
    //    @"",@"schedulemsg",
    //    @"",@"schedulestarttime",
    //    @"",@"scheduleendtime",
    //    @"",@"schedulemember",
    //    @"",@"schedulemembercc",
    //    @"",@"schedulelocation",
    //                      [ResourceLoader sharedInstance].mySessionkey,@"sesseionkey",
    //                      nil];
    //
    //    }
    
    
}


- (void)keyboardWasShown:(NSNotification *)noti
{
    NSLog(@"keyboardWasShown");
    
    NSDictionary *info = [noti userInfo];
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    float currentKeyboardHeight = [value CGRectValue].size.height;
    NSLog(@"current %f",currentKeyboardHeight);
    
	optionView.frame = CGRectMake(0, self.view.frame.size.height - currentKeyboardHeight - optionView.frame.size.height, 320, optionView.frame.size.height);
    
	
    //    NSValue *aniValue = info[UIKeyboardAnimationDurationUserInfoKey];
    //    NSTimeInterval aniDuration;
    //    [aniValue getValue:&aniDuration];
    //
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:aniDuration];
    //    [UIView setAnimationDelegate:self];
    
	[self refreshPreView];
    
    //    contentView.frame = CGRectMake(6, 45 + 15, 308, self.view.frame.size.height - currentKeyboardHeight - 45 - 15 - 15);
    //    bottomRoundImage.frame = CGRectMake(6, contentView.frame.origin.y + contentView.frame.size.height, 308, 9);
    //    addPhoto.frame = CGRectMake(10, contentView.frame.size.height - 41, 45, 41);
    //    addLocation.frame = CGRectMake(addPhoto.frame.origin.x + addPhoto.frame.size.width + 5, contentView.frame.size.height - 41, 45, 41);
    //    contentsTextView.frame = CGRectMake(5, 5, contentView.frame.size.width - 5,
    //                                        contentView.frame.size.height - addLocation.frame.size.height - 10);
    
    
    //    CGRect contentFrame = contentView.frame;
    //    contentFrame.size.height -= currentKeyboardHeight;
    //    contentView.frame = contentFrame;
    //    CGRect textviewFrame = contentsTextView.frame;
    //    textviewFrame.size.height -= currentKeyboardHeight;
    //    contentsTextView.frame = textviewFrame;
    //
    //    CGRect bottomFrame = bottomRoundImage.frame;
    //    bottomFrame.origin.y -= currentKeyboardHeight;
    //    bottomRoundImage.frame = bottomFrame;
    //    CGRect locationFrame = addLocation.frame;
    //    locationFrame.origin.y -= currentKeyboardHeight;
    //    addLocation.frame = locationFrame;
    
    //    [UIView commitAnimations];
    
}
//- (void)keyboardWillHide:(NSNotification *)noti
//{
//    NSLog(@"keyboardWillHide");
//
//    NSDictionary *info = [noti userInfo];
//    NSValue *value = [infoobjectForKey:UIKeyboardFrameEndUserInfoKey];
//    float currentKeyboardHeight = [value CGRectValue].size.height;
//    NSValue *aniValue = [infoobjectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval aniDuration;
//    [aniValue getValue:&aniDuration];
//
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:aniDuration];
//    [UIView setAnimationDelegate:self];
//
//    CGRect contentFrame = contentView.frame;
//    contentFrame.size.height += currentKeyboardHeight;
//    contentView.frame = contentFrame;
//    CGRect textviewFrame = contentsTextView.frame;
//    textviewFrame.size.height += currentKeyboardHeight;
//    contentsTextView.frame = textviewFrame;
//
//    CGRect bottomFrame = bottomRoundImage.frame;
//    bottomFrame.origin.y += currentKeyboardHeight;
//    bottomRoundImage.frame = bottomFrame;
//    CGRect locationFrame = addLocation.frame;
//    locationFrame.origin.y += currentKeyboardHeight;
//    addLocation.frame = locationFrame;
//
//    [UIView commitAnimations];
//}
//- (void)tap
//{
//    [contentsTextView resignFirstResponder];
////    [UIView beginAnimations:nil context:nil];
////    [UIView setAnimationDuration:0.3f];
////    [UIView setAnimationDelegate:self];
////    contentsTextView.frame = CGRectMake(5, 5, bgView.frame.size.width - addPhoto.frame.size.width - 15,
////                                        bgView.frame.size.height - addLocation.frame.size.height - 20);
////    addLocation.frame = CGRectMake(5, bgView.frame.size.height - 30 - 10, bgView.frame.size.width - 10, 30);
////    [UIView commitAnimations];
//}
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//
//    if ([touch.view isKindOfClass:[UIButton class]]){
//        return FALSE;
//    }
//    return TRUE;
//}

- (void)deleteEachPhoto:(id)sender{
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"사진 삭제"
                                                                                 message:@"사진이 삭제됩니다.\n계속하시겠습니까?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", @"yes")
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                           [self confirmAlertPhoto:(int)[sender tag]];
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", @"no")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:cancelb];
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"사진 삭제" message:@"사진이 삭제됩니다.\n계속하시겠습니까?" delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
        
        NSString *tagString = [NSString stringWithFormat:@"%d",(int)[sender tag]];
        objc_setAssociatedObject(alert, &paramNumber, tagString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    alert.tag = kAlertPhoto;
    [alert show];
//    [alert release];
    }
    
    
    
    
}

- (void)refreshPreView{
    
    
    
    if([dataArray count]>0){
        [photoCountLabel setText:[NSString stringWithFormat:@"%d/5",(int)[dataArray count]]];
        photoCountLabel.hidden = NO;
        [addPhoto setBackgroundImage:[CustomUIKit customImageNamed:@"wrt_photodel.png"] forState:UIControlStateNormal];
        
        if(preView){
            [preView removeFromSuperview];
//            [preView release];
            preView = nil;
        }
        
        preView = [[UIImageView alloc]init];
        preView.frame = CGRectMake(0,optionView.frame.origin.y - 60, 320, 60);
        preView.userInteractionEnabled = YES;
        
        CGRect countFrame = countLabel.frame;
        countFrame.origin.y = preView.frame.origin.y - 20 - 50;
        countLabel.frame = countFrame;
        
        CGRect pCountFrame = photoCountLabel.frame;
        pCountFrame.origin.y = preView.frame.origin.y - 15;
        photoCountLabel.frame = pCountFrame;
        
        CGRect conFrame = contentsTextView.frame;
        conFrame.size.height = countLabel.frame.origin.y + 3;
        contentsTextView.frame = conFrame;
        
        
        
        preView.image = [UIImage imageNamed:@"wrt_photosline_ptn.png"];
        [self.view addSubview:preView];
        for(int i = 0; i < [dataArray count]; i++){
            UIImageView *inImageView = [[UIImageView alloc]init];
            inImageView.frame = CGRectMake(4 + 65 *i, 4, 52, 52);
            [inImageView setContentMode:UIViewContentModeScaleAspectFill];
            [inImageView setClipsToBounds:YES];
            UIImage *img = dataArray[i][@"image"];
            inImageView.image = img;
            [preView addSubview:inImageView];
            inImageView.userInteractionEnabled = YES;
            UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,52,52)];
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"wrt_photobgdel.png"] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteEachPhoto:) forControlEvents:UIControlEventTouchUpInside];
            deleteButton.tag = i;
            [inImageView addSubview:deleteButton];
//            [deleteButton release];
//            [inImageView release];
        }
            
            UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
            [rightButton setEnabled:YES];
    
    }
    else{
        [self deletePhotos];
        //        [addPhoto setBackgroundImage:[CustomUIKit customImageNamed:@"wrt_photobg.png"] forState:UIControlStateNormal];
    }
}

- (void)deletePhotos{
    
    photoCountLabel.hidden = YES;
    
    CGRect countFrame = countLabel.frame;
    countFrame.origin.y = optionView.frame.origin.y - 20 - 50;
    countLabel.frame = countFrame;
    
    CGRect pCountFrame = photoCountLabel.frame;
    pCountFrame.origin.y = optionView.frame.origin.y - 15;
    photoCountLabel.frame = pCountFrame;
    
    
    CGRect conFrame = contentsTextView.frame;
    //    CGRect bottomFrame = bottomRoundImage.frame;
    conFrame.size.height = countLabel.frame.origin.y + 3;
    contentsTextView.frame = conFrame;
    //    bottomFrame.origin.y = contentView.frame.origin.y + contentView.frame.size.height;
    //    bottomRoundImage.frame = bottomFrame;
    if(preView){
        [preView removeFromSuperview];
//        [preView release];
        preView = nil;
    }
    //    if(dataArray){
    [dataArray removeAllObjects];
    //    [dataArray release];
    //    dataArray = nil;
    //    }
    [addPhoto setBackgroundImage:[CustomUIKit customImageNamed:@"mmbtm_photo_dft.png"] forState:UIControlStateNormal];
    
    if([contentsTextView.text length]>0){
        
        UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
        [rightButton setEnabled:YES];
    }
    else{
        
        UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
        [rightButton setEnabled:NO];
    }
}

- (void)confirmAlertPhoto:(int)t{
    NSLog(@"confirmAlertPhoto t %d",t);
    [dataArray removeObjectAtIndex:t];
    [self refreshPreView];
    
    //			if (selectedImageData) {
    //				[selectedImageData release];
    //				selectedImageData = nil;
    //			}
    [self refreshPreView];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        if(alertView.tag == kAlertPost){
            [self sendPost];
        }
        else if(alertView.tag == kAlertPhoto){
            NSString *tagString = objc_getAssociatedObject(alertView, &paramNumber);
            [self confirmAlertPhoto:[tagString intValue]];
        }
        
    }
}



- (void)cancel//:(id)sender
{
    NSLog(@"backTo");
    //    self.viewDeckController.centerController = SharedAppDelegate.timelineController;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"textViewDidBeginEditing");
    //    NSLog(@"self.view.frame.size.height %f",self.view.frame.size.height);
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.3f];
    //    [UIView setAnimationDelegate:self];
    //    bgView.frame = CGRectMake(50, 0, 320-60, self.view.frame.size.height+20-35-216); // keyboard height
    //    contentsTextView.frame = CGRectMake(5, 5, bgView.frame.size.width - addPhoto.frame.size.width - 15,
    //                                        bgView.frame.size.height - addLocation.frame.size.height - 20);
    //    addLocation.frame = CGRectMake(5, bgView.frame.size.height - 30 - 10, bgView.frame.size.width - 10, 30);
    //                              [UIView commitAnimations];
}
-(void)textViewDidChange:(UITextView *)_textView {
    if (_textView.text.length == 0){
        [placeHolderLabel setHidden:NO];
        
        if([dataArray count]>0){
            
            UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
            [rightButton setEnabled:YES];
        }
        else{
            
            UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
            [rightButton setEnabled:NO];
        }
    }
    else{
        [placeHolderLabel setHidden:YES];
        UIBarButtonItem *rightButton = [self.navigationItem.rightBarButtonItems lastObject];
        [rightButton setEnabled:YES];
    }

    
    
    countLabel.text = [NSString stringWithFormat:@"%d/10,000",(int)[_textView.text length]];
    
	[SharedFunctions adjustContentOffsetForTextView:_textView];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if ([SVProgressHUD isVisible]) {
		return NO;
	}
	
	return YES;
}
//- (void)setLock:(id)sender
//{
//    UIButton *button = (UIButton *)sender;
//    if(button.selected)
//    {
//        [button setBackgroundImage:[CustomUIKit customImageNamed:@"n04_grp_ifoic_prs.png"] forState:UIControlStateNormal];
//        button.selected = NO;
//    }
//    else{
//        [button setBackgroundImage:[CustomUIKit customImageNamed:@"n04_grp_ifoic_dft.png"] forState:UIControlStateNormal];
//        button.selected = YES;
//
//    }
//}

- (void)cmdButton:(id)sender
{
    //    [self tap];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
  
        
        if([sender tag] == kPhoto){
            
            
            if([dataArray count]<5){
                
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
                                    
                                    
                                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                    picker.delegate = self;
                                    picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
                                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                    [self presentViewController:picker animated:YES completion:nil];
//                                    [picker release];
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"앨범에서 사진 선택"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    [SharedAppDelegate.root launchQBImageController:5-[dataArray count] con:self];
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                UIAlertAction* cancel = [UIAlertAction
                                         actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [view dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                
                [view addAction:cancel];
                [self presentViewController:view animated:YES completion:nil];

                
                
                
            }
            else{
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"첨부는 5장까지 가능합니다." con:self];
            }
        }
        else if([sender tag] == kLocation){
            
            if(locationInfo){
                
                
                UIAlertController * view=   [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@""
                                             preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *actionButton;
                
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"위치 삭제"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    if(locationInfo){
//                                        [locationInfo release];
                                        locationInfo = nil;
                                    }
                                    [addLocation setBackgroundImage:[CustomUIKit customImageNamed:@"mmbtm_location_dft.png"] forState:UIControlStateNormal];
                                    [locationLabel performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"위치 재설정"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    [self loadMap];
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                UIAlertAction* cancel = [UIAlertAction
                                         actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [view dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                
                [view addAction:cancel];
                [self presentViewController:view animated:YES completion:nil];
                
                
                
            }
            else{
                [self loadMap];
            }
        }
        
        
    }
    else{
    UIActionSheet *actionSheet = nil;
    
    if([sender tag] == kPhoto){
        
        
        if([dataArray count]<5){
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                        destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기" , @"앨범에서 사진 선택", nil];
            actionSheet.tag = [sender tag];
        }
        else{
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"첨부는 5장까지 가능합니다." con:self];
        }
    }
    else if([sender tag] == kLocation){
        
        if(locationInfo){
			actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
										destructiveButtonTitle:nil otherButtonTitles:@"위치 삭제", @"위치 재설정", nil];
			actionSheet.tag = [sender tag];
        }
        else{
            [self loadMap];
        }
    }
    [actionSheet showInView:SharedAppDelegate.window];
    }
}

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(actionSheet.tag == kPhoto)
	{
		switch (buttonIndex) {
			case 0:
			{
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				picker.delegate = self;
				picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
				picker.sourceType = UIImagePickerControllerSourceTypeCamera;
				[self presentViewController:picker animated:YES completion:nil];
//				[picker release];
				break;
			}
			case 1:
                [SharedAppDelegate.root launchQBImageController:5-[dataArray count] con:self];
				break;
			default:
				break;
		}
	}
    //	else if(actionSheet.tag == kPhotoExist)
    //	{
    //		switch (buttonIndex) {
    //			case 0:
    //			{
    //				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //				picker.delegate = self;
    //				picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
    //				picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //				[self presentViewController:picker animated:YES];
    //				[picker release];
    //				break;
    //			}
    //			case 1:
    //				//            picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
    //				//            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //				//            [self presentViewController:picker animated:YES];
    //
    //				[SharedAppDelegate.root launchQBImageController:5 con:self];
    //				break;
    //						default:
    //				break;
    //		}
    //	}
    else if(actionSheet.tag == kLocation)
    {
        switch (buttonIndex) {
            case 0:
                if(locationInfo){
//					[locationInfo release];
					locationInfo = nil;
                }
                [addLocation setBackgroundImage:[CustomUIKit customImageNamed:@"mmbtm_location_dft.png"] forState:UIControlStateNormal];
                [locationLabel performSelectorOnMainThread:@selector(setText:) withObject:@"" waitUntilDone:NO];
                break;
            case 1:
                [self loadMap];
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
    
    NSMutableArray *infoArray = [NSMutableArray array];
    for (PHAsset *asset in assets) {
        [imageManager requestImageDataForAsset:asset
                                       options:0
                                 resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                                     if([imageData length]<1){
                                         
                                         [CustomUIKit popupSimpleAlertViewOK:nil msg:@"이미지가 너무 작아 첨부할 수 없는 이미지가 있습니다." con:self];
                                         return;
                                     }
                                     UIImage *image = [UIImage imageWithData:imageData];
                                     
                                     if(image.size.width > 640 || image.size.height > 960) {
                                         image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
                                     }
                                     
                                     NSData *aimageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
                                     NSLog(@"imageData length %d",(int)[aimageData length]);
                                     [infoArray addObject:@{@"image" : image, @"data" : aimageData}];
                                     
                                     if([assets count] == [infoArray count]){
                                         
                                         NSLog(@"infoArray count %d",(int)[infoArray count]);
                                         PhotoTableViewController *photoTable = [[PhotoTableViewController alloc]initForUpload:infoArray parent:self];
                                         
                                         UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:photoTable];
                                         //                                         [picker pushView:photoTable animated:YES];
                                         
                                         [picker presentViewController:nc animated:YES completion:nil];
                                     }
                                 }];
    }
    
    
    
    
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    NSLog(@"qb_imagePickerControllerDidCancel");
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}

#else

#pragma mark - QBImagePickerControllerDelegate

- (void)qbimagePickerController:(QBImagePickerController *)picker didFinishPickingMediaWithInfo:(id)info
{
    NSArray *mediaInfoArray = (NSArray *)info;
    
    NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:[info count]];
    
    for(NSDictionary *dict in mediaInfoArray) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        
        if(image.size.width > 640 || image.size.height > 960) {
            image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
        }
        
        NSData *imageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
        NSLog(@"imageData length %d",(int)[imageData length]);
        [infoArray addObject:@{@"image" : image, @"data" : imageData}];
//        [imageData release];
    }
    
    
    PhotoTableViewController *photoTable = [[PhotoTableViewController alloc]initForUpload:infoArray parent:self];
    
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:photoTable];
    //                                         [picker pushView:photoTable animated:YES];
    
    [picker presentViewController:nc animated:YES completion:nil];
}

#endif
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
	//	NSLog(@"ipicker %@",info);
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self sendPhoto:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
//	else {
//        PhotoViewController *photoView = [[[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] autorelease];
//        [picker presentViewController:photoView animated:YES];
//    }
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
	[picker dismissViewControllerAnimated:YES completion:nil];
}





- (void)saveImages:(NSMutableArray *)array{
    
    
    NSLog(@"dataArray %@",dataArray);
    //    NSLog(@"array %@",array);
    //    if(dataArray){
    //        [dataArray release];
    //        dataArray = nil;
    //    }
    //    dataArray = [[NSMutableArray alloc]init];//WithArray:array];
    [dataArray addObjectsFromArray:array];
    [self refreshPreView];
    
}
- (void)sendPhoto:(UIImage*)image
{
	
	if(image.size.width > 640 || image.size.height > 960) {
		image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
	}
	
	NSData *imageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
    //    UIImage *roundingImage = [SharedAppDelegate.root roundCornersOfImage:[UIImage imageWithData:imageData] scale:100];
    [dataArray addObject:@{@"data" : imageData, @"image" : image}];
//    [imageData release];
    //    UIImage *roundingImage = [SharedAppDelegate.root roundCornersOfImage:[UIImage imageWithData:selectedImageData] scale:100];
    //	[addPhoto setBackgroundImage:roundingImage forState:UIControlStateNormal];
	[self refreshPreView];
}


- (void)loadMap//:(id)sender
{
    
    //    [contentsTextView resignFirstResponder];
    MapViewController *mvc = [[MapViewController alloc] initForTimeLine];
	[mvc setDelegate:self selector:@selector(setLocation:)];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:mvc];
	[self presentViewController:nc animated:YES completion:nil];
//    [nc release];
//	[mvc release];
}

- (void)setLocation:(NSString*)location {
	NSArray *array = [location componentsSeparatedByString:@","];
    NSLog(@"array %@",array);
    
    //    [addLocation performSelectorOnMainThread:@selector(setBackgroundImage:) withObject:[CustomUIKit customImageNamed:@"n02_whay_btn_02.png"] waitUntilDone:NO];
    //    [locationLabel performSelectorOnMainThread:@selector(setText:) withObject:[[placeArray[indexPath.row]objectForKey:@"name"] waitUntilDone:YES];
    [addLocation setBackgroundImage:[CustomUIKit customImageNamed:@"mmbtm_location_prs.png"] forState:UIControlStateNormal];
	if ([array[2] isEqualToString:@""] || [array[2] isEqualToString:@"(null)"] || array[2] == nil)
	{
		[locationLabel performSelectorOnMainThread:@selector(setText:) withObject:@"위치" waitUntilDone:NO];
	} else {
		[locationLabel performSelectorOnMainThread:@selector(setText:) withObject:array[2] waitUntilDone:NO];
	}
	if (locationInfo) {
//		[locationInfo release];
        locationInfo = nil;
	}
	locationInfo = [[NSString alloc] initWithString:location];
    
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
    
    
    //	[self removeKeyBoardNoti];
}
//- (void)dealloc
//{
//    // Release any retained subviews of the main view.
////    [targetuid release];
////    [groupnum release];
////    [category release];
////    [memberArray release];
////	[selectedDeptArray release];
////	[dataArray release];
//	[super dealloc];
//}


@end
