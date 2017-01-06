//
//  LocationSender.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 5. 9..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationSender : NSObject

+ (void)trackingStartWithDisplayName:(NSString*)name rsid:(NSString*)rsid rstype:(NSString*)rstype
							 success:(void (^)(NSString *trackID))successBlock
							 failure:(void (^)(NSString *resultCode, NSString *resultMessage))failBlock;

+ (void)trackingWithTrackID:(NSString*)trackID displayName:(NSString*)name rsid:(NSString*)rsid rstype:(NSString*)rstype
				   location:(CLLocation*)location
					failure:(void (^)(NSString *resultCode, NSString *resultMessage))failBlock;

+ (void)trackingStopWithTrackID:(NSString*)trackID
						success:(void (^)(void))successBlock
						failure:(void (^)(NSString *resultCode, NSString *resultMessage))failBlock;
@end
