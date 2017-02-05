//
//  SharedFunctions.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 13. 2. 20..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//

#import "SharedFunctions.h"




@implementation NSString (CustomAddFunction)

+ (NSString *)stringToLinux:(NSString *)setTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [formatter dateFromString:setTime];
//    [formatter release];
	NSString *identify = [NSString stringWithFormat:@"%.0f",[dateFromString timeIntervalSince1970]];
    return identify;
}
+ (NSString *)calculateDate:(NSString *)date;{// with:(NSString *)now{
    NSDate *now2 = [NSDate date];
    NSLog(@"date int %d",[date intValue]);
    NSString *nowString = [NSString stringWithFormat:@"%.0f",[now2 timeIntervalSince1970]];
    NSLog(@"nowString %@",nowString);
    //    NSString *diffString = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
    //    NSLog(@"diffsTring %@",diffString);
    NSString *interval;
    int valueInterval = [nowString intValue] - [date intValue];
    NSLog(@"valueInterval %d",valueInterval);
    if(valueInterval < 0)
    {
        int intervalPerMinute = (-valueInterval)/60;
        if(intervalPerMinute<1)
        {
            interval = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"just_before", @"just_before"),NSLocalizedString(@"before_unit", @"before_unit")];
        }
        else if(intervalPerMinute < 60)
        {
            interval = [NSString stringWithFormat:@"%d%@%@",intervalPerMinute,NSLocalizedString(@"minute_unit", @"minute_unit"),NSLocalizedString(@"after_unit", @"after_unit")];
        }
        else if(intervalPerMinute/60 < 24)
        {
            interval = [NSString stringWithFormat:@"%d%@%@",intervalPerMinute/60,NSLocalizedString(@"hour_unit", @"hour_unit"),NSLocalizedString(@"after_unit", @"after_unit")];
        }
        else if(intervalPerMinute/60/24 < 100){
            interval = [NSString stringWithFormat:@"%d%@%@",intervalPerMinute/60/24,NSLocalizedString(@"day_unit", @"day_unit"),NSLocalizedString(@"after_unit", @"after_unit")];
            
        }
        else
            interval = [NSString stringWithFormat:@"%@",NSLocalizedString(@"later", @"later")];
        
    }
    else{
        int intervalPerMinute = valueInterval/60;
        if(intervalPerMinute<1)
        {
            interval = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"just_before", @"just_before"),NSLocalizedString(@"before_unit", @"before_unit")];
        }
        else if(intervalPerMinute < 60)
        {
            interval = [NSString stringWithFormat:@"%d%@%@",intervalPerMinute,NSLocalizedString(@"minute_unit", @"minute_unit"),NSLocalizedString(@"before_unit", @"before_unit")];
        }
        else if(intervalPerMinute/60 < 24)
        {
            interval = [NSString stringWithFormat:@"%d%@%@",intervalPerMinute/60,NSLocalizedString(@"hour_unit", @"hour_unit"),NSLocalizedString(@"before_unit", @"before_unit")];
        }
        else if(intervalPerMinute/60/24 < 100){
            interval = [NSString stringWithFormat:@"%d%@%@",intervalPerMinute/60/24,NSLocalizedString(@"day_unit", @"day_unit"),NSLocalizedString(@"before_unit", @"before_unit")];
            
        }
        else
            interval = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"longtime", @"longtime"),NSLocalizedString(@"before_unit", @"before_unit")];
    }
    NSLog(@"interval %@",interval);
    return interval;
}


+ (NSString *)convertToHourMinSec:(NSString *)s{

    NSString *returnValue = @"";
    int sec = [s intValue];
    if(sec < 60)
        returnValue = [NSString stringWithFormat:@"00:00:%02d",sec];
    else if(sec >= 60 && sec < 3600)
        returnValue = [NSString stringWithFormat:@"00:%02d:%02d",sec/60,sec%60];
    else{
        int hour = 0;
        int min = 0;
        
        hour = sec/3600;
        int rest = sec%3600;
        
        if(rest < 60){
            sec = sec%3600;
            min = 0;
        }
        else{
            min = rest/60;
            sec = rest%60;
        }
        
        
        returnValue = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];
    }
    
    
    return returnValue;
}
#define kStart 1
#define kIng 2
#define kEnd 3

+ (NSString *)calculateDateDifferNow:(NSString *)date mode:(int)mode{// with:(NSString *)now{
    NSDate *now2 = [NSDate date];
    NSLog(@"date int %d",[date intValue]);
    NSString *nowString = [NSString stringWithFormat:@"%.0f",[now2 timeIntervalSince1970]];
    NSLog(@"nowString %@",nowString);
    //    NSString *diffString = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]];
    //    NSLog(@"diffsTring %@",diffString);
    
    NSString *addingString;
    
    if(mode == kStart)
        addingString = @"후";
    else if(mode == kIng)
        addingString = @"째";
    else if(mode == kEnd)
        addingString = @"전";
    
    NSString *interval = @"";
    int valueInterval = [nowString intValue] - [date intValue];
    NSLog(@"valueInterval %d",valueInterval);
    
    
 if(valueInterval < 0)
 {
     valueInterval = -valueInterval;
 }
    
        int intervalPerMinute = valueInterval/60;
        if(intervalPerMinute<1)
        {
            if(mode == kStart)
                interval = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"just_after", @"just_after"),NSLocalizedString(@"start", @"start")];
            else if(mode == kIng)
                interval = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"just_before", @"just_before"),NSLocalizedString(@"start", @"start")];
            else if(mode == kEnd)
                interval = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"just_before", @"just_before"),NSLocalizedString(@"before_unit", @"before_unit")];
            
        }
        else if(intervalPerMinute < 60)
        {
            interval = [NSString stringWithFormat:@"%d%@%@",intervalPerMinute,NSLocalizedString(@"minute_unit", @"minute_unit"),addingString];
        }
        else if(intervalPerMinute/60 < 24)
        {
            interval = [NSString stringWithFormat:@"%d%@%@",intervalPerMinute/60,NSLocalizedString(@"hour_unit", @"hour_unit"),addingString];
        }
        else if(intervalPerMinute/60/24 < 1000)
        {
            interval = [NSString stringWithFormat:@"%d%@%@",intervalPerMinute/60/24,NSLocalizedString(@"day_unit", @"day_unit"),addingString];
            
        }
        else{
            if(mode == kStart)
                interval = [NSString stringWithFormat:@"%@",NSLocalizedString(@"far_future", @"far_future")];
            else if(mode == kIng)
                interval = [NSString stringWithFormat:@"%@",NSLocalizedString(@"longtime_ing", @"longtime_ing")];            
            else if(mode == kEnd)
                interval = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"longtime", @"longtime"),NSLocalizedString(@"before_unit", @"before_unit")];
            
            
        }
//        else
//            interval = @"오래";

    return interval;
}

+ (NSString *)formattingDate:(NSString *)date withFormat:(NSString *)format{
    //    NSLog(@"date %@ format %@",date,format);
    NSDate *dateStr = [NSDate dateWithTimeIntervalSince1970:[date doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *strTime = [NSString stringWithString:[formatter stringFromDate:dateStr]];
//	[formatter release];
    return strTime;
    
    
}
//
//+ (NSString *)convertString:(NSString *)str{
//    NSLog(@"str %@",str);
//
//    NSDictionary *dic = [[str objectFromJSONString]objectForKey:@"chatmsg"];
//    NSLog(@"dic %@",dic);
//
//    return [dicobjectForKey:@"chatmsg"];
//}

//+ (NSString *)calculateDate:(NSDate *)date {
//NSString *interval;
//int diffSecond = (int)[date timeIntervalSinceNow];
//
//if (diffSecond < 0) { //입력날짜가 과거
//
//    //날짜 차이부터 체크
//    int valueInterval;
//    int valueOfToday, valueOfTheDate;
//
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *languages = [defaultsobjectForKey:@"AppleLanguages"];
//    NSString *currentLanguage = [languagesobjectatindex:0];
//
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:currentLanguage] ];
//    [formatter setDateFormat:@"yyyyMMdd"];
//
//    NSDate *now = [SharedFunctions convertLocalDate];
//    valueOfToday = [[formatter stringFromDate:now] intValue]; //오늘날짜
//    valueOfTheDate = [[formatter stringFromDate:date] intValue]; //입력날짜
//    valueInterval = valueOfToday - valueOfTheDate; //두 날짜 차이
//
//    if(valueInterval == 1)
//        interval = @"어제";
//    else if(valueInterval == 2)
//        interval = @"2일전";
//    else if(valueInterval == 3)
//        interval = @"3일전";
//    else if(valueInterval > 3) { //4일 이상일때는 그냥 요일, 날짜 표시
//        if ([currentLanguage compare:@"ko"] == NSOrderedSame)
//            [formatter setDateFormat:@"yyyy.MM.d a h:mm"]; //locale 한국일 경우 "년, 일" 붙이기
//        else
//            [formatter setDateFormat:@"yyyy.MM.d a h:mm"];
//        interval = [formatter stringFromDate:date];
//    } else { //날짜가 같은경우 시간 비교
//
//        [formatter setDateFormat:@"HH"];
//
//        valueOfToday = [[formatter stringFromDate:now] intValue]; //오늘시간
//        valueOfTheDate = [[formatter stringFromDate:date] intValue]; //입력시간
//        valueInterval = valueOfToday - valueOfTheDate; //두 시간 차이
//
//        if(valueInterval == 1)
//            interval = @"1시간전";
//        else if(valueInterval >= 2)
//            interval = [NSString stringWithFormat:@"%i시간전", valueInterval];
//        else { //시간이 같은 경우 분 비교
//
//            [formatter setDateFormat:@"mm"];
//
//            valueOfToday = [[formatter stringFromDate:now] intValue]; //오늘분
//            valueOfTheDate = [[formatter stringFromDate:date] intValue]; //입력분
//            valueInterval = valueOfToday - valueOfTheDate; //두 분 차이
//
//            if(valueInterval == 1)
//                interval = @"1분전";
//            else if(valueInterval >= 2)
//                interval = [NSString stringWithFormat:@"%i분전", valueInterval];
//            else //분이 같은 경우 차이가 1분 이내
//                interval = @"방금 전";
//            
//        }
//        
//    }
//}
//else { //입력날짜가 미래
//    NSLog(@"%s, 입력된 날짜가 미래임", __func__);
//    interval = @"방금 전";
//}
//
//
//return interval;
//}

@end


@implementation SharedFunctions

//+ (NSDate *)convertLocalDate{
//    NSDate *currentDate = [NSDate date];
//    NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
//    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
//    
//    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:currentDate];
//    NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:currentDate];
//    
//    NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
//    NSDate *nowDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
//    NSLog(@"nowDate %@",nowDate);
//    return nowDate;
//}


+ (float)scaleFromWidth:(float)w
{
    float scaledW;
   scaledW = w*SharedAppDelegate.window.frame.size.width/375;
//    scaleRect.size.height = h==0?h:h*SharedAppDelegate.window.frame.size.height/667;
//    scaleRect.origin.x = x;
//    scaleRect.origin.y = y;
    
    return scaledW;
}


+ (float)scaleFromHeight:(float)h
{
    float scaledH;
//    scaleRect.size.width = w==0?w:w*SharedAppDelegate.window.frame.size.width/375;
        scaledH = h*SharedAppDelegate.window.frame.size.height/667;
    //    scaleRect.origin.x = x;
    //    scaleRect.origin.y = y;
    
    NSLog(@"in Height %f out Height %f",h,scaledH);
    
    return scaledH;
}



+ (NSString*)getDeviceIDForParameter
{
	NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"PushAlertLastToken"];
	if (deviceToken == nil || [deviceToken length] < 1) {
		// DeviceID가 존재하지 않음
		[SharedFunctions saveDeviceToken:nil status:NO];
		deviceToken = @"dummydeviceid";
	}
	NSLog(@"deviceToken %@",deviceToken);
	return deviceToken;
}

+ (void)saveDeviceToken:(NSString*)token status:(BOOL)status
{
    NSLog(@"saveDeviceToken %@ %@",token,status?@"YES":@"NO");
	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];

	if (token == nil || [token length] < 1) {
		if ([def objectForKey:@"PushAlertLastToken"] == nil) {
			[def setObject:nil forKey:@"PushAlertLastToken"];
		}
		[def setBool:NO forKey:@"PushAlertLastStatus"];
	} else {
		[def setBool:status forKey:@"PushAlertLastStatus"];
		[def setObject:token forKey:@"PushAlertLastToken"];
	}
	[def synchronize];
}

+ (CGSize)textViewSizeForString:(NSString*)string font:(UIFont*)font width:(CGFloat)width realZeroInsets:(BOOL)zeroInsets
{
    NSLog(@"string %@ font %@ width %f",string,font,width);
    if(IS_NULL(string)){
        return CGSizeMake(0, 0);
    }
    
    
    UITextView *calculationView = [[UITextView alloc] init];
	
	if ([calculationView respondsToSelector:@selector(setAttributedText:)]) {
		NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string
																			   attributes:@{NSFontAttributeName: font}];
		[calculationView setAttributedText:attributedString];
//		[attributedString release];
	} else {
		[calculationView setText:string];
		[calculationView setFont:font];
	}
	
	CGFloat extraWidth = 0.0;
	CGFloat adjustPoint = 0.0;
	if (zeroInsets) {
		if ([calculationView respondsToSelector:@selector(textContainer)]) {
			calculationView.textContainer.lineFragmentPadding = 0.0;
			[calculationView setTextContainerInset:UIEdgeInsetsZero];
		} else {
			[calculationView setContentInset:UIEdgeInsetsMake(-8, -8, -8, -8)];
            
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
            extraWidth = [string boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        
            
	//		extraWidth = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, FLT_MAX)].width;
			adjustPoint = 16.0;
		}
	} else {
		[calculationView setContentInset:UIEdgeInsetsZero];
	}
	
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width+adjustPoint, FLT_MAX)];
	size.height -= adjustPoint;
	if (extraWidth != 0.0) {
		size.width = extraWidth;
	}

//	[calculationView release];
    return size;
}
+ (CGSize)htmltextViewSizeForString:(NSString*)string font:(UIFont*)font width:(CGFloat)width realZeroInsets:(BOOL)zeroInsets fontSize:(NSInteger)fontSize
{
    NSLog(@"string %@ font %@ width %f length %d",string,font,width,[string length]);
    UITextView *calculationView = [[UITextView alloc] init];
    
    if ([calculationView respondsToSelector:@selector(setAttributedText:)]) {
//        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string
//                                                                               attributes:@{NSFontAttributeName: font}];
        
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
        NSString *htmlString = [NSString stringWithFormat:@"<span style=\"font-size: %i\">%@</span>",(int)fontSize,string];
        NSData *htmlDATA = [htmlString dataUsingEncoding:NSUTF8StringEncoding];

        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:htmlDATA
                                                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]}
                                                                     documentAttributes:nil error:nil];


        
        [calculationView setAttributedText:attributedString];
        [calculationView setFont:font];
//        [attributedString release];
    } else {
        [calculationView setText:string];
        [calculationView setFont:font];
    }
    
    CGFloat extraWidth = 0.0;
    CGFloat adjustPoint = 0.0;
    if (zeroInsets) {
        if ([calculationView respondsToSelector:@selector(textContainer)]) {
            calculationView.textContainer.lineFragmentPadding = 0.0;
            [calculationView setTextContainerInset:UIEdgeInsetsZero];
        } else {
            [calculationView setContentInset:UIEdgeInsetsMake(-8, -8, -8, -8)];
            
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
            extraWidth = [string boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            
            
         //   extraWidth = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, FLT_MAX)].width;
            adjustPoint = 16.0;
        }
    } else {
        [calculationView setContentInset:UIEdgeInsetsZero];
    }
    
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width+adjustPoint, FLT_MAX)];
    size.height -= adjustPoint;
    if (extraWidth != 0.0) {
        size.width = extraWidth;
    }
    
    if([string length] < 1){
        size = CGSizeMake(size.width, 5.0);
       

    }
    NSLog(@"string %d size %@",[string length],NSStringFromCGSize(size));
//    [calculationView release];
    return size;
}
+ (void)adjustContentOffsetForTextView:(UITextView*)textView
{
    
	CGRect line = [textView caretRectForPosition:
				   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
	- ( textView.contentOffset.y + textView.bounds.size.height
	   - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
		// We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
		// Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
		// Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
}

+ (NSMutableDictionary *)fromOldToNew:(NSDictionary *)dic object:(id)object key:(NSString *)key
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : mutable하지 않은 배열에서 특정 dictionary의 key에 맞는 object를 바꿔줄 때 이용한다.
     param  - dic(NSDictionary *) : 원래 dictionary
     - object(NSString *) : 바꿀 object
     - key(NSString *) : 원래 dictionary의 key
     연관화면 : 없음
     ****************************************************************/
    if(object == nil)
        object = @"";
    
    NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
    NSDictionary *oldDic = [[NSDictionary alloc]initWithDictionary:dic];
//    oldDic = dic;
// 		NSLog(@"oldDic %@",oldDic);
    [newDic addEntriesFromDictionary:oldDic];
//    NSLog(@"key %@",key);
//    NSLog(@"object %@",object);
    [newDic setObject:object forKey:key];
//    NSLog(@"newDic %@",newDic);
    return newDic;
}

+ (NSString *)minusMe:(NSString *)uidString
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 받은 사번이 내 사번과 ,로 이어져있을 수 있는 경우에 쓰인다. 내 사번만 빼고 나머지 사번을 돌려준다.
     param  - u(NSString *) : 사번
     연관화면 : 없음
     ****************************************************************/
    
	NSString *returnUid = @"";
    NSMutableArray *uidArray = (NSMutableArray*)[uidString componentsSeparatedByString:@","];
    
    if([uidArray count] < 2)  {
        returnUid = uidString;
    } else {
		for (NSString *str in uidArray) {
			if (![str isEqualToString:[ResourceLoader sharedInstance].myUID] && [str length]>0) {
				returnUid = [returnUid stringByAppendingFormat:@"%@,",str];
			}
		}
    }
//    NSLog(@"returnUid %@",returnUid);
    
    return returnUid;
    
}

+ (void)setLastUpdate:(NSString*)date
{
	NSLog(@"setLastUpdate %@",date);
//    NSDate *now = [[NSDate alloc] init];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *strNow = [NSString stringWithString:[formatter stringFromDate:now]];
//    [now release];
//    [formatter release];
	if (date == nil || [date length] < 1) {
		return;
	}
    [SharedAppDelegate writeToPlist:@"lastdate" value:date];
}

+ (NSString *)getMimeTypeForData:(NSData*)data{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
            break;
        case 0x89:
            return @"image/png";
            break;
        case 0x47:
            return @"image/gif";
            break;
        case 0x49:
        case 0x4D:
            return @"image/tiff";
            break;
        case 0x25:
            return @"application/pdf";
            break;
        case 0xD0:
            return @"application/vnd";
            break;
        case 0x46:
            return @"text/plain";
            break;
        default:
            return @"application/octet-stream";
    }
    return nil;
}
+ (NSString*)getMIMETypeWithFilePath:(NSString*)filePath
{
	CFStringRef fileExtension = (__bridge CFStringRef)[filePath pathExtension];
	CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
	CFStringRef mimeType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
//	NSLog(@"mime %@",(NSString*)mimeType);
	if (UTI != NULL) {
		CFRelease(UTI);
	}
	
	NSString *mimeTypeString = (__bridge NSString *)mimeType;
	
	if (mimeTypeString == nil || [mimeTypeString length] < 1) {
		return @"application/octet-stream";
	}
	return mimeTypeString;
}

+ (UIImage *)imageWithColor:(UIColor *)color width:(float)w height:(float)h
{
    CGRect rect = CGRectMake(0.0f, 0.0f, w, h);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"image %@",image);
    return image;
}

@end
