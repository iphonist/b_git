//
//  LocationSender.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 5. 9..
//  Copyright (c) 2014년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "LocationSender.h"

@implementation LocationSender

+ (void)trackingStartWithDisplayName:(NSString*)name rsid:(NSString*)rsid rstype:(NSString*)rstype
							 success:(void (^)(NSString *trackID))successBlock
							 failure:(void (^)(NSString *resultCode, NSString *resultMessage))failBlock
{
    //	NSURL *url = [NSURL URLWithString:@"https://dev.lemp.co.kr"];
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]];
	AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
    
	NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
	
	NSDictionary *param = @{@"uid": dic[@"uid"],
							@"sessionkey": dic[@"sessionkey"],
							@"rsid": rsid,
							@"rstype": rstype,
							@"displayname": name};
	[client setParameterEncoding:AFJSONParameterEncoding];
	
	NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/rest/location/tracking/start" parameters:param];
    NSLog(@"request %@",request);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
			successBlock(resultDic[@"track_id"]);			
		} else {
			failBlock(resultDic[@"result"],resultDic[@"resultMessage"]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
		failBlock([NSString stringWithFormat:@"%i",error.code],error.localizedDescription);
	}];
	
	[operation start];
}


+ (void)trackingWithTrackID:(NSString*)trackID displayName:(NSString*)name rsid:(NSString*)rsid rstype:(NSString*)rstype
				   location:(CLLocation*)location
					failure:(void (^)(NSString *resultCode, NSString *resultMessage))failBlock
{
    //	NSURL *url = [NSURL URLWithString:@"https://dev.lemp.co.kr:62238"];
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@:62238",[SharedAppDelegate readPlist:@"was"]]];
	AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
	NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
	
	NSDictionary *param = @{@"uid": dic[@"uid"],
							@"sessionkey": dic[@"sessionkey"],
							@"track_id": trackID,
							@"rsid": rsid,
							@"rstype": rstype,
							@"latitude": [NSNumber numberWithDouble:location.coordinate.latitude],
							@"longitude": [NSNumber numberWithDouble:location.coordinate.longitude],
							@"displayname": name,
							@"strength": @"0",
							@"distance": [NSNumber numberWithDouble:location.horizontalAccuracy]};
	[client setParameterEncoding:AFJSONParameterEncoding];
	
	NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/tracking/location" parameters:param];
    NSLog(@"request %@",request);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if (![isSuccess isEqualToString:@"0"]) {
			failBlock(resultDic[@"result"],resultDic[@"resultMessage"]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
		failBlock([NSString stringWithFormat:@"%i",error.code],error.localizedDescription);
	}];
	
	[operation start];
}
+ (void)trackingStopWithTrackID:(NSString*)trackID
						success:(void (^)(void))successBlock
						failure:(void (^)(NSString *resultCode, NSString *resultMessage))failBlock
{
    //	NSURL *url = [NSURL URLWithString:@"https://dev.lemp.co.kr:62238"];
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@:62238",[SharedAppDelegate readPlist:@"was"]]];
	AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:url];
	NSDictionary *dic = [SharedAppDelegate readPlist:@"myinfo"];
	
	NSString *pathWithParam = [NSString stringWithFormat:@"/tracking/stop/uid/%@/sessionkey/%@/track_id/%@",
							   dic[@"uid"], dic[@"sessionkey"], trackID];
	
	NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:pathWithParam parameters:nil];
    NSLog(@"request %@",request);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
			successBlock();
		} else {
			NSLog(@"ERROR! [%@]%@",resultDic[@"result"],resultDic[@"resultMessage"]);
			failBlock(resultDic[@"result"],resultDic[@"resultMessage"]);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
		failBlock([NSString stringWithFormat:@"%i",error.code],error.localizedDescription);
	}];
	
	[operation start];
}

@end
