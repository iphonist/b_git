//
//  ProfileView.m
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 1. 31..
//  Copyright 2012 Benchbee. All rights reserved.
//

#import "ProfileView.h"
#import "PhotoViewController.h"
#import "SendNoteViewController.h"
#import "SubSetupViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
@implementation ProfileView

@synthesize uniqueid;
@synthesize userlevel;



#define kNotFavorite 1
#define kFavorite 2
#define kInvite 4


#define kPhoto 100
#define kOffice 200
#define kCell 300
#define kEmail 400
#define kMvoipOffice 500
#define kMvoipUid 600
#define kCover 700
#define kChat 800

#ifdef Batong
- (id)init{
    self = [super init];
    if (self) {
        
        viewHeight = 0;
        
        backgroundView = [[UIImageView alloc]init];
        backgroundView.userInteractionEnabled = YES;
        
        backgroundView.image = [[UIImage imageNamed:@"imageview_mysocial.png"] stretchableImageWithLeftCapWidth:40 topCapHeight:40];
        backgroundView.frame = CGRectMake((320 - 260)/2,(self.view.frame.size.height - viewHeight)/2,260,viewHeight);
        [self.view addSubview:backgroundView];
        
        
        UILabel *label;
        
        
        
        midView = [[UIImageView alloc]init];
        midView.frame = CGRectMake(0, 0, backgroundView.frame.size.width, 0);
//        midView.image = [[UIImage imageNamed:@"imageview_scheduletab.png"] stretchableImageWithLeftCapWidth:151 topCapHeight:14];
        //        midView.backgroundColor = [UIColor whiteColor];
        [backgroundView addSubview:midView];
        midView.userInteractionEnabled = YES;
//        [midView release];
        
        
        UIButton *button;
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(closePopup) frame:CGRectMake(midView.frame.size.width - 31, 5, 29, 29) imageNamedBullet:nil imageNamedNormal:@"button_profilepopup_close.png" imageNamedPressed:nil];
        [midView addSubview:button];
        
        
        
        profile = [[UIImageView alloc]init];
        profile.frame = CGRectMake(midView.frame.size.width/2-65/2, 10, 65, 65);
        [midView addSubview:profile];
        profile.userInteractionEnabled = YES;
//        [profile release];
        
        
        coverProfileView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, profile.frame.size.width, profile.frame.size.height)];
        coverProfileView.userInteractionEnabled = YES;
        [profile addSubview:coverProfileView];
        coverProfileView.backgroundColor = RGBA(0,0,0,0.64);
//        [coverProfileView release];
        coverProfileView.hidden = YES;
        
        infoLabel = [[UILabel alloc]initWithFrame:coverProfileView.frame];
        infoLabel.font = [UIFont boldSystemFontOfSize:13];
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.text = @"";
        [coverProfileView addSubview:infoLabel];
//        [infoLabel release];
        
        
        UIButton *borderButton;
        borderButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(0,0,profile.frame.size.width,profile.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"imageview_profile_rounding_1.png" imageNamedPressed:nil];
        borderButton.tag = kPhoto;
        [profile addSubview:borderButton];
//        [borderButton release];
        
        
        lblName = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(profile.frame)+5, midView.frame.size.width - 20, 20)];
        lblName.font = [UIFont systemFontOfSize:15];
        lblName.textAlignment = NSTextAlignmentCenter;
        lblName.textColor = GreenTalkColor;
        lblName.backgroundColor = [UIColor clearColor];
        [midView addSubview:lblName];
//        [lblName release];
        
        
        balloonView = [[UIImageView alloc]init];
        balloonView.frame = CGRectMake(10, CGRectGetMaxY(lblName.frame)+10, lblName.frame.size.width, 20);
        balloonView.image = [[UIImage imageNamed:@""]stretchableImageWithLeftCapWidth:18 topCapHeight:8];
        [midView addSubview:balloonView];
//        [balloonView release];
        
        lblInfo = [[UILabel alloc]init];
        lblInfo.frame = CGRectMake(12, CGRectGetMaxY(lblName.frame)+10, lblName.frame.size.width, 20);
        [lblInfo setBackgroundColor:[UIColor clearColor]];
        lblInfo.font = [UIFont systemFontOfSize:12];
        lblInfo.textAlignment = NSTextAlignmentCenter;
        lblInfo.textColor = RGB(34, 72, 0);
        lblInfo.layer.borderWidth = 0.5;
        lblInfo.layer.borderColor = [UIColor grayColor].CGColor;
        lblInfo.layer.cornerRadius = 3.0; // rounding label
        lblInfo.clipsToBounds = YES;
        lblInfo.userInteractionEnabled = YES;
        lblInfo.numberOfLines = 1;
        [midView addSubview:lblInfo];
//        [lblInfo release];
        
        
        
        positionScrollView = [[UIScrollView alloc]init];
        positionScrollView.frame = CGRectMake(lblName.frame.origin.x,CGRectGetMaxY(lblInfo.frame)+7,lblName.frame.size.width,17);
        [midView addSubview:positionScrollView];
        
        lblPosition = [[UILabel alloc]init];
        [lblPosition setBackgroundColor:[UIColor clearColor]];
        lblPosition.textColor = [UIColor grayColor];
        [lblPosition setFont:[UIFont systemFontOfSize:12]];
        lblPosition.textAlignment = NSTextAlignmentCenter;
        lblPosition.numberOfLines = 0;
        [lblPosition setLineBreakMode:NSLineBreakByCharWrapping];
        [positionScrollView addSubview:lblPosition];
//        [lblPosition release];
        
        
        chatButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(manToMan) frame:CGRectMake(10, CGRectGetMaxY(positionScrollView.frame)+10, positionScrollView.frame.size.width, 25) imageNamedBullet:nil imageNamedNormal:@"button_profilepopup_call_green.png" imageNamedPressed:nil];
        [chatButton setBackgroundImage:[[UIImage imageNamed:@"button_profilepopup_call_green.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:12] forState:UIControlStateNormal];
        chatButton.backgroundColor = [UIColor clearColor];
        [midView addSubview:chatButton];
        
        chatLabel = [[UILabel alloc]init];
        chatLabel.frame = CGRectMake(0, 0, chatButton.frame.size.width, chatButton.frame.size.height);
        chatLabel.text = NSLocalizedString(@"chat", @"chat");
        chatLabel.textColor = [UIColor whiteColor];
        chatLabel.textAlignment = NSTextAlignmentCenter;
        chatLabel.font = [UIFont systemFontOfSize:14];
        [chatButton addSubview:chatLabel];
//        [chatLabel release];
        
        
        inviteButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(invite:) frame:chatButton.frame imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [inviteButton setBackgroundImage:[[UIImage imageNamed:@"attend_btn.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:15] forState:UIControlStateNormal];
        inviteButton.tag = kInvite;
        inviteButton.hidden = YES;
        
        inviteButton.backgroundColor = [UIColor clearColor];
        [midView addSubview:inviteButton];
        
        label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, inviteButton.frame.size.width, inviteButton.frame.size.height);
        label.text = @"설치요청";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [inviteButton addSubview:label];
//        [label release];
        
        
        bound = [[UIImageView alloc]init];//WithImage:[UIImage imageNamed:@"balon_grayline_deep.png"]];
        bound.frame = CGRectMake(chatButton.frame.origin.x,CGRectGetMaxY(chatButton.frame)+10, midView.frame.size.width-20,1);
        [midView addSubview:bound];
        bound.backgroundColor = [UIColor lightGrayColor];
//                [bound release];
        
        NSLog(@"bound %@",bound);
        NSLog(@"backgroundView %@",backgroundView);
        NSLog(@"midView %@",midView);
        midView.frame = CGRectMake(0, 0, backgroundView.frame.size.width, CGRectGetMaxY(bound.frame));
        
        
        
        bottomView = [[UIImageView alloc]init];
        [backgroundView addSubview:bottomView];
        bottomView.frame = CGRectMake(0, CGRectGetMaxY(midView.frame),midView.frame.size.width, 0);
//        bottomView.image = [[UIImage imageNamed:@"imageview_schedulebody.png"] stretchableImageWithLeftCapWidth:151 topCapHeight:37];
//        [bottomView release];
        bottomView.userInteractionEnabled = YES;
        
        
        
        phoneButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(10, 10, bottomView.frame.size.width - 20, 30) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        [phoneButton setBackgroundImage: [[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8] forState:UIControlStateNormal];
        phoneButton.tag = kCell;
        phoneButton.backgroundColor = [UIColor clearColor];
        [bottomView addSubview:phoneButton];
        
        
        UIImageView *phoneImage;
        
        phoneImage = [[UIImageView alloc]init];
        [phoneButton addSubview:phoneImage];
        phoneImage.frame = CGRectMake(5, 6, 17, 17);
        phoneImage.image = [UIImage imageNamed:@"imageview_icon_phone.png"];
//        [phoneImage release];
        phoneImage.userInteractionEnabled = YES;
        
        
        lblPhone = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneImage.frame)+10, phoneImage.frame.origin.y, phoneButton.frame.size.width - CGRectGetMaxX(phoneImage.frame) - 10 - 10, 20)];
        lblPhone.font = [UIFont systemFontOfSize:11];
        lblPhone.textColor = [UIColor grayColor];
        lblPhone.backgroundColor = [UIColor clearColor];
        [phoneButton addSubview:lblPhone];
//        [lblPhone release];
        
        
        emailButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(phoneButton.frame.origin.x, CGRectGetMaxY(phoneButton.frame)+10, phoneButton.frame.size.width, phoneButton.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        [emailButton setBackgroundImage: [[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:8] forState:UIControlStateNormal];
        emailButton.tag = kEmail;
        emailButton.backgroundColor = [UIColor clearColor];
        [bottomView addSubview:emailButton];
        
        
        
        
        
        UIImageView *emailImage;
        
        emailImage = [[UIImageView alloc]init];
        [emailButton addSubview:emailImage];
        emailImage.frame = phoneImage.frame;
        emailImage.image = [UIImage imageNamed:@"imageview_icon_email.png"];
//        [emailImage release];
        emailImage.userInteractionEnabled = YES;
        
        
        lblEmail = [[UILabel alloc]initWithFrame:lblPhone.frame];
        lblEmail.font = [UIFont systemFontOfSize:11];
        lblEmail.textColor = [UIColor grayColor];
        lblEmail.backgroundColor = [UIColor clearColor];
        [emailButton addSubview:lblEmail];
//        [lblEmail release];
        
        
        
        
        bottomView.frame = CGRectMake(0, CGRectGetMaxY(emailButton.frame),midView.frame.size.width, CGRectGetMaxY(emailButton.frame)+10);
        
    }
    return self;
    
}
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
- (id)init{
    
    self = [super init];
    if (self) {
        
//        UIView *backgroundView;
        backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake((320 - 260)/2,(self.view.frame.size.height - 230)/2,260,230)];
        //        backgroundView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:backgroundView];
        backgroundView.userInteractionEnabled = YES;
        
        UIImageView *topView = [[UIImageView alloc]init];
        topView.frame = CGRectMake(0, 0, backgroundView.frame.size.width, 45);
        topView.image = [[UIImage imageNamed:@"imageview_profilepopup_top.png"] stretchableImageWithLeftCapWidth:26 topCapHeight:16];
        [backgroundView addSubview:topView];
//        [topView release];
        
        UILabel *label;
        
        titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(10, 5, topView.frame.size.width-16, topView.frame.size.height-10);
        titleLabel.textColor = [UIColor whiteColor];
        [topView addSubview:titleLabel];
        titleLabel.shadowOffset = CGSizeMake(1, 1);
        titleLabel.shadowColor = [UIColor grayColor];
//        [titleLabel release];
        
        topView.userInteractionEnabled = YES;
        UIButton *button;
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(closePopup) frame:CGRectMake(topView.frame.size.width - 41, (45-41)/2, 41, 41) imageNamedBullet:nil imageNamedNormal:@"button_profilepopup_close.png" imageNamedPressed:nil];
        [topView addSubview:button];
        
        
        
//        UIImageView *midView;
        midView = [[UIImageView alloc]init];
        midView.frame = CGRectMake(0, topView.frame.size.height, backgroundView.frame.size.width, backgroundView.frame.size.height - topView.frame.size.height);
        //        midView.image = [[UIImage imageNamed:@"imageview_profilepopup_bottom.png"] stretchableImageWithLeftCapWidth:26 topCapHeight:37];
        midView.backgroundColor = [UIColor whiteColor];
        [backgroundView addSubview:midView];
//        [midView release];
        midView.userInteractionEnabled = YES;
        
        
        profile = [[UIImageView alloc]init];
        profile.frame = CGRectMake(10, 10, 45, 45);
        [midView addSubview:profile];
        profile.userInteractionEnabled = YES;
//        [profile release];
        
        UIButton *borderButton;
        borderButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(0,0,profile.frame.size.width,profile.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"imageview_profilepopup_profile_rounding.png" imageNamedPressed:nil];
        borderButton.tag = kPhoto;
        [profile addSubview:borderButton];
//        [borderButton release];
        
        
        lblName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(profile.frame) + 10, 10, midView.frame.size.width - CGRectGetMaxX(profile.frame) - 20, 20)];
        lblName.font = [UIFont systemFontOfSize:17];
        lblName.textColor = GreenTalkColor;
        lblName.backgroundColor = [UIColor clearColor];
        [midView addSubview:lblName];
//        [lblName release];
        
        
        lblPosition = [[UILabel alloc]init];
        lblPosition.frame = CGRectMake(lblName.frame.origin.x, CGRectGetMaxY(lblName.frame)+10, lblName.frame.size.width, 12);
        [lblPosition setBackgroundColor:[UIColor clearColor]];
        lblPosition.textColor = [UIColor grayColor];
        [lblPosition setFont:[UIFont systemFontOfSize:12]];
        lblPosition.textAlignment = NSTextAlignmentLeft;
        lblPosition.numberOfLines = 1;
        [midView addSubview:lblPosition];
//        [lblPosition release];
        
        midView.frame = CGRectMake(0, topView.frame.size.height, backgroundView.frame.size.width, CGRectGetMaxY(profile.frame));
        
        
        bottomView = [[UIImageView alloc]init];
        bottomView.frame = CGRectMake(0, CGRectGetMaxY(midView.frame),midView.frame.size.width,backgroundView.frame.size.height-CGRectGetMaxY(midView.frame));
        [backgroundView addSubview:bottomView];
        bottomView.image = [[UIImage imageNamed:@"imageview_profilepopup_bottom.png"] stretchableImageWithLeftCapWidth:26 topCapHeight:37];
//        [bottomView release];
        bottomView.userInteractionEnabled = YES;
        
        // company
        greenBottomView = [[UIView alloc]init];
        greenBottomView.frame = CGRectMake(0, 0, bottomView.frame.size.width, bottomView.frame.size.height);
        [bottomView addSubview:greenBottomView];
        greenBottomView.userInteractionEnabled = YES;
        greenBottomView.backgroundColor = [UIColor clearColor];
//        [greenBottomView release];
        
        balloonView = [[UIImageView alloc]init];
        balloonView.frame = CGRectMake(lblPosition.frame.origin.x, 0, lblPosition.frame.size.width, 32);
        balloonView.image = [[UIImage imageNamed:@"imageview_profilepopup_balloon.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:20];
        [greenBottomView addSubview:balloonView];
//        [balloonView release];
        
        lblInfo = [[UILabel alloc]init];
        lblInfo.frame = CGRectMake(12, 3, balloonView.frame.size.width - 24, balloonView.frame.size.height - 6);
        [lblInfo setBackgroundColor:[UIColor clearColor]];
        lblInfo.textColor = RGB(34, 72, 0);
        lblInfo.font = [UIFont systemFontOfSize:12];
        lblInfo.textAlignment = NSTextAlignmentLeft;
        lblInfo.numberOfLines = 1;
        [balloonView addSubview:lblInfo];
//        [lblInfo release];
        
        
        // customer
        customerBottomView = [[UIView alloc]init];
        customerBottomView.frame = greenBottomView.frame;
        customerBottomView.backgroundColor = [UIColor clearColor];
        [bottomView addSubview:customerBottomView];
        customerBottomView.userInteractionEnabled = YES;
//        [customerBottomView release];
        
        
        
        label = [[UILabel alloc]init];
        label.frame = CGRectMake(profile.frame.origin.x, customerBottomView.frame.size.height - 50, 30, 20);
        label.text = @"주소";
        label.font = [UIFont systemFontOfSize:11];
        [customerBottomView addSubview:label];
//        [label release];
        
        
        addressLabel = [[UILabel alloc]init];
        addressLabel.frame = CGRectMake(CGRectGetMaxX(label.frame)+5, customerBottomView.frame.size.height - 50, customerBottomView.frame.size.width - CGRectGetMaxX(label.frame)-5, 20);
        addressLabel.textColor = [UIColor darkGrayColor];
        addressLabel.adjustsFontSizeToFitWidth = YES;
        addressLabel.font = [UIFont systemFontOfSize:11];
        [customerBottomView addSubview:addressLabel];
//        [addressLabel release];
        NSLog(@"addresslabel %@",NSStringFromCGRect(addressLabel.frame));
        
        
        label = [[UILabel alloc]init];
        label.frame = CGRectMake(greenPhoneLabel.frame.origin.x+10, CGRectGetMaxY(addressLabel.frame)+5, 45, 20);
        label.text = @"G포인트";
        label.font = [UIFont systemFontOfSize:11];
        [customerBottomView addSubview:label];
//        [label release];
        
        
        pointLabel = [[UILabel alloc]init];
        pointLabel.frame = CGRectMake(CGRectGetMaxX(label.frame)+5, CGRectGetMaxY(addressLabel.frame)+5, customerBottomView.frame.size.width - CGRectGetMaxX(label.frame)-5, 20);
        
        pointLabel.textColor = [UIColor darkGrayColor];
        pointLabel.font = [UIFont systemFontOfSize:11];
        [customerBottomView addSubview:pointLabel];
//        [pointLabel release];
        
        
        // common
        
        chatButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(manToMan) frame:CGRectMake(10, bottomView.frame.size.height - 85, (bottomView.frame.size.width - 30)/2, 25) imageNamedBullet:nil imageNamedNormal:@"button_profilepopup_call_green.png" imageNamedPressed:nil];
        [chatButton setBackgroundImage:[[UIImage imageNamed:@"button_profilepopup_call_green.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:12] forState:UIControlStateNormal];
        chatButton.backgroundColor = [UIColor clearColor];
        [bottomView addSubview:chatButton];
        
        chatLabel = [[UILabel alloc]init];
        chatLabel.frame = CGRectMake(0, 0, chatButton.frame.size.width, chatButton.frame.size.height);
        chatLabel.text = NSLocalizedString(@"chat", @"chat");
        chatLabel.textColor = [UIColor whiteColor];
        chatLabel.textAlignment = NSTextAlignmentCenter;
        chatLabel.font = [UIFont systemFontOfSize:14];
        [chatButton addSubview:chatLabel];
//        [chatLabel release];
        
        noteButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(note) frame:CGRectMake(CGRectGetMaxX(chatButton.frame)+10, chatButton.frame.origin.y, chatButton.frame.size.width, chatButton.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"button_profilepopup_call_green.png" imageNamedPressed:nil];
        [noteButton setBackgroundImage:[[UIImage imageNamed:@"button_profilepopup_call_green.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:12] forState:UIControlStateNormal];
        noteButton.hidden = YES;
        noteButton.backgroundColor = [UIColor clearColor];
        [bottomView addSubview:noteButton];
        
        label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, noteButton.frame.size.width, noteButton.frame.size.height);
        label.text = @"쪽지";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [noteButton addSubview:label];
//        [label release];
        
        
        inviteButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(invite:) frame:CGRectMake(10, bottomView.frame.size.height - 85, bottomView.frame.size.width - 20, 25) imageNamedBullet:nil imageNamedNormal:@"button_profilepopup_call_green.png" imageNamedPressed:nil];
        [inviteButton setBackgroundImage:[[UIImage imageNamed:@"button_profilepopup_call_green.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:12] forState:UIControlStateNormal];
        inviteButton.tag = kInvite;
        inviteButton.hidden = YES;
        inviteButton.backgroundColor = [UIColor clearColor];
        [bottomView addSubview:inviteButton];
        
        label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, inviteButton.frame.size.width, inviteButton.frame.size.height);
        label.text = @"설치요청";
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [inviteButton addSubview:label];
//        [label release];
        
        
        bound = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"balon_grayline_deep.png"]];
        bound.frame = CGRectMake(chatButton.frame.origin.x,CGRectGetMaxY(chatButton.frame)+12,260-20,1);
        [bottomView addSubview:bound];
//        [bound release];
        
        
        greenPhoneLabel = [[UILabel alloc]init];
        greenPhoneLabel.frame = CGRectMake(profile.frame.origin.x,bottomView.frame.size.height - 35, 45, 20);
        greenPhoneLabel.text = NSLocalizedString(@"cellphone", @"cellphone");
        greenPhoneLabel.font = [UIFont systemFontOfSize:11];
        [bottomView addSubview:greenPhoneLabel];
//        [greenPhoneLabel release];
        
        
        lblPhone = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(greenPhoneLabel.frame), greenPhoneLabel.frame.origin.y, bottomView.frame.size.width - CGRectGetMaxX(greenPhoneLabel.frame) - 10 - 15 - 60, 20)];
        lblPhone.font = [UIFont systemFontOfSize:11];
        lblPhone.textColor = [UIColor grayColor];
        lblPhone.backgroundColor = [UIColor clearColor];
        [bottomView addSubview:lblPhone];
//        [lblPhone release];
        
        
        phoneButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(bottomView.frame.size.width - 10 - 50, lblPhone.frame.origin.y, 50, 22) imageNamedBullet:nil imageNamedNormal:@"button_profilepopup_call_green.png" imageNamedPressed:nil];
        phoneButton.tag = kCell;
        phoneButton.backgroundColor = [UIColor clearColor];
        [bottomView addSubview:phoneButton];
        [phoneButton setBackgroundImage:[[UIImage imageNamed:@"button_profilepopup_call_green.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:12] forState:UIControlStateNormal];
        
        label = [[UILabel alloc]init];
        label.frame = CGRectMake(0, 0, phoneButton.frame.size.width, phoneButton.frame.size.height);
        label.text = NSLocalizedString(@"call", @"call");
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        [phoneButton addSubview:label];
//        [label release];
        
        
        
        
        
        
    }
    return self;
    
}
#else

- (id)init{
    
    self = [super init];
    if (self) {
        
        
        backgroundView = [[UIImageView alloc]initWithFrame:self.view.frame];
        NSLog(@"background %@",NSStringFromCGRect([UIApplication sharedApplication].delegate.window.bounds));
        NSLog(@"background %@",NSStringFromCGRect(self.view.bounds));
        backgroundView.backgroundColor = [UIColor whiteColor];
        backgroundView.userInteractionEnabled = YES;
        [self.view addSubview:backgroundView];
        
        coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, backgroundView.frame.size.width, backgroundView.frame.size.height-319)];
        coverImageView.userInteractionEnabled = YES;
        [coverImageView setContentMode:UIViewContentModeScaleAspectFill];
        [backgroundView addSubview:coverImageView];
        
//        [coverImageView release];
        
//        [viewButton release];
        
#ifdef BearTalk
        coverImageView.frame = CGRectMake(0,0,backgroundView.frame.size.width, [SharedFunctions scaleFromHeight:464]);
        NSLog(@"coverImageView %@",NSStringFromCGRect(coverImageView.frame));
      
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){

            UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
  
            // add effect to an effect view
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
            effectView.frame = coverImageView.frame;
        
            // add the effect view to the image view
            [coverImageView addSubview:effectView];
        }
        else{
        
            
            
            UIToolbar *blurView = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0, coverImageView.frame.size.width, coverImageView.frame.size.height)];
            blurView.barStyle = UIBarStyleBlack;
            [coverImageView addSubview:blurView];
    }
#else
        
        UIButton *viewButton;
        viewButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(0,0,coverImageView.frame.size.width,coverImageView.frame.size.height) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        viewButton.tag = kCover;
        [coverImageView addSubview:viewButton];
        
#endif
        
        
        UIButton *button;
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(closePopup) frame:CGRectMake(coverImageView.frame.size.width - 45-5, 10, 45, 45) imageNamedBullet:nil imageNamedNormal:@"button_profilepopup_close.png" imageNamedPressed:nil];
        [coverImageView addSubview:button];
        
        
#ifdef BearTalk
        button.frame = CGRectMake(coverImageView.frame.size.width - 16 - 25, 20, 25, 25);
        [button setBackgroundImage:[UIImage imageNamed:@"actionbar_btn_close.png"] forState:UIControlStateNormal];
#endif
        UIImageView *restView;
        restView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(coverImageView.frame), backgroundView.frame.size.width, backgroundView.frame.size.height-CGRectGetMaxY(coverImageView.frame))];
        restView.userInteractionEnabled = YES;
        [backgroundView addSubview:restView];
        //        [restView release];
        NSLog(@"restView %@",NSStringFromCGRect(restView.frame));
        restView.backgroundColor = [UIColor whiteColor];
        
        
        
        
        
        
        // name myinfo team
        //        UIImageView *myInfoView;
        //        myInfoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, restView.frame.size.width, 140)];
        //        myInfoView.userInteractionEnabled = YES;
        //        [restView addSubview:myInfoView];
//                [myInfoView release];
        
        
        
        //        UIImageView *photoimageView;
        profile = [[UIImageView alloc]initWithFrame:CGRectMake(backgroundView.frame.size.width/2-86/2, CGRectGetMaxY(coverImageView.frame) - 56, 86, 86)];
        //        photoimageView.image = [CustomUIKit customImageNamed:@"profile_popup_top.png"];
        profile.userInteractionEnabled = YES;
        
#ifdef BearTalk
        profile.frame = CGRectMake(coverImageView.frame.size.width/2 - [SharedFunctions scaleFromWidth:120]/2, [SharedFunctions scaleFromHeight:64+15+23+6+23+18], [SharedFunctions scaleFromWidth:120], [SharedFunctions scaleFromHeight:120]);
        profile.clipsToBounds = YES;
        profile.layer.cornerRadius = profile.frame.size.width/2;
        
        [profile setContentMode:UIViewContentModeScaleAspectFill];
        [coverImageView addSubview:profile];
#else
        
        [backgroundView addSubview:profile];
#endif
        
//        [profile release];
        
        //
        //        profile = [[UIImageView alloc]init];
        //        profile.frame = CGRectMake(12, 0, 80, 80);
        //        [photoimageView addSubview:profile];
        //        profile.userInteractionEnabled = YES;
        //        [profile release];
        //
        
        coverProfileView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, profile.frame.size.width, profile.frame.size.height)];
        //        coverProfileView.image = [CustomUIKit customImageNamed:@"imageview_profilepopup_profile_disabledcover.png"];
        coverProfileView.userInteractionEnabled = YES;
        [profile addSubview:coverProfileView];
        coverProfileView.backgroundColor = RGBA(0,0,0,0.64);
//        [coverProfileView release];
        coverProfileView.hidden = YES;
#ifdef BearTalk
        coverProfileView.clipsToBounds = YES;
        coverProfileView.layer.cornerRadius = coverProfileView.frame.size.width/2;
        
        
#endif
        
        infoLabel = [[UILabel alloc]initWithFrame:coverProfileView.frame];
        infoLabel.font = [UIFont boldSystemFontOfSize:17];
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        infoLabel.text = @"";
        [coverProfileView addSubview:infoLabel];
        
        
        
        UIButton *borderButton;
        borderButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(0,0,profile.frame.size.width,profile.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"imageview_profilepopup_profile_border.png" imageNamedPressed:nil];
        borderButton.tag = kPhoto;
        [profile addSubview:borderButton];
//        [borderButton release];

        
        lblName = [[UILabel alloc]initWithFrame:CGRectMake(25, 30+5, 320-50, 25)];
        lblName.font = [UIFont systemFontOfSize:18];
        lblName.textColor = RGB(51, 51, 51);
        lblName.textAlignment = NSTextAlignmentCenter;
        lblName.backgroundColor = [UIColor clearColor];
#ifdef BearTalk
      #else
        [restView addSubview:lblName];
#endif
//        [lblName release];
        
        
        
        
        
#ifdef BearTalk
        
        [borderButton setBackgroundImage:nil forState:UIControlStateNormal];
        
        lblName.frame = CGRectMake(16, CGRectGetMaxY(profile.frame)+12, backgroundView.frame.size.width - 32, 20);
        lblName.font = [UIFont boldSystemFontOfSize:19];
        lblName.textColor = RGB(255,255,255);
        [coverImageView addSubview:lblName];
        
//        checkView = [[UIImageView alloc]initWithFrame:CGRectMake(profile.frame.origin.x+profile.frame.size.width-32,profile.frame.origin.y+profile.frame.size.height-32,27,27)];
//        checkView.layer.borderWidth = 1.0;
//        checkView.layer.borderColor = [RGB(223, 223, 223)CGColor];
//        checkView.layer.cornerRadius = checkView.frame.size.width/2;
//        checkView.backgroundColor = RGB(249,249,249);
//        [coverImageView addSubview:checkView];
        
        favButton = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(addOrClear:) frame:CGRectMake(profile.frame.origin.x+profile.frame.size.width-27, profile.frame.origin.y+profile.frame.size.height-27, 25, 25) imageNamedBullet:nil imageNamedNormal:@"btn_profile_bookmark_off.png" imageNamedPressed:nil];
        
        //        [favButton release];
        favButton.tag = kNotFavorite;
        
        
               [coverImageView addSubview:favButton];
        
        
#else
        
        favButton = [CustomUIKit buttonWithTitle:nil fontSize:14 fontColor:nil target:self selector:@selector(addOrClear:) frame:CGRectMake(restView.frame.size.width - 35, 5, 29, 29) imageNamedBullet:nil imageNamedNormal:@"button_profilepopup_notfavorite.png" imageNamedPressed:nil];
        
        //        [favButton release];
        favButton.tag = kNotFavorite;
        
                [restView addSubview:favButton];
#endif
        
        holidayView = [[UIImageView alloc]init];
        holidayView.frame = CGRectMake(5,favButton.frame.origin.y,20,20);
//        [holidayView release];
        
        holidayLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(holidayView.frame)+5, holidayView.frame.origin.y, 65, 20)];
        holidayLabel.font = [UIFont systemFontOfSize:13];
        holidayLabel.textColor = [UIColor grayColor];
        holidayLabel.textAlignment = NSTextAlignmentLeft;
        holidayLabel.backgroundColor = [UIColor clearColor];
//        [holidayLabel release];
        
        //        holidayView.image = [UIImage imageNamed:@"imageview_profile_popup_holiday.png"];
        //        holidayLabel.text = @"휴가";
        
        
        
        infoBackgroundView = [[UIImageView alloc]init];
        infoBackgroundView.frame = CGRectMake(15,CGRectGetMaxY(lblName.frame)+5,320-30,0);
        infoBackgroundView.userInteractionEnabled = YES;
        infoBackgroundView.image = [[UIImage imageNamed:@"button_profilepopup_info_background.png"] stretchableImageWithLeftCapWidth:58 topCapHeight:14];
//        [infoBackgroundView release];
        
        
        lblInfo = [[UILabel alloc]init];
        lblInfo.frame = CGRectMake(15,0,infoBackgroundView.frame.size.width-30,infoBackgroundView.frame.size.height);
        [lblInfo setBackgroundColor:[UIColor clearColor]];
        lblInfo.textColor = [UIColor grayColor];
        lblInfo.font = [UIFont systemFontOfSize:10];
        lblInfo.textAlignment = NSTextAlignmentCenter;
        lblInfo.numberOfLines = 1;
//        [lblInfo release];
        
        positionScrollView = [[UIScrollView alloc]init];
        positionScrollView.frame = CGRectMake(lblName.frame.origin.x,CGRectGetMaxY(infoBackgroundView.frame)+8,lblName.frame.size.width,25);
        NSLog(@" positionScrollView.fr %@",NSStringFromCGRect( positionScrollView.frame));
        lblPosition = [[UILabel alloc]init];
        [lblPosition setBackgroundColor:[UIColor clearColor]];
        lblPosition.textColor = [UIColor grayColor];
        [lblPosition setFont:[UIFont systemFontOfSize:12]];
        lblPosition.textAlignment = NSTextAlignmentCenter;
        lblPosition.numberOfLines = 0;
        [lblPosition setLineBreakMode:NSLineBreakByCharWrapping];
#ifdef BearTalk
        
        [coverImageView addSubview:holidayView];
        [coverImageView addSubview:holidayLabel];
        [coverImageView addSubview:positionScrollView];
        [coverImageView addSubview:lblInfo];
        [positionScrollView addSubview:lblPosition];
        
        holidayView.frame = CGRectMake(16, 20, 20, 20);
        holidayLabel.frame = CGRectMake(CGRectGetMaxX(holidayView.frame)+5, holidayView.frame.origin.y, 65, 20);
        holidayLabel.font = [UIFont systemFontOfSize:15];
        holidayLabel.textColor = RGB(255,255,255);
        lblInfo.frame = CGRectMake(16,[SharedFunctions scaleFromHeight:64],coverImageView.frame.size.width-32,profile.frame.origin.y - [SharedFunctions scaleFromHeight:64]);
        lblInfo.textColor = [UIColor whiteColor];
        lblInfo.font = [UIFont boldSystemFontOfSize:23];
        lblInfo.textAlignment = NSTextAlignmentCenter;
        lblInfo.numberOfLines = 2;
        
        lblPosition.textColor = RGB(255,255,255);
        [lblPosition setFont:[UIFont systemFontOfSize:14]];
        
        NSLog(@"lblName %@",NSStringFromCGRect(lblName.frame));
        NSLog(@"lblInfo %@",NSStringFromCGRect(lblInfo.frame));
        
        
        buttonView = [[UIView alloc]init];
        buttonView.frame = CGRectMake(0,coverImageView.frame.size.height - [SharedFunctions scaleFromHeight:40] - 40,coverImageView.frame.size.width,40);
        buttonView.userInteractionEnabled = YES;
        [coverImageView addSubview:buttonView];
        
        
        myButtonView = [[UIView alloc]init];
        myButtonView.frame = buttonView.frame;
        [coverImageView addSubview:myButtonView];
        
        
        inviteView = [[UIView alloc]init];
        inviteView.frame = buttonView.frame;
        [coverImageView addSubview:inviteView];
        
        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        // chat call
        chatButton = [CustomUIKit buttonWithTitle:NSLocalizedString(@"chat", @"chat") fontSize:16 fontColor:RGB(255,255,255) target:self selector:@selector(manToMan)
                                        frame:CGRectMake(buttonView.frame.size.width/2 - (buttonView.frame.size.width/2 - 13 - 37)/2, 0, buttonView.frame.size.width/2 - 13 - 37, 40)
                             imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
       
        [buttonView addSubview:chatButton];
        chatButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        chatButton.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        chatButton.clipsToBounds = YES;
        chatButton.layer.cornerRadius = 19;
        
        
//        button = [CustomUIKit buttonWithTitle:@"무료통화" fontSize:16 fontColor:RGB(255,255,255) target:self selector:@selector(mVoip)
//                                        frame:CGRectMake(coverImageView.frame.size.width/2 + 13, 0, buttonView.frame.size.width/2 - 13 - 37, 40)
//                             imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
//        [buttonView addSubview:button];
//        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
//        button.backgroundColor = RGB(51,61,71);
//        button.clipsToBounds = YES;
//        button.layer.cornerRadius = 19;
        
        
        // invite
        inviteButton = [CustomUIKit buttonWithTitle:@"설치요청" fontSize:16 fontColor:RGB(255,255,255) target:self selector:@selector(invite:)
                                        frame:CGRectMake(70, 0, inviteView.frame.size.width - 70*2, 40)
                             imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [inviteView addSubview:inviteButton];
        inviteButton.tag = kInvite;
        inviteButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        inviteButton.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        inviteButton.clipsToBounds = YES;
        inviteButton.layer.cornerRadius = 19;
        
        
        // invite
        myButton = [CustomUIKit buttonWithTitle:NSLocalizedString(@"change_my_info", @"change_my_info") fontSize:16 fontColor:RGB(255,255,255) target:self selector:@selector(editMyProfile)
                                        frame:CGRectMake(37, 0, inviteView.frame.size.width - 37*2, 40)
                             imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [myButtonView addSubview:myButton];
        myButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        myButton.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        myButton.clipsToBounds = YES;
        myButton.layer.cornerRadius = 19;
        
        
        
        
        
        positionScrollView.frame = CGRectMake(lblName.frame.origin.x,CGRectGetMaxY(lblName.frame)+6,lblName.frame.size.width,buttonView.frame.origin.y - [SharedFunctions scaleFromHeight:20] - (CGRectGetMaxY(lblName.frame)+6));
        
        NSLog(@" positionScrollView.fr2 %@",NSStringFromCGRect( positionScrollView.frame));
        NSLog(@"restView %@",NSStringFromCGRect(restView.frame));
        
        
        
        
        
        officeIconButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(restView.frame.size.width - 37 - [SharedFunctions scaleFromWidth:35], [SharedFunctions scaleFromHeight:13], [SharedFunctions scaleFromWidth:35], [SharedFunctions scaleFromHeight:35]) imageNamedBullet:nil imageNamedNormal:@"btn_profile_call.png" imageNamedPressed:nil];
        officeIconButton.tag = kOffice;
        [restView addSubview:officeIconButton];
        
        
        
        UIImageView *iconView;
        iconView = [[UIImageView alloc]initWithFrame: CGRectMake(37, [SharedFunctions scaleFromHeight:13+2], 18, 31)];
        iconView.image = [UIImage imageNamed:@"ic_profile_office.png"];
        [restView addSubview:iconView];
      
        
        lblOffice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+11, iconView.frame.origin.y, officeIconButton.frame.origin.x - CGRectGetMaxX(iconView.frame) - 10, iconView.frame.size.height)];
        lblOffice.font = [UIFont systemFontOfSize:15];
        lblOffice.textColor = RGB(51,61,71);
        lblOffice.backgroundColor = [UIColor clearColor];
        [restView addSubview:lblOffice];
        //        [lblOffice release];
        
        
        cellIconButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(restView.frame.size.width - 37 - [SharedFunctions scaleFromWidth:35], [SharedFunctions scaleFromHeight:13+35+10], [SharedFunctions scaleFromWidth:35], [SharedFunctions scaleFromHeight:35]) imageNamedBullet:nil imageNamedNormal:@"btn_profile_call.png" imageNamedPressed:nil];
        cellIconButton.tag = kCell;
        [restView addSubview:cellIconButton];
        
        iconView = [[UIImageView alloc]initWithFrame: CGRectMake(37, [SharedFunctions scaleFromHeight:13+35+10+2], 18, 31)];
        iconView.image = [UIImage imageNamed:@"ic_profile_phone.png"];
        [restView addSubview:iconView];
        
        
        lblPhone = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+11, iconView.frame.origin.y, cellIconButton.frame.origin.x - CGRectGetMaxX(iconView.frame) - 10, iconView.frame.size.height)];
        lblPhone.font = [UIFont systemFontOfSize:15];
        lblPhone.textColor = RGB(51,61,71);
        lblPhone.backgroundColor = [UIColor clearColor];
        [restView addSubview:lblPhone];
        //        [lblOffice release];
        
        
        
        emailIconButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(restView.frame.size.width - 37 - [SharedFunctions scaleFromWidth:35], [SharedFunctions scaleFromHeight:13+35+10+35+10], [SharedFunctions scaleFromWidth:35], [SharedFunctions scaleFromHeight:35]) imageNamedBullet:nil imageNamedNormal:@"btn_profile_mail.png" imageNamedPressed:nil];
        emailIconButton.tag = kEmail;
        [restView addSubview:emailIconButton];
        
        iconView = [[UIImageView alloc]initWithFrame: CGRectMake(37,  [SharedFunctions scaleFromHeight:13+35+10+35+10+2], 18, 31)];
        iconView.image = [UIImage imageNamed:@"ic_profile_mail.png"];
        [restView addSubview:iconView];
        
        
        lblEmail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame)+11, iconView.frame.origin.y, emailIconButton.frame.origin.x - (CGRectGetMaxX(iconView.frame)+11) - 10, iconView.frame.size.height)];
        lblEmail.font = [UIFont systemFontOfSize:15];
        lblEmail.textColor = RGB(51,61,71);
        lblEmail.backgroundColor = [UIColor clearColor];
        [restView addSubview:lblEmail];
        lblEmail.adjustsFontSizeToFitWidth = YES;
        //        [lblOffice release];
        
        saveButton = [CustomUIKit buttonWithTitle:@"휴대폰에 연락처 저장" fontSize:14 fontColor:RGB(143, 150, 156) target:self selector:@selector(confirmCell2:) frame:CGRectMake(37, [SharedFunctions scaleFromHeight:13+35+10+35+10+35+15],restView.frame.size.width - 37*2, [SharedFunctions scaleFromHeight:36]) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        saveButton.layer.borderWidth = 1;
        saveButton.layer.borderColor = RGB(188,198,207).CGColor;
        saveButton.clipsToBounds = YES;
        [restView addSubview:saveButton];
        
        CGSize size = [@"휴대폰에 연락처 저장" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        iconView = [[UIImageView alloc]initWithFrame:CGRectMake(saveButton.frame.size.width/2 + size.width/2 + 5,[SharedFunctions scaleFromHeight:36]/2-16/2, 16, 16)];
        iconView.image = [UIImage imageNamed:@"btn_profile_download.png"];
        [saveButton addSubview:iconView];
                  
//                  iconView = [[UIImageView alloc]initWithFrame: CGRectMake(37,  [SharedFunctions scaleFromHeight:13]+35+[SharedFunctions scaleFromHeight:10]+35+[SharedFunctions scaleFromHeight:10], 20, 35)];
  //                iconView.image = [UIImage imageNamed:@"ic_profile_mail.png"];
    //              [button addSubview:iconView];
#else
        [restView addSubview:holidayView];
        [restView addSubview:holidayLabel];
        [restView addSubview:infoBackgroundView];
        [restView addSubview:positionScrollView];
        [infoBackgroundView addSubview:lblInfo];
        [positionScrollView addSubview:lblPosition];

//        [lblPosition release];
        //        positionScrollView.backgroundColor = [UIColor blueColor];
        
        UIImageView *companyBackgroundView;
        UIImageView *companyIconView;
        UILabel *title;
        
        
        UIView *myCompanyView;
        myCompanyView = [[UIView alloc]init];
        myCompanyView.frame = CGRectMake(0,restView.frame.size.height-124,restView.frame.size.width,124);
        myCompanyView.userInteractionEnabled = YES;
        [restView addSubview:myCompanyView];
//        [myCompanyView release];
        
        // office cellphone email
        //        UIView *myCompanyView = [[UIView alloc]init];
        //        myCompanyView.frame = CGRectMake(buttonView.frame.origin.x,CGRectGetMaxY(buttonView.frame),myButtonView.frame.size.width,105);
        //        myCompanyView.userInteractionEnabled = YES;
        //        [restView addSubview:myCompanyView];
//                [myCompanyView release];
        UIImageView *line;
        line = [[UIImageView alloc]init];
        line.image = [[UIImage imageNamed:@"imageview_profilepopup_grayline.png"] stretchableImageWithLeftCapWidth:31 topCapHeight:0];
        line.frame = CGRectMake(25, 0, 320-50, 1);
        [myCompanyView addSubview:line];
//        [line release];
        
        
        // office
        companyBackgroundView = [[UIImageView alloc]initWithFrame:
                                 CGRectMake(25, 1+12, 130, 46)];
        companyBackgroundView.userInteractionEnabled = YES;
        companyBackgroundView.image = [[UIImage imageNamed:@"button_profilepopup_buttonbackground.png"] stretchableImageWithLeftCapWidth:65 topCapHeight:23];
        [myCompanyView addSubview:companyBackgroundView];
//        [companyBackgroundView release];
        
        companyIconView = [[UIImageView alloc]initWithFrame:
                           CGRectMake(10, 46/2-19/2, 14, 19)];
        companyIconView.userInteractionEnabled = YES;
        companyIconView.image = [UIImage imageNamed:@"button_profilepopup_call.png"];
        [companyBackgroundView addSubview:companyIconView];
//        [companyIconView release];
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(companyIconView.frame)+10, 5, companyBackgroundView.frame.size.width-10-CGRectGetMaxX(companyIconView.frame), 18)];
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"사무실";
        [companyBackgroundView addSubview:title];
//        [title release];
        
        lblOffice = [[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, CGRectGetMaxY(title.frame), title.frame.size.width, 18)];
        lblOffice.font = [UIFont systemFontOfSize:12];
        lblOffice.textColor = [UIColor grayColor];
        lblOffice.backgroundColor = [UIColor clearColor];
        [companyBackgroundView addSubview:lblOffice];
//        [lblOffice release];
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(0,0,companyBackgroundView.frame.size.width,companyBackgroundView.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        button.tag = kOffice;
        button.backgroundColor = [UIColor clearColor];
        [companyBackgroundView addSubview:button];
        
        // cell
        companyBackgroundView = [[UIImageView alloc]initWithFrame:
                                 CGRectMake(25+130+10, 1+12, 130, 46)];
        companyBackgroundView.userInteractionEnabled = YES;
        companyBackgroundView.image = [[UIImage imageNamed:@"button_profilepopup_buttonbackground.png"] stretchableImageWithLeftCapWidth:65 topCapHeight:23];
        [myCompanyView addSubview:companyBackgroundView];
//        [companyBackgroundView release];
        
        companyIconView = [[UIImageView alloc]initWithFrame:
                           CGRectMake(10, 46/2-19/2, 14, 19)];
        companyIconView.userInteractionEnabled = YES;
        companyIconView.image = [UIImage imageNamed:@"button_profilepopup_call.png"];
        [companyBackgroundView addSubview:companyIconView];
//        [companyIconView release];
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(companyIconView.frame)+10, 5, companyBackgroundView.frame.size.width-10-CGRectGetMaxX(companyIconView.frame), 18)];
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        title.text = NSLocalizedString(@"cellphone", @"cellphone");
        [companyBackgroundView addSubview:title];
//        [title release];
        
        lblPhone = [[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, CGRectGetMaxY(title.frame), title.frame.size.width, 18)];
        lblPhone.font = [UIFont systemFontOfSize:12];
        lblPhone.textColor = [UIColor grayColor];
        lblPhone.backgroundColor = [UIColor clearColor];
        [companyBackgroundView addSubview:lblPhone];
//        [lblPhone release];
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(0,0,companyBackgroundView.frame.size.width,companyBackgroundView.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        button.tag = kCell;
        button.backgroundColor = [UIColor clearColor];
        [companyBackgroundView addSubview:button];
        
        // email
        companyBackgroundView = [[UIImageView alloc]initWithFrame:
                                 CGRectMake(25, 1+12+46+7, 320-25-25, 46)];
        companyBackgroundView.userInteractionEnabled = YES;
        companyBackgroundView.image = [[UIImage imageNamed:@"button_profilepopup_buttonbackground.png"] stretchableImageWithLeftCapWidth:65 topCapHeight:23];
        [myCompanyView addSubview:companyBackgroundView];
//        [companyBackgroundView release];
        
        companyIconView = [[UIImageView alloc]initWithFrame:
                           CGRectMake(10, 46/2-17/2, 20, 17)];
        companyIconView.userInteractionEnabled = YES;
        companyIconView.image = [UIImage imageNamed:@"button_profilepopup_email.png"];
        [companyBackgroundView addSubview:companyIconView];
//        [companyIconView release];
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(companyIconView.frame)+10, 5, companyBackgroundView.frame.size.width-10-CGRectGetMaxX(companyIconView.frame), 18)];
        title.font = [UIFont systemFontOfSize:12];
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"이메일";
        [companyBackgroundView addSubview:title];
//        [title release];
        
        lblEmail = [[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, CGRectGetMaxY(title.frame), title.frame.size.width, 18)];
        lblEmail.font = [UIFont systemFontOfSize:12];
        lblEmail.textColor = [UIColor grayColor];
        lblEmail.backgroundColor = [UIColor clearColor];
        [companyBackgroundView addSubview:lblEmail];
//        [lblEmail release];
        
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:) frame:CGRectMake(0,0,companyBackgroundView.frame.size.width,companyBackgroundView.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        button.tag = kEmail;
        button.backgroundColor = [UIColor clearColor];
        [companyBackgroundView addSubview:button];
        
        
        
        
        
        
        // chat mvoip install note
        buttonView = [[UIView alloc]init];
        buttonView.frame = CGRectMake(0,myCompanyView.frame.origin.y-62-10,restView.frame.size.width,62);
        buttonView.userInteractionEnabled = YES;
        [restView addSubview:buttonView];
//        [buttonView release];
        
        
        UIButton *notebutton;
        notebutton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(note)
                                            frame:CGRectMake(restView.frame.size.width/2-50,5,100,42)
                                 imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [buttonView addSubview:notebutton];
        
        
#ifdef BearTalk
        notebutton.frame = CGRectMake(buttonView.frame.size.width/2,10,0,42);
#else
        
        
        companyIconView = [[UIImageView alloc]initWithFrame:
                           CGRectMake(0, 0, 42, 42)];
        companyIconView.image = [UIImage imageNamed:@"button_profilepopup_note.png"];
        [notebutton addSubview:companyIconView];
//        [companyIconView release];
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(companyIconView.frame)+10, 42/2-18/2, notebutton.frame.size.width-10-CGRectGetMaxX(companyIconView.frame)-10, 18)];
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"쪽지";
        [notebutton addSubview:title];
//        [title release];
        
        
#endif
        
        
        // chat
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(manToMan)
                                        frame:CGRectMake(notebutton.frame.origin.x-100,notebutton.frame.origin.y,100,42)
                             imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [buttonView addSubview:button];
        companyIconView = [[UIImageView alloc]initWithFrame:
                           CGRectMake(0, 0, 42, 42)];
        companyIconView.image = [UIImage imageNamed:@"button_profilepopup_chat.png"];
        [button addSubview:companyIconView];
//        [companyIconView release];
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(companyIconView.frame)+10, 42/2-18/2, button.frame.size.width-10-CGRectGetMaxX(companyIconView.frame)-10, 18)];
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        title.text = NSLocalizedString(@"chat", @"chat");
        [button addSubview:title];
//        [title release];
        
        
        // mvoip
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(mVoip)
                                        frame:CGRectMake(CGRectGetMaxX(notebutton.frame),notebutton.frame.origin.y,130,42)
                             imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [buttonView addSubview:button];
        
        
        companyIconView = [[UIImageView alloc]initWithFrame:
                           CGRectMake(0, 0, 42, 42)];
        companyIconView.image = [UIImage imageNamed:@"button_profilepopup_mvoip.png"];
        [button addSubview:companyIconView];
//        [companyIconView release];
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(companyIconView.frame)+10, 42/2-18/2, button.frame.size.width-10-CGRectGetMaxX(companyIconView.frame)-10, 18)];
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"무료통화";
        [button addSubview:title];
//        [title release];
        
        
        inviteView = [[UIView alloc]init];
        inviteView.frame = buttonView.frame;
        [restView addSubview:inviteView];
        
        // invite
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(invite:)
                                        frame:CGRectMake(inviteView.frame.size.width/2-65,notebutton.frame.origin.y,130,42)
                             imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [inviteView addSubview:button];
        button.tag = kInvite;
        
        
        companyIconView = [[UIImageView alloc]initWithFrame:
                           CGRectMake(0, 0, 42, 42)];
        companyIconView.userInteractionEnabled = YES;
        companyIconView.image = [UIImage imageNamed:@"button_profilepopup_invite.png"];
        [button addSubview:companyIconView];
//        [companyIconView release];
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(companyIconView.frame)+10, 42/2-18/2, button.frame.size.width-10-CGRectGetMaxX(companyIconView.frame)-10, 18)];
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        title.text = @"설치요청";
        [button addSubview:title];
//        [title release];
        
        
        
        myButtonView = [[UIView alloc]init];
        myButtonView.frame = buttonView.frame;
        [restView addSubview:myButtonView];
        // myinfo
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editMyProfile) frame:CGRectMake(myButtonView.frame.size.width/2-75,notebutton.frame.origin.y,150,42)
                             imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
        [myButtonView addSubview:button];
        
        
        companyIconView = [[UIImageView alloc]initWithFrame:
                           CGRectMake(0, 0, 42, 42)];
        companyIconView.userInteractionEnabled = YES;
        companyIconView.image = [UIImage imageNamed:@"button_profilepopup_myinfo.png"];
        [button addSubview:companyIconView];
        companyIconView.userInteractionEnabled = NO;
//        [companyIconView release];
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(companyIconView.frame)+10, 42/2-18/2, button.frame.size.width-10-CGRectGetMaxX(companyIconView.frame)-10, 18)];
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        title.text = NSLocalizedString(@"change_my_info", @"change_my_info");
        [button addSubview:title];
//        [title release];
        
        #endif
        
        
        
        
    }
    return self;
}

#endif

//- (void)callPhone
//{
//
//    [self closePopup];
//
//}
//
//- (void)callOffice
//{
//    [self closePopup];
//   }
//
//
//- (void)callCustomer
//{
//    [self closePopup];
//
//}
//
//- (void)sendEmail
//{
//
//
//    [self closePopup];
//
//}


#define kUsingUid 1
#define kNotUsingUid 2

- (void)mVoip
{
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"mVoIPEnable"]) {
        NSLog(@"sip_trunk %@",[SharedAppDelegate readPlist:@"sip_trunk"]);
        
        if([[SharedAppDelegate readPlist:@"sip_trunk"]isEqualToString:@"0"]){
            [self closePopup];
            UIView *view = [SharedAppDelegate.root.callManager setFullOutgoing:self.uniqueid usingUid:kUsingUid];
            [SharedAppDelegate.window addSubview:view];
        }else if([[SharedAppDelegate readPlist:@"sip_trunk"]isEqualToString:@"1"]){
            
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                UIAlertController * view=   [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@""
                                             preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *actionButton;
                
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"사무실 무료통화"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    [CustomUIKit popupAlertViewOK:@"" msg:@"무선 데이터 네트워크 상태가 고르지 못할 경우 (3G 혹은 신호강도가 약한 WiFi 에 연결) 통화품질이 낮을 수 있습니다. 가입하신 통신사의 3G/LTE 네트워크로 접속시 사용중인 요금제의 기본 제공 데이터가 소모됩니다.(1분 통화시 약 1.2MB)" delegate:self tag:kMvoipOffice sel:@selector(confirmMvoipOffice) with:nil csel:nil with:nil];
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"휴대폰 무료통화"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    [CustomUIKit popupAlertViewOK:@"" msg:@"무선 데이터 네트워크 상태가 고르지 못할 경우 (3G 혹은 신호강도가 약한 WiFi 에 연결) 통화품질이 낮을 수 있습니다. 가입하신 통신사의 3G/LTE 네트워크로 접속시 사용중인 요금제의 기본 제공 데이터가 소모됩니다.(1분 통화시 약 1.2MB)" delegate:self tag:kMvoipUid sel:@selector(confirmMvoipUid) with:nil csel:nil with:nil];
                                    
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
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                                           destructiveButtonTitle:nil otherButtonTitles:@"사무실 무료통화", @"휴대폰 무료통화", nil];
                [actionSheet showInView:SharedAppDelegate.window];
            }
        }
    } else {
        NSString *msg = @"상대방의 핸드폰 번호로 일반통화 연결합니다. 통화하시겠습니까?";
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
        //        alert.tag = kCell;
        //        [alert show];
        //        [alert release];
        [CustomUIKit popupAlertViewOK:@"일반통화" msg:msg delegate:self tag:kCell sel:@selector(confirmCell) with:nil csel:nil with:nil];
    }
    
}


- (void)note{
    
    [self closePopup];
    SendNoteViewController *post = [[SendNoteViewController alloc]initWithStyle:1];//WithViewCon:self];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
    post.title = @"쪽지 보내기";
    NSDictionary *dic = [SharedAppDelegate.root searchContactDictionary:self.uniqueid];
    [post saveArray:[NSArray arrayWithObjects:dic,nil]];
    //    [SharedAppDelegate.root returnTitle:post.title viewcon:post noti:NO alarm:NO];
    [SharedAppDelegate.root anywhereModal:nc];
//    [post release];
//    [nc release];
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"viewWillAppear");
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
}
- (void)closePopup
{
    NSLog(@"closePopup");
    [self close];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setAlpha:0.0];
        [SharedAppDelegate.root removeDisableView];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
    
}


#define kSubStatus 100

- (void)editMyProfile{
    
    [self closePopup];
    
    SubSetupViewController *sub = [[SubSetupViewController alloc]initFromWhere:kSubStatus];
    UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:sub];
    [SharedAppDelegate.root anywhereModal:nc];
//    [nc release];
//    [sub release];
}

- (void)manToMan
{
    NSLog(@"mantoman %@",self.userlevel);
    
    [self closePopup];
    
    if([self.userlevel intValue] == 40) // ############# 채팅화면으로 이동, 만들지 않음
    {
       
#ifdef Batong // #######################
#elif GreenTalk
        // 우선 채팅탭으로 이동
        
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
        
        
        NSLog(@"visible !!!!!!!!!! %@",[SharedAppDelegate.root checkVisible:SharedAppDelegate.root]?@"YES":@"NO");
        
        
        if([SharedAppDelegate.root checkVisible:SharedAppDelegate.root.greenBoard]){
            NSLog(@"social");
            [SharedAppDelegate.root.greenBoard setSelectedIndex:kSubTabIndexChat];
        }
        else if([SharedAppDelegate.root checkVisible:SharedAppDelegate.root.main]){
            
            [SharedAppDelegate.root.mainTabBar setSelectedIndex:kTabIndexMessage];
            [SharedAppDelegate.root.greenChatBoard setSelectedIndex:1];
        }
        return;
#endif
        
    }
    
    
    if([SharedAppDelegate.root checkVisible:SharedAppDelegate.root.chatView] && [SharedAppDelegate.root.chatView.roomType isEqualToString:@"1"]){
        NSLog(@"chatview / roomtype 1");
        return;
    }
    
    [SharedAppDelegate.root createRoomWithWhom:self.uniqueid type:@"1" roomname:@"mantoman" push:self];
}




- (void)addOrClear:(id)sender
{
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    UIButton *button = (UIButton *)sender;
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.tag = 22;
    [activity setCenter:CGPointMake(button.frame.size.width/2, button.frame.size.height/2)];
    [activity hidesWhenStopped];
    [sender addSubview:activity];
    [activity startAnimating];
//    [activity release];
    
    
    NSString *type = @"";
    
    if([sender tag]==kNotFavorite){
        type = @"1";
        //        clearFavButton.hidden = NO;
        //        addFavButton.hidden = YES;
    }
    else{
        type = @"2";
        //        clearFavButton.hidden = YES;
        //        addFavButton.hidden = NO;
        
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
    
    NSDictionary *parameters;
#ifdef BearTalk
    
    parameters = @{
                   @"act" : type,
                   @"uid" : [ResourceLoader sharedInstance].myUID,
                   @"favuid" : self.uniqueid,
                   };
#else
    
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                type,@"type",
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                self.uniqueid,@"member",
                                @"1",@"category",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",nil];
    
#endif
    NSLog(@"parameter %@",parameters);
    
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setfavorite.lemp" parameters:parameters];
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:method URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        
#ifdef BearTalk
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString];
        NSLog(@"resultDic %@",resultDic);
        
        if([sender tag] == kNotFavorite){
            [SQLiteDBManager updateFavorite:@"1" uniqueid:self.uniqueid];
            [SharedAppDelegate.root refreshSearchFavorite:self.uniqueid fav:@"1"];
            favButton.tag = kFavorite;
        
            NSLog(@"favorite_1");
            [favButton setBackgroundImage:[UIImage imageNamed:@"btn_profile_bookmark_on.png"] forState:UIControlStateNormal];

        }
        else{
            [SQLiteDBManager updateFavorite:@"0" uniqueid:self.uniqueid];
            [SharedAppDelegate.root refreshSearchFavorite:self.uniqueid fav:@"0"];
            favButton.tag = kNotFavorite;
           
            NSLog(@"favorite_1");
            [favButton setBackgroundImage:[UIImage imageNamed:@"btn_profile_bookmark_off.png"] forState:UIControlStateNormal];

            
        }
        [activity stopAnimating];
#else

        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResulstDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            //            if([[yourDicobjectForKey:@"favorite"]isEqualToString:@"0"]){
            if([sender tag] == kNotFavorite){
                [favButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_profilepopup_favorite.png"] forState:UIControlStateNormal];
                [SQLiteDBManager updateFavorite:@"1" uniqueid:self.uniqueid];
                [SharedAppDelegate.root refreshSearchFavorite:self.uniqueid fav:@"1"];
                favButton.tag = kFavorite;

            }
            else{
                [favButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_profilepopup_notfavorite.png"] forState:UIControlStateNormal];
                [SQLiteDBManager updateFavorite:@"0" uniqueid:self.uniqueid];
                [SharedAppDelegate.root refreshSearchFavorite:self.uniqueid fav:@"0"];
                favButton.tag = kNotFavorite;
 
                
            }
            [activity stopAnimating];
            
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            [activity stopAnimating];
            
        }
        
#endif
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [activity stopAnimating];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"즐겨찾기 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
    
}



- (void)invite:(id)sender{
    
    NSLog(@"invite %@",sender);
    
    
    [self closePopup];
    //    if([[SharedAppDelegate.root getPureNumbers:lblPhone.text] length]>9){
    [SharedAppDelegate.root invite:sender];
    
    //    }
    //    else{
    //
    //        [CustomUIKit popupAlertViewOK:nil msg:@"멤버의 휴대폰 정보가 없어 설치요청\nSMS를 발송할 수 없습니다."];
    //        return;
    //
    //    }
}



#define kNumber 3

- (void)cmdButton:(id)sender{
    
    NSLog(@"profile cmdButton %d",(int)[sender tag]);
    
    switch ([sender tag]) {
        case kCover:
        {
            
            
            
            NSString *theUID = [[SharedFunctions minusMe:self.uniqueid] componentsSeparatedByString:@","][0];
            NSLog(@"getCoverImage %@",theUID);
            
            NSURL *imgURL;
            NSString *profileImageInfo = [SharedAppDelegate.root searchContactDictionary:theUID][@"newfield6"];
            NSLog(@"otherProfile!!!! %@",profileImageInfo);
            imgURL = [ResourceLoader resourceURLfromJSONString:profileImageInfo num:0 thumbnail:NO];
            
            
            NSString *commercial_string = [SharedAppDelegate readPlist:@"commercial_image"];
            NSURL *saved_imgURL;
            saved_imgURL = [ResourceLoader resourceURLfromJSONString:commercial_string num:0 thumbnail:NO];
            
            

            NSData *cover_data = nil;
            
            
            if([theUID isEqualToString:[ResourceLoader sharedInstance].myUID]){
                
                NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@_privatetimelinetemp.JPG",NSHomeDirectory(),[ResourceLoader sharedInstance].myUID];
                
                BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                
                NSLog(@"imgURL is null");
                if(fileExists) // startup saved image exist ?
                {
                    
                   cover_data = [[NSFileManager defaultManager] contentsAtPath:filePath];
                    
                }
                else{ // not exist
                    
                    NSLog(@"file NOT Exists");
                    
                    
                    
                    NSURLRequest *request = [NSMutableURLRequest requestWithURL:imgURL];
                    NSURLResponse *response = nil;
                    //    NSError *error=nil;
                    NSData *data=[[NSData alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil]];
                    // you can use retVal , ignore if you don't need.
                    NSInteger httpStatus = [((NSHTTPURLResponse *)response) statusCode];
            
                    
                    if(IS_NULL(imgURL) || httpStatus != 200){
                        cover_data = [NSData dataWithContentsOfURL:saved_imgURL];
                    }
                    else{
                        cover_data = [NSData dataWithContentsOfURL:imgURL];
                        
                    }
                }
                
            }
            
            else{
                
                NSURLRequest *request = [NSMutableURLRequest requestWithURL:imgURL];
                NSURLResponse *response = nil;
                //    NSError *error=nil;
                NSData *data=[[NSData alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil]];
                // you can use retVal , ignore if you don't need.
                NSInteger httpStatus = [((NSHTTPURLResponse *)response) statusCode];
                

                if(IS_NULL(imgURL) || httpStatus != 200){
                    
                    
                    NSDictionary *dict = [commercial_string objectFromJSONString];
                    
                    NSArray *dict_filename = dict[@"filename"];
                    
                    NSString *filePath = [NSString stringWithFormat:@"%@/Library/Caches/%@.JPG",NSHomeDirectory(),dict_filename[0]];
                    NSLog(@"filePath %@",filePath);
                    
                    
                    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                    
                    
                    NSLog(@"imgURL is null");
                    if(fileExists) // startup saved image exist ?
                    {
                        //            view setimage
                        
                        
                        cover_data = [[NSFileManager defaultManager] contentsAtPath:filePath];

                    }
                    else{ // not exist
                        
                        NSLog(@"file NOT Exists");
                        
                        cover_data = [NSData dataWithContentsOfURL:saved_imgURL];
                    }
                }
                else{
                    
                    cover_data = [NSData dataWithContentsOfURL:imgURL];
                    
                }
            }
         
            
            
            PhotoViewController *photoViewCon;
            
            photoViewCon = [[PhotoViewController alloc] initWithImage:[UIImage imageWithData:cover_data] placeholder:coverImageView.image];
            
            UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(close) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"xclosebtn.png" imageNamedPressed:nil];
            UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//            [button release];
            photoViewCon.navigationItem.leftBarButtonItem = btnNavi;
//            [btnNavi release];
            
            if(specificNavicon){
//                [specificNavicon release];
                specificNavicon = nil;
            }
            specificNavicon = [[CBNavigationController alloc]initWithRootViewController:photoViewCon];
            //                [SharedAppDelegate.root anywherePush:photoViewCon];
            //            [SharedAppDelegate.root anywhereModal:nc];
            [SharedAppDelegate.window addSubview:specificNavicon.view];
//            [photoViewCon release];
            
            
            
            
            
            
        }
            break;
        case kPhoto:
        {
            
            
            NSString *profileImageInfo = [ResourceLoader checkProfileImageWithUID:self.uniqueid];
            NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:profileImageInfo num:0 thumbnail:NO];
            NSLog(@"self.uniqueid %@ profileImageInfo %@ imgurl %@",self.uniqueid,profileImageInfo,imgURL);
            if(imgURL == nil)
                return;
            
            PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithJSONdata:profileImageInfo image:profile.image type:2 parentViewCon:self uniqueID:self.uniqueid];
            
            UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(close) frame:CGRectMake(0, 0, 36, 36) imageNamedBullet:nil imageNamedNormal:@"xclosebtn.png" imageNamedPressed:nil];
            UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//            [button release];
            
            photoViewCon.navigationItem.leftBarButtonItem = btnNavi;
//            [btnNavi release];
            
            if(specificNavicon){
//                [specificNavicon release];
                specificNavicon = nil;
            }
            specificNavicon = [[CBNavigationController alloc]initWithRootViewController:photoViewCon];
            //                [SharedAppDelegate.root anywherePush:photoViewCon];
            //            [SharedAppDelegate.root anywhereModal:nc];
            [SharedAppDelegate.window addSubview:specificNavicon.view];
//            [photoViewCon release];
            
        }
            break;
        case kOffice:
        {
            
            if([lblOffice.text length]<1)
                return;
            

            NSString *msg = @"일반통화로 연결되며 통화료가 부과됩니다.\n전화를 연결하시겠습니까?";//[NSString stringWithFormat:@"%@로 일반 전화를\n연결하시겠습니
            [CustomUIKit popupAlertViewOK:@"일반통화" msg:msg delegate:self tag:kOffice sel:@selector(confirmOffice) with:nil csel:nil with:nil];

            
            
            
        }
            break;
        case kCell:
        {
            //            lblPhoneString = @"01072772192";
            
            if([self.uniqueid isEqualToString:[ResourceLoader sharedInstance].myUID])
                return;
            
            if([lblPhoneString length]<1)
                return;

            
            NSString *msg = @"일반통화로 연결되며 통화료가 부과됩니다.\n전화를 연결하시겠습니까?";//[NSString stringWithFormat:@"%@로 일반 전화를\n연결하시겠습니
            [CustomUIKit popupAlertViewOK:@"일반통화" msg:msg delegate:self tag:kCell sel:@selector(confirmCell) with:nil csel:nil with:nil];

            
        }
            break;
        case kEmail:
        {
            //            if([self.uniqueid isEqualToString:[ResourceLoader sharedInstance].myUID])
            //                return;
            
            if([lblEmail.text length]<1)
                return;
            
            NSString *msg = [NSString stringWithFormat:@"%@로 이메일을 보내시겠습니까?",lblEmail.text];
            //            UIAlertView *alert;
            //            alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
            //            alert.tag = kEmail;
            //            [alert show];
            //            [alert release];
            [CustomUIKit popupAlertViewOK:@"이메일" msg:msg delegate:self tag:kEmail sel:@selector(confirmEmail) with:nil csel:nil with:nil];
            
            
        }
            break;
        default:
            break;
    }
}

- (void)close{
    NSLog(@"specific %@",specificNavicon.view);
    if(specificNavicon.view)
        [specificNavicon.view removeFromSuperview];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    
    switch (buttonIndex) {
        case 0:
        {
            [CustomUIKit popupAlertViewOK:@"" msg:@"무선 데이터 네트워크 상태가 고르지 못할 경우 (3G 혹은 신호강도가 약한 WiFi 에 연결) 통화품질이 낮을 수 있습니다. 가입하신 통신사의 3G/LTE 네트워크로 접속시 사용중인 요금제의 기본 제공 데이터가 소모됩니다.(1분 통화시 약 1.2MB)" delegate:self tag:kMvoipOffice sel:@selector(confirmMvoipOffice) with:nil csel:nil with:nil];
            
        }
            break;
        case 1:
        {
            [CustomUIKit popupAlertViewOK:@"" msg:@"무선 데이터 네트워크 상태가 고르지 못할 경우 (3G 혹은 신호강도가 약한 WiFi 에 연결) 통화품질이 낮을 수 있습니다. 가입하신 통신사의 3G/LTE 네트워크로 접속시 사용중인 요금제의 기본 제공 데이터가 소모됩니다.(1분 통화시 약 1.2MB)" delegate:self tag:kMvoipUid sel:@selector(confirmMvoipUid) with:nil csel:nil with:nil];
            
        }
            break;
        default:
            break;
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    switch (result)
    {
        case MFMailComposeResultCancelled:{
            
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case MFMailComposeResultSaved:{
            
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case MFMailComposeResultSent:
        {
            UIAlertController * view=   [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:@""
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *actionButton;
            
            
            
            actionButton = [UIAlertAction
                            actionWithTitle:@"메일을 전송하였습니다."
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [controller dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
            
            
            
            
            
            [SharedAppDelegate.root anywhereModal:view];
            

            
//            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"메일을 전송하였습니다." con:self];
        }
            break;
        case MFMailComposeResultFailed:
        {
            UIAlertController * view=   [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:@""
                                         preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *actionButton;
            
            
            
            actionButton = [UIAlertAction
                            actionWithTitle:@"메일 전송에 실패하였습니다. 잠시후 다시 시도해주세요!"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [controller dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
            
            
            
            
            
            [SharedAppDelegate.root anywhereModal:view];
            
        }
//            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"메일 전송에 실패하였습니다. 잠시후 다시 시도해주세요!" con:self];
            break;
        default:{
            
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
            break;
    }
    
    
    
    //	if(result == MFMailComposeResdismissViewControllerAnimated:YES completion:nil];ltFailed){
    //		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"메일 전송에 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil];
    //
    //		[alert show];
    //		[alert release];
    //	}
}


- (void)confirmOffice{
    
    NSString *number = [NSString stringWithFormat:@"tel:%@",lblOffice.text];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:number]];
}

- (void)confirmCell2:(id)sender{

    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        //1
        NSLog(@"Denied");
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //2
        NSLog(@"Authorized");
        [self saveContact:sender];
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        //3
        NSLog(@"Not determined");
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            if (!granted){
                //4
                NSLog(@"Just denied");
                return;
            }
            //5
            NSLog(@"Just authorized");
            [self saveContact:sender];
        });
    }

}
- (void)saveContact:(id)sender{
    NSLog(@"savecontact");
    
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    ABRecordRef person = ABPersonCreate();
    
    // Setting basic properties
//    ABRecordSetValue(person, kABPersonFirstNameProperty, @"Ondrej" , nil);
    ABRecordSetValue(person, kABPersonLastNameProperty, (__bridge CFTypeRef)([sender titleForState:UIControlStateDisabled]), nil);
    // Adding phone numbers
    
//    ABRecordSetValue(person, kABPersonPhoneProperty, (__bridge CFTypeRef)(lblPhone.text), nil);
    ABMutableMultiValueRef phoneNumberMultiValue = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phoneNumberMultiValue, (__bridge CFTypeRef)[sender titleForState:UIControlStateSelected], (CFStringRef)@"iPhone", NULL);
    ABRecordSetValue(person, kABPersonPhoneProperty, phoneNumberMultiValue, nil);
    CFRelease(phoneNumberMultiValue);
    
    
    // Adding person to the address book
    ABAddressBookAddRecord(addressBook, person, nil);
    CFRelease(addressBook);
    
    // Creating view controller for a new contact
    ABNewPersonViewController *c = [[ABNewPersonViewController alloc] init];
    [c setNewPersonViewDelegate:self];
    [c setDisplayedPerson:person];
    
    if(specificNavicon){
        //                [specificNavicon release];
        specificNavicon = nil;
    }
    specificNavicon = [[CBNavigationController alloc]initWithRootViewController:c];
    
    specificNavicon.navigationBar.translucent = NO;
    
    [SharedAppDelegate.root anywhereModal:specificNavicon];
    CFRelease(person);
    
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(nullable ABRecordRef)person {
    // Trick to go back to your view by popping it from the navigation stack when done or cancel button is pressed
    NSLog(@"didCompleteWithNewPerson %@",specificNavicon);
    if(specificNavicon)
    [specificNavicon dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)confirmCell{
    NSString *number = [NSString stringWithFormat:@"tel:%@",lblPhoneString];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:number]];
}



- (void)confirmEmail{
    
    [self closePopup];
    
    MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
    mailView.mailComposeDelegate = self;
    if([MFMailComposeViewController canSendMail]) {
        NSString *mailAddress = lblEmail.text;
        NSArray *toMail = [mailAddress componentsSeparatedByString:@"@"];
        NSLog(@"toMAil : %@",toMail);
        if(toMail[0] != nil && [toMail[0] length] > 0 && ![toMail[0] isEqualToString:@""] && ![toMail[0] isEqualToString:@"."]) {
            NSLog(@"mailAddress : %@",mailAddress);
            [mailView setToRecipients:[NSArray arrayWithObject:mailAddress]];
            [mailView setSubject:@""];
            [mailView setMessageBody:@"" isHTML:NO];
            [mailView setWantsFullScreenLayout:YES];
            //            [mailView shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
            //                        [SharedAppDelegate.root presentViewController:mailView animated:YES];
            [SharedAppDelegate.root anywhereModal:mailView];
        }
    }
//    [mailView release];
}

- (void)confirmMvoipOffice{
    
    [self closePopup];
    UIView *view = [SharedAppDelegate.root.callManager setFullOutgoing:self.uniqueid usingUid:kNotUsingUid];
    [SharedAppDelegate.window addSubview:view];
}
- (void)confirmMvoipUid{
    
    [self closePopup];
    UIView *view = [SharedAppDelegate.root.callManager setFullOutgoing:self.uniqueid usingUid:kUsingUid];
    [SharedAppDelegate.window addSubview:view];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1)
    {
        switch (alertView.tag) {
            case kOffice:{
                [self confirmOffice];
                
            }
                break;
            case kCell:
            {
                [self confirmCell];
            }
                break;
            case kEmail:
            {
                [self confirmEmail];
            }
                break;
            case kMvoipOffice:
            {
                [self confirmMvoipOffice];
            }
                break;
            case kMvoipUid:
            {
                [self confirmMvoipUid];
                
            }
                break;
            default:
                break;
        }
    }
}

//- (void)saveContact:(NSString *)number{
//
//
//    // Create the pre-filled properties
//    ABAddressBookRef addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
//    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
//        NSLog(@"Access to contacts %@ by user", granted ? @"granted" : @"denied");
//    });
//    ABRecordRef newPerson = ABPersonCreate();
//    CFErrorRef error = NULL;
//
//    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, lblName.text, &error);
//
//    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
//    ABMultiValueAddValueAndLabel(multiPhone, number, kABPersonPhoneMobileLabel, NULL);
//    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, nil);
////    NSAssert( !error, @"Something bad happened here." );
//    ABAddressBookAddRecord(addressBook, newPerson, nil);
//    ABAddressBookSave(addressBook, nil);
//
//    // Create and set-up the new person view controller
//    //    ABNewPersonViewController* newPersonViewController = [[ABNewPersonViewController alloc] init];
//    //    [newPersonViewController setDisplayedPerson:newPerson];
//    //    [newPersonViewController setNewPersonViewDelegate:self];
//    //
//    //    // Wrap in a nav controller and display
//    //    UINavigationController *navController = [[CBNavigationController alloc] initWithRootViewController:newPersonViewController];
//    //    [self presentViewController:navController animated:YES];
//    //
//    //    // Clean up everything
//    //    [navController release];
//    //    [newPersonViewController release];
//    CFRelease(newPerson);
//    CFRelease(multiPhone);
//
//
//    [SVProgressHUD showSuccessWithStatus:@"휴대폰 주소록에 저장하였습니다."];
//
//}

- (UIImage*) maskImage:(UIImage *)image //withMask:(UIImage *)maskImage {
{
    UIImage *maskImage = [UIImage imageNamed:@"imageview_profilepopup_top_background.png"];
    
    //    CGImageRef imageRef = [image CGImage];
    //    CGImageRef maskRef = [maskImage CGImage];
    //
    //    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
    //                                        CGImageGetHeight(maskRef),
    //                                        CGImageGetBitsPerComponent(maskRef),
    //                                        CGImageGetBitsPerPixel(maskRef),
    //                                        CGImageGetBytesPerRow(maskRef),
    //                                        CGImageGetDataProvider(maskRef),
    //                                        NULL, false);
    //
    //    CGImageRef masked = CGImageCreateWithMask(imageRef, mask);
    //    CGImageRelease(mask);
    //
    //    UIImage *maskedImage = [UIImage imageWithCGImage:masked];
    //    CGImageRelease(masked);
    //    return maskedImage;
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef maskImageRef = [maskImage CGImage];
    
    // create a bitmap graphics context the size of the image
    CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    if (mainViewContentContext==NULL)
        return NULL;
    
    CGFloat ratio = 0;
    
    ratio = maskImage.size.width/ image.size.width;
    
    if(ratio * image.size.height < maskImage.size.height) {
        ratio = maskImage.size.height/ image.size.height;
    }
    
    CGRect rect1  = {{0, 0}, {maskImage.size.width, maskImage.size.height}};
    CGRect rect2  = {{-((image.size.width*ratio)-maskImage.size.width)/2 , -((image.size.height*ratio)-maskImage.size.height)/2}, {image.size.width*ratio, image.size.height*ratio}};
    
    
    CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
    CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);
    
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    
    CGImageRelease(newImage);
    
    // return the image
    return theImage;
    
}



- (void)getCustomerInfo{
    
    
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/pulmuone_mlg_ha.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           lblName.text,@"name",
                           [SharedAppDelegate.root getPureNumbers:lblPhone.text],@"cellphone",
                           //                           @"성윤경",@"name",
                           //                           @"01197192025",@"cellphone",
                           nil];
    
    
    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    NSLog(@"jsonString %@",jsonString);
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/pulmuone_mlg_ha.lemp" parametersJson:param key:@"param"];
    NSLog(@"request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            
            addressLabel.text = [NSString stringWithFormat:@"%@ %@",resultDic[@"addr1"]==nil?@"":resultDic[@"addr1"],resultDic[@"addr2"]==nil?@"":resultDic[@"addr2"]];//@"서울특별시 강남구 서초2동 우성아파트 103동 604호";
            pointLabel.text = [NSString stringWithFormat:@"%@점 (익월 소멸 예정: %@점)",resultDic[@"mlg"]==nil?@"0":resultDic[@"mlg"],resultDic[@"extinction"]==nil?resultDic[@"extinction"]:@"0"];//@"35,000점 (익월 소멸 예정: 1,210점)";
            lblPosition.text = [NSString stringWithFormat:@"고객번호: %@",resultDic[@"cust_cd"]==nil?@"":resultDic[@"cust_cd"]];
        }
        else if([isSuccess isEqualToString:@"0006"]){
            
        }
        else {
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
    
}


#ifdef Batong
- (void)updateWithDic:(NSDictionary *)dic
{
    
    NSLog(@"dic %@",dic);
    
    
    
    if([dic[@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
        inviteButton.hidden = YES;
        chatButton.hidden = YES;
        coverProfileView.hidden = YES;
        infoLabel.text = @"";
        
    }
    else if([dic[@"available"]isEqualToString:@"0"]){
        inviteButton.hidden = NO;
        inviteButton.titleLabel.text = dic[@"uniqueid"];
        chatButton.hidden = YES;
        coverProfileView.hidden = NO;
        infoLabel.text = NSLocalizedString(@"not_installed", @"not_installed");
        
    }
    else if([dic[@"available"]isEqualToString:@"4"]){
        inviteButton.hidden = YES;
        chatButton.hidden = NO;
        chatButton.enabled = NO;
        coverProfileView.hidden = NO;
        infoLabel.text = NSLocalizedString(@"logout", @"logout");
        
        
    }
    else{
        inviteButton.hidden = YES;
        chatButton.hidden = NO;
        chatButton.enabled = YES;
        coverProfileView.hidden = YES;
        infoLabel.text = @"";
    }
    
    
    lblName.text = dic[@"name"];
    
    if([dic[@"grade2"]length]>0){
        NSString *msg = [NSString stringWithFormat:@"%@ %@",dic[@"name"],dic[@"grade2"]];
    NSArray *texts=[NSArray arrayWithObjects:dic[@"name"], dic[@"grade2"],nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
        if([texts count]>1){
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:[msg rangeOfString:texts[1]]];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[msg rangeOfString:texts[1]]];
        }
           [lblName setAttributedText:string];
    }
    
    if(lblPhoneString){
//        [lblPhoneString release];
        lblPhoneString = nil;
    }
    lblPhoneString = [[NSString alloc]initWithFormat:@"%@",[SharedAppDelegate.root dashCheck:dic[@"cellphone"]]];
    NSMutableString *str1 = [[NSMutableString alloc]initWithString:lblPhoneString];
    
    if([dic[@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
        lblInfo.text = [SharedAppDelegate readPlist:@"employeinfo"];
        lblPhone.text = str1;
        
    }
    else{
        lblInfo.text = dic[@"newfield1"];
        
        lblPhone.text = str1;
        
    }
    
    [saveButton setTitle:lblName.text forState:UIControlStateDisabled];
    [saveButton setTitle:lblPhoneString forState:UIControlStateSelected];
    [saveButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
    [saveButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
    
    CGSize infosize;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:lblInfo.font, NSParagraphStyleAttributeName:paragraphStyle};
    infosize = [lblInfo.text boundingRectWithSize:CGSizeMake(midView.frame.size.width-10, 100) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    
  //  infosize = [lblInfo.text sizeWithFont:lblInfo.font constrainedToSize:CGSizeMake(midView.frame.size.width-10, 100) lineBreakMode:NSLineBreakByWordWrapping];
    lblInfo.frame = CGRectMake((midView.frame.size.width-10)/2-(infosize.width+10)/2,lblInfo.frame.origin.y,infosize.width+10, infosize.height+5);
    
    lblOffice.text = [SharedAppDelegate.root dashCheck:dic[@"companyphone"]];
    
    lblEmail.text = dic[@"email"];
    
    
    
    
    
    if([lblPhone.text length]<1){
        
        lblPhone.text = @"번호 없음";
        
        
    }
    else{
        
        
    }
    
    if([lblEmail.text length]<1){
        
        
    }
    
    else{
        
        
        
    }
    
    if([lblInfo.text length]<1){
//        balloonView.hidden = YES;
//        balloonView.frame = CGRectMake(10, CGRectGetMaxY(lblName.frame)+5, lblName.frame.size.width, 0);
        lblInfo.hidden = YES;
    }
    else{
        lblInfo.hidden = NO;
//        balloonView.hidden = NO;
//        balloonView.frame = CGRectMake(10, CGRectGetMaxY(lblName.frame)+10, lblName.frame.size.width, 20);
    }
    
    
    if([dic[@"newfield4"] isKindOfClass:[NSArray class]] && [dic[@"newfield4"]count]>1){
        
        NSString *positionstring = @"";
        for(NSString *dcode in dic[@"newfield4"]){
            
            
            
            positionstring = [positionstring stringByAppendingFormat:@"%@\n",[[ResourceLoader sharedInstance]searchCode:dcode]];
            
        }
        lblPosition.text = positionstring;
        
    }
    else{
        
        
        lblPosition.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
    }
    NSLog(@"lblPosition.text %@",lblPosition.text);
    CGSize size;
    
    paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    attributes = @{NSFontAttributeName:lblPosition.font, NSParagraphStyleAttributeName:paragraphStyle};
    size = [lblPosition.text boundingRectWithSize:CGSizeMake(positionScrollView.frame.size.width, 350) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    
    
 //   size = [lblPosition.text sizeWithFont:lblPosition.font constrainedToSize:CGSizeMake(positionScrollView.frame.size.width, 350) lineBreakMode:NSLineBreakByWordWrapping];
    
    NSLog(@"position size %@",NSStringFromCGSize(size));
    lblPosition.frame = CGRectMake(0, 0, positionScrollView.frame.size.width, size.height);
    
    NSLog(@" positionScrollView.fr3 %@",NSStringFromCGRect( positionScrollView.frame));
    positionScrollView.contentSize = CGSizeMake(positionScrollView.frame.size.width,size.height);
    
    if(size.height>42)
        positionScrollView.frame = CGRectMake(lblName.frame.origin.x,CGRectGetMaxY(lblInfo.frame)+5, lblName.frame.size.width, 42);
    else
        positionScrollView.frame = CGRectMake(lblName.frame.origin.x,CGRectGetMaxY(lblInfo.frame)+5,lblName.frame.size.width,size.height);
    
    
    NSLog(@" positionScrollView.fr4 %@",NSStringFromCGRect( positionScrollView.frame));
    
    
    self.uniqueid = dic[@"uniqueid"];
    self.userlevel = dic[@"newfield3"];
    //        available = [dicobjectForKey:@"available"];
    [SharedAppDelegate.root getProfileImageWithURL:self.uniqueid ifNil:@"profile_photo.png" view:profile scale:24];
    
    
    chatButton.frame = CGRectMake(10, CGRectGetMaxY(positionScrollView.frame)+10, positionScrollView.frame.size.width, 25);
    inviteButton.frame = chatButton.frame;
    bound.frame = CGRectMake(chatButton.frame.origin.x,CGRectGetMaxY(chatButton.frame)+10, midView.frame.size.width-20,1);
    midView.frame = CGRectMake(0, 0, backgroundView.frame.size.width, CGRectGetMaxY(bound.frame));
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(midView.frame), midView.frame.size.width, CGRectGetMaxY(emailButton.frame)+10);
    viewHeight = CGRectGetMaxY(bottomView.frame);
    backgroundView.frame = CGRectMake((320 - 260)/2,(self.view.frame.size.height - viewHeight)/2,260,viewHeight);
    
    NSLog(@"lblPosition %@",NSStringFromCGRect(lblPosition.frame));
    NSLog(@"midview %@",NSStringFromCGRect(midView.frame));
    NSLog(@"bottomView %@",NSStringFromCGRect(bottomView.frame));
    NSLog(@"backgroundView %@",NSStringFromCGRect(backgroundView.frame));
    
    
    
}

#elif defined(GreenTalk) || defined(GreenTalkCustomer)
- (void)updateWithDic:(NSDictionary *)dic
{
    NSLog(@"dic %@",dic);
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    
    if([dic[@"newfield3"]intValue]==40){
        
        greenBottomView.hidden = YES;
        customerBottomView.hidden = NO;
        titleLabel.text = @"고객 정보";
        chatButton.frame = CGRectMake(10, 10, 260 - 20, 25);
        inviteButton.frame = CGRectMake(10, 10, 260 - 20, 25);
        chatLabel.frame = CGRectMake(0, 0, chatButton.frame.size.width, chatButton.frame.size.height);
        noteButton.hidden = YES;
        inviteButton.hidden = YES;
        chatButton.hidden = NO;
    }
    else{
        greenBottomView.hidden = NO;
        customerBottomView.hidden = YES;
        titleLabel.text = @"멤버 정보";
        
        if([dic[@"available"]isEqualToString:@"0"]){
            chatButton.frame = CGRectMake(10, 130 - 85, (260 - 30)/2, 25);
            inviteButton.frame = CGRectMake(10, 130 - 85, 260 - 20, 25);
            chatLabel.frame = CGRectMake(0, 0, chatButton.frame.size.width, chatButton.frame.size.height);
            noteButton.hidden = YES;
            chatButton.hidden = YES;
            inviteButton.hidden = NO;
            inviteButton.titleLabel.text = dic[@"uniqueid"];
        }
        else{
            chatButton.frame = CGRectMake(10, 130 - 85, (260 - 30)/2, 25);
            inviteButton.frame = CGRectMake(10, 130 - 85, 260 - 20, 25);
            chatLabel.frame = CGRectMake(0, 0, chatButton.frame.size.width, chatButton.frame.size.height);
            noteButton.hidden = NO;
            inviteButton.hidden = YES;
            chatButton.hidden = NO;
            
            
        }
    }
    bound.frame = CGRectMake(chatButton.frame.origin.x,
                             CGRectGetMaxY(chatButton.frame)+12,
                             260-20,1);
    greenPhoneLabel.frame = CGRectMake(profile.frame.origin.x,
                                       CGRectGetMaxY(bound.frame)+10,
                                       45, 20);
    lblPhone.frame = CGRectMake(CGRectGetMaxX(greenPhoneLabel.frame),
                                greenPhoneLabel.frame.origin.y,
                                260 - CGRectGetMaxX(greenPhoneLabel.frame) - 10 - 15 - 60, 20);
    phoneButton.frame = CGRectMake(260 - 10 - 50,
                                   lblPhone.frame.origin.y,
                                   50, 22);
#endif
    
    if([dic[@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
        buttonView.hidden = YES;
        inviteView.hidden = YES;
        myButtonView.hidden = NO;
  favButton.hidden = YES;
        disableButtonView.hidden = YES;
        coverProfileView.hidden = YES;
        infoLabel.text = @"";
        
    }
    else if([dic[@"available"]isEqualToString:@"0"]){
        disableButtonView.hidden = YES;
        buttonView.hidden = YES;
        inviteView.hidden = NO;
        myButtonView.hidden = YES;
        
        inviteButton.titleLabel.text = dic[@"uniqueid"];
        [inviteButton addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
        inviteButton.tag = kInvite;
        //            [inviteButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_invite.png"] forState:UIControlStateNormal];
        
        
        favButton.hidden = NO;

        coverProfileView.hidden = NO;
        infoLabel.text = NSLocalizedString(@"not_installed", @"not_installed");
        
    }
    else if([dic[@"available"]isEqualToString:@"4"]){
        disableButtonView.hidden = NO;
        buttonView.hidden = YES;
        inviteView.hidden = YES;
        myButtonView.hidden = YES;
        favButton.hidden = NO;

        coverProfileView.hidden = NO;
        infoLabel.text = NSLocalizedString(@"logout", @"logout");
        
        
    }
    else{
        disableButtonView.hidden = YES;
        buttonView.hidden = NO;
        inviteView.hidden = YES;
        myButtonView.hidden = YES;
        favButton.hidden = NO;

        coverProfileView.hidden = YES;
        infoLabel.text = @"";
    }
    
    
    lblName.text = dic[@"name"];
    CGSize size = [lblName.text sizeWithAttributes:@{NSFontAttributeName:lblName.font}];
    
    if(size.width > 284 - profile.frame.origin.x - profile.frame.size.width - 40){
        lblName.numberOfLines = 2;
        CGRect nameFrame = lblName.frame;
        nameFrame.size.height = 40;
        lblName.frame = nameFrame;
    }
    else{
        lblName.numberOfLines = 1;
        CGRect nameFrame = lblName.frame;
        nameFrame.size.height = 20;
        lblName.frame = nameFrame;
    }
    lblPosition.frame = CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y + lblName.frame.size.height, lblName.frame.size.width, 14);
    
    
    if([dic[@"newfield3"]intValue]!=40){
        
        
        if([dic[@"grade2"]length]>0)
        {
            if([dic[@"team"]length]>0){
                lblPosition.text = [NSString stringWithFormat:@"%@ | %@",dic[@"grade2"],dic[@"team"]];
#ifdef Batong
                lblPosition.text = [NSString stringWithFormat:@"%@ | %@",dic[@"team"],dic[@"grade2"]];
#endif
            }
            else
                lblPosition.text = [NSString stringWithFormat:@"%@",dic[@"grade2"]];
        }
        else if([dic[@"team"]length]>0)
            lblPosition.text = [NSString stringWithFormat:@"%@",dic[@"team"]];
        else{
            lblPosition.text = @"";
        }
        
        
    }
    //    lblTeam.text = dic[@"team"];
    
    if(lblPhoneString){
//        [lblPhoneString release];
        lblPhoneString = nil;
    }
    lblPhoneString = [[NSString alloc]initWithFormat:@"%@",[SharedAppDelegate.root dashCheck:dic[@"cellphone"]]];
    NSMutableString *str1 = [[NSMutableString alloc]initWithString:lblPhoneString];
    
    if([dic[@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
        lblInfo.text = [SharedAppDelegate readPlist:@"employeinfo"];
        lblPhone.text = str1;
        
    }
    else{
        lblInfo.text = dic[@"newfield1"];
        if([str1 length]>11)
            [str1 replaceCharactersInRange:NSMakeRange([str1 length]-4, 4) withString:@"****"];
        lblPhone.text = str1;
        
    }
    [saveButton setTitle:lblName.text forState:UIControlStateDisabled];
    [saveButton setTitle:lblPhoneString forState:UIControlStateSelected];
    [saveButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
    [saveButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
    
    lblOffice.text = [SharedAppDelegate.root dashCheck:dic[@"companyphone"]];
#ifdef SbTalk
    if([dic[@"companyphone"]length] == 4)
        lblOffice.text = [NSString stringWithFormat:@"02-2241-%@",dic[@"companyphone"]];
#endif
    
    lblEmail.text = dic[@"email"];
    size = [lblEmail.text sizeWithAttributes:@{NSFontAttributeName:lblEmail.font}];
    
    if(size.width > lblPhone.frame.size.width){
        lblEmail.numberOfLines = 2;
        CGRect nameFrame = lblEmail.frame;
        nameFrame.size.height = 35;
        lblEmail.frame = nameFrame;
    }
    else{
        lblEmail.numberOfLines = 1;
        CGRect nameFrame = lblEmail.frame;
        nameFrame.size.height = 25;
        lblEmail.frame = nameFrame;
    }
    
    
    if([lblOffice.text length]<1){
        
        
        
        [officeButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_call_disabled.png"] forState:UIControlStateNormal];
        
        [officeButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_call_disabled.png"] forState:UIControlStateHighlighted];
        
    }
    
    else{
        
        [officeButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_call.png"] forState:UIControlStateNormal];
        
        
        
    }
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    //    lblPhone.text = @"010-7277-2192";
    if([lblPhone.text length]<1){
        
        lblPhone.text = @"번호 없음";
        
        
        UIImage *disabledImage = [[UIImage imageNamed:@"imageview_roundingbox_gray.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:12];
        [phoneButton setBackgroundImage:disabledImage forState:UIControlStateNormal];
        [phoneButton setBackgroundImage:disabledImage forState:UIControlStateHighlighted];
    }
    else{
        
        
        UIImage *enabledImage = [[UIImage imageNamed:@"button_profilepopup_call_green.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:12];
        [phoneButton setBackgroundImage:enabledImage forState:UIControlStateNormal];
        
    }
    
    if([lblInfo.text length]<1){
        balloonView.hidden = YES;
    }
    else{
        balloonView.hidden = NO;
    }
#else
    if([lblPhone.text length]<1){
        
        
        
        [phoneButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_call_disabled.png"] forState:UIControlStateNormal];
        
        [phoneButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_call_disabled.png"] forState:UIControlStateHighlighted];
        
    }
    else{
        
        [phoneButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_call.png"] forState:UIControlStateNormal];
        
        
        
    }
#endif
    
    if([lblEmail.text length]<1){
        
        
        
        [emailButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_email_disabled.png"] forState:UIControlStateNormal];
        
        [emailButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_email_disabled.png"] forState:UIControlStateHighlighted];
        
    }
    
    else{
        
        [emailButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_email.png"] forState:UIControlStateNormal];
        
        
        
    }
    
    
    self.uniqueid = dic[@"uniqueid"];
    self.userlevel = dic[@"newfield3"];
    //        available = [dicobjectForKey:@"available"];
    [SharedAppDelegate.root getProfileImageWithURL:self.uniqueid ifNil:@"imageview_profilepopup_defaultprofile.png" view:profile scale:24];
    //[AppID getImage:uniqueid];
    
    //	NSString *profileImageInfo = [ResourceLoader checkProfileImageWithUID:self.uniqueid];
    //	NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:profileImageInfo thumbnail:YES];
    //	NSLog(@"profileImageURL %@",imgURL);
    //	if (profileImageInfo && imgURL) {
    //		[profile setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"profilepop_profil_nophoto.png"] options:SDWebImageRetryFailed progress:^(NSUInteger receivedSize, long long expectedSize) {
    //
    //		} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    //			NSLog(@"fail %@",[error localizedDescription]);
    //			if (image != nil) {
    //				[ResourceLoader roundCornersOfImage:image scale:24 block:^(UIImage *roundedImage) {
    //					[profile setImage:roundedImage];
    //				}];
    //			}
    //		}];
    //	} else {
    //		profile.image = [UIImage imageNamed:@"profilepop_profil_nophoto.png"];
    //	}
    
    //		if(profile.image == nil)
    //            profile.image = [CustomUIKit customImageNamed:@"profilepop_profil_nophoto.png"];
    
    
    if([dic[@"favorite"] isEqualToString:@"1"])
    {
        [favButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_profilepopup_favorite.png"] forState:UIControlStateNormal];
        favButton.tag = kFavorite;

    }
    else
    {
        [favButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_profilepopup_notfavorite.png"] forState:UIControlStateNormal];
        favButton.tag = kNotFavorite;

    }

    
    //
    //    UIImage *defaultImage = [self maskImage:[CustomUIKit customImageNamed:@"imageview_defaultcover_480h.png"]];//withMask:[UIImage
    //    if(IS_HEIGHT568){
    //        defaultImage = [self maskImage:[CustomUIKit customImageNamed:@"imageview_defaultcover.png"]];// withMask:[UIImage
    //    }
    //
    //    [coverImageView setImage:defaultImage];
    //
    //
    //    NSString *imageFilePath = [NSString stringWithFormat:@"%@/Library/Caches/Covers/timelineimage_%@.jpg",NSHomeDirectory(),self.uniqueid];
    //    UIImage *savedImage = [UIImage imageWithContentsOfFile:imageFilePath];
    //    NSLog(@"image %@",savedImage);
    //    if(savedImage == nil){
    //
    //        NSString *urlString = [NSString stringWithFormat:@"https://%@/file/%@/timelineimage_%@_.jpg",[SharedAppDelegate readPlist:@"was"],self.uniqueid,self.uniqueid];
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
    //
    //            [responseData writeToFile:imageFilePath atomically:YES];
    //            UIImage *image = [UIImage imageWithData:responseData];
    //            [coverImageView setImage:[self maskImage:image]];
    //        }
    //    }
    //    else{
    //        [coverImageView setImage:[self maskImage:savedImage]];
    //        
    //    }
    
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    
    if([dic[@"newfield3"]intValue]==40){
        [self getCustomerInfo];
    }
#endif
    
    
}
#else

- (void)updateWithDic:(NSDictionary *)dic
{
    //    NSDictionary *dic = [SharedAppDelegate.root searchContactDictionary:uid];
    NSLog(@"else updatewithdic %@",dic);
    // NSLog(@"myinfo %@",[SharedAppDelegate readPlist:@"myinfo"]);
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    if(chatButton){
    chatButton.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    }
    if(myButton){
        myButton.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    }
    if(inviteButton){
        inviteButton.backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    }
    
    
    if([dic[@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
        // my profile
        
        //        buttonView.hidden = YES;
        //        inviteView.hidden = YES;
        //        myButtonView.hidden = NO;
        //        disableButtonView.hidden = YES;
        myButtonView.hidden = NO;
        buttonView.hidden = YES;
        inviteView.hidden = YES;
        coverProfileView.hidden = YES;
        infoLabel.text = @"";
     

        favButton.hidden = YES;
       

        
    }
    else if([dic[@"available"]isEqualToString:@"0"]){
        // not install - invite
        
        //        disableButtonView.hidden = YES;
        //        buttonView.hidden = YES;
        //        inviteView.hidden = NO;
        //        myButtonView.hidden = YES;
        //
        //        inviteButton.titleLabel.text = dic[@"uniqueid"];
        //        [inviteButton addTarget:self action:@selector(invite:) forControlEvents:UIControlEventTouchUpInside];
        //        inviteButton.tag = kInvite;
        //            [inviteButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_invite.png"] forState:UIControlStateNormal];
        
        [inviteButton setTitle:dic[@"uniqueid"] forState:UIControlStateHighlighted];
        [inviteButton setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
        myButtonView.hidden = YES;
        buttonView.hidden = YES;
        inviteView.hidden = NO;
        coverProfileView.hidden = NO;
        infoLabel.text = NSLocalizedString(@"not_installed", @"not_installed");
        favButton.hidden = NO;
        
        


    }
    else if([dic[@"available"]isEqualToString:@"4"]){
        // logout
        //        disableButtonView.hidden = NO;
        //        buttonView.hidden = YES;
        //        inviteView.hidden = YES;
        //        myButtonView.hidden = YES;
        //        favButton.hidden = NO;
        //
        //
        //
        //        coverProfileView.hidden = NO;
        //        infoLabel.text = NSLocalizedString(@"logout", @"logout");
        
        myButtonView.hidden = YES;
        buttonView.hidden = NO;
        inviteView.hidden = YES;
        coverProfileView.hidden = NO;
        infoLabel.text = NSLocalizedString(@"logout", @"logout");
        favButton.hidden = NO;
        
        


    }
    else{
        // normal
        
        //        disableButtonView.hidden = YES;
        //        buttonView.hidden = NO;
        //        inviteView.hidden = YES;
        //        myButtonView.hidden = YES;
        //        favButton.hidden = NO;
        //
        //        coverProfileView.hidden = YES;
        //        infoLabel.text = @"";
        
        myButtonView.hidden = YES;
        buttonView.hidden = NO;
        inviteView.hidden = YES;
        coverProfileView.hidden = YES;
        infoLabel.text = @"";
        favButton.hidden = NO;
        
        

    }
    
    lblName.text = dic[@"name"];
    CGSize size;
    
    //    CGSize size = [lblName.text sizeWithFont:lblName.font];
    //
    //    if(size.width > 284 - profile.frame.origin.x - profile.frame.size.width - 40){
    //        lblName.numberOfLines = 2;
    //        CGRect nameFrame = lblName.frame;
    //        nameFrame.size.height = 40;
    //        lblName.frame = nameFrame;
    //    }
    //    else{
    //        lblName.numberOfLines = 1;
    //        CGRect nameFrame = lblName.frame;
    //        nameFrame.size.height = 20;
    //        lblName.frame = nameFrame;
    //    }
    
    //    lblTeam.text = dic[@"team"];
    
    if(lblPhoneString){
//        [lblPhoneString release];
        lblPhoneString = nil;
    }
    lblPhoneString = [[NSString alloc]initWithFormat:@"%@",[SharedAppDelegate.root dashCheck:dic[@"cellphone"]]];
    NSMutableString *str1 = [[NSMutableString alloc]initWithString:lblPhoneString];
    
    if([dic[@"uniqueid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
        lblInfo.text = [SharedAppDelegate readPlist:@"employeinfo"];
        lblPhone.text = str1;
        
    }
    else{
        lblInfo.text = dic[@"newfield1"];
#ifdef BearTalk
#else
        if([str1 length]>11)
            [str1 replaceCharactersInRange:NSMakeRange([str1 length]-4, 4) withString:@"****"];
#endif
        lblPhone.text = str1;
        
    }
    
#ifdef BearTalk
    if([lblPhone.text length]<1)
    {
        [cellIconButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_profile_call_disable.png"] forState:UIControlStateNormal];
    }
    else{
        
        [cellIconButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_profile_call.png"] forState:UIControlStateNormal];
    }
#endif
    
    [saveButton setTitle:lblName.text forState:UIControlStateDisabled];
    [saveButton setTitle:lblPhoneString forState:UIControlStateSelected];
    [saveButton setTitleColor:[UIColor clearColor] forState:UIControlStateDisabled];
    [saveButton setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
    
    
    size = [lblInfo.text sizeWithAttributes:@{NSFontAttributeName:lblInfo.font}];
#ifdef BearTalk
#else
    if([lblInfo.text length]>0){
        infoBackgroundView.frame = CGRectMake(320/2-(size.width/2)-15,CGRectGetMaxY(lblName.frame)+5,size.width+30,28);
        lblInfo.frame = CGRectMake(15,0,infoBackgroundView.frame.size.width-30,infoBackgroundView.frame.size.height);
    }
    else{
        infoBackgroundView.frame = CGRectMake(320/2-(size.width/2)-15,CGRectGetMaxY(lblName.frame)+5,size.width+30,0);
        lblInfo.frame = CGRectMake(15,0,infoBackgroundView.frame.size.width-30,infoBackgroundView.frame.size.height);
    }
#endif
    
    
    //    size = [lblPosition.text sizeWithFont:lblPosition.font];
    
    
#ifdef BearTalk
    
    if([dic[@"newfield4"]count]>0){
        NSString *positionstring = @"";
        
        if([dic[@"grade2"]length]>0)
            positionstring = [positionstring stringByAppendingFormat:@" %@ |",dic[@"grade2"]];
        
        NSLog(@"positionstring1 %@",positionstring);
        if([dic[@"team"]length]>0)
            positionstring = [positionstring stringByAppendingFormat:@" %@ |",dic[@"team"]];
        
        NSLog(@"positionstring2 %@",positionstring);
        if([dic[@"newfield7"]length]>0)
            positionstring = [positionstring stringByAppendingFormat:@" %@ |",dic[@"newfield7"]];
        
        
        NSLog(@"positionstring3 %@",positionstring);
        if([positionstring hasSuffix:@"|"]){
            positionstring = [positionstring substringWithRange:NSMakeRange(0,[positionstring length]-1)];
        }
        NSLog(@"positionstring4 %@",positionstring);
        
        positionstring = [positionstring stringByAppendingString:@"\n"];
        
        for(NSDictionary *pdic in dic[@"newfield4"]){
            
            
            
                positionstring = [positionstring stringByAppendingFormat:@" %@/%@",pdic[@"POS_NAME"],pdic[@"DUTY_NAME"]];
            
            if([pdic[@"DEPT_NAME"]length]>0)
                positionstring = [positionstring stringByAppendingFormat:@" | %@",pdic[@"DEPT_NAME"]];
            
            if([pdic[@"COMPANY_NAME"]length]>0)
                positionstring = [positionstring stringByAppendingFormat:@" | %@",pdic[@"COMPANY_NAME"]];
            
            
            positionstring = [positionstring stringByAppendingString:@"\n"];
            
            
            NSLog(@"positionstring0 %@",positionstring);
            

        }
        
        NSLog(@"positionstring1 %@",positionstring);
        if([positionstring hasSuffix:@"\n"]){
            positionstring = [positionstring substringWithRange:NSMakeRange(0,[positionstring length]-1)];
        }
        
        NSLog(@"positionstring2 %@",positionstring);
        lblPosition.text = positionstring;
    }
    else{
        
        
        NSString *positionstring = @"";
        if([dic[@"grade2"]length]>0)
            positionstring = [positionstring stringByAppendingFormat:@" %@ |",dic[@"grade2"]];
        
        if([dic[@"team"]length]>0)
            positionstring = [positionstring stringByAppendingFormat:@" %@ |",dic[@"team"]];
        
        if([dic[@"newfield7"]length]>0)
            positionstring = [positionstring stringByAppendingFormat:@" %@ |",dic[@"newfield7"]];
        
        
        NSLog(@"positionstring3 %@",positionstring);
        if([positionstring hasSuffix:@"|"]){
            positionstring = [positionstring substringWithRange:NSMakeRange(0,[positionstring length]-1)];
        }
        NSLog(@"positionstring4 %@",positionstring);
        lblPosition.text = positionstring;
        
        
        
    }
#else
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
            
            
            
            NSLog(@"positionstring %@",positionstring);

        }
        
        if([positionstring hasSuffix:@"\n"]){
            positionstring = [positionstring substringWithRange:NSMakeRange(0,[positionstring length]-1)];
        }
        
        NSLog(@"positionstring %@",positionstring);
        lblPosition.text = positionstring;
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
        lblPosition.text = positionstring;
        
     
        
    }
#endif
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:lblPosition.font, NSParagraphStyleAttributeName:paragraphStyle};
    size = [lblPosition.text boundingRectWithSize:CGSizeMake(lblPosition.frame.size.width, 200) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    
    
 //   size = [lblPosition.text sizeWithFont:lblPosition.font constrainedToSize:CGSizeMake(lblPosition.frame.size.width, 200) lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"position size %@",NSStringFromCGSize(size));
    
    lblPosition.frame = CGRectMake(0, 0, positionScrollView.frame.size.width, size.height);
    positionScrollView.contentSize = CGSizeMake(positionScrollView.frame.size.width,size.height+5);
    
    NSLog(@" positionScrollView.fr5 %@",NSStringFromCGRect( positionScrollView.frame));
#ifdef BearTalk
#else
    if(size.height>25)
        positionScrollView.frame = CGRectMake(lblName.frame.origin.x,CGRectGetMaxY(infoBackgroundView.frame)+8, lblName.frame.size.width, 35);
    else
        positionScrollView.frame = CGRectMake(lblName.frame.origin.x,CGRectGetMaxY(infoBackgroundView.frame)+8,lblName.frame.size.width,25);
    
    NSLog(@"position size %@",NSStringFromCGRect(positionScrollView.frame));
    
    
    buttonView.frame = CGRectMake(0,CGRectGetMaxY(positionScrollView.frame),320,62);
    myButtonView.frame = buttonView.frame;
    inviteView.frame = buttonView.frame;
    
#endif
    
    
    lblOffice.text = [SharedAppDelegate.root dashCheck:dic[@"companyphone"]];
    
#ifdef BearTalk
    if([lblOffice.text length]<1)
    {
        [officeIconButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_profile_call_disable.png"] forState:UIControlStateNormal];
    }
    else{
        
        [officeIconButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_profile_call.png"] forState:UIControlStateNormal];
    }
#elif SbTalk
    if([dic[@"companyphone"]length]==4)
        lblOffice.text = [NSString stringWithFormat:@"02-2241-%@",dic[@"companyphone"]];
#endif
    
    lblEmail.text = dic[@"email"];
    
#ifdef BearTalk
    if([lblEmail.text length]<1)
    {
        [emailIconButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_profile_mail_disable.png"] forState:UIControlStateNormal];
    }
    else{
        [emailIconButton setBackgroundImage:[CustomUIKit customImageNamed:@"btn_profile_mail.png"] forState:UIControlStateNormal];
        
    }
#endif
    //    size = [lblEmail.text sizeWithFont:lblEmail.font];
    //
    //    if(size.width > lblPhone.frame.size.width){
    //        lblEmail.numberOfLines = 2;
    //        CGRect nameFrame = lblEmail.frame;
    //        nameFrame.size.height = 35;
    //        lblEmail.frame = nameFrame;
    //    }
    //    else{
    //        lblEmail.numberOfLines = 1;
    //        CGRect nameFrame = lblEmail.frame;
    //        nameFrame.size.height = 25;
    //        lblEmail.frame = nameFrame;
    //    }
    //
    //
    //
    //    if([lblOffice.text length]<1){
    //
    //
    //
    //        [officeButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_call_disabled.png"] forState:UIControlStateNormal];
    //
    //        [officeButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_call_disabled.png"] forState:UIControlStateHighlighted];
    //
    //    }
    //
    //    else{
    //
    //        [officeButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_call.png"] forState:UIControlStateNormal];
    //
    //
    //
    //    }
    //
    //    if([lblPhone.text length]<1){
    //
    //
    //
    //        [phoneButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_call_disabled.png"] forState:UIControlStateNormal];
    //
    //        [phoneButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_call_disabled.png"] forState:UIControlStateHighlighted];
    //
    //    }
    //
    //    else{
    //
    //        [phoneButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_call.png"] forState:UIControlStateNormal];
    //
    //
    //
    //    }
    //
    //    if([lblEmail.text length]<1){
    //
    //
    //
    //        [emailButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_email_disabled.png"] forState:UIControlStateNormal];
    //
    //        [emailButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_email_disabled.png"] forState:UIControlStateHighlighted];
    //
    //    }
    //
    //    else{
    //
    //        [emailButton setBackgroundImage:[UIImage imageNamed:@"button_profilepopup_email.png"] forState:UIControlStateNormal];
    //
    //
    //
    //    }
    
    
    self.uniqueid = dic[@"uniqueid"];
    //        available = [dicobjectForKey:@"available"];

    //[AppID getImage:uniqueid];
    
    //	NSString *profileImageInfo = [ResourceLoader checkProfileImageWithUID:self.uniqueid];
    //	NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:profileImageInfo thumbnail:YES];
    //	NSLog(@"profileImageURL %@",imgURL);
    //	if (profileImageInfo && imgURL) {
    //		[profile setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"profilepop_profil_nophoto.png"] options:SDWebImageRetryFailed progress:^(NSUInteger receivedSize, long long expectedSize) {
    //
    //		} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    //			NSLog(@"fail %@",[error localizedDescription]);
    //			if (image != nil) {
    //				[ResourceLoader roundCornersOfImage:image scale:24 block:^(UIImage *roundedImage) {
    //					[profile setImage:roundedImage];
    //				}];
    //			}
    //		}];
    //	} else {
    //		profile.image = [UIImage imageNamed:@"profilepop_profil_nophoto.png"];
    //	}
    
    //		if(profile.image == nil)
    //            profile.image = [CustomUIKit customImageNamed:@"profilepop_profil_nophoto.png"];
    
    
    if([dic[@"favorite"] isEqualToString:@"1"])
    {
#ifdef BearTalk
        NSLog(@"favorite_1");
        [favButton setBackgroundImage:[UIImage imageNamed:@"btn_profile_bookmark_on.png"] forState:UIControlStateNormal];
     
#else
        [favButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_profilepopup_favorite.png"] forState:UIControlStateNormal];
#endif
        favButton.tag = kFavorite;
    }
    else
    {
#ifdef BearTalk
        
        NSLog(@"favorite_0");
        [favButton setBackgroundImage:[UIImage imageNamed:@"btn_profile_bookmark_off.png"] forState:UIControlStateNormal];
    
#else
        [favButton setBackgroundImage:[CustomUIKit customImageNamed:@"button_profilepopup_notfavorite.png"] forState:UIControlStateNormal];
#endif
        favButton.tag = kNotFavorite;
    }
    
    
    
#ifdef BearTalk

    
    
    NSString *leave_type = dic[@"newfield5"];
    holidayLabel.text = leave_type;
    
    if([leave_type length]>0){
        NSLog(@"leave_type %@",leave_type);
        if([leave_type hasPrefix:@"출산"])
            holidayView.image = [CustomUIKit customImageNamed:@"imageview_profile_popup_baby.png"];
        else if([leave_type hasPrefix:@"육아"])
            holidayView.image = [CustomUIKit customImageNamed:@"imageview_profile_popup_feed.png"];
        else if([leave_type hasPrefix:@"질병"])
            holidayView.image = [CustomUIKit customImageNamed:@"imageview_profile_popup_disease.png"];
        else
            holidayView.image = [CustomUIKit customImageNamed:@"imageview_profile_popup_etc.png"];
    }
    else{
        
        
        holidayView.image = nil;
    }
#endif
    
    
#ifdef BearTalk
    
    [SharedAppDelegate.root getProfileImageWithURL:self.uniqueid ifNil:nil view:coverImageView scale:1];
    [SharedAppDelegate.root getProfileImageWithURL:self.uniqueid ifNil:@"imageview_profilepopup_defaultprofile.png" view:profile scale:0];
    
#elif defined(LempMobileNowon) || defined(SbTalk)
    UIImage *defaultImage = [CustomUIKit customImageNamed:@"imageview_defaultcover.png"];//withMask:[UIImage
    //    if(IS_HEIGHT568){
    //        defaultImage = [CustomUIKit customImageNamed:@"imageview_defaultcover.png"];// withMask:[UIImage
    //    }
    
    [coverImageView setImage:defaultImage];
    
    
    NSString *imageFilePath = [NSString stringWithFormat:@"%@/Library/Caches/Covers/timelineimage_%@.jpg",NSHomeDirectory(),self.uniqueid];
    UIImage *savedImage = [UIImage imageWithContentsOfFile:imageFilePath];
    NSLog(@"image %@",savedImage);
    if(savedImage == nil){
        NSString *urlString = [NSString stringWithFormat:@"https://%@/file/%@/timelineimage_%@_.jpg",[SharedAppDelegate readPlist:@"was"],self.uniqueid,self.uniqueid];
        NSLog(@"urlString %@",urlString);
        NSURL *imgURL = [NSURL URLWithString:urlString];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:imgURL];
        NSHTTPURLResponse* response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        NSInteger statusCode = [response statusCode];
        NSLog(@"statusCode %d",(int)statusCode);
        
        
        if(statusCode == 404){
        }
        else{
            
            [responseData writeToFile:imageFilePath atomically:YES];
            UIImage *image = [UIImage imageWithData:responseData];
            [coverImageView setImage:image];
        }
    }
    else{
        [coverImageView setImage:savedImage];
        
    }
    
    [SharedAppDelegate.root getProfileImageWithURL:self.uniqueid ifNil:@"imageview_profilepopup_defaultprofile.png" view:profile scale:24];
#else
    [SharedAppDelegate.root getProfileImageWithURL:self.uniqueid ifNil:@"imageview_profilepopup_defaultprofile.png" view:profile scale:24];
    [SharedAppDelegate.root getCoverImage:self.uniqueid view:coverImageView ifnil:@""];
    
#endif
    

    
}
#endif
//- (void)dealloc {
    //    [lblPhone release];
    //    [lblOffice release];
    //    [lblEmail release];
    //    [name release];
    //    [position release];
    //    [team release];
    //    [office release];
    //    [email release];
    //    [numVoip release];
    //    [uniqueid release];
//    [super dealloc];
//}


@end
