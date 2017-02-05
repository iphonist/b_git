
#import "PasswordViewController.h"
#import <AudioToolbox/AudioServices.h>
@implementation PasswordViewController

//@synthesize instructionLabel;
//@synthesize fakeField;

#define pwImage fromSetup?[CustomUIKit customImageNamed:@"prefere_pass_bg_dft.png"]:[CustomUIKit customImageNamed:@"login_passs_dft.png"]
#define pressedImage fromSetup?[CustomUIKit customImageNamed:@"prefere_pass_bg_prs.png"]:[CustomUIKit customImageNamed:@"login_passs_prs.png"]


- (id)initFromSetup:(BOOL)setup
{
    self = [super init];
    if(self != nil)
    {
        NSLog(@"passwordViewController init");
        
        fromSetup = setup;
        
    }
    return self;
    
}

//- (void)dealloc {
//    
////    [bulletField0 release], bulletField0 = nil;
////    [bulletField1 release], bulletField1 = nil;
////    [bulletField2 release], bulletField2 = nil;
////    [bulletField3 release], bulletField3 = nil;
//    
////    [instructionLabel release], instructionLabel = nil;
//    
////    [blank0 release],
//    blank0 = nil;
////    [blank1 release],
//    blank1 = nil;
////    [blank2 release],
//    blank2 = nil;
////    [blank3 release],
//    blank3 = nil;
//    
//    [super dealloc];
//}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"passwordViewController viewDidLoad");
    

    
    alreadyTry = NO;
    
    
    fakeField = [[UITextField alloc] init];
//    fakeField.hidden = YES; 
    fakeField.delegate = self;
    fakeField.text = @"";
    fakeField.keyboardType = UIKeyboardTypeNumberPad;
    [fakeField becomeFirstResponder];
    [self.view addSubview:fakeField];
//    [fakeField release];
    if(fromSetup){
        if([[SharedAppDelegate readPlist:@"pwsaved"]isEqualToString:@"1"])
        self.title = @"비밀번호 해제";
        else
            self.title = @"비밀번호 설정";
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
        
        self.view.backgroundColor = RGB(236, 236, 236);
        
#ifdef BearTalk
        self.view.backgroundColor = RGB(238, 242, 245);
#endif
//        self.view.backgroundColor = RGB(227, 227, 225);//RGB(241, 241, 241);//[UIColor colorWithPatternImage:[CustomUIKit customImageNamed:@"dp_tl_background.png"]];
        
        
        UIButton *button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo)];
        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
//        [btnNavi release];
//        [button release];
    }
    else{
        
        UIImageView *comLogo = [[UIImageView alloc]init];//WithFrame:CGRectMake((320-154)/2, 20, 154, 86)];//185
        comLogo.backgroundColor = [UIColor clearColor];
        comLogo.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:comLogo];
        
        
            comLogo.frame = CGRectMake(320-100, 30, 86, 89);
 
            
        comLogo.image = [CustomUIKit customImageNamed:@"minilogo.png"];
    
        
        self.view.backgroundColor = RGB(236, 236, 236);
        
#ifdef BearTalk
        comLogo.image = [CustomUIKit customImageNamed:@"prefere_logo.png"];
        self.view.backgroundColor = RGB(238, 242, 245);
#endif
        
    }
    
    
    blank0 = [[UIImageView alloc]init];
    [self.view addSubview:blank0];
    blank0.userInteractionEnabled = YES;
    
    blank1 = [[UIImageView alloc]init];
    [self.view addSubview:blank1];
    blank1.userInteractionEnabled = YES;
    
    blank2 = [[UIImageView alloc]init];
    [self.view addSubview:blank2];
    blank2.userInteractionEnabled = YES;
    
    blank3 = [[UIImageView alloc]init];
    [self.view addSubview:blank3];
    blank3.userInteractionEnabled = YES;
    
    instructionLabel = [[UILabel alloc]init];
    instructionLabel.text = @"비밀번호를 입력해주세요.";
    instructionLabel.textAlignment = NSTextAlignmentCenter;
    instructionLabel.backgroundColor = [UIColor clearColor];
    instructionLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:instructionLabel];
    instructionLabel.textColor = RGB(161,159,160);
    instructionLabel.numberOfLines = 2;
//    [instructionLabel release];
    
//    bulletField0 = [[UITextField alloc] init];//With
//    bulletField0.textColor = [UIColor clearColor];
//    bulletField0.enabled = NO;
//    [self.view addSubview:bulletField0];
//    
//    bulletField1 = [[UITextField alloc] init];//With
//    bulletField1.textColor = [UIColor clearColor];
//    bulletField1.enabled = NO;
//    [self.view addSubview:bulletField1];
//    
//    bulletField2 = [[UITextField alloc] init];//With
//    bulletField2.textColor = [UIColor clearColor];
//    bulletField2.enabled = NO;
//    [self.view addSubview:bulletField2];
//    
//    bulletField3 = [[UITextField alloc] init];//With
//    bulletField3.textColor = [UIColor clearColor];
//    bulletField3.enabled = NO;
//    [self.view addSubview:bulletField3];
    
    
    blank0.image = pwImage;//[CustomUIKit customImageNamed:@"paswd_01.png"];
    blank1.image = pwImage;//[CustomUIKit customImageNamed:@"paswd_01.png"];
    blank2.image = pwImage;//[CustomUIKit customImageNamed:@"paswd_01.png"];
    blank3.image = pwImage;//[CustomUIKit customImageNamed:@"paswd_01.png"];
    
    
    if(fromSetup){
        
        //        UILabel *subTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2 - 70 - 60 - 50, 320, 30)];
        //        subTitle.text = @"비밀번호 입력";
        //        subTitle.textColor = [UIColor colorWithRed:(64.0f/255.0f) green:(71.0f/255.0f) blue:(30.0f/255.0f) alpha:1.0f];
        //        subTitle.font = [UIFont boldSystemFontOfSize:19];
        //        subTitle.textAlignment = NSTextAlignmentCenter;
        //        subTitle.backgroundColor = [UIColor clearColor];
        //        [self.view addSubview:subTitle];
        //        [subTitle release];
        
        blank0.frame = CGRectMake(26+55*0+16*0, self.view.frame.size.height/2 - 80 - 60, 55, 55);
        blank1.frame = CGRectMake(26+55*1+16*1, self.view.frame.size.height/2 - 80 - 60, 55, 55);
        blank2.frame = CGRectMake(26+55*2+16*2, self.view.frame.size.height/2 - 80 - 60, 55, 55);
		blank3.frame = CGRectMake(26+55*3+16*3, self.view.frame.size.height/2 - 80 - 60, 55, 55);
//        bulletField0.frame = blank0.frame;
//        bulletField1.frame = blank1.frame;
//        bulletField2.frame = blank2.frame;
//        bulletField3.frame = blank3.frame;
        
		instructionLabel.frame = CGRectMake(0, self.view.frame.size.height/2 - 80, 320, 40);
    }
    else{
        blank0.frame = CGRectMake(26+55*0+16*0, self.view.frame.size.height/2 - 40 - 60, 55, 55);
        blank1.frame = CGRectMake(26+55*1+16*1, self.view.frame.size.height/2 - 40 - 60, 55, 55);
        blank2.frame = CGRectMake(26+55*2+16*2, self.view.frame.size.height/2 - 40 - 60, 55, 55);
		blank3.frame = CGRectMake(26+55*3+16*3, self.view.frame.size.height/2 - 40 - 60, 55, 55);
//        bulletField0.frame = blank0.frame;
//        bulletField1.frame = blank1.frame;
//        bulletField2.frame = blank2.frame;
//        bulletField3.frame = blank3.frame;
		instructionLabel.frame = CGRectMake(0, self.view.frame.size.height/2 - 40, 320, 40);
    }

}



- (void)backTo{
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}


- (void)cancel{//:(id)sender{
//    [SharedAppDelegate.root removePassword];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"didReceiveMemoryWarning");
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    fakeField = nil;
    blank0 = nil;
    blank1 = nil;
    blank2 = nil;
    blank3 = nil;
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"touchesBegan");
//    UITouch *touch = [touches anyObject];
//    CGPoint touchPoint = [touch locationInView:_cropBorderView];
//    
//    
//    _theAnchor = [self _calcuateWhichBorderHandleIsTheAnchorPointFromHere:touchPoint];
//    [self _fillMultiplyer];
//    /*if (CGPointEqualToPoint(_theAnchor, CGPointMake(_cropBorderView.bounds.size.width / 2, _cropBorderView.bounds.size.height / 2))){
//     _resizingEnabled = NO;
//     return;
//     }*/
//    _resizingEnabled = YES;
//    _startPoint = [touch locationInView:self.superview];
    [fakeField becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    NSLog(@"viewDidDisappear %@",pushRk);
    
    
//    if(pushRk != nil && [pushRk length]>0)
//        [SharedAppDelegate.root getRoomWithRk:pushRk];
    NSLog(@"viewDidDisappear %@",pushDic);
    
    if(pushDic != nil){
        NSString *kindOfPush = [pushDic valueForKey:@"ptype"];
        
        if([kindOfPush isEqualToString:@"chat"]){
            if([[pushDic valueForKey:@"rkey"]isEqualToString:[SharedAppDelegate readPlist:@"lastroomkey"]] && [SharedAppDelegate.root checkVisible:SharedAppDelegate.root.chatView]){
                NSLog(@"push chatview");
#ifdef BearTalk
                
                [SharedAppDelegate.root getRoomWithSocket:[pushDic valueForKey:@"rkey"] num:@""];
#else
                [SharedAppDelegate.root.chatView settingRk:[pushDic valueForKey:@"rkey"] sendMemo:@""];
#endif
            }
            else{
				[SharedAppDelegate.root getRoomWithRk:[pushDic valueForKey:@"rkey"] number:@"" sendMemo:@"" modal:NO];
				
                
            }
        }
        else if([kindOfPush isEqualToString:@"sns"]){
            [SharedAppDelegate.root.home loadDetail:[pushDic valueForKey:@"cidx"] inModal:YES con:SharedAppDelegate.root.tabBarController.selectedViewController];// fromNoti:NO con:SharedAppDelegate.root.centerController.visibleViewController];
            
            
        }
        else if([kindOfPush isEqualToString:@"voice"]){
            [SharedAppDelegate.root.callManager setFullIncoming:pushDic active:NO];
        }
    }
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}


//- (void)notifyDelegate:(NSString *)passcode {
//		NSLog(@"notifyDelegate %@",passcode);
//
//		[self passcodeEntered:passcode];
//    fakeField.text = @"";
//
//
//}


- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"passwordViewController viewWillAppear");
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    NSLog(@"fakeField %@",fakeField);
    [fakeField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
 
    NSLog(@"passwordViewWillDisappear");
    [super viewWillDisappear:animated];
    [fakeField resignFirstResponder];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)keyboardWasShown:(NSNotification *)noti{
    NSLog(@"keyboardWasShown");
 
}
- (void)keyboardWillHide:(NSNotification *)noti{
    NSLog(@"keyboardWillHide");
    
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : UITextFieldDelegate로서 비밀번호를 입력할 때, 입력한 길이에 맞게 검정 동그라미 그림을 붙여준다.
     param  - textField(UITextField *) : 텍스트필드
     - range(NSRange) : 입력된 길이
     - string(NSString *) : 입력한 스트링
     연관화면 : 패스워드
     ****************************************************************/
    
    
    
    NSString *passcode = fakeField.text;
    passcode = [passcode stringByReplacingCharactersInRange:range withString:string];
    
    if(alreadyTry == NO)
        [instructionLabel performSelectorOnMainThread:@selector(setText:) withObject:@"비밀번호를 입력해주세요." waitUntilDone:NO];
    
    
    switch ([passcode length]) {
        case 0:
            
            [blank0 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
            [blank1 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
            [blank2 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
            [blank3 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
//            bulletField0.text = nil;
//              bulletField1.text = nil;
//              bulletField2.text = nil;
//              bulletField3.text = nil;
            break;
        case 1:
            [blank0 performSelectorOnMainThread:@selector(setImage:) withObject:pressedImage waitUntilDone:NO];
            [blank1 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
            [blank2 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
            [blank3 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
//            bulletField0.text = @"*";
//            bulletField1.text = nil;
//            bulletField2.text = nil;
//            bulletField3.text = nil;
            
            break;
        case 2:
            [blank0 performSelectorOnMainThread:@selector(setImage:) withObject:pressedImage waitUntilDone:NO];
            [blank1 performSelectorOnMainThread:@selector(setImage:) withObject:pressedImage waitUntilDone:NO];
            [blank2 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
            [blank3 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
//            bulletField0.text = @"*";
//            bulletField1.text = @"*";
//            bulletField2.text = nil;
//            bulletField3.text = nil;
            
            break;
        case 3:
            [blank0 performSelectorOnMainThread:@selector(setImage:) withObject:pressedImage waitUntilDone:NO];
            [blank1 performSelectorOnMainThread:@selector(setImage:) withObject:pressedImage waitUntilDone:NO];
            [blank2 performSelectorOnMainThread:@selector(setImage:) withObject:pressedImage waitUntilDone:NO];
            [blank3 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
//            bulletField0.text = @"*";
//            bulletField1.text = @"*";
//            bulletField2.text = @"*";
//            bulletField3.text = nil;
            
            break;
        case 4:
            [blank0 performSelectorOnMainThread:@selector(setImage:) withObject:pressedImage waitUntilDone:NO];
            [blank1 performSelectorOnMainThread:@selector(setImage:) withObject:pressedImage waitUntilDone:NO];
            [blank2 performSelectorOnMainThread:@selector(setImage:) withObject:pressedImage waitUntilDone:NO];
            [blank3 performSelectorOnMainThread:@selector(setImage:) withObject:pressedImage waitUntilDone:NO];
//            bulletField0.text = @"*";
//            bulletField1.text = @"*";
//            bulletField2.text = @"*";
//            bulletField3.text = @"*";
            
            [self performSelector:@selector(passwordBridge:) withObject:passcode afterDelay:0];
            return NO;
            break;
        default:
            break;
    }
    
    return YES;
}

//- (void)getRoom:(NSString *)rk{
//    pushRk = [[NSString alloc]initWithFormat:@"%@",rk];
//}
- (void)checkUserInfo:(NSDictionary *)dic{
    NSLog(@"dic %@",dic);
    pushDic = [[NSDictionary alloc]initWithDictionary:dic];
}
- (void)passwordBridge:(NSString *)pw{
    [self passcodeEntered:pw];
    fakeField.text = @"";
}

- (void)passcodeEntered:(NSString *)passCode {
    
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 비밀번호를 입력했을 때. 비밀번호가 있는데 입력한 것과 같은지, 없는데 입력한 것인지, 구분하여 비밀번호를 새로 정하게 하거나 다시 입력하도록 한다.
     param - passcode(NSString *) : 입력한 비밀번호
     연관화면 : 패스워드
     ****************************************************************/
    NSLog(@"pw %@ saved %@",[SharedAppDelegate readPlist:@"pw"],[SharedAppDelegate readPlist:@"pwsaved"]);
    
    
    if([SharedAppDelegate readPlist:@"pw"] == nil || [[SharedAppDelegate readPlist:@"pw"]length] < 4) // 비밀번호 없음
    {
        
        NSLog(@"password not exist");
        if([password isEqualToString:passCode])
        {
//            [SharedAppDelegate.root removePassword];
            [self backTo];
            [SharedAppDelegate writeToPlist:@"pw" value:passCode];// writeToAllPlistWithKey:@"pw" value:passCode];
            [SharedAppDelegate writeToPlist:@"pwsaved" value:@"1"];
            //                    [SharedAppDelegate writeToAllPlistWithKey:@"pwsaved" value:@"1"];
            
        }
        else
        {
            
            [self setEmptyPassword];
            
            
            NSLog(@"password %@ passcode %@",password,passCode);
            if(password != nil && [password length]==4 && alreadyTry == YES){
                [instructionLabel performSelectorOnMainThread:@selector(setText:) withObject:@"암호가 일치하지 않습니다.\n처음부터 다시 시도해주세요." waitUntilDone:NO];
                alreadyTry = NO;
            }
            else
            {
                [instructionLabel performSelectorOnMainThread:@selector(setText:) withObject:@"확인을 위해 한 번 더 입력해주세요." waitUntilDone:NO];
                alreadyTry = YES;
            }
            if(alreadyTry == YES)
            password = [[NSString alloc]initWithFormat:@"%@",passCode];
        }
    }
    
    
    
    else // 비밀번호 이미 있음.
    {
        
        if([[SharedAppDelegate readPlist:@"pw"] isEqualToString:passCode])// && [[AppID readAllPlist:@"pwsaved"]isEqualToString:@"1"])
        {
            NSLog(@"ding dong deng fromSetup %@",fromSetup?@"YES":@"NO");
            if(fromSetup == YES){
//                [self dismissViewControllerAnimated:YES completion:nil];
                
                [self backTo];
                [SharedAppDelegate writeToPlist:@"pwsaved" value:@"0"];
                [SharedAppDelegate writeToPlist:@"pw" value:@""];
            }
            else{
                [SharedAppDelegate.root removePassword];
            }
            //                    [AppID authenticateWithtag:999];
            //                    if([[SharedAppDelegate readPlist:@"pwsaved"]isEqualToString:@"1"])
            //                    {
            //                        NSLog(@"pw length 4");
            //                    }
        }
        else
        {
            [blank0 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
            [blank1 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
            [blank2 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
            [blank3 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
            //						blank0.image = [CustomUIKit customImageNamed:@"paswd_01.png"];
            //						blank1.image = [CustomUIKit customImageNamed:@"paswd_01.png"];
            //						blank2.image = [CustomUIKit customImageNamed:@"paswd_01.png"];
            //                    blank3.image = [CustomUIKit customImageNamed:@"paswd_01.png"];
            
            [instructionLabel performSelectorOnMainThread:@selector(setText:) withObject:@"암호가 일치하지 않습니다.\n다시 시도해주세요." waitUntilDone:NO];
            //                    [instructionLabel performSelectorOnMainThread:@selector(setText:) withObject:@"다시 입력해주세요." waitUntilDone:NO];
            fakeField.text = @"";
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
    }
    
}


- (void)setEmptyPassword
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 비밀번호 창을 비운다.
     연관화면 : 패스워드
     ****************************************************************/
    
    NSLog(@"passwordViewController setEmptyPassword");
    NSLog(@"pw %@",[SharedAppDelegate readPlist:@"pw"]);
//    bulletField0.text = nil;
//    bulletField1.text = nil;
//    bulletField2.text = nil;
//    bulletField3.text = nil;
    
    [blank0 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
    [blank1 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
    [blank2 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
    [blank3 performSelectorOnMainThread:@selector(setImage:) withObject:pwImage waitUntilDone:NO];
    //		blank0.image = [CustomUIKit customImageNamed:@"paswd_01.png"];
    //		blank1.image = [CustomUIKit customImageNamed:@"paswd_01.png"];
    //		blank2.image = [CustomUIKit customImageNamed:@"paswd_01.png"];
    //		blank3.image = [CustomUIKit customImageNamed:@"paswd_01.png"];
    //    [fakeField becomeFirstResponder];
    fakeField.text = @"";
}



@end
