//
//  WritePollViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 2. 12..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WritePollViewController : UIViewController <UITextFieldDelegate>
{
    
	__unsafe_unretained id pTarget;
	SEL pSelector;
    UIView *optionView;
    UIView *addOptionView;
    UIView *checkView;
    int optionNumber;
    UIScrollView *scrollView;
    int is_multi;
    int is_anon;
    int is_close;
    
    UIView *titleView;
    UITextField *titleTf;
    NSMutableArray *tfArray;
    UISwitch *nameCheck;
    UISwitch *singularCheck;
    
    
}
@property (nonatomic, assign) id pTarget;
@property (nonatomic, assign) SEL pSelector;

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;
- (void)setModifyView:(NSDictionary *)dic;

@end
