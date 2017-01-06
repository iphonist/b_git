//
//  LoginModalViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 7. 25..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "ChangeLoginPasswordViewController.h"
#import "AESExtention.h"

@interface ChangeLoginPasswordViewController ()

@end

@implementation ChangeLoginPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



#define kVerifyPin 2
#define kRequestPinAgain 5
#define kReport 1
#define kRequestPinAtSetup 30
#define kMissPincode 6
#define kCancel 100

#define kPassword 100
#define kPasswordAgain 200
#define kPin 300

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
#ifdef BearTalk
    self.view.backgroundColor = RGB(238, 242, 245);
#endif
    
    
}


- (void)cancel{
    NSLog(@"cancel");
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.translucent = NO;

    [self enterPassword];
 
}


- (void)checkPincode{
    
    [SharedAppDelegate.root resetUserPwd:kVerifyPin con:self code:pintextField.text pw:@""];
}


- (void)requestPincode{
    
    [SharedAppDelegate.root resetUserPwd:kRequestPinAtSetup con:self code:@"" pw:@""];
}
- (void)enterPincode{
    
    
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(checkEmail)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkPincode) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"barbutton_done.png" imageNamedPressed:nil];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    
    if(transView){
        [transView removeFromSuperview];
        //        [transView release];
        transView = nil;
    }
    
    
    transView = [[UIView alloc]initWithFrame:self.view.frame];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    
    
    UILabel *label = [CustomUIKit labelWithText:@"아이디로 입력한 이메일로 인증메일이 발송되었습니다. 이메일을 확인해 발송된 인증번호를 입력해 주세요." fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(15, VIEWY+10, 320 - 30, 40) numberOfLines:3 alignText:NSTextAlignmentLeft];
    [transView addSubview:label];
    
    
    
    UIImageView *imageView = [[UIImageView alloc]init];//WithFrame:CGRectMake(320-35-20, 20, 35, 45)];//185
    imageView.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame)+10, label.frame.size.width, 34);
    
    imageView.image = [[UIImage imageNamed:@"imageview_login_textfield_background_grayfull.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30];
    [transView addSubview:imageView];
//    [imageView release];
    
    UILabel *emailLabel = [[UILabel alloc]init];
    emailLabel.frame = CGRectMake(5, 5, imageView.frame.size.width - 10, imageView.frame.size.height - 10);
    emailLabel.font = [UIFont systemFontOfSize:14];
    emailLabel.textColor = [UIColor grayColor];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = [SharedAppDelegate readPlist:@"email"];
    emailLabel.adjustsFontSizeToFitWidth = NO;
    [imageView addSubview:emailLabel];
//    [emailLabel release];
    
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(imageView.frame)+10, 270, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
//    [textFieldImageView release];
    
   
    
    pintextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 3, textFieldImageView.frame.size.width - 17, textFieldImageView.frame.size.height - 6)]; // 180
    pintextField.backgroundColor = [UIColor clearColor];
    pintextField.delegate = self;
    pintextField.placeholder = @"인증번호 입력";
    pintextField.clearButtonMode = UITextFieldViewModeAlways;
    pintextField.keyboardType = UIKeyboardTypeNumberPad;
    [textFieldImageView addSubview:pintextField];
    pintextField.tag = kPin;
    [pintextField becomeFirstResponder];
    
    
    NSString *str = @"인증메일을 받지 못하셨나요?";
    
    UILabel *resendEmailLabel = [CustomUIKit labelWithText:str
                                                  fontSize:14 fontColor:[UIColor grayColor]
                                                     frame:CGRectMake(0, CGRectGetMaxY(textFieldImageView.frame) + 10, 320, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    resendEmailLabel.userInteractionEnabled = YES;
    
    
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [str length])];
        
        // Set background color for entire range
        [attributedString addAttribute:NSBackgroundColorAttributeName
                                 value:[UIColor clearColor]
                                 range:NSMakeRange(0, [attributedString length])];
        [resendEmailLabel setAttributedText:attributedString];
    
    
    [transView addSubview:resendEmailLabel];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)  frame:CGRectMake(0, 0, resendEmailLabel.frame.size.width, resendEmailLabel.frame.size.height) imageNamedBullet:nil // 179
                         imageNamedNormal:nil imageNamedPressed:nil];
    button.tag = kMissPincode;
    [resendEmailLabel addSubview:button];
//    [button release];
    
}

- (void)enterPassword{// image:(NSString *)img{
    
    
    
    self.title = @"비밀번호 변경";
    
    
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkPasswordToServer) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"barbutton_done.png" imageNamedPressed:nil];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    //    self.view.tag = kVerified;
    
    if(transView){
        [transView removeFromSuperview];
//                [transView release];
        transView = nil;
    }
    
    
    transView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];

    
    
    UILabel *label = [CustomUIKit labelWithText:@"정보 보호를 위해 현재 비밀번호를 확인해주세요." fontSize:14 fontColor:[UIColor blackColor]
                                                    frame:CGRectMake(15, VIEWY+10, self.view.frame.size.width - 30, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
  

    [transView addSubview:label];
    
    
    UIImageView *imageView = [[UIImageView alloc]init];//WithFrame:CGRectMake(320-35-20, 20, 35, 45)];//185
    imageView.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame)+10, label.frame.size.width, 34);
    
    imageView.image = [[UIImage imageNamed:@"imageview_login_textfield_background_grayfull.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30];
    [transView addSubview:imageView];
//    [imageView release];
    
    UILabel *emailLabel = [[UILabel alloc]init];
    emailLabel.frame = CGRectMake(5, 5, imageView.frame.size.width - 10, imageView.frame.size.height - 10);
    emailLabel.font = [UIFont systemFontOfSize:14];
    emailLabel.textColor = [UIColor grayColor];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = [SharedAppDelegate readPlist:@"email"];
    emailLabel.adjustsFontSizeToFitWidth = NO;
    [imageView addSubview:emailLabel];
//    [emailLabel release];
    
    
    
    
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame)+10, imageView.frame.size.width, imageView.frame.size.height)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    textFieldImageView.userInteractionEnabled = YES;
//    [textFieldImageView release];
    
    pwTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 3, textFieldImageView.frame.size.width - 17, textFieldImageView.frame.size.height - 6)]; // 180
    pwTextField.backgroundColor = [UIColor clearColor];
    pwTextField.delegate = self;
    pwTextField.placeholder = @"현재 비밀번호 입력";
    pwTextField.secureTextEntry = YES;
    pwTextField.clearButtonMode = UITextFieldViewModeAlways;
    [textFieldImageView addSubview:pwTextField];
    //    pwTextField.keyboardType = UIKeyboardTypeNumberPad;
    [pwTextField becomeFirstResponder];
    //    [pwTextField release];
    
    
    
    
    NSString *str = @"비밀번호가 생각이 나지 않으시나요?";
    
    label = [CustomUIKit labelWithText:str
                                       fontSize:14 fontColor:[UIColor grayColor]
                                          frame:CGRectMake(0, CGRectGetMaxY(textFieldImageView.frame)+15, 320, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    label.userInteractionEnabled = YES;
    
    
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [str length])];
        
        // Set background color for entire range
        [attributedString addAttribute:NSBackgroundColorAttributeName
                                 value:[UIColor clearColor]
                                 range:NSMakeRange(0, [attributedString length])];
        [label setAttributedText:attributedString];
    
    
    [transView addSubview:label];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkEmail)
                                              frame:CGRectMake(0, 0, label.frame.size.width, label.frame.size.height) imageNamedBullet:nil // 179
                                   imageNamedNormal:nil imageNamedPressed:nil];
    [label addSubview:button];

    
    
 
}

- (void)checkEmail{
    
    
    self.title = @"비밀번호 변경";
    
    
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(enterPassword)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(requestPincode) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"barbutton_done.png" imageNamedPressed:nil];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    //    self.view.tag = kVerified;
    
    if(transView){
        [transView removeFromSuperview];
        //        [transView release];
        transView = nil;
    }
    
    
    transView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    
    
    UILabel *label = [CustomUIKit labelWithText:@"아이디로 입력한 이메일 주소로 인증메일이 발송됩니다. 이메일을 확인해주세요." fontSize:14 fontColor:[UIColor blackColor] frame:CGRectMake(15, VIEWY+10, self.view.frame.size.width - 30, 40) numberOfLines:2 alignText:NSTextAlignmentLeft];
    
    
    [transView addSubview:label];
    
    
    UIImageView *imageView = [[UIImageView alloc]init];//WithFrame:CGRectMake(320-35-20, 20, 35, 45)];//185
    imageView.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame)+10, label.frame.size.width, 34);
    
    imageView.image = [[UIImage imageNamed:@"imageview_login_textfield_background_grayfull.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30];
    [transView addSubview:imageView];
//    [imageView release];
    
    UILabel *emailLabel = [[UILabel alloc]init];
    emailLabel.frame = CGRectMake(5, 5, imageView.frame.size.width - 10, imageView.frame.size.height - 10);
    emailLabel.font = [UIFont systemFontOfSize:14];
    emailLabel.textColor = [UIColor grayColor];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = [SharedAppDelegate readPlist:@"email"];
    emailLabel.adjustsFontSizeToFitWidth = NO;
    [imageView addSubview:emailLabel];
//    [emailLabel release];
    
    
    

}

- (void)reCreatePassword{
    
    //    self.view.tag = kNotVerify;
    NSLog(@"reCreatePassword");
    
    
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(enterPassword)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(checkPassword) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"barbutton_done.png" imageNamedPressed:nil];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    if(transView){
        [transView removeFromSuperview];
        //        [transView release];
        transView = nil;
    }
    
    
    transView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    
    
    
    
    UILabel *loginLabel = [CustomUIKit labelWithText:@"새로운 비밀번호를 입력해주세요.\n(영문 대/소문자, 숫자, 허용된 특수문자, 4~25자)\n특수문자 : #$%&'()*+,./:;<=>?@^_`{|}~-" fontSize:15 fontColor:[UIColor blackColor]
                                               frame:CGRectMake(15, VIEWY+10, self.view.frame.size.width - 30, 60) numberOfLines:3 alignText:NSTextAlignmentLeft];
    [transView addSubview:loginLabel];
    
    
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, loginLabel.frame.origin.y + loginLabel.frame.size.height + 5, 270, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    
    pwTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldImageView.frame.origin.x + 10, textFieldImageView.frame.origin.y + 3, textFieldImageView.frame.size.width - 17, textFieldImageView.frame.size.height - 6)]; // 180
    pwTextField.backgroundColor = [UIColor clearColor];
    pwTextField.delegate = self;
    pwTextField.placeholder = @"비밀번호 입력";
    pwTextField.secureTextEntry = YES;
    pwTextField.tag = kPassword;
    pwTextField.clearButtonMode = UITextFieldViewModeAlways;
    [transView addSubview:pwTextField];
//    [textFieldImageView release];
    
    //    pwTextField.keyboardType = UIKeyboardTypeNumberPad;
    [pwTextField becomeFirstResponder];
    //    [pwTextField release];
    
    
    textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, loginLabel.frame.origin.y + loginLabel.frame.size.height + 5 + 33 + 5, 270, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    
    checkTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldImageView.frame.origin.x + 10, textFieldImageView.frame.origin.y + 3, textFieldImageView.frame.size.width - 17, textFieldImageView.frame.size.height - 6)]; // 180
    checkTextField.backgroundColor = [UIColor clearColor];
    checkTextField.placeholder = @"비밀번호 재입력";
    checkTextField.delegate = self;
    checkTextField.tag = kPasswordAgain;
    checkTextField.secureTextEntry = YES;
    checkTextField.clearButtonMode = UITextFieldViewModeAlways;
    [transView addSubview:checkTextField];
    //    pwTextField.keyboardType = UIKeyboardTypeNumberPad;
    //    [pwTextField becomeFirstResponder];
//    [checkTextField release];
//    [textFieldImageView release];
    
    
    
    
}



- (void)checkPasswordToServer{//:(NSString *)pw{
    
    if([pwTextField.text length]<1){
        
        OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"비밀번호를 입력해주세요."];
        toast.position = OLGhostAlertViewPositionCenter;
        toast.style = OLGhostAlertViewStyleDark;
        toast.timeout = 2.0;
        toast.dismissible = YES;
        [toast show];
//        [toast release];
        return;
    }
    
    //    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/install.lemp",[SharedAppDelegate readPlist:@"ipaddress"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [SharedAppDelegate readPlist:@"email"],@"authid",
                                [pwTextField.text length]>0?pwTextField.text:@"",@"password",@"2",@"installtype",nil];//@{ @"uniqueid" : @"c112256" };
    
    NSLog(@"parameters %@",parameters);
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"lemp/auth/install.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            [self reCreatePassword];
            pwTextField.text = @"";
            
            
        }
        else {
            pwTextField.text = @"";
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            //            [alert show];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        pwTextField.text = @"";
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
    
    
    
}


- (void)checkPassword{
    
    NSLog(@"pwtext %@ check %@",pwTextField.text,checkTextField.text);
    
    if([pwTextField.text length]<1){
        
        OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"변경할 비밀번호를 입력해주세요."];
        toast.position = OLGhostAlertViewPositionCenter;
        toast.style = OLGhostAlertViewStyleDark;
        toast.timeout = 2.0;
        toast.dismissible = YES;
        [toast show];
//        [toast release];
        
    }
    else if([self validPassword:pwTextField.text] == NO){
        // it is not right
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"비밀번호는 영문 대/소문자, 숫자, 허용된 특수문자 4~25자만 가능합니다." con:self];
    }
    else if([pwTextField.text isEqualToString:checkTextField.text]){
        
        
        NSString *encPassword = [AESExtention aesEncryptString:pwTextField.text];
        [SharedAppDelegate writeToPlist:@"loginpassword" value:encPassword];
        
        NSLog(@"AES Enc : %@",encPassword);
        
        [self changePasswordAtSetup:pwTextField.text];
    }
    else{
        [CustomUIKit popupSimpleAlertViewOK:@"비밀번호 변경" msg:@"비밀번호가 일치하지 않습니다.\n입력한 내용을 다시 확인해주세요." con:self];
        //        [checkLabel performSelectorOnMainThread:@selector(setText:) withObject:@"일치하지 않습니다." waitUntilDone:NO];
        return;
    }
}

- (void)changePasswordAtSetup:(NSString *)pw{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    //    NSString *url = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"ipaddress"]];
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/auth/changepasswd.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           pw,@"passwd",
                           nil];//@{ @"uniqueid" : @"c110256" };
    
    
    //    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/pulmuone_retirement.lemp" parametersJson:param key:@"param"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"1");
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"비밀번호 변경"
                                                                               message:@"비밀번호가 변경되었습니다.\n\n변경된 비밀번호는 로그아웃 하신 후,\n다시 로그인 하실 때부터 적용됩니다."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action){
                                                               
                                                               [self cancel];
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
                
                
                [alert addAction:ok];
                //        [self presentViewController:alert animated:YES completion:nil];
                [SharedAppDelegate.root anywhereModal:alert];
                
            }
            
            else{
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"비밀번호 변경" message:@"비밀번호가 변경되었습니다.\n\n변경된 비밀번호는 로그아웃 하신 후,\n다시 로그인 하실 때부터 적용됩니다." delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            alert.tag = kCancel;
            [alert show];
//            [alert release];
            }
            
            
            
            
        } else {
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"확인", nil];
            //            [alert show];
            //
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL allowInput = YES;
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSLog(@"newLength %d",(int)newLength);
    if(textField.tag == kPin){
        if(newLength > 6){
            allowInput = NO;
        }
        else if(newLength == 6){
            buttonOK.enabled = YES;
        }
        else{
            buttonOK.enabled = NO;
        }
    }
    return allowInput;
}



- (void)cmdButton:(id)sender{
    switch ([sender tag]) {
            
        case kRequestPinAgain:{
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"인증메일 재발송"
                                                                                         message:@"메일을 받지 못하셨나요?\n스팸편지함 혹은 휴지통 등의 편지함을 확인해보세요. 메일서비스에 따라 메일이 도착하기 까지 다소 시간이 걸릴 수 있습니다.\n\n'재발송'을 선택하면 이메일 주소로 인증메일을 다시 발송합니다."
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okb = [UIAlertAction actionWithTitle:@"재발송"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){
                                                                
                                                                
                                                                [SharedAppDelegate.root resetUserPwd:kRequestPinAgain con:self code:@"" pw:@""];
                                                                
                                                                [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                            }];
                
                UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"취소"
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
                alert = [[UIAlertView alloc] initWithTitle:@"인증메일 재발송" message:@"메일을 받지 못하셨나요?\n스팸편지함 혹은 휴지통 등의 편지함을 확인해보세요. 메일서비스에 따라 메일이 도착하기 까지 다소 시간이 걸릴 수 있습니다.\n\n'재발송'을 선택하면 이메일 주소로 인증메일을 다시 발송합니다." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"재발송", nil];
                alert.tag = [sender tag];
                [alert show];
//                [alert release];
            }
        }
            break;
        case kReport:{
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
                
                UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"인증메일 미수신"
                                                                                         message:@"메일 미수신 신고하기\n메일서비스에 따라 메일이 도착하기 까지 다소 시간이 걸릴 수 있습니다.\n\n2시간이 지나도 이메일이 오지 않았다면 아래의 '신고하기'버튼을 눌러주세요. 최대한 빠른시간내에 조치해 드리겠습니다."
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *okb = [UIAlertAction actionWithTitle:@"신고하기"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action){
                                                                
                                                                
                                                                [SharedAppDelegate.root resetUserPwd:kReport con:self code:@"" pw:@""];
                                                                
                                                                [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                            }];
                
                UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"취소"
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
                alert = [[UIAlertView alloc] initWithTitle:@"인증메일 미수신" message:@"메일 미수신 신고하기\n메일서비스에 따라 메일이 도착하기 까지 다소 시간이 걸릴 수 있습니다.\n\n2시간이 지나도 이메일이 오지 않았다면 아래의 '신고하기'버튼을 눌러주세요. 최대한 빠른시간내에 조치해 드리겠습니다." delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"신고하기", nil];
                alert.tag = [sender tag];
                [alert show];
//                [alert release];
            }
        }
            break;
        case kVerifyPin:{
            
            [SharedAppDelegate.root resetUserPwd:(int)[sender tag] con:self code:pintextField.text pw:@""];
        }
        default:
            break;
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(alertView.tag == kRequestPinAgain){
            
            [SharedAppDelegate.root resetUserPwd:(int)alertView.tag con:self code:@"" pw:@""];
        }
        else if(alertView.tag == kReport){
            
            [SharedAppDelegate.root resetUserPwd:(int)alertView.tag con:self code:@"" pw:@""];
        }
        else if(alertView.tag == kCancel){
            [self cancel];
        }
        
    }
}



- (BOOL)validPassword:(NSString*)pwString{
    
    NSString *regExPattern = @"[A-Z0-9a-z!\"#$%&'()*+,./:;<=>?@^_`{|}~-]{4,25}";
    // ^[a-zA-Z0-9]+$
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:pwString options:0 range:NSMakeRange(0, [pwString length])];
    
    NSLog(@"%i", (int)regExMatches);
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL) textFieldShouldClear:(UITextField *)textField{
    if(textField.tag == kPin)
        buttonOK.enabled = NO;
    
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
