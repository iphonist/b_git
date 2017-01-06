//
//  ActivityTableViewCellSubViews.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 4. 4..
//  Copyright (c) 2014년 BENCHBEE. All rights reserved.
//

#import "ActivityTableViewCellSubViews.h"

@implementation ActivityTableViewCellSubViews

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
		CGFloat topMargin = 10.0;
		
		profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, topMargin, 35, 35)];
		profileImageView.userInteractionEnabled = YES;
		
		timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, CGRectGetMaxY(profileImageView.frame)+3, 39, 12)];
		[timeLabel setTextAlignment:UITextAlignmentCenter];
		[timeLabel setTextColor:[UIColor darkGrayColor]];
		[timeLabel setFont:[UIFont systemFontOfSize:9.0]];
		[timeLabel setBackgroundColor:[UIColor clearColor]];

		
		defaultView = [[UIImageView alloc] initWithFrame:CGRectMake(45, topMargin, 270, 0)];
		[defaultView setContentMode:UIViewContentModeScaleToFill];
		[defaultView setClipsToBounds:YES];
		[defaultView setAutoresizesSubviews:YES];
		[defaultView setUserInteractionEnabled:YES];

		nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 17)];
		[nameLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
		[nameLabel setBackgroundColor:[UIColor clearColor]];
		[nameLabel setTextColor:RGB(87, 107, 149)];

		positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+3, 4, 90, 13)];
		[positionLabel setTextColor:[UIColor blackColor]];
		[positionLabel setFont:[UIFont systemFontOfSize:12.0]];
		[positionLabel setBackgroundColor:[UIColor clearColor]];
			
		teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(positionLabel.frame)+5, 4, 90, 13)];
		[teamLabel setFont:[UIFont systemFontOfSize:12.0]];
		[teamLabel setTextColor:[UIColor grayColor]];
		[teamLabel setBackgroundColor:[UIColor clearColor]];
		[teamLabel setAdjustsFontSizeToFitWidth:NO];
		
		timeDetailLabel	= [[UILabel alloc] initWithFrame:CGRectMake(0, 22, defaultView.bounds.size.width, 12)];
		[timeDetailLabel setTextColor:[UIColor grayColor]];
		[timeDetailLabel setFont:[UIFont systemFontOfSize:12.0]];
		[timeDetailLabel setBackgroundColor:[UIColor clearColor]];
		
		
		whImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(timeDetailLabel.frame)+15, 12, 17)];
		whImageView.image = [UIImage imageNamed:@"location_ic.png"];
		[defaultView addSubview:whImageView];
		
		whLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(whImageView.frame)+3, CGRectGetMaxY(timeDetailLabel.frame)+15, 252, 17)];
		[whLabel setTextAlignment:UITextAlignmentLeft];
		[whLabel setFont:[UIFont systemFontOfSize:14.0]];
		[whLabel setBackgroundColor:[UIColor clearColor]];
		[whLabel setTextColor:RGB(226, 68, 60)];

		
		NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
		contentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(whLabel.frame)+10, defaultView.bounds.size.width, 0)];
		[contentsLabel setTextAlignment:UITextAlignmentLeft];
		[contentsLabel setFont:[UIFont systemFontOfSize:fontSize]];
		[contentsLabel setBackgroundColor:[UIColor clearColor]];
		[contentsLabel setAdjustsFontSizeToFitWidth:NO];
		[contentsLabel setNumberOfLines:7];
		
		
		contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(contentsLabel.frame)+20, 254, 137)];
		[contentImageView setContentMode:UIViewContentModeScaleAspectFill];
		[contentImageView setClipsToBounds:YES];
		
		[defaultView addSubview:nameLabel];
		[defaultView addSubview:positionLabel];
		[defaultView addSubview:teamLabel];
		[defaultView addSubview:timeDetailLabel];
		[defaultView addSubview:whImageView];
		[defaultView addSubview:whLabel];
		[defaultView addSubview:contentsLabel];
		[defaultView addSubview:contentImageView];
		
		[nameLabel release];
		[positionLabel release];
		[teamLabel release];
		[timeDetailLabel release];
		[whImageView release];
		[whLabel release];
		[contentsLabel release];
		[contentImageView release];

		
		
		bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(45, CGRectGetMaxY(defaultView.frame), 270, 0)];
		bottomView.clipsToBounds = YES;
		
		likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 29, 29)];
		likeImageView.image = [UIImage imageNamed:@"goodic.png"];
		
		likeCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(likeImageView.frame)+2, 0, 85, 29)];
		[likeCountLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
		[likeCountLabel setBackgroundColor:[UIColor clearColor]];
		[likeCountLabel setTextColor:[UIColor colorWithRed:0.5333 green:0.6 blue:0.651 alpha:1.0]];
		likeCountLabel.text = @"0";

		replyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(likeCountLabel.frame), 0, 29, 29)];
		replyImageView.image = [UIImage imageNamed:@"commentic.png"];
		
		replyCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(replyImageView.frame)+5, 0, 85, 29)];
		[replyCountLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
		[replyCountLabel setBackgroundColor:[UIColor clearColor]];
		[replyCountLabel setTextColor:[UIColor colorWithRed:0.5333 green:0.6 blue:0.651 alpha:1.0]];
		replyCountLabel.text = @"0";
		

		
		[bottomView addSubview:likeImageView];
		[bottomView addSubview:likeCountLabel];
		[bottomView addSubview:replyImageView];
		[bottomView addSubview:replyCountLabel];

		[likeImageView release];
		[likeCountLabel release];
		[replyImageView release];
		[replyCountLabel release];

		
		
		[self.contentView addSubview:profileImageView];
		[self.contentView addSubview:timeLabel];
		[self.contentView addSubview:defaultView];
		[self.contentView addSubview:bottomView];
		
		[profileImageView release];
		[timeLabel release];
		[defaultView release];
		[bottomView release];
				
//		UIImageView *bgView = [[UIImageView alloc]init];
//		bgView.backgroundColor = RGB(246,246,246);
//		self.backgroundView = bgView;
//		[bgView release];
	}
	return self;
}



#pragma mark - button action

- (void)goToYourTimeline:(id)sender{
    
    if(self.uid == nil || [self.uid length] == 0)
        return;
    
    [SharedAppDelegate.root.home goToYourTimeline:self.uid];
}

- (void)goToReplyTimeline:(id)sender{
    NSLog(@"goToReplyTimeline %@",[[sender titleLabel]text]);
    
    if([[sender titleLabel]text] == nil && [[[sender titleLabel]text] length]==0)
        return;
    
    if([sender tag]!=1)
        return;
    
    [SharedAppDelegate.root.home goToYourTimeline:[[sender titleLabel]text]];
}


#pragma mark - setting

- (void)setUid:(NSString *)newUid
{
	[super setUid:newUid];

	[SharedAppDelegate.root getProfileImageWithURL:newUid ifNil:@"profile_photo.png" view:profileImageView scale:12];

	UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,35,35)];
    viewButton.adjustsImageWhenHighlighted = NO;
    [viewButton addTarget:self action:@selector(goToYourTimeline:) forControlEvents:UIControlEventTouchUpInside];
    [profileImageView addSubview:viewButton];
	[viewButton release];

	
	[nameLabel setText:[[ResourceLoader sharedInstance] getUserName:newUid]];
	CGSize size = [nameLabel.text sizeWithFont:nameLabel.font];
	if (size.width > 180.0) {
		size.width = 180.0;
		nameLabel.adjustsFontSizeToFitWidth = YES;
	} else {
		nameLabel.adjustsFontSizeToFitWidth = NO;
	}
	[nameLabel setFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y, size.width, nameLabel.frame.size.height)];
}

- (void)setPosition:(NSString *)newPosition
{
	[super setPosition:newPosition];
	
	[positionLabel setText:newPosition];
	CGSize size = [positionLabel.text sizeWithFont:positionLabel.font];
	CGFloat maxWidth = defaultView.frame.size.width-nameLabel.frame.size.width-3.0;
	if (size.width > maxWidth) {
		size.width = maxWidth;
		positionLabel.adjustsFontSizeToFitWidth = YES;
	} else {
		positionLabel.adjustsFontSizeToFitWidth = NO;
	}
	[positionLabel setFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+3.0, positionLabel.frame.origin.y, size.width, positionLabel.frame.size.height)];
}

- (void)setDeptName:(NSString *)newDeptName
{
	[super setDeptName:newDeptName];
	
	[teamLabel setText:newDeptName];
	CGSize size = [teamLabel.text sizeWithFont:teamLabel.font];
	CGFloat maxWidth = defaultView.frame.size.width-nameLabel.frame.size.width-positionLabel.frame.size.width-5.0;
	if (maxWidth < 15.0)
		maxWidth = 0.0;
	
	if (size.width > maxWidth)
		size.width = maxWidth;
	
	[teamLabel setFrame:CGRectMake(CGRectGetMaxX(positionLabel.frame)+5.0, teamLabel.frame.origin.y, size.width, teamLabel.frame.size.height)];
}

- (void)setCreatedTimeInterval:(NSTimeInterval)newCreatedTimeInterval
{
	[super setCreatedTimeInterval:newCreatedTimeInterval];
	
	NSString *linTimeStr = [NSString stringWithFormat:@"%f",newCreatedTimeInterval];
	
	NSString *dateStr = [NSString calculateDate:linTimeStr];
	[timeLabel setText:dateStr];
	
	NSString *dateDetailStr = [NSString formattingDate:linTimeStr withFormat:@"yyyy년 M월 d일 a h시 m분"];
	[timeDetailLabel setText:dateDetailStr];
}

- (void)setAddress:(NSString *)newAddress
{
	[super setAddress:newAddress];
	
	[whLabel setText:newAddress];
}


- (void)setDesc:(NSString *)newDesc
{
	[super setDesc:newDesc];
	
	NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
	NSString *con = newDesc;
	if ([con length] > 360) {
		con = [con substringToIndex:360];
	}
	CGSize contentSize = [con sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(240, 130) lineBreakMode:UILineBreakModeWordWrap];
	if ([newDesc length] == 0) {
		contentSize.height = 0.0;
	}
	[contentsLabel setText:con];
	[contentsLabel setFrame:CGRectMake(contentsLabel.frame.origin.x, contentsLabel.frame.origin.y, contentsLabel.frame.size.width, contentSize.height)];
}

- (void)setUrlArray:(NSMutableArray *)newUrlArray
{
	[super setUrlArray:newUrlArray];
	
	NSInteger imageCount = [urlArray count];
	if (imageCount > 1) {
		CGSize contentSize = [contentsLabel.text sizeWithFont:contentsLabel.font constrainedToSize:CGSizeMake(240, 50) lineBreakMode:UILineBreakModeWordWrap];
		CGFloat viewMargin = 20.0;
		if ([contentsLabel.text length] == 0) {
			contentSize.height = 0.0;
			viewMargin = 7.0;
		}
		[contentsLabel setNumberOfLines:2];
		[contentsLabel setFrame:CGRectMake(contentsLabel.frame.origin.x, contentsLabel.frame.origin.y, contentsLabel.frame.size.width, contentSize.height)];

		[contentImageView setFrame:CGRectMake(contentImageView.frame.origin.x, CGRectGetMaxY(contentsLabel.frame)+viewMargin, contentImageView.frame.size.width, contentImageView.frame.size.height)];
		[contentImageView setHidden:NO];
		
		
//		UIImageView *inImageView = [[UIImageView alloc]init];
//		[inImageView setContentMode:UIViewContentModeScaleAspectFill];
//		[inImageView setClipsToBounds:YES];
//		inImageView.frame = CGRectMake(0,0,254,137);
//		NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:imgString num:0 thumbnail:YES];
		NSURL *imgURL = [NSURL URLWithString:newUrlArray[1]];
		
		[contentImageView setImageWithURL:imgURL placeholderImage:nil options:SDWebImageRetryFailed success:^(UIImage *image, BOOL cached) {
			
		} failure:^(NSError *error) {
			NSLog(@"fail %@",[error localizedDescription]);
			[HTTPExceptionHandler handlingByError:error];
			
		}];
//		[contentImageView addSubview:inImageView];
		
		if(imageCount > 2) {
			
			UIImageView *multiImage = [[UIImageView alloc]initWithFrame:contentImageView.frame];
			multiImage.image = [UIImage imageNamed:@"sns_manyphotos_cover.png"];
			[defaultView addSubview:multiImage];
			
			UIImageView *countImage = [[UIImageView alloc]initWithFrame:CGRectMake(multiImage.frame.size.width-15,5,17,29)];
			countImage.image = [UIImage imageNamed:@"number_tab.png"];
			[multiImage addSubview:countImage];
			
			UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(4,7,15,15)];
			countLabel.font = [UIFont systemFontOfSize:14];
			countLabel.textColor = [UIColor whiteColor];
			countLabel.backgroundColor = [UIColor clearColor];
			countLabel.text = [NSString stringWithFormat:@"%d",(int)imageCount-1];
			[countImage addSubview:countLabel];
			
			[multiImage release];
			[countImage release];
			[countLabel release];
		} else {
			
			UIImageView *coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,contentImageView.frame.size.width,contentImageView.frame.size.height)];
			coverImage.image = [UIImage imageNamed:@"sns_photo_cover.png"];
			[contentImageView addSubview:coverImage];
			[coverImage release];
		}
				
		[defaultView setFrame:CGRectMake(defaultView.frame.origin.x, defaultView.frame.origin.y, defaultView.frame.size.width, CGRectGetMaxY(contentImageView.frame)+8.0)];

	} else {
		[contentsLabel setNumberOfLines:7];
		
		[contentImageView setFrame:CGRectMake(contentImageView.frame.origin.x, CGRectGetMaxY(contentsLabel.frame)+20.0, contentImageView.frame.size.width, contentImageView.frame.size.height)];
		[contentImageView setHidden:YES];
		
		[defaultView setFrame:CGRectMake(defaultView.frame.origin.x, defaultView.frame.origin.y, defaultView.frame.size.width, CGRectGetMaxY(contentsLabel.frame)+8.0)];
	}
	
	[bottomView setFrame:CGRectMake(bottomView.frame.origin.x, CGRectGetMaxY(defaultView.frame), bottomView.frame.size.width, 29.0)];
}


- (void)setReplyArray:(NSMutableArray *)newReplyArray
{
	[super setReplyArray:newReplyArray];
	NSString *count = [NSString stringWithFormat:@"%i",(int)[newReplyArray count]];
	[replyCountLabel setText:count];
}

- (void)setLikeArray:(NSMutableArray *)newLikeArray
{
	[super setLikeArray:newLikeArray];
	NSString *count = [NSString stringWithFormat:@"%i",(int)[newLikeArray count]];
	[likeCountLabel setText:count];
}

@end
