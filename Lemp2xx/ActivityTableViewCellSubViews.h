//
//  ActivityTableViewCellSubViews.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 4. 4..
//  Copyright (c) 2014년 BENCHBEE. All rights reserved.
//

#import "ActivityTableViewCell.h"

@interface ActivityTableViewCellSubViews : ActivityTableViewCell
{
	UIImageView *backgroundView;
	UIImageView *profileImageView;
    UIImageView *defaultView;
	UIImageView *bottomView;
	
	UILabel *timeLabel;
	UILabel *timeDetailLabel;
    UILabel *nameLabel;
    UILabel *positionLabel;
    UILabel *teamLabel;
	UILabel *contentsLabel;
	UILabel *whLabel;
	
    UIImageView *whImageView;
    UIImageView *contentImageView;
	UIImageView *likeImageView;
	UIImageView *replyImageView;
	
    UIImageView *lineView;
    UIImageView *subImageView;
    
    
	UILabel *likeCountLabel;
    UILabel *replyCountLabel;
	
	UITapGestureRecognizer *tapGesture;
    UIButton *likeMemberButton;
    UIButton *deleteButton;
	
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
