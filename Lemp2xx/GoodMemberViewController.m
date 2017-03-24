//
//  GoodMemberViewController.m
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 11. 12..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import "GoodMemberViewController.h"

@interface GoodMemberViewController ()

@end

@implementation GoodMemberViewController

@synthesize member;




- (id)initWithMember:(NSMutableArray *)m//WithStyle:(UITableViewStyle)style
{
    self = [super init];//WithStyle:style];
    if (self) {
        // Custom initialization
        
        self.member = [NSMutableArray arrayWithArray:m];
        self.title = @"좋아요 멤버";
//        self.tableView.tag = t;
        self.tableView.rowHeight = 50;
//        [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(refreshProfiles)
													 name:@"refreshProfiles"
												   object:nil];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return self;
}

- (void)refreshProfiles
{
	[self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
	
//	if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//		self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//		self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//	}
//
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(backTo:)];
    UIButton *button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo:)];
    UIBarButtonItem *btnnavl = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnnavl;
//    [btnnavl release];
//    [button release];
    

    self.tableView.scrollsToTop = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)backTo:(id)sender
{
    NSLog(@"backTo");
    //    self.viewDeckController.centerController = SharedAppDelegate.timelineController;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}

- (void)dealloc
{
//    self.member = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
//	[super dealloc];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

//    self.member = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.member count];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImageView *profileView;
    UIImageView *roundingView;
    UILabel *nameLabel, *teamLabel;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        profileView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        profileView.tag = 1;
        [cell.contentView addSubview:profileView];
//        [profileView release];
        
        
        roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(0,0,profileView.frame.size.width,profileView.frame.size.height);
        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        [profileView addSubview:roundingView];
        roundingView.tag = 11;
//        [roundingView release];
        
        
        nameLabel = [CustomUIKit labelWithText:nil fontSize:0 fontColor:[UIColor blackColor] frame:CGRectMake(55, 5, 320-60-70, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        nameLabel.font = [UIFont boldSystemFontOfSize:15];
        nameLabel.tag = 2;
        [cell.contentView addSubview:nameLabel];
//        [nameLabel release];
        
//        positionLabel = [CustomUIKit labelWithText:nil fontSize:0 fontColor:[UIColor grayColor] frame:CGRectMake(0, 0, 0, 0) numberOfLines:1 alignText:NSTextAlignmentLeft];
//        positionLabel.font = [UIFont systemFontOfSize:14];
//        positionLabel.tag = 3;
//        [cell.contentView addSubview:positionLabel];
//        [positionLabel release];
        
        teamLabel = [CustomUIKit labelWithText:nil fontSize:0 fontColor:[UIColor grayColor] frame:CGRectMake(0, 0, 0, 0) numberOfLines:1 alignText:NSTextAlignmentLeft];
        teamLabel.font = [UIFont systemFontOfSize:12];
        teamLabel.tag = 4;
        [cell.contentView addSubview:teamLabel];
//        [teamLabel release];
    }
    else{
        profileView = (UIImageView *)[cell viewWithTag:1];
        nameLabel = (UILabel *)[cell viewWithTag:2];
//        positionLabel = (UILabel *)[cell viewWithTag:3];
        teamLabel = (UILabel *)[cell viewWithTag:4];
        roundingView = (UIImageView *)[cell viewWithTag:11];
    }
	profileView.image = nil;
//    profileView.image = [SharedAppDelegate.root getImage:[[self.memberobjectatindex:indexPath.row]objectForKey:@"uid"] ifNil:@"n01_tl_list_profile.png"];
    
    [SharedAppDelegate.root getProfileImageWithURL:self.member[indexPath.row][@"uid"] ifNil:@"profile_photo.png" view:profileView scale:0];
//    NSDictionary *dic = [SharedAppDelegate.root searchContactDictionary:[self.memberobjectatindex:indexPath.row]];
    
    NSDictionary *dic = nil;
//    if(self.view.tag == kActivity)
//        dic = [SharedAppDelegate.root searchContactDictionary:self.member[indexPath.row][@"uid"]];
//    else
    dic = [self.member[indexPath.row][@"writeinfo"]objectFromJSONString];
    NSLog(@"dic %@",dic);
    
    nameLabel.text = dic[@"name"];
    if([dic[@"position"]length]>0)
    {
        if([dic[@"deptname"]length]>0)
            teamLabel.text = [NSString stringWithFormat:@"%@ | %@",dic[@"position"],dic[@"deptname"]];
        else
            teamLabel.text = [NSString stringWithFormat:@"%@",dic[@"position"]];
    }
    else{
        if([dic[@"deptname"]length]>0)
            teamLabel.text = [NSString stringWithFormat:@"%@",dic[@"deptname"]];
    }
    
    teamLabel.frame = CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height, nameLabel.frame.size.width, nameLabel.frame.size.height);
    
//    positionLabel.text = dic[@"position"];
//    teamLabel.text = dic[@"deptname"];
//    CGSize size = [nameLabel.text sizeWithFont:nameLabel.font];
//    [positionLabel setFrame:CGRectMake(nameLabel.frame.origin.x + (size.width+5>90?90:size.width+5), 16, 90, 15)];
//    CGSize size2 = [positionLabel.text sizeWithFont:positionLabel.font];
//                         [teamLabel setFrame:CGRectMake(positionLabel.frame.origin.x + (size2.width+5>90?90:size2.width+5), 15, 80, 15)];
    
    if([nameLabel.text length]<1){
        nameLabel.text = NSLocalizedString(@"unknown_user", @"unknown_user");
//        positionLabel.text = @"";
        teamLabel.text = @"";
    }
    
    
#if defined(LempMobileNowon) || defined(LempMobile)
    roundingView.hidden = YES;
    
#else
    roundingView.hidden = NO;
#endif
    // Configure the cell...
    
    return cell;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [SharedAppDelegate.root.home goToYourTimeline:self.member[indexPath.row][@"uid"]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
