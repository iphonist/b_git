//
//  ApplicationCustom.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 9. 12..
//  Copyright (c)BENCHBEE. All rights reserved.
//

#import "ApplicationCustom.h"

@implementation ApplicationCustom

- (BOOL)openURL:(NSURL *)url
{
	return [self openURL:url toSafari:NO];
}

- (BOOL)openURL:(NSURL *)url toSafari:(BOOL)safari
{
	NSLog(@"OPENURL : %@",[url absoluteString]);
	if (safari) {
		return [super openURL:url];
	}
	
	BOOL isHttp = NO;
	
	NSString *scheme = [url.scheme lowercaseString];
	if ([scheme compare:@"http"] == NSOrderedSame || [scheme compare:@"https"] == NSOrderedSame) {
		if ([[url absoluteString] hasPrefix:@"http://www.youtube.com/v/"] == NO &&
			[[url absoluteString] hasPrefix:@"http://itunes.apple.com/"] == NO &&
			[[url absoluteString] hasPrefix:@"http://phobos.apple.com/"] == NO) {
			isHttp = [(AppDelegate*)self.delegate openURL:url];
		}
	}
	
	if (!isHttp) {
		return [super openURL:url];
	} else {
		return YES;
	}
}


@end
