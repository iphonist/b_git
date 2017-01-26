
//  HomeTimelineViewController.m
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 8..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "ECMDMainViewController.h"
#import "SVPullToRefresh.h"

@interface ECMDMainViewController ()

@end



@implementation ECMDMainViewController



@synthesize myList;
@synthesize myTable;
@synthesize noticeBadgeCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        NSLog(@"main init");
        
        
#ifdef BearTalk
        self.title = @"대웅생활";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSetupButton) name:@"refreshPushAlertStatus" object:nil];
#else
        self.title = @"컨텐츠";
#endif
        
        
        self.view.backgroundColor = RGB(242,242,242);
        
        
#ifdef BearTalk
        self.view.backgroundColor = RGB(238, 242, 245);
#endif
        
        noticeBadgeCount = 0;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    
    gsetup = [[GreenSetupViewController alloc] init];
    
    lastInteger = 0;
    
    myList = [[NSMutableArray alloc]init];
    CGRect tableFrame;
    
    
    
    tableFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - VIEWY); // 네비(44px) + 상태바(20px)
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    myTable = [[UICollectionView alloc] initWithFrame:tableFrame collectionViewLayout:layout];
    [myTable setDataSource:self];
    [myTable setDelegate:self];
    myTable.backgroundColor = [UIColor clearColor];
    [myTable registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    [self.view addSubview:myTable];
    myTable.scrollsToTop = YES;
    
    
    
    
#ifdef BearTalk
    
    
    NSLog(@"SharedAppDelegate.root.main %@",SharedAppDelegate.root.main);
    
    UIBarButtonItem *btnNaviNotice;
    
    NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
    if([colorNumber isEqualToString:@"2"]){
        
    noticebutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(settingNotiList) frame:CGRectMake(0, 0, 25, 25)
                               imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_alarm_urusa.png" imageNamedPressed:nil];
    
    }
    else if([colorNumber isEqualToString:@"4"]){
        
        noticebutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(settingNotiList) frame:CGRectMake(0, 0, 25, 25)
                                   imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_alarm_impactamin.png" imageNamedPressed:nil];
    }
    else if([colorNumber isEqualToString:@"3"]){
        
        noticebutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(settingNotiList) frame:CGRectMake(0, 0, 25, 25)
                                   imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_alarm_ezn6.png" imageNamedPressed:nil];
    }
    else{
        
        noticebutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(settingNotiList) frame:CGRectMake(0, 0, 25, 25)
                                   imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_alarm.png" imageNamedPressed:nil];
    }
    
    btnNaviNotice = [[UIBarButtonItem alloc]initWithCustomView:noticebutton];
    
    
    UIBarButtonItem *btnNavi;
    //    [noticeView release];
//    UIButton *button;
    setupButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(loadGreenSetup:) frame:CGRectMake(0, 0, 25, 25)
                         imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_ect.png" imageNamedPressed:nil];
    
    [self refreshSetupButton];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:setupButton];
    
    
    NSArray *arrBtns = [[NSArray alloc]initWithObjects:btnNavi, btnNaviNotice, nil]; // 순서는 거꾸로
    self.navigationItem.rightBarButtonItems = arrBtns;
    
    
    
    //    noticeBadge.hidden = YES;
#endif
    
    
}

- (void)loadGreenSetup:(id)sender{
    
    
    //			[self.navigationController pushViewController:setup animated:YES];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:gsetup];
    [SharedAppDelegate.root anywhereModal:nc];
    //    [setup release];
    //    [nc release];
}



- (void)addGroupDic:(NSDictionary *)dic{
    NSLog(@"addgroup %@",dic);
    [myList addObject:dic];
    [myTable reloadData];
}

- (void)setRightBadge:(int)n{
    
    NSLog(@"n %d",n);
    //    rlabel.text = [NSString stringWithFormat:@"%d",n];
    //
    //    if(n == 0)
    //        rbadge.hidden = YES;
    //    else
    //        rbadge.hidden = NO;
    //    [SharedAppDelegate.root.home setRightBadge:n];
}



- (void)setGroupList:(NSMutableArray *)list{
    
    NSLog(@"setGroupList");
    
    [myList setArray:list];
    [myTable reloadData];
}

#ifdef BearTalk

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForItemAtIndexPath");
    
    //    NSLog(@"mainCellForRow");
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.contentView.userInteractionEnabled = YES;
    UIImageView *bg, *coverImage, *new, *invitationImage, *coverOverImage, *borderImage;
    UIView *infoView;
    UILabel *name, *explain, *newSocialLabel;//, *supporterGroup;
    //    UILabel *invitationMemberLabel;
    UIButton *accept, *deny;
    UILabel *acceptLabel, *denyLabel;
    //
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        cell.backgroundColor = [UIColor redColor];
    //    if(cell == nil){
    
    bg = (UIImageView*)[cell.contentView viewWithTag:100];
    coverImage = (UIImageView*)[cell.contentView viewWithTag:200];
    coverOverImage = (UIImageView*)[cell.contentView viewWithTag:1000];
    infoView = (UIView*)[cell.contentView viewWithTag:600];
    name = (UILabel*)[cell.contentView viewWithTag:700];
    explain = (UILabel*)[cell.contentView viewWithTag:800];
    
    invitationImage = (UIImageView*)[cell.contentView viewWithTag:300];
    deny = (UIButton *)[cell.contentView viewWithTag:400];
    accept = (UIButton *)[cell.contentView viewWithTag:500];
    
    denyLabel = (UILabel*)[cell.contentView viewWithTag:40];
    acceptLabel = (UILabel*)[cell.contentView viewWithTag:50];
    
    new = (UIImageView*)[cell.contentView viewWithTag:900];
    newSocialLabel = (UILabel *)[cell.contentView viewWithTag:901];
    borderImage = (UIImageView *)[cell.contentView viewWithTag:2000];
    

    if(bg == nil){
        bg = [[UIImageView alloc]init];
        bg.userInteractionEnabled = YES;
        bg.frame = CGRectMake(0, 0, 136, 171);
        
        
        bg.frame = CGRectMake(0,0,[SharedFunctions scaleFromWidth:165],[SharedFunctions scaleFromHeight:215]);
        //        bg.frame = CGRectMake(0,0,(self.view.frame.size.width/2)-7-16,215);
        //        bg.frame = CGRectInset(cell.contentView.bounds, 0, 0);
        //        bg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        NSLog(@"bg frame %@",NSStringFromCGRect(bg.frame));
        
        //		bg.image = [UIImage imageNamed:@"group_whlinebg.png"];
        bg.tag = 100;
        [cell.contentView addSubview:bg];
        
        //        [bg release];
        
    }
    
    if(coverImage == nil){
        coverImage = [[UIImageView alloc]init];
        coverImage.frame = CGRectMake(6,8,122,65);
        
        coverImage.frame = CGRectMake(0,0,bg.frame.size.width,[SharedFunctions scaleFromHeight:138+20]);
        
        [coverImage setContentMode:UIViewContentModeScaleAspectFill];
        [coverImage setClipsToBounds:YES];
        coverImage.tag = 200;
        
        [bg addSubview:coverImage];
        //        [coverImage release];
    }
    
    
    
    if(infoView == nil){
        infoView = [[UIView alloc]init];
        infoView.frame = CGRectMake(coverImage.frame.origin.x, coverImage.frame.size.height, coverImage.frame.size.width, 171-65-8-8);
        infoView.backgroundColor = [UIColor clearColor];
        
        infoView.backgroundColor = [UIColor whiteColor];
        infoView.frame = CGRectMake(coverImage.frame.origin.x, coverImage.frame.size.height, coverImage.frame.size.width, bg.frame.size.height - coverImage.frame.size.height);
        
        //    whiteCoverImage.image = [UIImage imageNamed:@"scg_photo_cover.png"];//AspectFill];//AspectFit];//ToFill];
        infoView.tag = 600;
        [bg addSubview:infoView];
        //        [infoView release];
    }
    if(name == nil){
        
        
        name = [CustomUIKit labelWithText:nil fontSize:12 fontColor:RGB(32, 32, 32) frame:CGRectMake(12, 5, infoView.frame.size.width - 24, infoView.frame.size.height-10) numberOfLines:2 alignText:NSTextAlignmentCenter];
        name.font = [UIFont systemFontOfSize:14];
        
        
        
        name.tag = 700;
        
        [infoView addSubview:name];

    }
    if(explain == nil){
        
        
        explain = [CustomUIKit labelWithText:nil fontSize:11 fontColor:RGB(151,152,157) frame:CGRectMake(name.frame.origin.x, CGRectGetMaxY(name.frame), name.frame.size.width, infoView.frame.size.height - CGRectGetMaxY(name.frame)-3) numberOfLines:2 alignText:NSTextAlignmentCenter];
        
        [infoView addSubview:explain];
        
        explain.tag = 800;

        explain.hidden = YES;

    }
    
    if(invitationImage == nil){
        invitationImage = [[UIImageView alloc]init];
        invitationImage.userInteractionEnabled = YES;
        invitationImage.frame = CGRectMake(0,0,136,171);
        invitationImage.image = [UIImage imageNamed:@"imageview_main_invite.png"];
        
        
        
        invitationImage.frame = CGRectMake(0,0,bg.frame.size.width,bg.frame.size.height);
        invitationImage.image = [UIImage imageNamed:@"n00_globe_black_hide.png"];
        
        invitationImage.tag = 300;
        [bg addSubview:invitationImage];
        //        [invitationImage release];
    }
    if(acceptLabel == nil){
        acceptLabel = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(10, 70, 53, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
        acceptLabel.font = [UIFont boldSystemFontOfSize:15];
        acceptLabel.backgroundColor = RGB(167, 201, 77);
        
        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        acceptLabel.backgroundColor =  [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        acceptLabel.textColor = [UIColor whiteColor];
        
        acceptLabel.layer.cornerRadius = 3.0; // rounding label
        acceptLabel.clipsToBounds = YES;
        acceptLabel.tag = 50;
        acceptLabel.userInteractionEnabled = YES;
        [invitationImage addSubview:acceptLabel];
        acceptLabel.text = @"가입";
    }
    
    
    if(coverOverImage == nil){
        coverOverImage = [[UIImageView alloc]init];
        
        coverOverImage.frame = bg.frame;
        
        coverOverImage.image = [UIImage imageNamed:@"social_cover.png"];
        coverOverImage.tag = 1000;
        [bg addSubview:coverOverImage];
        
        //        [coverOverImage release];
    }
    
    
    
    
    if(accept == nil){
        accept = [[UIButton alloc]init];
        accept.frame = CGRectMake(0,0,acceptLabel.frame.size.width,acceptLabel.frame.size.height);
        
        [accept addTarget:self action:@selector(acceptInvite:) forControlEvents:UIControlEventTouchUpInside];
        accept.tag = 500;
        [acceptLabel addSubview:accept];
        //        [accept release];
    }
    
    if(denyLabel == nil){
        denyLabel = [CustomUIKit labelWithText:nil fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(CGRectGetMaxX(acceptLabel.frame)+10, acceptLabel.frame.origin.y, acceptLabel.frame.size.width, acceptLabel.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
        denyLabel.font = [UIFont boldSystemFontOfSize:15];
        denyLabel.backgroundColor = RGB(228, 229, 224);
        denyLabel.layer.cornerRadius = 3.0; // rounding label
        denyLabel.clipsToBounds = YES;
        denyLabel.tag = 40;
        denyLabel.userInteractionEnabled = YES;
        [invitationImage addSubview:denyLabel];
        denyLabel.text = @"거절";
    }
    if(deny == nil){
        deny = [[UIButton alloc]init];
        deny.frame = CGRectMake(0,0,denyLabel.frame.size.width,denyLabel.frame.size.height);
        
        [deny addTarget:self action:@selector(denyInvite:) forControlEvents:UIControlEventTouchUpInside];
        deny.tag = 400;
        [denyLabel addSubview:deny];
        //        [deny release];
    }
    if(borderImage == nil){
        borderImage = [[UIImageView alloc]init];
        borderImage.frame = CGRectMake(0, 0, 140, 165);
        
        borderImage.image = [UIImage imageNamed:@"imageview_main_all_rounding.png"];
        borderImage.tag = 2000;
        [bg addSubview:borderImage];
        //        [borderImage release];
        
    }
    
    
    if(new == nil){
        
        new = [[UIImageView alloc]init];
        
        
        new.backgroundColor = RGB(89, 198, 244);
        new.layer.cornerRadius = 7;
        new.clipsToBounds = YES;
        new.frame = CGRectMake(12, 12, 45, 17);
        
        
        new.tag = 900;
        
        [bg addSubview:new];
        //        [new release];
        
    }
    
    if(newSocialLabel == nil){
        newSocialLabel = [CustomUIKit labelWithText:nil fontSize:10 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, new.frame.size.width, new.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
        newSocialLabel.font = [UIFont boldSystemFontOfSize:10];
        newSocialLabel.tag = 901;
        [new addSubview:newSocialLabel];
        newSocialLabel.text = @"NEW";
        newSocialLabel.hidden = YES;
    }
    
    
    
    
    if(indexPath.row < [myList count]){
    
        NSDictionary *dic = myList[indexPath.row];
        name.textColor = [UIColor blackColor];
        name.frame = CGRectMake(10, 5, 124-20, 45);
        name.textAlignment = NSTextAlignmentCenter;
        explain.textAlignment = NSTextAlignmentCenter;
        infoView.backgroundColor = [UIColor clearColor];
        borderImage.hidden = YES;
        name.font = [UIFont systemFontOfSize:15];
        
        name.font = [UIFont systemFontOfSize:14];
        infoView.backgroundColor = [UIColor whiteColor];

        name.frame = CGRectMake(12, 5, infoView.frame.size.width - 24, infoView.frame.size.height-10);

        name.textColor = RGB(32, 32, 32);
        
        
        //        coverOverImage.hidden = NO;
        NSLog(@"dic %@",dic);
        
        NSString *attribute2 = dic[@"groupattribute2"];
        if([attribute2 length]<1)
            attribute2 = @"00";
        
        NSMutableArray *array2 = [NSMutableArray array];
        
        NSLog(@"attribute2 %@",attribute2);
        for (int i = 0; i < [attribute2 length]; i++) {
            
            [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
            
        }
        
        
        
        NSLog(@"array2 %@",array2);
        
        
        
        bg.image = nil;
        
        
        //        infoView.hidden = NO;
        name.text = dic[@"groupname"];
        
        
        
        
        
        explain.text = dic[@"groupexplain"];
        
        NSURL *imgURL;
        imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BearTalkBaseUrl,dic[@"groupimage"]]];

        //				NSLog(@"== desc %@",[imgURL description]);
        NSLog(@"imgURL %@",imgURL);
        [coverImage sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger a, NSInteger b) {
            
        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
            NSLog(@"fail %@",[error localizedDescription]);
            [HTTPExceptionHandler handlingByError:error];
            
        }];
        
        
        NSString *groupNumber = [SharedAppDelegate readPlist:dic[@"groupnumber"]];
        
        
        
        if([dic[@"INVITE_YN"]isEqualToString:@"Y"] && [dic[@"MEMBER_YN"]isEqualToString:@"N"]){

            
            coverOverImage.hidden = YES;
            invitationImage.hidden = NO;
            accept.hidden = NO;
            deny.hidden = NO;
            acceptLabel.hidden = NO;
            denyLabel.hidden = NO;
            accept.titleLabel.text = dic[@"groupnumber"];
            deny.titleLabel.text = dic[@"groupnumber"];
            
            
        } else {
            coverOverImage.hidden = NO;
            invitationImage.hidden = YES;
            accept.hidden = YES;
            deny.hidden = YES;
            acceptLabel.hidden = YES;
            denyLabel.hidden = YES;
            
#ifdef BearTalk
            if([dic[@"NEW_YN"]isEqualToString:@"Y"]){
#else
            if([groupNumber length] < 1 || [groupNumber intValue] < [dic[@"lastcontentindex"] intValue]) {
#endif
                new.hidden = NO;
                newSocialLabel.hidden = NO;
            }
            else {
                
                new.hidden = YES;
                newSocialLabel.hidden = YES;
            }
        }
        
        
        
        coverOverImage.hidden = NO;
        
        
    }

    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake([SharedFunctions scaleFromWidth:165],[SharedFunctions scaleFromHeight:215]);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 12, 10, 12);// t l b r
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


#else

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForItemAtIndexPath");
    
    //    NSLog(@"mainCellForRow");
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.contentView.userInteractionEnabled = YES;
    UIImageView *bg, *coverImage, *new, *invitationImage, *borderImage;
    UIView *infoView;
    UILabel *name, *explain;//, *supporterGroup;
    //    UILabel *invitationMemberLabel;
    UIButton *accept, *deny;
    UILabel *acceptLabel, *denyLabel;
    //
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        cell.backgroundColor = [UIColor redColor];
    //    if(cell == nil){
    
    bg = (UIImageView*)[cell.contentView viewWithTag:100];
    coverImage = (UIImageView*)[cell.contentView viewWithTag:200];
    //    coverOverImage = (UIImageView*)[cell.contentView viewWithTag:1000];
    infoView = (UIView*)[cell.contentView viewWithTag:600];
    name = (UILabel*)[cell.contentView viewWithTag:700];
    explain = (UILabel*)[cell.contentView viewWithTag:800];
    
    invitationImage = (UIImageView*)[cell.contentView viewWithTag:300];
    deny = (UIButton *)[cell.contentView viewWithTag:400];
    accept = (UIButton *)[cell.contentView viewWithTag:500];
    
    denyLabel = (UILabel*)[cell.contentView viewWithTag:40];
    acceptLabel = (UILabel*)[cell.contentView viewWithTag:50];
    
    new = (UIImageView*)[cell.contentView viewWithTag:900];
    
    borderImage = (UIImageView *)[cell.contentView viewWithTag:2000];
    
    if(bg == nil){
        bg = [[UIImageView alloc]init];
        bg.userInteractionEnabled = YES;
        bg.frame = CGRectMake(0,0,140,165);
        
        //		bg.image = [UIImage imageNamed:@"group_whlinebg.png"];
        bg.tag = 100;
        [cell.contentView addSubview:bg];
        //        [bg release];
        
    }
    
    if(coverImage == nil){
        coverImage = [[UIImageView alloc]init];
        coverImage.frame = CGRectMake(0,0,140,90);
        
        [coverImage setContentMode:UIViewContentModeScaleAspectFill];
        [coverImage setClipsToBounds:YES];
        coverImage.tag = 200;
        
        [bg addSubview:coverImage];
        //        [coverImage release];
    }
    
    
    
    if(infoView == nil){
        infoView = [[UIView alloc]init];
        infoView.backgroundColor = [UIColor clearColor];
        
        
        infoView.frame = CGRectMake(coverImage.frame.origin.x, coverImage.frame.size.height, coverImage.frame.size.width, 24);
        
        //    whiteCoverImage.image = [UIImage imageNamed:@"scg_photo_cover.png"];//AspectFill];//AspectFit];//ToFill];
        infoView.tag = 600;
        [bg addSubview:infoView];
        //        [infoView release];
    }
    if(name == nil){
        name = [CustomUIKit labelWithText:nil fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(10, 15, 124-20, 45) numberOfLines:2 alignText:NSTextAlignmentCenter];
        name.tag = 700;
        
        name.frame = CGRectMake(5,0,infoView.frame.size.width-10,infoView.frame.size.height);
        name.textColor = [UIColor whiteColor];
        
        
        [infoView addSubview:name];
    }
    if(explain == nil){
        explain = [CustomUIKit labelWithText:nil fontSize:11 fontColor:RGB(168,167,167) frame:CGRectMake(name.frame.origin.x, CGRectGetMaxY(infoView.frame), name.frame.size.width, bg.frame.size.height-(CGRectGetMaxY(infoView.frame))) numberOfLines:3 alignText:NSTextAlignmentLeft];
        explain.tag = 800;
        [bg addSubview:explain];
        explain.frame = CGRectMake(name.frame.origin.x,CGRectGetMaxY(infoView.frame), name.frame.size.width, bg.frame.size.height - CGRectGetMaxY(infoView.frame));
        
        
    }
    
    if(invitationImage == nil){
        invitationImage = [[UIImageView alloc]init];
        invitationImage.userInteractionEnabled = YES;
        
        invitationImage.frame = CGRectMake(0,0,140,165);
        invitationImage.image = [UIImage imageNamed:@"n00_globe_black_hide.png"];
        
        invitationImage.tag = 300;
        [bg addSubview:invitationImage];
        //        [invitationImage release];
    }
    if(deny == nil){
        deny = [[UIButton alloc]init];
        deny.frame = CGRectMake(10, 70, 53, 30);
        [deny setBackgroundImage:[UIImage imageNamed:@"button_main_invite_deny.png"] forState:UIControlStateNormal];
        [deny addTarget:self action:@selector(denyInvite:) forControlEvents:UIControlEventTouchUpInside];
        deny.tag = 400;
        [invitationImage addSubview:deny];
        //        [deny release];
    }
    if(accept == nil){
        accept = [[UIButton alloc]init];
        accept.frame = CGRectMake(CGRectGetMaxX(deny.frame)+10, deny.frame.origin.y, deny.frame.size.width, deny.frame.size.height);
        [accept setBackgroundImage:[UIImage imageNamed:@"button_main_invite_accept.png"] forState:UIControlStateNormal];
        [accept addTarget:self action:@selector(acceptInvite:) forControlEvents:UIControlEventTouchUpInside];
        accept.tag = 500;
        [invitationImage addSubview:accept];
        //        [accept release];
    }
    if(denyLabel == nil){
        denyLabel = [CustomUIKit labelWithText:nil fontSize:16 fontColor:[UIColor grayColor] frame:CGRectMake(0, 0, deny.frame.size.width, deny.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
        denyLabel.font = [UIFont boldSystemFontOfSize:16];
        denyLabel.tag = 40;
        [deny addSubview:denyLabel];
        denyLabel.text = @"거절";
    }
    if(acceptLabel == nil){
        acceptLabel = [CustomUIKit labelWithText:nil fontSize:16 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, accept.frame.size.width, accept.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
        acceptLabel.font = [UIFont boldSystemFontOfSize:16];
        acceptLabel.tag = 50;
        [accept addSubview:acceptLabel];
        acceptLabel.text = @"수락";
    }
    
    
    if(borderImage == nil){
        borderImage = [[UIImageView alloc]init];
        borderImage.frame = CGRectMake(0, 0, 140, 165);
        
        borderImage.image = [UIImage imageNamed:@"imageview_main_all_rounding.png"];
        borderImage.tag = 2000;
        [bg addSubview:borderImage];
        //        [borderImage release];
        
    }
    
    
    if(new == nil){
        new = [[UIImageView alloc]init];
        
        new.frame = CGRectMake(140-37,0,37,37);
        
        new.image = [UIImage imageNamed:@"imageview_main_border_new.png"];
        new.tag = 900;
        
        [bg addSubview:new];
        //        [new release];
        
    }
    
    
    
    
    
    if([myList count]<1){
        
        
        borderImage.hidden = YES;
        infoView.backgroundColor = [UIColor clearColor];
        //            coverOverImage.hidden = YES;
        acceptLabel.hidden = YES;
        denyLabel.hidden = YES;
        bg.image = [UIImage imageNamed:@"imageview_empty_social.png"];
        //        infoView.hidden = YES;
        name.text = @"";
        name.frame = CGRectMake(0, 30, 140, 20);
        name.textColor = RGB(120, 120, 120);
        name.font = [UIFont systemFontOfSize:15];
        name.textAlignment = NSTextAlignmentCenter;
        explain.textAlignment = NSTextAlignmentCenter;
        explain.text = @"";
        coverImage.image = nil;
        invitationImage.hidden = YES;
        accept.hidden = YES;
        deny.hidden = YES;
        new.hidden = YES;
        
    }
    else if(indexPath.row < [myList count]+1){//< [myList count]) {
        
        
        NSDictionary *dic = nil;
        
        
        dic = myList[indexPath.row];
        
        
        
        NSLog(@"realnumber %@ groupnumber %@",dic[@"groupnumber"],[SharedAppDelegate readPlist:dic[@"groupnumber"]]);
        NSLog(@"lastcontentindex %@",dic[@"lastcontentindex"]);
        
        borderImage.hidden = NO;
        
        NSArray *colorArray =[dic[@"color"] componentsSeparatedByString:@","];
        infoView.backgroundColor = RGB([colorArray[0]intValue], [colorArray[1]intValue], [colorArray[2]intValue]);
        //        infoView.backgroundColor = RGB(149, 55, 53);
        explain.textAlignment = NSTextAlignmentLeft;
        name.frame = CGRectMake(5,0,infoView.frame.size.width-10,infoView.frame.size.height);
        name.textColor = [UIColor whiteColor];
        name.textAlignment = NSTextAlignmentLeft;
        
        
        
        name.font = [UIFont systemFontOfSize:15];
        //        coverOverImage.hidden = NO;
        NSLog(@"dic %@",dic);
        
        NSString *attribute2 = dic[@"groupattribute2"];
        if([attribute2 length]<1)
            attribute2 = @"00";
        
        NSMutableArray *array2 = [NSMutableArray array];
        
        NSLog(@"attribute2 %@",attribute2);
        for (int i = 0; i < [attribute2 length]; i++) {
            
            [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
            
        }
        
        
        
        NSLog(@"array2 %@",array2);
        
        
        bg.image = [UIImage imageNamed:@"imageview_main_border.png"];
        
        
        
        
        //        infoView.hidden = NO;
        name.text = dic[@"groupname"];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:name.font, NSParagraphStyleAttributeName:paragraphStyle};
        CGSize nameSize = [name.text boundingRectWithSize:CGSizeMake(124-20, 45) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
//        CGSize nameSize = [name.text sizeWithFont:name.font constrainedToSize:CGSizeMake(124-20, 45) lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"nameSize %@",NSStringFromCGSize(nameSize));
        float nameHeight = nameSize.height;
        if(nameHeight>30)
            nameHeight = 30;
        
        
        explain.text = dic[@"groupexplain"];
        
        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:dic[@"groupimage"] num:0 thumbnail:YES];
        //				NSLog(@"== desc %@",[imgURL description]);
        NSLog(@"imgURL %@",imgURL);
        [coverImage sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger a, NSInteger b) {
            
        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
            NSLog(@"fail %@",[error localizedDescription]);
            [HTTPExceptionHandler handlingByError:error];
            
        }];
        
        
        NSString *groupNumber = [SharedAppDelegate readPlist:dic[@"groupnumber"]];
        
        
        if([dic[@"accept"]isEqualToString:@"N"] && [dic[@"grouptype"]isEqualToString:@"1"]){
            //            coverOverImage.hidden = YES;
            invitationImage.hidden = NO;
            accept.hidden = NO;
            deny.hidden = NO;
            acceptLabel.hidden = NO;
            denyLabel.hidden = NO;
            accept.titleLabel.text = dic[@"groupnumber"];
            deny.titleLabel.text = dic[@"groupnumber"];
            
            
        } else {
            //            coverOverImage.hidden = NO;
            invitationImage.hidden = YES;
            accept.hidden = YES;
            deny.hidden = YES;
            acceptLabel.hidden = YES;
            denyLabel.hidden = YES;
            
            if([groupNumber length] < 1 || [groupNumber intValue] < [dic[@"lastcontentindex"] intValue]) {
                
                new.hidden = NO;
            }
            else {
                
                new.hidden = YES;
            }
        }
        
        
    }
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(140, 165);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 12, 10, 12);// t l b r
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


#endif

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return [myList count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)acceptInvite:(id)sender{
    
    
    [self regiGroup:[[sender titleLabel]text] answer:@"Y"];
}





- (void)refreshSetupButton
{
    
    NSLog(@"refresh!");
    BOOL currentStatus = [SharedAppDelegate checkRemoteNotificationActivate];
    
    NSLog(@"currentStatus %@",currentStatus?@"YES":@"NO");
 
    NSString *imageName;
    if (currentStatus == YES) {
  
        imageName = @"actionbar_btn_ect.png";

    } else {
        //        alertImage.hidden = NO;
        imageName = @"actionbar_btn_ect2.png";
        //        		[setupButton setBackgroundImage:[UIImage imageNamed:@"barbutton_main_setup_alert.png"] forState:UIControlStateNormal];
        
    }
 //   [setupButton setBackgroundImage:[UIImage imageNamed:@"barbutton_main_setup_alert.png"] forState:UIControlStateNormal];
    [self performSelectorOnMainThread:@selector(changeSetup:) withObject:imageName waitUntilDone:NO];
//    [gsetup refreshSetupButton];
    
}


- (void)changeSetup:(NSString *)imagename{
    [setupButton setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    NSLog(@"setupButton %@",setupButton);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = nil;
    dic = myList[indexPath.row];
#ifdef BearTalk
    NSLog(@"dic %@",dic);
    [SharedAppDelegate.root.home.timeLineCells removeAllObjects];
    SharedAppDelegate.root.home.timeLineCells = nil;
    [SharedAppDelegate.root.home.myTable reloadData];
    SharedAppDelegate.root.home.title = dic[@"groupname"];
    SharedAppDelegate.root.home.titleString = dic[@"groupname"];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [dic[@"groupattribute"] length]; i++) {
        [array addObject:[NSString stringWithFormat:@"%C", [dic[@"groupattribute"] characterAtIndex:i]]];
    }
    NSLog(@"array %@",array);
    
    NSString *attribute2 = dic[@"groupattribute2"];
    if([attribute2 length]<1)
        attribute2 = @"00";
    
    NSMutableArray *array2 = [NSMutableArray array];
    for (int i = 0; i < [attribute2 length]; i++) {
        
        [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
        
    }
    NSLog(@"array2 %@",array2);
            [SharedAppDelegate.root.home setGroup:dic regi:dic[@"accept"]];
    
//    NSString *lastcontentindex = [NSString stringWithFormat:@"%@",dic[@"lastcontentindex"]];
//    if(IS_NULL(lastcontentindex) || [lastcontentindex length] == 0)
//        [SharedAppDelegate writeToPlist:dic[@"groupnumber"] value:@"0"];
//    else
//    {
//        [SharedAppDelegate writeToPlist:dic[@"groupnumber"] value:dic[@"lastcontentindex"]];
//    }
    

    SharedAppDelegate.root.home.targetuid = @"";
    SharedAppDelegate.root.home.category = dic[@"category"];
    SharedAppDelegate.root.home.groupnum = dic[@"groupnumber"];
    SharedAppDelegate.root.needsRefresh = YES;
    
    UIBarButtonItem *btnNaviSetup = nil;
    UIBarButtonItem *btnNaviSearch = nil;
    
    
    if([dic[@"category"]isEqualToString:@"1"]){
        
        
        UIButton *searchButton = [CustomUIKit buttonWithTitle:SharedAppDelegate.root.home.titleString fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(loadSocialSearch) frame:CGRectMake(0, 0, 25, 25) imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_search.png" imageNamedPressed:nil];
        btnNaviSearch = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
        
        
        
        SharedAppDelegate.root.home.navigationItem.rightBarButtonItems = nil;
        SharedAppDelegate.root.home.navigationItem.rightBarButtonItem = btnNaviSearch;
    }
    else if([dic[@"category"]isEqualToString:@"3"] || [dic[@"category"]isEqualToString:@"10"]){
        
        SharedAppDelegate.root.home.navigationItem.rightBarButtonItem = nil;
        SharedAppDelegate.root.home.navigationItem.rightBarButtonItems = nil;
    }
    else{
        
        UIButton *button = [CustomUIKit buttonWithTitle:SharedAppDelegate.root.home.titleString fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(loadSocialSetup) frame:CGRectMake(0, 0, 25, 25) imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_setting.png" imageNamedPressed:nil];
        btnNaviSetup  = [[UIBarButtonItem alloc]initWithCustomView:button];
        
        
        UIButton *searchButton = [CustomUIKit buttonWithTitle:SharedAppDelegate.root.home.titleString fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(loadSocialSearch) frame:CGRectMake(0, 0, 25, 25) imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_search.png" imageNamedPressed:nil];
        btnNaviSearch = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
        
        
        NSLog(@"navi setup %@ search %@",btnNaviSetup,btnNaviSearch);
        NSArray *arrBtns;
        arrBtns = [[NSArray alloc]initWithObjects:btnNaviSetup, btnNaviSearch, nil]; // 순서는 거꾸로
        
        
        SharedAppDelegate.root.home.navigationItem.rightBarButtonItem = nil;
        SharedAppDelegate.root.home.navigationItem.rightBarButtonItems = arrBtns;
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![self.navigationController.topViewController isKindOfClass:[SharedAppDelegate.root.home class]])
        [self.navigationController pushViewController:SharedAppDelegate.root.home animated:YES];
    });
    

#else
    if(indexPath.row < [myList count]){
        
        //        else if(indexPath.row != 1)
        //            dic = myList[indexPath.row-1];
        
        //        if(indexPath.row != 1)
        [self enterContentsGroup:dic con:self];
        
    }
#endif
    
}

#define kCS119 14
- (void)enterContentsGroup:(NSDictionary *)dic con:(UIViewController *)con{
    
    NSLog(@"dic %@",dic);
    
    if(cs119Dic){
        cs119Dic = nil;
    }
    cs119Dic = [[NSDictionary alloc]initWithDictionary:dic];
    
    NSString *attribute2 = dic[@"groupattribute2"];
    if([attribute2 length]<1)
        attribute2 = @"00";
    
    NSMutableArray *array2 = [NSMutableArray array];
    for (int i = 0; i < [attribute2 length]; i++) {
        
        [array2 addObject:[NSString stringWithFormat:@"%C", [attribute2 characterAtIndex:i]]];
        
    }
    NSLog(@"array2 %@",array2);
    
    if([array2[0]isEqualToString:@"3"]){
        // cs119
        [self getCS119List:dic time:@"0" table:nil];
        
        return;
    }
    
    [SharedAppDelegate.root.home.timeLineCells removeAllObjects];
    SharedAppDelegate.root.home.timeLineCells = nil;
    [SharedAppDelegate.root.home.myTable reloadData];
    
    SharedAppDelegate.root.home.title = dic[@"groupname"];
    SharedAppDelegate.root.home.titleString = dic[@"groupname"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < [dic[@"groupattribute"] length]; i++) {
        [array addObject:[NSString stringWithFormat:@"%C", [dic[@"groupattribute"] characterAtIndex:i]]];
    }
    
    
    
    if(![array2[0]isEqualToString:@"3"]) {
        
        
        SharedAppDelegate.root.home.navigationItem.rightBarButtonItems = nil;
        
        
        UIButton *searchButton = [CustomUIKit buttonWithTitle:SharedAppDelegate.root.home.titleString fontSize:0 fontColor:nil target:SharedAppDelegate.root selector:@selector(loadSocialSearch) frame:CGRectMake(0, 0, 26, 26) imageNamedBullet:nil imageNamedNormal:@"barbutton_search.png" imageNamedPressed:nil];
        UIBarButtonItem *btnNaviSearch = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
        
        
        NSLog(@"search %@",array2[0]);
        SharedAppDelegate.root.home.navigationItem.rightBarButtonItem = btnNaviSearch;
        
        //        [btnNaviSearch release];
        
        
        
    } else {
        
        SharedAppDelegate.root.home.navigationItem.rightBarButtonItems = nil;
        SharedAppDelegate.root.home.navigationItem.rightBarButtonItem = nil;
    }
    
    
    
    
    
    if([dic[@"category"]isEqualToString:@"1"]){
        
        [SharedAppDelegate.root.home setGroup:dic regi:dic[@"accept"]];
    }
    else if([dic[@"category"]isEqualToString:@"2"]){ // 1이 아닐 때
        if([dic[@"grouptype"]isEqualToString:@"1"])
            [SharedAppDelegate.root getGroupInfo:dic[@"groupnumber"] regi:dic[@"accept"] add:NO];
        else
            [SharedAppDelegate.root.home setGroup:dic regi:dic[@"accept"]];
    }
    
    
    
    
    
    
    
    if([dic[@"lastcontentindex"]length]<1 || dic[@"lastcontentindex"]==nil)
        [SharedAppDelegate writeToPlist:dic[@"groupnumber"] value:@"0"];
    else
    {
        [SharedAppDelegate writeToPlist:dic[@"groupnumber"] value:dic[@"lastcontentindex"]];
    }
    
    
    
    SharedAppDelegate.root.home.targetuid = @"";
    SharedAppDelegate.root.home.category = dic[@"category"];
    SharedAppDelegate.root.home.groupnum = dic[@"groupnumber"];
    //		home.reloadView = YES;
    SharedAppDelegate.root.needsRefresh = YES;
    
    
    SharedAppDelegate.root.home.category = @"2";
    
    
    
    
    
    
    
    
    [SharedAppDelegate.root.home setGroup:dic regi:dic[@"accept"]];
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![con.navigationController.topViewController isKindOfClass:[SharedAppDelegate.root.home class]])
        [con.navigationController pushViewController:SharedAppDelegate.root.home animated:YES];
    });
    [SharedAppDelegate.root.home settingGroupDic:dic];
    
    
    
    
    
}

- (void)loadMoreTimeline:(UITableView *)table
{
    NSLog(@"cs119Dic %@",cs119Dic);
    NSLog(@"lastInteger %d",(int)lastInteger);
    if(cs119Dic != nil)
        [self getCS119List:cs119Dic time:[NSString stringWithFormat:@"-%d",(int)lastInteger] table:table];
    
}

- (void)getCS119List:(NSDictionary *)dic time:(NSString *)time table:(UITableView *)table{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/categorymsg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters;
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                  [ResourceLoader sharedInstance].myUID,@"uid",
                  time,@"time",
                  dic[@"category"],@"category",
                  @"",@"targetuid",
                  dic[@"groupnumber"],@"groupnumber",
                  nil];//@{ @"uniqueid" : @"c110256" };
    
    NSLog(@"parameters %@",parameters);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    NSLog(@"timeout: %f", request.timeoutInterval);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [table.infiniteScrollingView stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            lastInteger = [resultDic[@"time"] intValue];
            
            if([dic[@"lastcontentindex"]length]<1 || dic[@"lastcontentindex"]==nil)
                [SharedAppDelegate writeToPlist:dic[@"groupnumber"] value:@"0"];
            else
            {
                [SharedAppDelegate writeToPlist:dic[@"groupnumber"] value:dic[@"lastcontentindex"]];
            }
            
            
            
            EmptyListViewController *controller = [[EmptyListViewController alloc]initWithList:resultDic[@"past"] from:kCS119];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(![self.navigationController.topViewController isKindOfClass:[controller class]]){
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
            });
            //            [controller release];
            
            
            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [table.infiniteScrollingView stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
}


#define kMakeSocical 200
#define kDenySocial 300

- (void)confirmDeny:(NSString *)number{
    [self regiGroup:number answer:@"N"];
}
//#define kNormal 0
//#define kControl 1
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == kMakeSocical){
        if(buttonIndex == 0){
            // cancel
            
        }
        else if(buttonIndex == 1){
            
            //            [self loadNew:@"11"];
        }
        else{
            //            [self loadNew:@"00"];
            
            
        }
    }
    else if(alertView.tag == kDenySocial){
        
    }
    
}



- (void)loadNote{
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.note];
    [self presentViewController:nc animated:YES completion:nil];
    //    [nc release];
    
}
#define kNewGroup 3

- (void)loadNewConfirm
{
    //    if([[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]isEqualToString:@"50"]){
    //
    //        NSString *msg = [NSString stringWithFormat:@"고객 관리형 소셜은 추가적으로 고객과 함께 소통할 소셜로 공지, 배송요청, Q&A, 채팅, 일정 메뉴로 고객 관리에 최적화된 소셜입니다.\n\nHA용 소셜은 고객은 초대할 수 없는 내부 직원용 추가 소셜로 게시판, Q&A, 채팅, 일정 메뉴로 자유로운 소통에 최적화된 소셜입니다."];
    //        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
    //
    //            UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"새소셜 만들기"
    //                                                                                     message:msg
    //                                                                              preferredStyle:UIAlertControllerStyleAlert];
    //
    //            UIAlertAction *okb = [UIAlertAction actionWithTitle:@"고객 관리형 소셜 만들기"
    //                                                          style:UIAlertActionStyleDefault
    //                                                        handler:^(UIAlertAction * action){
    //
    //                                                            [self loadNew:@"11"];
    //
    //
    //                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
    //                                                        }];
    //            [alertcontroller addAction:okb];
    //
    //            okb = [UIAlertAction actionWithTitle:@"HA용 소셜 만들기"
    //                                           style:UIAlertActionStyleDefault
    //                                         handler:^(UIAlertAction * action){
    //
    //                                             [self loadNew:@"00"];
    //
    //
    //                                             [alertcontroller dismissViewControllerAnimated:YES completion:nil];
    //                                         }];
    //            [alertcontroller addAction:okb];
    //
    //            UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"취소"
    //                                                              style:UIAlertActionStyleDefault
    //                                                            handler:^(UIAlertAction * action){
    //                                                                [alertcontroller dismissViewControllerAnimated:YES completion:nil];
    //                                                            }];
    //
    //            [alertcontroller addAction:cancelb];
    //            [self presentViewController:alertcontroller animated:YES completion:nil];
    //
    //        }
    //        else{
    //            UIAlertView *alert;
    //            alert = [[UIAlertView alloc] initWithTitle:@"새소셜 만들기" message:msg delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"고객 관리형 소셜 만들기",@"HA용 소셜 만들기", nil];
    //            alert.tag = kMakeSocical;
    //            [alert show];
    //            [alert release];
    //        }
    //
    //    }
    //    else{
    //        [self loadNew:@"00"];
    //    }
    
    
}


- (void)cancel//:(id)sender
{
    NSLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)regiGroupWithBearTalk:(NSString *)groupnum answer:(NSString *)yn{
    
    
    NSLog(@"regiGroup");
    
    if([ResourceLoader sharedInstance].myUID == nil || [[ResourceLoader sharedInstance].myUID length]<1){
        NSLog(@"userindex null");
        return;
    }
    
    
    NSString *urlString;
    if([yn isEqualToString:@"Y"]){
    urlString = [NSString stringWithFormat:@"%@/api/sns/accept",BearTalkBaseUrl];
    }
    else{
        urlString = [NSString stringWithFormat:@"%@/api/sns/reject",BearTalkBaseUrl];
        
    }
        NSURL *baseUrl = [NSURL URLWithString:urlString];
        
        
        
        
        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [ResourceLoader sharedInstance].myUID,@"uid",
                                    groupnum,@"snskey",nil];
        NSLog(@"parameters %@",parameters);
        
        //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/group/join.lemp" parameters:parameters];
        
        
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"PUT" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"resultDic %@",[operation.responseString objectFromJSONString]);
     
            
            if([yn isEqualToString:@"Y"]){
                [CustomUIKit popupSimpleAlertViewOK:@"소셜 가입" msg:@"가입 완료!" con:self];
                
                
                for(int i = 0; i < [myList count]; i++){
                    if([myList[i][@"groupnumber"]isEqualToString:groupnum])
                    {
                        [SharedAppDelegate.root fromUnjoinToJoin:myList[i]];
                        
                        [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:myList[i] object:@"N" key:@"INVITE_YN"]];
                        [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:myList[i] object:@"Y" key:@"MEMBER_YN"]];
                    }
                }
            }
            else{
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"거절 완료!" con:self];
                
                
                
                for(int i = 0; i < [myList count]; i++){
                    if([myList[i][@"groupnumber"]isEqualToString:groupnum])
                        [myList removeObjectAtIndex:i];
                    
                }
                
                
            }
            
            [myTable reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"FAIL : %@",operation.error);
            [HTTPExceptionHandler handlingByError:error];
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹을 가입하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            //        [alert show];
            
        }];
        
        [operation start];

}
    

- (void)regiGroup:(NSString *)groupnum answer:(NSString *)yn{
    
    
#ifdef BearTalk
    [self regiGroupWithBearTalk:groupnum answer:yn];
    return;
    
#endif
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    
    
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/join.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                groupnum,@"groupnumber",
                                yn,@"answer",nil];
    NSLog(@"parameters %@",parameters);
    
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/group/join.lemp" parameters:parameters];
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if([yn isEqualToString:@"Y"]){
                [CustomUIKit popupSimpleAlertViewOK:@"소셜 가입" msg:@"가입 완료!" con:self];
                
                
                for(int i = 0; i < [myList count]; i++){
                    if([myList[i][@"groupnumber"]isEqualToString:groupnum])
                    {
                        [SharedAppDelegate.root fromUnjoinToJoin:myList[i]];
                        
                        [myList replaceObjectAtIndex:i withObject:[SharedFunctions fromOldToNew:myList[i] object:@"Y" key:@"accept"]];
                    }
                }
            }
            else{
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"거절 완료!" con:self];
                
                
                
                for(int i = 0; i < [myList count]; i++){
                    if([myList[i][@"groupnumber"]isEqualToString:groupnum])
                        [myList removeObjectAtIndex:i];
                    
                }
                
                
            }
            
            [myTable reloadData];
            //            [SharedAppDelegate.root setGroupTimeline:myList];
            //            [SharedAppDelegate.root.home getTimeline:@"" target:@"" type:@"2" groupnum:groupnum];
            
            
        }
        else {
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹을 가입하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear %@",NSStringFromCGRect(self.view.frame));
    //    self.navigationController.navigationBar.hidden = NO;
    //    myTable.frame = CGRectMake(0,44,320,self.view.frame.size.height-44);
    //    [myTable reloadData];
    //    [self refreshTimeline];

    
}
- (void)setChatBadge:(int)num{
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear %@",NSStringFromCGRect(self.view.frame));
    //    self.navigationController.navigationBar.hidden = YES;
    
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear %@",NSStringFromCGRect(self.view.frame));
    //     self.navigationController.navigationBar.hidden = YES;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewwillappear");
    self.navigationController.navigationBar.translucent = NO;
    
    [self refreshSetupButton];
    [SharedAppDelegate.root.main refreshTimeline];
//#ifdef BearTalk
//    [self refreshSetupButton];
//#endif
}

//- (void)dealloc{
//
//    [myList release];
//
//    [super dealloc];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    //    [lastcom release];
    //    [lastnote release];
    //    [lastschedule release];
}



#pragma mark - beartalk

- (void)setNewNoticeBadge:(int)count{
    NSLog(@"setNewBadge");
    noticeBadgeCount = count;
    
    if(count>0){
        NSLog(@"count>0");
        
        NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
        if([colorNumber isEqualToString:@"2"]){
        [noticebutton setBackgroundImage:[UIImage imageNamed:@"actionbar_btn_alarm_urusa.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        }
        else if([colorNumber isEqualToString:@"3"]){
            
            [noticebutton setBackgroundImage:[UIImage imageNamed:@"actionbar_btn_alarm_urusa.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        }
        else if([colorNumber isEqualToString:@"4"]){
            
            [noticebutton setBackgroundImage:[UIImage imageNamed:@"actionbar_btn_alarm_urusa.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        }
        else{
            [noticebutton setBackgroundImage:[UIImage imageNamed:@"actionbar_btn_alarm2.png"] forState:UIControlStateNormal];//setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
            
        }
    }
    else{
        NSLog(@"count=0");
        [noticebutton setBackgroundImage:[UIImage imageNamed:@"actionbar_btn_alarm.png"] forState:UIControlStateNormal];
        //        [btnNaviNotice setBackgroundImage:[UIImage imageNamed:@"barbutton_main_notice_new.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    
}

@end
