//
//  OCRViewController.h
//  PulmuoneBarcodeOCR
//
//  Created by KimSung on 2016. 1. 28..
//  Copyright © 2016년 김성. All rights reserved.
//

#define DocumentPath    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#import <UIKit/UIKit.h>

@protocol OCRViewController_Protocol;
@interface OCRViewController : UIViewController{
    id<OCRViewController_Protocol> __unsafe_unretained delegate;
    
    int     m_timeOut;
    
    NSString*   m_BarcodeFileName;
    NSString*   m_MakeDateFileName;
    NSString*   m_LimitDateFileName;
    
    BOOL        m_onlyMakeDate;
}
@property (nonatomic, assign)   id<OCRViewController_Protocol>  delegate;
@property (nonatomic)           int         m_timeOut;
@property (nonatomic, retain)   NSString*   m_BarcodeFileName;
@property (nonatomic, retain)   NSString*   m_MakeDateFileName;
@property (nonatomic, retain)   NSString*   m_LimitDateFileName;
@property (nonatomic)   BOOL        m_onlyMakeDate;

-(BOOL)checkExpire:(NSString*)madeDate EXPIREDATE:(NSString*)expireDate TERMSDAY:(NSString*)termsDay ERRORRANGE:(int)errorRange;
@end

@protocol OCRViewController_Protocol
-(void)OCRViewController_CloseView:(OCRViewController *)oCRViewController
                            SUCESS:(BOOL)success
                      BARCODEVALUE:(NSString*)barcodeValue
                     MAKEDATEVALUE:(NSString*)makeDateValue
                   LIMITEDATEVALUE:(NSString*)limiteDateValue;

-(void)OCRViewController_MakeDate_CloseView:(OCRViewController *)oCRViewController
                                     SUCESS:(BOOL)succes
                               BARCODEVALUE:(NSString*)barcodeValue
                              MAKEDATEVALUE:(NSString*)makeDateValue;

@end
