//
//  CustomUIKit.m
//  LEMPMobile
//
//  Created by 백인구 on 11. 6. 27..
//  Copyright 2011 벤치비. All rights reserved.
//

#import "CustomUIKit.h"

   const char paramIndex;

@implementation CustomUIKit



+ (UIButton *)buttonWithTitle:(NSString *)title fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor target:(id)target selector:(SEL)inSelector frame:(CGRect)frame imageNamedBullet:(NSString *)imageNamedBullet imageNamedNormal:(NSString *)imageNamedNormal imageNamedPressed:(NSString *)imageNamedPressed
{
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
	
	// UIImage는 별다른 변경사항이 없다면 setBackgroundImage 속성으로 사용하는데
	// 이미지의 속성을 변경해야 하는 일이 생긴다면 변수를 선언하고 사용하는 것이 좋음. 향후 확장을 위해 변수를 사용
	UIImage *imageButtonNormal  = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNamedNormal ofType:nil]]; 
	UIImage *imageButtonPressed = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNamedPressed ofType:nil]]; 
//	UIImage *imageButtonBullet  = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNamedBullet ofType:nil]]; 
//    UIImage *imageButtonPressed = [CustomUIKit customImageNamed:imageNamedPressed];
//    UIImage *imageButtonNormal = [CustomUIKit customImageNamed:imageNamedNormal];
//     UIImage *imageButtonBullet = [CustomUIKit customImageNamed:imageNamedBullet];
    
    
	// 이미지는 Scale 에 맞게 Up Scale, Down Scale을 함. 리소스 줄이는데 사용
	// UIImage *newImage = [imageButton stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	
	// 정렬
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	button.adjustsImageWhenDisabled = YES;
	button.adjustsImageWhenHighlighted = YES;
	
	// 버튼 글자 색상
	[button setTitle:title forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
	[button setTitleColor:fontColor forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
	[button setBackgroundColor:[UIColor clearColor]];	// in case the parent view draws with a custom color or gradient, use a transparent color
//	[button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:fontSize]];
		button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
		
	// 버튼 글자의 마진 조정. Bullet 여부에 따라 조정한다.
	//[button setTitleEdgeInsets:UIEdgeInsetsMake(29.0f, 22.0f, 0.0f, 0.0f)];
	
	// 버튼 이미지 설정
	if (imageNamedNormal) [button setBackgroundImage:imageButtonNormal  forState:UIControlStateNormal];
	if (imageNamedPressed) [button setBackgroundImage:imageButtonPressed forState:UIControlStateHighlighted];
	
	// 버튼 눌린 경우 엑션 설정
	[button addTarget:target action:inSelector forControlEvents:UIControlEventTouchUpInside];
	
	// bullet 추가
//	if (imageNamedBullet) {
//		NSInteger bx;
//		UIImageView *imageView = [[UIImageView alloc] initWithImage:imageButtonBullet];
//		CGSize size = [title sizeWithFont:fontSize];
//		
//		// bx = (frame.size.width / 2 - (([title length] * fontSize) * 2.7) / 3);
//		bx = ((frame.size.width - size.width) / 2 - 26); // icon 16px + margin 10px
//		
//		if (bx < 0) bx = 5;
//		
//		imageView.frame = CGRectMake(bx, frame.size.height / 3.5, 16, 16);
//		[button addSubview:imageView];
////		[imageView release];
//	}
	
	return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor target:(id)target selector:(SEL)inSelector frame:(CGRect)frame cachedImageNamedBullet:(NSString *)imageNamedBullet cachedImageNamedNormal:(NSString *)imageNamedNormal cachedImageNamedPressed:(NSString *)imageNamedPressed
{
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	// UIImage는 별다른 변경사항이 없다면 setBackgroundImage 속성으로 사용하는데
	// 이미지의 속성을 변경해야 하는 일이 생긴다면 변수를 선언하고 사용하는 것이 좋음. 향후 확장을 위해 변수를 사용
	UIImage *imageButtonNormal  = [UIImage imageNamed:imageNamedNormal];
	UIImage *imageButtonPressed = [UIImage imageNamed:imageNamedPressed];
    
	// 이미지는 Scale 에 맞게 Up Scale, Down Scale을 함. 리소스 줄이는데 사용
	// UIImage *newImage = [imageButton stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	
	// 정렬
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	button.adjustsImageWhenDisabled = YES;
	button.adjustsImageWhenHighlighted = YES;
	
	// 버튼 글자 색상
	[button setTitle:title forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
	[button setTitleColor:fontColor forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
	[button setBackgroundColor:[UIColor clearColor]];	// in case the parent view draws with a custom color or gradient, use a transparent color
	button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
	
	// 버튼 글자의 마진 조정. Bullet 여부에 따라 조정한다.
	//[button setTitleEdgeInsets:UIEdgeInsetsMake(29.0f, 22.0f, 0.0f, 0.0f)];
	
	// 버튼 이미지 설정
	if (imageNamedNormal) [button setBackgroundImage:imageButtonNormal  forState:UIControlStateNormal];
	if (imageNamedPressed) [button setBackgroundImage:imageButtonPressed forState:UIControlStateHighlighted];
	
	// 버튼 눌린 경우 엑션 설정
	[button addTarget:target action:inSelector forControlEvents:UIControlEventTouchUpInside];
	
	return button;
}

+ (UILabel *)labelWithText:(NSString *)title bold:(BOOL)bold fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor frame:(CGRect)frame numberOfLines:(NSInteger)numberOfLines alignText:(NSTextAlignment)alignText
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    label.text = title;
    label.textAlignment = alignText; // NSTextAlignmentCenter;
    label.numberOfLines = numberOfLines;
    label.textColor = fontColor;
    [label setBackgroundColor:[UIColor clearColor]];
    //	[label setFont:[UIFont fontWithName:@"Helvetica" size:fontSize]]; // Helvetica-Bold
    if(bold)
        label.font = [UIFont boldSystemFontOfSize:fontSize];
    else
        label.font = [UIFont systemFontOfSize:fontSize];
    return label;
}


+ (UILabel *)labelWithText:(NSString *)title fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor frame:(CGRect)frame numberOfLines:(NSInteger)numberOfLines alignText:(NSTextAlignment)alignText
{
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	
	label.text = title;
	label.textAlignment = alignText; // NSTextAlignmentCenter;
	label.numberOfLines = numberOfLines;
	label.textColor = fontColor;
	[label setBackgroundColor:[UIColor clearColor]];
//	[label setFont:[UIFont fontWithName:@"Helvetica" size:fontSize]]; // Helvetica-Bold
		label.font = [UIFont systemFontOfSize:fontSize];
	return label;
}

//+ (UITextField *)textFieldWithPlaceholder:(NSString *)title fontSize:(NSInteger)fontSize fontColor:(UIColor *)fontColor frame:(CGRect)frame 
//										 imageNamedBackground:(NSString *)imageNamedBackground imageNamedIcon:(NSString *)imageNamedIcon keyboardType:(UIKeyboardType)keyboardType
//{
//	UITextField *textField;
//	
//	textField = [[[UITextField alloc] initWithFrame:frame]autorelease];
//	textField.placeholder = title;
//	if (imageNamedBackground)
//		textField.background = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNamedBackground ofType:nil]]; // [CustomUIKit customImageNamed:imageNamedBackground];
//	// textField.disabledBackground = [CustomUIKit customImageNamed:@"input_center_t.png"];
//	textField.font = [UIFont systemFontOfSize:fontSize];
//	textField.textColor = fontColor;
//	textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//	textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//	textField.borderStyle = UITextBorderStyleBezel;
//	textField.enablesReturnKeyAutomatically = TRUE;
//	textField.returnKeyType = UIReturnKeyDone;
//	textField.keyboardType = keyboardType; // UIKeyboardType
//	
//	// 텍스트필드 내부에 아이콘을 표시한다.
//	if (imageNamedIcon)
//	{
//		UIImageView* leftView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNamedIcon ofType:nil]]];
//		textField.leftView = leftView;
//		textField.leftViewMode = UITextFieldViewModeAlways;
//		[leftView release];
//	}
//	
//	return textField;
//}	

+ (void)popupSimpleAlertViewOK:(NSString *)title msg:(NSString *)msg con:(UIViewController *)con
{
    if([title length]<1)
        title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle: NSLocalizedString(@"ok", @"ok")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       
                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
       
        
        [alert addAction:ok];
        //        [self presentViewController:alert animated:YES completion:nil];
        [SharedAppDelegate.root anywhereModal:alert];
        
    }
    
    else{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:msg
												   delegate:nil
										  cancelButtonTitle:nil
										  otherButtonTitles:NSLocalizedString(@"ok", @"ok"), nil];
	[alert show];
//	[alert release];
    }
}
+ (void)popupAlertViewOK:(NSString *)title msg:(NSString *)msg delegate:(UIViewController *)con tag:(int)t sel:(SEL)selector with:(id)obj1 csel:(SEL)cancelsel with:(id)obj2
{
    
    if([title length]<1)
        title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"yes", @"yes")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       
                                                       if ([con respondsToSelector:selector]) {
                                                           NSLog(@"ok row1 %@ row2 %@",obj1,obj2);
                                                           if(obj1 != nil){
                                                                [con performSelector:selector withObject:obj1];
                                                           }
                                                           else{
                                                                [con performSelector:selector];
                                                           }
                                                       }
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"no", @"no")
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action){
                                                           NSLog(@"cancel row1 %@ row2 %@",obj1,obj2);
                                                           if(cancelsel != nil){
                                                               if ([con respondsToSelector:cancelsel]) {
                                                                   if(obj2 != nil)
                                                                       [con performSelector:cancelsel withObject:obj2];
                                                                   else
                                                                       [con performSelector:cancelsel];
                                                               }
                                                           }
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        //        [self presentViewController:alert animated:YES completion:nil];
        [SharedAppDelegate.root anywhereModal:alert];
        
    }
    else{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:msg
												   delegate:con
										  cancelButtonTitle:NSLocalizedString(@"no", @"no")
                                          otherButtonTitles:NSLocalizedString(@"yes", @"yes"), nil];
     
        objc_setAssociatedObject(alert, &paramIndex, (NSString *)obj1, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    alert.tag = t;
	[alert show];
//	[alert release];
    }
}


+ (UIScrollView *)scrollViewWithFrame:(CGRect)frame contextSize:(CGSize)size scrollEnable:(BOOL)scrollEnable 
{
	UIScrollView *scrollView;
	scrollView = [[UIScrollView alloc] init];
	
	
	scrollView.frame = frame; // self.frame; // 프레임의 크기를 화면에 꽉 맞게 잡더라도 scrollview로 뷰를 정해진 크기 밖으로 밀 수 있다.
	
	// 스크롤바 크기
	// frame을 580을 주고 contextSize를 480을 주면 setContextOffset으로 화면 이동이 되진 않는다. 
	// 이 경우 키보드가 나온 상태에선 frame 크기는 크기 때문에 화면 이동이 가능한다.
	// 프레임과 컨텐트 사이즈는 구분하는게 좋을 듯 하다. 프레임 크기는 화면에 표시되는 크기로 정의하고
	// context 크기는 스크롤될 크기로 정의하는것이 옮을 듯 하다.
	scrollView.frame = frame; // self.frame; // 프레임의 크기를 화면에 꽉 맞게 잡더라도 scrollview로 뷰를 정해진 크기 밖으로 밀 수 있다.
	scrollView.contentSize = size; // 스크롤 View의 실제 크기. frame은 480, 이걸 크게 주면 커진 크기까지 scroll이 가능하다.
	
	// 스크롤을 이동시키는 함수. 아래처럼 주면 100px 이동해 있는다.
	// [scrollView setContentOffset:CGPointMake(100.0f, 100.0f)];
	// CGPoint offset = [scrollView contentOffset]; // offset 위치정보 얻기
	
	// Content Inset
	// Content 상하에 여백을 추가한다.	 스크롤 시켜 끝으로 이동하면 아래 지정한 대로 여백이 생긴다.
	//scrollView.contentInset = UIEdgeInsetsMake(45.0, 0.0, 54.0, 0.0); // {top, left, bottom, right}
	scrollView.contentInset = UIEdgeInsetsMake((frame.origin.y * -1), 0.0, 0.0, 0.0); // {top, left, bottom, right}
	
	// 스크롤 설정. NO로 하면 터치에 의한 스크롤은 먹지 않는다. 소스내에서 위치를 변경시키는 것은 가능한다. 스크롤이 안 되야 하는 View를 이동할 땐 NO
	scrollView.scrollEnabled = scrollEnable;
	// 수직/수평 한 방향으로만 스크롤 되도록 설정
	scrollView.directionalLockEnabled = YES;
	// 상태바를 클릭할 경우 가장 위쪽으로 스크롤 되도록 설정. scrollViewDidScrollToTop: 델리게이트 메소드로 적절한 처리를 해 주어야 한다.
	//scrollView.scrollsToTop = YES;
	// 특정 사각 영역이 뷰에 표시되도록 오프셋 이동. 잘 먼지 모르겠당.
	// [scrollView scrollRectToVisible:CGRectMake(50.0, 50.0, 100.0, 100.0) animated:YES];
	// 페이징 설정
	scrollView.pagingEnabled = NO;
	
	// 스크롤이 경계에 도달하면 바운싱효과를 적용 경계를 넘어 섰다가 다시 복귀하는지
	//scrollView.alwaysBounceHorizontal = NO;
	//scrollView.alwaysBounceVertical = NO;
	
	// 스크롤뷰를 터치할 경우 컨텐츠 내부의 뷰에 이벤트 전달
	//[scrollView touchesShouldBegin:touches withEvent:evt inContentView:contentInView];
	//[scrollView touchesShouldCancelInContentView:contentInView];
	
	
	// 터치이벤트가 발생할 경우 딜레이를 두고 touchesShouldBegin:withEvent:inContentView: 메소드를 호출
	scrollView.delaysContentTouches = YES;
	
	
	// 감속 속도 조절
	scrollView.decelerationRate = UIScrollViewDecelerationRateFast; // or UIScrollViewDecelerationRateNormal
	
	// 스크롤 바 스타일
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
	//scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	//scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
	
	// 스크롤 바 표시
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = YES;
	
	// 스크롤 바 위치 설정
	//scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
	
	// 아래 옵션에 대해 좀 알아봐야 할 듯 터치 이벤트 관련
	//userInteractionEnabled
	
	return scrollView;
}

+ (void) hideAllKeyboard:(UIView *)uiView
{
	NSArray* subArray = uiView.subviews;
	id v;
	for (v in subArray) 
	{
		if ([v conformsToProtocol:@protocol(UITextInputTraits)]) 
		{
			[v resignFirstResponder];
		}
	}
}	

+ (NSString *) returnMD5Hash:(NSString*)concat {
	const char *concat_str = [concat UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, (int)strlen(concat_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++)
		[hash appendFormat:@"%02X", result[i]];
	return [hash lowercaseString];
	
}

+ (UIImage *)customImageNamed:(NSString *)name
{
    UIImage *img;
	NSString *imagePath;
	
	imagePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
	img = [UIImage imageWithContentsOfFile:imagePath];

    
	return img;
}

+ (void)customImageNamed:(NSString *)name block:(void(^)(UIImage *image))block
{
//    static NSCache *cache = nil;
//    if (!cache)
//    {
//        cache = [[NSCache alloc] init];
//    }
	
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    //check cache first
//    UIImage *image = [cacheobjectForKey:path];
//    if (image)
//    {
//        block(image);
//        return;
//    }
	
    //switch to background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		
        //load image
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        //back to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
			
            //cache the image
//            [cache setObject:image forKey:path];

            //return the image
            block(image);
        });
    });
}

+ (UIImageView *) createImageViewWithOfFiles:(NSString *)imgName withFrame:(CGRect)frame
{
	UIImage *img;
	NSString *imagePath;
	UIImageView *imageView;
	
	imagePath = [[NSBundle mainBundle] pathForResource:imgName ofType:nil];
	img = [UIImage imageWithContentsOfFile:imagePath];
	imageView = [[UIImageView alloc] initWithImage:img];
	
	imageView.frame = frame;
	
	return imageView;
}



+ (UIButton *)backButtonWithTitle:(NSString *)num target:(id)target selector:(SEL)selector{

    NSLog(@"setBackButton %@",num);
    
//    NSString *back;
//    
//    if(num == nil || [num length]<1 || [num isEqualToString:@"0"])
//    {
//        back = @"";
//    }
//    else
//    {
//        back = [NSString stringWithFormat:@"%@",num];
//        
//    }
//    back = @"";
//
//    CGSize size = [back sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:NSLineBreakByWordWrapping];
//    NSLog(@"size.width %f",size.width);
    
    UIImageView *backImageView = [[UIImageView alloc]init];
//    backImageView.frame = CGRectMake(0, 0, size.width+32, 32);
#ifdef BearTalk
    backImageView.frame = CGRectMake(0, 0, 25, 25);
    UIImage *backImage = [CustomUIKit customImageNamed:@"actionbar_btn_back.png"];//stretchableImageWithLeftCapWidth:32-3 topCapHeight:0];
#else
    
    backImageView.frame = CGRectMake(0, 0, 32, 32);
    UIImage *backImage = [CustomUIKit customImageNamed:@"backglobebtn.png"];//
#endif
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = backImageView.frame;
    [button setBackgroundImage:backImage forState:UIControlStateNormal];
 [button setBackgroundImage:backImage forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
//    UILabel *label = [[UILabel alloc]init];
//    label.textColor =  RGB(41,41,41);//[UIColor whiteColor];
////    label.shadowOffset = CGSizeMake(0, -1);
////    label.shadowColor = [UIColor darkGrayColor];
//    label.numberOfLines = 0;
//    label.lineBreakMode = NSLineBreakByWordWrapping;
//    label.font = [UIFont boldSystemFontOfSize:15];
//    label.frame = CGRectMake(28,6,size.width,size.height);
//    label.text = back;
//    label.backgroundColor = [UIColor clearColor];
//    [button addSubview:label];
//    [label release];
    
    return button;
}

//+ (UIButton *)backButtonWithTarget:(id)target selector:(SEL)selector{
//    
//        
//    UIImageView *backImageView = [[UIImageView alloc]init];
//    backImageView.frame = CGRectMake(0, 0, 46, 44);
//    
//    UIImage *backImage = [CustomUIKit customImageNamed:@"back_bt.png"];
//    
//    UIButton *button = [[UIButton alloc]init];
//    button.frame = backImageView.frame;
//    [button setBackgroundImage:backImage forState:UIControlStateNormal];
//    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//    return button;
//}

//+ (UIButton *)closeRightButtonWithTarget:(id)target selector:(SEL)selector{
//    
//    
//    UIImageView *backImageView = [[[UIImageView alloc]init]autorelease];
//    backImageView.frame = CGRectMake(0, 0, 46, 44);
//    
//    UIImage *backImage = [CustomUIKit customImageNamed:@"btnr_close.png"];
//    
//    UIButton *button = [[[UIButton alloc]init]autorelease];
//    button.frame = backImageView.frame;
//    [button setBackgroundImage:backImage forState:UIControlStateNormal];
//    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    
//    return button;
//}



+ (UIButton *)emptyButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)selector{
    
    
    //    UIImageView *backImageView = [[[UIImageView alloc]init]autorelease];
    //    backImageView.frame = CGRectMake(0, 0, 43, 32);
    //
    //    UIImage *backImage = [CustomUIKit customImageNamed:@"done_btn.png"];
    //
    //    UIButton *button = [[[UIButton alloc]init]autorelease];
    //    button.frame = backImageView.frame;
    //    [button setBackgroundImage:backImage forState:UIControlStateNormal];
    
    UIButton *button = [[UIButton alloc]init];

    button.frame = CGRectMake(0, 0, 32, 32);
#ifdef BearTalk
    
    button.frame = CGRectMake(0, 0, 22, 22);

#endif

//	[button setTitle:title forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//	[button setTitleColor:RGB(87, 87, 87) forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
    [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateHighlighted];
//	[button setBackgroundColor:[UIColor clearColor]];	// in case the parent view draws with a custom color or gradient, use a transparent color
//	button.titleLabel.font = [UIFont systemFontOfSize:16];

    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return button;
    //    UIButton *button = [[UIButton alloc]init];
    //
    //    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:CGSizeMake(100, 29) lineBreakMode:NSLineBreakByWordWrapping];
    //
    //    NSLog(@"size.width %f",size.width);
    //    UIImageView *backImageView = [[UIImageView alloc]init];
    //    backImageView.frame = CGRectMake(0, 0, size.width+17, 29);
    //
    //    UIImage *backImage = [[CustomUIKit customImageNamed:@"n01_tl_bt_pto.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:29];
    //
    //    button.frame = backImageView.frame;
    //    [button setBackgroundImage:backImage forState:UIControlStateNormal];
    //    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    //
    //    UILabel *label = [[UILabel alloc]init];
    //    label.textColor =  RGB(250,79,5);// [UIColor whiteColor];
    ////    label.shadowOffset = CGSizeMake(0, -1);
    ////    label.shadowColor = [UIColor darkGrayColor];
    //    label.numberOfLines = 0;
    //    label.lineBreakMode = NSLineBreakByWordWrapping;
    //    label.font = [UIFont boldSystemFontOfSize:13];
    //    label.frame = CGRectMake(9, 6, size.width, size.height);
    //    label.text = title;
    //    label.backgroundColor = [UIColor clearColor];
    //    [button addSubview:label];
    //    [label release];
    //
    //    return button;
}

@end
