
#import "KakaoTalkActivity.h"
#import "OWActivityViewController.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>

@implementation KakaoTalkActivity

- (id)init
{
    self = [super initWithTitle: NSLocalizedString(@"kakaotalk", @"kakaotalk")
                          image:[UIImage imageNamed:@"Icon_Kakao.png"]
                    actionBlock:nil];
    
    if (!self)
        return nil;
    
    __typeof(&*self)  weakSelf = self;
    
    self.actionBlock = ^(OWActivity *activity, OWActivityViewController *activityViewController) {
        
        UIViewController *presenter = activityViewController.presentingController;
        NSDictionary *userInfo = weakSelf.userInfo ? weakSelf.userInfo : activityViewController.userInfo;

        [activityViewController dismissViewControllerAnimated:YES completion:^{
            
            [weakSelf shareFromViewController:presenter
                                         text:[userInfo objectForKey:@"text"]
                                        image:nil];
            
        }];
    };
    
    return self;
}


- (void)shareFromViewController:(UIViewController *)viewController text:(NSString *)text image:(NSMutableArray *)array
{
    NSLog(@"text %@",text);
    
    
    
    
    BOOL isInstalled = [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"kakaotalk://"]];
    NSLog(@"isInstalled %@",isInstalled?@"YES":@"NO");
    if(!isInstalled){
        
        [CustomUIKit popupSimpleAlertViewOK:nil msg:NSLocalizedString(@"not_install_kakaotalk", @"not_install_kakaotalk") con:SharedAppDelegate.window.rootViewController];
        return;
        
    }
    
    
    
    
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:text] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    AFHTTPRequestOperation *operation =   [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
         
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        UIImage *img = [UIImage imageWithData:operation.responseData];
        
        KakaoTalkLinkObject *image = [KakaoTalkLinkObject createImage:text width:img.size.width height:img.size.height];
        
        [KOAppCall openKakaoTalkAppLink:@[image]];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"failed %@",error);
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    [operation start];
    
    
    
    
    
    
}

@end
