//
//  CallManager.m
//  Lemp2
//
//  Created by Hyemin Kim on 13. 2. 5..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "CallManager.h"
#import <objc/runtime.h>
#import "ring.h"
#import "AddMemberViewController.h"

const char alertNumber;

@implementation CallManager

@synthesize audioPlayer;
@synthesize fromName;
@synthesize toName;
@synthesize savedNum;

- (void)closeAllCallView{
    NSLog(@"closeAllCallView \n out %@ \n income %@ \n call %@",fullOutgoingView,fullIncomingView,fullCallingView);
    [SharedAppDelegate.root setAudioRoute:NO];
//    [SharedAppDelegate.root stopRingSound];
//    if(outgoingView)
    //        [self cancelSideOutgoing];
    if(fullOutgoingView){
//        [self cancelFullOutgoing];
        [fullOutgoingView removeFromSuperview];
//        [fullOutgoingView release];
        fullOutgoingView = nil;
    }
//    if(incomingView)
//        [self cancelSideIncoming];
    if(fullIncomingView){
//        sip_ring_stop();
//        sip_ring_deinit();
 [self stopRingSound];
        //        [self cancelFullOutgoing];
        [fullIncomingView removeFromSuperview];
//        [fullIncomingView release];
        fullIncomingView = nil;
    }
//    if(callingView)
//        [self cancelSideCalling];
    if(fullCallingView){
        //        [self cancelFullOutgoing];
        [fullCallingView removeFromSuperview];
//        [fullCallingView release];
        fullCallingView = nil;
    }
//      [[VoIPSingleton sharedVoIP] callSpeaker:NO];
    
//    sip_ring_stop();
//    sip_ring_deinit();
    
    
    [[VoIPSingleton sharedVoIP] callSpeaker:NO];
    bSpeakerOn = NO;
    [self isCallingByPush:NO];
//    viewShown = NO;
//


    
    NSLog(@"pw length %@ %d",[SharedAppDelegate readPlist:@"pwsaved"],(int)[[SharedAppDelegate readPlist:@"pw"]length]);
    
    if([[SharedAppDelegate readPlist:@"pwsaved"]isEqualToString:@"1"] && [[SharedAppDelegate readPlist:@"pw"]length]==4 && bIncoming == YES)
    {
        [SharedAppDelegate.root showPassword];
        
    }
    
}

- (void)showDial:(id)sender{
    
    if(!fullCallingView)
        return;
    
    [SharedAppDelegate.root setAudioRoute:NO];
    NSLog(@"showDial");
    
    UIButton *button = (UIButton *)sender;
    
    dialView.hidden = !dialView.hidden;
    button.selected = !button.selected;
    
    if(button.selected){
        [button setBackgroundImage:[UIImage imageNamed:@"button_calling_hidedial.png"] forState:UIControlStateNormal];
        
    }
    else{
        [button setBackgroundImage:[UIImage imageNamed:@"button_calling_showdial.png"] forState:UIControlStateNormal];
    }
    
}

- (void)loadCallMember
{
    //    [self closeCall];
    NSLog(@"loadCallMember");
    
    //    [SharedAppDelegate.root loadSearch:kChat];
	
	AddMemberViewController *addController = [[AddMemberViewController alloc] initWithTag:7 array:nil add:nil];
    [addController setDelegate:self selector:@selector(selectedMember:)];
	addController.title = @"무료통화 대상 선택";
	UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:addController];
//	[self presentViewController:nc animated:YES completion:nil];
      [SharedAppDelegate.root anywhereModal:nc];
//	[addController release];
//	[nc release];
}

#define kUsingUid 1
#define kNotUsingUid 2
#define kNumber 3


- (void)selectedMember:(NSMutableArray*)member
{
	NSLog(@"member %@",member);
    if ([member count] < 1) {
		[SVProgressHUD showErrorWithStatus:@"선택된 대상이 없습니다!"];
		return;
	}
    [SharedAppDelegate.window addSubview:[self setFullOutgoing:member[0][@"uniqueid"] usingUid:kUsingUid]];
}

//#pragma mark - check outbound
//
//- (void)callCheck:(NSString *)num{
//    
//    NSLog(@"callCheck %@",num);
//    
////    NSString *number = [SharedAppDelegate.root getPureNumbers:num];
////    
////    if([number hasPrefix:@"*"])
////    {
//        [SharedAppDelegate.window addSubview:[self setFullOutgoing:num]];
////        
////    }
////    else{
////
////    if([number length]>4){
////        [self callAlert:num];
////        return;
////    }
////    if([number length]>3)
////    {
////        [SharedAppDelegate.window addSubview:[self setFullOutgoing:number]];
////    }
////    }
//}



- (void)callAlert:(NSString *)number{
    
    NSLog(@"number %@",number);
    
    
    
    UIAlertView *alert;
    NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 연결하시겠습니까?",number];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"일반통화"
                                                                        message:msg
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"네"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action){
                                                          
                                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:[SharedAppDelegate.root getPureNumbers:number]]]];
                                                          [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                      }];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           [alertcontroller dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alertcontroller addAction:cancelb];
        [alertcontroller addAction:okb];
        [SharedAppDelegate.window.rootViewController presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
    alert = [[UIAlertView alloc] initWithTitle:@"일반통화" message:msg delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
    objc_setAssociatedObject(alert, &alertNumber, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);    
    [alert show];
//    [alert release];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    
    if(buttonIndex == 1)
    {
        NSString *number = objc_getAssociatedObject(alertView, &alertNumber);
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:[SharedAppDelegate.root getPureNumbers:number]]]];
            
        
    }
    
}

#pragma mark - sount output

- (void)playDialingSound
{
    
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"lemp_ringbacktone" ofType:@"wav" inDirectory:NO];
	AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:soundPath] error:nil];
	newPlayer.numberOfLoops = -1;
	
	self.audioPlayer = newPlayer;
//	[newPlayer release];
	
	[self.audioPlayer prepareToPlay];
	[self.audioPlayer play];
}


- (void)stopDialingSound
{
	if ([self.audioPlayer isPlaying]) {
		[self.audioPlayer stop];
	}
    if(self.audioPlayer){
	self.audioPlayer = nil;
    }
}

#pragma mark - mvoip

- (void)mvoipOutgoingWith:(NSString *)num{
    
    NSLog(@"mvoipOutgoingWith %@",num);

    
    NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
    NSLog(@"dic %@",dic);
    
    NSString *userKey = [NSString stringWithFormat:@"*%@",dic[@"uid"]];
    NSString *userName = dic[@"name"];
    NSString *peerPhone = [SharedAppDelegate.root getPureNumbers:num];
    NSString *userPhone = @"";
    NSString *comphone = dic[@"officephone"];
    if([num hasPrefix:@"*"]){
        userPhone = userKey;
    }
    else{
        userPhone = comphone;//[comphone substringWithRange:NSMakeRange([comphone length]-4, 4)];
		//        userPhone = [[[SharedAppDelegate readPlist:@"email"]componentsSeparatedByString:@"@"]objectAtIndex:0];
    }
    
//    if(viewTag == kNumber){
//        userPhone = peerPhone;
//    }
    
    NSString *userPassword = [NSString stringWithFormat:@"min%@jun",userPhone];
    
	[VoIPSingleton sharedVoIP].bSendCall = YES;
	[VoIPSingleton sharedVoIP].szServerIP = [SharedAppDelegate readPlist:@"voip"];
	[VoIPSingleton sharedVoIP].nServerPort = [NSNumber numberWithUnsignedInt:62234];
	[VoIPSingleton sharedVoIP].szServerDomain = [SharedAppDelegate readPlist:@"sip"];
	[VoIPSingleton sharedVoIP].szUserKey = userKey;
    [VoIPSingleton sharedVoIP].szUserName = userName;
    [VoIPSingleton sharedVoIP].szPeerPhone = peerPhone;
    [VoIPSingleton sharedVoIP].szUserPhone = userPhone;
    [VoIPSingleton sharedVoIP].szUserPwd = userPassword;
    
    [cancel setEnabled:YES];
    
	[VoIPSingleton sharedVoIP].call_target = self;
	
    NSLog(@"IP:%@ domain:%@ key:%@ name:%@ peerphone:%@ userphone:%@",[SharedAppDelegate readPlist:@"voip"],[SharedAppDelegate readPlist:@"sip"],userKey,userName,peerPhone,userPhone);
	if ([[VoIPSingleton sharedVoIP] callStatus] == CALL_WAIT)
	{
		if ([[VoIPSingleton sharedVoIP] callStart:DCODEC_ALAW] == NO)
		{
			return;
		}
	}
    
}

- (void)mvoipIncomingWith:(NSDictionary *)dic{
    
    
    NSLog(@"======== mvoipIncomingWith %@",dic);
//    [SharedAppDelegate.root playRingSound];
    [self stopRingSound];
    
    
    if([dic[@"fromstatus"] isEqualToString:@"0"]){
        [self alreadyHangup];
        return;
    }
	
//    sip_ring_start();
    
    
	if ([[VoIPSingleton sharedVoIP] callQuerySuccessCall]) {        
		return;
    }
    
    NSArray *array = [dic[@"info"] componentsSeparatedByString:@":"];
    NSLog(@"array %@",array);
    if([array count]<2){
        [self alreadyHangup];
        return;
    }
    
    [SharedAppDelegate.root removePassword];
    
	
    if(!fullIncomingView){
        
        [SharedAppDelegate.window addSubview:[self setFullIncoming:dic active:NO]];
    }
    else{
//        sip_ring_init();
          [self playRingSound];
        
    }
    
//    [SharedAppDelegate.root stopRingSound];

    
//    [SharedAppDelegate.root playRingSound];
    NSDictionary *myDic = [SharedAppDelegate readPlist:@"myinfo"];
    NSString *userKey = [NSString stringWithFormat:@"*%@",myDic[@"uid"]];
    NSString *password = [NSString stringWithFormat:@"min%@jun",userKey];

    
    
    [VoIPSingleton sharedVoIP].bSendCall = NO;
	[VoIPSingleton sharedVoIP].szServerIP = array[0];//[dicobjectForKey:@"server"];
	[VoIPSingleton sharedVoIP].nServerPort = [NSNumber numberWithUnsignedInt:[array[1] intValue]];
	[VoIPSingleton sharedVoIP].szServerDomain = array[2];
	[VoIPSingleton sharedVoIP].szUserKey = userKey;
    [VoIPSingleton sharedVoIP].szUserPhone = userKey;
    [VoIPSingleton sharedVoIP].szUserPwd = password;
    [VoIPSingleton sharedVoIP].szPeerPhone = savedNum;
    
    
	[VoIPSingleton sharedVoIP].call_target = self;
//	[answer setEnabled:YES];
    [cancel setEnabled:YES];
    
//    [SharedAppDelegate.root playRingSound];
	NSLog(@"[[VoIPSingleton sharedVoIP] callStatus] %d",(int)[[VoIPSingleton sharedVoIP] callStatus]);

	if ([[VoIPSingleton sharedVoIP] callStatus] == CALL_WAIT)
	{
        NSLog(@"CALL_WAIT");
		if ([[VoIPSingleton sharedVoIP] callStart:DCODEC_ALAW] == NO)
		{
            NSLog(@"DCODEC_ALAW");
			return;
		}
		NSLog(@"HERE");
        
//		[[VoIPSingleton sharedVoIP] callSpeaker:YES];
	}
    else{
        
//		[[VoIPSingleton sharedVoIP] callSpeaker:NO];
        
    }
    
}


- (void)eventStatus:(NSInteger)status_type status_Code:(NSInteger)status_code
{
    NSLog(@"from %@ to  saved ",self.fromName);
    NSLog(@"from  to  saved %@",self.savedNum);
    NSLog(@"from to %@ saved ",self.toName);
	if (status_type == DEVENT_DIALING)
	{
		// do nothing
		NSLog(@"DEVENT_DIALING\n");
		[self playDialingSound];
	}
	else if (status_type == DEVENT_RINGING)
	{
		//TODO play Ringback Tone....
		NSLog(@"DEVENT_RINGING\n");
		[answer setEnabled:YES]; 
	}
	else if (status_type == DEVENT_CALL)
	{
		// do nothing
		NSLog(@"DEVENT_CALL\n");
		[self stopDialingSound];
        [SharedAppDelegate.window addSubview:[self setFullCalling]];
        //		[self showCalling];
		
	}
	else if (status_type == DEVENT_HOLD)
	{
		// do nothing
		NSLog(@"DEVENT_HOLD\n");
	}
	else if (status_type == DEVENT_HANGUP)
	{
		NSLog(@"DEVENT_HANGUP\n");
		[self stopDialingSound];
        [self closeAllCallView];
        NSDate *now = [[NSDate alloc] init];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *linuxString = [NSString stringWithFormat:@"%.0f",[now timeIntervalSince1970]];
//        [formatter setDateFormat:@"M월 d일 a h시 mm분"];
//        NSString *strTestTime = [[NSString alloc] initWithString:[formatter stringFromDate:now]];
//        [now release];
//        [formatter release];
        
//		[[VoIPSingleton sharedVoIP] callSpeaker:NO];
        
        NSLog(@"time %@",time);
        
        NSString *talkingTime = @"";

        if(time != nil && [time.text length]>0){
            NSLog(@"time not nil, time.text %@",time.text);
            talkingTime = time.text;
        
//                [time release];
                time = nil;
        }
        else//       if(time == nil || [time.text isEqualToString:@""] || [time.text isEqualToString:@"(null)"])
                {
                    if([self.fromName isEqualToString:@""])
                      talkingTime = @"발신 취소";
       
                    else if([self.toName isEqualToString:@""])
                        talkingTime = @"부재중 전화";
        
                }
        
        NSLog(@"talking time %@",talkingTime);
        NSLog(@"from %@ to %@ saved %@",self.fromName,self.toName,self.savedNum);
        
        [SQLiteDBManager AddListWithTalkdate:linuxString FromName:self.fromName ToName:self.toName Talktime:talkingTime Num:self.savedNum];

//        [strTestTime release];
		[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        
        
        
		[[VoIPSingleton sharedVoIP] callDestroy];
		
		NSLog(@"fromName %@ toName %@",self.fromName,self.toName);
        NSString *szByte = @"";//[[NSString alloc]init];
        NSLog(@"status_code %d",(int)status_code);
        
        if(status_code == DHANGUP_BUSY)
            szByte = [NSString stringWithFormat:@"상대방이 통화중입니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_NOANSWER)
            szByte = [NSString stringWithFormat:@"상대방이 전화를 받지않습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_REJECT && [self.fromName isEqualToString:@""])
            szByte = [NSString stringWithFormat:@"상대방이 전화를 받을 수 없는 상황입니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_CANCEL && [self.toName isEqualToString:@""])
            szByte = [NSString stringWithFormat:@"상대방이 발신을 취소하였습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_FAILURE)
            szByte = [NSString stringWithFormat:@"전화를 연결할 수 없습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_RTPTIMEOUT)
            szByte = [NSString stringWithFormat:@"네트워크 불안정으로 통화가 종료되었습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_TORTPTIMEOUT)
            szByte = [NSString stringWithFormat:@"상대방 네트워크 불안정으로 통화가 종료되었습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_CONGESTION)
            szByte = [NSString stringWithFormat:@"통화량이 많아 서비스가 제공되지 않습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_NOPERMIT)
            szByte = [NSString stringWithFormat:@"해당 번호로 전화를 걸 권한이 없습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_INCOMINGTIMEOUT)
            szByte = [NSString stringWithFormat:@"수신대기 시간을 초과하였습니다. (%d)",(int)status_code];
        else if(status_code > 29 && status_code < 40)
            szByte = [NSString stringWithFormat:@"mVoIP 서버에 연결할 수 없습니다. (%d)",(int)status_code];
        else if(status_code == 43)
            szByte = [NSString stringWithFormat:@"mVoIP 연동이 되어 있지 않습니다. (%d)",(int)status_code];
        else if(status_code > 39 && status_code < 50)
            szByte = [NSString stringWithFormat:@"mVoIP 계정에 문제가 있어 발신이 제한됐습니다. (%d)",(int)status_code];
        else if(status_code > 49 && status_code < 70 && status_code != 56 && status_code != 57)
            szByte = [NSString stringWithFormat:@"mVoIP 관리서버 연결에 문제가 있습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_WASCALEEBUSY)
            szByte = [NSString stringWithFormat:@"상대방이 통화중입니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_WASNOCALLER)
            szByte = [NSString stringWithFormat:@"발신자가 전화를 끊은 상태입니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_TO3GCALL)
            szByte = [NSString stringWithFormat:@"상대방에게 3G 전화가 와서 통화가 종료되었습니다. (%d)",(int)status_code];
        else if(status_code == DHANGUP_MPDND)
            szByte = [NSString stringWithFormat:@"상대방이 수신거부를 설정해놓았습니다. (%d)",(int)status_code];
        
        NSLog(@"status_code %d",(int)status_code);
        NSLog(@"szByte %@",szByte);
        
        if(szByte != nil && [szByte length]>0)
        {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:szByte con:SharedAppDelegate.window.rootViewController];
        }
        
        [SharedAppDelegate.root.recent refreshContents];
	} else {
		[self stopDialingSound];
	}
}



#pragma mark - outgoing UI
//
//- (UIView *)setSideOutgoing:(NSDictionary *)dic{
//    
//    if(outgoingView)
//        return nil;
//    
//    fromName = @"";
//    toName = [[NSString alloc]initWithFormat:@"%@",[dicobjectForKey:@"name"]];
//    savedNum = [[NSString alloc]initWithFormat:@"*%@",[dicobjectForKey:@"uniqueid"]];
//    talkingTime = @"";
//    
//    outgoingView = [[UIImageView alloc]initWithFrame:CGRectMake(0-320, 20+44, 320, 173)];
//    outgoingView.image = [CustomUIKit customImageNamed:@"n06_rcal_bg.png"];
//    outgoingView.userInteractionEnabled = YES;
//    
//    UIImageView *phone = [[UIImageView alloc]initWithFrame:CGRectMake(90, 20, 22, 28)];
//    phone.image = [CustomUIKit customImageNamed:@"n06_cic.png"];
//    [outgoingView addSubview:phone];
//    [phone release];
//    
//    UIImageView *profile = [[UIImageView alloc]init];
//    profile.image = [CustomUIKit customImageNamed:@"n01_tl_profile.png"];
//    profile.frame = CGRectMake(20, 20, 47, 47);
//    [outgoingView addSubview:profile];
//    [profile release];
//    
//    
//    NSString *nameAndPosition = [[dicobjectForKey:@"name"] stringByAppendingFormat:@" %@",[dicobjectForKey:@"grade2"]];
//    NSLog(@"nameAndPostiion %@",nameAndPosition);
//    UILabel *name = [CustomUIKit labelWithText:nameAndPosition fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(15, 75, 300, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [outgoingView addSubview:name];
////    [name release];
//    
//    UILabel *label = [CustomUIKit labelWithText:@"전화거는중..." fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(116, 20, 100, 25) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [outgoingView addSubview:label];
////    [label release];
//    
//    
//    UIButton *cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelSideOutgoing) frame:CGRectMake(12, 160-10-46, 296, 46) imageNamedBullet:nil imageNamedNormal:@"n06_cancelbtn.png" imageNamedPressed:nil];
//    [outgoingView addSubview:cancel];
////    [cancel release];
//    
////    [self mvoipOutgoingWith:[NSString stringWithFormat:@"*%@",[dicobjectForKey:@"uniqueid"]]];
//    
//    return outgoingView;
//}
//
//
//- (void)cancelSideOutgoing{
//    
//    if(outgoingView == nil)
//        return;
//    
//    [UIView animateWithDuration:0.4
//                     animations:^{
//                         outgoingView.frame = CGRectMake(0-320, 20+44, 320, 173);// its final location
//                     }];
//    [outgoingView release];
//    outgoingView = nil;
//}


- (void)alreadyHangup{
    
    [CustomUIKit popupSimpleAlertViewOK:nil msg:@"이미 종료된 전화입니다." con:SharedAppDelegate.window.rootViewController];
    [self closeAllCallView];
}

- (void)checkPush{
    if(callingByPush){
        [self alreadyHangup];
    }
}

- (BOOL)isCalling{
    NSLog(@"fullCallingView %@",fullCallingView);
    if(fullCallingView)
        return YES;
    else
        return NO;
}

- (void)isCallingByPush:(BOOL)yn{
    callingByPush = yn;
}

//- (void)isViewShown:(BOOL)yn{
//    viewShown = yn;
//}


- (UIView *)setFullOutgoing:(NSString *)u usingUid:(int)usingUid{// name:(NSString *)name{
    NSLog(@"setFullOutgoing %@ using %d",u,usingUid);
    
    
    viewTag = usingUid;
    
    if(fullOutgoingView)
        return nil;
    
    if ([u length]<1 || u == nil) {
        return nil;
    }
    
    bIncoming = NO;
    
//    if([num hasPrefix:@"*"]){
//
//        if([num hasSuffix:@","])
//            num = [num substringWithRange:NSMakeRange(0,[num length]-1)];
//
//    }
//    else{
//        
//    }
    NSDictionary *dic = nil;
    
    if(usingUid == kNumber){
    
        dic = [SharedAppDelegate.root searchDicWithOnlyNumber:u];
    }
    else{
        
    dic = [SharedAppDelegate.root searchContactDictionary:u];
    
    if([dic[@"uniqueid"]length]<1 || dic[@"uniqueid"]==nil)
    {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"직원 정보가 없습니다." con:SharedAppDelegate.window.rootViewController];
        return nil;
    }
    }
    
    NSLog(@"dic %@",dic);
   
    [SharedAppDelegate.root setAudioRoute:YES];
    NSString *uid = @"";
    
    if(usingUid == kUsingUid){
        uid = [NSString stringWithFormat:@"*%@",dic[@"uniqueid"]];
        if([uid hasSuffix:@","])
            uid = [uid substringWithRange:NSMakeRange(0,[uid length]-1)];
    }
    else if(usingUid == kNotUsingUid){
        uid = dic[@"companyphone"];
        
        if (uid==nil || [uid length]<1) {
            return nil;
        }
    }
    else {
        uid = u;
    }
    
    
    
    self.fromName = @"";//[[NSString alloc]init];
    self.toName = [dic[@"name"]length]>0?dic[@"name"]:@"";//[[NSString alloc]initWithFormat:@"%@",[dic[@"name"]length]>0?dic[@"name"]:@""];
    self.savedNum = [uid length]>0?uid:@"";//[[NSString alloc]initWithFormat:@"%@",[uid length]>0?uid:@""];
    
    NSLog(@"dic name %@",dic[@"name"]);
    NSLog(@"from %@ to %@ saved %@",self.fromName,self.toName,self.savedNum);
    if([dic[@"name"] length]<1 || dic[@"name"] == nil){
        toName = savedNum;
    
    }
    
    
    if(usingUid == kNumber){
        if(dic[@"uniqueid"] == nil || [dic[@"uniqueid"]length]<1){
        toName = u;
        savedNum = u;
        }
    }
    NSLog(@"from %@ to %@ saved %@",self.fromName,self.toName,self.savedNum);

    
    
    float height = 0;
    if(IS_HEIGHT568)
        height = 568-20;
    else
        height = 480-20;
    fullOutgoingView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, height)];
    fullOutgoingView.userInteractionEnabled = YES;
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    
    [fullOutgoingView addSubview:coverImageView];
    //    [imageView release];
    
    if(IS_HEIGHT568)
        coverImageView.frame = CGRectMake(0, 0, 320, 389);
    
#ifdef BearTalk
    
    coverImageView.frame = CGRectMake(0, 0, fullOutgoingView.frame.size.width, [SharedFunctions scaleFromHeight:453]);
    
    [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"call_nophoto.png" view:coverImageView scale:0];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        // add effect to an effect view
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        effectView.frame = coverImageView.frame;
        
        // add the effect view to the image view
        [coverImageView addSubview:effectView];
    }
    else{
        
        
        
        UIToolbar *blurView = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, coverImageView.frame.size.width, coverImageView.frame.size.height)];
        blurView.barStyle = UIBarStyleDefault;
        [coverImageView addSubview:blurView];
    }
    
    
#else

    
    UIImage *defaultImage = [CustomUIKit customImageNamed:@"imageview_call_cover.png"];
    [coverImageView setImage:defaultImage];
    
    [SharedAppDelegate.root getCoverImage:dic[@"uniqueid"] view:coverImageView ifnil:@"imageview_call_cover.png"];
#endif
    
    
    [coverImageView setContentMode:UIViewContentModeScaleAspectFill];
    [coverImageView setClipsToBounds:YES];
    
//        NSString *urlString = [NSString stringWithFormat:@"https://%@/file/%@/timelineimage_%@_.jpg",[SharedAppDelegate readPlist:@"was"],dic[@"uniqueid"],dic[@"uniqueid"]];
//        NSLog(@"urlString %@",urlString);
//        NSURL *imgURL = [NSURL URLWithString:urlString];
//        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:imgURL];
//        NSHTTPURLResponse* response = nil;
//        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//        NSInteger statusCode = [response statusCode];
//        NSLog(@"statusCode %d",(int)statusCode);
//        if(statusCode == 404){
//        }
//        else{
//            UIImage *image = [UIImage imageWithData:responseData];
//            [coverImageView setImage:image];
//        }
    
        
    
    
    
    
    
    UIImageView *imageView;
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_cover_dark.png" withFrame:coverImageView.frame];
   [fullOutgoingView addSubview:imageView];
    
#ifdef BearTalk
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_top_background.png" withFrame:CGRectMake(0, 0, fullOutgoingView.frame.size.width, 30)];
        [fullOutgoingView addSubview:imageView];
#else
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_top_background.png" withFrame:CGRectMake(0, 0, 320, 25)];
        [fullOutgoingView addSubview:imageView];
#endif
    
    
    UILabel *label;
    label = [CustomUIKit labelWithText:@"무료통화" fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [fullOutgoingView addSubview:label];
   
    int gap = 0;
    
    if(IS_HEIGHT568)
        gap = 30;
    
    UIImageView *profileView = [[UIImageView alloc]initWithFrame:CGRectMake(95,coverImageView.frame.origin.y + coverImageView.frame.size.height - 75 - 130 - gap, 130, 130)];
    [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"call_nophoto.png" view:profileView scale:0];
#ifdef BearTalk
    profileView.frame = CGRectMake(fullOutgoingView.frame.size.width/2 - 130/2, (coverImageView.frame.size.height - 30)/2 - 130/2, 130, 130);
#endif
    [fullOutgoingView addSubview:profileView];
//    [profileView release];
    profileView.layer.cornerRadius = profileView.frame.size.width / 2;
    profileView.clipsToBounds = YES;
    
//    UIImageView *coverView;
//    coverView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_profile_rounding.png" withFrame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height)];
//    [profileView addSubview:coverView];
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"" withFrame:CGRectMake(0, coverImageView.frame.size.height, 320, fullOutgoingView.frame.size.height - coverImageView.frame.size.height)];
    imageView.backgroundColor = RGB(251,251,251);
    
#ifdef BearTalk
    imageView.backgroundColor = [UIColor whiteColor];
#endif
    [fullOutgoingView addSubview:imageView];
//    [imageView release];
    
//    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_outico.png" withFrame:CGRectMake(320-75, 103, 68, 15)];
//    [fullOutgoingView addSubview:imageView];
//    [imageView release];
    
//    if(IS_HEIGHT568){
//        imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_03.png" withFrame:CGRectMake(0, 98+26, 320, 308)];
//        [fullOutgoingView addSubview:imageView];
//        [imageView release];
//    }
//    else{
//    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_03.png" withFrame:CGRectMake(0, 98+26, 320, 500)];
//    [fullOutgoingView addSubview:imageView];
////    [imageView release];
////    }
//    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_04.png" withFrame:CGRectMake(0, height-85, 320, 85)];
//    [fullOutgoingView addSubview:imageView];
    if(IS_HEIGHT568)
        gap = 20;
    
    bSpeakerOn = NO;
#ifdef BearTalk
#else
    UIButton *speaker;
    speaker = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(speakerOnOff:) frame:CGRectMake(122, coverImageView.frame.origin.y + coverImageView.frame.size.height - 75 - gap, 75, 75) imageNamedBullet:nil imageNamedNormal:@"button_call_speaker_on.png" imageNamedPressed:nil];
//    [coverImageView release];
    [fullOutgoingView addSubview:speaker];
#endif
    if(IS_HEIGHT568)
        gap = 15;
    
    UILabel *toLabel;
    toLabel = [CustomUIKit labelWithText:toName fontSize:25 fontColor:[UIColor whiteColor] frame:CGRectMake(0, profileView.frame.origin.y - 60 - gap, 320, 28) numberOfLines:1 alignText:NSTextAlignmentCenter];
    toLabel.font = [UIFont boldSystemFontOfSize:25];
#ifdef BearTalk
    toLabel.frame = CGRectMake(16, CGRectGetMaxY(profileView.frame)+12, fullOutgoingView.frame.size.width - 32, 27);
    toLabel.font = [UIFont boldSystemFontOfSize:23];
#endif
    [fullOutgoingView addSubview:toLabel];
    
    
#ifdef BearTalk
    
    
    UILabel *positionLabel;
    UIScrollView *positionScrollView;
    
    positionScrollView = [[UIScrollView alloc]init];
    positionScrollView.frame = CGRectMake(toLabel.frame.origin.x,CGRectGetMaxY(toLabel.frame)+6,toLabel.frame.size.width,90);
    [fullOutgoingView addSubview:positionScrollView];
    
    positionLabel = [[UILabel alloc]init];
    [positionLabel setBackgroundColor:[UIColor clearColor]];
    positionLabel.textAlignment = NSTextAlignmentCenter;
    positionLabel.numberOfLines = 0;
    [positionLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [positionLabel setFont:[UIFont systemFontOfSize:14]];
    positionLabel.textColor = [UIColor whiteColor];
    [positionScrollView addSubview:positionLabel];
    
    
    
    if([dic[@"newfield4"] isKindOfClass:[NSArray class]]){
        NSString *positionstring = @"";
        
        for(NSDictionary *pdic in dic[@"newfield4"]){
            
            NSString *dcode = pdic[@"deptcode"];
            NSString *pcode = [[ResourceLoader sharedInstance] searchParentCode:dcode];
            
            if([pdic[@"position"]length]>0)
                positionstring = [positionstring stringByAppendingFormat:@" %@ |",pdic[@"position"]];
            
            if([[[ResourceLoader sharedInstance] searchCode:dcode]length]>0)
                positionstring = [positionstring stringByAppendingFormat:@" %@ |",[[ResourceLoader sharedInstance] searchCode:dcode]];
            
            if([[[ResourceLoader sharedInstance] searchCode:pcode]length]>0)
                positionstring = [positionstring stringByAppendingFormat:@" %@ |",[[ResourceLoader sharedInstance] searchCode:pcode]];
            
            if([positionstring hasSuffix:@"|"]){
                positionstring = [positionstring substringWithRange:NSMakeRange(0,[positionstring length]-1)];
            }
            
            positionstring = [positionstring stringByAppendingString:@"\n"];
            
            
            
        }
        
        if([positionstring hasSuffix:@"\n"]){
            positionstring = [positionstring substringWithRange:NSMakeRange(0,[positionstring length]-2)];
        }
        
        NSLog(@"positionstring %@",positionstring);
        positionLabel.text = positionstring;
    }
    else{
        NSString *pcode = [[ResourceLoader sharedInstance] searchParentCode:dic[@"deptcode"]];
        
        NSString *positionstring = @"";
        if([dic[@"grade2"]length]>0)
            positionstring = [positionstring stringByAppendingFormat:@" %@ |",dic[@"grade2"]];
        
        if([dic[@"team"]length]>0)
            positionstring = [positionstring stringByAppendingFormat:@" %@ |",dic[@"team"]];
        
        if([[[ResourceLoader sharedInstance] searchCode:pcode]length]>0)
            positionstring = [positionstring stringByAppendingFormat:@" %@ |",[[ResourceLoader sharedInstance] searchCode:pcode]];
        
        if([positionstring hasSuffix:@"|"]){
            positionstring = [positionstring substringWithRange:NSMakeRange(0,[positionstring length]-1)];
        }
        NSLog(@"positionstring %@",positionstring);
        positionLabel.text = positionstring;
        
        
        
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:positionLabel.font, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [positionLabel.text boundingRectWithSize:CGSizeMake(positionLabel.frame.size.width, 200) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//    CGSize size = [positionLabel.text sizeWithFont:positionLabel.font constrainedToSize:CGSizeMake(positionLabel.frame.size.width, 200) lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"position size %@",NSStringFromCGSize(size));
    
    positionLabel.frame = CGRectMake(0, 0, positionScrollView.frame.size.width, size.height);
    positionScrollView.contentSize = CGSizeMake(positionScrollView.frame.size.width,size.height+5);
    
    NSLog(@"positionScrollView %@",NSStringFromCGRect(positionScrollView.frame));
    NSLog(@"positionLabel %@",NSStringFromCGRect(positionLabel.frame));
    
    
    UILabel *lblInfo = [[UILabel alloc]init];
    lblInfo.frame = CGRectMake(16,[SharedFunctions scaleFromHeight:64],coverImageView.frame.size.width-32,profileView.frame.origin.y - [SharedFunctions scaleFromHeight:64]);
    lblInfo.textColor = [UIColor whiteColor];
    lblInfo.font = [UIFont boldSystemFontOfSize:23];
    lblInfo.textAlignment = NSTextAlignmentCenter;
    lblInfo.numberOfLines = 2;
    [fullOutgoingView addSubview:lblInfo];
    
    lblInfo.text = dic[@"newfield1"];
    
#else
    

    UILabel *positionLabel;
    positionLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%@ | %@",dic[@"grade2"]==nil?@"":dic[@"grade2"],dic[@"team"]==nil?@"":dic[@"team"]] fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, toLabel.frame.origin.y + toLabel.frame.size.height + 5, 320, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    if(dic[@"grade2"] == nil && dic[@"team"] == nil)
        positionLabel.text = @"";
    NSLog(@"dic %@ %@",dic[@"grade2"],dic[@"team"]);
    NSLog(@"positionlabel.text %@",positionLabel.text);
    
    [fullOutgoingView addSubview:positionLabel];
    
    if(usingUid == kNumber){
        if([positionLabel.text length]<1){
        positionLabel.text = @"";
        }
        
    }
#endif

    
#ifdef BearTalk
    
    
    cancel = [CustomUIKit buttonWithTitle:@"" fontSize:0 fontColor:RGB(255,255,255) target:self selector:@selector(cancelFullOutgoing)
                                    frame:CGRectMake(fullOutgoingView.frame.size.width/2 - 160/2, fullOutgoingView.frame.size.height - 100+27, 160, 46)
                         imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [fullOutgoingView addSubview:cancel];
    cancel.backgroundColor = RGB(255, 59, 48);
    cancel.clipsToBounds = YES;
    cancel.layer.cornerRadius = 23;
    
    
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"btn_call_reject.png" withFrame:CGRectMake(cancel.frame.size.width/2 - 35/2, cancel.frame.size.height/2 - 33/2, 35, 33)];
    [cancel addSubview:imageView];
    
    label = [CustomUIKit labelWithText:@"발신 전화" fontSize:25 fontColor:RGB(31, 192, 214) frame:CGRectMake(16, CGRectGetMaxY(coverImageView.frame)+[SharedFunctions scaleFromHeight:30], fullOutgoingView.frame.size.width - 32 , 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:23];
    [fullOutgoingView addSubview:label];
    
#else
    cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelFullOutgoing) frame:CGRectMake(18, height-20-44-20, 284, 44) imageNamedBullet:nil imageNamedNormal:@"button_call_hangup.png" imageNamedPressed:nil];
    [fullOutgoingView addSubview:cancel];
    [cancel setEnabled:NO];
//    [cancel release];
    
    label = [CustomUIKit labelWithText:@"발신전화" fontSize:23 fontColor:RGB(41, 197, 185) frame:CGRectMake(0, cancel.frame.origin.y - 50, 320, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:23];
    [fullOutgoingView addSubview:label];
#endif
    [self mvoipOutgoingWith:uid];
    
    return fullOutgoingView;
}


- (UIView *)setReDialing:(NSDictionary *)dic uid:(NSString *)uid{
    
    NSLog(@"setReDialing dic %@",dic);

    
    if(fullOutgoingView)
        return nil;
    
    if (dic == nil) {
        return nil;
    }
    
    bIncoming = NO;
    
    
    NSLog(@"dic %@",dic);
 
    NSString *number = @"";
    
  
        number = dic[@"num"];
        
        if (number == nil || [number length]<1) {
            return nil;
        }
    
    
    
    self.fromName = @"";//[[NSString alloc]init];
    self.toName = [dic[@"toname"]length]>0?dic[@"toname"]:dic[@"fromname"];//[[NSString alloc]initWithFormat:@"%@",[dic[@"toname"]length]>0?dic[@"toname"]:dic[@"fromname"]];
    self.savedNum = dic[@"num"];//[[NSString alloc]initWithFormat:@"%@",dic[@"num"]];
    
    if([toName length]<1 || toName == nil){
        toName = savedNum;
        
    }
    
    float height = 0;
  
    
#ifdef BearTalk
    height = SharedAppDelegate.window.frame.size.height - 20;
#else
    if(IS_HEIGHT568)
        height = 568-20;
    else
        height = 480-20;
#endif
    
    fullOutgoingView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, height)];
    fullOutgoingView.userInteractionEnabled = YES;
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    [coverImageView setContentMode:UIViewContentModeScaleAspectFill];
    [coverImageView setClipsToBounds:YES];
    UIImage *defaultImage = [CustomUIKit customImageNamed:@"imageview_call_cover.png"];
    
    
    [coverImageView setImage:defaultImage];
    
    
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@/file/%@/timelineimage_%@_.jpg",[SharedAppDelegate readPlist:@"was"],uid,uid];
//    NSLog(@"urlString %@",urlString);
//    NSURL *imgURL = [NSURL URLWithString:urlString];
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:imgURL];
//    NSHTTPURLResponse* response = nil;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    NSInteger statusCode = [response statusCode];
//    NSLog(@"statusCode %d",(int)statusCode);
//    if(statusCode == 404){
//    }
//    else{
//        UIImage *image = [UIImage imageWithData:responseData];
//        [coverImageView setImage:image];
//    }
    
    NSDictionary *contactDic = [SharedAppDelegate.root searchContactDictionary:uid];
    [SharedAppDelegate.root getCoverImage:contactDic[@"uniqueid"] view:coverImageView ifnil:@"imageview_call_cover.png"];
    
    [fullOutgoingView addSubview:coverImageView];
    //    [imageView release];
    if(IS_HEIGHT568)
        coverImageView.frame = CGRectMake(0, 0, 320, 389);
    
    
    
    NSLog(@"contactDic %@",contactDic);
    
    UIImageView *imageView;
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_cover_dark.png" withFrame:coverImageView.frame];
    [fullOutgoingView addSubview:imageView];
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_top_background.png" withFrame:CGRectMake(0, 0, 320, 25)];
    [fullOutgoingView addSubview:imageView];
    
    
    UILabel *label;
    label = [CustomUIKit labelWithText:@"무료통화" fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, 320, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [fullOutgoingView addSubview:label];
    
    int gap = 0;
    
    if(IS_HEIGHT568)
        gap = 30;
    
    UIImageView *profileView = [[UIImageView alloc]initWithFrame:CGRectMake(95,coverImageView.frame.origin.y + coverImageView.frame.size.height - 75 - 130 - gap, 130, 130)];
    [SharedAppDelegate.root getProfileImageWithURL:uid ifNil:@"call_nophoto.png" view:profileView scale:0];
    [fullOutgoingView addSubview:profileView];
//    [profileView release];
    profileView.layer.cornerRadius = profileView.frame.size.width / 2;
    profileView.clipsToBounds = YES;
    
    //    UIImageView *coverView;
    //    coverView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_profile_rounding.png" withFrame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height)];
    //    [profileView addSubview:coverView];
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"" withFrame:CGRectMake(0, coverImageView.frame.size.height, 320, fullOutgoingView.frame.size.height - coverImageView.frame.size.height)];
    imageView.backgroundColor = RGB(251,251,251);
    [fullOutgoingView addSubview:imageView];
    //    [imageView release];
    
    //    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_outico.png" withFrame:CGRectMake(320-75, 103, 68, 15)];
    //    [fullOutgoingView addSubview:imageView];
    //    [imageView release];
    
    //    if(IS_HEIGHT568){
    //        imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_03.png" withFrame:CGRectMake(0, 98+26, 320, 308)];
    //        [fullOutgoingView addSubview:imageView];
    //        [imageView release];
    //    }
    //    else{
    //    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_03.png" withFrame:CGRectMake(0, 98+26, 320, 500)];
    //    [fullOutgoingView addSubview:imageView];
    ////    [imageView release];
    ////    }
    //    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_04.png" withFrame:CGRectMake(0, height-85, 320, 85)];
    //    [fullOutgoingView addSubview:imageView];
    if(IS_HEIGHT568)
        gap = 20;
    
    bSpeakerOn = NO;
    UIButton *speaker;
    speaker = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(speakerOnOff:) frame:CGRectMake(122, coverImageView.frame.origin.y + coverImageView.frame.size.height - 75 - gap, 75, 75) imageNamedBullet:nil imageNamedNormal:@"button_call_speaker_on.png" imageNamedPressed:nil];
//    [coverImageView release];
    
    [fullOutgoingView addSubview:speaker];
  
    if(IS_HEIGHT568)
        gap = 15;
    
    UILabel *toLabel;
    toLabel = [CustomUIKit labelWithText:toName fontSize:25 fontColor:[UIColor whiteColor] frame:CGRectMake(0, profileView.frame.origin.y - 60 - gap, 320, 28) numberOfLines:1 alignText:NSTextAlignmentCenter];
    toLabel.font = [UIFont boldSystemFontOfSize:25];
    [fullOutgoingView addSubview:toLabel];
    
    UILabel *positionLabel;
    positionLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%@ | %@",contactDic[@"grade2"]==nil?@"":contactDic[@"grade2"],contactDic[@"team"]==nil?@"":contactDic[@"team"]] fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, toLabel.frame.origin.y + toLabel.frame.size.height + 5, 320, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [fullOutgoingView addSubview:positionLabel];
    if(contactDic[@"grade2"] == nil && contactDic[@"team"] == nil)
        positionLabel.text = @"";
    
    
    cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelFullOutgoing) frame:CGRectMake(18, height-20-44-20, 284, 44) imageNamedBullet:nil imageNamedNormal:@"button_call_hangup.png" imageNamedPressed:nil];
    [fullOutgoingView addSubview:cancel];
    [cancel setEnabled:NO];
//    [cancel release];
    
    label = [CustomUIKit labelWithText:@"발신전화" fontSize:23 fontColor:RGB(41, 197, 185) frame:CGRectMake(0, cancel.frame.origin.y - 50, 320, 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:23];
    [fullOutgoingView addSubview:label];
    
    
    [self mvoipOutgoingWith:number];
    
    return fullOutgoingView;
}

- (void)cancelFullOutgoing{
    NSLog(@"cancelFullOutgoing");

    fullOutgoingView.hidden = YES;
    
    [[VoIPSingleton sharedVoIP]callHangup:DHANGUP_CANCEL];

    [self closeAllCallView];

//    if(fullOutgoingView == nil)
//        return;
//    
//    [fullOutgoingView removeFromSuperview];
//    [fullOutgoingView release];
//    fullOutgoingView = nil;
    
}


#pragma mark - incoming UI
//- (UIView *)setSideIncoming:(NSDictionary *)dic{
//    
//    if(incomingView)
//        return nil;
//    
//    fromName = [[NSString alloc]initWithFormat:@"%@",[dicobjectForKey:@"name"]];
//    toName = @"";
//    savedNum = [[NSString alloc]initWithFormat:@"*%@",[dicobjectForKey:@"uniqueid"]];
//    talkingTime = @"";
//    
//    incomingView = [[UIImageView alloc]initWithFrame:CGRectMake(0-320, 20+44, 320, 173)];
//    incomingView.image = [CustomUIKit customImageNamed:@"n06_rcal_bg.png"];
//    incomingView.userInteractionEnabled = YES;
//    
//    UIImageView *phone = [[UIImageView alloc]initWithFrame:CGRectMake(90, 20, 22, 28)];
//    phone.image = [CustomUIKit customImageNamed:@"n06_cic.png"];
//    [incomingView addSubview:phone];
//    [phone release];
//    
//    UIImageView *profile = [[UIImageView alloc]init];
//    profile.image = [CustomUIKit customImageNamed:@"n01_tl_profile.png"];
//    profile.frame = CGRectMake(20, 20, 47, 47);
//    [incomingView addSubview:profile];
//    [profile release];
//    
//    
//    NSString *nameAndPosition = [[dicobjectForKey:@"name"] stringByAppendingFormat:@" %@",[dicobjectForKey:@"grade2"]];
//    NSLog(@"nameAndPostiion %@",nameAndPosition);
//    UILabel *name = [CustomUIKit labelWithText:nameAndPosition fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(15, 75, 300, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [incomingView addSubview:name];
////    [name release];
//    
//    UILabel *label = [CustomUIKit labelWithText:@"전화가 왔습니다." fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(116, 20, 180, 25) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [incomingView addSubview:label];
////    [label release];
//    
//    
//    UIButton *cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelSideIncoming) frame:CGRectMake(10, 160-10-46, 145, 46) imageNamedBullet:nil imageNamedNormal:@"n06_nocal_bt.png" imageNamedPressed:nil];
//    [incomingView addSubview:cancel];
////    [cancel release];
//    
//    UIButton *answer = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(answerSideIncoming) frame:CGRectMake(10+145+10, 160-10-46, 145, 46) imageNamedBullet:nil imageNamedNormal:@"n06_yscal_bt.png" imageNamedPressed:nil];
//    [incomingView addSubview:answer];
////    [answer release];
//    
//    
//    return incomingView;
//}
//
//
//- (void)cancelSideIncoming{
//    
//    if(incomingView == nil)
//        return;
//    
//    [UIView animateWithDuration:0.4
//                     animations:^{
//                         incomingView.frame = CGRectMake(0-320, 20+44, 320, 173);// its final location
//                     }];
//    [incomingView release];
//    incomingView = nil;
//}
//- (void)answerSideIncoming{
//    
//}

- (UIView *)setFullIncoming:(NSDictionary *)adic active:(BOOL)active{//(NSString *)num name:(NSString *)name{
    NSLog(@"setFullIncoming %@ / %@",active?@"YES":@"NO",adic);
    
//    [SharedAppDelegate.root stopRingSound];
    
    if(fullIncomingView){
        [self mvoipIncomingWith:adic];
        return nil;
    }
    
//    if(viewShown)
//        return nil;
    
    [SharedAppDelegate.window endEditing:TRUE];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self playRingSound];
    bIncoming = YES;
//    viewShown = YES;
//    talkingTime = @"";
   
    
    NSString *uid = @"";
    
    self.fromName = [adic[@"cname"]length]>0?adic[@"cname"]:@"";//[[NSString alloc]initWithFormat:@"%@",[dic[@"cname"]length]>0?dic[@"cname"]:@""];
    self.toName = @"";//[[NSString alloc]init];
    self.savedNum = [adic[@"cid"]length]>0?adic[@"cid"]:@"";//[[NSString alloc]initWithFormat:@"%@",[dic[@"cid"]length]>0?dic[@"cid"]:@""];
   
    NSLog(@"from %@ to %@ saved %@",self.fromName,self.toName,self.savedNum);
  
    
    if([self.savedNum hasPrefix:@"*"]){
        uid = [self.savedNum substringWithRange:NSMakeRange(1,[self.savedNum length]-1)];
      
    }
    else{
        uid = savedNum;
    }
     NSDictionary *dic = [SharedAppDelegate.root searchContactDictionary:uid];
       NSLog(@"dic %@",dic);
    float height = 0;
#ifdef BearTalk
    height = SharedAppDelegate.window.frame.size.height - 20;
#else
    
    if(IS_HEIGHT568)
        height = 568-20;
    else
        height = 480-20;
#endif
    
    fullIncomingView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SharedAppDelegate.window.frame.size.width, height)];
    fullIncomingView.userInteractionEnabled = YES;
    
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    if(IS_HEIGHT568)
        coverImageView.frame = CGRectMake(0, 0, 320, 389);
    
    [fullIncomingView addSubview:coverImageView];
    
#ifdef BearTalk
    coverImageView.frame = CGRectMake(0, 0, fullIncomingView.frame.size.width, [SharedFunctions scaleFromHeight:453]);
    
    [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"call_nophoto.png" view:coverImageView scale:0];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        // add effect to an effect view
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        effectView.frame = coverImageView.frame;
        
        // add the effect view to the image view
        [coverImageView addSubview:effectView];
    }
    else{
        
        
        
        UIToolbar *blurView = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, coverImageView.frame.size.width, coverImageView.frame.size.height)];
        blurView.barStyle = UIBarStyleDefault;
        [coverImageView addSubview:blurView];
    }
    
    
#else
    
    UIImage *defaultImage = [CustomUIKit customImageNamed:@"imageview_call_cover.png"];
    [coverImageView setImage:defaultImage];
    
    [SharedAppDelegate.root getCoverImage:dic[@"uniqueid"] view:coverImageView ifnil:@"imageview_call_cover.png"];
#endif
    
    
    [coverImageView setContentMode:UIViewContentModeScaleAspectFill];
    [coverImageView setClipsToBounds:YES];
  
    
    
    
    
//    NSString *urlString = [NSString stringWithFormat:@"https://%@/file/%@/timelineimage_%@_.jpg",[SharedAppDelegate readPlist:@"was"],uid,uid];
//    NSLog(@"urlString %@",urlString);
//    NSURL *imgURL = [NSURL URLWithString:urlString];
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:imgURL];
//    NSHTTPURLResponse* response = nil;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
//    NSInteger statusCode = [response statusCode];
//    NSLog(@"statusCode %d",(int)statusCode);
//    if(statusCode == 404){
//    }
//    else{
//        UIImage *image = [UIImage imageWithData:responseData];
//        [coverImageView setImage:image];
//    }
    
    //    [imageView release];
    
    
    
    
    UIImageView *imageView;
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_cover_dark.png" withFrame:coverImageView.frame];
    [fullIncomingView addSubview:imageView];
    
#ifdef BearTalk
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_top_background.png" withFrame:CGRectMake(0, 0, fullIncomingView.frame.size.width, 30)];
    
#else
    imageView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_top_background.png" withFrame:CGRectMake(0, 0, 320, 25)];
#endif
    [fullIncomingView addSubview:imageView];
    
    
    UILabel *label;
    label = [CustomUIKit labelWithText:@"무료통화" fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [fullIncomingView addSubview:label];
    
    
    int gap = 0;
    
    if(IS_HEIGHT568)
        gap = 30;
    
    UIImageView *profileView = [[UIImageView alloc]initWithFrame:CGRectMake(95,coverImageView.frame.origin.y + coverImageView.frame.size.height - 75 - 130 - gap, 130, 130)];
#ifdef BearTalk
    profileView.frame = CGRectMake(fullIncomingView.frame.size.width/2 - 130/2, (coverImageView.frame.size.height - 30)/2 - 130/2, 130, 130);
#endif
    [SharedAppDelegate.root getProfileImageWithURL:dic[@"uniqueid"] ifNil:@"call_nophoto.png" view:profileView scale:0];
    [fullIncomingView addSubview:profileView];
//    [profileView release];
    profileView.layer.cornerRadius = profileView.frame.size.width / 2;
    profileView.clipsToBounds = YES;
    
    //    UIImageView *coverView;
    //    coverView = [CustomUIKit createImageViewWithOfFiles:@"imageview_call_profile_rounding.png" withFrame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height)];
    //    [profileView addSubview:coverView];
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"" withFrame:CGRectMake(0, coverImageView.frame.size.height, fullIncomingView.frame.size.width, fullIncomingView.frame.size.height - coverImageView.frame.size.height)];
//    [coverImageView release];
    imageView.backgroundColor = RGB(251,251,251);
#ifdef BearTalk
    imageView.backgroundColor = [UIColor whiteColor];
#endif
    [fullIncomingView addSubview:imageView];
    //    [imageView release];
    
    //    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_outico.png" withFrame:CGRectMake(320-75, 103, 68, 15)];
    //    [fullIncomingView addSubview:imageView];
    //    [imageView release];
    
    //    if(IS_HEIGHT568){
    //        imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_03.png" withFrame:CGRectMake(0, 98+26, 320, 308)];
    //        [fullIncomingView addSubview:imageView];
    //        [imageView release];
    //    }
    //    else{
    //    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_03.png" withFrame:CGRectMake(0, 98+26, 320, 500)];
    //    [fullIncomingView addSubview:imageView];
    ////    [imageView release];
    ////    }
    //    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_04.png" withFrame:CGRectMake(0, height-85, 320, 85)];
    //    [fullIncomingView addSubview:imageView];
    
    if(IS_HEIGHT568)
        gap = 15;
    
    UILabel *fromLabel;
    fromLabel = [CustomUIKit labelWithText:self.fromName fontSize:25 fontColor:[UIColor whiteColor] frame:CGRectMake(0, profileView.frame.origin.y - 60 - gap, 320, 28) numberOfLines:1 alignText:NSTextAlignmentCenter];
    fromLabel.font = [UIFont boldSystemFontOfSize:25];
#ifdef BearTalk
    fromLabel.frame = CGRectMake(16, CGRectGetMaxY(profileView.frame)+12, fullIncomingView.frame.size.width - 32, 27);
    fromLabel.font = [UIFont boldSystemFontOfSize:23];
#endif
    [fullIncomingView addSubview:fromLabel];
    
#ifdef BearTalk
    
    
    UILabel *positionLabel;
    UIScrollView *positionScrollView;
    
    
    positionScrollView = [[UIScrollView alloc]init];
    positionScrollView.frame = CGRectMake(fromLabel.frame.origin.x,CGRectGetMaxY(fromLabel.frame)+6,fromLabel.frame.size.width,120);
    [fullIncomingView addSubview:positionScrollView];
    
    positionLabel = [[UILabel alloc]init];
    [positionLabel setBackgroundColor:[UIColor clearColor]];
    positionLabel.textAlignment = NSTextAlignmentCenter;
    positionLabel.numberOfLines = 0;
    [positionLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [positionLabel setFont:[UIFont systemFontOfSize:14]];
    positionLabel.textColor = [UIColor whiteColor];
    [positionScrollView addSubview:positionLabel];
    
    
    
    if([dic[@"newfield4"] isKindOfClass:[NSArray class]]){
        NSString *positionstring = @"";
        
        for(NSDictionary *pdic in dic[@"newfield4"]){
            
            NSString *dcode = pdic[@"deptcode"];
            NSString *pcode = [[ResourceLoader sharedInstance] searchParentCode:dcode];
            
            if([pdic[@"position"]length]>0)
                positionstring = [positionstring stringByAppendingFormat:@" %@ |",pdic[@"position"]];
            
            if([[[ResourceLoader sharedInstance] searchCode:dcode]length]>0)
                positionstring = [positionstring stringByAppendingFormat:@" %@ |",[[ResourceLoader sharedInstance] searchCode:dcode]];
            
            if([[[ResourceLoader sharedInstance] searchCode:pcode]length]>0)
                positionstring = [positionstring stringByAppendingFormat:@" %@ |",[[ResourceLoader sharedInstance] searchCode:pcode]];
            
            if([positionstring hasSuffix:@"|"]){
                positionstring = [positionstring substringWithRange:NSMakeRange(0,[positionstring length]-1)];
            }
            
            positionstring = [positionstring stringByAppendingString:@"\n"];
            
            
            
        }
        
        if([positionstring hasSuffix:@"\n"]){
            positionstring = [positionstring substringWithRange:NSMakeRange(0,[positionstring length]-2)];
        }
        
        NSLog(@"positionstring %@",positionstring);
        positionLabel.text = positionstring;
    }
    else{
        NSString *pcode = [[ResourceLoader sharedInstance] searchParentCode:dic[@"deptcode"]];
        
        NSString *positionstring = @"";
        if([dic[@"grade2"]length]>0)
            positionstring = [positionstring stringByAppendingFormat:@" %@ |",dic[@"grade2"]];
        
        if([dic[@"team"]length]>0)
            positionstring = [positionstring stringByAppendingFormat:@" %@ |",dic[@"team"]];
        
        if([[[ResourceLoader sharedInstance] searchCode:pcode]length]>0)
            positionstring = [positionstring stringByAppendingFormat:@" %@ |",[[ResourceLoader sharedInstance] searchCode:pcode]];
        
        if([positionstring hasSuffix:@"|"]){
            positionstring = [positionstring substringWithRange:NSMakeRange(0,[positionstring length]-1)];
        }
        NSLog(@"positionstring %@",positionstring);
        positionLabel.text = positionstring;
        
        
        
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:positionLabel.font, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [positionLabel.text boundingRectWithSize:CGSizeMake(positionLabel.frame.size.width, 200) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
 //   CGSize size = [positionLabel.text sizeWithFont:positionLabel.font constrainedToSize:CGSizeMake(positionLabel.frame.size.width, 200) lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"position size %@",NSStringFromCGSize(size));
    
    positionLabel.frame = CGRectMake(0, 0, positionScrollView.frame.size.width, size.height);
    positionScrollView.contentSize = CGSizeMake(positionScrollView.frame.size.width,size.height+5);
    
    UILabel *lblInfo = [[UILabel alloc]init];
    lblInfo.frame = CGRectMake(16,[SharedFunctions scaleFromHeight:64],coverImageView.frame.size.width-32,profileView.frame.origin.y - [SharedFunctions scaleFromHeight:64]);
    lblInfo.textColor = [UIColor whiteColor];
    lblInfo.font = [UIFont boldSystemFontOfSize:23];
    lblInfo.textAlignment = NSTextAlignmentCenter;
    lblInfo.numberOfLines = 2;
    [fullIncomingView addSubview:lblInfo];

    lblInfo.text = dic[@"newfield1"];
    NSLog(@"lblinfo %@",lblInfo.text);
    NSLog(@"positionScrollView %@",NSStringFromCGRect(positionScrollView.frame));
    NSLog(@"positionLabel %@",NSStringFromCGRect(positionLabel.frame));
#else
    
    UILabel *positionLabel;
    positionLabel = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%@ | %@",dic[@"grade2"]==nil?@"":dic[@"grade2"],dic[@"team"]==nil?@"":dic[@"team"]] fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(0, fromLabel.frame.origin.y + fromLabel.frame.size.height + 5, 320, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    [fullIncomingView addSubview:positionLabel];
    
    
    if(dic[@"grade2"] == nil && dic[@"team"] == nil)
        positionLabel.text = @"";
#endif
    
#ifdef BearTalk
    
    
    cancel = [CustomUIKit buttonWithTitle:@"" fontSize:0 fontColor:RGB(255,255,255) target:self selector:@selector(cancelFullIncoming)
                                    frame:CGRectMake([SharedFunctions scaleFromWidth:22.5], fullIncomingView.frame.size.height - 100 +27, [SharedFunctions scaleFromWidth:160], 46)
                         imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [fullIncomingView addSubview:cancel];
    cancel.backgroundColor = RGB(255, 59, 48);
    cancel.clipsToBounds = YES;
    cancel.layer.cornerRadius = 23;
    
    
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"btn_call_reject.png" withFrame:CGRectMake(cancel.frame.size.width/2 - 35/2, cancel.frame.size.height/2 - 33/2, 35, 33)];
    [cancel addSubview:imageView];
    
    
    answer = [CustomUIKit buttonWithTitle:@"" fontSize:0 fontColor:RGB(255,255,255) target:self selector:@selector(answerFullIncoming)
                                    frame:CGRectMake([SharedFunctions scaleFromWidth:22.5+160+10], cancel.frame.origin.y, cancel.frame.size.width, cancel.frame.size.height)
                         imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [fullIncomingView addSubview:answer];
    answer.backgroundColor = RGB(75, 217, 100);
    answer.clipsToBounds = YES;
    answer.layer.cornerRadius = 23;
    
    
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"btn_call_recieve.png" withFrame:CGRectMake(answer.frame.size.width/2 - 35/2, answer.frame.size.height/2 - 33/2, 35, 33)];
    [answer addSubview:imageView];
    
    label = [CustomUIKit labelWithText:@"수신 전화" fontSize:25 fontColor:RGB(31, 192, 214) frame:CGRectMake(16, CGRectGetMaxY(coverImageView.frame)+[SharedFunctions scaleFromHeight:30], fullIncomingView.frame.size.width - 32 , 25) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:23];
    [fullIncomingView addSubview:label];
    
#else
    cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelFullIncoming) frame:CGRectMake(18, height-20-44-20, 137, 44) imageNamedBullet:nil imageNamedNormal:@"button_call_deny.png" imageNamedPressed:nil];
    [fullIncomingView addSubview:cancel];
    [cancel setEnabled:NO];
//    [cancel release];

    
    answer = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(answerFullIncoming) frame:CGRectMake(cancel.frame.origin.x + cancel.frame.size.width + 10,  cancel.frame.origin.y, cancel.frame.size.width, cancel.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"button_call_answer.png" imageNamedPressed:nil];
    [fullIncomingView addSubview:answer];
    [answer setEnabled:NO];
//    [answer release];
    
    label = [CustomUIKit labelWithText:@"수신전화" fontSize:23 fontColor:RGB(41, 197, 185) frame:CGRectMake(0, cancel.frame.origin.y - 50, 320, 30) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.font = [UIFont boldSystemFontOfSize:23];
    [fullIncomingView addSubview:label];
#endif

    
    
    if(active){
        
        bIncoming = NO;
        [SharedAppDelegate.root startup];
    }
    else{
        
        [self mvoipIncomingWith:adic];
    }
    return fullIncomingView;
}

- (void)cancelFullIncoming{
    NSLog(@"cancelFullIncoming");
    
//    sip_ring_stop();
//    sip_ring_deinit();
    
    fullIncomingView.hidden = YES;
    
    [[VoIPSingleton sharedVoIP]callHangup:DHANGUP_REJECT];
//    [[VoIPSingleton sharedVoIP] callSpeaker:NO];
    
    [self closeAllCallView];
//    if(fullIncomingView == nil)
//        return;
//    
//    [fullIncomingView removeFromSuperview];
//    [fullIncomingView release];
//    fullIncomingView = nil;
    
    
}
- (void)answerFullIncoming{
    NSLog(@"answerFullIncoming");
    
//    sip_ring_stop();
//    sip_ring_deinit();
    
    
//    [SharedAppDelegate.root stopRingSound];
    
    [[VoIPSingleton sharedVoIP] callAccept];
//     [[VoIPSingleton sharedVoIP] callSpeaker:NO];
//    [self setCalling];
    
    [SharedAppDelegate.window addSubview:[self setFullCalling]];
    
}

#pragma mark - calling UI

//- (UIView *)setSideCalling:(NSString *)from to:(NSString *)to{//:(NSDictionary *)dic{
//    
//    if(callingView)
//        return nil;
//    
//    fromName = [[NSString alloc]initWithFormat:@"%@",from];
//    toName = [[NSString alloc]initWithFormat:@"%@",to];
//    savedNum = @"";
//    talkingTime = @"";
//    
//    callingView = [[UIImageView alloc]initWithFrame:CGRectMake(0-320, 0, 320, 173)];
//    callingView.image = [CustomUIKit customImageNamed:@"n06_rcal_bg.png"];
//    callingView.userInteractionEnabled = YES;
//    
//    UIImageView *phone = [[UIImageView alloc]initWithFrame:CGRectMake(90, 20, 22, 28)];
//    phone.image = [CustomUIKit customImageNamed:@"n06_cic.png"];
//    [callingView addSubview:phone];
//    [phone release];
//    
//    UIImageView *profile = [[UIImageView alloc]init];
//    profile.image = [CustomUIKit customImageNamed:@"n01_tl_profile.png"];
//    profile.frame = CGRectMake(20, 20, 47, 47);
//    [callingView addSubview:profile];
//    [profile release];
//    
//    
//    NSString *nameAndPosition = [[dicobjectForKey:@"name"] stringByAppendingFormat:@" %@",[dicobjectForKey:@"grade2"]];
//    NSLog(@"nameAndPostiion %@",nameAndPosition);
//    UILabel *name = [CustomUIKit labelWithText:nameAndPosition fontSize:13 fontColor:[UIColor whiteColor] frame:CGRectMake(15, 75, 300, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [callingView addSubview:name];
//    [name release];
//    
//    UILabel *label = [CustomUIKit labelWithText:@"전화거는중..." fontSize:18 fontColor:[UIColor whiteColor] frame:CGRectMake(116, 20, 100, 25) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [callingView addSubview:label];
//    [label release];
//    
//    
//    UIButton *cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelSideCalling) frame:CGRectMake(12, 160-10-46, 296, 46) imageNamedBullet:nil imageNamedNormal:@"n06_cancelbtn.png" imageNamedPressed:nil];
//    [callingView addSubview:cancel];
//    [cancel release];
//    
////    [self mvoipOutgoingWith:[NSString stringWithFormat:@"*%@",[dicobjectForKey:@"uniqueid"]]];
//    
//    return callingView;
//}
//
//
- (void)cancelSideCalling{
//
//    if(callingView == nil)
//        return;
//    
//    [UIView animateWithDuration:0.4
//                     animations:^{
//                         callingView.frame = CGRectMake(0-320, 0, 320, 173);// its final location
//                     }];
//    [callingView release];
//    callingView = nil;
}
//
//


- (UIView *)setFullCalling{//:(NSDictionary *)dic{//(NSString *)num name:(NSString *)name{
    
    NSLog(@"setFullCalling %@",savedNum);
    
    if(fullCallingView)
        return nil;    
    
    
    
    NSString *uid = @"";// = num;
    
    if([savedNum hasPrefix:@"*"]){
        uid = [savedNum substringWithRange:NSMakeRange(1,[savedNum length]-1)];
    }
    else{
        uid = savedNum;
    }
    
    if(fullIncomingView){
//        sip_ring_stop();
//        sip_ring_deinit();
        [self stopRingSound];
        
    [fullIncomingView removeFromSuperview];
//    [fullIncomingView release];
    fullIncomingView = nil;
    }
    if(fullOutgoingView){
    [fullOutgoingView removeFromSuperview];
//    [fullOutgoingView release];
    fullOutgoingView = nil;
    }

    float height = 0;
    
//    talkingTime = @"";
    
#ifdef BearTalk
    height = SharedAppDelegate.window.frame.size.height - 0;
#else
    
    if(IS_HEIGHT568)
        height = 568-20;
    else
        height = 480-20;
#endif
    
    fullCallingView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SharedAppDelegate.window.frame.size.width, height)];
#ifdef BearTalk
    fullCallingView.frame = CGRectMake(0, 0, SharedAppDelegate.window.frame.size.width, height);
#endif
    fullCallingView.userInteractionEnabled = YES;
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    UIImageView *imageView;
    
    
#ifdef BearTalk
    imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = RGB(70, 77, 83);
    imageView.frame = CGRectMake(0, 0, fullCallingView.frame.size.width, 25+25+86);
#else
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_01.png" withFrame:CGRectMake(0, 0, 320, 98)];
    
#endif

    [fullCallingView addSubview:imageView];
//    [imageView release];
    
    UIImageView *profileView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 71, 71)];
#ifdef BearTalk
    
    
    profileView.frame = CGRectMake(20, 25, 86, 86);
    [SharedAppDelegate.root getProfileImageWithURL:uid ifNil:@"call_nophoto.png" view:profileView scale:0];
    
    profileView.layer.cornerRadius = profileView.frame.size.width / 2;
    profileView.clipsToBounds = YES;
#else
    [SharedAppDelegate.root getProfileImageWithURL:uid ifNil:@"call_nophoto.png" view:profileView scale:24];
    UIImageView *coverView;
    coverView = [CustomUIKit createImageViewWithOfFiles:@"call_photocover.png" withFrame:CGRectMake(0, 0, profileView.frame.size.width, profileView.frame.size.height)];
    [profileView addSubview:coverView];
#endif
    [fullCallingView addSubview:profileView];
//    [profileView release];
    
    
    
#ifdef BearTalk
    
    imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = RGB(44, 49, 55);
    imageView.frame = CGRectMake(0, 25+86+25, fullCallingView.frame.size.width, 26);
    [fullCallingView addSubview:imageView];
    
    UIImageView *callIconView;
    UILabel *callLabel;
    
    if([self.toName length]>0){
        
        callLabel = [CustomUIKit labelWithText:@"발신전화" fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(imageView.frame.size.width - 16 - 50, imageView.frame.size.height/2 - 15/2, 50, 15) numberOfLines:1 alignText:NSTextAlignmentRight];
                                                                                                                  
        callIconView = [CustomUIKit createImageViewWithOfFiles:@"call_stic_02.png" withFrame:CGRectMake(callLabel.frame.origin.x - 16 - 5, imageView.frame.size.height/2 - 15/2, 16, 15)];
    
    }
    if([self.fromName length]>0){ // incoming
        
        callLabel = [CustomUIKit labelWithText:@"수신전화" fontSize:14 fontColor:[UIColor grayColor] frame:CGRectMake(imageView.frame.size.width - 16 - 50, imageView.frame.size.height/2 - 15/2, 50, 15) numberOfLines:1 alignText:NSTextAlignmentRight];
        
        callIconView = [CustomUIKit createImageViewWithOfFiles:@"call_stic_01.png" withFrame:CGRectMake(callLabel.frame.origin.x - 16 - 5, imageView.frame.size.height/2 - 15/2, 16, 15)];

        
    }
    
    [imageView addSubview:callIconView];
    [imageView addSubview:callLabel];
    
    imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = RGB(50, 55, 59);
    imageView.frame = CGRectMake(0, fullCallingView.frame.size.height - 100, fullCallingView.frame.size.width, 100);
    [fullCallingView addSubview:imageView];
    
    imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = RGB(30, 32, 35);
    imageView.frame = CGRectMake(0, 25+86+25+26, fullCallingView.frame.size.width, fullCallingView.frame.size.height - 100 - (25+86+25+26));
    [fullCallingView addSubview:imageView];
    
    
#else
    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_02.png" withFrame:CGRectMake(0, 98, 320, 26)];
    [fullCallingView addSubview:imageView];
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_03.png" withFrame:CGRectMake(0, 98+26, 320, 500)];
        [fullCallingView addSubview:imageView];

    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"call_bg_04.png" withFrame:CGRectMake(0, height-85, 320, 85)];
    [fullCallingView addSubview:imageView];
    
    
    
    UIButton *speaker;
    speaker = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(speakerLargeOnOff:) frame:CGRectMake(103, height/2-55, 113, 113) imageNamedBullet:nil imageNamedNormal:@"speaker_on.png" imageNamedPressed:nil];
    [fullCallingView addSubview:speaker];
    
    
    dialView = [[UIView alloc]init];
    dialView.frame = CGRectMake(0, 98+26, 320, height-(90+26)-85);
    [fullCallingView addSubview:dialView];
    dialView.hidden = YES;
    
    
    [SharedAppDelegate.root.dialer settingDialScreenWithHeight:dialView.frame.size.height dialer:NO view:dialView];
    
    [SharedAppDelegate.root.dialer settingDialerWithHeight:dialView.frame.size.height dialer:NO view:dialView];
    
#endif
    
    
    
    UILabel *label;
    label = [CustomUIKit labelWithText:@"" fontSize:19 fontColor:[UIColor whiteColor] frame:CGRectMake(100, 20, 200, 22) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [fullCallingView addSubview:label];
    
    if([self.toName length]>0)
        label.text = self.toName;
    if([self.fromName length]>0)
        label.text = self.fromName;
    NSLog(@"label.text %@",label.text);
    
    
    
#ifdef BearTalk
    label.frame = CGRectMake(CGRectGetMaxX(profileView.frame)+12, 25+20, 150, 23);
    label.font = [UIFont boldSystemFontOfSize:23];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [label.text boundingRectWithSize:CGSizeMake(110, 23) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
 //   CGSize size = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(110, 23) lineBreakMode:NSLineBreakByCharWrapping];
    label.frame = CGRectMake(CGRectGetMaxX(profileView.frame)+12, 25+17, size.width, 23);
    UILabel *sublabel;
    sublabel = [CustomUIKit labelWithText:@"무료 통화" fontSize:15 fontColor:[UIColor whiteColor] frame:CGRectMake(label.frame.origin.x + size.width + 8, label.frame.origin.y+8, 80, 15) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [fullCallingView addSubview:sublabel];
    
    
#endif
    
    
//    [label release];
    
    
//    time = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(100, 48, 200, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [fullCallingView addSubview:time];
//	[time retain];
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(100, 48, 200, 17)];
    [time setFont:[UIFont boldSystemFontOfSize:14]];
    [time setTextColor:[UIColor whiteColor]];
    [time setTextAlignment:NSTextAlignmentLeft];
    [time setBackgroundColor:[UIColor clearColor]];
    [fullCallingView addSubview:time];
    
//    qual = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(100, 65, 217, 17) numberOfLines:1 alignText:NSTextAlignmentLeft];
//    [qual retain];
    
    qual = [[UILabel alloc] initWithFrame:CGRectMake(100, 65, 217, 17)];
    [qual setFont:[UIFont boldSystemFontOfSize:14]];
    [qual setTextColor:[UIColor whiteColor]];
    [qual setTextAlignment:NSTextAlignmentLeft];
    [qual setBackgroundColor:[UIColor clearColor]];
    [fullCallingView addSubview:qual];
    
#ifdef BearTalk
    time.font = [UIFont systemFontOfSize:21];
    time.frame = CGRectMake(CGRectGetMaxX(profileView.frame)+12, 25+20+23+7, 65, 21);
    [qual setFont:[UIFont systemFontOfSize:14]];
    qual.frame = CGRectMake(CGRectGetMaxX(time.frame), time.frame.origin.y + 5, 120, 14);
    
#endif
    
    
#ifdef LempMobileNowon
    cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelFullCalling) frame:CGRectMake(27, height-20-44, 124, 43) imageNamedBullet:nil imageNamedNormal:@"button_call_deny.png" imageNamedPressed:nil];
    [fullCallingView addSubview:cancel];
    
    dial = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(showDial:) frame:CGRectMake(cancel.frame.origin.x + cancel.frame.size.width + 15,  cancel.frame.origin.y, cancel.frame.size.width, cancel.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"button_calling_showdial.png" imageNamedPressed:nil];
    dial.selected = NO;
    dial.adjustsImageWhenHighlighted = NO;
    [fullCallingView addSubview:dial];
    
#elif BearTalk
    
    cancel = [CustomUIKit buttonWithTitle:@"" fontSize:0 fontColor:RGB(255,255,255) target:self selector:@selector(cancelFullCalling)
                                    frame:CGRectMake(fullCallingView.frame.size.width/2 - 160/2, fullCallingView.frame.size.height - 100+27, 160, 46)
                         imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [fullCallingView addSubview:cancel];
    cancel.backgroundColor = RGB(255, 59, 48);
    cancel.clipsToBounds = YES;
    cancel.layer.cornerRadius = 23;
    
    
    imageView = [CustomUIKit createImageViewWithOfFiles:@"btn_call_reject.png" withFrame:CGRectMake(cancel.frame.size.width/2 - 35/2, cancel.frame.size.height/2 - 33/2, 35, 33)];
    [cancel addSubview:imageView];
    
    
#else
    
    cancel = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancelFullCalling) frame:CGRectMake(24, height-20-44, 272, 44) imageNamedBullet:nil imageNamedNormal:@"call_endbtn.png" imageNamedPressed:nil];
    [fullCallingView addSubview:cancel];
#endif
    
    if (_timerQual == nil)
    {
        _timerQual = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(qualTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    
    if (_timerCall == nil)
    {
        _timerCall = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                      target:self
                                                    selector:@selector(callTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    

    return fullCallingView;
}
//
//
- (void)speakerOnOff:(id)sender{
    [self performSelectorOnMainThread:@selector(changeImage:) withObject:sender waitUntilDone:NO];
    
    bSpeakerOn = !bSpeakerOn;
    NSLog(@"bspeakeron %@",bSpeakerOn?@"YES":@"NO");
    [[VoIPSingleton sharedVoIP] callSpeaker:bSpeakerOn];
}

- (void)speakerLargeOnOff:(id)sender{
    [self performSelectorOnMainThread:@selector(changeLargeImage:) withObject:sender waitUntilDone:NO];
    
    bSpeakerOn = !bSpeakerOn;
    NSLog(@"bspeakeron %@",bSpeakerOn?@"YES":@"NO");
    [[VoIPSingleton sharedVoIP] callSpeaker:bSpeakerOn];
}

- (void)changeLargeImage:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSString *btnImage;
    
    
    if(button.selected == YES)
    {
        btnImage = [NSString stringWithFormat:@"speaker_on.png"];
        button.selected = NO;
    }
    else
    {
        btnImage = [NSString stringWithFormat:@"speaker_off.png"];
        button.selected = YES;
    }
    
    
    
    [button setBackgroundImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
}
- (void)changeImage:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSString *btnImage;
    
    
    if(button.selected == YES)
    {
        btnImage = [NSString stringWithFormat:@"button_call_speaker_on.png"];
        button.selected = NO;
    }
    else
    {
        btnImage = [NSString stringWithFormat:@"button_call_speaker_off.png"];
        button.selected = YES;
    }
    
    
    
    [button setBackgroundImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
}

- (void)callTimer:(NSTimer*)timer
{
    
#ifdef BearTalk
#else
    int hour = 0;
#endif
    int minute = (int)(NSInteger)[[VoIPSingleton sharedVoIP] callQueryCallTime]/60;
    int second = (int)(NSInteger)[[VoIPSingleton sharedVoIP] callQueryCallTime]%60;
    if(minute > 60)
    {
        
#ifdef BearTalk
#else
        hour = minute/60;
#endif
        minute = minute%60;
        
    }
#ifdef BearTalk
    
    time.text = [NSString stringWithFormat:@"%02d:%02d",minute,second];
#else
    NSString* szByte = [NSString stringWithFormat:@"%d KB",(int) (NSInteger)((float)[[VoIPSingleton sharedVoIP] callQueryNetworkByte])/1024];
	time.text = [NSString stringWithFormat:@"%02d:%02d:%02d / %@",hour,minute,second,szByte];
#endif
}

- (void)qualTimer:(NSTimer *)timer
{

    
    NSString *quality;
#ifdef BearTalk
    
    NSString* szByte = [NSString stringWithFormat:@"%d KB",(int) (NSInteger)((float)[[VoIPSingleton sharedVoIP] callQueryNetworkByte])/1024];
    quality = [NSString stringWithFormat:@"/ %@ (%d%%)",szByte,(int)(NSInteger)[[VoIPSingleton sharedVoIP] callQueryNetworkQuality]];
       qual.text = quality;
#else
    
    quality = [NSString stringWithFormat:@"%d%%",(int)(NSInteger)[[VoIPSingleton sharedVoIP] callQueryNetworkQuality]];
    qual.text = quality;
#endif
    
    if((int)(NSInteger)[[VoIPSingleton sharedVoIP] callQueryNetworkQuality] < 80)
        qual.text = [quality stringByAppendingString:@" 네트워크 환경이 좋지 않습니다."];
    
    NSLog(@"qual %@",qual.text);
}


- (void)cancelFullCalling{
    NSLog(@"cancelFullCalling");

//    if(talkingTime){
//        [talkingTime release];
//        talkingTime = nil;
//    }
//    talkingTime = [[NSString alloc]initWithFormat:@"%@",time.text];
    fullCallingView.hidden = YES;
    
    [[VoIPSingleton sharedVoIP] callHangup:0];

//    if(fullCallingView == nil)
//        return;
//    
//    [fullCallingView removeFromSuperview];
//    [fullCallingView release];
//    fullCallingView = nil;
//    
    [self closeAllCallView];
//
    if (_timerQual)
    {
        [_timerQual invalidate];
        _timerQual = nil;
    }
    
    if (_timerCall)
    {
        [_timerCall invalidate];
        _timerCall = nil;
    }
    
}



- (void)playRingSound {
    
    NSLog(@"playRingSound");//
    //    NSLog(@"playRingSound %@",isPlaying?@"YES":@"NO");
    //    if(isPlaying)
    //        return;
    //
    //    isPlaying = YES;
    NSString *bell = [SharedAppDelegate readPlist:@"bell"];
    if ([bell length] < 1) {
        bell = @"1.wav";
        [SharedAppDelegate writeToPlist:@"bell" value:bell];
    }
    NSString *sndPath = [[NSBundle mainBundle]pathForResource:bell ofType:nil inDirectory:NO];
      NSURL *aFileURL = [NSURL fileURLWithPath:sndPath isDirectory:NO];
 //   CFURLRef sndURL = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:sndPath]);
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)aFileURL, &ringSound);
    
    
    //    sip_ring_start();
    AudioServicesPlaySystemSound(ringSound);
    sip_ring_init();
    
}

- (void)stopRingSound{
    
    NSLog(@"stopRingSound");// %@",isPlaying?@"YES":@"NO");
    //    if(!isPlaying)
    //        return;
    //
    //    isPlaying = NO;
    
    AudioServicesDisposeSystemSoundID(ringSound);
    
    sip_ring_stop();
    sip_ring_deinit();
    // AudioServicesDisposeSystemSoundID
}


@end
