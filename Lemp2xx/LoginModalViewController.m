//
//  LoginModalViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 7. 25..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "LoginModalViewController.h"
#import "AESExtention.h"

@interface LoginModalViewController ()

@end

@implementation LoginModalViewController

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
#define kChangePwd 4
#define kCheckPassword 3

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


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
#ifdef MQM
#else
    [SVProgressHUD showSuccessWithStatus:@"발송 완료"];
#endif
    self.title = @"인증번호 입력";
    
//    UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    CGRect frame = CGRectMake(0, 0, 320, self.view.frame.size.height);
    
    transView = [[UIView alloc]initWithFrame:frame];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    
    NSString *msg =[NSString stringWithFormat:@"%@\n으로 인증번호가 발송되었습니다.",[SharedAppDelegate readPlist:@"email"]];
    
    UILabel *emailLabel = [CustomUIKit labelWithText:msg fontSize:16 fontColor:[UIColor blackColor] frame:CGRectMake(25, 44 + 30, 320 - 30, 45) numberOfLines:2 alignText:NSTextAlignmentLeft];
    emailLabel.font = [UIFont boldSystemFontOfSize:16];
    [transView addSubview:emailLabel];
    
    msg = @"메일을 확인하시고 6자리 인증번호를 입력해주세요.";
    UILabel *label = [CustomUIKit labelWithText:msg fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(emailLabel.frame.origin.x, emailLabel.frame.origin.y + emailLabel.frame.size.height, emailLabel.frame.size.width, 17) numberOfLines:2 alignText:NSTextAlignmentLeft];
    [transView addSubview:label];
    
    
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, label.frame.origin.y + label.frame.size.height + 10, 269, 33)]; // 180
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

    
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)
                                      frame:CGRectMake(textFieldImageView.frame.origin.x, textFieldImageView.frame.origin.y + textFieldImageView.frame.size.height + 10, 269, 32) imageNamedBullet:nil // 179
                           imageNamedNormal:@"email_singbtn.png" imageNamedPressed:nil];
    buttonOK.tag = kVerifyPin;
    [transView addSubview:buttonOK];
    buttonOK.enabled = NO;
//    [buttonOK release];
    
    NSString *str = @"메일을 받지 못하셨나요?";
    
    UILabel *resendEmailLabel = [CustomUIKit labelWithText:str
                                                  fontSize:14 fontColor:[UIColor grayColor]
                                                     frame:CGRectMake(0, buttonOK.frame.origin.y + buttonOK.frame.size.height + 10, 320, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
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
    button.tag = kRequestPinAgain;
    [resendEmailLabel addSubview:button];
//    [button release];
    
    
    str = @"램프 고객센터에 메일 미수신 신고하기";
    
    UILabel *reportLabel = [CustomUIKit labelWithText:str
                                             fontSize:14 fontColor:[UIColor grayColor]
                                                frame:CGRectMake(0, resendEmailLabel.frame.origin.y + resendEmailLabel.frame.size.height + 10, 320, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
    reportLabel.userInteractionEnabled = YES;
    
    
    attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [str length])];
    
    // Set background color for entire range
    [attributedString addAttribute:NSBackgroundColorAttributeName
                             value:[UIColor clearColor]
                             range:NSMakeRange(0, [attributedString length])];
    [reportLabel setAttributedText:attributedString];
    
    
    [transView addSubview:reportLabel];
    
    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)
                                    frame:CGRectMake(0, 0, reportLabel.frame.size.width, reportLabel.frame.size.height) imageNamedBullet:nil // 179
                         imageNamedNormal:nil imageNamedPressed:nil];
    button.tag = kReport;
    [reportLabel addSubview:button];
//    [button release];
}



- (void)reCreatePassword{
    
    //    self.view.tag = kNotVerify;
    NSLog(@"createPassword");
    
    self.title = @"비밀번호 재설정";
    
    
    if(transView){
        [transView removeFromSuperview];
//        [transView release];
        transView = nil;
    }
    
    
    transView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    transView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:transView];
    
    
    
    
    
    UILabel *loginLabel = [CustomUIKit labelWithText:@"로그인에 사용할 비밀번호를 설정합니다." fontSize:15 fontColor:[UIColor blackColor]
                                               frame:CGRectMake(25, 44+40, 270, 25) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [transView addSubview:loginLabel];

    
    
    UIImageView *textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, loginLabel.frame.origin.y + loginLabel.frame.size.height + 5, 270, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    
    pwTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldImageView.frame.origin.x + 10, textFieldImageView.frame.origin.y + 3, textFieldImageView.frame.size.width - 17, textFieldImageView.frame.size.height - 6)]; // 180
    pwTextField.backgroundColor = [UIColor clearColor];
    pwTextField.delegate = self;
    pwTextField.placeholder = @"비밀번호를 설정해주세요.";
    pwTextField.secureTextEntry = YES;
    pwTextField.tag = kPassword;
	pwTextField.clearButtonMode = UITextFieldViewModeAlways;
    [transView addSubview:pwTextField];
//	[textFieldImageView release];
    
    //    pwTextField.keyboardType = UIKeyboardTypeNumberPad;
    [pwTextField becomeFirstResponder];
    //    [pwTextField release];
    
    
    textFieldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, loginLabel.frame.origin.y + loginLabel.frame.size.height + 5 + 33 + 5, 270, 33)]; // 180
    textFieldImageView.image = [CustomUIKit customImageNamed:@"login_input.png"];
    [transView addSubview:textFieldImageView];
    
    checkTextField = [[UITextField alloc]initWithFrame:CGRectMake(textFieldImageView.frame.origin.x + 10, textFieldImageView.frame.origin.y + 3, textFieldImageView.frame.size.width - 17, textFieldImageView.frame.size.height - 6)]; // 180
    checkTextField.backgroundColor = [UIColor clearColor];
    checkTextField.placeholder = @"한 번 더 입력해주세요.";
    checkTextField.delegate = self;
    checkTextField.tag = kPasswordAgain;
    checkTextField.secureTextEntry = YES;
	checkTextField.clearButtonMode = UITextFieldViewModeAlways;
    [transView addSubview:checkTextField];
    //    pwTextField.keyboardType = UIKeyboardTypeNumberPad;
    //    [pwTextField becomeFirstResponder];
//    [checkTextField release];
//    [textFieldImageView release];
    
    
    
    buttonOK = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdButton:)
                                      frame:CGRectMake(25, loginLabel.frame.origin.y + loginLabel.frame.size.height + 5 + 33 + 5 + 33 + 5, 269, 32) imageNamedBullet:nil // 179
                           imageNamedNormal:@"pass_rebtn.png" imageNamedPressed:nil];
    buttonOK.tag = kCheckPassword;
    [transView addSubview:buttonOK];
    buttonOK.enabled = YES;
//    [buttonOK release];
}



- (void)cmdButton:(id)sender{
    switch ([sender tag]) {
        case kCheckPassword:{
            [self checkPassword];
        }
            break;
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
                
                UIAlertAction *cancelb = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
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
            alert = [[UIAlertView alloc] initWithTitle:@"인증메일 재발송" message:@"메일을 받지 못하셨나요?\n스팸편지함 혹은 휴지통 등의 편지함을 확인해보세요. 메일서비스에 따라 메일이 도착하기 까지 다소 시간이 걸릴 수 있습니다.\n\n'재발송'을 선택하면 이메일 주소로 인증메일을 다시 발송합니다." delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:@"재발송", nil];
            alert.tag = [sender tag];
            [alert show];
//            [alert release];
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
                
                UIAlertAction *cancelb = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
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
            alert = [[UIAlertView alloc] initWithTitle:@"인증메일 미수신" message:@"메일 미수신 신고하기\n메일서비스에 따라 메일이 도착하기 까지 다소 시간이 걸릴 수 있습니다.\n\n2시간이 지나도 이메일이 오지 않았다면 아래의 '신고하기'버튼을 눌러주세요. 최대한 빠른시간내에 조치해 드리겠습니다." delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel") otherButtonTitles:@"신고하기", nil];
            alert.tag = [sender tag];
            [alert show];
//            [alert release];
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
        
    }
}


- (void)checkPassword{
    
    NSLog(@"pwtext %@ check %@",pwTextField.text,checkTextField.text);
    
    if([pwTextField.text length]<1){
        
        [CustomUIKit popupSimpleAlertViewOK:@"로그인" msg:@"비밀번호를 입력하세요." con:self];
        
    }
    else if([self validPassword:pwTextField.text] == NO){
        // it is not right
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"비밀번호는 영문 대/소문자, 숫자, 허용된 특수문자만 가능합니다." con:self];
    }
    else if([pwTextField.text isEqualToString:checkTextField.text]){
        
        
        NSString *encPassword = [AESExtention aesEncryptString:pwTextField.text];
        [SharedAppDelegate writeToPlist:@"loginpassword" value:encPassword];
        
        NSLog(@"AES Enc : %@",encPassword);
        
        [SharedAppDelegate.root resetUserPwd:kChangePwd con:self code:pintextField.text pw:pwTextField.text];
    }
    else{
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"비밀번호가 일치하지 않습니다." con:self];
        //        [checkLabel performSelectorOnMainThread:@selector(setText:) withObject:@"일치하지 않습니다." waitUntilDone:NO];
        return;
    }
}


- (BOOL)validPassword:(NSString*)pwString{
    
    NSString *regExPattern = @"[A-Z0-9a-z!\"#$%&'()*+,./:;<=>?@^_`{|}~-]";
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




- (BOOL) textFieldShouldClear:(UITextField *)textField{
    if(textField.tag == kPin)
        buttonOK.enabled = NO;
    
    return YES;
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
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
