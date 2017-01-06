//
//  BonManager.m
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 28..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import "BonManager.h"
#import "ChatViewC.h"
#import "bon_mobile.h"



void callback_func(char event, int msg_type, char *uid, char *nickname, char *rk, char *lastidx, char *msg);

void start_callback(void *obj);
void typing_event(void *obj);
void join_event(void *obj);
void leave_event(void *obj);




@implementation BonManager

+ (BonManager *)sharedBon{
    static BonManager *sharedInstance = nil;
    
    if(sharedInstance == nil){
        @synchronized(self){
            if(sharedInstance == nil){
                sharedInstance = [[BonManager alloc]init];
            }
        }
    }
    
    return sharedInstance;
}

- (void)bonStart{
//    NSLog(@"bonStart");// alreadyBon %@",alreadyBon?@"YES":@"NO");
//    int r = bon_get_status();
//    NSLog(@"bon_status %d",r);
//    if(alreadyBon == YES)
//        return;
//    else{
//    if(bonThread)
//    {
//        [bonThread release];
//        bonThread = nil;
//    }
//    bonThread = [[NSThread alloc]initWithTarget:self selector:@selector(_th_bon) object:nil];
//    [bonThread start];
//    alreadyBon = YES;
//    }
}
- (void)_th_bon{
//    	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
//    start_callback(SharedAppDelegate.root.chatView);
//    [pool release];
}

- (void)bonJoin:(int)type
{
//    NSLog(@"bonJoin %d",type);
//     int r = bon_get_status();
//    NSLog(@"bon_status %d",r);
//    
//    if(r == BON_STATUS_IN_CHATROOM)
//        return;
//    
//    if(r < BON_STATUS_READY)
//    {
//        [self bonStart];
//		join_event(SharedAppDelegate.root.chatView);
//    }
//    else if(type != 4 && type != 2)
//		join_event(SharedAppDelegate.root.chatView);

}
- (void)bonTyping:(int)type
{
//    NSLog(@"bonTyping %d",type);
//    int r = bon_get_status();
//    NSLog(@"bon_status %d",r);
//    
//    if(type != 4 && type != 2 && r != BON_STATUS_IN_CHATROOM)
//        [self bonJoin:type];
//    
//    typing_event(SharedAppDelegate.root.chatView);
//	
}
- (void)bonLeave
{
//    NSLog(@"bonLeave");
//    int r = bon_get_status();
//    NSLog(@"bon_status %d",r);
//    leave_event(SharedAppDelegate.root.chatView);
//	
}
- (void)bonStop{
//    NSLog(@"bonStop");
//    int r = bon_get_status();
//    NSLog(@"bon_status %d",r);
//    alreadyBon = NO;
//    bon_stop();
    
}
@end



//ChatViewC *objCVC = NULL;
////id objCVC = NULL;
//
//void leave_event(void *obj)
//{
//    //		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
//    objCVC = obj;
//    
////    id AppID = [[UIApplication sharedApplication]delegate];
//    //    NSLog(@"___________________ leave_event %@ %@___________________",[[AppID readPlistDic]objectForKey:@"uniqueid"],objCVC.roomKey);
//    
//    
//    char uid[32];
//    char rk[32];
//    
//    
//    memset(uid, '\0', 32);
//    memset(rk, '\0', 32);
//    
//    
//    
//    @try {
//        if([SharedAppDelegate readPlist:@"myinfo"][@"uid"] == nil) sprintf(uid, "");
//        else sprintf(uid, "%s", [[SharedAppDelegate readPlist:@"myinfo"][@"uid"] UTF8String]);
//    }
//    @catch (NSException * e) {
//        sprintf(uid,"_exp");
//    }
//    
//    @try {
//        if(objCVC.roomKey == nil) sprintf(rk, "");
//        else sprintf(rk, "%s", [objCVC.roomKey UTF8String]);
//    }
//    @catch (NSException * e) {
//        sprintf(rk,"_exp");
//    }
//    
//    int r = bon_send_event(BON_EVENT_LEAVE_ROOM, uid, rk);
//    [objCVC checkEvent:r];
//    
//    NSLog(@"___________________ BON_LEAVE return %d___________________",r);
//    //		[pool release];
//}
//
//void join_event(void *obj)
//{
//    
//    //		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
//    objCVC = obj;
//    
////    id AppID = [[UIApplication sharedApplication]delegate];
//        NSLog(@"___________________ join_event %@___________________",objCVC.roomKey);
//    
//    
//    char uid[32];
//    char rk[32];
//    
//    
//    memset(uid, '\0', 32);
//    memset(rk, '\0', 32);
//    
//    
//    
//    @try {
//        if([SharedAppDelegate readPlist:@"myinfo"][@"uid"] == nil) sprintf(uid, "");
//        else sprintf(uid, "%s", [[SharedAppDelegate readPlist:@"myinfo"][@"uid"] UTF8String]);
//    }
//    @catch (NSException * e) {
//        sprintf(uid,"_exp");
//    }
//    
//    @try {
//        if(objCVC.roomKey == nil) sprintf(rk, "");
//        else sprintf(rk, "%s", [objCVC.roomKey UTF8String]);
//        int r = bon_send_event(BON_EVENT_JOIN_ROOM, uid, rk);
//        [objCVC checkEvent:r];
//    }
//    @catch (NSException * e) {
//        sprintf(rk,"_exp");
//    }
//    
//    
//    
//    //		NSLog(@"___________________ BON_JOIN RETURN %d___________________",r);
//    //		[pool release];
//}
//
//
//void typing_event(void *obj)
//{
//    //		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
//    objCVC = obj;
//    
////    id AppID = [[UIApplication sharedApplication]delegate];
//    //    NSLog(@"___________________ typing_event %@ %@___________________",[[AppID readPlistDic]objectForKey:@"uniqueid"],objCVC.roomKey);
//    
//    
//    
//    char uid[32];
//    char rk[32];
//    
//    
//    memset(uid, '\0', 32);
//    memset(rk, '\0', 32);
//    
//    
//    
//    @try {
//        if([SharedAppDelegate readPlist:@"myinfo"][@"uid"] == nil) sprintf(uid, "");
//        else sprintf(uid, "%s", [[SharedAppDelegate readPlist:@"myinfo"][@"uid"] UTF8String]);
//    }
//    @catch (NSException * e) {
//        sprintf(uid,"_exp");
//    }
//    
//    @try {
//        if(objCVC.roomKey == nil) sprintf(rk, "");
//        else sprintf(rk, "%s", [objCVC.roomKey UTF8String]);
//    }
//    @catch (NSException * e) {
//        sprintf(rk,"_exp");
//    }
//    
//    int r = bon_send_event(BON_EVENT_TYPING, uid, rk);
//    [objCVC checkEvent:r];
//    
//    //		NSLog(@"___________________ BON_TYPING return %d ___________________",r);
//    //		[pool release];
//}
//
//
//void start_callback(void *obj)
//{
//    
//    //		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
//    objCVC = obj;
//    
////    id AppID = [[UIApplication sharedApplication]delegate];
//    //    NSLog(@"___________________ START_CALLBACK %@___________________",[[AppID readPlistDic]objectForKey:@"uniqueid"]);
//    
//    
//    
//    char uid[32];
//    char ip[32];
//    char was[32];
//    char session[32];
//    int port = 0;
//    char mode;
//    char enc;// = 1;
//    int a = 1;
//    
//    
//    memset(uid, '\0', 32);
//    memset(ip, '\0', 32);
//    memset(session, '\0', 32);
//    memset(was, '\0', 32);
//    
//    
//    
//    @try {
//        if([SharedAppDelegate readPlist:@"myinfo"][@"uid"] == nil) sprintf(uid, "");
//        else sprintf(uid, "%s", [[SharedAppDelegate readPlist:@"myinfo"][@"uid"] UTF8String]);
//    }
//    @catch (NSException * e) {
//        sprintf(uid,"_exp");
//    }
//    
//    
//    @try {
//        if([SharedAppDelegate readPlist:@"skey"] == nil) sprintf(session, "");
//        else sprintf(session, "%s", [[SharedAppDelegate readPlist:@"skey"] UTF8String]);
//    }
//    @catch (NSException * e) {
//        sprintf(session,"_exp");
//    }
//    
//    //    NSLog(@"bonServer %@",[AppID readServerPlist:@"bon"]);
//    
//    @try {
//        if([SharedAppDelegate readPlist:@"bon"] == nil) sprintf(ip, "");
//        else sprintf(ip, "%s", [[SharedAppDelegate readPlist:@"bon"] UTF8String]);
//    }
//    @catch (NSException * e) {
//        sprintf(ip,"_exp");
//    }
//    
//    @try {
//        if([SharedAppDelegate readPlist:@"was"] == nil) sprintf(was, "");
//        else sprintf(was, "%s", [[SharedAppDelegate readPlist:@"was"] UTF8String]);
//    }
//    @catch (NSException * e) {
//        sprintf(was,"_exp");
//    }
//    
//    
//    //		sprintf(ip,"%s","61.74.230.249");
//    enc = (char)a;
//    
//    
//    if([SharedAppDelegate.root isCellNetwork] == YES)
//    {
//        a = 1;
//        mode = (char)a;
//    }
//    else
//    {
//        a = 0;
//        mode = (char)a;
//    }
//    
//    
//    port = 62232;
//    
//    
//    //int r = 0;
//    int r = bon_start(ip, port, uid, session, mode, was, enc, callback_func);
//    
//    [objCVC checkEvent:r];
//    //		NSLog(@"___________________ BON_START RESULT %d ___________________",r);
//    
//    
//    //		[pool release];
//}
//
//
//
//
//void callback_func(char event, int msg_type, char *uid, char *nickname, char *rk, char *lastidx, char *msg)
//{
//    //    NSLog(@"___________________ CALLBACK_FUNC ___________________");
//    bonParam *bParam = [[bonParam alloc]init];
//    
//    bParam.event = event;
//    
//    bParam.msg_type = msg_type;
//    
//    
//    bParam.rk = [[NSString alloc]initWithFormat:@"%s",rk];
//    
//    
//    bParam.nick = [[NSString alloc]initWithUTF8String:nickname];
//    
//    
//    bParam.msg = [[NSString alloc]initWithUTF8String:msg]; // 한글이 들어가니까.
//    
//    
//    bParam.uid = [[NSString alloc]initWithFormat:@"%s",uid];
//    
//    
//    bParam.lastidx = [[NSString alloc]initWithFormat:@"%s",lastidx];
//    
//    [objCVC performSelectorOnMainThread:@selector(resultBonEvent:) withObject:bParam waitUntilDone:NO];
//    
//    
//    [bParam release];
//    
//    
//    //		[cvc release];
//}
