//
//  LoginModalViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 7. 25..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeLoginPasswordViewController : UIViewController<UITextFieldDelegate>{
    UIView *transView;
    UIButton *buttonOK;
        
    UITextField *pwTextField;
    UITextField *checkTextField;
    UITextField *pintextField;
}

@end
