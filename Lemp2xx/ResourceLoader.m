//
//  ResourceLoader.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 2. 20..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//

#import "ResourceLoader.h"

@implementation ResourceLoader

+ (ResourceLoader*)sharedInstance
{
	static ResourceLoader *resourceLoader = nil;
	
	if (resourceLoader == nil) {
		@synchronized(self) {
			if (resourceLoader == nil) {
				resourceLoader = [[ResourceLoader alloc] init];
				resourceLoader.cache_profileImageDirectory = [NSMutableArray arrayWithArray:[SQLiteDBManager getProfileImageDirectory]];
				resourceLoader.deptList = [[[NSMutableArray alloc] init]autorelease];
				resourceLoader.contactList = [[[NSMutableArray alloc] init]autorelease];
                resourceLoader.allContactList = [[[NSMutableArray alloc] init]autorelease];
                resourceLoader.customerContactList = [[[NSMutableArray alloc] init]autorelease];
                resourceLoader.myDeptList = [[[NSMutableArray alloc] init]autorelease];
                
                
				resourceLoader.favoriteList = [[[NSMutableArray alloc] init]autorelease];
                resourceLoader.csList = [[[NSMutableArray alloc]init]autorelease];
                resourceLoader.myUID = [ResourceLoader sharedInstance].myUID;
#ifdef BearTalk
                
                resourceLoader.mySessionkey = @"";
#else
                
                resourceLoader.mySessionkey = [ResourceLoader sharedInstance].mySessionkey;
#endif
			}
		}
	}
	return resourceLoader;
}

#pragma mark - ProfileImage Public Methods
//+ (NSURL*)resourceURLfromJSONString:(NSString*)jsonString num:(int)num thumbnail:(BOOL)thumb
//{
//    if(IS_NULL(jsonString) || [jsonString length] < 1){
//        return nil;
//    }
//    NSDictionary *dict = [jsonString objectFromJSONString];
//    NSLog(@"dict %@ %@",dict,thumb?@"YES":@"NO");
//    NSString *filename;
//    
//    if(![dict objectForKey:@"thumbnail"] || [[dict objectForKey:@"thumbnail"] count] < 1 || thumb == NO) {
//        
//        if ([dict objectForKey:@"filename"] && [[dict objectForKey:@"filename"] count] > 0) {
//            
//            
//            NSLog(@"here");
//            filename = [[dict objectForKey:@"filename"] objectAtIndex:num];
//        }
//        else {
//            NSLog(@"here2 nil");
//            return nil;
//        }
//        
//    } else {
//        NSLog(@"thumbnail");
//        filename = [[dict objectForKey:@"thumbnail"] objectAtIndex:num];
//    }
//    
//    NSString *serverAddress = [dict objectForKey:@"server"];
//    NSString *urlStr = [NSString stringWithFormat:@"%@://%@%@%@",IS_NULL([dict objectForKey:@"protocol"])?@"":[dict objectForKey:@"protocol"],IS_NULL(serverAddress)?@"":serverAddress,IS_NULL([dict objectForKey:@"dir"])?@"":[dict objectForKey:@"dir"],IS_NULL(filename)?@"":filename];
//    NSLog(@"urlString %@",urlStr);
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"urlString %@",urlStr);
//    NSURL *URL = [NSURL URLWithString:urlStr];
//    return URL;
//}
//

+ (NSURL*)resourceURLfromJSONString:(NSString*)jsonString num:(int)num thumbnail:(BOOL)thumb
{
    if(IS_NULL(jsonString) || [jsonString length] < 1){
        return nil;
    }
    
#ifdef BearTalk
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",BearTalkBaseUrl,jsonString];
    
#else
    
    
    NSDictionary *dict = [jsonString objectFromJSONString];
    NSLog(@"dict %@ %@",dict,thumb?@"YES":@"NO");
    NSString *filename;
    
    NSArray *dict_thumbnail = dict[@"thumbnail"];
    NSLog(@"dict_thumb 1 file %@",dict_thumbnail);
    if([dict[@"thumbnail"]isKindOfClass:[NSArray class]] && [dict[@"thumbnail"]count]>0){
    if([dict[@"thumbnail"][0]hasPrefix:@"beartalk"]){
        dict_thumbnail = nil;
    }
    }
    
    NSArray *dict_filename = dict[@"filename"];
    NSLog(@"dict_thumb 2 file %@",dict_filename);
    if([dict[@"filename"]isKindOfClass:[NSArray class]] && [dict[@"filename"]count]>0){
    if([dict[@"filename"][0]hasPrefix:@"beartalk"]){
        dict_filename = nil;
    }
    }
    NSLog(@"dict_thumb file 3 %@ %@",dict_thumbnail,dict_filename);
    
    if((dict_thumbnail == nil) || [dict_thumbnail count] < 1 || thumb == NO) {
        
        if ((dict_filename != nil) && [dict_filename count] > 0) {
            NSLog(@"here");
            filename = dict_filename[num];
        }
        else {
            NSLog(@"here2 nil");
            return nil;
        }
        
    } else {
        NSLog(@"thumbnail");
        filename = dict_thumbnail[num];
    }
    
    NSString *serverAddress = [dict objectForKey:@"server"];
    NSString *urlStr = [NSString stringWithFormat:@"%@://%@%@%@",IS_NULL([dict objectForKey:@"protocol"])?@"":[dict objectForKey:@"protocol"],IS_NULL(serverAddress)?@"":serverAddress,IS_NULL([dict objectForKey:@"dir"])?@"":[dict objectForKey:@"dir"],IS_NULL(filename)?@"":filename];
    NSLog(@"urlString %@",urlStr);
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
#endif
    NSLog(@"urlString %@",urlStr);
    NSURL *URL = [NSURL URLWithString:urlStr];
    return URL;
    
    
}


+ (NSString*)checkProfileImageWithUID:(NSString *)uid
{
    if ([uid length] < 1 || uid == nil) {
        return nil;
    }

	NSString *imgString = [[ResourceLoader sharedInstance] getProfileImageAtUID:uid];
    if ([imgString length] < 1 || imgString == nil) {
        return nil;
    }
	
	return imgString;
}

#pragma mark - ProfileImage Private Methods

- (NSString*)getProfileImageAtUID:(NSString*)uid
{
	NSString *profile = [NSString string];

	for (NSMutableDictionary *dic in self.cache_profileImageDirectory) {
		if ([[dic objectForKey:@"uid"] isEqualToString:uid]) {
			profile = [dic objectForKey:@"profileimage"];
			break;
		}
	}
	return profile;
}

- (void)cache_profileImageDirectoryUpdateObjectAtUID:(NSString*)uid andProfileImage:(NSString*)profile
{
	BOOL isExist = NO;
	NSInteger index = 0;
	for (NSMutableDictionary *dic in self.cache_profileImageDirectory) {
		if ([[dic objectForKey:@"uid"] isEqualToString:uid]) {
			isExist = YES;
			break;
		}
		index++;
	}
	
	NSURL *url = [ResourceLoader resourceURLfromJSONString:[self getProfileImageAtUID:uid] num:0 thumbnail:YES];
	[[SDImageCache sharedImageCache] removeImageForKey:[url description]];
	if (isExist) {
		NSLog(@"cache_update");
		
		if ([uid isEqualToString:[ResourceLoader sharedInstance].myUID]) {
			NSLog(@"MyProfile Update IN Cache %@, %@",uid,profile);
			NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",uid];
			NSURL *imgURL = [NSURL fileURLWithPath:documentPath];
			[[SDImageCache sharedImageCache] removeImageForKey:[imgURL description] fromDisk:NO];
		}
		
		[self.cache_profileImageDirectory replaceObjectAtIndex:index withObject:@{@"uid": uid, @"profileimage": profile}];
	} else {
		NSLog(@"cache_create");
		[self.cache_profileImageDirectory addObject:@{@"uid": uid, @"profileimage": profile}];
	}
}

- (void)cache_profileImageDirectoryDeleteObjectAtUID:(NSString*)uid
{
	BOOL isExist = NO;
	NSInteger index = 0;
	for (NSMutableDictionary *dic in self.cache_profileImageDirectory) {
		if ([[dic objectForKey:@"uid"] isEqualToString:uid]) {
			isExist = YES;
			break;
		}
		index++;
	}
	
	if (isExist) {
		NSLog(@"cache_delete");
		NSURL *url = [ResourceLoader resourceURLfromJSONString:[self getProfileImageAtUID:uid] num:0 thumbnail:YES];
		[[SDImageCache sharedImageCache] removeImageForKey:[url description] fromDisk:YES];
		
		if ([uid isEqualToString:[ResourceLoader sharedInstance].myUID]) {
			NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentPath = [[searchPaths lastObject] stringByAppendingFormat:@"/%@.JPG",uid];
			NSLog(@"@@@@@@@@@@ %@",documentPath);
			NSURL *imgURL = [NSURL fileURLWithPath:documentPath];
			[[SDImageCache sharedImageCache] removeImageForKey:[imgURL description] fromDisk:YES];
		}
		
		[self.cache_profileImageDirectory removeObjectAtIndex:index];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProfiles" object:nil];
	}
}



#pragma mark - Round Corner Image Process

-(void)addRoundedRectToPath:(CGContextRef)context rect:(CGRect)rect ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight
{
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
	
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    CGFloat fw = CGRectGetWidth (rect) / ovalWidth;
    CGFloat fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (void)roundCornersOfImage:(UIImage *)source scale:(int)scale block:(void(^)(UIImage *roundedImage))block
{
    //switch to background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

		CGFloat w = source.size.width;
		CGFloat h = source.size.height;
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
		
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, w, h);
//		addRoundedRectToPath(context, rect, scale, scale);
		[[ResourceLoader sharedInstance] addRoundedRectToPath:context rect:rect ovalWidth:scale ovalHeight:scale];
		CGContextClosePath(context);
		CGContextClip(context);
		
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), source.CGImage);
		
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		
		UIImage *roundedImage = [UIImage imageWithCGImage:imageMasked];
		CGImageRelease(imageMasked);
		
        //back to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            block(roundedImage);
        });
    });
}

#pragma mark - Data Array
- (void)settingContactList
{
	NSLog(@"init Contacts");
    
#ifdef BearTalk
    if(![[SharedAppDelegate readPlist:@"initContact"]isEqualToString:@"3.0.0"])
        return;
#endif

    NSMutableArray *contactArray = [NSMutableArray array];
    
#ifdef GreenTalkCustomer
    NSLog(@"haContactList %@",SharedAppDelegate.root.haContactList);
//    [contactArray removeAllObjects];
    for(NSMutableDictionary *dic in SharedAppDelegate.root.haContactList){
        
//        NSLog(@"dic %@",dic);
        NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
        if([dic[@"retirement"]isEqualToString:@"N"]){
        [newDic setObject:dic[@"available"] forKey:@"available"];
        [newDic setObject:dic[@"cellphone"] forKey:@"cellphone"];
        [newDic setObject:dic[@"deptcode"] forKey:@"deptcode"];
        [newDic setObject:dic[@"duty"] forKey:@"position"];
        [newDic setObject:dic[@"email"] forKey:@"email"];
        [newDic setObject:[dic[@"employeinfo"]objectFromJSONString][@"msg"] forKey:@"newfield1"];
        [newDic setObject:dic[@"name"] forKey:@"name"];
        [newDic setObject:dic[@"officephone"] forKey:@"companyphone"];
        [newDic setObject:dic[@"position"] forKey:@"grade2"];
        [newDic setObject:dic[@"profileimage"] forKey:@"profileimage"];
        [newDic setObject:dic[@"sequence"] forKey:@"newfield2"];
        [newDic setObject:dic[@"uid"] forKey:@"uniqueid"];
            [newDic setObject:dic[@"userlevel"] forKey:@"newfield3"];
//            NSLog(@"newDic %@",newDic);
        }
        [contactArray addObject:newDic];
        
    }
    NSLog(@"contactArray %@",contactArray);
    
    
#else
    contactArray  = [SQLiteDBManager getList];
    NSLog(@"contactArray count %d",[contactArray count]);
#endif
    
    [self.customerContactList removeAllObjects];
    
    NSMutableArray *favoriteArray = [NSMutableArray array];
    
        for(int j = 0; j < [contactArray count]; j++) {
            //    for(NSDictionary *aDic in contactArray){
            NSMutableDictionary *aDic = contactArray[j];
            
            NSString *deptcode = aDic[@"deptcode"];
            for(NSMutableDictionary *dic in [[self.deptList copy]autorelease]) {
                
                NSString *mycode = dic[@"mycode"];
                if([deptcode isEqualToString:mycode]) {
                    
                    NSString *newDeptName = dic[@"shortname"];
                    
                    NSMutableDictionary *newDic = [SharedFunctions fromOldToNew:aDic object:newDeptName key:@"team"];
                    [contactArray replaceObjectAtIndex:j withObject:newDic];
                    
                }
                
            }
            
#ifdef Batong
            
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
            
            NSString *aUserlevel = aDic[@"newfield3"];
            if([aUserlevel isEqualToString:@"40"]){
                [self.customerContactList addObject:aDic];
            }
#endif
            
            
//            NSLog(@"aDic favorite %@",aDic[@"favorite"]);
            NSString *aFavorite = aDic[@"favorite"];
                if([aFavorite isEqualToString:@"1"]){
                    [favoriteArray addObject:aDic[@"uniqueid"]];
                }
            
        }
    if([self.favoriteList count]<1){
    [self.favoriteList setArray:favoriteArray];
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"newfield2" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCompare:)];
    
#ifdef Batong
    
    NSMutableArray *ecmdArray = [NSMutableArray array];
    
    for(NSMutableDictionary *ecmddic in contactArray) {
        if(![ecmddic[@"newfield4"] isKindOfClass:[NSArray class]])
        {
//                       NSLog(@"ecmddic1 %@",ecmddic);
            [ecmdArray addObject:ecmddic];
            
        }
        else{
            
            NSArray *deptarray = ecmddic[@"newfield4"];
//                        NSLog(@"ecmddic2 %@",ecmddic);
            for(NSString *deptcode in deptarray){
//                NSLog(@"deptcode %@",deptcode);
                
                NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
                [newDic setObject:ecmddic[@"available"] forKey:@"available"];
                [newDic setObject:ecmddic[@"cellphone"] forKey:@"cellphone"];
                [newDic setObject:ecmddic[@"companyphone"] forKey:@"companyphone"];
                [newDic setObject:deptcode forKey:@"deptcode"];
                [newDic setObject:ecmddic[@"email"] forKey:@"email"];
                [newDic setObject:ecmddic[@"favorite"] forKey:@"favorite"];
                [newDic setObject:ecmddic[@"position"] forKey:@"position"];
                [newDic setObject:ecmddic[@"id"] forKey:@"id"];
                [newDic setObject:ecmddic[@"name"] forKey:@"name"];
                [newDic setObject:ecmddic[@"newfield1"] forKey:@"newfield1"];
                [newDic setObject:ecmddic[@"newfield2"] forKey:@"newfield2"];
                [newDic setObject:ecmddic[@"newfield3"] forKey:@"newfield3"];
                [newDic setObject:ecmddic[@"newfield4"] forKey:@"newfield4"];
                [newDic setObject:ecmddic[@"newfield5"] forKey:@"newfield5"];
                [newDic setObject:ecmddic[@"grade2"] forKey:@"grade2"];
                [newDic setObject:ecmddic[@"profileimage"] forKey:@"profileimage"];
                [newDic setObject:[self searchCode:deptcode] forKey:@"team"];
                [newDic setObject:ecmddic[@"uniqueid"] forKey:@"uniqueid"];
                //               NSLog(@"newdic %@",newDic);
                
                [ecmdArray addObject:newDic];
                
                
            }
            
            
        }
    }
    
    
    
    NSLog(@"self.allContactList %d",(int)[self.allContactList count]);
    [ecmdArray sortUsingDescriptors:[NSArray arrayWithObjects:sortName,nil]];
    
    [self.allContactList setArray:ecmdArray];
    [ecmdArray sortUsingDescriptors:[NSArray arrayWithObjects:sortName, nil]];
    [self.contactList setArray:ecmdArray];
    NSLog(@"self.allContactList %d",(int)[self.allContactList count]);
    NSLog(@"contactList %d",(int)[self.contactList count]);

#elif BearTalk
    
    
    NSMutableArray *myDeptArray = [NSMutableArray array];
    NSMutableArray *bearArray = [NSMutableArray array];
    
    for(NSMutableDictionary *beartalkdic in contactArray) {
        
            
            NSArray *deptarray = beartalkdic[@"newfield4"];
        
            //            NSLog(@"beartalkdic %@",beartalkdic);
        if([deptarray count]==0){
            
            [bearArray addObject:beartalkdic];
        }
        else{
            
            
            
            
            NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
            [newDic setObject:beartalkdic[@"available"] forKey:@"available"];
            [newDic setObject:beartalkdic[@"cellphone"] forKey:@"cellphone"];
            [newDic setObject:beartalkdic[@"companyphone"] forKey:@"companyphone"];
            [newDic setObject:beartalkdic[@"deptcode"] forKey:@"deptcode"];
            [newDic setObject:beartalkdic[@"email"] forKey:@"email"];
            [newDic setObject:beartalkdic[@"favorite"] forKey:@"favorite"];
            [newDic setObject:beartalkdic[@"position"] forKey:@"position"];
            [newDic setObject:beartalkdic[@"grade2"] forKey:@"grade2"];
            [newDic setObject:beartalkdic[@"id"] forKey:@"id"];
            [newDic setObject:beartalkdic[@"name"] forKey:@"name"];
            [newDic setObject:beartalkdic[@"newfield1"] forKey:@"newfield1"];
            [newDic setObject:beartalkdic[@"newfield2"] forKey:@"newfield2"];
            [newDic setObject:beartalkdic[@"newfield3"] forKey:@"newfield3"];
            [newDic setObject:beartalkdic[@"newfield4"] forKey:@"newfield4"];
            [newDic setObject:beartalkdic[@"newfield5"] forKey:@"newfield5"];
            [newDic setObject:beartalkdic[@"newfield6"] forKey:@"newfield6"];
            [newDic setObject:beartalkdic[@"newfield7"] forKey:@"newfield7"];
            [newDic setObject:beartalkdic[@"profileimage"] forKey:@"profileimage"];
            //                NSLog(@"pdic deptcode %@",pdic[@"deptcode"]);
            [newDic setObject:beartalkdic[@"team"] forKey:@"team"];
            [newDic setObject:beartalkdic[@"uniqueid"] forKey:@"uniqueid"];
            //               NSLog(@"newdic %@",newDic);
            
            [bearArray addObject:newDic];
            
            
            for(NSMutableDictionary *pdic in deptarray){
                
                NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
                [newDic setObject:beartalkdic[@"available"] forKey:@"available"];
                [newDic setObject:IS_NULL(pdic[@"MOBILE_NUM"])?@"":pdic[@"MOBILE_NUM"] forKey:@"cellphone"];
                [newDic setObject:IS_NULL(pdic[@"COMPANY_TEL_NUM"])?@"":pdic[@"COMPANY_TEL_NUM"] forKey:@"companyphone"];
                [newDic setObject:IS_NULL(pdic[@"DEPT_CODE"])?@"":pdic[@"DEPT_CODE"] forKey:@"deptcode"];
                [newDic setObject:beartalkdic[@"email"] forKey:@"email"];
                [newDic setObject:beartalkdic[@"favorite"] forKey:@"favorite"];
                [newDic setObject:beartalkdic[@"position"] forKey:@"position"];
                [newDic setObject:[NSString stringWithFormat:@"%@/%@",IS_NULL(pdic[@"POS_NAME"])?@"":pdic[@"POS_NAME"],IS_NULL(pdic[@"DUTY_NAME"])?@"":pdic[@"DUTY_NAME"]] forKey:@"grade2"];
                [newDic setObject:beartalkdic[@"id"] forKey:@"id"];
                [newDic setObject:IS_NULL(pdic[@"USER_NAME"])?@"":pdic[@"USER_NAME"] forKey:@"name"];
                [newDic setObject:beartalkdic[@"newfield1"] forKey:@"newfield1"];
                [newDic setObject:beartalkdic[@"newfield2"] forKey:@"newfield2"];
                [newDic setObject:beartalkdic[@"newfield3"] forKey:@"newfield3"];
                [newDic setObject:beartalkdic[@"newfield4"] forKey:@"newfield4"];
                [newDic setObject:beartalkdic[@"newfield5"] forKey:@"newfield5"];
                [newDic setObject:beartalkdic[@"newfield6"] forKey:@"newfield6"];
                [newDic setObject:IS_NULL(pdic[@"COMPANY_NAME"])?@"":pdic[@"COMPANY_NAME"] forKey:@"newfield7"];
                [newDic setObject:beartalkdic[@"profileimage"] forKey:@"profileimage"];
                //                NSLog(@"pdic deptcode %@",pdic[@"deptcode"]);
                [newDic setObject:IS_NULL(pdic[@"DEPT_NAME"])?@"":pdic[@"DEPT_NAME"] forKey:@"team"];
                [newDic setObject:beartalkdic[@"uniqueid"] forKey:@"uniqueid"];
                //               NSLog(@"newdic %@",newDic);
                
                [bearArray addObject:newDic];
                
                
                
            }
            
            
            
            
            
        }
            
        
            
    }
    
    

    
    
    for(int j = 0; j < [bearArray count]; j++) {
        //    for(NSDictionary *aDic in contactArray){
        NSMutableDictionary *aDic = bearArray[j];
        
        
        
        NSString *aDeptcode = aDic[@"deptcode"];
        if([aDic[@"team"]length]>0){
        if(![aDeptcode isEqualToString:@"00000"]){
          
                NSString *grade2 = aDic[@"grade2"];
            
                NSArray *gradeArray = [grade2 componentsSeparatedByString:@"/"];
                if([gradeArray count]>1){
                    
                    if([gradeArray[1]isEqualToString:@"팀장대행"] ||
                       [gradeArray[1]isEqualToString:@"팀장"] ||
                       [gradeArray[1]isEqualToString:@"최고소장"] ||
                       [gradeArray[1]isEqualToString:@"지사장"] ||
                       [gradeArray[1]isEqualToString:@"예비(최고)소장"] ||
                       [gradeArray[1]isEqualToString:@"연구소장"] ||
                       [gradeArray[1]isEqualToString:@"실장대행"] ||
                       [gradeArray[1]isEqualToString:@"실장"] ||
                       [gradeArray[1]isEqualToString:@"소장대행"] ||
                       [gradeArray[1]isEqualToString:@"소장"] ||
                       [gradeArray[1]isEqualToString:@"센터장대행"] ||
                       [gradeArray[1]isEqualToString:@"센터장"] ||
                       [gradeArray[1]isEqualToString:@"사외이사"] ||
                       [gradeArray[1]isEqualToString:@"사업부장대행"] ||
                       [gradeArray[1]isEqualToString:@"사업부장"] ||
                       [gradeArray[1]isEqualToString:@"대표이사"] ||
                       [gradeArray[1]isEqualToString:@"담당임원"] ||
                       [gradeArray[1]isEqualToString:@"고문"]){
                        NSString *pickedCode = aDeptcode;
//                        NSLog(@"aDeptcode %@",aDeptcode);
                        while (![aDeptcode isEqualToString:@"00000"]) {
                            pickedCode = aDeptcode;
                            aDeptcode = [self searchParentCode:aDeptcode];
                            if([aDeptcode length]<1)
                                break;
                            
                        }
                        
//                        NSLog(@"pickedCode %@",pickedCode);
                        NSString *deptname = [self searchCode:pickedCode];
//                        NSLog(@"deptname %@",deptname);
                        NSMutableDictionary *newDic = [SharedFunctions fromOldToNew:aDic object:deptname key:@"position"];
                        [bearArray replaceObjectAtIndex:j withObject:newDic];
//                        NSLog(@"newDic %@",newDic);
                        NSString *sequence = [self searchSequence:pickedCode];
//                                                NSLog(@"sequence %@",sequence);
                        if([deptname length]>0)
                        [myDeptArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:deptname,@"name",sequence,@"newfield1",nil]];
                    }
                    
                }
            
        }
        }
        

        
    }
//    NSLog(@"myDeptArray %@",myDeptArray);
    NSSortDescriptor *sortseq = [NSSortDescriptor sortDescriptorWithKey:@"newfield1" ascending:YES selector:@selector(localizedStandardCompare:)];
    [myDeptArray sortUsingDescriptors:[NSArray arrayWithObjects:sortseq, nil]];
    
    [self.myDeptList setArray:[[NSSet setWithArray: myDeptArray] allObjects]];
    
    [bearArray sortUsingDescriptors:[NSArray arrayWithObjects:sortName,nil]];
    [self.allContactList setArray:bearArray];
    [bearArray sortUsingDescriptors:[NSArray arrayWithObjects:sort, sortName, nil]];
    [self.contactList setArray:bearArray];
    NSLog(@"self.allContactList %d",(int)[self.allContactList count]);
    NSLog(@"contactList %d",(int)[self.contactList count]);
    
#else
    
    
    NSLog(@"self.allContactList %d",[self.allContactList count]);
    [contactArray sortUsingDescriptors:[NSArray arrayWithObjects:sortName,nil]];
    
    [self.allContactList setArray:contactArray];
    [contactArray sortUsingDescriptors:[NSArray arrayWithObjects:sort, sortName, nil]];
    [self.contactList setArray:contactArray];
    NSLog(@"self.allContactList %d",[self.allContactList count]);
#endif
    
    
 
#ifdef Batong
    
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    NSLog(@"mydept %d",(int)[self.myDeptList count]);
    NSMutableArray *aDeptArray = [NSMutableArray array];
    
        for(NSMutableDictionary *dic in [[self.contactList copy]autorelease]){
            if([dic[@"deptcode"]isEqualToString:[SharedAppDelegate readPlist:@"myinfo"][@"deptcode"]]){
                [aDeptArray addObject:dic];
            }
            else if([dic[@"newfield3"]isEqualToString:@"50"] && [[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] == 50){
                [aDeptArray addObject:dic];
            }
            else if([dic[@"newfield3"]isEqualToString:@"60"] && [[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] == 60){
                        [aDeptArray addObject:dic];
                    }
        }
    
    [aDeptArray sortUsingDescriptors:[NSArray arrayWithObjects:sortName,nil]];
    [self.myDeptList setArray:aDeptArray];
    NSLog(@"mydept %d",(int)[self.myDeptList count]);
#endif
    
    
//    NSLog(@"self.myDeptList count %d",[self.myDeptList count]);
//    for(NSDictionary *dic in self.allContactList){
//        if(![dic[@"deptcode"]isEqualToString:[SharedAppDelegate readPlist:@"myinfo"][@"deptcode"]]){
//        
//        
//         if([dic[@"newfield3"]isEqualToString:@"60"] && [[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] == 60){
//            [self.myDeptList addObject:dic];
//        }
//        }
//    }
    
    
        NSLog(@"Contacts initializing complete.");
        //    [SVProgressHUD dismiss];
        
    
                        
                        
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                        });
//                    });
    
    
}

- (void)settingDeptList
{
    NSLog(@"init DeptList");
    
#ifdef BearTalk
     if(![[SharedAppDelegate readPlist:@"initContact"]isEqualToString:@"3.0.0"])
         return;
#endif
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
    NSMutableArray *deptArray = [NSMutableArray array];
    
//#ifdef GreenTalkCustomer
//    NSLog(@"haContactList %@",SharedAppDelegate.root.haDeptList);
//    deptList = [NSMutableArray array];
//    [deptList removeAllObjects];
//    for(NSDictionary *dic in SharedAppDelegate.root.haDeptList){
//        
//        NSLog(@"dic %@",dic);
//        NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
//        if([dic[@"close"]isEqualToString:@"N"]){
//            [newDic setObject:dic[@"available"] forKey:@"available"];
//            [newDic setObject:dic[@"cellphone"] forKey:@"cellphone"];
//            [newDic setObject:dic[@"deptcode"] forKey:@"deptcode"];
//            [newDic setObject:dic[@"duty"] forKey:@"position"];
//            [newDic setObject:dic[@"email"] forKey:@"email"];
//            [newDic setObject:[dic[@"employeinfo"]objectFromJSONString][@"msg"] forKey:@"newfield1"];
//            [newDic setObject:dic[@"name"] forKey:@"name"];
//            [newDic setObject:dic[@"officephone"] forKey:@"companyphone"];
//            [newDic setObject:dic[@"position"] forKey:@"grade2"];
//            [newDic setObject:dic[@"profileimage"] forKey:@"profileimage"];
//            [newDic setObject:dic[@"sequence"] forKey:@"newfield2"];
//            [newDic setObject:dic[@"uid"] forKey:@"uniqueid"];
//            [newDic setObject:dic[@"userlevel"] forKey:@"newfield3"];
//            NSLog(@"newDic %@",newDic);
//        }
//        [deptList addObject:newDic];
//        
//    }
//    NSLog(@"contactArray %@",deptList);
//    
//    
//#else
    deptArray = [SQLiteDBManager getOrganizing];
//    NSLog(@"deptarray %@",deptArray);
//#endif
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"newfield1" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortTeamName = [NSSortDescriptor sortDescriptorWithKey:@"shortname" ascending:YES selector:@selector(localizedCompare:)];
	
    [deptArray sortUsingDescriptors:[NSArray arrayWithObjects:sort, sortTeamName, nil]];
    [self.deptList setArray:deptArray];
//    dispatch_async(dispatch_get_main_queue(), ^{
//    });
//});
	NSLog(@"DeptList initializing complete. %d",(int)[self.deptList count]);


}



#pragma mark - Data Search
- (NSArray *)deptRecursiveSearch:(NSString*)myCode
{
	NSMutableArray *selectedDeptArray = [NSMutableArray array];
	[selectedDeptArray addObject:myCode];
	
	for (NSMutableDictionary *dic in self.deptList) {
		if ([dic[@"parentcode"] isEqualToString:myCode]) {
			[selectedDeptArray addObjectsFromArray:[self deptRecursiveSearch:dic[@"mycode"]]];
		}
	}
	
	return (NSArray*)selectedDeptArray;
}

- (NSString *)searchMemberCount:(NSString *)code
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 공지사항을 받았을 때 조직코드에 맞는 조직이름을 찾아 리턴한다.
     param  - code(NSString *) : 조직코드
     연관화면 : 없음
     ****************************************************************/
    
    NSString *num = [[[NSString alloc]init]autorelease];
    for(NSMutableDictionary *forDic in [self.deptList copy]) {
        if([forDic[@"mycode"] isEqualToString:code]) {
            num = forDic[@"newfield"];
            break;
        }
    }
    if(num == nil)
        num = @"";
    
    return num;
}

- (NSString *)searchParentCode:(NSString *)code{
    
    NSString *pcode = [[[NSString alloc]init]autorelease];
    for(NSMutableDictionary *forDic in [self.deptList copy]) {
        NSString *mycode = forDic[@"mycode"];
        if([mycode isEqualToString:code]) {
            pcode = forDic[@"parentcode"];
        }
    }
    return pcode;
}
- (NSString *)searchCode:(NSString *)code
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 공지사항을 받았을 때 조직코드에 맞는 조직이름을 찾아 리턴한다.
     param  - code(NSString *) : 조직코드
     연관화면 : 없음
     ****************************************************************/
    
    NSString *dept = [[[NSString alloc]init]autorelease];
    
    for(NSMutableDictionary *forDic in [self.deptList copy]) {
        
        if([forDic[@"mycode"] isEqualToString:code]) {
            dept = forDic[@"shortname"];
//            NSLog(@"fordic!!! %@",forDic);
			break;
        }
    }
    
    if(dept == nil)
        dept = @"";
    
    return dept;
}
                         
                         - (NSString *)searchSequence:(NSString *)code
                        {
                            /****************************************************************
                             작업자 : 김혜민
                             작업일자 : 2012/06/04
                             작업내용 : 공지사항을 받았을 때 조직코드에 맞는 조직이름을 찾아 리턴한다.
                             param  - code(NSString *) : 조직코드
                             연관화면 : 없음
                             ****************************************************************/
                            
                            NSString *dept = [[[NSString alloc]init]autorelease];
                            
                            for(NSMutableDictionary *forDic in [self.deptList copy]) {
                                if([forDic[@"mycode"] isEqualToString:code]) {
                                    dept = forDic[@"newfield1"];
                                    break;
                                }
                            }
                            if(dept == nil)
                                dept = @"";
                            
                            return dept;
                        }

- (NSString *)getUserName:(NSString *)uid
{
    NSLog(@"uid %@",uid);
    NSLog(@"self.allContactList %d",(int)[self.allContactList count]);
uid = [SharedFunctions minusMe:uid];
    
    if([uid hasSuffix:@","])
        uid = [uid substringWithRange:NSMakeRange(0,[uid length]-1)];
    
    NSString *userName = [[[NSString alloc]init]autorelease];
    
	for(NSMutableDictionary *forDic in [self.allContactList copy]) {
        if([forDic[@"uniqueid"] isEqualToString:uid]) {
            userName = forDic[@"name"];
			break;
        }
    }
    NSLog(@"returnName %@",userName);
    return userName;
}

- (void)dealloc {
    
    [super dealloc];
}


@end
