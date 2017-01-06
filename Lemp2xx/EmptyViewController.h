//
//  EmptyViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 4. 15..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmptyViewController : UIViewController<UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>{
    NSInteger viewTag;
    NSDictionary *myDic;
    NSMutableArray *myList;
   __unsafe_unretained id target;
    SEL selector;
    
    
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL selector;

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;
- (id)initFromWhere:(int)t withObject:(NSDictionary *)dic;
- (id)initWithFileName:(NSString *)name tag:(int)t;

@end
