//
//  MQMTestedResultViewController.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2016. 6. 7..
//  Copyright © 2016년 BENCHBEE Co., Ltd. All rights reserved.
//
#import "MQMTestedResultViewController.h"

@interface MQMTestedResultViewController ()

@end

@implementation MQMTestedResultViewController





- (void)dealloc
{
    //    self.member = nil;
    
    //	[super dealloc];
}


- (id)initWithDictionary:(NSDictionary *)dic//WithStyle:(UITableViewStyle)style
{
    self = [super init];//WithStyle:style];
    if (self) {
        // Custom initialization
        myDic = [[NSDictionary alloc]initWithDictionary:dic];
        
        [self getMQMTestedResult:myDic];
   
    }
    return self;
}

- (void)getMQMTestedResult:(NSDictionary *)dic{
    
    
    
#ifdef BearTalk
#else
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#endif
    
    
    
    requested = NO;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    NSLog(@"getMQMTestedLink");
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/mqm_exam_result.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           [ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           dic[@"VENDOR_ID"],@"vender_id",
                           nil];//@{ @"uniqueid" : @"c110256" };
    
    
    //    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/auth/pulmuone_retirement.lemp" parametersJson:param key:@"param"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"1");
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        requested = YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            if(myList){
                myList = nil;
            }
            myList = [[NSMutableArray alloc]initWithArray:resultDic[@"check_result"]];
            [self.tableView reloadData];
            
            
            
        }
        else {
            
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        requested = YES;
        NSLog(@"FAIL : %@",operation.error);
        
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    
    requested = NO;
    
    
    UIButton *button = [CustomUIKit backButtonWithTitle:@"" target:self selector:@selector(backTo:)];
    UIBarButtonItem *btnnavl = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnnavl;

    
    self.title = @"검사결과";
    //        self.tableView.tag = t;
    
    self.view.backgroundColor = RGB(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)backTo:(id)sender
{
    NSLog(@"backTo");
    //    self.viewDeckController.centerController = SharedAppDelegate.timelineController;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
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
    return [myList count]==0?1:[myList count];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIImageView *roundingView;
    UILabel *nameLabel;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGB(245, 245, 245);
       
        
        
        roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(5,5,self.view.frame.size.width - 10, 120 - 10);
        [roundingView setImage:[[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10]];
        [cell.contentView addSubview:roundingView];
        roundingView.tag = 1;
        
        
        
        nameLabel = [CustomUIKit labelWithText:nil fontSize:12 fontColor:[UIColor blackColor] frame:CGRectMake(5, 5, roundingView.frame.size.width - 10, roundingView.frame.size.height - 10) numberOfLines:6 alignText:NSTextAlignmentLeft];
        nameLabel.tag = 2;
        [roundingView addSubview:nameLabel];
        
        
        
    }
    else{
        
        roundingView = (UIImageView *)[cell viewWithTag:1];
        nameLabel = (UILabel *)[cell viewWithTag:2];
    }
    if(requested){
    if([myList count]==0){
        NSLog(@"myList count 0");
        nameLabel.text = @"검사 결과가 없습니다.";
        nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    else{
        NSLog(@"myList count not 0");
        NSLog(@"mylist count %d",[myList count]);
        NSLog(@"myList %@",myList);
        NSDictionary *dic = myList[indexPath.row];
        NSString *contents = [NSString stringWithFormat:@"%@\n\n검사자 : %@\n검사항목 : %@\n사업장 : %@",dic[@"CHECK_DATE"],dic[@"CHECK_USER_NAME"],dic[@"ITEM_NAME"],dic[@"PLANT_NAME"]];
        
        nameLabel.text = contents;
        nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    }
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
    
}

@end
