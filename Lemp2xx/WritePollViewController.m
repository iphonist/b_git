//
//  WritePollViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 2. 12..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import "WritePollViewController.h"

@interface WritePollViewController ()

@end

@implementation WritePollViewController

@synthesize pTarget;
@synthesize pSelector;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setSubviews];
    }
    return self;
}

#define kName 1
#define kSingular 2

#define kTitle 1
#define kOption 2


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    //    [SharedAppDelegate.root.home getTimeline:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    
	NSDictionary *info = [noti userInfo];
	CGRect endFrame;
	[[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
 
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(checkView.frame)+endFrame.size.height+20+VIEWY);
    
}

- (void)keyboardWillHide:(NSNotification *)noti{
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(checkView.frame)+20+VIEWY);
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    self.title = @"설문 작성";
    
    
    
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_cancel.png" target:self selector:@selector(cancel:)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    
    
    
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_attach.png" target:self selector:@selector(cmdDone:)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnNavi;
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
//    [btnNavi release];

    
    
}
- (void)setSubviews
{
    NSLog(@"setSubviews");
    
    // ******************************
    
    scrollView = [[UIScrollView alloc]init];
//    scrollView.backgroundColor = [];
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = RGB(238, 242, 245);
    // **************************
    
    
    
    
    
    
    
    
    
    
    
    titleView = [[UIView alloc]initWithFrame:CGRectMake(0,20,self.view.frame.size.width,18+16+18)];
    
    CGFloat borderWidth = 0.5f;
    
    titleView.backgroundColor = [UIColor whiteColor];
//    titleView.frame = CGRectInset(titleView.frame, -borderWidth, -borderWidth);
    titleView.layer.borderColor = RGB(240, 240, 240).CGColor;
    titleView.layer.borderWidth = borderWidth;
    [scrollView addSubview:titleView];
    
//    [titleView release];
    
    
    titleTf = [[UITextField alloc]initWithFrame:CGRectMake(15, 18, titleView.frame.size.width - 30, 16)];
    [titleTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    titleTf.backgroundColor = [UIColor clearColor];
    titleTf.delegate = self;
    titleTf.tag = kTitle;
    titleTf.font = [UIFont systemFontOfSize:16];
    titleTf.placeholder = @"설문 제목을 입력하세요";
	titleTf.clearButtonMode = UITextFieldViewModeAlways;
    [titleView addSubview:titleTf];
//    [titleTf release];
    
    
//    UIImageView *line;
//    line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gryline2px_light.png"]];
//    line.frame = CGRectMake(titleTf.frame.origin.x, titleTf.frame.origin.y + titleTf.frame.size.height, titleTf.frame.size.width, 1);
//    [titleView addSubview:line];
//    [line release];
    
    
    
    // ******************************
    
    optionNumber = 3;
    
    optionView = [[UIView alloc]initWithFrame:CGRectMake(titleView.frame.origin.x,
                                                                 CGRectGetMaxY(titleView.frame),
                                                                 titleView.frame.size.width,
                                                                 52*optionNumber)];
    [scrollView addSubview:optionView];
    optionView.backgroundColor = [UIColor whiteColor];
//    [optionView release];
    
    tfArray = [[NSMutableArray alloc] initWithCapacity: optionNumber];
    
    for(int i = 0; i < optionNumber; i++){
        
        UIView *optionEachView = [[UIView alloc]initWithFrame:CGRectMake(0, 52*i, optionView.frame.size.width, 52)];
//        numberImage.image = [UIImage imageNamed:@"vote_numbg.png"];
        [optionView addSubview:optionEachView];
        optionEachView.backgroundColor = [UIColor whiteColor];
//        optionEachView.frame = CGRectInset(optionEachView.frame, -borderWidth, -borderWidth);
        optionEachView.layer.borderColor = RGB(240, 240, 240).CGColor;
        optionEachView.layer.borderWidth = borderWidth;
//        [numberImage release];
       
        
        
        
    UITextField *optionTf = [[UITextField alloc]initWithFrame:CGRectMake(15,
                                                                         18,
                                                                         optionEachView.frame.size.width - 30,
                                                                         16)];
        [optionTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
 
        optionTf.backgroundColor = [UIColor clearColor];
    optionTf.delegate = self;
        optionTf.tag = kOption;
        optionTf.clearButtonMode = UITextFieldViewModeAlways;
    optionTf.font = [UIFont systemFontOfSize:15];
    optionTf.placeholder = [NSString stringWithFormat:@"%d. 항목 입력",i+1];
        [optionEachView addSubview:optionTf];
        [tfArray addObject:optionTf];

        
        
    }
    
    // ******************************
    
    addOptionView = [[UIView alloc]initWithFrame:CGRectMake(optionView.frame.origin.x,
                                                                    optionView.frame.origin.y + optionView.frame.size.height,
                                                                    optionView.frame.size.width,
                                                                    52)];
    [scrollView addSubview:addOptionView];
    addOptionView.backgroundColor = [UIColor whiteColor];
//    addOptionView.frame = CGRectInset(addOptionView.frame, -borderWidth, -borderWidth);
    addOptionView.layer.borderColor = RGB(240, 240, 240).CGColor;
    addOptionView.layer.borderWidth = borderWidth;
//    [addOptionView release];
    
    
//    [addOptionBtn release];
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    UILabel *label = [CustomUIKit labelWithText:@"+ 항목 추가" fontSize:15 fontColor:RGB(51, 61, 71)
                                                 frame:CGRectMake(15, 18, addOptionView.frame.size.width - 30, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [addOptionView addSubview:label];
    NSArray *texts=[NSArray arrayWithObjects:@"+ ",@"항목 추가",nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:label.text];
    NSLog(@"label %@ string %@",label,string);
    [string addAttribute:NSForegroundColorAttributeName value:[NSKeyedUnarchiver unarchiveObjectWithData:colorData] range:[label.text rangeOfString:texts[0]]];
    [label setAttributedText:string];

    
    
    UIButton *addOptionBtn = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(addOption:) frame:CGRectMake(0, 0, addOptionView.frame.size.width, addOptionView.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [addOptionView addSubview:addOptionBtn];
    
    // ******************************
    
    checkView = [[UIView alloc]initWithFrame:CGRectMake(addOptionView.frame.origin.x,
                                                                addOptionView.frame.origin.y + addOptionView.frame.size.height + 20,
                                                                addOptionView.frame.size.width,
                                                                52*2)];
    [scrollView addSubview:checkView];
    
    for(int i = 0; i < 2; i++){
    UIView *checkEachView = [[UIView alloc]initWithFrame:CGRectMake(0, 52*i, checkView.frame.size.width, 52)];
    //        numberImage.image = [UIImage imageNamed:@"vote_numbg.png"];
    [checkView addSubview:checkEachView];
    checkEachView.backgroundColor = [UIColor whiteColor];
//    checkEachView.frame = CGRectInset(checkEachView.frame, -borderWidth, -borderWidth);
    checkEachView.layer.borderColor = RGB(240, 240, 240).CGColor;
    checkEachView.layer.borderWidth = borderWidth;
    }
    
    
    label = [CustomUIKit labelWithText:@"무기명 설문" fontSize:15 fontColor:RGB(51, 61, 71)
                                 frame:CGRectMake(15, 18, checkView.frame.size.width - 30, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [checkView addSubview:label];
    
    
    nameCheck = [[UISwitch alloc]init];
    nameCheck.frame = CGRectMake(checkView.frame.size.width - 16 - 56, 10, 56, 34);
    [nameCheck setOn:NO];
    [checkView addSubview:nameCheck];
    nameCheck.tag = kName;
    [nameCheck addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventValueChanged];

        UIView *line;
    line.backgroundColor = RGB(240,240,240);
        line.frame = CGRectMake(0, 52, checkView.frame.size.width, 1);
        [checkView addSubview:line];
    
//    [singularCheck release];
    
    label = [CustomUIKit labelWithText:@"복수 선택 허용" fontSize:15 fontColor:RGB(51, 61, 71)
                                 frame:CGRectMake(15, 52+18, checkView.frame.size.width - 30, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
    [checkView addSubview:label];
    
    singularCheck = [[UISwitch alloc]init];
    singularCheck.frame = CGRectMake(checkView.frame.size.width - 16 - 56, 52+10, 56, 34);
    [singularCheck setOn:NO];
    [checkView addSubview:singularCheck];
    singularCheck.tag = kSingular;
    [singularCheck addTarget:self action:@selector(cmdButton:) forControlEvents:UIControlEventValueChanged];
   
    
    // **********************************************
    is_multi = 0;
    is_anon = 0;
    is_close = 0;
    
}
-(void)textFieldDidChange:(UITextField *)theTextField
{
    NSString *newString = [theTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
 
    
    int numberOfOptions = 0;
    
        for(int i = 0; i < [tfArray count]; i++){
            UITextField *tf = (UITextField *)tfArray[i];
            NSLog(@"tf.text %@",tf.text);
            NSString *nString = [tf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if([nString length]>0){
                numberOfOptions++;
            }
        
    }

        NSLog(@"optarray count %d",numberOfOptions);
    NSLog(@"newSTring length %d",(int)[newString length]);
    
    if([newString length]>0 && numberOfOptions>1)
          [self.navigationItem.rightBarButtonItem setEnabled:YES];
    else
          [self.navigationItem.rightBarButtonItem setEnabled:NO];

    
   
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSLog(@"textField shouldChangeCharactersInRange %d",(int)newLength);
    if(newLength > 200)
        return NO;
    
       return YES;
}



- (void)setModifyView:(NSDictionary *)dic{
    
    
//    NSLog(@"str objectfromjson %@",[str objectFromJSONString]);
    NSLog(@"scrollView %@",scrollView);
    NSLog(@"titleTf %@",titleTf);
//    NSDictionary *dic = [str objectFromJSONString];

    titleTf.text = dic[@"title"];
    NSArray *optArray = dic[@"options"];
    NSLog(@"optArray %@",optArray);
    optionNumber = 0;
    
    for(NSDictionary *dic in optArray){
        optionNumber = [dic[@"number"]intValue];
    }
    NSLog(@"optionNumber %d",optionNumber);
    
    [tfArray removeAllObjects];
    
    NSLog(@"optionView %@",optionView);
    
    if(optionView){
        [optionView removeFromSuperview];    
        optionView = nil;
    }
    optionView = [[UIView alloc]init];
    optionView.frame = CGRectMake(titleView.frame.origin.x,
                                  titleView.frame.origin.y + titleView.frame.size.height + 0,
                                  titleView.frame.size.width,
                                  52*optionNumber);
    [scrollView addSubview:optionView];
    optionView.backgroundColor = [UIColor clearColor];
//      [optionView release];
    
 
    
//    tfArray = [[NSMutableArray alloc] initWithCapacity: optionNumber];
    
    for(int i = 0; i < optionNumber; i++){
        
        
        UIView *optionEachView = [[UIView alloc]initWithFrame:CGRectMake(0, 52*i
                                                                         , optionView.frame.size.width, 52)];
        //        numberImage.image = [UIImage imageNamed:@"vote_numbg.png"];
        [optionView addSubview:optionEachView];
        optionEachView.backgroundColor = [UIColor whiteColor];
        float borderWidth = 0.5f;
//        optionEachView.frame = CGRectInset(optionEachView.frame, -borderWidth, -borderWidth);
        optionEachView.layer.borderColor = RGB(240, 240, 240).CGColor;
        optionEachView.layer.borderWidth = borderWidth;
        //        [numberImage release];
        
//        [label release];
        
        
        
        UITextField *optionTf = [[UITextField alloc]initWithFrame:CGRectMake(15,
                                                                             18,
                                                                             optionEachView.frame.size.width - 30,
                                                                             16)];
        [optionTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        optionTf.backgroundColor = [UIColor clearColor];
        optionTf.delegate = self;
        optionTf.tag = kOption;
        optionTf.clearButtonMode = UITextFieldViewModeAlways;
        optionTf.font = [UIFont systemFontOfSize:15];
        optionTf.placeholder = [NSString stringWithFormat:@"%d. 항목 입력",i+1];
      
        
//        [numberImage release];
 
        
        
        for(NSDictionary *dic in optArray){
            if([dic[@"number"]isEqualToString:[NSString stringWithFormat:@"%d",i+1]]){
                optionTf.text = dic[@"name"];
                optionTf.placeholder = @"";
            }
        }
        optionTf.placeholder = [NSString stringWithFormat:@"%d. 항목 입력",i+1];
        [optionEachView addSubview:optionTf];
        [tfArray addObject:optionTf];
//        [optionTf release];
        
        
        
        
        
    }

    
    addOptionView.frame = CGRectMake(optionView.frame.origin.x,
                                                            optionView.frame.origin.y + optionView.frame.size.height,
                                                            optionView.frame.size.width,
                                                            52);

    
//    // ******************************
    
    checkView.frame = CGRectMake(addOptionView.frame.origin.x,
                                                        addOptionView.frame.origin.y + addOptionView.frame.size.height + 10,
                                                        addOptionView.frame.size.width,
                                                        52*2);

    
    if([dic[@"is_anon"]isEqualToString:@"1"]){
//        [nameCheck setBackgroundImage:[UIImage imageNamed:@"vote_check_prs.png"] forState:UIControlStateNormal];
        [nameCheck setOn:YES];
    }
    else{
//        [nameCheck setBackgroundImage:[UIImage imageNamed:@"vote_check_dft.png"] forState:UIControlStateNormal];
        [nameCheck setOn:NO];
        
    }
    
    if([dic[@"is_multi"]isEqualToString:@"1"]){
//        [singularCheck setBackgroundImage:[UIImage imageNamed:@"vote_check_prs.png"] forState:UIControlStateNormal];
        [singularCheck setOn:YES];
    }
    else{
//        [singularCheck setBackgroundImage:[UIImage imageNamed:@"vote_check_dft.png"] forState:UIControlStateNormal];
        [singularCheck setOn:NO];
        
    }
    
    
    // **********************************************
    is_multi = [dic[@"is_multi"]intValue];
    is_anon = [dic[@"is_anon"]intValue];
    is_close = [dic[@"is_close"]intValue];
    
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(checkView.frame)+20+VIEWY);
    

}

- (void)addOption:(id)sender{
    NSLog(@"addOption %d",optionNumber);
    
    [self.view endEditing:YES];
    
    NSString *num = [NSString stringWithFormat:@"%d",optionNumber+1];
    optionNumber++;
    CGRect optFrame = optionView.frame;
    
    float borderWidth = 0.5f;
    UIView *optionEachView = [[UIView alloc]initWithFrame:CGRectMake(0, optFrame.size.height, optionView.frame.size.width, 52)];
    //        numberImage.image = [UIImage imageNamed:@"vote_numbg.png"];
    [optionView addSubview:optionEachView];
    optionEachView.backgroundColor = [UIColor whiteColor];

//    optionEachView.frame = CGRectInset(optionEachView.frame, -borderWidth, -borderWidth);
    optionEachView.layer.borderColor = RGB(240, 240, 240).CGColor;
    optionEachView.layer.borderWidth = borderWidth;
    
    
    
    UITextField *optionTf = [[UITextField alloc]initWithFrame:CGRectMake(15, 18, optionEachView.frame.size.width - 30, 16)];
    [optionTf addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    optionTf.backgroundColor = [UIColor clearColor];
    optionTf.delegate = self;
    optionTf.tag = kOption;
    optionTf.clearButtonMode = UITextFieldViewModeAlways;
    optionTf.font = [UIFont systemFontOfSize:15];
    optionTf.placeholder = [NSString stringWithFormat:@"%@. 항목 입력",num];
    [optionEachView addSubview:optionTf];
    
    [tfArray addObject:optionTf];
    
    
    
    optFrame.size.height += 52;
    optionView.frame = optFrame;
    
    if(optionNumber == 20){
        addOptionView.hidden = YES;
        return;
    }
    
    CGRect addFrame = addOptionView.frame;
    addFrame.origin.y += 52;
    addOptionView.frame = addFrame;
    
    
    CGRect chkFrame = checkView.frame;
    chkFrame.origin.y += 52;
    checkView.frame = chkFrame;
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY(checkView.frame)+20+VIEWY);
    
}


- (void)cmdButton:(id)sender{
    
    UISwitch *aSwitch = (UISwitch *)sender;
//    NSString *btnImage;
    
    if(aSwitch.selected == YES)
    {
        aSwitch.selected = NO;
//        btnImage = [NSString stringWithFormat:@"vote_check_dft.png"];
        [aSwitch setOn:NO];
        if([sender tag] == kName){
            is_anon = 0;
        }
        else if([sender tag] == kSingular){
            is_multi = 0;
        }
    }
    else
    {
        aSwitch.selected = YES;
        //        btnImage = [NSString stringWithFormat:@"vote_check_prs.png"];
        [aSwitch setOn:YES];

        if([sender tag] == kName){
            is_anon = 1;
        }
        else if([sender tag] == kSingular){
            is_multi = 1;
        }
    }
    
//    [button setBackgroundImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
    
}

#pragma mark - textfield


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSLog(@"self.view.frame %f",self.view.frame.origin.y);
    [textField resignFirstResponder];
    return YES;
}


- (void)cmdDone:(id)sender{
    
    NSString *newString = [titleTf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([newString length]<1){
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"설문 제목을 입력하세요." con:self];
        return;
    }
    
    if([titleTf.text length]>200){
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"설문 제목은 최대 200자입니다." con:self];
        return;
    }
    NSMutableArray *optArray = [NSMutableArray array];
    for(int i = 0; i < [tfArray count]; i++){//UITextField *tf in tfArray){
        UITextField *tf = (UITextField *)tfArray[i];
        if([tf.text length]>200){
            
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"설문 항목은 최대 200자입니다." con:self];
            return;
        }
        if([tf.text length]>0){
            NSDictionary *dic = @{
                                  @"number" : [NSString stringWithFormat:@"%d",i+1],
                                  @"name" : tf.text,
                                  };
        [optArray addObject:dic];
        }
    }
    NSLog(@"optArray %@",optArray);
    if([optArray count]<2){
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"설문 항목은 2개 이상 입력해야 합니다." con:self];
        return;
    }
    
    // tfarray 갯수는 항목입력창의 갯수고, 내용을 어레이로 만들든지 했을 때 2개 미만이면 리턴 시켜야 함.
    
    NSLog(@"titletf.text %@",titleTf.text);
    NSLog(@"option2 %@",titleTf.text);
    
    NSDictionary *parameters = @{
                                 @"title" : titleTf.text,
                                 @"options" : optArray,
                                 @"is_multi" : [NSString stringWithFormat:@"%d",is_multi],
                                 @"is_anon" : [NSString stringWithFormat:@"%d",is_anon],
                                                      };
    

    NSLog(@"param %@",parameters);
  
    
           if (pTarget && pSelector) {
            [pTarget performSelector:pSelector withObject:parameters];
        }
    
	[self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{
    
	self.pTarget = aTarget;
	self.pSelector = aSelector;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
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
