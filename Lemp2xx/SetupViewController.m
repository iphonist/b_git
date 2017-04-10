//
//  SetupViewController.m
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "SetupViewController.h"
//#import "WebViewController.h"
//#import "OptionViewController.h"
#import "HistoryViewController.h"
//#import "InfoViewController.h"
//#import "LEMPMobileAppDelegate.h"
//#import "IIViewDeckController.h"
#import "WebViewController.h"
//#import "PasswordViewController.h"
#import "SubSetupViewController.h"
#import "GreenPushConfigViewController.h"


@implementation SetupViewController


#ifdef BearTalk
#define kGlobalFontSizeNormal	14
#define kGlobalrFontSizeNormal	12
#else
#define kGlobalFontSizeNormal	15
#define kGlobalrFontSizeNormal	15
#endif

#define kGlobalFontSizeLarge	kGlobalFontSizeNormal+3
#define kGlobalFontSizeLargest	kGlobalFontSizeLarge+3
#define kGlobalrFontSizeLarge	kGlobalrFontSizeNormal+3
#define kGlobalrFontSizeLargest	kGlobalrFontSizeLarge+3



#define kSubStatusWithBack 1000

#define kSubPassword 200
#define kSubBell 300
#define kSubProgram 400
#define kSubAlarm 500
#define kSubReplySort 600
#define kSubGlobalFontSize 700
#define kSubShareAccount 800
#define kSubPush 900
#define kSubGuide 901
#define kSubLocation 201

//#define kMenu 1
//#define kSetup 2
//#define kAllSetup 3

- (id)init{
    self = [super init];
    if(self != nil)
    {
        NSLog(@"init");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSetupButton) name:@"refreshPushAlertStatus" object:nil];
        
        
        
        
        
        CGRect tableFrame;
        
        
        float viewY = 64;
        
        //        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        //            tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height-44-20);
        //        } else {
        tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height-viewY);
        //        }
        
        
        myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
//        myTable.frame = tableFrame;
        myTable.dataSource = self;
        myTable.delegate = self;
        myTable.rowHeight = 50;
        myTable.backgroundColor = [UIColor clearColor];
#ifdef BearTalk
        myTable.rowHeight = 53;
        
        // ########## temp
        if([SharedAppDelegate readPlist:@"kLocation"]== nil || [[SharedAppDelegate readPlist:@"kLocation"]length]<1)
            [SharedAppDelegate writeToPlist:@"kLocation" value:@"전체"];
        
#endif
        [self.view addSubview:myTable];
        //        myTable.tag = kAllSetup;
        
        if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [myTable setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [myTable setLayoutMargins:UIEdgeInsetsZero];
        }
        
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        myTable.separatorColor = GreenTalkColor;
#endif
    }
    return self;
}

//- (id)initForSetup{
//
//    self = [super init];
//    if(self != nil)
//    {
//        NSLog(@"init");
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"refreshPushAlertStatus" object:nil];
//
//
//
//        self.navigationController.navigationBar.translucent = NO;
//        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//            self.edgesForExtendedLayout = UIRectEdgeBottom;
//
//        float viewY = 0;
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//            viewY = 44 + 20;
//        } else {
//            viewY = 44;
//
//        }
////        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
////            myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
////        } else {
//            myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-viewY) style:UITableViewStyleGrouped];
////        }
//
//        myTable.dataSource = self;
//        myTable.delegate = self;
//        myTable.rowHeight = 50;
//        [self.view addSubview:myTable];
//        myTable.tag = kMenu;
//
//        if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
//            [myTable setSeparatorInset:UIEdgeInsetsZero];
//        }
//        if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
//            [myTable setLayoutMargins:UIEdgeInsetsZero];
//        }
//        [self settingSetup];
//
//
//    }
//    return self;
//}

- (void)refreshSetupButton
{
    NSLog(@"setup refresh");
    [myTable reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    return 4;
#elif BearTalk
    return 4;
#endif
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    switch (section) {
        case 0:
#ifdef Batong
            return 2;
#else
            return 1;
#endif
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 3;
            break;
        default:
            break;
    }
#elif BearTalk
    return [myList[section]count];
//    switch (section){
//        case 0:
//            return 1;
//            break;
//        case 1:
//            return 3;
//            break;
//        case 2:
//            return 4;
//            break;
//        case 3:
//            return 3;
//            break;
//        default:
//            break;
//    }
#else
    return [myList count];
#endif
    
    return 0;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *myTableIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myTableIdentifier];
    UIImageView *imageView;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        
#ifdef BearTalk
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = RGB(132,146,160);
        
#endif
        imageView = [[UIImageView alloc] init];//WithFrame:CGRectMake(84.0, 14.0, 20.0, 20.0)];
        imageView.tag = 20;
        [cell.contentView addSubview:imageView];
//        [imageView release];
    } else {
        imageView = (UIImageView*)[cell.contentView viewWithTag:20];
    }
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    cell.detailTextLabel.textColor = GreenTalkColor;
    if(indexPath.section == 0){
        switch (indexPath.row) {
#ifdef Batong
            case 0:
                cell.textLabel.text = NSLocalizedString(@"notice", @"notice");
                break;
            case 1:
                cell.textLabel.text = NSLocalizedString(@"my_info", @"my_info");
                break;
#else
            case 0:
                cell.textLabel.text = NSLocalizedString(@"my_info", @"my_info");
                break;
#endif
            default:
                break;
        }
    }
    else if(indexPath.section == 1){
        
        switch (indexPath.row){
            case 0:{
                cell.textLabel.text = @"알림음";
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *filePath = [paths[0] stringByAppendingPathComponent:@"SoundList.plist"];
                NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
                NSArray *alarmSounds = plistDict[@"AlarmSounds"];
                NSString *pushSound = [SharedAppDelegate readPlist:@"pushsound"];
                
                for (NSDictionary *dic in alarmSounds) {
                    if ([pushSound isEqualToString:dic[@"filename"]]) {
                        cell.detailTextLabel.text = dic[@"name"];
                        break;
                    }
                }
                if ([cell.detailTextLabel.text length] < 1) {
                    cell.detailTextLabel.text = @"기본알림음1";
                }
            }
                break;
            case 1:
                cell.textLabel.text = NSLocalizedString(@"setup_each_social_alert", @"setup_each_social_alert");
                break;
            default:
                break;
        }
        
    }
    else if(indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"글자 크기";
                NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
                NSString *fontName;
                switch (fontSize) {
                    case kGlobalFontSizeNormal:
                        fontName = @"보통";
                        break;
                    case kGlobalFontSizeLarge:
                        fontName = @"크게";
                        break;
                    case kGlobalFontSizeLargest:
                        fontName = @"아주크게";
                        break;
                    default:
                        fontName = @"보통";
                        break;
                }
                cell.detailTextLabel.text = fontName;
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"비밀번호 잠금";
                if([[SharedAppDelegate readPlist:@"pwsaved"]isEqualToString:@"1"])
                    cell.detailTextLabel.text = @"설정됨";
                else
                    cell.detailTextLabel.text = @"해제됨";
            }
                break;
                
            default:
                break;
        }
    }
    else {
        switch (indexPath.row) {
                
#ifdef GreenTalkCustomer
                
            case 0:
                cell.textLabel.text = @"이용약관 및 회사소개";
                
                break;
            case 1:
                cell.textLabel.text = @"프로그램 정보";
                cell.detailTextLabel.text = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                break;
            case 2:
                cell.textLabel.text = @"그린톡 탈퇴";
                break;
            default:
                break;
#else
            case 0:
                cell.textLabel.text = @"주소록 다시받기";
                
                break;
            case 1:
                cell.textLabel.text = @"프로그램 정보";
                cell.detailTextLabel.text = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
                break;
            case 2:
                cell.textLabel.text = NSLocalizedString(@"logout", @"logout");
                break;
            default:
                break;
#endif
        }
    }
#elif BearTalk
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = myList[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
    imageView.image = nil;
    
    if(indexPath.section == 3 && indexPath.row == theme){
        
        NSString *colorNumber = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColorNumber"];
        
        if([colorNumber isEqualToString:@"2"]){
            cell.detailTextLabel.text = @"우루사";
        
        }
        else  if([colorNumber isEqualToString:@"3"]){
            cell.detailTextLabel.text = @"이지엔6";
        }
        else  if([colorNumber isEqualToString:@"4"]){
            cell.detailTextLabel.text = @"임팩타민";
        }
        else{
            cell.detailTextLabel.text = @"대웅";
            
        }
        
    }
    else if(indexPath.section == 3 && indexPath.row == location){
        
        
                cell.detailTextLabel.text = [SharedAppDelegate readPlist:@"kLocation"];
          
        
        
    }
    else if(indexPath.section == 3 && indexPath.row == programInfo){
        cell.detailTextLabel.text = [[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    }
    else if (indexPath.section == 1 && indexPath.row == push) {
        
        BOOL currentStatus = [SharedAppDelegate checkRemoteNotificationActivate];
        
        
        if (currentStatus == NO) {
            imageView.frame = CGRectMake(80, 15, 20.0, 20.0);
            imageView.image = [UIImage imageNamed:@"listalert_ic.png"];
            cell.detailTextLabel.text = @"OFF";
        } else {
            cell.detailTextLabel.text = @"ON";
        }
        
//    } else if (indexPath.section == 1 && indexPath.row == bell) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *filePath = [paths[0] stringByAppendingPathComponent:@"SoundList.plist"];
//        NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
//        NSArray *ringtones = plistDict[@"Ringtones"];
//        NSString *bellName = [SharedAppDelegate readPlist:@"bell"];
//        
//        for (NSDictionary *dic in ringtones) {
//            if ([bellName isEqualToString:dic[@"filename"]]) {
//                cell.detailTextLabel.text = dic[@"name"];
//                break;
//            }
//        }
//        
//        if ([cell.detailTextLabel.text length] < 1) {
//            cell.detailTextLabel.text = @"기본벨소리3";
//        }
    } else if (indexPath.section == 1 && indexPath.row == bell){
    
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [paths[0] stringByAppendingPathComponent:@"SoundList.plist"];
        NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSArray *ringtones = plistDict[@"Ringtones"];
        NSString *bellName = [SharedAppDelegate readPlist:@"bell"];
        
        for (NSDictionary *dic in ringtones) {
            if ([bellName isEqualToString:dic[@"filename"]]) {
                cell.detailTextLabel.text = dic[@"name"];
                break;
            }
        }
        
        if ([cell.detailTextLabel.text length] < 1) {
            cell.detailTextLabel.text = @"기본벨소리3";
        }
    }  else if (indexPath.section == 1 && indexPath.row == alarm){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [paths[0] stringByAppendingPathComponent:@"SoundList.plist"];
        NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSArray *alarmSounds = plistDict[@"AlarmSounds"];
        NSString *pushSound = [SharedAppDelegate readPlist:@"pushsound"];
        
        for (NSDictionary *dic in alarmSounds) {
            if ([pushSound isEqualToString:dic[@"filename"]]) {
                cell.detailTextLabel.text = dic[@"name"];
                break;
            }
        }
        if ([cell.detailTextLabel.text length] < 1) {
            cell.detailTextLabel.text = @"기본알림음1";
        }
    } else if (indexPath.section == 2 && indexPath.row == globalFontSize) {
        NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
        NSString *fontName;
        switch (fontSize) {
            case kGlobalFontSizeNormal:
                fontName = @"보통";
                break;
            case kGlobalFontSizeLarge:
                fontName = @"크게";
                break;
            case kGlobalFontSizeLargest:
                fontName = @"아주크게";
                break;
            default:
                fontName = @"보통";
                break;
        }
        cell.detailTextLabel.text = fontName;
    }
    else if(indexPath.section == 2 && indexPath.row == password){
        if([[SharedAppDelegate readPlist:@"pwsaved"]isEqualToString:@"1"])
            cell.detailTextLabel.text = @"ON";
        else
            cell.detailTextLabel.text = @"OFF";
    }
    
    else if(indexPath.section == 2 && indexPath.row == viewDept){
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"kViewDept"] == YES)
            cell.detailTextLabel.text = @"ON";
        else
            cell.detailTextLabel.text = @"OFF";
    }

    
#else
    
    cell.textLabel.text = myList[indexPath.row];
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
    imageView.image = nil;
    
    if (indexPath.row == push) {
        //            UIRemoteNotificationType types;
        //            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        //                types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
        //            }else{
        //                types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        //            }
        //
        //            BOOL currentStatus = (types==UIRemoteNotificationTypeNone)?NO:YES;
        //            BOOL currentStatus = NO;
        //
        //            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        //
        //                currentStatus =  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
        //            }
        //            else{
        //                UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        //                if (types & UIRemoteNotificationTypeAlert)
        //                {
        //                    currentStatus = YES;
        //                }
        //            }
        
        BOOL currentStatus = [SharedAppDelegate checkRemoteNotificationActivate];
        
        
        if (currentStatus == NO) {
            imageView.frame = CGRectMake(84.0, 14.0, 20.0, 20.0);
            imageView.image = [UIImage imageNamed:@"listalert_ic.png"];
            cell.detailTextLabel.text = NSLocalizedString(@"alarm_off_status", @"alarm_off_status");
        } else {
            cell.detailTextLabel.text = NSLocalizedString(@"alarm_on_status", @"alarm_on_status");
        }
        
    }
    else if (indexPath.row == bell) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [paths[0] stringByAppendingPathComponent:@"SoundList.plist"];
        NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSArray *ringtones = plistDict[@"Ringtones"];
        NSString *bellName = [SharedAppDelegate readPlist:@"bell"];
        
        for (NSDictionary *dic in ringtones) {
            if ([bellName isEqualToString:dic[@"filename"]]) {
                cell.detailTextLabel.text = dic[@"name"];
                break;
            }
        }
        
        if ([cell.detailTextLabel.text length] < 1) {
            cell.detailTextLabel.text = @"기본벨소리3";
        }
    }
else if (indexPath.row == alarm){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [paths[0] stringByAppendingPathComponent:@"SoundList.plist"];
        NSDictionary *plistDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        NSArray *alarmSounds = plistDict[@"AlarmSounds"];
        NSString *pushSound = [SharedAppDelegate readPlist:@"pushsound"];
        
        for (NSDictionary *dic in alarmSounds) {
            if ([pushSound isEqualToString:dic[@"filename"]]) {
                cell.detailTextLabel.text = dic[@"name"];
                break;
            }
        }
        if ([cell.detailTextLabel.text length] < 1) {
            cell.detailTextLabel.text = @"기본알림음1";
        }
    }
else if (indexPath.row == replySort){

        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReplySort"] == 1) {
            cell.detailTextLabel.text = @"최신 댓글부터 표시";
        } else {
            cell.detailTextLabel.text = @"첫 댓글부터 표시";
        }
    }
else if (indexPath.row == globalFontSize) {
        NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
        NSString *fontName;
        switch (fontSize) {
            case kGlobalFontSizeNormal:
                fontName = @"보통";
                break;
            case kGlobalFontSizeLarge:
                fontName = @"크게";
                break;
            case kGlobalFontSizeLargest:
                fontName = @"아주크게";
                break;
            default:
                fontName = @"보통";
                break;
        }
        cell.detailTextLabel.text = fontName;
    }
    else if(indexPath.row == password){
        if([[SharedAppDelegate readPlist:@"pwsaved"]isEqualToString:@"1"])
            cell.detailTextLabel.text = @"설정됨";
        else
            cell.detailTextLabel.text = @"해제됨";
    }
    
    
    
    //    }
#endif
    return cell;
}


#define kConfirmLeave 111
#define kLeave 222
#define kCompanyInfo 300

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //    if(tableView.tag == kMenu){
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    if(indexPath.section == 0){
        switch (indexPath.row) {
#ifdef Batong
            case 0:
            {
                [SharedAppDelegate.root.main loadNoticeWebview];
            }
                break;
            case 1:
            {
                
                SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubStatusWithBack];
//                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
                //        [self presentViewController:nc animated:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
                    //                    sub.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:sub animated:YES];
                }
                });
//                [sub release];
//                [nc release];
                //        [sub release];
            }
                break;
#else
            case 0:
            {
                
                SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubStatusWithBack];
//                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
                //        [self presentViewController:nc animated:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
                    //                    sub.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:sub animated:YES];
                }
                });
//                [sub release];
//                [nc release];
                //        [sub release];
            }
                break;
#endif
        }
    }
    else if(indexPath.section == 1){
        
        switch (indexPath.row){
            case 0:
            {
                SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubAlarm];
//                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
                //        [self presentViewController:nc animated:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
                    //                    sub.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:sub animated:YES];
                }
                });
//                [sub release];
//                [nc release];
                
            }
                break;
            case 1:
            {
                
                GreenPushConfigViewController *pushConfig = [[GreenPushConfigViewController alloc]init];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![self.navigationController.topViewController isKindOfClass:[pushConfig class]])
                    [self.navigationController pushViewController:pushConfig animated:YES];
//                [pushConfig release];
                });
            }
                               
                break;
                
            default:
                break;
        }
    }
    //    else if(indexPath.section == 1){
    //        switch (indexPath.row) {
    //            case 0:
    //            {
    //                SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubPush];
    //                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
    //                //        [self presentViewController:nc animated:YES];
    //                [self.navigationController pushViewController:sub animated:YES];
    //                [sub release];
    //                [nc release];
    //            }
    //                break;
    //            case 1:
    //            {
    //
    //                    GreenPushConfigViewController *pushConfig = [[GreenPushConfigViewController alloc]init];
    //
    //                    [self.navigationController pushViewController:pushConfig animated:YES];
    //                    [pushConfig release];
    //
    //            }
    //                break;
    //
    //            default:
    //                break;
    //        }
    //
    //    }
    else if(indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
            {
                SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubGlobalFontSize];
//                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
                //        [self presentViewController:nc animated:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
                    //                    sub.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:sub animated:YES];
                }
                });
//                [sub release];
//                [nc release];
            }
                break;
            case 1:
            {
                
                PasswordViewController *pwv = [[PasswordViewController alloc]initFromSetup:YES];
//                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:pwv];
                //        [self presentViewController:nc animated:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![self.navigationController.topViewController isKindOfClass:[pwv class]])
                    [self.navigationController pushViewController:pwv animated:YES];
//                [pwv release];
//                [nc release];
                });
            }
                               
                break;
                
            default:
                break;
        }
        
    }
    else{
        switch (indexPath.row) {
#ifdef GreenTalkCustomer
            case 0:
            {
                
                EmptyListViewController *controller;
                controller = [[EmptyListViewController alloc]initWithSectionsWithList:@"" with:@"" from:kCompanyInfo master:@""];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![self.navigationController.topViewController isKindOfClass:[controller class]])
                    [self.navigationController pushViewController:controller animated:YES];
//                [controller release];
                });
            }
                break;
            case 1:{
                SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubProgram];
//                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
                //        [self presentViewController:nc animated:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
                    //                    sub.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:sub animated:YES];
                }
                });
//                [sub release];
//                [nc release];
            }
                break;
            case 2:
            {
                
                [CustomUIKit popupAlertViewOK:@"그린톡 탈퇴" msg:@"풀무원 건강생활 그린톡을 탈퇴합니다.\n탈퇴하시면 다시 초대받기 전까지는\n그린톡을 이용하실 수 없게 되며, 작성한\n모든 글에 대한 권한을 잃게 됩니다.\n정말 그린톡을 탈퇴 하시겠습니까?" delegate:self tag:(int)kConfirmLeave sel:@selector(confirmLeave) with:nil csel:nil with:nil];
            }
                break;
                
            default:
                break;
#else
            case 0:
            {
                //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"주소록을 다시 받아오시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
                //            [alert setTag:initContact];
                //            [alert show];
//                            [alert release];
                [CustomUIKit popupAlertViewOK:@"주소록 다시받기" msg:@"주소록을 다시 받아오시겠습니까?" delegate:self tag:(int)initContact sel:@selector(confirmInit) with:nil csel:nil with:nil];
            }
                break;
            case 1:{
                SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubProgram];
//                UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
                //        [self presentViewController:nc animated:YES];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
                    //                    sub.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:sub animated:YES];
                }
                });
//                [sub release];
//                [nc release];
            }
                break;
            case 2:
            {
                //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그아웃 하시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
                //            [alert setTag:logOut];
                //            [alert show];
                //            [alert release];
                [CustomUIKit popupAlertViewOK:NSLocalizedString(@"logout", @"logout") msg:@"로그아웃 하시겠습니까?" delegate:self tag:(int)logOut sel:@selector(confirmLogout) with:nil csel:nil with:nil];
            }
                break;
                
            default:
                break;
#endif
        }
        
    }
#elif BearTalk
//    if(indexPath.row == history)
//    {
//        // temp
//        HistoryViewController *historyView = [[HistoryViewController alloc]init];
//        //        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:historyView];
//        //        [self presentViewController:nc animated:YES];
//        if(![self.navigationController.topViewController isKindOfClass:[historyView class]])
//            [self.navigationController pushViewController:historyView animated:YES];
//        //        [historyView release];
//        //        [nc release];
//        
//    }
//    else
    
    if(indexPath.section == 3 && indexPath.row == location) {
        
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubLocation];
  
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
                //                sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
            }
        });
    }
   else if(indexPath.section == 3 && indexPath.row == theme)
    {
        
        [self showThemeActionSheet];
    }
    else if(indexPath.section == 3 && indexPath.row == programInfo)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubProgram];
        //        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //                sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
        //        [sub release];
        //        [nc release];
    }
    else if(indexPath.section == 3 && indexPath.row == initContact)
    {
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"주소록을 다시 받아오시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
        //            [alert setTag:initContact];
        //            [alert show];
        //            [alert release];
        [CustomUIKit popupAlertViewOK:@"주소록 다시받기" msg:@"주소록을 다시 받아오시겠습니까?" delegate:self tag:(int)initContact sel:@selector(confirmInit) with:nil csel:nil with:nil];
    }
    else if(indexPath.section == 0 && indexPath.row == status){
        
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubStatusWithBack];
        //        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //                sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
        //        [sub release];
        //        [nc release];
        //        [sub release];
    }
    else if(indexPath.section == 3 && indexPath.row == logOut) {
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그아웃 하시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
        //            [alert setTag:logOut];
        //            [alert show];
        //            [alert release];
        [CustomUIKit popupAlertViewOK:NSLocalizedString(@"logout", @"logout") msg:@"로그아웃 하시겠습니까?" delegate:self tag:(int)logOut sel:@selector(confirmLogout) with:nil csel:nil with:nil];
    }
    //        else if(indexPath.row == allSetup){
    //
    //
    //            SetupViewController *sub = [[SetupViewController alloc]initForSetup];
    //            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
    //            //        [self presentViewController:nc animated:YES];
    //            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
    ////                sub.hidesBottomBarWhenPushed = YES;
    //
    //                [self.navigationController pushViewController:sub animated:YES];            }
    //            [sub release];
    //            [nc release];
    //        }
    
    
    //    }
    //    else{
    
    else if (indexPath.section == 0 && indexPath.row == guide)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubGuide];
        //        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
                //            sub.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sub animated:YES];
            }
        });
        //        [sub release];
        //        [nc release];
    }
    else if (indexPath.section == 1 && indexPath.row == push)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubPush];
        //        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
        //        [sub release];
        //        [nc release];
    }
    else if(indexPath.section == 2 && indexPath.row == password)
    {
        
        PasswordViewController *pwv = [[PasswordViewController alloc]initFromSetup:YES];
        //        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:pwv];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[pwv class]])
            [self.navigationController pushViewController:pwv animated:YES];
        });
        //        [pwv release];
        //        [nc release];
    }
//    else if(indexPath.row == replySort)
//    {
//        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubReplySort];
//        //        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
//        //        [self presentViewController:nc animated:YES];
//        if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
//            //            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//        }
//        //        [sub release];
//        //        [nc release];
//    }
    else if (indexPath.section == 2 && indexPath.row == globalFontSize)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubGlobalFontSize];
        //        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
        //        [sub release];
        //        [nc release];
    }
//    else if(indexPath.row == alarm)
//    {
//        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubAlarm];
//        //        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
//        //        [self presentViewController:nc animated:YES];
//        if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
//            //            sub.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:sub animated:YES];
//        }
//        //        [sub release];
//        //        [nc release];
//    }
    else if(indexPath.section == 1 && indexPath.row == bell)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubBell];
        //        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
        //        [sub release];
        //        [nc release];
    }
    else if(indexPath.section == 1 && indexPath.row == alarm)
    {
        
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubAlarm];
        //        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
        //        [sub release];
        //        [nc release];
    }
    else if (indexPath.section == 2 && indexPath.row == shareAccount)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubShareAccount];
        //        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
        //        [sub release];
        //        [nc release];
        //	}
    }
    
    else if (indexPath.section == 2 && indexPath.row == viewDept)
    {
     
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"kViewDept"] == YES){
            OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"직급자보기가 해제되었습니다."];
            toast.position = OLGhostAlertViewPositionCenter;
            toast.style = OLGhostAlertViewStyleDark;
            toast.timeout = 2.0;
            toast.dismissible = YES;
            [toast show];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kViewDept"];
        }
        else{
            
            OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"직급자보기가 설정되었습니다."];
            toast.position = OLGhostAlertViewPositionCenter;
            toast.style = OLGhostAlertViewStyleDark;
            toast.timeout = 2.0;
            toast.dismissible = YES;
            [toast show];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kViewDept"];
        }
  
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [myTable reloadData];
        
    }
    else if(indexPath.section == 1 && indexPath.row == socialAlert) {
        
            GreenPushConfigViewController *pushConfig = [[GreenPushConfigViewController alloc]init];
            
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[pushConfig class]])
                [self.navigationController pushViewController:pushConfig animated:YES];
            //    [pushConfig release];
        });

    }
#else
    if(indexPath.row == history)
    {
        // temp
        HistoryViewController *historyView = [[HistoryViewController alloc]init];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:historyView];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[historyView class]])
            [self.navigationController pushViewController:historyView animated:YES];
        });
//        [historyView release];
//        [nc release];
        
    }
    else if(indexPath.row == programInfo)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubProgram];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //                sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
//        [sub release];
//        [nc release];
    }
    else if(indexPath.row == initContact)
    {
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"주소록을 다시 받아오시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
        //            [alert setTag:initContact];
        //            [alert show];
        //            [alert release];
        [CustomUIKit popupAlertViewOK:@"주소록 다시받기" msg:@"주소록을 다시 받아오시겠습니까?" delegate:self tag:(int)initContact sel:@selector(confirmInit) with:nil csel:nil with:nil];
    }
    else if(indexPath.row == status){
        
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubStatusWithBack];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //                sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
//        [sub release];
//        [nc release];
        //        [sub release];
    }
    else if(indexPath.row == logOut) {
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"로그아웃 하시겠습니까?" message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
        //            [alert setTag:logOut];
        //            [alert show];
        //            [alert release];
        [CustomUIKit popupAlertViewOK:NSLocalizedString(@"logout", @"logout") msg:@"로그아웃 하시겠습니까?" delegate:self tag:(int)logOut sel:@selector(confirmLogout) with:nil csel:nil with:nil];
    }
    //        else if(indexPath.row == allSetup){
    //
    //
    //            SetupViewController *sub = [[SetupViewController alloc]initForSetup];
    //            UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
    //            //        [self presentViewController:nc animated:YES];
    //            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
    ////                sub.hidesBottomBarWhenPushed = YES;
    //
    //                [self.navigationController pushViewController:sub animated:YES];            }
    //            [sub release];
    //            [nc release];
    //        }
    
    
    //    }
    //    else{
    else if (indexPath.row == push)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubPush];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
//        [sub release];
//        [nc release];
    }
    else if(indexPath.row == password)
    {
        
        PasswordViewController *pwv = [[PasswordViewController alloc]initFromSetup:YES];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:pwv];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[pwv class]])
            [self.navigationController pushViewController:pwv animated:YES];
        });
//        [pwv release];
//        [nc release];
    }
    else if(indexPath.row == replySort)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubReplySort];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
//        [sub release];
//        [nc release];
    }
    else if (indexPath.row == globalFontSize)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubGlobalFontSize];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
//        [sub release];
//        [nc release];
    }
    else if(indexPath.row == alarm)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubAlarm];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
//        [sub release];
//        [nc release];
    }
    else if(indexPath.row == bell)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubBell];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
//        [sub release];
//        [nc release];
    }
    else if (indexPath.row == shareAccount)
    {
        SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubShareAccount];
//        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:sub];
        //        [self presentViewController:nc animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(![self.navigationController.topViewController isKindOfClass:[sub class]]){
            //            sub.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sub animated:YES];
        }
        });
//        [sub release];
//        [nc release];
        //	}
    }
#endif
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

- (void)confirmLogout{
    
    
    
    
    
    [self logout];
}

- (void)confirmLeave{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"그린톡 탈퇴"
                                                                                 message:@"지금까지 풀무원 건강생활 그린톡을 이용해\n주셔서 감사합니다."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"ok")
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        [self confirmLeaveOK];
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"그린톡 탈퇴" message:@"지금까지 풀무원 건강생활 그린톡을 이용해\n주셔서 감사합니다." delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
        [alert setTag:kLeave];
        [alert show];
//        [alert release];
    }
}
- (void)confirmInit{
    
    //			[MBProgressHUD showHUDAddedTo:SharedAppDelegate.window label:@"앱을 종료하지 말고 기다려주세요." animated:YES];
  
    
#ifdef BearTalk
    
     [SharedAppDelegate writeToPlist:@"lastdate" value:@"0"];
#else
        [SharedAppDelegate writeToPlist:@"lastdate" value:@"0000-00-00 00:00:00"];
#endif
    [SharedAppDelegate.root setShowFeedbackMessage:YES];
    [SVProgressHUD showWithStatus:@"앱을 종료하지 말고\n기다려주세요." maskType:SVProgressHUDMaskTypeBlack];
    [SharedAppDelegate.root startup];
}
- (void)confirmLeaveOK{
    
    [SharedAppDelegate.root leaveApp];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1){
        if (alertView.tag == initContact) {
            [self confirmInit];
        } else if (alertView.tag == logOut) {
            
            [self confirmLogout];
        }
        else if(alertView.tag == kConfirmLeave){
            
            [self confirmLeave];
        }
        
    }
    else if(buttonIndex == 0){
        if(alertView.tag == kLeave){
            
            [self confirmLeaveOK];
        }
    }
}


- (void)logout{
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
        NSLog(@"1 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
        [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
        NSLog(@"2 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
        [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
        NSLog(@"3 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
        [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    if (SharedAppDelegate.root.slidingViewController.presentedViewController) {
        NSLog(@"4 %@",SharedAppDelegate.root.slidingViewController.presentedViewController);
        [SharedAppDelegate.root.slidingViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    
    //    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/logout.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           nil];//@{ @"uniqueid" : @"c110256" };
    
    
//    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/logout.lemp" parametersJson:param key:@"param"];
//    NSLog(@"jsonString %@",jsonString);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"1");
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"2");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSString *operationString = operation.responseString;
        if([operationString hasPrefix:@"["]){
            
            operationString = [operationString substringWithRange:NSMakeRange(1, [operationString length]-2)];
        }
        NSLog(@"4 %@",operationString);
        NSDictionary *resultDic = [operationString objectFromJSONString];//[0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            [SharedAppDelegate writeToPlist:@"loginfo" value:@"logout"];
            [SharedAppDelegate.root settingLogin];
            
        } else {
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
            //                [alert show];
            [CustomUIKit popupSimpleAlertViewOK:@"" msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
    
}

- (void)cancel
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 뒤로 버튼을 눌렀을 때. 한단계 위의 네비게이션컨트롤러로.
     연관화면 : 없음
     ****************************************************************/
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
    }
}

- (void)subBackTo
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 뒤로 버튼을 눌렀을 때. 한단계 위의 네비게이션컨트롤러로.
     연관화면 : 없음
     ****************************************************************/
    
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];// dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"viewWillAppear");
    
    self.view.backgroundColor = RGB(236, 236, 236);
    self.navigationController.navigationBar.translucent = NO;
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    
    if(SharedAppDelegate.root.greenBoard.selectedIndex == kSubTabIndexSetup){
        
        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    }
    
#endif
    
    
#ifdef BearTalk
    self.view.backgroundColor = RGB(238, 242, 245);
#endif
    [myTable reloadData];
}

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    [self settingAllSetup];
    
    
}

- (void)settingAllSetup{
    
    self.title = NSLocalizedString(@"setup", @"setup");
    
    //    UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
    //    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    //    self.navigationItem.leftBarButtonItem = btnNavi;
    //    [btnNavi release];
    NSLog(@"settingAllSetup");
#ifdef Hicare
#else
    UIButton *button;
    UIBarButtonItem *btnNavi;
  
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
  
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
#endif
    
    
    
#ifdef BearTalk
    status = 0;
    guide = 1;
    
    push = 0;
    alarm = 1;
    socialAlert = 2;
    bell = 102;
    
    globalFontSize = 0;
    password = 1;
    shareAccount = 2;
    viewDept = 3;
    
    theme = 0;
    location = 1;
    initContact = 2;
    programInfo = 3;
    logOut = 102;
    
    history = 100;
    replySort = 101;
    
//    myList = [[NSMutableArray alloc] initWithObjects:
//              NSLocalizedString(@"my_profile", @"my_profile"),
//              NSLocalizedString(@"push_alert", @"push_alert")",
//              @"알림음"
//              NSLocalizedString(@"setup_each_social_alert", @"setup_each_social_alert"),
//              @"글씨크기",
//              @"암호잠금",
//              @"직급자보기 설정",
//              @"공유 계정",
//              @"프로그램 정보",
//              @"주소록 다시받기",
//              NSLocalizedString(@"logout", @"logout"),
//              nil];
    if(myList){
        myList = nil;
    }
    myList = [[NSMutableArray alloc]init];
    [myList addObject:[NSArray arrayWithObjects:NSLocalizedString(@"my_profile", @"my_profile"),@"화면 가이드", nil]];
    [myList addObject:[NSArray arrayWithObjects:NSLocalizedString(@"push_alert", @"push_alert"),@"알림음",NSLocalizedString(@"setup_each_social_alert", @"setup_each_social_alert"),nil]];
    [myList addObject:[NSArray arrayWithObjects:@"글자 크기",@"앱 잠금",@"공유 계정",@"직급자보기 설정",nil]];
    [myList addObject:[NSArray arrayWithObjects:@"테마 설정", @"근무 지역 설정", @"주소록 다시받기",@"프로그램 정보",nil]];
#else
              socialAlert = 100;
              viewDept = 101;
    //    allSetup = 100;
    push = 0;
    status = 1;
    history = 2;
    password = 3;
    replySort = 4;
    globalFontSize = 5;
    alarm = 6;
    //    allSetup = 1;
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"mVoIPEnable"]) {
        
        bell = 7;
        shareAccount = 8;
        programInfo = 9;
        initContact = 10;
        logOut = 11;
        myList = [[NSMutableArray alloc] initWithObjects:
                  NSLocalizedString(@"push_alert", @"push_alert"),
                  NSLocalizedString(@"change_my_info", @"change_my_info"),
                  NSLocalizedString(@"chat_history", @"chat_history"),
                  NSLocalizedString(@"password", @"password"),
                  @"댓글 정렬 순서",
                  @"글자 크기",
                  @"알림음",
                  @"무료통화 벨소리",
                  @"공유 계정",
                  @"프로그램 정보",
                  @"주소록 다시받기",
                  NSLocalizedString(@"logout", @"logout"),
                  nil];
    }
    else{
        
        shareAccount = 7;
        programInfo = 8;
        initContact = 9;
        logOut = 10;
        myList = [[NSMutableArray alloc] initWithObjects:
                  NSLocalizedString(@"push_alert", @"push_alert"),
                  NSLocalizedString(@"change_my_info", @"change_my_info"),
                  NSLocalizedString(@"chat_history", @"chat_history"),
                  NSLocalizedString(@"password", @"password"),
                  @"댓글 정렬 순서",
                  @"글자 크기",
                  @"알림음",
                  @"공유 계정",
                  @"프로그램 정보",
                  @"주소록 다시받기",
                  NSLocalizedString(@"logout", @"logout"),
                  nil];
    }
    
#ifdef Hicare
    //    allSetup = 100;
    push = 0;
    status = 1;
    alarm = 2;
    globalFontSize = 3;
    password = 4;
    initContact = 5;
    programInfo = 6;
    myList = [[NSMutableArray alloc] initWithObjects:
              NSLocalizedString(@"push_alert", @"push_alert"),
              NSLocalizedString(@"my_info", @"my_info"),
              @"알림음",
              @"글자 크기",
              NSLocalizedString(@"password", @"password"),
              @"주소록 다시받기",
              @"프로그램 정보",
              nil];
    
    
    
    
    history = 100;
    replySort = 100;
    bell = 100;
    shareAccount = 100;
    logOut = 100;
#endif
    
#endif
    [myTable reloadData];
    
}



//- (void)settingSetup{
//
//    self.title = @"설정";
//
//    UIButton *button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(subBackTo)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
//
//    push = 0;//0;
//    password = 1;//3;
//    globalFontSize = 2;//5;
//    replySort = 3;//4;
//    alarm = 4;//6;
//
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"mVoIPEnable"]) {
//        bell = 5;//7;
//        shareAccount = 6;//8;
//
//        myList = [[NSMutableArray alloc] initWithObjects:
//              NSLocalizedString(@"push_alert", @"push_alert")",
//                  NSLocalizedString(@"password", @"password"),
//                  @"글자크기",
//                  @"댓글 정렬 순서",
//                  @"알림음",
//                  @"무료통화 벨소리",
//                  @"공유 계정",
//                  nil];
//    }
//    else{
//
//        shareAccount = 5;//8;
//
//        myList = [[NSMutableArray alloc] initWithObjects:
//                  NSLocalizedString(@"push_alert", @"push_alert")",
//                  NSLocalizedString(@"password", @"password"),
//                  @"글자크기",
//                  @"댓글 정렬 순서",
//                  @"알림음",
//                  @"공유 계정",
//                  nil];
//
//    }
//
//    myTable.tag = kSetup;
//    [myTable reloadData];
//
//}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


#if defined(GreenTalk) || defined(GreenTalkCustomer) || defined(BearTalk)
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, myTable.frame.size.width, 28)];
//    headerView.backgroundColor = [UIColor grayColor];
//    headerView.image = [CustomUIKit customImageNamed:@"headerbg.png"];
    
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 260, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont systemFontOfSize:14];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    
#ifdef BearTalk
    headerView.image = nil;
    headerView.backgroundColor = [UIColor clearColor];//RGB(238, 242, 245);
    headerView.frame = CGRectMake(0, 0, myTable.frame.size.width, 60);
    headerLabel.frame = CGRectMake(16, 30, 120, 20);
    headerLabel.textColor = RGB(180, 188, 192);
    headerLabel.font = [UIFont systemFontOfSize:13];
#endif
    
    
    switch (section) {
        case 0:
            headerLabel.text = @"";
            break;
        case 1:
            headerLabel.text = @"알림 설정";
            break;
        case 2:
            headerLabel.text = @"일반 설정";
            break;
        case 3:
            headerLabel.text = @"시스템 설정";
            break;
        default:
            break;
    }
    
    
    
    [headerView addSubview:headerLabel];
    
    
    
    return headerView;
}

-  (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
#ifdef BearTalk
    
    if(section == 0)
        return 30;
    else
        return 60;

#else

    if(section == 0)
        return 0;
    else
        return 28;
#endif
}

#endif


- (void)showThemeActionSheet{
    
    
    
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"대웅"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:RGB(255,112,58)];
                            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"themeColor"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"themeColorNumber"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                            [myTable reloadData];
                            [SharedAppDelegate resetNavigationBar];
                            [self cancel];
                            
                        }];
        [view addAction:actionButton];
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"우루사"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:RGB(102, 142, 57)];
                            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"themeColor"];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"themeColorNumber"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                            
                            [SharedAppDelegate resetNavigationBar];
                            [myTable reloadData];
                            [SharedAppDelegate resetNavigationBar];
                            [self cancel];
                            
                        }];
        [view addAction:actionButton];
    
    actionButton = [UIAlertAction
                    actionWithTitle:@"임팩타민"
                    style:UIAlertActionStyleDefault
                    handler:^(UIAlertAction * action)
                    {
                        
                        
                        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:RGB(35, 95, 205)];
                        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"themeColor"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:@"themeColorNumber"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [view dismissViewControllerAnimated:YES completion:nil];
                        
                        
                        [SharedAppDelegate resetNavigationBar];
                        [myTable reloadData];
                        [SharedAppDelegate resetNavigationBar];
                        [self cancel];
                        
                    }];
    [view addAction:actionButton];
    
        actionButton = [UIAlertAction
                        actionWithTitle:@"이지엔6"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:RGB(25, 207, 185)];
                            [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"themeColor"];
                            [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"themeColorNumber"];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                            
                            [SharedAppDelegate resetNavigationBar];
                            [myTable reloadData];
                            [SharedAppDelegate resetNavigationBar];
                            [self cancel];
                            
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [myList release];
//    [myTable release];
//    
//    [super dealloc];
}


@end
