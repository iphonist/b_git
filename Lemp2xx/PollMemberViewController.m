//
//  PollMemberViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 2. 17..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import "PollMemberViewController.h"

@interface PollMemberViewController ()

@end

@implementation PollMemberViewController

- (id)initWithArray:(NSArray *)array//NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        myList = [[NSArray alloc]initWithArray:array];
        NSLog(@"mylist %@",myList);
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *title = [NSString stringWithFormat:@"%@ - %@명",myList[section][@"name"],myList[section][@"count"]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle};
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(self.view.frame.size.width-10-10, 150) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
//     CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(self.view.frame.size.width-10-10, 150) lineBreakMode:NSLineBreakByWordWrapping];
    return titleSize.height+16;
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    headerView.backgroundColor = [UIColor grayColor];
    headerView.image = [CustomUIKit customImageNamed:@"headersectionbg.png"];
    
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 7+12+7);
    headerView.image = nil;
    headerView.backgroundColor = RGB(238, 242, 245);
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, self.view.frame.size.width-10-10, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    
    headerLabel.frame = CGRectMake(16, 7, 100, 12);
    headerLabel.font = [UIFont systemFontOfSize:11];
    headerLabel.textColor = RGB(132, 146, 160);
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.numberOfLines = 0;
    headerLabel.text = [NSString stringWithFormat:@"%@ - %@명",myList[section][@"name"],myList[section][@"count"]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle};
    CGSize titleSize = [headerLabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width-10-10, 150) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
          //  CGSize titleSize = [headerLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(self.view.frame.size.width-10-10, 150) lineBreakMode:NSLineBreakByWordWrapping];
    headerLabel.frame = CGRectMake(16, 7, self.view.frame.size.width-16-16, titleSize.height);
    headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 14+headerLabel.frame.size.height);
    
    [headerView addSubview:headerLabel];
    
    
    
    return headerView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    self.title = @"설문 현황";
    
//	UIBarButtonItem *negativeSpaceforLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//		negativeSpaceforLeft.width = -10;
//	}
//    UIButton *button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cancel:) frame:CGRectMake(0, 0, 49, 33) imageNamedBullet:nil imageNamedNormal:@"cancel_navi_btn.png" imageNamedPressed:nil];//[CustomUIKit closeButtonWithTarget:self selector:@selector(cancel)];
//    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
////    self.navigationItem.leftBarButtonItem = btnNavi;
//	
//	self.navigationItem.leftBarButtonItems = @[negativeSpaceforLeft, btnNavi];
//    [btnNavi release];
//    [negativeSpaceforLeft release];

	
    UIButton *button;
    UIBarButtonItem *btnNavi;
    button = [CustomUIKit emptyButtonWithTitle:@"barbutton_close.png" target:self selector:@selector(cancel:)];
    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
//    UIBarButtonItem *negativeSpaceforRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//		negativeSpaceforRight.width = -10;
//	}
//	button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdEmail:) frame:CGRectMake(0, 0, 51, 33) imageNamedBullet:nil imageNamedNormal:@"email_btn.png" imageNamedPressed:nil];//[CustomUIKit emptyButtonWithTitle:@"공유" target:self selector:@selector(tryPost)];
//    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
//	
//    self.navigationItem.rightBarButtonItems = @[negativeSpaceforRight, btnNavi];
//	//    self.navigationItem.rightBarButtonItem = btnNavi;
//    [btnNavi release];
//	[negativeSpaceforRight release];
    

    
}
- (void)cmdEmail:(id)sender{
    
}

- (void)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning");
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.translucent = NO;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [myList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [myList[section][@"username"]length]>0?1:0;
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
    
    UILabel *nameLabel;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = RGB(250, 250, 250);
        
        
        nameLabel = [CustomUIKit labelWithText:nil fontSize:0 fontColor:[UIColor blackColor] frame:CGRectMake(50, 10, 90, 0) numberOfLines:0 alignText:NSTextAlignmentLeft];
        nameLabel.font = [UIFont boldSystemFontOfSize:13];
        nameLabel.tag = 1;
        [cell.contentView addSubview:nameLabel];
        
        
    }
    else{
        nameLabel = (UILabel *)[cell viewWithTag:1];
        
    }
    nameLabel.text = myList[indexPath.section][@"username"];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13], NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [nameLabel.text boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
   // CGSize size = [nameLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"size.height %f",size.height);
    nameLabel.frame = CGRectMake(10, 10, 300, size.height);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:13], NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [myList[indexPath.section][@"username"] boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
  //  CGSize size = [myList[indexPath.section][@"username"] sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height + 20;
    
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
