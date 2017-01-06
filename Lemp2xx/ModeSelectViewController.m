//
//  CSRequestViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 12. 9..
//  Copyright © 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "ModeSelectViewController.h"


@implementation ModeSelectViewController




- (void)cancel{
    NSLog(@"cancel!!!!!!!!!!!!!!!!");
    [self  dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [self settingView];
}
- (id)init
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)settingView{
    
    
    
    NSLog(@"settingView");
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"모드 설정";
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    UIImageView *borderView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, self.view.frame.size.width-30, 40)]; // 180
    [self.view addSubview:borderView];
    borderView.image = [[UIImage imageNamed:@"imageview_border_green.png"]stretchableImageWithLeftCapWidth:18 topCapHeight:15];
    borderView.userInteractionEnabled = YES;
//    [borderView release];
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(borderView.frame.size.width/2, 5, 1, borderView.frame.size.height - 10)]; // 180
    [borderView addSubview:lineView];
    lineView.backgroundColor = GreenTalkColor;
    lineView.userInteractionEnabled = YES;
//    [lineView release];
    
    
    defaultButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(selectDefault) frame:CGRectMake(5, 2, 35, 35) imageNamedBullet:nil imageNamedNormal:@"radio_dft.png" imageNamedPressed:nil];
    [borderView addSubview:defaultButton];
    defaultButton.adjustsImageWhenHighlighted = NO;
    
    specialButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(selectSpecial) frame:CGRectMake(CGRectGetMaxX(lineView.frame)+5, defaultButton.frame.origin.y, defaultButton.frame.size.width, defaultButton.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"radio_dft.png" imageNamedPressed:nil];
    [borderView addSubview:specialButton];
    specialButton.adjustsImageWhenHighlighted = NO;
    
    if([[SharedAppDelegate readPlist:@"ocrmode"]isEqualToString:@"1"]){
        [defaultButton setBackgroundImage:[UIImage imageNamed:@"radio_prs.png"] forState:UIControlStateNormal];
    }
    else if([[SharedAppDelegate readPlist:@"ocrmode"]isEqualToString:@"2"]){
        [specialButton setBackgroundImage:[UIImage imageNamed:@"radio_prs.png"] forState:UIControlStateNormal];
    }
    
    UILabel *defaultlabel;
    defaultlabel = [CustomUIKit labelWithText:@"기본모드" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(CGRectGetMaxX(defaultButton.frame), 0, 100, 40) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [borderView addSubview:defaultlabel];
    
    
    UILabel *specialLabel;
    specialLabel = [CustomUIKit labelWithText:@"제조일검사모드" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(CGRectGetMaxX(specialButton.frame), 0, 100, 40) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [borderView addSubview:specialLabel];
    
    
    UILabel *explainLabel;
    explainLabel = [CustomUIKit labelWithText:@"1. 기본모드\n - 일반적인 일부인 검사로 날인된 제조일자,\n유통기한을 인식하여 검사할 때 사용\n\n2. 제조일검사모드\n - 유통기한을 날인하지 않고 제조일자만 날인하는\n경우 사용\n- 검사 가능 품목 : 나물, 얼음, 수출품 일부" fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(15, CGRectGetMaxY(borderView.frame)+15, self.view.frame.size.width-30, 150) numberOfLines:9 alignText:NSTextAlignmentLeft];
    [self.view addSubview:explainLabel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}


- (void)selectDefault{
    [SharedAppDelegate writeToPlist:@"ocrmode" value:@"1"];
    [defaultButton setBackgroundImage:[UIImage imageNamed:@"radio_prs.png"] forState:UIControlStateNormal];
    [specialButton setBackgroundImage:[UIImage imageNamed:@"radio_dft.png"] forState:UIControlStateNormal];
    
    OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"스캔모드가 변경되었습니다."];
    toast.position = OLGhostAlertViewPositionCenter;
    toast.style = OLGhostAlertViewStyleDark;
    toast.timeout = 2.0;
    toast.dismissible = YES;
    [toast show];
//    [toast release];
}

- (void)selectSpecial{
    [SharedAppDelegate writeToPlist:@"ocrmode" value:@"2"];
    [defaultButton setBackgroundImage:[UIImage imageNamed:@"radio_dft.png"] forState:UIControlStateNormal];
    [specialButton setBackgroundImage:[UIImage imageNamed:@"radio_prs.png"] forState:UIControlStateNormal];
    
    
    OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"스캔모드가 변경되었습니다."];
    toast.position = OLGhostAlertViewPositionCenter;
    toast.style = OLGhostAlertViewStyleDark;
    toast.timeout = 2.0;
    toast.dismissible = YES;
    [toast show];
//    [toast release];
}


@end
