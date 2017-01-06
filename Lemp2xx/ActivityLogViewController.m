//
//  ActivityLogViewController.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 2014. 4. 4..
//  Copyright (c) 2014년 BENCHBEE. All rights reserved.
//

#import "ActivityLogViewController.h"
#import "ActivityTableViewCell.h"
#import "ActivityTableViewCellSubViews.h"
#import "ActivityDetailViewController.h"
#import "GoodMemberViewController.h"
#import "GoogleMapViewController.h"
#import "WriteActivityViewController.h"
#import "SVPullToRefresh.h"

@interface ActivityLogViewController ()

@end

@implementation ActivityLogViewController
@synthesize timeLineCells;
@synthesize needRefresh;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
		self.title = @"활동 일지";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshProfiles) name:@"refreshProfiles" object:nil];
	}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.navigationController.navigationBar.translucent = NO;

	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeBottom;
//    self.view.backgroundColor = RGB(246,246,246);

//	if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//		self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//		self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//	}
	if (self.presentingViewController) {
//		UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:[CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(backTo) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"home_btn.png" imageNamedPressed:nil]];
        
//        UIButton *button;
//        button = [CustomUIKit closeButtonWithTarget:self selector:@selector(backTo)];
//        
//		UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//		self.navigationItem.leftBarButtonItem = btnNavi;
//		[btnNavi release];
        UIButton *button;
        UIBarButtonItem *btnNavi;
        button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(backTo)];
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = btnNavi;
        [btnNavi release];

	} else {
		UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
		UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
		self.navigationItem.leftBarButtonItem = btnNavi;
		[btnNavi release];
        [button release];
	}
	
	UIButton *writeButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(addActivity) frame:CGRectMake(0, 0, 32, 32) imageNamedBullet:nil imageNamedNormal:@"write_btn.png" imageNamedPressed:nil];
	UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:writeButton];
	self.navigationItem.rightBarButtonItem = btnNavi;
	[btnNavi release];
    
    float viewY = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        viewY = 44 + 20;
    } else {
        viewY = 44;
        
    }
	CGRect tableFrame;
		tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY);
	
	
    myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
//    myTable.backgroundColor = [UIColor clearColor];
    myTable.delegate = self;
    myTable.dataSource = self;
//    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTable.scrollsToTop = YES;
	
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
	
	[myTable addPullToRefreshWithActionHandler:^{
		[self refreshTimeline];
	}];
	myTable.pullToRefreshView.backgroundColor = self.view.backgroundColor;
	
	[myTable addInfiniteScrollingWithActionHandler:^{
		[self loadMoreTimeline];
	}];
	myTable.showsInfiniteScrolling = NO;

	
	coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 160)];
    coverImageView.backgroundColor = [UIColor blackColor];
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
	coverImageView.userInteractionEnabled = YES;
	coverImageView.image = [UIImage imageNamed:@"youwin_cover_activitylog.png"];
	coverImageView.clipsToBounds = YES;
	[myTable addSubview:coverImageView];
    [coverImageView release];
	
	UIImageView *gradationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 160-45, 320, 45)];
	gradationView.image = [UIImage imageNamed:@"pic_backline.png"];
	[coverImageView addSubview:gradationView];
		
	nowLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 18.0, gradationView.frame.size.width, 20.0)];
	nowLabel.font = [UIFont systemFontOfSize:14];
    nowLabel.textAlignment = UITextAlignmentLeft;
    nowLabel.backgroundColor = [UIColor clearColor];
    nowLabel.textColor = RGB(186,185,185);
	nowLabel.text = @"Activity Logs.";
	[gradationView addSubview:nowLabel];
    [nowLabel release];
	[gradationView release];

    [self.view addSubview:myTable];
    
    self.needRefresh = YES;
	refreshing = NO;
	isLoaded = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
    refreshing = NO;
    didRequest = NO;
	   
    NSLog(@"needsRefresh? %@",self.needRefresh?@"YES":@"NO");
    if(self.needRefresh){
        [self refreshTimeline];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[myTable release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (void)addActivity {
    
    WriteActivityViewController *wvc = [[WriteActivityViewController alloc]init];//WithInfo:dic];
    //        UINavigationController *nc = (UINavigationController *)dic[@"con"];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:wvc];
    [self presentModalViewController:nc animated:YES];
    [wvc release];
    [nc release];
}

- (void)backTo
{
	if (self.presentingViewController) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		[self.navigationController popViewControllerWithBlockGestureAnimated:YES];
	}
	
}

- (void)refreshProfiles
{
	[myTable reloadData];
}

- (void)refreshTimeline
{
    refreshing = YES;
	self.needRefresh = NO;
    [self getTimeline:@""];
}

- (void)loadMoreTimeline
{
	[self getTimeline:@"next"];
}

- (void)getTimeline:(NSString *)scope
{
	NSUInteger isScope = [scope length];
    if(didRequest){
		if (isScope) {
			[myTable.infiniteScrollingView stopAnimating];
		} else {
			[myTable.pullToRefreshView stopAnimating];
		}
        return;
    }

//    if(cidx == nil || [cidx length] == 0) {
//		if (scope != nil) {
//			[myTable.infiniteScrollingView stopAnimating];
//		}
//        return;
//	}

    didRequest = YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
//	NSString *urlString = @"https://dev.lemp.co.kr";
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
	[client setAuthorizationHeaderWithToken:[ResourceLoader sharedInstance].mySessionkey];
	
    NSDictionary *parameters;
    if(isScope) {
		NSLog(@"getTimeline %@",cidx);
        parameters = @{@"scope": scope, @"cidx": cidx};
	} else {
        if(refreshing == NO) {
            if(self.timeLineCells) {
                self.timeLineCells = nil;
            }
            [myTable reloadData];
	
        }
			
		myTable.contentOffset = CGPointMake(0, 0);
		parameters = nil;
	}
	NSLog(@"parameters %@",parameters);
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:@"/capi/youwin/activity/list" parameters:parameters];
	
	NSLog(@"request %@",request);
	NSLog(@"%@",[client description]);

    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        didRequest = NO;
        refreshing = NO;
		isLoaded = YES;

		if (isScope) {
			[myTable.infiniteScrollingView stopAnimating];
		} else {
			[myTable.pullToRefreshView stopAnimating];
		}
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        NSDictionary *resultDic = [operation.responseString objectFromJSONString];
        NSLog(@"ResultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"message"];
		
        if ([isSuccess isEqualToString:@"success"]) {
            NSMutableArray *resultArray = resultDic[@"contents"];
            NSMutableArray *parsingArray = [NSMutableArray array];
            if([resultArray count] > 0) {
//				NSString *lastIndex = resultArray[0][@"id"];

                for (NSDictionary *dic in resultArray) {
                    
                    if (cidx) {
                        [cidx release];
                        cidx = nil;
                    }
                    cidx = [[NSString alloc] initWithString:dic[@"id"]];
                    
                    ActivityTableViewCell *cellData = [[ActivityTableViewCell alloc] init];
					cellData.cid = dic[@"id"];
					cellData.uid = dic[@"uid"];
					cellData.position = dic[@"position"];
					cellData.deptName = dic[@"deptname"];
					cellData.createdTimeInterval = [dic[@"created"] length] > 0 ? [dic[@"created"] doubleValue] : 0.0;

					cellData.address = dic[@"address"];
					cellData.desc = dic[@"desc"];
					cellData.urlArray = dic[@"url"];
					cellData.fileCount = [dic[@"num_files"] length] > 0 ? [dic[@"num_files"] integerValue] : 0;
					
					cellData.replyArray = dic[@"reply"];
					cellData.likeArray = dic[@"like"];

					cellData.mapImageURL = [NSURL URLWithString:dic[@"mapfile"]];
					cellData.latitude = [dic[@"latitude"] length] > 0 ? [dic[@"latitude"] doubleValue] : 0.0;
					cellData.longitude = [dic[@"longitude"] length] > 0 ? [dic[@"longitude"] doubleValue] : 0.0;
					cellData.zoomLevel = [dic[@"zoomlevel"] length] > 0 ? [dic[@"zoomlevel"] integerValue] : 0;
					cellData.isNotice = ([dic[@"is_notice"] length] > 0 && [dic[@"is_notice"] isEqualToString:@"1"]) ? YES : NO;
					cellData.createdTimeString = dic[@"created_datetime"];
                    
                    [parsingArray addObject:cellData];
                    [cellData release];
                }
                
            }
            NSDictionary *dic = @{@"scope": scope, @"array": parsingArray};
			[self handleContents:dic];
            
        } else {
//            NSString *msg = [NSString stringWithFormat:@"오류: %@ %@",isSuccess,resultDic[@"resultMessage"]];
			[myTable reloadData];
            [CustomUIKit popupAlertViewOK:nil msg:@"데이터를 불러올 수 없습니다."];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        didRequest = NO;
        refreshing = NO;
		isLoaded = YES;

        NSLog(@"FAIL : %@",operation.error);

		if (isScope) {
			[myTable.infiniteScrollingView stopAnimating];
		} else {
			[myTable.pullToRefreshView stopAnimating];
		}
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[myTable reloadData];
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
}

- (void)handleContents:(NSDictionary *)dic
{
    NSLog(@"handleContents cell count %@",dic);
    
    if([dic[@"scope"] length] == 0) {
        self.timeLineCells = [NSMutableArray array];
        [self.timeLineCells setArray:dic[@"array"]];
		
		if ([self.timeLineCells count] > 9) {
			myTable.showsInfiniteScrolling = YES;
		} else {
			myTable.showsInfiniteScrolling = NO;
		}
	} else {
		[self.timeLineCells addObjectsFromArray:dic[@"array"]];
		
		if ([dic[@"array"] count] == 0) {
			myTable.showsInfiniteScrolling = NO;
		}
    }
    [myTable reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([self.timeLineCells count] > 0) {
		return [self.timeLineCells count]+1;
    } else {
        return 2;
	}
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([self.timeLineCells count] > 0) {
		static NSString *CellIdentifier = @"ActivityTableViewCell";
		ActivityTableViewCell *cell = (ActivityTableViewCell*)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
		
		// Configure the cell...
		if(cell == nil) {
			cell = [[[ActivityTableViewCellSubViews alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.backgroundColor = [UIColor clearColor];
		}
		tableView1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
		
		if(indexPath.row == 0) {
			cell.backgroundView = nil;
		} else {
			ActivityTableViewCell *dataItem = self.timeLineCells[indexPath.row-1];
			NSLog(@"dataItem %@",dataItem);
			
			cell.cid = dataItem.cid;
			cell.uid = dataItem.uid;
			cell.address = dataItem.address;
			cell.desc = dataItem.desc;
			cell.position = dataItem.position;
			cell.deptName = dataItem.deptName;
			cell.createdTimeString = dataItem.createdTimeString;
			
			cell.mapImageURL = dataItem.mapImageURL;
			cell.latitude = dataItem.latitude;
			cell.longitude = dataItem.longitude;
			cell.createdTimeInterval = dataItem.createdTimeInterval;
			
			cell.zoomLevel = dataItem.zoomLevel;
			cell.fileCount = dataItem.fileCount;
			cell.isNotice = dataItem.isNotice;
			
			cell.likeArray = dataItem.likeArray;
			cell.replyArray = dataItem.replyArray;
			cell.urlArray = dataItem.urlArray;
		}
		return cell;

	} else {
		UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor clearColor];

		if(indexPath.row == 0) {
			cell.backgroundView = nil;
		} else {
			tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;

			if (isLoaded) {
				UIImageView *profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 35, 35)];
				[profileImageView setImage:[UIImage imageNamed:@"sns_systeam.png"]];
								
				UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 90, 17)];
				[nameLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
				[nameLabel setBackgroundColor:[UIColor clearColor]];
				[nameLabel setTextColor:RGB(160, 18, 19)];
				[nameLabel setText:@"YouWin"];

				NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
				NSString *warningString = @"활동 내역이 없습니다.\n새로운 활동을 남겨보세요. 현재 위치의 활동 내용이나 상황을 즉시 공유할 수 있습니다.";
				CGSize contentSize = [warningString sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(270, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];

				UILabel *contentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, CGRectGetMaxY(nameLabel.frame)+5, 270, contentSize.height)];
				[contentsLabel setTextAlignment:UITextAlignmentLeft];
				[contentsLabel setFont:[UIFont systemFontOfSize:fontSize]];
				[contentsLabel setBackgroundColor:[UIColor clearColor]];
				[contentsLabel setAdjustsFontSizeToFitWidth:NO];
				[contentsLabel setNumberOfLines:0];
				[contentsLabel setText:warningString];
				
				[cell.contentView addSubview:profileImageView];
				[cell.contentView addSubview:nameLabel];
				[cell.contentView addSubview:contentsLabel];
				
				[profileImageView release];
				[nameLabel release];
				[contentsLabel release];
			} else {
				
				UILabel *progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 70, 260, 20)];
				progressLabel.text = @"활동일지를 가져오고 있습니다.";
				progressLabel.textColor = [UIColor grayColor];
				progressLabel.backgroundColor = [UIColor clearColor];
				progressLabel.font = [UIFont systemFontOfSize:16];
				progressLabel.tag = 6000;
				
				UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
				activity.frame = CGRectMake(248, 70, 20, 20);
				activity.tag = 7000;
				[activity startAnimating];
				
				[cell.contentView addSubview:progressLabel];
				[cell.contentView addSubview:activity];
				[progressLabel release];
				[activity release];
			}
		}

		return cell;
	}
	
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0;
    
	if(indexPath.row == 0) {
		height = 160.0;
	} else if([timeLineCells count] == 0) {
		height = 140.0;
	} else {

		ActivityTableViewCell *dataItem = self.timeLineCells[indexPath.row-1];
		
		NSString *content = dataItem.desc;
		NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
		
		height += (10+17+17+15+17+10); // defaultView TOP
		
		if(dataItem.fileCount > 1) {
			CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(240, 50) lineBreakMode:UILineBreakModeWordWrap];
			if ([content length] == 0) {
				contentSize.height = 7.0;
			} else {
				contentSize.height += 20.0;
			}
			
			height += (contentSize.height+137+8);
			
		} else {
			CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(240, 130) lineBreakMode:UILineBreakModeWordWrap];
			if ([content length] == 0) {
				contentSize.height = 0.0;
			}
			height += contentSize.height+8;
			
		}
		
		height += (29+10); // BOTTOM VIEW
	}
    
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 || didRequest || [self.timeLineCells count] == 0)
        return;
    
    didRequest = YES;
    
    ActivityDetailViewController *contentsViewCon = [[ActivityDetailViewController alloc] init];//WithViewCon:self]autorelease];
	contentsViewCon.contentsData = self.timeLineCells[indexPath.row-1];
    [self.navigationController pushViewController:contentsViewCon animated:YES];
    [contentsViewCon release];
    
}

@end
