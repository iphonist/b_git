//
//  ProfileView.h
//  LEMPMobile
//
//  Created by Hyemin Kim on 12. 1. 31..
//  Copyright 2012 Benchbee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ProfileView : UIViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, ABNewPersonViewControllerDelegate>{
    
    float viewHeight;
    UIImageView *bottomView;
    UIImageView *midView;
    UIImageView *backgroundView;
		UILabel *lblName;
		UILabel *lblPosition;
//		UILabel *department;
    UILabel *lblaPosition;
    UILabel *lblInfo;
		UILabel *lblPhone;
		UILabel *lblOffice;
    UILabel *lblEmail;
//		NSString *phone;
//		NSString *office;
//		NSString *email;
//		NSString *numVoip;
//		NSString *purePeer;
//		NSString *index;
    NSString *uniqueid;
    NSString *userlevel;

//		BOOL favorite;
    UIButton *favButton;
    UIImageView *holidayView;
    UILabel *holidayLabel;
//		UIButton *clearFavButton;
//		int tagInfo;
//		int otherInfo;
		UIImageView *profile;
//		NSArray *subArray;
//		UIScrollView *scrollView;
//		NSString *appUse;
//		NSString *available;
//    NSDictionary *yourDic;
    
    UIView *buttonView;
    UIView *disableButtonView;
    UIView *myButtonView;
    UIView *inviteView;
    UIButton *inviteButton;
    UIButton *myButton;
    NSString *lblPhoneString;
    UIImageView *coverImageView;
    UIButton *officeButton;
    UIButton *phoneButton;
    UIButton *noteButton;
    UIButton *chatButton;
    UIButton *emailButton;
    UILabel *chatLabel;
    UIImageView *coverProfileView;
    UILabel *infoLabel;
    UINavigationController *specificNavicon;
    UIImageView *balloonView;
    UIView *greenBottomView;
    UIView *customerBottomView;
    UILabel *titleLabel;
    UIImageView *bound;
    UILabel *greenPhoneLabel;
    UILabel *addressLabel;
    UILabel *pointLabel;
    
    
    
    UIImageView *infoBackgroundView;
    UIScrollView *positionScrollView;
    UIImageView *checkView;
    
    UIButton *saveButton;
    UIButton *cellIconButton;
    UIButton *officeIconButton;
    UIButton *emailIconButton;
}

//- (void)hideDisableViewOverlay;
- (void)updateWithDic:(NSDictionary *)dic;
- (void)closePopup;
- (void)confirmCell2:(id)sender;

@property (retain) NSString *uniqueid;
@property (retain) NSString *userlevel;


@end
