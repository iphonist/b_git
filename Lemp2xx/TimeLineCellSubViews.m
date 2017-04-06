
#import "TimeLineCellSubViews.h"
#import "HomeTimeLineViewController.h"
#import "UIImageView+AFNetworking.h"
//#import "UIImage+RoundedCorner.h"
#import "SocialSearchViewController.h"
#ifdef MQM
#import "MQMDailyViewController.h"
#endif
@implementation TimeLineCellSubViews


#define kNotFavorite 1
#define kFavorite 2
#define kNothing 3

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier viewController:(UIViewController*)viewController
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
#ifdef BearTalk
        
//        UIImageView *bgView = [[UIImageView alloc]init];
//        bgView.backgroundColor = [UIColor whiteColor];
//        self.backgroundView = bgView;
        self.contentView.backgroundColor = RGB(238, 242, 245);//[UIColor whiteColor];
        
        parentViewCon = viewController;
        
        
        bgView = [[UIView alloc]init];
        bgView.frame = CGRectMake(0,0,self.contentView.frame.size.width,0);
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        defaultView = [[UIView alloc]init];
        defaultView.frame = CGRectMake(16, 0, bgView.frame.size.width - 32, 14+42+14);
        [bgView addSubview:defaultView];
        //        [defaultView release];
        defaultView.backgroundColor = [UIColor clearColor];
        //        roundingView.frame = CGRectMake(5, 5, 310 ,CGRectGetMaxY(defaultView.frame));
        
        contentsView = [[UIView alloc]init];
        contentsView.frame = CGRectMake(defaultView.frame.origin.x, CGRectGetMaxY(defaultView.frame), defaultView.frame.size.width, 0);
        [bgView addSubview:contentsView];
        //        [contentsView release];
        contentsView.backgroundColor = [UIColor clearColor];
        
        optionView = [[UIImageView alloc]init];
        optionView.frame = CGRectMake(0, CGRectGetMaxY(optionView.frame), bgView.frame.size.width, 0);
        [bgView addSubview:optionView];
        //        [optionView release];
        optionView.backgroundColor = RGB(247, 247, 249);
        
//        replyView = [[UIView alloc]init];
//        replyView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 0);
//        [self.contentView addSubview:replyView];
//        //        [replyView release];
//        replyView.backgroundColor = [UIColor clearColor];
//        
//        replyViewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,replyView.frame.size.width,replyView.frame.size.height)];
//        [replyViewButton addTarget:self action:@selector(goReply:) forControlEvents:UIControlEventTouchUpInside];
//        [replyViewButton setShowsTouchWhenHighlighted:YES];
//        [replyView addSubview:replyViewButton];
        //        [replyViewButton release];
        
        
        
        profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 14, 42, 42)];
        [defaultView addSubview:profileImageView];
        profileImageView.userInteractionEnabled = YES;
        //        [profileImageView release];
        
        nameLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(profileImageView.frame.origin.x + profileImageView.frame.size.width + 5, profileImageView.frame.origin.y, 90, 17)];
        nameLabel.frame = CGRectMake(CGRectGetMaxX(profileImageView.frame) + 8, profileImageView.frame.origin.y+5, 85, 17);
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextColor:RGB(32, 32, 32)];

        UIImageView *roundingView;
        roundingView.frame = CGRectMake(0,0,profileImageView.frame.size.width,profileImageView.frame.size.height);
        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        [profileImageView addSubview:roundingView];

        
        [defaultView addSubview:nameLabel];
        //        [nameLabel release];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame) + 6, 100, 14)];
        [timeLabel setTextAlignment:NSTextAlignmentLeft];
        [timeLabel setTextColor:RGB(151,152,157)];
        [timeLabel setFont:[UIFont systemFontOfSize:12]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [defaultView addSubview:timeLabel];
        //        [timeLabel release];
        
        
        positionLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 5, 0, 0)];
        [positionLabel setTextAlignment:NSTextAlignmentLeft];
        [positionLabel setTextColor:RGB(151,152,157)];
        [positionLabel setFont:[UIFont systemFontOfSize:12]];
        [positionLabel setBackgroundColor:[UIColor clearColor]];
        [defaultView addSubview:positionLabel];
        //        [positionLabel release];
        
        
        
        
        
        
        [defaultView setUserInteractionEnabled:YES];
        favButton = [[UIButton alloc]initWithFrame:CGRectMake(defaultView.frame.size.width - 16 - 17, 0, 0, 0)];
        [favButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_off.png"] forState:UIControlStateNormal];
        [favButton addTarget:self action:@selector(addOrClear:) forControlEvents:UIControlEventTouchUpInside];
        [defaultView addSubview:favButton];
//        favButton.backgroundColor = [UIColor redColor];
        favButton.tag = kNotFavorite;
        //        [favButton release];
        
        arrLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 5, 0, 0)];
        [arrLabel setTextAlignment:NSTextAlignmentLeft];
        [arrLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [arrLabel setBackgroundColor:[UIColor clearColor]];
        [arrLabel setTextColor:RGB(64,88,115)];
        [defaultView addSubview:arrLabel];
        //        [arrLabel release];
        
        toLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 5, 0, 0)];
        [toLabel setTextAlignment:NSTextAlignmentLeft];
        [toLabel setFont:[UIFont systemFontOfSize:14.0]];
        [toLabel setBackgroundColor:[UIColor clearColor]];
        [toLabel setTextColor:[UIColor grayColor]];
        toLabel.adjustsFontSizeToFitWidth = YES;
        toLabel.minimumScaleFactor = 11.0/[UIFont labelFontSize];
        [defaultView addSubview:toLabel];
        //        [toLabel release];
        
        
        //		subLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-60-100, 10, 100, 17)];
        //		[subLabel setTextAlignment:NSTextAlignmentRight];
        //		[subLabel setFont:[UIFont systemFontOfSize:14.0]];
        //		[subLabel setBackgroundColor:[UIColor clearColor]];
        //        [subLabel setTextColor:[UIColor lightGrayColor]];
        
        //        UIImageView *toImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,32,10,10)];
        //        toImage.image = [UIImage imageNamed:@"arrowgroupname.png"];
        
        //        toLabel.minimumScaleFactor = 0.9f;
        
        //        teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 0, 0)];
        //		[teamLabel setTextAlignment:NSTextAlignmentLeft];
        //        [teamLabel setTextColor:[UIColor grayColor]];
        //		[teamLabel setFont:[UIFont systemFontOfSize:12.0]];
        //		[teamLabel setBackgroundColor:[UIColor clearColor]];
        
        
        
        
        
        //		defaultView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 5, 270, 0)];
        //        defaultView.image = [[UIImage imageNamed:@"sns_balloonbg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 0, 1, 0)];
        //		[defaultView setContentMode:UIViewContentModeScaleToFill];
        //		[defaultView setClipsToBounds:YES];
        //		[defaultView setAutoresizesSubviews:YES];
        //  		[defaultView setUserInteractionEnabled:YES];
        
        
        
        
        NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
        
        contentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width, 0)];
        [contentsLabel setTextAlignment:NSTextAlignmentLeft];
        [contentsLabel setTextColor:RGB(51, 51, 51)];
        [contentsLabel setFont:[UIFont systemFontOfSize:fontSize]];
        [contentsLabel setBackgroundColor:[UIColor clearColor]];
        [contentsLabel setAdjustsFontSizeToFitWidth:NO];
        [contentsLabel setNumberOfLines:10];
        [contentsView addSubview:contentsLabel];
        //        [contentsLabel release];
        
        
        whImageView = [[UIImageView alloc]init];
//        whImageView.image = [UIImage imageNamed:@"location_ic.png"];
        [contentsView addSubview:whImageView];
        //        [whImageView release];
        //        whImageView.hidden = YES;
        
        whLabel = [[UILabel alloc]init];
        [whLabel setTextAlignment:NSTextAlignmentLeft];
        [whLabel setFont:[UIFont systemFontOfSize:14.0]];
        [whLabel setBackgroundColor:[UIColor clearColor]];
        [whLabel setTextColor:RGB(216, 68, 60)];
        [contentsView addSubview:whLabel];
        //        [whLabel release];
        
        
        
        
        contentImageView = [[UIImageView alloc] init];
        [contentsView addSubview:contentImageView];
        //        [contentImageView release];
        
        
        pollView = [[UIImageView alloc]init];
        [contentsView addSubview:pollView];
        //        pollView.image = [UIImage imageNamed:@"vote_listbtnbg.png"];
        //        [pollView release];
        
        fileView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, pollView.frame.origin.y + pollView.frame.size.height + 10, 240, 0)];
        [contentsView addSubview:fileView];

        
        
        likeButton = [[UIButton alloc]init];
        [likeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [optionView addSubview:likeButton];
        [likeButton addTarget:self action:@selector(sendLike:) forControlEvents:UIControlEventTouchUpInside];
        //        [likeButton release];
        
        
        likeImage = [[UIImageView alloc]init];
        likeImage.image = [UIImage imageNamed:@"btn_like_off.png"];
        [likeButton addSubview:likeImage];
        //        likeIconButton = [[UIButton alloc]init];
        //        [likeIconButton setBackgroundImage:[UIImage imageNamed:@"goodicon.png"] forState:UIControlStateNormal];
        //        [optionView addSubview:likeIconButton];
        //        [likeIconButton release];
        
        likeCountLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 5, 0, 0)];
        [likeCountLabel setTextAlignment:NSTextAlignmentCenter];
        [likeCountLabel setTextColor:RGB(184, 184, 184)];
        [likeCountLabel setFont:[UIFont systemFontOfSize:12]];
        [likeCountLabel setBackgroundColor:[UIColor clearColor]];
        [likeButton addSubview:likeCountLabel];
        //        [likeCountLabel release];
        
        likeLabel = [CustomUIKit labelWithText:@"좋아요" fontSize:12 fontColor:RGB(113, 113, 115) frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
        likeLabel.backgroundColor = [UIColor clearColor];
        //        likeLabel.layer.borderWidth = 0.5;
        //        likeLabel.layer.borderColor = [UIColor grayColor].CGColor;
        //        likeLabel.layer.cornerRadius = 3.0; // rounding label
        //        likeLabel.clipsToBounds = YES;
        likeLabel.userInteractionEnabled = YES;
        [likeButton addSubview:likeLabel];
        
        
        replyButton = [[UIButton alloc]init];
        [replyButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [optionView addSubview:replyButton];
        [replyButton addTarget:self action:@selector(goReplyWrite) forControlEvents:UIControlEventTouchUpInside];
        //        [replyButton release];
        
        
        replyImage = [[UIImageView alloc]init];
        replyImage.image = [UIImage imageNamed:@"btn_reply.png"];
        [replyButton addSubview:replyImage];
        //        [replyIconButton release];
        
        replyCountLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 5, 0, 0)];
        [replyCountLabel setTextAlignment:NSTextAlignmentCenter];
        [replyCountLabel setTextColor:RGB(184, 184, 184)];
        [replyCountLabel setFont:[UIFont systemFontOfSize:12]];
        [replyCountLabel setBackgroundColor:[UIColor clearColor]];
        [replyButton addSubview:replyCountLabel];
        //        [replyCountLabel release];
        
        replyLabel = [CustomUIKit labelWithText:@"댓글" fontSize:12 fontColor:RGB(113, 113, 115) frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
        replyLabel.backgroundColor = [UIColor clearColor];
        //        replyLabel.layer.borderWidth = 0.5;
        //        replyLabel.layer.borderColor = [UIColor grayColor].CGColor;
        //        replyLabel.layer.cornerRadius = 3.0; // rounding label
        //        replyLabel.clipsToBounds = YES;
        //        replyLabel.userInteractionEnabled = YES;
        [replyButton addSubview:replyLabel];
        
        shareLabel = [CustomUIKit labelWithText:@"" fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
        
        shareLabel.layer.borderWidth = 0.5;
        shareLabel.layer.borderColor = [UIColor grayColor].CGColor;
        shareLabel.layer.cornerRadius = 3.0; // rounding label
        shareLabel.clipsToBounds = YES;
        shareLabel.userInteractionEnabled = YES;
        [optionView addSubview:shareLabel];
        
        
        shareButton = [[UIButton alloc]init];
        [shareButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [shareLabel addSubview:shareButton];
#else
        parentViewCon = viewController;
        
        bottomRoundingView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 310, 0)];
        bottomRoundingView.image = [[UIImage imageNamed:@"sns_balloon_04.png"]stretchableImageWithLeftCapWidth:135 topCapHeight:22];
        [self.contentView addSubview:bottomRoundingView];
//        [bottomRoundingView release];
        
        defaultView = [[UIView alloc]init];
        defaultView.frame = CGRectMake(15, 15, self.contentView.frame.size.width - 32, 40);
        [self.contentView addSubview:defaultView];
//        [defaultView release];
        defaultView.backgroundColor = [UIColor clearColor];
        //        roundingView.frame = CGRectMake(5, 5, 310 ,CGRectGetMaxY(defaultView.frame));
        
        contentsView = [[UIView alloc]init];
        contentsView.frame = CGRectMake(15, 0, self.contentView.frame.size.width - 32, 0);
        [self.contentView addSubview:contentsView];
//        [contentsView release];
        contentsView.backgroundColor = [UIColor clearColor];
        
        optionView = [[UIImageView alloc]init];
        optionView.frame = CGRectMake(15, 0, self.contentView.frame.size.width - 32, 0);
        [self.contentView addSubview:optionView];
//        [optionView release];
        optionView.backgroundColor = [UIColor clearColor];
        
        replyView = [[UIView alloc]init];
        replyView.frame = CGRectMake(15, 0, self.contentView.frame.size.width - 32, 0);
        [self.contentView addSubview:replyView];
//        [replyView release];
        replyView.backgroundColor = [UIColor clearColor];
        
        replyViewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,replyView.frame.size.width,replyView.frame.size.height)];
        [replyViewButton addTarget:self action:@selector(goReply:) forControlEvents:UIControlEventTouchUpInside];
        [replyViewButton setShowsTouchWhenHighlighted:YES];
        [replyView addSubview:replyViewButton];
//        [replyViewButton release];
        
        
        
        profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [defaultView addSubview:profileImageView];
        profileImageView.userInteractionEnabled = YES;
//        [profileImageView release];
        
        nameLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(profileImageView.frame.origin.x + profileImageView.frame.size.width + 5, profileImageView.frame.origin.y, 90, 17)];
        nameLabel.frame = CGRectMake(profileImageView.frame.origin.x + profileImageView.frame.size.width + 5, profileImageView.frame.origin.y, 85, 17);
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextColor:RGB(87, 107, 149)];
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        nameLabel.textColor = GreenTalkColor;
        
        
        UIImageView *roundingView;
        roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(0,0,profileImageView.frame.size.width,profileImageView.frame.size.height);
        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        [profileImageView addSubview:roundingView];
//        [roundingView release];
#endif
        [defaultView addSubview:nameLabel];
//        [nameLabel release];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileImageView.frame.origin.x + profileImageView.frame.size.width + 5, profileImageView.frame.origin.y + profileImageView.frame.size.height - 16, 150, 13)];
        [timeLabel setTextAlignment:NSTextAlignmentLeft];
        [timeLabel setTextColor:[UIColor darkGrayColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:11]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [defaultView addSubview:timeLabel];
//        [timeLabel release];
        
        
        positionLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 5, 0, 0)];
        [positionLabel setTextAlignment:NSTextAlignmentLeft];
        [positionLabel setTextColor:[UIColor grayColor]];
        [positionLabel setFont:[UIFont systemFontOfSize:14.0]];
        [positionLabel setBackgroundColor:[UIColor clearColor]];
        [defaultView addSubview:positionLabel];
//        [positionLabel release];
        
        
       spgLabel = [CustomUIKit labelWithText:@"" fontSize:9 fontColor:RGB(41, 92, 172) frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
        spgLabel.backgroundColor = RGB(216, 216, 216);
        spgLabel.layer.cornerRadius = 3.0; // rounding label
        spgLabel.clipsToBounds = YES;
        [defaultView addSubview:spgLabel];
        
        hpgLabel = [CustomUIKit labelWithText:@"" fontSize:9 fontColor:RGB(168, 21, 6) frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
        hpgLabel.backgroundColor = RGB(216, 216, 216);
        hpgLabel.layer.cornerRadius = 3.0; // rounding label
        hpgLabel.clipsToBounds = YES;
        [defaultView addSubview:hpgLabel];
        
        
        nbgLabel = [CustomUIKit labelWithText:@"" fontSize:9 fontColor:RGB(38, 152, 129) frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
        nbgLabel.backgroundColor = RGB(216, 216, 216);
        nbgLabel.layer.cornerRadius = 3.0; // rounding label
        nbgLabel.clipsToBounds = YES;
        [defaultView addSubview:nbgLabel];
        
        
        
        
        
        favButton = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 32-36, 0, 36, 0)];
        [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_dft.png"] forState:UIControlStateNormal];
        [favButton addTarget:self action:@selector(addOrClear:) forControlEvents:UIControlEventTouchUpInside];
        [defaultView addSubview:favButton];
        
        favButton.tag = kNotFavorite;
//        [favButton release];
        
        arrLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 5, 0, 0)];
        [arrLabel setTextAlignment:NSTextAlignmentLeft];
        [arrLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [arrLabel setBackgroundColor:[UIColor clearColor]];
        [arrLabel setTextColor:RGB(64,88,115)];
        [defaultView addSubview:arrLabel];
//        [arrLabel release];
        
        toLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 5, 0, 0)];
        [toLabel setTextAlignment:NSTextAlignmentLeft];
        [toLabel setFont:[UIFont systemFontOfSize:14.0]];
        [toLabel setBackgroundColor:[UIColor clearColor]];
        [toLabel setTextColor:[UIColor grayColor]];
        toLabel.adjustsFontSizeToFitWidth = YES;
        toLabel.minimumScaleFactor = 11.0/[UIFont labelFontSize];
        [defaultView addSubview:toLabel];
//        [toLabel release];
        
        
        //		subLabel = [[UILabel alloc] initWithFrame:CGRectMake(320-60-100, 10, 100, 17)];
        //		[subLabel setTextAlignment:NSTextAlignmentRight];
        //		[subLabel setFont:[UIFont systemFontOfSize:14.0]];
        //		[subLabel setBackgroundColor:[UIColor clearColor]];
        //        [subLabel setTextColor:[UIColor lightGrayColor]];
        
        //        UIImageView *toImage = [[UIImageView alloc]initWithFrame:CGRectMake(10,32,10,10)];
        //        toImage.image = [UIImage imageNamed:@"arrowgroupname.png"];
        
        //        toLabel.minimumScaleFactor = 0.9f;
        
        //        teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 0, 0)];
        //		[teamLabel setTextAlignment:NSTextAlignmentLeft];
        //        [teamLabel setTextColor:[UIColor grayColor]];
        //		[teamLabel setFont:[UIFont systemFontOfSize:12.0]];
        //		[teamLabel setBackgroundColor:[UIColor clearColor]];
        
        
        
        
        
        //		defaultView = [[UIImageView alloc] initWithFrame:CGRectMake(45, 5, 270, 0)];
        //        defaultView.image = [[UIImage imageNamed:@"sns_balloonbg_top.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 0, 1, 0)];
        //		[defaultView setContentMode:UIViewContentModeScaleToFill];
        //		[defaultView setClipsToBounds:YES];
        //		[defaultView setAutoresizesSubviews:YES];
        //  		[defaultView setUserInteractionEnabled:YES];
        
        
        
        
        NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
        
        contentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width - 32, 0)];
        [contentsLabel setTextAlignment:NSTextAlignmentLeft];
        [contentsLabel setFont:[UIFont systemFontOfSize:fontSize]];
        [contentsLabel setBackgroundColor:[UIColor clearColor]];
        [contentsLabel setAdjustsFontSizeToFitWidth:NO];
        [contentsLabel setNumberOfLines:10];
        [contentsView addSubview:contentsLabel];
//        [contentsLabel release];
        
        
        whImageView = [[UIImageView alloc]init];
        whImageView.image = [UIImage imageNamed:@"location_ic.png"];
        [contentsView addSubview:whImageView];
//        [whImageView release];
        //        whImageView.hidden = YES;
        
        whLabel = [[UILabel alloc]init];
        [whLabel setTextAlignment:NSTextAlignmentLeft];
        [whLabel setFont:[UIFont systemFontOfSize:14.0]];
        [whLabel setBackgroundColor:[UIColor clearColor]];
        [whLabel setTextColor:RGB(216, 68, 60)];
        [contentsView addSubview:whLabel];
//        [whLabel release];
        
        
        
        
        contentImageView = [[UIImageView alloc] init];
        [contentsView addSubview:contentImageView];
//        [contentImageView release];
        
        
        pollView = [[UIImageView alloc]init];
        [contentsView addSubview:pollView];
        //        pollView.image = [UIImage imageNamed:@"vote_listbtnbg.png"];
        pollView.image = [[UIImage imageNamed:@"vote_listbtnbg.png"]stretchableImageWithLeftCapWidth:130 topCapHeight:36];
//        [pollView release];
        
        fileView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, pollView.frame.origin.y + pollView.frame.size.height + 10, 240, 0)];
        [contentsView addSubview:fileView];
        fileView.image = [[UIImage imageNamed:@"vote_listbtnbg.png"]stretchableImageWithLeftCapWidth:130 topCapHeight:36];
        //        fileView.image = [UIImage imageNamed:@"vote_listbtnbg.png"];
//        [fileView release];
        
        
        //		readLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
        //		[readLabel setTextAlignment:NSTextAlignmentRight];
        //        [readLabel setTextColor:[UIColor darkGrayColor]];
        //		[readLabel setFont:[UIFont systemFontOfSize:14.0]];
        //		[readLabel setBackgroundColor:[UIColor clearColor]];
        
        
        
        //        roundingView = [[UIImageView alloc]initWithFrame:CGRectMake(10, nameLabel.frame.origin.y + nameLabel.frame.size.height + 3, 204, 0)];
        //        roundingView.image = [[UIImage imageNamed:@"n01_tl_wc_bg.png"]stretchableImageWithLeftCapWidth:0 topCapHeight:32];
        //        roundingView.image = nil;
        //		[roundingView setContentMode:UIViewContentModeScaleToFill];
        //		[roundingView setClipsToBounds:YES];
        //		[roundingView setAutoresizesSubviews:YES];
        //  		[roundingView setUserInteractionEnabled:YES];
        //        roundingView.hidden = YES;
        
        //        UIImageView *foodImage = [[UIImageView alloc]initWithFrame:CGRectMake(5,8,48,48)];
        //        foodImage.image = [UIImage imageNamed:@"sidn_photo_05.png"];
        //        [roundingView addSubview:foodImage];
        //        [foodImage release];
        //
        //        UIImageView *decoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,48,48)];
        //        decoImage.image = [UIImage imageNamed:@"sidn_bg.png"];
        //        [foodImage addSubview:decoImage];
        //        [decoImage release];
        
        //		[defaultView addSubview:nameLabel];
        ////		[defaultView addSubview:subLabel];
        //        //        [defaultView addSubview:toImage];
        //        [defaultView addSubview:arrLabel];
        //        [defaultView addSubview:toLabel];
        //        [defaultView addSubview:readLabel];
        ////		[defaultView addSubview:teamLabel];
        //		[defaultView addSubview:positionLabel];
        ////        [defaultView addSubview:roundingView];
        //		[defaultView addSubview:contentsLabel];
        //        [nameLabel release];
        ////        [subLabel release];
        ////        [toImage release];
        //        [readLabel release];
        //        [toLabel release];
        //        [arrLabel release];
        ////        [teamLabel release];
        //        [positionLabel release];
        //        [contentsLabel release];
        //        [roundingView release];
        
        //        deleteButton = [[UIButton alloc]init];
        //        [deleteButton addTarget:self action:@selector(deletePost:) forControlEvents:UIControlEventTouchUpInside];
        //        [deleteButton setBackgroundImage:[UIImage imageNamed:@"n02_whay_btn_x.png"] forState:UIControlStateNormal];
        //        deleteButton.frame = CGRectMake(190, 5, 19, 19);
        //        [defaultView addSubview:deleteButton];
        //        deleteButton.hidden = YES;
        //        [deleteButton release];
        
        //        likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 10, 270, 0)];
        //        likeImageView.image = [[UIImage imageNamed:@"sns_balloonbg_btm.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 3, 0)];
        
        //		UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, likeImageView.frame.size.width, 1)];
        //		line.image = [UIImage imageNamed:@"balon_grayline.png"];
        //		[likeImageView addSubview:line];
        //		[line release];

        
        likeIconButton = [[UIButton alloc]init];
        [likeIconButton setBackgroundImage:[UIImage imageNamed:@"goodicon.png"] forState:UIControlStateNormal];
        [optionView addSubview:likeIconButton];
//        [likeIconButton release];
        
        likeCountLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 5, 0, 0)];
        [likeCountLabel setTextAlignment:NSTextAlignmentLeft];
        [likeCountLabel setTextColor:[UIColor grayColor]];
        [likeCountLabel setFont:[UIFont systemFontOfSize:14.0]];
        [likeCountLabel setBackgroundColor:[UIColor clearColor]];
        [optionView addSubview:likeCountLabel];
//        [likeCountLabel release];
        
        replyIconButton = [[UIButton alloc]init];
        [replyIconButton setBackgroundImage:[UIImage imageNamed:@"commentic.png"] forState:UIControlStateNormal];
        [optionView addSubview:replyIconButton];
//        [replyIconButton release];
        
        replyCountLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 5, 0, 0)];
        [replyCountLabel setTextAlignment:NSTextAlignmentLeft];
        [replyCountLabel setTextColor:[UIColor grayColor]];
        [replyCountLabel setFont:[UIFont systemFontOfSize:14.0]];
        [replyCountLabel setBackgroundColor:[UIColor clearColor]];
        [optionView addSubview:replyCountLabel];
//        [replyCountLabel release];
        
        
        likeLabel = [CustomUIKit labelWithText:@"좋아요" fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
        likeLabel.backgroundColor = [UIColor whiteColor];
        likeLabel.layer.borderWidth = 0.5;
        likeLabel.layer.borderColor = [UIColor grayColor].CGColor;
        likeLabel.layer.cornerRadius = 3.0; // rounding label
        likeLabel.clipsToBounds = YES;
        likeLabel.userInteractionEnabled = YES;
        [optionView addSubview:likeLabel];
        
        likeButton = [[UIButton alloc]init];
        [likeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [likeLabel addSubview:likeButton];
        [likeButton addTarget:self action:@selector(sendLike:) forControlEvents:UIControlEventTouchUpInside];
//        [likeButton release];
        
        replyLabel = [CustomUIKit labelWithText:@"댓글" fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
        replyLabel.backgroundColor = [UIColor whiteColor];
        replyLabel.layer.borderWidth = 0.5;
        replyLabel.layer.borderColor = [UIColor grayColor].CGColor;
        replyLabel.layer.cornerRadius = 3.0; // rounding label
        replyLabel.clipsToBounds = YES;
        replyLabel.userInteractionEnabled = YES;
        [optionView addSubview:replyLabel];
        
        replyButton = [[UIButton alloc]init];
        [replyButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [replyLabel addSubview:replyButton];
        [replyButton addTarget:self action:@selector(goReplyWrite) forControlEvents:UIControlEventTouchUpInside];
//        [replyButton release];
        
        shareLabel = [CustomUIKit labelWithText:@"" fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];

        shareLabel.layer.borderWidth = 0.5;
        shareLabel.layer.borderColor = [UIColor grayColor].CGColor;
        shareLabel.layer.cornerRadius = 3.0; // rounding label
        shareLabel.clipsToBounds = YES;
        shareLabel.userInteractionEnabled = YES;
        [optionView addSubview:shareLabel];
        
        
        shareButton = [[UIButton alloc]init];
        [shareButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [shareLabel addSubview:shareButton];
//        [shareButton release];
        
        
        bgView = [[UIView alloc]init];
        bgView.backgroundColor = RGB(246,246,246);
        self.backgroundView = bgView;
#endif
        
        
        
        //		accept = [CustomUIKit buttonWithTitle:@"" fontSize:15 fontColor:[UIColor blackColor] target:self selector:@selector(regiGroup:) frame:CGRectMake(30, defaultView.frame.origin.y + defaultView.frame.size.height + 10, 80, 0) cachedImageNamedBullet:nil cachedImageNamedNormal:@"btn_group_ok_untitled.png" cachedImageNamedPressed:nil];
        //        [defaultView addSubview:accept];
        //        accept.tag = 0;
        //        accept.hidden = YES;
        //
        //        acceptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        //        [acceptLabel setTextAlignment:NSTextAlignmentCenter];
        //		[acceptLabel setFont:[UIFont systemFontOfSize:16]];
        //		[acceptLabel setBackgroundColor:[UIColor clearColor]];
        //		[acceptLabel setTextColor:RGB(173,91,38)];
        //        [accept addSubview:acceptLabel];
        //        [acceptLabel release];
        //
        //        deny = [CustomUIKit buttonWithTitle:@"" fontSize:15 fontColor:[UIColor blackColor] target:self selector:@selector(regiGroup:) frame:CGRectMake(30 + accept.frame.size.width + 10, accept.frame.origin.y, 80, 0) cachedImageNamedBullet:nil cachedImageNamedNormal:@"btn_group_no_untitled.png" cachedImageNamedPressed:nil];
        //        [defaultView addSubview:deny];
        //        deny.tag = 1;
        //        deny.hidden = YES;
        //
        //        denyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
        //        [denyLabel setTextAlignment:NSTextAlignmentCenter];
        //		[denyLabel setFont:[UIFont systemFontOfSize:16]];
        //		[denyLabel setBackgroundColor:[UIColor clearColor]];
        //		[denyLabel setTextColor:RGB(142,136,134)];
        //        [deny addSubview:denyLabel];
        //        [denyLabel release];
        
//        [bgView release];
        
        
//               webviewHeight = 0.0f;
    }
    
    return self;
}


#pragma mark - button action

//- (void)deletePost:(id)sender{
//    [sender setEnabled:NO];
//    [parentViewCon deletePost:self.idx];
//    //    NSLog(@"self.idx %@",self.idx);
//}

- (void)goodMember:(id)sender
{
    if([self.likeArray count]<1)
        return;
    //    NSLog(@"goodMember %@ con %@",self.likeArray,parentViewCon);
    [SharedAppDelegate.root.home pushGood:self.likeArray con:parentViewCon];
    
}
- (void)sendLike:(id)sender
{
    //	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:sender label:nil animated:YES];
    UIButton *button = (UIButton*)sender;
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.tag = 22;
    [activity setCenter:button.center];
    [activity hidesWhenStopped];
    [button addSubview:activity];
    [activity startAnimating];
    //    [activity release];
    if ([parentViewCon isKindOfClass:[HomeTimelineViewController class]])
        [(HomeTimelineViewController *)parentViewCon sendLike:self.idx sender:sender con:SharedAppDelegate.root.home];
    if ([parentViewCon isKindOfClass:[SocialSearchViewController class]])
        [(SocialSearchViewController *)parentViewCon sendLike:self.idx sender:sender];
}

- (void)goToYourTimeline:(id)sender{
    NSLog(@"goToYourTimeline %@ %@",self.profileImage,self.writeinfoType);
    
    if(self.profileImage == nil && [self.profileImage length]==0)
        return;
    
    if(![self.writeinfoType isEqualToString:@"1"])
        return;
    
    [SharedAppDelegate.root.home goToYourTimeline:self.profileImage];
}

- (void)goReplyWrite
{
    if ([parentViewCon isKindOfClass:[HomeTimelineViewController class]])
        [(HomeTimelineViewController *)parentViewCon goReply:self.idx withKeyboard:YES];
    if ([parentViewCon isKindOfClass:[SocialSearchViewController class]])
        [(SocialSearchViewController *)parentViewCon goReply:self.idx withKeyboard:YES];
}

- (void)goReply:(id)sender{
    NSLog(@"gogo reply");
    
    if ([parentViewCon isKindOfClass:[HomeTimelineViewController class]])
        [(HomeTimelineViewController *)parentViewCon goReply:self.idx withKeyboard:NO];
    
    if ([parentViewCon isKindOfClass:[SocialSearchViewController class]])
        [(SocialSearchViewController *)parentViewCon goReply:self.idx withKeyboard:NO];
}
- (void)goToReplyTimeline:(id)sender{
    NSLog(@"goToReplyTimeline %@",[[sender titleLabel]text]);
    
    if([[sender titleLabel]text] == nil && [[[sender titleLabel]text] length]==0)
        return;
    
    if([sender tag]!=1)
        return;
    
    [SharedAppDelegate.root.home goToYourTimeline:[[sender titleLabel]text]];
}
#define kShare 800

- (void)goShare{//:(id)sender{
    
    [CustomUIKit popupAlertViewOK:@"공유" msg:@"Best Practice 컨텐츠 소셜로 선택한 글을\n공유 합니다. " delegate:SharedAppDelegate.root.home tag:kShare sel:@selector(goShare:) with:self.idx csel:nil with:nil];
}
- (void)goShareAgain{
    
    [CustomUIKit popupAlertViewOK:@"공유" msg:@"Best Practice 컨텐츠 소셜로 공유 된 이력이\n있는 글 입니다. 한번 더 Best Practice\n컨텐츠 소셜로 공유 하시겠습니까?" delegate:SharedAppDelegate.root.home tag:kShare sel:@selector(goShare:) with:self.idx csel:nil with:nil];
}

#pragma mark - setting

//- (void)setDeletePermission:(NSInteger)permission{
//    [super setDeletePermission:permission];
//
//    if(permission == 1 && [self.profileImage isEqualToString:self.myUID])
//        deleteButton.hidden = NO;
////    else
////        deleteButton.hidden = YES;
//}


- (void)setProfileImage:(NSString *)newProfileImage
{
    [super setProfileImage:newProfileImage];
    
    NSLog(@"newProfile %@",newProfileImage);
    
    
    UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,profileImageView.frame.size.width, profileImageView.frame.size.height)];
    viewButton.adjustsImageWhenHighlighted = NO;
    [viewButton addTarget:self action:@selector(goToYourTimeline:) forControlEvents:UIControlEventTouchUpInside];
    [profileImageView addSubview:viewButton];
    //     viewButton.titleLabel.text = newProfileImage;
//    [viewButton release];
    
#ifdef BearTalk
    
    favButton.frame = CGRectMake(defaultView.frame.size.width - 30+7, 14-3, 30, 30);
    bgView.frame = CGRectMake(0,0,self.contentView.frame.size.width,CGRectGetMaxY(defaultView.frame));
    NSLog(@"favButton frame %@",NSStringFromCGRect(favButton.frame));
#else
    
    favButton.frame = CGRectMake(self.contentView.frame.size.width - 32-36, 0, 36, 36);
    bottomRoundingView.frame = CGRectMake(5, 5, 310 ,CGRectGetMaxY(defaultView.frame));
    
#endif
}

- (void)setFavorite:(NSString *)newFavorite{
    [super setFavorite:newFavorite];
#ifdef BearTalk
    NSLog(@"newFavorite %@",newFavorite);
    if([newFavorite isEqualToString:@"0"]){
        [favButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_off.png"] forState:UIControlStateNormal];
        favButton.tag = kNotFavorite;
    }
    else{
        [favButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_on.png"] forState:UIControlStateNormal];
        favButton.tag = kFavorite;
    }
    NSLog(@"favButton frame %@",NSStringFromCGRect(favButton.frame));
#else
    if([newFavorite isEqualToString:@"0"]){
        [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_dft.png"] forState:UIControlStateNormal];
        favButton.tag = kNotFavorite;
    }
    else{
        [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_prs.png"] forState:UIControlStateNormal];
        favButton.tag = kFavorite;
    }
#endif
}

//- (void)setGroup:(NSString *)name// setCompany:(NSString *)com{
//{
//    [super setGroup:name];// setCompany:com];
//
//    if([name length]>0)
//        toLabel.text = [NSString stringWithFormat:@"➤ %@",name];
//}
//- (void)setCompany:(NSString *)com{
//    [super setCompany:com];
//
//    if([com length]>0)
//        toLabel.text = @"";
//}
//- (void)setTargetname:(NSString *)name{
//    [super setTargetname:name];
//
//    if([name length]>0)
//        toLabel.text = [NSString stringWithFormat:@"➤ %@",name];
//}


- (void)setNotice:(NSString *)not{
    [super setNotice:not];
}
- (void)setTargetdic:(NSString *)target{
    [super setTargetdic:target];
    
    NSLog(@"setTargetDic %@ ",target);
    NSDictionary *targetDic = [target objectFromJSONString];
    NSLog(@"targetDic %@",targetDic[@"category"]);
    if([targetDic[@"category"]isEqualToString:@"1"]){
        if([self.notice isEqualToString:@"1"]){
            //           toLabel.text = [NSString stringWithFormat:@"➤ %@",[[target objectFromJSONString]@"categoryname"]];
        }
        //        [arrLabel setText:@"➤"];
        //        toLabel.text = [NSString stringWithFormat:@"%@",targetDic[@"categoryname"]];
    }
    else if ([targetDic[@"category"]isEqualToString:@""])
    {
        
    }
    else{
        //            [arrLabel setText:@"➤"];
        //    toLabel.text = [NSString stringWithFormat:@"%@",targetDic[@"categoryname"]];
        
    }
    
    
    
}

- (void)setPersonInfo:(NSDictionary *)dic
{
    [super setPersonInfo:dic];// image:img time:newTime currentTime:current content:newContent where:location];
    
    NSLog(@"self.profileImage %@",self.profileImage);
    
#ifdef BearTalk
    
    NSDictionary *adic = IS_NULL(dic)?[SharedAppDelegate.root searchContactDictionary:self.profileImage]:dic;
    [nameLabel setText:adic[@"name"]];
//    [positionLabel setText:adic[@"grade2"]];
    [positionLabel setText:[NSString stringWithFormat:@"%@ | %@",adic[@"grade2"],adic[@"team"]]];

    
    [SharedAppDelegate.root getProfileImageWithURL:self.profileImage ifNil:@"profile_photo.png" view:profileImageView scale:0];
    
    
    
#else
    
    if([self.writeinfoType isEqualToString:@"2"]){
        
        [nameLabel setText:dic[@"deptname"]];
        nameLabel.textColor = RGB(160, 18, 19);
        [positionLabel setText:@""];
        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:dic[@"image"] num:0 thumbnail:YES];
        if (imgURL) {
            
            [profileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:[UIImage imageNamed:@"sns_profile_company.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly progress:^(NSInteger a, NSInteger b) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                NSLog(@"fail %@",[error localizedDescription]);
                if (image != nil) {
                    [ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
                        [profileImageView setImage:roundedImage];
                    }];
                }

                [HTTPExceptionHandler handlingByError:error];
                
            }];
        } else {
            [profileImageView setImage:[UIImage imageNamed:@"sns_profile_company.png"]];
        }
        
    }
    else if([self.writeinfoType isEqualToString:@"3"]){
        
        [nameLabel setText:dic[@"companyname"]];
        nameLabel.textColor = RGB(160, 18, 19);
        [positionLabel setText:@""];
        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:dic[@"image"] num:0 thumbnail:YES];
        if (imgURL) {
            [profileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:[UIImage imageNamed:@"sns_profile_company.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly progress:^(NSInteger a, NSInteger b) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                NSLog(@"fail %@",[error localizedDescription]);
                if (image != nil) {
                    [ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
                        [profileImageView setImage:roundedImage];
                    }];
                }

                [HTTPExceptionHandler handlingByError:error];
                
            }];
        } else {
            profileImageView.image = [UIImage imageNamed:@"sns_profile_company.png"];
        }
    }
    else if([self.writeinfoType isEqualToString:@"4"]){
        
        [nameLabel setText:dic[@"text"]];
        nameLabel.textColor = RGB(160, 18, 19);
        [positionLabel setText:@""];
        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:dic[@"image"] num:0 thumbnail:YES];
        NSLog(@"imgURL %@",imgURL);
        if (imgURL) {
            [profileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:[UIImage imageNamed:@"sns_systeam.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly progress:^(NSInteger a, NSInteger b) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                NSLog(@"fail %@",[error localizedDescription]);
                if (image != nil) {
                    [ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
                        [profileImageView setImage:roundedImage];
                    }];
                }

                [HTTPExceptionHandler handlingByError:error];
                
            }];
        } else {
            profileImageView.image = [UIImage imageNamed:@"sns_systeam.png"];
        }
        
    }
    else if([self.writeinfoType isEqualToString:@"1"]){
        [nameLabel setText:dic[@"name"]];
        [positionLabel setText:dic[@"position"]];

        [SharedAppDelegate.root getProfileImageWithURL:self.profileImage ifNil:@"profile_photo.png" view:profileImageView scale:24];
        if([dic[@"position"]length]>0)
        [positionLabel setText:[NSString stringWithFormat:@"%@ | %@",dic[@"deptname"],dic[@"position"]]];
        else
            [positionLabel setText:dic[@"deptname"]];

        
    
        
        
    }
    else if([self.writeinfoType isEqualToString:@"10"]){
        [nameLabel setText:@"익명"];
        [positionLabel setText:@""];
        [profileImageView setImage:[UIImage imageNamed:@"sns_anonym.png"]];
        
    }
    
    else if([self.writeinfoType isEqualToString:@"0"]){
        CGRect dFrame = defaultView.frame;
        dFrame.size.height = 0;
        defaultView.frame = dFrame;
        
        [nameLabel setText:@""];
        [positionLabel setText:@""];
        [profileImageView setImage:nil];
        
    }
    
    else{
        
        [profileImageView setImage:[UIImage imageNamed:@"sns_systeam.png"]];
        

        
    }
    
#endif
    
    
#ifdef BearTalk
    UIImageView *roundingView2;
    roundingView2 = [[UIImageView alloc]init];
    roundingView2.frame = CGRectMake(0,0,profileImageView.frame.size.width,profileImageView.frame.size.height);
    roundingView2.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
    [profileImageView addSubview:roundingView2];
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    nameLabel.textColor = GreenTalkColor;
    
    
    UIImageView *roundingView2;
    roundingView2 = [[UIImageView alloc]init];
    roundingView2.frame = CGRectMake(0,0,profileImageView.frame.size.width,profileImageView.frame.size.height);
    roundingView2.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
    
    [profileImageView addSubview:roundingView2];
//    [roundingView2 release];
#endif
    
    CGSize size = [nameLabel.text sizeWithAttributes:@{NSFontAttributeName:nameLabel.font}];
    [positionLabel setFrame:CGRectMake(nameLabel.frame.origin.x + (size.width+5>90?90:size.width+5), nameLabel.frame.origin.y, 80, 17)];
    
#if defined(BearTalk) || defined(Batong)
    
    [positionLabel setFrame:CGRectMake(nameLabel.frame.origin.x + (size.width+5>90?90:size.width+5), nameLabel.frame.origin.y, 170, 17)];
#endif
    
}



- (void)setTime:(NSString *)newTime
{
    
    //    NSString *dateString = [NSString calculateDate:newTime];// with:self.currentTime];
    //	[timeLabel setText:dateString];
    //    NSLog(@"newtime %@",newTime);
    //        NSLog(@"timeLabel text %@",timeLabel.text);
    
    
    //    defaultView.frame = CGRectMake(45.0, 5.0, 230, whLabel.frame.origin.y + whLabel.frame.size.height + 5);
    //
    //    likeButton.frame = CGRectMake(10, 5, 39, 26);
    //
    //    likeImageView.frame = CGRectMake(defaultView.frame.origin.x,
    //                                     defaultView.frame.origin.y + defaultView.frame.size.height,
    //                                     defaultView.frame.size.width,
    //                                     37);
    //
    //    likeMemberButton.frame = CGRectMake(40, 4, defaultView.frame.size.width-40, 30);
    
}

- (void)setWritetime:(NSString *)newTime
{
    [super setWritetime:newTime];
    NSString *dateString = [NSString calculateDate:newTime];// with:self.currentTime];
    [timeLabel setText:dateString];
    if([self.writeinfoType intValue]==0)
        timeLabel.text = @"";
}
//- (void)setCurrentTime:(NSString *)current{
//    [super setCurrentTime:current];
//}



- (void)setContentDic:(NSDictionary *)dic{//ImageString:(NSString *)imgString content:(NSString *)con wh:(NSString *)location{
    
    [super setContentDic:dic];//:imgString content:con wh:location];
    
    
}

- (void)setContent:(NSString *)con{
    [super setContent:con];
    NSLog(@"self.content %@",self.content);
}
- (void)setFileArray:(NSArray *)array
{
    [super setFileArray:array];
    
}
- (void)setImageArray:(NSArray *)array
{
    [super setImageArray:array];
    
    NSLog(@"self.imageArray %@",self.imageArray);
    
}



- (void)setCategoryname:(NSString *)catename{
    [super setCategoryname:catename];
    
    if(!IS_NULL(catename) && [catename length]>0){
        for(NSDictionary *dic in SharedAppDelegate.root.home.groupDic[@"SNS_CATEGORY"]){
            if([catename isEqualToString:dic[@"CATEGORY_KEY"]]){
                self.categoryname = dic[@"CATEGORY_NAME"];
            }
        }
    }
    NSLog(@"self.catename %@",self.categoryname);
    
}

- (void)setReadArray:(NSMutableArray *)array
{
    [super setReadArray:array];
    
}



- (void)setLikeCount:(NSInteger)cnt{
    [super setLikeCount:cnt];
    
    NSLog(@"self.type %@",self.type);
    if([self.type isEqualToString:@"6"]){
        favButton.hidden = YES;
        return;
    }
    
    
    if([self.type isEqualToString:@"5"]){
        favButton.hidden = YES;
        return;
    }
    
    
    favButton.hidden = NO;
#ifdef Batong
    favButton.hidden = YES;
#elif GreenTalk //|| defined(GreenTalkCustomer)
    if([self.writeinfoType isEqualToString:@"0"]){
        
        favButton.hidden = YES;
    }
    else if([self.contentType isEqualToString:@"1"]){
        if([self.writeinfoType isEqualToString:@"1"]){
            favButton.hidden = NO;
            favButton.frame = CGRectMake(self.contentView.frame.size.width - 32-29, 0, 29, 29);
            [favButton setBackgroundImage:[UIImage imageNamed:@"button_social_share.png"] forState:UIControlStateNormal];
        }
        else{
            favButton.hidden = YES;
        }
    }
    else{
        favButton.hidden = YES;
    }
#elif GreenTalkCustomer
    favButton.hidden = YES;
#endif
    
    
    
#ifdef BearTalk
    
    
    optionView.userInteractionEnabled = YES;
    optionView.frame = CGRectMake(0, CGRectGetMaxY(contentsView.frame)+10, self.contentView.frame.size.width - 0, 46);

    likeImage.frame = CGRectMake(0, 0, 20, 20);
    likeLabel.frame = CGRectMake(CGRectGetMaxX(likeImage.frame)+5, 0, 32, 20);
        likeCountLabel.frame = CGRectMake(CGRectGetMaxX(likeLabel.frame),0,35,20);
        [likeCountLabel setText:[NSString stringWithFormat:@"%d",(int)cnt]];
    
    likeButton.frame = CGRectMake(0,0,optionView.frame.size.width/2, optionView.frame.size.height);
    likeButton.center = CGPointMake(optionView.frame.size.width * 1/4, optionView.frame.size.height/2);
    
    likeLabel.center = CGPointMake(likeButton.frame.size.width/2, likeButton.center.y);
    likeImage.frame = CGRectMake(likeLabel.frame.origin.x - 20 - 5, likeLabel.frame.origin.y, 20, 20);
    likeCountLabel.frame = CGRectMake(CGRectGetMaxX(likeLabel.frame) - 4, likeLabel.frame.origin.y, 35, 20);

    
    replyImage.frame = CGRectMake(0, 0, 20, 20);
    replyLabel.frame = CGRectMake(CGRectGetMaxX(replyImage.frame)+5, 0, 22, 20);
    replyCountLabel.frame = CGRectMake(CGRectGetMaxX(replyLabel.frame),0,35,20);
    
    replyButton.frame = CGRectMake(optionView.frame.size.width/2,0,optionView.frame.size.width/2, optionView.frame.size.height);
    replyButton.center = CGPointMake(optionView.frame.size.width * 3/4, optionView.frame.size.height/2);
    
    replyLabel.center = CGPointMake(replyButton.frame.size.width/2, replyButton.center.y);
    replyImage.frame = CGRectMake(replyLabel.frame.origin.x - 20 - 5, replyLabel.frame.origin.y, 20, 20);
    replyCountLabel.frame = CGRectMake(CGRectGetMaxX(replyLabel.frame) - 4, replyLabel.frame.origin.y, 35, 20);
    
    NSLog(@"replylabel %@",NSStringFromCGRect(replyLabel.frame));
    NSLog(@"replylabel %@",NSStringFromCGRect(replyImage.frame));
    NSLog(@"replylabel %@",NSStringFromCGRect(replyCountLabel.frame));
    NSLog(@"replylabel %@",NSStringFromCGRect(replyButton.frame));
    
    UIImageView *lineview;
    lineview = [[UIImageView alloc]init];
    lineview.frame = CGRectMake(0,0,optionView.frame.size.width,1);
    lineview.backgroundColor = RGB(239, 239, 239);
    [optionView addSubview:lineview];
    
    lineview = [[UIImageView alloc]init];
    lineview.frame = CGRectMake(0,optionView.frame.size.height-1,optionView.frame.size.width,1);
    lineview.backgroundColor = RGB(215, 218, 219);
    [optionView addSubview:lineview];
    
    
    
#else
    
    optionView.userInteractionEnabled = YES;
    if (cnt > 0) {
        likeIconButton.frame = CGRectMake(0,8,17,14);
        likeCountLabel.frame = CGRectMake(CGRectGetMaxX(likeIconButton.frame)+5,0,35,30);
        [likeCountLabel setText:[NSString stringWithFormat:@"%d",(int)cnt]];
        
    } else {
        NSLog(@"here!");
        likeIconButton.frame = CGRectMake(0,8,0,14);
        likeCountLabel.frame = CGRectMake(CGRectGetMaxX(likeIconButton.frame),0,0,30);
        [likeCountLabel setText:@""];
        
    }
    
    optionView.frame = CGRectMake(15, CGRectGetMaxY(contentsView.frame)+10, self.contentView.frame.size.width - 32, 30);
    replyLabel.frame = CGRectMake(self.contentView.frame.size.width - 32-40, 0, 40, 24);
    likeLabel.frame = CGRectMake(replyLabel.frame.origin.x-5-40, 0, 40, 24);
//    replyLabel.frame = CGRectMake(CGRectGetMaxX(likeLabel.frame)+5, 0, 51, 24);
   
#endif
    
#ifdef GreenTalkCustomer
    if([self.contentType isEqualToString:@"1"]&& [self.writeinfoType isEqualToString:@"0"]){
    }
    else if([self.type isEqualToString:@"7"]){
        
        likeLabel.frame = replyLabel.frame;
        replyLabel.frame = CGRectMake(CGRectGetMaxX(likeLabel.frame)+5, 0, 0, 0);
    }
    else{
        likeLabel.frame = replyLabel.frame;
        replyLabel.frame = CGRectMake(CGRectGetMaxX(likeLabel.frame)+5, 0, 0, 0);
    }
#else
    if([self.type isEqualToString:@"7"]){
        
        likeLabel.frame = replyLabel.frame;
        replyLabel.frame = CGRectMake(CGRectGetMaxX(likeLabel.frame)+5, 0, 0, 0);
    }
#endif
    
#ifdef MQM
    
    
    NSString *attribute2 = SharedAppDelegate.root.home.groupDic[@"groupattribute2"];
    
    
    if([SharedAppDelegate.root.home.groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID] && [attribute2 isEqualToString:@"00"]){
        
        shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-50, 0, 50, 24);
        shareLabel.text = @"읽음확인"; // 리더 & 유저레벨 80만 가능하도록 변경해야
        [shareButton addTarget:self action:@selector(showRead) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(![attribute2 isEqualToString:@"00"] && [[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] > 70){
        
        
        shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-50, 0, 50, 24);
        shareLabel.text = @"읽음확인"; // 리더 & 유저레벨 80만 가능하도록 변경해야
        [shareButton addTarget:self action:@selector(showRead) forControlEvents:UIControlEventTouchUpInside];
    }
    
#elif Batong
    NSLog(@"c %@ w %@ s %@",self.contentType,self.writeinfoType,self.sub_category);
    if([self.contentType isEqualToString:@"1"] && [self.writeinfoType isEqualToString:@"1"] && ![self.sub_category isKindOfClass:[NSNull class]] && [self.sub_category length]>1){
      
 
        NSString *share = self.contentDic[@"share"];
        
        if([share isEqualToString:@"2"]){
            // x
            shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-40, 0, 0, 0);
        }
        else if([share isEqualToString:@"1"]){
            // best
            shareLabel.text = @"BP선정";
            shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-40, 0, 40, 24);
            shareLabel.backgroundColor = RGB(46, 107, 165);//[UIColor whiteColor];
            shareLabel.textColor = [UIColor whiteColor];
       
            if([[SharedAppDelegate readPlist:@"isCS"]isEqualToString:@"1"])// i am cs
            {
                               [shareButton addTarget:self action:@selector(goShareAgain) forControlEvents:UIControlEventTouchUpInside];
            
            }
            else{
                              [shareButton addTarget:SharedAppDelegate.root.home action:@selector(alreadyShareToast) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
        else {
            if([[SharedAppDelegate readPlist:@"isCS"]isEqualToString:@"1"]){ // i am cs
            
            shareLabel.text = @"공유";
            shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-40, 0, 40, 24);
            shareLabel.backgroundColor = [UIColor whiteColor];//[UIColor whiteColor];
            shareLabel.textColor = [UIColor grayColor];
            [shareButton addTarget:self action:@selector(goShare) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                
                shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-40, 0, 0, 0);
                
            }
        }
        
        
    }
    
#endif
    
    
    
    
#ifdef BearTalk
    bgView.frame = CGRectMake(0,0,self.contentView.frame.size.width,CGRectGetMaxY(optionView.frame));
#else
    
    likeButton.frame = CGRectMake(0,0,likeLabel.frame.size.width,likeLabel.frame.size.height);
    replyButton.frame = CGRectMake(0,0,replyLabel.frame.size.width,replyLabel.frame.size.height);
    shareButton.frame = CGRectMake(0,0,shareLabel.frame.size.width,shareLabel.frame.size.height);
    bottomRoundingView.frame = CGRectMake(5, 5, 310 ,CGRectGetMaxY(optionView.frame));
#endif
    
    NSLog(@"likebutton %@",NSStringFromCGRect(likeLabel.frame));
}


- (void)setReplyCount:(NSInteger)count
{
    [super setReplyCount:count];
    
    if([self.type isEqualToString:@"6"] || [self.type isEqualToString:@"5"])
        return;
    
    
    if([self.contentType isEqualToString:@"11"] || [self.contentType isEqualToString:@"14"]){
        NSLog(@"reply here ");
        optionView.backgroundColor =  [UIColor clearColor];
        optionView.frame = CGRectMake(10, CGRectGetMaxY(contentsView.frame)+10, 320-20, 25);
        bottomRoundingView.frame = CGRectMake(5, 5, 310 ,CGRectGetMaxY(optionView.frame));
        UILabel *label;
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, optionView.frame.size.width, optionView.frame.size.height);
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont boldSystemFontOfSize:14.0]];
        [label setBackgroundColor:[UIColor clearColor]];
        [optionView addSubview:label];
//        [label release];
        if(count > 0){
            //
            optionView.image = [[UIImage imageNamed:@"login_input.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10];
            //            optionView.backgroundColor = [UIColor whiteColor];
            [label setTextColor:RGB(167, 204, 69)];
            label.text = @"답변 완료";
            if([self.contentType isEqualToString:@"14"])
                label.text = @"배송 완료";
        }
        else{
            optionView.image = [[UIImage imageNamed:@"imageview_roundingbox_gray.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10];
            //
            //            optionView.backgroundColor = RGB(218, 218, 218);
            [label setTextColor:RGB(47, 46, 47)];
            label.text = @"답변 대기 중";
            if([self.contentType isEqualToString:@"14"])
                label.text = @"배송 요청 확인 중";
        }
        return;
    }
    
    
#ifdef BearTalk
    [replyCountLabel setText:[NSString stringWithFormat:@"%d",(int)count]];
#else
    
    if (count > 0) {
        
        replyIconButton.frame = CGRectMake(CGRectGetMaxX(likeCountLabel.frame),8,17,14);
        replyCountLabel.frame = CGRectMake(CGRectGetMaxX(replyIconButton.frame)+5,0,35,30);
        [replyCountLabel setText:[NSString stringWithFormat:@"%d",(int)count]];
        
        
        
        
    } else {
        replyIconButton.frame = CGRectMake(CGRectGetMaxX(likeCountLabel.frame),8,17,0);
        replyCountLabel.frame = CGRectMake(CGRectGetMaxX(replyIconButton.frame)+5,0,35,0);
        [replyCountLabel setText:@""];
    }
    optionView.frame = CGRectMake(15, CGRectGetMaxY(contentsView.frame)+10, self.contentView.frame.size.width - 32, 30);
    //    optionView.backgroundColor = [UIColor lightGrayColor];
    
    
    replyLabel.frame = CGRectMake(self.contentView.frame.size.width - 32-40, 0, 40, 24);
    likeLabel.frame = CGRectMake(replyLabel.frame.origin.x-5-40, 0, 40, 24);
//    likeLabel.frame = CGRectMake(175, 0, 51, 24);
//    replyLabel.frame = CGRectMake(CGRectGetMaxX(likeLabel.frame)+5, 0, 51, 24);
#endif
    
#ifdef GreenTalkCustomer
    
    if([self.contentType isEqualToString:@"1"]&& [self.writeinfoType isEqualToString:@"0"]){
    }
    else if([self.type isEqualToString:@"7"]){
        likeLabel.frame = replyLabel.frame;
        replyLabel.frame = CGRectMake(CGRectGetMaxX(likeLabel.frame)+5, 0, 0, 0);
    }
    else{
        likeLabel.frame = replyLabel.frame;
        replyLabel.frame = CGRectMake(CGRectGetMaxX(likeLabel.frame)+5, 0, 0, 0);
    }
#elif BearTalk
#else
    if([self.type isEqualToString:@"7"]){
        likeLabel.frame = replyLabel.frame;
        replyLabel.frame = CGRectMake(CGRectGetMaxX(likeLabel.frame)+5, 0, 0, 0);
    }
#endif
    
    
    
#ifdef MQM
    shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-0, 0, 0, 24);
    shareLabel.text = @"0";
    [shareButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
#elif Batong
    NSLog(@"c %@ w %@ s %@",self.contentType,self.writeinfoType,self.sub_category);
    if([self.contentType isEqualToString:@"1"] && [self.writeinfoType isEqualToString:@"1"] && ![self.sub_category isKindOfClass:[NSNull class]] && [self.sub_category length]>1){
        
        
        NSString *share = self.contentDic[@"share"];
        
        if([share isEqualToString:@"2"]){
            // x
            shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-40, 0, 0, 0);
        }
        else if([share isEqualToString:@"1"]){
            // best
            shareLabel.text = @"BP선정";
            shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-40, 0, 40, 24);
            shareLabel.backgroundColor = RGB(46, 107, 165);//[UIColor whiteColor];
            shareLabel.textColor = [UIColor yellowColor];
            
            if([[SharedAppDelegate readPlist:@"isCS"]isEqualToString:@"1"])// i am cs
            {
                [shareButton addTarget:self action:@selector(goShareAgain) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else{
                [shareButton addTarget:SharedAppDelegate.root.home action:@selector(alreadyShareToast) forControlEvents:UIControlEventTouchUpInside];
                
            }
        }
        else {
            if([[SharedAppDelegate readPlist:@"isCS"]isEqualToString:@"1"]){ // i am cs
                
                shareLabel.text = @"공유";
                shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-40, 0, 40, 24);
                shareLabel.backgroundColor = [UIColor whiteColor];//[UIColor whiteColor];
                shareLabel.textColor = [UIColor grayColor];
                [shareButton addTarget:self action:@selector(goShare) forControlEvents:UIControlEventTouchUpInside];
            }
            else{
                
                shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-40, 0, 0, 0);
                
            }
        }
        
        
    }
    
#endif
    
#ifdef BearTalk
    bgView.frame = CGRectMake(0,0,self.contentView.frame.size.width,CGRectGetMaxY(optionView.frame));
#else
    likeButton.frame = CGRectMake(0,0,likeLabel.frame.size.width,likeLabel.frame.size.height);
    replyButton.frame = CGRectMake(0,0,replyLabel.frame.size.width,replyLabel.frame.size.height);
    shareButton.frame = CGRectMake(0,0,shareLabel.frame.size.width,shareLabel.frame.size.height);
    bottomRoundingView.frame = CGRectMake(5, 5, 310 ,CGRectGetMaxY(optionView.frame));
#endif
    
    NSLog(@"likelabel %@",NSStringFromCGRect(likeLabel.frame));
    
}

- (void)setLikeArray:(NSMutableArray *)array
{
    [super setLikeArray:array];
    
    if([self.type isEqualToString:@"5"] || [self.type isEqualToString:@"6"])
        return;
    
        NSLog(@"likeArray %@",likeArray);
    
    //    likeMemberButton.tag = count;
    //    [likeButton setBackgroundImage:[UIImage imageNamed:@"good_btn_dft.png"] forState:UIControlStateNormal];
    //    likeButton.frame = CGRectMake(10, 13, 44, 24);
    
    //	[likeButton setTitleColor:[UIColor colorWithWhite:0.423 alpha:1.000] forState:UIControlStateNormal];
    
    if([array count] > 0) {
            
#ifdef BearTalk
        
        likeButton.selected = NO;
        for(NSString *uid in array){
            if([uid isEqualToString:[ResourceLoader sharedInstance].myUID]) {
                likeImage.image = [UIImage imageNamed:@"btn_like_on.png"];
                likeButton.selected = YES;
#else
                for(NSDictionary *dic in array){
                if([dic[@"uid"] isEqualToString:[ResourceLoader sharedInstance].myUID]) {
                likeLabel.textColor = [UIColor whiteColor];

                likeLabel.backgroundColor = RGB(252, 179, 66);
                
    #if defined(LempMobile) || defined(LempMobileNowon) || defined(SbTalk)
                likeLabel.backgroundColor = RGB(39, 128, 248);
    #endif
                
#endif
                break;
            }
        }
        // 사람 목록을 표시하지 않음
        //        UIImageView *detailLike = [[UIImageView alloc] init];
        //        detailLike.image = [UIImage imageNamed:@"n01_tl_list_profile_check.png"];
        //        detailLike.frame = CGRectMake(defaultView.frame.size.width-8-21, 8, 21, 21);
        //        [likeImageView addSubview:detailLike];
        //        [detailLike release];
        //
        //        UIImageView *thumbImageView;
        ////        for(int i = 0; i < [array count]; i++)
        //		NSInteger increment = 0;
        //		for(NSDictionary *dic in array) {
        //            if(increment > 3)
        //                break;
        //
        //			UIImageView *likeProfileImageView = [[UIImageView alloc]init];
        //            likeProfileImageView.frame = CGRectMake(60.0 + 35 * increment, 6, 28, 28);
        //			[SharedAppDelegate.root getProfileImageWithURL:array[increment][@"uid"] ifNil:@"goodnophoto.png" view:likeProfileImageView scale:0];
        //
        //
        //            thumbImageView = [[UIImageView alloc]init];
        //            thumbImageView.frame = CGRectMake(0, 0, 28, 28);
        //            [thumbImageView setImage:[UIImage imageNamed:@"goodphoto_cover.png"]];
        //
        //            [likeImageView addSubview:likeProfileImageView];
        //            [likeProfileImageView addSubview:thumbImageView];
        //            [likeProfileImageView release];
        //            [thumbImageView release];
        //
        //			increment++;
        //        }
        //
        //
        //        if ([array count] > 4) {
        //
        //            UIImageView *moreLike = [[UIImageView alloc]init];
        //            moreLike.image = [UIImage imageNamed:@"n01_tl_list_profile_more.png"];
        //            moreLike.frame = CGRectMake(defaultView.frame.size.width-8-21-30, 7, 26, 26);
        //            [likeImageView addSubview:moreLike];
        //            [moreLike release];
        //        }
        //        //        likeImageView.hidden = NO;
        
    }
    
}


- (void)setReplyArray:(NSMutableArray *)array{
    [super setReplyArray:array];
    //    NSLog(@"replyArray %@",array);
    
    if([self.type isEqualToString:@"6"])
        return;
    else if([self.type isEqualToString:@"5"]){
        return;
    }
    
    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
#elif BearTalk
#else
    if(self.replyCount > 0)
    {
        UILabel *replyNameLabel;
        UILabel *replyContentsLabel;
        UILabel *replyTimeLabel;
        UIImageView *replyProfileImageView;
        UILabel *replyPostionLabel;
        UILabel *moreLabel;
        UIImageView *replyPhotoImage;
        likeImageView.image = [UIImage imageNamed:@"sns_balloonbg_cent.png"];
        NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, replyView.frame.size.width, 1)];
        line.image = [UIImage imageNamed:@"balon_grayline_deep.png"];
        [replyView addSubview:line];
//        [line release];
        
        if(self.replyCount < 3)
        {
            double preHeight = 0.0f;
            for(int i = 0; i < self.replyCount; i++)
            {
                NSDictionary *dic = array[i];
                NSLog(@"dic %@",dic);
                
                
                
                NSDictionary *infoDic = [dic[@"writeinfo"]objectFromJSONString];
                NSLog(@"infoDic %@",infoDic);
                replyProfileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8 + preHeight, 30, 30)];
                replyProfileImageView.userInteractionEnabled = YES;
                //                replyProfileImageView.image = [SharedAppDelegate.root getImage:[dicobjectForKey:@"uid"] ifNil:@"n01_tl_list_profile.png"];
                [replyView addSubview:replyProfileImageView];
//                [replyProfileImageView release];
                

                UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
                viewButton.adjustsImageWhenHighlighted = NO;
                [viewButton addTarget:self action:@selector(goToReplyTimeline:) forControlEvents:UIControlEventTouchUpInside];
                [replyProfileImageView addSubview:viewButton];
                viewButton.titleLabel.text = dic[@"uid"];
                viewButton.tag = [dic[@"writeinfotype"]intValue];
//                [viewButton release];
                
                replyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, replyProfileImageView.frame.origin.y, 120, 20)];
                [replyNameLabel setBackgroundColor:[UIColor clearColor]];
                [replyNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
                [replyNameLabel setTextColor:RGB(87, 107, 149)];
                [replyView addSubview:replyNameLabel];
                

//                [replyNameLabel release];
                
                replyPostionLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(replyNameLabel.frame.origin.x + [replyNameLabel.text length]*13, 5 + preHeight, 100, 20)];
                [replyPostionLabel setBackgroundColor:[UIColor clearColor]];
                [replyPostionLabel setTextColor:[UIColor grayColor]];
                [replyPostionLabel setFont:[UIFont systemFontOfSize:14]];
                [replyView addSubview:replyPostionLabel];
//                [replyPostionLabel release];
                
                //                replyTeamLabel = [[UILabel alloc]initWithFrame:CGRectMake(replyPostionLabel.frame.origin.x + [replyPostionLabel.text length]*11, 5 + preHeight, 70, 20)];
                //                [replyTeamLabel setBackgroundColor:[UIColor clearColor]];
                //                [replyTeamLabel setTextColor:[UIColor grayColor]];
                //                [replyTeamLabel setFont:[UIFont systemFontOfSize:10.0]];
                //                [replyTeamLabel setText:[infoDicobjectForKey:@"deptname"]];
                //                [replyView addSubview:replyTeamLabel];
                //                [replyTeamLabel release];
                
                
                if([dic[@"writeinfotype"] intValue]>4 && [dic[@"writeinfotype"] intValue]!=10){
                    
                    [replyPostionLabel setText:@""];
                    [replyNameLabel setText:@""];
                    [replyProfileImageView setImage:[UIImage imageNamed:@"sns_systeam.png"]];
                    [replyContentsLabel setText:@"업그레이드가 필요합니다."];
                    replyContentsLabel.frame = CGRectMake(replyNameLabel.frame.origin.x, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, self.contentView.frame.size.width - 32-replyNameLabel.frame.origin.x, 25);
                }
                else if([dic[@"writeinfotype"]isEqualToString:@"10"]){
                    
                    [replyPostionLabel setText:@""];
                    [replyNameLabel setText:@"익명"];
                    [replyProfileImageView setImage:[UIImage imageNamed:@"sns_anonym.png"]];
                    [replyProfileImageView setImage:[UIImage imageNamed:@"sns_anonym.png"]];
                }
                
                else if([dic[@"writeinfotype"] isEqualToString:@"4"]){
                    
                    [replyNameLabel setText:infoDic[@"text"]];
                    replyNameLabel.textColor = RGB(160, 18, 19);
                    [replyPostionLabel setText:@""];
                    
                    NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:infoDic[@"image"] num:0 thumbnail:YES];
                    if (imgURL) {
                        [replyProfileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:[UIImage imageNamed:@"sns_systeam.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly progress:^(NSInteger a, NSInteger b) {
                        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                            NSLog(@"fail %@",[error localizedDescription]);
                            if (image != nil) {
                                [ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
                                    [replyProfileImageView setImage:roundedImage];
                                }];
                            }

                            [HTTPExceptionHandler handlingByError:error];
                            
                        }];
                    } else {
                        replyProfileImageView.image = [UIImage imageNamed:@"sns_systeam.png"];
                    }
                    
                }
                else{
                    
                    [replyNameLabel setText:infoDic[@"name"]];
                    [replyPostionLabel setText:infoDic[@"position"]];
                    [SharedAppDelegate.root getProfileImageWithURL:dic[@"uid"] ifNil:@"profile_photo.png" view:replyProfileImageView scale:24];
                    
                }
                

                
                
                NSString *replyCon = [dic[@"replymsg"]objectFromJSONString][@"msg"];
                if ([replyCon length] > 90) {
                    replyCon = [replyCon substringToIndex:90];
                }
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                CGSize replySize = [replyCon boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width - 32-replyNameLabel.frame.origin.x, fontSize*2) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                

    //            CGSize replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 32-replyNameLabel.frame.origin.x, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                replyContentsLabel = [[UILabel alloc]initWithFrame:CGRectMake(replyNameLabel.frame.origin.x, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, self.contentView.frame.size.width - 32-replyNameLabel.frame.origin.x, replySize.height)];
                
                NSString *replyPhotoUrl = [dic[@"replymsg"]objectFromJSONString][@"image"];
                if([replyPhotoUrl length]>0){
                    replyPhotoImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 32-24-5, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, 24,20)];
                    replyPhotoImage.image = [UIImage imageNamed:@"comment_photoic.png"];
                    [replyView addSubview:replyPhotoImage];
//                    [replyPhotoImage release];
                    NSLog(@"replyCon %d",(int)[replyCon length]);
                    if([replyCon length]==0)
                        replyCon = @"(사진)";
                     replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 32-24-5-5-replyNameLabel.frame.origin.x, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
        //            replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 32-24-5-5-replyNameLabel.frame.origin.x, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                    replyContentsLabel.frame = CGRectMake(replyNameLabel.frame.origin.x, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, self.contentView.frame.size.width - 32-24-5-5-replyNameLabel.frame.origin.x, replySize.height<20?20:replySize.height);
                    
                }
                
                
                if([[dic[@"replymsg"]objectFromJSONString][@"emoticon"]length]>0){
                    replyCon = @"(이모티콘)";
                }
                    
                [replyContentsLabel setTextAlignment:NSTextAlignmentLeft];
                [replyContentsLabel setFont:[UIFont systemFontOfSize:fontSize]];
                [replyContentsLabel setBackgroundColor:[UIColor clearColor]];
                [replyContentsLabel setAdjustsFontSizeToFitWidth:NO];
                [replyContentsLabel setNumberOfLines:1];
                [replyContentsLabel setText:replyCon];
                [replyView addSubview:replyContentsLabel];
//                [replyContentsLabel release];
                
                
                CGSize size = [replyNameLabel.text sizeWithAttributes:@{NSFontAttributeName:replyNameLabel.font}];
                replyPostionLabel.frame = CGRectMake(replyNameLabel.frame.origin.x + (size.width+5>120?120:size.width+5), replyNameLabel.frame.origin.y, 100, 20);
                
                CGSize size2 = [replyPostionLabel.text sizeWithAttributes:@{NSFontAttributeName:replyPostionLabel.font}];
                
                replyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(replyPostionLabel.frame.origin.x + (size2.width+5>100?100:size2.width+5), replyNameLabel.frame.origin.y+2, 50, 14)];
                NSLog(@"replytimelabel %@",NSStringFromCGRect(replyTimeLabel.frame));
                [replyTimeLabel setTextAlignment:NSTextAlignmentLeft];
                [replyTimeLabel setTextColor:[UIColor darkGrayColor]];
                [replyTimeLabel setFont:[UIFont systemFontOfSize:11]];
                [replyTimeLabel setBackgroundColor:[UIColor clearColor]];
                //            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                //            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                //            NSDate *date = [formatter dateFromString:[dicobjectForKey:@"messagedate"]];
                //        id AppID = [[UIApplication sharedApplication]delegate];
                NSString *dateString = [NSString calculateDate:dic[@"operatingtime"]];// with:self.currentTime];
                [replyTimeLabel setText:[NSString stringWithFormat:@"| %@",dateString]];
                [replyView addSubview:replyTimeLabel];
//                [replyTimeLabel release];
                
                
                
                NSLog(@"replyContentsLabel.frame.size.height %.0f",replyContentsLabel.frame.size.height);
                
                if(replyContentsLabel.frame.size.height < 5){
                    CGRect frame = replyContentsLabel.frame;
                    frame.size.height = 20;
                    replyContentsLabel.frame = frame;
                }
                
                if(i < self.replyCount-1){
                    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, replyContentsLabel.frame.origin.y + replyContentsLabel.frame.size.height+5, replyView.frame.size.width, 1)];
                    line.image = [UIImage imageNamed:@"balon_grayline_deep.png"];
                    [replyView addSubview:line];
//                    [line release];
                }
                
                preHeight += 10+20+5+replyContentsLabel.frame.size.height;
                
            }
            
            replyView.frame = CGRectMake(15,CGRectGetMaxY(optionView.frame)+5,
                                         self.contentView.frame.size.width - 32,
                                         preHeight);
            replyViewButton.frame = CGRectMake(0,0,replyView.frame.size.width,replyView.frame.size.height);
            
            //            replyImageView.frame = CGRectMake(defaultView.frame.origin.x,
            //                                              defaultView.frame.size.height + likeImageView.frame.size.height,
            //                                              defaultView.frame.size.width,
            //                                              preHeight + 9);
            
            //            lineView.frame = CGRectMake(292, 0, 3, defaultView.frame.size.height + likeImageView.frame.size.height + preHeight);
        }
        else//if(count>2)
        {
            NSLog(@"reply > 2 array %@",array);
            
            
            double preHeight = 0.0f;//35.0f;
            
            for(int i = (int)[array count]-2; i < (int)[array count]; i++)
            {
                NSDictionary *dic = array[i];
                //                NSLog(@"dic %@",dic);
                
                //                replyProfileImageView.image = [SharedAppDelegate.root getImage:[dicobjectForKey:@"uid"] ifNil:@"n01_tl_list_profile.png"];
                
                NSDictionary *infoDic = [dic[@"writeinfo"]objectFromJSONString];
                
                replyProfileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8 + preHeight, 30, 30)];
                replyProfileImageView.userInteractionEnabled = YES;
                [replyView addSubview:replyProfileImageView];
//                [replyProfileImageView release];
                

                UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
                viewButton.adjustsImageWhenHighlighted = NO;
                [viewButton addTarget:self action:@selector(goToReplyTimeline:) forControlEvents:UIControlEventTouchUpInside];
                viewButton.titleLabel.text = dic[@"uid"];
                viewButton.tag = [dic[@"writeinfotype"]intValue];
                [replyProfileImageView addSubview:viewButton];
//                [viewButton release];
                
                replyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, replyProfileImageView.frame.origin.y, 120, 20)];
                [replyNameLabel setBackgroundColor:[UIColor clearColor]];
                [replyNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
                [replyNameLabel setTextColor:RGB(87, 107, 149)];
                

                [replyView addSubview:replyNameLabel];
//                [replyNameLabel release];
                
                replyPostionLabel = [[UILabel alloc]init];//With
                [replyPostionLabel setBackgroundColor:[UIColor clearColor]];
                [replyPostionLabel setTextColor:[UIColor grayColor]];
                [replyPostionLabel setFont:[UIFont systemFontOfSize:14]];
                [replyView addSubview:replyPostionLabel];
//                [replyPostionLabel release];
                
                
                
                
                if([dic[@"writeinfotype"] intValue]>4 && [dic[@"writeinfotype"] intValue]!=10){
                    
                    [replyPostionLabel setText:@""];
                    [replyNameLabel setText:@""];
                    [replyProfileImageView setImage:[UIImage imageNamed:@"sns_systeam.png"]];
                    [replyContentsLabel setText:@"업그레이드가 필요합니다."];
                    replyContentsLabel.frame = CGRectMake(replyNameLabel.frame.origin.x, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, self.contentView.frame.size.width - 32-replyNameLabel.frame.origin.x, 25);
                }
                else if([dic[@"writeinfotype"]isEqualToString:@"10"]){
                    
                    [replyPostionLabel setText:@""];
                    [replyNameLabel setText:@"익명"];
                    [replyProfileImageView setImage:[UIImage imageNamed:@"sns_anonym.png"]];
                    [replyProfileImageView setImage:[UIImage imageNamed:@"sns_anonym.png"]];
                }
                
                else if([dic[@"writeinfotype"] isEqualToString:@"4"]){
                    
                    [replyNameLabel setText:infoDic[@"text"]];
                    replyNameLabel.textColor = RGB(160, 18, 19);
                    [replyPostionLabel setText:@""];
                    
                    NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:infoDic[@"image"] num:0 thumbnail:YES];
                    if (imgURL) {
                        [replyProfileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:[UIImage imageNamed:@"sns_systeam.png"] options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly progress:^(NSInteger a, NSInteger b) {
                        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                            NSLog(@"fail %@",[error localizedDescription]);
                            if (image != nil) {
                                [ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
                                    [replyProfileImageView setImage:roundedImage];
                                }];
                            }

                            [HTTPExceptionHandler handlingByError:error];
                            
                        }];
                    } else {
                        replyProfileImageView.image = [UIImage imageNamed:@"sns_systeam.png"];
                    }
                    
                }
                else{
                    
                    [replyNameLabel setText:infoDic[@"name"]];
                    [replyPostionLabel setText:infoDic[@"position"]];
                    [SharedAppDelegate.root getProfileImageWithURL:dic[@"uid"] ifNil:@"profile_photo.png" view:replyProfileImageView scale:24];
                    
                }
                
                
                NSString *replyCon = [dic[@"replymsg"]objectFromJSONString][@"msg"];
                if ([replyCon length] > 90) {
                    replyCon = [replyCon substringToIndex:90];
                }
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
                CGSize replySize = [replyCon boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width - 32-replyNameLabel.frame.origin.x, fontSize*2) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                

          //      CGSize replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 32-replyNameLabel.frame.origin.x, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                replyContentsLabel = [[UILabel alloc]initWithFrame:CGRectMake(replyNameLabel.frame.origin.x, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, self.contentView.frame.size.width - 32-replyNameLabel.frame.origin.x, replySize.height)];
                
                NSString *replyPhotoUrl = [dic[@"replymsg"]objectFromJSONString][@"image"];
                NSLog(@"replyphotourl %@",replyPhotoUrl);
                if([replyPhotoUrl length]>0){
                    replyPhotoImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 32-24-5, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, 24,20)];
                    replyPhotoImage.image = [UIImage imageNamed:@"comment_photoic.png"];
                    [replyView addSubview:replyPhotoImage];
//                    [replyPhotoImage release];
                    NSLog(@"replyCon %d",(int)[replyCon length]);
                    if([replyCon length]==0)
                        replyCon = @"(사진)";
                    replySize = [replyCon boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width - 32-24-5-5-replyNameLabel.frame.origin.x, fontSize*2) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    
                //    replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 32-24-5-5-replyNameLabel.frame.origin.x, fontSize*2) lineBreakMode:NSLineBreakByWordWrapping];
                    replyContentsLabel.frame = CGRectMake(replyNameLabel.frame.origin.x, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, self.contentView.frame.size.width - 32-24-5-5-replyNameLabel.frame.origin.x, replySize.height<20?20:replySize.height);
                    
                }
                
                if([[dic[@"replymsg"]objectFromJSONString][@"emoticon"]length]>0){
                    replyCon = @"(이모티콘)";
                }
                
                [replyContentsLabel setTextAlignment:NSTextAlignmentLeft];
                [replyContentsLabel setFont:[UIFont systemFontOfSize:fontSize]];
                [replyContentsLabel setBackgroundColor:[UIColor clearColor]];
                [replyContentsLabel setAdjustsFontSizeToFitWidth:NO];
                [replyContentsLabel setNumberOfLines:1];
                [replyContentsLabel setText:replyCon];
                [replyView addSubview:replyContentsLabel];
//                [replyContentsLabel release];
                
                CGSize size = [replyNameLabel.text sizeWithAttributes:@{NSFontAttributeName:replyNameLabel.font}];
                replyPostionLabel.frame = CGRectMake(replyNameLabel.frame.origin.x + (size.width+5>120?120:size.width+5), replyNameLabel.frame.origin.y, 100, 20);
                //                replyTeamLabel = [[UILabel alloc]initWithFrame:CGRectMake(replyPostionLabel.frame.origin.x + [replyPostionLabel.text length]*11, 5 + preHeight, 80, 20)];
                //                [replyTeamLabel setBackgroundColor:[UIColor clearColor]];
                //                [replyTeamLabel setTextColor:[UIColor grayColor]];
                //                [replyTeamLabel setFont:[UIFont systemFontOfSize:14.0]];
                //                [replyTeamLabel setText:[infoDicobjectForKey:@"deptname"]];
                //                [replyView addSubview:replyTeamLabel];
                //                [replyTeamLabel release];
                
                CGSize size2 = [replyPostionLabel.text sizeWithAttributes:@{NSFontAttributeName:replyPostionLabel.font}];
                
                replyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(replyPostionLabel.frame.origin.x + (size2.width+5>100?100:size2.width+5), replyNameLabel.frame.origin.y+2, 50, 14)];
                NSLog(@"replytimelabel %@",NSStringFromCGRect(replyTimeLabel.frame));
                [replyTimeLabel setTextAlignment:NSTextAlignmentLeft];
                [replyTimeLabel setTextColor:[UIColor darkGrayColor]];
                [replyTimeLabel setFont:[UIFont systemFontOfSize:11]];
                [replyTimeLabel setBackgroundColor:[UIColor clearColor]];
                //                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                //                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                //                NSDate *date = [formatter dateFromString:[dicobjectForKey:@"messagedate"]];
                //        id AppID = [[UIApplication sharedApplication]delegate];
                NSString *dateString = [NSString calculateDate:dic[@"operatingtime"]];// with:self.currentTime];
                
                [replyTimeLabel setText:[NSString stringWithFormat:@"| %@",dateString]];
                [replyView addSubview:replyTimeLabel];
//                [replyTimeLabel release];
                
                
                
                
                NSLog(@"replyContentsLabel.frame.size.height %.0f",replyContentsLabel.frame.size.height);
                
                if(replyContentsLabel.frame.size.height < 5){
                    CGRect frame = replyContentsLabel.frame;
                    frame.size.height = 20;
                    replyContentsLabel.frame = frame;
                }
                
                
                if(i < [array count]-1){
                    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, replyContentsLabel.frame.origin.y + replyContentsLabel.frame.size.height+5, replyView.frame.size.width, 1)];
                    line.image = [UIImage imageNamed:@"balon_grayline_deep.png"];
                    [replyView addSubview:line];
//                    [line release];
                }
                
                
                preHeight += 10+20+5+replyContentsLabel.frame.size.height;
                
                
                
                
            }
            line = [[UIImageView alloc]initWithFrame:CGRectMake(0, preHeight, replyView.frame.size.width, 1)];
            line.image = [UIImage imageNamed:@"balon_grayline_deep.png"];
            [replyView addSubview:line];
//            [line release];
            
            moreLabel = [[UILabel alloc]init];
            moreLabel.text = [NSString stringWithFormat:@"모든 댓글 보기 (%d)",(int)self.replyCount];
            moreLabel.frame = CGRectMake(0, line.frame.origin.y + line.frame.size.height + 5, self.contentView.frame.size.width - 32, 23);
            [moreLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
            [moreLabel setTextAlignment:NSTextAlignmentCenter];
            [moreLabel setBackgroundColor:[UIColor clearColor]];
            [replyView addSubview:moreLabel];
//            [moreLabel release];
            
            //            preHeight += 25;
            
            replyView.frame = CGRectMake(15, CGRectGetMaxY(optionView.frame)+5, self.contentView.frame.size.width - 32, CGRectGetMaxY(moreLabel.frame));
            
            replyViewButton.frame = CGRectMake(0,0,replyView.frame.size.width,replyView.frame.size.height);
            
        }
        
        
        bottomRoundingView.frame = CGRectMake(5, 5, 310 ,CGRectGetMaxY(replyView.frame));
    }
    else
    {
        
        
    }
#endif
    
    //    if([self.contentType isEqualToString:@"7"]){
    //
    //    }
    //    else{
    //
    //        replyWriteButton.frame = CGRectMake(60, 13, 54, 24);
    //    }
    
    
}

- (void)setType:(NSString *)ty{
    [super setType:ty];
    //    NSLog(@"setType %@",ty);
    
    if([ty intValue]>6 || [self.contentType intValue]>17 || ([self.writeinfoType intValue]>4 && [self.writeinfoType intValue]!=10)){
        
#ifdef BearTalk
        contentsLabel.frame = CGRectMake(0, 0, contentsView.frame.size.width, 25);
        contentsLabel.text = @"업그레이드가 필요합니다.";
        
        contentsView.frame = CGRectMake(0, CGRectGetMaxY(defaultView.frame), defaultView.frame.size.width, CGRectGetMaxY(contentsLabel.frame));
        bgView.frame = CGRectMake(0,0,self.contentView.frame.size.width,CGRectGetMaxY(contentsView.frame));
#else
        
        contentsLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width - 32, 25);
        contentsLabel.text = @"업그레이드가 필요합니다.";
        
        contentsView.frame = CGRectMake(15, CGRectGetMaxY(defaultView.frame)+10, self.contentView.frame.size.width - 32, CGRectGetMaxY(contentsLabel.frame));
        
        bottomRoundingView.frame = CGRectMake(5, 5, 310 ,CGRectGetMaxY(contentsView.frame));
#endif
        return;
    }
    
    //    if([ty isEqualToString:@"3"]){ //  식단
    ////        roundingView.hidden = NO;
    //
    //
    //        UIImageView *foodImage = [[UIImageView alloc]initWithFrame:CGRectMake(5,8,48,48)];
    //        NSString *randomString = [NSString stringWithFormat:@"sidn_photo_%02d.png",[SharedAppDelegate.root getRandomNumberBetween:1 to:5]];
    //        NSLog(@"randomS %@",randomString);
    //        foodImage.image = [UIImage imageNamed:randomString];
    //        [roundingView addSubview:foodImage];
    //        [foodImage release];
    //
    //        UIImageView *decoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,48,48)];
    //        decoImage.image = [UIImage imageNamed:@"sidn_bg.png"];
    //        [foodImage addSubview:decoImage];
    //        [decoImage release];
    //        NSLog(@"contentsLabel %@",contentsLabel.text);
    //        contentsLabel.text = [[contentsLabel.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    //        NSLog(@"contentsLabel %@",contentsLabel.text);
    //        CGRect frame = contentsLabel.frame;
    //        frame.origin.x += 58;
    //        frame.size.width -= 58;
    //        contentsLabel.frame = frame;
    //
    //        frame = defaultView.frame;
    //        frame.size.height += 5;
    //        defaultView.frame = frame;
    //
    //        contentsLabel.font = [UIFont systemFontOfSize:13];
    //        profileImageView.image = [UIImage imageNamed:@"n01_tl_list_profile_cook.png"];
    ////        contentsLabel.frame = (12, 25, 210, 0)
    //    } // 식단
    
    
    if([ty isEqualToString:@"6"]){
        timeLabel.text = @"";
#ifdef MQM
        if([parentViewCon isKindOfClass:[MQMDailyViewController class]]){
            if([self.idx isEqualToString:@"0"]){
                
                if([self.writeinfoType isEqualToString:@"4"]){
                    if([SharedAppDelegate.root.home.groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
                        contentsLabel.text = @"등록된 일지가 없습니다.";
                    }
                    else{
                        contentsLabel.text = @"새로운 일지를 등록해주세요.";
                    }
                }
            }
        }
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
        NSLog(@"type 6 %@ ctype %@",self.idx,self.contentType);
        if([parentViewCon isKindOfClass:[GreenQnAViewController class]]){
            if([self.idx isEqualToString:@"0"]){
                
                if([self.writeinfoType isEqualToString:@"4"]){
                    if([SharedAppDelegate.root.home.groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
                        contentsLabel.text = @"등록된 질문이 없습니다.";
                    }
                    else{
                        contentsLabel.text = @"새로운 질문을 등록해주세요.";
                    }
                }
            }
        }
        else if([parentViewCon isKindOfClass:[GreenRequestViewController class]]){
            if([self.idx isEqualToString:@"0"]){
                
                if([self.writeinfoType isEqualToString:@"4"]){
                    if([SharedAppDelegate.root.home.groupDic[@"groupmaster"] isEqualToString:[ResourceLoader sharedInstance].myUID]){
                        contentsLabel.text = @"등록된 배송요청이 없습니다.";
                    }
                    else{
                        contentsLabel.text = @"새로운 배송요청을 등록해주세요.";
                    }
                }
            }
        }
#endif
        //    defaultView.image = [[UIImage imageNamed:@"sns_balloon_04.png"]stretchableImageWithLeftCapWidth:0 topCapHeight:30];
        //         subImageView.image = [UIImage imageNamed:@"n01_tl_realic_lemp.png"];
        
        //        UIImageView *closeImage;
        //        closeImage = [[UIImageView alloc]initWithFrame:CGRectMake(defaultView.frame.origin.x, defaultView.frame.origin.y + defaultView.frame.size.height, defaultView.frame.size.width, 11)];
        //        closeImage.image = [UIImage imageNamed:@"sns_balloon_04.png"];
        //        [self.contentView addSubview:closeImage];
        //        [closeImage release];
        //
        //		CGFloat lineViewHeight = closeImage.frame.origin.y + 8;
        //		if ([self.idx isEqualToString:@"0"] && lineViewHeight < 80) {
        //			lineViewHeight = 80;
        //		}
        //        lineView.frame = CGRectMake(292, 0, 3, lineViewHeight+20);//SharedAppDelegate.root.home.view.frame.size.height-160);
        
    }
    //else if([ty isEqualToString:@"5"]){
    //
    //
    //    UIImageView *closeImage;
    //    closeImage = [[UIImageView alloc]initWithFrame:CGRectMake(defaultView.frame.origin.x, defaultView.frame.origin.y + defaultView.frame.size.height, defaultView.frame.size.width, 11)];
    //    closeImage.image = [UIImage imageNamed:@"n01_tl_stbn_closebtm.png"];
    //    [self.contentView addSubview:closeImage];
    //    [closeImage release];
    //
    //    lineView.frame = CGRectMake(292, 0, 3, closeImage.frame.origin.y + closeImage.frame.size.height + 7);
    ////    lineView.frame = CGRectMake(292, 0, 3, closeImage.frame.origin.y + closeImage.frame.size.height + 34);
    //}
}

- (void)setSearchText:(NSString *)text{
    NSLog(@"setSearchText %@",text);
    
    
//    NSRange searchRange = [contentsLabel.text rangeOfString:text];
//    NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:contentsLabel.text];
//        [string addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:searchRange];
//        contentsLabel.attributedText = string;
    NSLog(@"contentsLabel.text %@",contentsLabel.text);
  NSMutableAttributedString* str = [[NSMutableAttributedString alloc]initWithString:contentsLabel.text];
    NSLog(@"str %@",str);
    NSUInteger count = 0;
   NSUInteger length = [contentsLabel.text length];
    NSRange range = NSMakeRange(0, length);
    NSLog(@"length %d",length);
    while(range.location != NSNotFound)
    {
        range = [[contentsLabel.text lowercaseString] rangeOfString:[text lowercaseString] options:0 range:range];
        if(range.location != NSNotFound) {
//            [mutableAttributedString setTextColor:color range:NSMakeRange(range.location, [word length])];
              [str addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++;
        }
    }
 contentsLabel.attributedText = str;
    
}

- (void)setCategoryType:(NSString *)ca{
    [super setCategoryType:ca];
    
    NSLog(@"setCategoryType %@",ca);
    //    if([ca isEqualToString:@"10"]){
    //        NSLog(@"self.type %@",self.type);
    ////        if([self.type isEqualToString:@"6"])// || [self.type isEqualToString:@"5"])
    ////            subLabel.hidden = YES;
    ////        else
    ////        subLabel.hidden = NO;
    //    }
    //    else{
    ////        subLabel.hidden = YES;
    //    }
    //    if([ca isEqualToString:@"3"] || [ca isEqualToString:@"10"]){
    //
    //        CGSize size2 = [positionLabel.text sizeWithFont:positionLabel.font];
    //        [arrLabel setFrame:CGRectMake(positionLabel.frame.origin.x + (size2.width+5>80?80:size2.width+5), nameLabel.frame.origin.y, 15, 17)];
    //        [toLabel setFrame:CGRectMake(arrLabel.frame.origin.x + arrLabel.frame.size.width, nameLabel.frame.origin.y, 90 - 15, 17)];
    //    }
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"didFailLoadWithError code %d", (int)[error code]);
    
    
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    
    NSString *output = [webView
                        stringByEvaluatingJavaScriptFromString:
                        @"document.documentElement.scrollHeight"];
    
    
    
    float h = [output floatValue];
    
    NSLog(@"webviewHeight %f",webviewHeight);
    webviewHeight = h;
    NSLog(@"webviewHeight %f",webviewHeight);
    NSLog(@"h webview height %f",SharedAppDelegate.root.home.webviewHeight);
    SharedAppDelegate.root.home.webviewHeight = h;
    NSLog(@"h webview height %f",SharedAppDelegate.root.home.webviewHeight);
    [SharedAppDelegate.root.home.myTable beginUpdates];
    [SharedAppDelegate.root.home.myTable endUpdates];
    
    [self setContentType:self.contentType];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    
}

- (void)setSub_category:(NSString *)sub{
    [super setSub_category:sub];
    
    NSLog(@"sub %@",sub);
    if([sub length]<1)
        return;
    spgLabel.frame = CGRectMake(295,0,0,0);
    hpgLabel.frame = CGRectMake(295,0,0,0);
    nbgLabel.frame = CGRectMake(295,0,0,0);
    NSMutableArray *subArray = (NSMutableArray *)[sub componentsSeparatedByString:@","];
    NSLog(@"subArray %@",subArray);
    for(int i = 0; i < [subArray count]; i++){
        if([subArray[i] length]<1)
            [subArray removeObjectAtIndex:i];
    }
    
    for(NSString *substring in subArray){
        if([substring isEqualToString:@"NBG"]){
            nbgLabel.frame = CGRectMake(self.contentView.frame.size.width - 32-30,0,30,15);
            hpgLabel.frame = CGRectMake(self.contentView.frame.size.width - 32-30,0,0,0);
            spgLabel.frame = CGRectMake(self.contentView.frame.size.width - 32-30,0,0,0);
            nbgLabel.text = @"NBG";
        }
    }
    
    for(NSString *substring in subArray){
        if([substring isEqualToString:@"HPG"]){
            hpgLabel.frame = CGRectMake(nbgLabel.frame.origin.x-35,0,30,15);
            spgLabel.frame = CGRectMake(nbgLabel.frame.origin.x-35,0,0,0);
            hpgLabel.text = @"HPG";
        }
    }
    
    for(NSString *substring in subArray){
        if([substring isEqualToString:@"SPG"]){
            spgLabel.frame = CGRectMake(hpgLabel.frame.origin.x-35,0,30,15);
            spgLabel.text = @"SPG";
        }
    }
}
- (void)setContentType:(NSString *)ctype{
    [super setContentType:ctype];
    
    NSLog(@"setContenttype %@",ctype);
    if([ctype intValue]>17)
        return;
    
    NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
    
    
    NSString *imgString = self.contentDic[@"image"];
    NSLog(@"self.contentDic %@",self.contentDic);
    NSString *location = self.contentDic[@"jlocation"];
    NSString *con = self.contentDic[@"msg"];
    
#ifdef BearTalk
    con = self.content;
    
    NSLog(@"con %@",con);
#endif
    //		NSLog(@"CONTENT SIZE %i / ENCODE %i",[con length],[con lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    
    CGSize contentSize;
    CGFloat moreLabelHeight = 0.0;
    
    
    if([ctype intValue] == 12){
        
        if(webviewHeight == 0){
            NSLog(@"mywebview %@",myWebView);
        myWebView = [[UIWebView alloc] init];
        myWebView.backgroundColor = [UIColor whiteColor];
        myWebView.delegate = self;
        [contentsLabel addSubview:myWebView];
        
        NSData *htmlDATA = [con dataUsingEncoding:NSUTF8StringEncoding];
            [myWebView loadData:htmlDATA MIMEType: @"text/html" textEncodingName: @"UTF-8" baseURL:nil];
            
            myWebView.frame = CGRectMake(0, 0, self.contentView.frame.size.width - 30, 0);
            contentsLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width - 30, 0);
//            [myWebView release];
        }
        else{
            NSLog(@"mywebview %@",myWebView);
        
        
        myWebView.frame = CGRectMake(0, 0, self.contentView.frame.size.width - 32, webviewHeight);
        contentsLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width - 32, webviewHeight);
        }
    }
    else{
        
        if ([con length] > 500) {
            con = [con substringToIndex:500];
            //			NSLog(@"SUBSTR CONTENT SIZE %i / ENCODE %i",[con length],[con lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        }
        
        if([ctype intValue] == 10){
            con = @"";
        }
        
#ifdef BearTalk
        if([self.categoryname length]>0){
            NSMutableAttributedString *contentwithname;
            NSLog(@"con %@",con);
            if([con length]>0){
                
                NSString *msg = [NSString stringWithFormat:@"[%@]\n\n%@",self.categoryname,con];
                NSLog(@"categoryname1 %@ con %@",self.categoryname,con);
                
                NSArray *texts=[NSArray arrayWithObjects:[NSString stringWithFormat:@"[%@]\n\n",self.categoryname],[NSString stringWithFormat:@"%@",content],nil];
                
                contentwithname = [[NSMutableAttributedString alloc]initWithString:msg];
                
                NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"];
                
                [contentwithname addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[msg rangeOfString:texts[0]]];
                [contentwithname addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[msg rangeOfString:texts[1]]];
                [contentwithname addAttribute:NSForegroundColorAttributeName
                                        value:[NSKeyedUnarchiver unarchiveObjectWithData:colorData]
                                        range:[msg rangeOfString:texts[0]]];
                
                [contentwithname addAttribute:NSForegroundColorAttributeName
                                        value:RGB(54, 54, 55)
                                        range:[msg rangeOfString:texts[1]]];
                
                [contentsLabel setAttributedText:contentwithname];
            }
            else{
                
                NSString *msg = [NSString stringWithFormat:@"[%@]",self.categoryname];
                NSLog(@"categoryname2 %@ con %@",self.categoryname,con);
                
                NSArray *texts=[NSArray arrayWithObjects:[NSString stringWithFormat:@"[%@]",self.categoryname],nil];
                
                contentwithname = [[NSMutableAttributedString alloc]initWithString:msg];
                
                NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"];
                
                [contentwithname addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:[msg rangeOfString:texts[0]]];
                
                [contentwithname addAttribute:NSForegroundColorAttributeName
                                        value:[NSKeyedUnarchiver unarchiveObjectWithData:colorData]
                                        range:[msg rangeOfString:texts[0]]];
                                
                [contentsLabel setAttributedText:contentwithname];
            }
            
            
        }
        else{
        
            contentsLabel.text = con;
            
        }
#else
        contentsLabel.text = con;
#endif
        
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle};
#ifdef BearTalk
        if(!IS_NULL(self.imageArray) && [self.imageArray count]>0){
            if([self.categoryname length]>0){
                if([con length]>0){
                    [contentsLabel setNumberOfLines:7];
                }
                else{
                    [contentsLabel setNumberOfLines:5];
                    
                }
            }
            else{
                [contentsLabel setNumberOfLines:5];
                
            }
#else
            if(!IS_NULL(imgString) && [imgString length]>5){
                [contentsLabel setNumberOfLines:5];
#endif
            
            contentSize = [con boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width - 32, fontSize*(contentsLabel.numberOfLines+1)) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            

            
      //      contentSize = [con sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 32, fontSize*6) lineBreakMode:NSLineBreakByWordWrapping];
            
            
        }
        else   {
            
            
#ifdef BearTalk
            
                if([self.categoryname length]>0){
                    if([con length]>0){
                        [contentsLabel setNumberOfLines:12];
                    }
                    else{
                        [contentsLabel setNumberOfLines:10];
                        
                    }
                }
                else{
                    [contentsLabel setNumberOfLines:10];
                    
                }
#else
                
                [contentsLabel setNumberOfLines:10];
#endif
                    
            contentSize = [con boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width - 32, fontSize*(contentsLabel.numberOfLines+1)) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            

      //      contentSize = [con sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 32, fontSize*11) lineBreakMode:NSLineBreakByWordWrapping];
            
            
        }
            CGRect realFrame = contentsLabel.frame;
            
            realFrame.size.width = [[UIScreen mainScreen] bounds].size.width - 32; //양쪽 패딩 합한 값이 64
            
            contentsLabel.frame = realFrame;
            
            [contentsLabel sizeToFit];
            
            
            
            NSLog(@"contentsLabel frame %f",contentSize.height);
            NSLog(@"contentsLabel frame %f",contentsLabel.frame.size.height);
            
#ifdef BearTalk
            contentsLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width - 32, contentsLabel.frame.size.height);
            NSLog(@"contentsLabel frame1 %@",NSStringFromCGRect(contentsLabel.frame));
#else
            contentsLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width - 30, contentsLabel.frame.size.height);
            NSLog(@"contentsLabel frame2 %@",NSStringFromCGRect(contentsLabel.frame));
            
#endif
            
            NSLog(@"contentsLabel.text %@",contentsLabel.text);
        
        CGSize realSize = [con boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width - 32, NSIntegerMax) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        

    //    CGSize realSize = [con sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 32, NSIntegerMax) lineBreakMode:NSLineBreakByWordWrapping];
        
        
        if (realSize.height > contentsLabel.frame.size.height) {
            UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0,CGRectGetMaxY(contentsLabel.frame), 80.0, 17.0)];
            [moreLabel setTextColor:[UIColor colorWithRed:0.217 green:0.346 blue:0.806 alpha:1.000]];
            [moreLabel setBackgroundColor:[UIColor clearColor]];
            [moreLabel setFont:[UIFont systemFontOfSize:15.0]];
#ifdef BearTalk
            moreLabel.frame = CGRectMake(0, CGRectGetMaxY(contentsLabel.frame), 80, 20);
            [moreLabel setTextColor:RGB(184, 184, 184)];
            [moreLabel setFont:[UIFont systemFontOfSize:13]];
#endif
            [moreLabel setText:@"...더보기"];
            [contentsView addSubview:moreLabel];
            
            moreLabelHeight = moreLabel.frame.size.height;
//            [moreLabel release];
        }
        
    }
    
    NSDictionary *dic = [location objectFromJSONString];//        if(location != nil && [location length]>0)
    //        {
    //            NSDictionary *dic = [location objectFromJSONString];//componentsSeparatedByString:@","];
    NSLog(@"dic text %@",dic[@"text"]);
    if([dic[@"text"]length]>0){
        //                whLabel.text = @"위치에서";
        //            }
        //            else
        whImageView.frame = CGRectMake(0, CGRectGetMaxY(contentsLabel.frame) + moreLabelHeight+5+10, 12, 17);
        whLabel.text = [NSString stringWithFormat:@"%@",dic[@"text"]];
        whLabel.frame = CGRectMake(10+15, whImageView.frame.origin.y, 300-20, 15);
        
    }
    else{
        whImageView.frame = CGRectMake(0, CGRectGetMaxY(contentsLabel.frame) + moreLabelHeight+10, 12, 0);
        whLabel.text = @"";
        whLabel.frame = CGRectMake(10+15, whImageView.frame.origin.y, 300-20, 0);
    }
    
    
    
    NSLog(@"whImageView frame %@",NSStringFromCGRect(whImageView.frame));
    if([ctype intValue] == 10){ // greentalk commercial // bigger image
        
#ifdef BearTalk
        if(!IS_NULL(self.imageArray) && [self.imageArray count]>0){
            
#else
        if(!IS_NULL(imgString) && [imgString length]>5)
        {
#endif
            NSLog(@"imgString %@",imgString);
            
            contentImageView.frame = CGRectMake(0, CGRectGetMaxY(whImageView.frame)+5-35, 310, 434);
            
            int imgCount;// = (int)[[[imgString objectFromJSONString]objectForKey:@"thumbnail"]count];
            
#ifdef BearTalk
            imgCount = (int)[self.imageArray count];
#else
            imgCount = (int)[[[imgString objectFromJSONString]objectForKey:@"thumbnail"]count];
#endif
            NSLog(@"imgCount %d",imgCount);
            //         if(imgCount>1){
            contentImageView.userInteractionEnabled = YES;
            UIScrollView *multiImage = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,310,434)];
            multiImage.showsHorizontalScrollIndicator = NO;
            multiImage.pagingEnabled = NO;
            multiImage.delegate = self;
            multiImage.bounces = YES;
            multiImage.scrollsToTop = NO;
            float imageViewWidth = 0;
            for(int i = 0; i<imgCount; i++){
                UIImageView *inImageView = [[UIImageView alloc]init];
                [inImageView setContentMode:UIViewContentModeScaleAspectFit];
                [inImageView setClipsToBounds:YES];
                if(i == 0){
                    inImageView.frame = CGRectMake(0, 0, 310-20, 434);
                    imageViewWidth = CGRectGetMaxX(inImageView.frame);
                }
                else if(i < imgCount-1){
                    inImageView.frame = CGRectMake(imageViewWidth+10, 0, 310-40, 434);
                    imageViewWidth = CGRectGetMaxX(inImageView.frame);
                }
                else if(i == imgCount-1){
                    
                    inImageView.frame = CGRectMake(imageViewWidth+10, 0, 310-20, 434);
                    imageViewWidth = CGRectGetMaxX(inImageView.frame);
                }
                
                
                NSURL *imgURL;// = [ResourceLoader resourceURLfromJSONString:imgString num:i thumbnail:YES];
#ifdef BearTalk
                  imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/file/%@",BearTalkBaseUrl,self.imageArray[i][@"FILE_KEY"]]];
#else
                imgURL = [ResourceLoader resourceURLfromJSONString:imgString num:i thumbnail:YES];
#endif
                NSLog(@"imgURL %@",imgURL);
                

                [inImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                    NSLog(@"fail %@",[error localizedDescription]);
                    [HTTPExceptionHandler handlingByError:error];
                    
                }];
                [multiImage addSubview:inImageView];
//                [inImageView release];
            }
            multiImage.contentSize = CGSizeMake(imageViewWidth,434);
            NSLog(@"cgsize %@",NSStringFromCGSize(multiImage.contentSize));
            
            [contentImageView addSubview:multiImage];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelect)];
            [multiImage addGestureRecognizer:tapGesture];
            tapGesture.delegate = self;

            
        }
        else{
            contentImageView.frame = CGRectMake(0, CGRectGetMaxY(whImageView.frame), self.contentView.frame.size.width - 32, 0);
        }
    }
    else {
        // not 10
        NSLog(@"type not 10 ");
#ifdef BearTalk
        if(!IS_NULL(self.imageArray) && [self.imageArray count]>0){
            
#else
        if(!IS_NULL(imgString) && [imgString length]>5)
        {
#endif
            NSLog(@"imgString %@",imgString);
            
            contentImageView.frame = CGRectMake(0, CGRectGetMaxY(whImageView.frame)+5, self.contentView.frame.size.width - 32, 137);
            
            
            
            int imgCount;
#ifdef BearTalk
            imgCount = (int)[self.imageArray count];
#else
            imgCount = (int)[[[imgString objectFromJSONString]objectForKey:@"thumbnail"]count];
#endif
            NSLog(@"imgCount %d",imgCount);
            //         if(imgCount>1){
            contentImageView.userInteractionEnabled = YES;
            UIScrollView *multiImage = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,self.contentView.frame.size.width - 32,137)];
            multiImage.showsHorizontalScrollIndicator = NO;
            multiImage.pagingEnabled = NO;
            multiImage.delegate = self;
            multiImage.bounces = YES;
            multiImage.scrollsToTop = NO;
            
            float imageViewWidth = 0;
            for(int i = 0; i<imgCount; i++){
                UIImageView *inImageView = [[UIImageView alloc]init];
                [inImageView setContentMode:UIViewContentModeScaleAspectFill];
                [inImageView setClipsToBounds:YES];
                if(i == 0){
                    inImageView.frame = CGRectMake(0, 0, self.contentView.frame.size.width - 32 - 20, 137);
                    imageViewWidth = CGRectGetMaxX(inImageView.frame);
                }
                else if(i < imgCount-1){
                    inImageView.frame = CGRectMake(imageViewWidth+10, 0, self.contentView.frame.size.width - 32 - 40, 137);
                    imageViewWidth = CGRectGetMaxX(inImageView.frame);
                }
                else if(i == imgCount-1){
                    
                    inImageView.frame = CGRectMake(imageViewWidth+10, 0, self.contentView.frame.size.width - 32 - 20, 137);
                    imageViewWidth = CGRectGetMaxX(inImageView.frame);
                }
                
                
                NSURL *imgURL;
                
#ifdef BearTalk
                
                imgURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/api/file/%@",BearTalkBaseUrl,self.imageArray[i][@"FILE_KEY"]]];
#else
                imgURL = [ResourceLoader resourceURLfromJSONString:imgString num:i thumbnail:YES];
#endif
                NSLog(@"imgURL %@",imgURL);
                [inImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                    NSLog(@"fail %@",[error localizedDescription]);
                    [HTTPExceptionHandler handlingByError:error];
                    
                }];
                [multiImage addSubview:inImageView];
//                [inImageView release];
            }
            multiImage.contentSize = CGSizeMake(imageViewWidth,137);
            NSLog(@"cgsize %@",NSStringFromCGSize(multiImage.contentSize));
            
            [contentImageView addSubview:multiImage];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelect)];
            [multiImage addGestureRecognizer:tapGesture];
            tapGesture.delegate = self;
//            [tapGesture release];
//            [multiImage release];
            
            
            //}
            //                else{
            //                    UIImageView *inImageView = [[UIImageView alloc]init];
            //                    [inImageView setContentMode:UIViewContentModeScaleAspectFill];
            //                    [inImageView setClipsToBounds:YES];
            //                    inImageView.frame = CGRectMake(0,0,270,137);
            //                    NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:imgString num:0 thumbnail:YES];
            //                    [inImageView setImageWithURL:imgURL placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b) {
            //
            //                    } failure:^(NSError *error) {
            //                        NSLog(@"fail %@",[error localizedDescription]);
            //                        [HTTPExceptionHandler handlingByError:error];
            //
            //                    }];
            //                    [contentImageView addSubview:inImageView];
            //
            //
            //                    UIImageView *coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,inImageView.frame.size.width,inImageView.frame.size.height)];
            //                    coverImage.image = [UIImage imageNamed:@"sns_photo_cover.png"];
            //                    [inImageView addSubview:coverImage];
            //                    [coverImage release];
            //                    [inImageView release];
            //
            //
            //        }
        }
        else{
            contentImageView.frame = CGRectMake(0, CGRectGetMaxY(whImageView.frame), self.contentView.frame.size.width - 32, 0);
        }
    }
    NSLog(@"contentImageView frame %@",NSStringFromCGRect(contentImageView.frame));
    
    NSDictionary *pDic = self.pollDic;
    NSLog(@"pollDic %@",pDic);
    
    
    if(!IS_NULL(pDic)){
        NSLog(@"poll not nil");
#ifdef BearTalk
        
        pollView.frame = CGRectMake(0, CGRectGetMaxY(contentImageView.frame)+10, contentsView.frame.size.width, 57);
        
        pollView.layer.borderWidth = 1.0;
        pollView.layer.borderColor = [RGB(244, 244, 244) CGColor];
        pollView.layer.cornerRadius = 3.0; // rounding label
        UIImageView *clipIcon;
        UILabel *fileInfo;
        
        
        
        pollView.backgroundColor = RGB(251, 251, 251);
        
        
        clipIcon = [[UIImageView alloc]init];
        clipIcon.userInteractionEnabled = YES;
        clipIcon.tag = 100;
        clipIcon.image = [UIImage imageNamed:@"btn_survey_off.png"];
        clipIcon.frame = CGRectMake(16, 16, 24, 24);
        
        [pollView addSubview:clipIcon];
        
        
        
        fileInfo = [[UILabel alloc]init];
        fileInfo.frame = CGRectMake(16+24+9, 0, pollView.frame.size.width - 16 - 24 - 9 - 16 - 15, pollView.frame.size.height);
        fileInfo.userInteractionEnabled = YES;
        fileInfo.tag = 300;
        [pollView addSubview:fileInfo];
        
        
        
        
        
        fileInfo.frame = CGRectMake(CGRectGetMaxX(clipIcon.frame)+5, 0, pollView.frame.size.width - (CGRectGetMaxX(clipIcon.frame)) - 16 - 15, pollView.frame.size.height);
        fileInfo.textAlignment = NSTextAlignmentLeft;
        fileInfo.font = [UIFont systemFontOfSize:14];
        
        
        NSString *subtitle = @"";
        if([pDic[@"ANONYMOUS_YN"]isEqualToString:@"Y"]){
            subtitle = [subtitle stringByAppendingString:@"무기명 "];
        }
        subtitle = [subtitle stringByAppendingString:@"설문 "];
        
        NSString *pollCloseDate = [NSString stringWithFormat:@"%@",pollDic[@"POLL_CLOSE_DATE"]];
        if(!IS_NULL(pDic[@"POLL_CLOSE_DATE"]) && [pollCloseDate length]>0){
//        if([pDic[@"POLL_CLOSE"]isEqualToString:@"Y"]){
            subtitle = [subtitle stringByAppendingString:@"종료"];
        }
        else{
            subtitle = [subtitle stringByAppendingString:@"진행중"];
        }
        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        NSString *msg = [NSString stringWithFormat:@"설문 %@\n%@",subtitle,pDic[@"POLL_TIT"]];
        NSLog(@"msg %@",msg);
        NSArray *texts=[NSArray arrayWithObjects:@"설문 ",[NSString stringWithFormat:@"%@\n",subtitle],pDic[@"POLL_TIT"],nil];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
        if([texts count]>0){
        [string addAttribute:NSForegroundColorAttributeName value:[NSKeyedUnarchiver unarchiveObjectWithData:colorData] range:[msg rangeOfString:texts[0]]];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[msg rangeOfString:texts[0]]];
        }
        else if([texts count]>1){
        [string addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153) range:[msg rangeOfString:texts[1]]];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[msg rangeOfString:texts[1]]];
        }
        else if([texts count]>2){
        [string addAttribute:NSForegroundColorAttributeName value:RGB(51, 51, 51) range:[msg rangeOfString:texts[2]]];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[msg rangeOfString:texts[2]]];
        }
        [fileInfo setAttributedText:string];
        fileInfo.numberOfLines = 0;
        
        
        
        
#else

        
        pollView.frame = CGRectMake(0, CGRectGetMaxY(contentImageView.frame)+5, self.contentView.frame.size.width - 32, 73);
        
        
        UIImageView *coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 53)];
        coverImage.image = [UIImage imageNamed:@"vote_listbtn.png"];
        [pollView addSubview:coverImage];
//        [coverImage release];
        
        
        NSString *subtitle = @"";
        if([pDic[@"is_anon"]isEqualToString:@"1"]){
            subtitle = [subtitle stringByAppendingString:@"무기명 "];
        }
        subtitle = [subtitle stringByAppendingString:@"설문 "];
        if([pDic[@"is_close"]isEqualToString:@"1"]){
            subtitle = [subtitle stringByAppendingString:@"종료"];
        }
        else{
            subtitle = [subtitle stringByAppendingString:@"진행중"];
        }
        UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(coverImage.frame.origin.x + coverImage.frame.size.width + 5,
                                                                          8,
                                                                          pollView.frame.size.width - 50 - 20, 17)];
        [subTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [subTitleLabel setFont:[UIFont systemFontOfSize:15]];
        [subTitleLabel setBackgroundColor:[UIColor clearColor]];
        [subTitleLabel setTextColor:RGB(55, 158, 216)];
        [pollView addSubview:subTitleLabel];
        subTitleLabel.text = subtitle;
//        [subTitleLabel release];
        
        
        NSString *text = pDic[@"title"];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(subTitleLabel.frame.origin.x,
                                                                       subTitleLabel.frame.origin.y + subTitleLabel.frame.size.height + 4, subTitleLabel.frame.size.width, 35)];
        [titleLabel setNumberOfLines:2];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor darkGrayColor]];//RGB(142,136,134)];
        [pollView addSubview:titleLabel];
        titleLabel.text = text;
//        [titleLabel release];
        
#endif
        
    }
    else{
        pollView.frame = CGRectMake(0, CGRectGetMaxY(contentImageView.frame), self.contentView.frame.size.width - 32, 0);
        
    }
    
    
    
    NSArray *fArray = self.fileArray;
    NSLog(@"fileArray %@",fArray);
    
    
    if(!IS_NULL(fArray) && [fArray count]>0){
        
        
#ifdef BearTalk
        
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        fileView.frame = CGRectMake(0, CGRectGetMaxY(pollView.frame)+10, contentsView.frame.size.width, 57);
        
        fileView.layer.borderWidth = 1.0;
        fileView.layer.borderColor = [RGB(244, 244, 244) CGColor];
        fileView.layer.cornerRadius = 3.0; // rounding label
        
        UIImageView *clipIcon;
        UIImageView *deleteImage;
        UILabel *fileInfo;
        
        
        
            fileView.backgroundColor = RGB(251, 251, 251);
        
        
            clipIcon = [[UIImageView alloc]init];
            clipIcon.userInteractionEnabled = YES;
        clipIcon.tag = 100;
        clipIcon.image = [UIImage imageNamed:@"btn_document_off.png"];
        clipIcon.frame = CGRectMake(16, 16, 24, 24);
        
            [fileView addSubview:clipIcon];
        
        
        
            fileInfo = [[UILabel alloc]init];
            fileInfo.frame = CGRectMake(16+24+9, 0, fileView.frame.size.width - 16 - 24 - 9 - 16 - 15, fileView.frame.size.height);
            fileInfo.userInteractionEnabled = YES;
            fileInfo.tag = 300;
            [fileView addSubview:fileInfo];
        
        
        
        
        fileInfo.frame = CGRectMake(CGRectGetMaxX(clipIcon.frame)+5, 0, fileView.frame.size.width - (CGRectGetMaxX(clipIcon.frame)) - 16 - 15, fileView.frame.size.height);
        fileInfo.textAlignment = NSTextAlignmentLeft;
        fileInfo.font = [UIFont systemFontOfSize:14];
        
        
        NSString *fileTitle;
        if([fArray count] == 1)
            fileTitle = fArray[0][@"FILE_NAME"];
        else
            fileTitle = [NSString stringWithFormat:@"%@ 외 %d개의 첨부 파일",fArray[0][@"FILE_NAME"],(int)[fArray count]-1];
        
        NSString *msg = [NSString stringWithFormat:@"첨부 파일 %d개\n%@",(int)[fArray count],fileTitle];
        NSLog(@"fileTitle %@",fileTitle);
        NSLog(@"msg %@",msg);
        NSArray *texts=[NSArray arrayWithObjects:[NSString stringWithFormat:@"첨부 파일 %d개",(int)[fArray count]],[NSString stringWithFormat:@"\n%@",fileTitle],nil];
                         NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
        
        if([texts count]>0){
                         [string addAttribute:NSForegroundColorAttributeName value:[NSKeyedUnarchiver unarchiveObjectWithData:colorData] range:[msg rangeOfString:texts[0]]];
                         [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[msg rangeOfString:texts[0]]];
        }
        else if([texts count]>1){
                         [string addAttribute:NSForegroundColorAttributeName value:RGB(51, 51, 51) range:[msg rangeOfString:texts[1]]];
                         [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[msg rangeOfString:texts[1]]];
        }
                         [fileInfo setAttributedText:string];
                         fileInfo.numberOfLines = 0;
                         
                         
#else
        
                         fileView.frame = CGRectMake(0, CGRectGetMaxY(pollView.frame)+5, self.contentView.frame.size.width - 32, 73);

        UIImageView *coverImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 53)];
        coverImage.image = [UIImage imageNamed:@"file_listbtn.png"];
        //                     coverImage.backgroundColor = [UIColor grayColor];
        [fileView addSubview:coverImage];

        
        NSString *subtitle = @"";
        subtitle = [NSString stringWithFormat:@"첨부 파일 %d개",(int)[fArray count]];
        UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(coverImage.frame.origin.x + coverImage.frame.size.width + 5,
                                                                          8,
                                                                          fileView.frame.size.width - 50 - 20, 17)];
        [subTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [subTitleLabel setFont:[UIFont systemFontOfSize:15]];
        [subTitleLabel setBackgroundColor:[UIColor clearColor]];
        [subTitleLabel setTextColor:RGB(89, 107, 148)];
        [fileView addSubview:subTitleLabel];
        subTitleLabel.text = subtitle;
//        [subTitleLabel release];
        
        
        NSString *text = @"";
        if([fArray count] == 1)
            text = fArray[0][@"filename"];
        else
            text = [NSString stringWithFormat:@"%@ 외 %d개의 첨부 파일",fArray[0][@"filename"],(int)[fArray count]-1];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(subTitleLabel.frame.origin.x,
                                                                       subTitleLabel.frame.origin.y + subTitleLabel.frame.size.height + 4, subTitleLabel.frame.size.width, 35)];
        [titleLabel setNumberOfLines:2];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor darkGrayColor]];//RGB(142,136,134)];
        [fileView addSubview:titleLabel];
        titleLabel.text = text;
//        [titleLabel release];
#endif
    }
    else{
        fileView.frame = CGRectMake(0, CGRectGetMaxY(pollView.frame), self.contentView.frame.size.width - 32, 0);
        
    }
    
    NSLog(@"contentsLabel %@",contentsLabel);
    //    NSLog(@"mywebview %@",myWebView);
    
#ifdef BearTalk
    
    contentsView.frame = CGRectMake(16, CGRectGetMaxY(defaultView.frame), self.contentView.frame.size.width - 32, CGRectGetMaxY(fileView.frame));
    bgView.frame = CGRectMake(0,0,self.contentView.frame.size.width,CGRectGetMaxY(contentsView.frame));
#else
    contentsView.frame = CGRectMake(15, CGRectGetMaxY(defaultView.frame)+10, self.contentView.frame.size.width - 32, CGRectGetMaxY(fileView.frame));
    NSLog(@"contentsView frame %@",NSStringFromCGRect(contentsView.frame));
    
    bottomRoundingView.frame = CGRectMake(5, 5, 310 ,CGRectGetMaxY(contentsView.frame));
    //    contentsView.backgroundColor = [UIColor grayColor];
#endif
}


- (void)setWriteinfoType:(NSString *)wtype{
    [super setWriteinfoType:wtype];
    
    
    
}

        
//- (void)join{
//    NSLog(@"join");
//
//}
//- (void)deny{
//    NSLog(@"deny");
//
//}


//- (void)setImage:(NSString *)img{
//    [super setImage:img];
//
//
//    if(img != nil && [img length]>5)
//    {
//        [contentsLabel setNumberOfLines:2];
//        CGSize contentSize = [newContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 50) lineBreakMode:NSLineBreakByWordWrapping];
//        contentsLabel.frame = CGRectMake(12.0, toLabel.frame.origin.y + toLabel.frame.size.height + 5 + contentImageView.frame.size.height, 200, contentSize.height + 5);
//
//    }
//    else{
//
//        [contentsLabel setNumberOfLines:7];
//        CGSize contentSize = [newContent sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, 130) lineBreakMode:NSLineBreakByWordWrapping];
//        contentsLabel.frame = CGRectMake(12.0, toLabel.frame.origin.y + toLabel.frame.size.height + 5, 200, contentSize.height + 5);
//
//    }
//
//}
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if([scrollView isKindOfClass:[UITableView class]])
        return;
    CGFloat pageWidth = 260;//scrollView.frame.size.width;
    
    _currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    NSLog(@"Dragging - You are now on page %i", _currentPage);
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSLog(@"scrollViewWillEndDragging");
    
    if([scrollView isKindOfClass:[UITableView class]])
        return;
    CGFloat pageWidth = 260;//scrollView.frame.size.width;
    NSLog(@"pageWidth %f",pageWidth);
    
    int newPage;// = _currentPage;
    
    if (velocity.x == 0) // slow dragging not lifting finger
    {
        newPage = floor((targetContentOffset->x - pageWidth / 2) / pageWidth) + 1;
        NSLog(@"newPage %d",newPage);
    }
    else
    {
        newPage = velocity.x > 0 ? _currentPage + 1 : _currentPage - 1;
        
        NSLog(@"newPage %d",newPage);
        if (newPage < 0)
            newPage = 0;
        if (newPage > scrollView.contentSize.width / pageWidth)
            newPage = ceil(scrollView.contentSize.width / pageWidth) - 1.0;
        NSLog(@"newPage %d",newPage);
    }
    
    NSLog(@"Dragging - You will be on %i page (from page %i)", newPage, _currentPage);
    
    *targetContentOffset = CGPointMake(newPage * pageWidth, targetContentOffset->y);
    
}

- (void)didSelect{
    NSLog(@"didSelect");
    
    if ([parentViewCon isKindOfClass:[HomeTimelineViewController class]])
        [(HomeTimelineViewController *)parentViewCon didSelectImageScrollView:self.idx];
    
    if ([parentViewCon isKindOfClass:[SocialSearchViewController class]])
        [(SocialSearchViewController *)parentViewCon didSelectImageScrollView:self.idx];
#ifdef MQM
    if ([parentViewCon isKindOfClass:[MQMDailyViewController class]])
        [(MQMDailyViewController *)parentViewCon didSelectImageScrollView:self.idx];
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
    if ([parentViewCon isKindOfClass:[GreenQnAViewController class]])
    [(GreenQnAViewController *)parentViewCon didSelectImageScrollView:self.idx];
    
    if ([parentViewCon isKindOfClass:[GreenRequestViewController class]])
        [(GreenRequestViewController *)parentViewCon didSelectImageScrollView:self.idx];
#endif

    
}

#define kSelectShare 6


- (void)share:(id)sender{
    NSLog(@"share");
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"소셜로 공유하기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            [SharedAppDelegate.root.home showShareGroupActionsheet:self.idx];
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"외부로 공유하기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            [SharedAppDelegate.root.home showShareOtherAppActionsheet:self.contentDic[@"msg"] con:parentViewCon];

                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"cancel", @"cancel")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [SharedAppDelegate.window.rootViewController presentViewController:view animated:YES completion:nil];
        
    }
    else{
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                destructiveButtonTitle:nil otherButtonTitles:@"소셜로 공유하기", @"외부로 공유하기", nil];
    
    [actionSheet showInView:SharedAppDelegate.window];
    actionSheet.tag = kSelectShare;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == kSelectShare){
        if(buttonIndex == 0){
            
            [SharedAppDelegate.root.home showShareGroupActionsheet:self.idx];
        }
        else if(buttonIndex == 1){
            
            [SharedAppDelegate.root.home showShareOtherAppActionsheet:self.contentDic[@"msg"] con:parentViewCon];
        }
        
    }
}

- (void)addOrClear:(id)sender
        {
            
#ifdef BearTalk
#else
            if([[SharedAppDelegate readPlist:@"was"]length]<1)
                return;
#endif
            
            
#if defined(GreenTalk) || defined(GreenTalkCustomer)
    if([self.contentType isEqualToString:@"1"])
        [self share:sender];
    return;
#endif
    
    [MBProgressHUD showHUDAddedTo:sender label:nil animated:YES];
    
    NSString *p_type;
    NSString *urlString;
    NSString *method;
#ifdef BearTalk
    method = @"PUT";
    if([sender tag]==kNotFavorite){
        p_type = @"i";
    }
    else{
        p_type = @"d";
    }
    urlString = [NSString stringWithFormat:@"%@/api/sns/conts/bookmark",BearTalkBaseUrl];
#else
    
    method = @"POST";
    if([sender tag]==kNotFavorite){
        p_type = @"1";
    }
    else{
        p_type = @"2";
    }
    urlString = [NSString stringWithFormat:@"https://%@/lemp/info/setfavorite.lemp",[SharedAppDelegate readPlist:@"was"]];

#endif
//    AFHTTPClient *client = [[[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]]autorelease];
        NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters;
#ifdef BearTalk
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                  self.idx,@"contskey",
                  SharedAppDelegate.root.home.groupnum,@"snskey",
                  [ResourceLoader sharedInstance].myUID,@"uid",
                  p_type,@"type",
                  nil];//@{ @"uniqueid" : @"c110256" };
#else
    parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                p_type,@"type",@"2",@"category",self.idx,@"contentindex",
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                @"",@"member",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",nil];
#endif
    
    NSLog(@"parameter %@",parameters);
    
//    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setfavorite.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:method URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
#ifdef BearTalk
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString];
        NSLog(@"ResulstDic %@",resultDic);
        
        if([sender tag] == kNotFavorite){
            
                [favButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_on.png"] forState:UIControlStateNormal];
            
            favButton.tag = kFavorite;
        }
        else{
            
                [favButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_off.png"] forState:UIControlStateNormal];
            
            favButton.tag = kNotFavorite;
            
        }
        [SharedAppDelegate.root setNeedsRefresh:YES];
        [MBProgressHUD hideHUDForView:sender animated:YES];
        NSLog(@"favButton frame %@",NSStringFromCGRect(favButton.frame));
#else
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResulstDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {

            if([sender tag] == kNotFavorite){
                if([self.contentType isEqualToString:@"7"])
                    [favButton setBackgroundImage:[UIImage imageNamed:@"button_note_detail_bookmark_selected.png"] forState:UIControlStateNormal];
                else
                    [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_prs.png"] forState:UIControlStateNormal];
                
                favButton.tag = kFavorite;
            }
            else{
                if([self.contentType isEqualToString:@"7"])
                    [favButton setBackgroundImage:[UIImage imageNamed:@"button_note_detail_bookmark.png"] forState:UIControlStateNormal];
                else
                    [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_dft.png"] forState:UIControlStateNormal];
                
                favButton.tag = kNotFavorite;
                
            }
            

            //            if([SharedAppDelegate.root.home.category isEqualToString:@"10"])
            [SharedAppDelegate.root setNeedsRefresh:YES];
            //                [SharedAppDelegate.root.home refreshTimeline];
            
            
            [MBProgressHUD hideHUDForView:sender animated:YES];
            
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:SharedAppDelegate.window.rootViewController];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            [MBProgressHUD hideHUDForView:sender animated:YES];
            
        }
        
#endif
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [MBProgressHUD hideHUDForView:sender animated:YES];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"즐겨찾기 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"ok") otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
    
}
@end
