//
//  MySucriptionVC.m
//  Zuntik
//
//  Created by Dev-Mac on 07/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "MySucriptionVC.h"
#import "SimpleTableCell.h"
#import "SWRevealViewController.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "SubcriptionDetailVC.h"
#import "SearchCalendarVC.h"
@interface MySucriptionVC ()
@property (strong, nonatomic) IBOutlet UILabel *lblAlert;
@end

@implementation MySucriptionVC
@synthesize tblSucription;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _lblAlert.hidden=YES;
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;//NavigationBar Hide
    
    [self SwrevelViewButton];//AddButton on Header(1)

}

- (void)viewWillAppear:(BOOL)animated
{
    objeAppdelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    arrForResponse=[[NSMutableArray alloc]init];
    userDefaults = [NSUserDefaults standardUserDefaults];
    strUserId=[userDefaults valueForKey:@"UserId"];
    objDatabase = [DataBaseManagement Connetion];//Database Connection
    [self MbProcessHud];//MbHud Method(2)
}

-(void)SwrevelViewButton //AddButton on Header(1)
{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIButton *btnLeft=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44 , 44)];
    [btnLeft setImage:[UIImage imageNamed:@"reveal-icon.png"]forState:UIControlStateNormal];
    [btnLeft addTarget:revealController action:@selector(revealToggle:)
      forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnLeft];
}
-(IBAction)AddSearchAction:(id)sender
{
    SWRevealViewController *revealController = self.revealViewController;
    
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
    
    if ( ![frontNavigationController.topViewController isKindOfClass:[SearchCalendarVC class]] )
    {
        SearchCalendarVC *frontViewController = [[SearchCalendarVC alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        [revealController setFrontViewController:navigationController animated:YES];
    }
}
-(void)MbProcessHud  //MbHud Method(2)
{
   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    [self CheckNetwork];  //Network Check(3)

}

-(void)CheckNetwork  //Network Check(3)
{
    Reachability *reachTest = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachTest  currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        [self ONDataBaseSubscriptionsValue];//CallLocalDatabase Value

    }
    else
    {
         [self ONServerSubscriptionsValue];//Call Server Value */ //Api call
       
    }
    
}
//Locale Databse Subscriptions
-(void)ONDataBaseSubscriptionsValue
{
    //Get All Subscriptions’ Data
    NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
    dicResponse= [objDatabase getSubscriptionsData:strUserId];
    NSString *stractivate=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
    if ([stractivate isEqualToString:@"1"]) {
        arrForResponse=[dicResponse valueForKey:@"subscriptions"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (arrForResponse.count>0)
        {
            _lblAlert.hidden=YES;
            [tblSucription reloadData]; //Table Reload
        }
        else
        {
            _lblAlert.hidden=NO;
        }
    }
}
//Server Subscriptions
-(void)ONServerSubscriptionsValue
{
    // [objDatabase deleteAllRecoredFromTbl:@"subscriptions’"];//DeleteData on subscriptions Table
    NSDictionary *parameters = @{@"user_email":strUserId,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"returnAllUsersSubs.php" Withparms:parameters WithSuccess:^(id response)
     {
         NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
         dicResponse=[response JSONValue];
         NSString *stractivate=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         if ([stractivate isEqualToString:@"1"]) {
             
             [objDatabase deleteSubscriptionsData_Userid_id:strUserId];  //delete data on database on userid
             
             arrForResponse=[dicResponse valueForKey:@"subscriptions"];
             for (int i=0;i<[arrForResponse count] ; i++)
             {
                 NSMutableDictionary *dicData=[arrForResponse objectAtIndex:i];
                 [objDatabase addUsersubscriptions:dicData];
                 
             }
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             if (arrForResponse.count>0)
             {
                 _lblAlert.hidden=YES;
                 [tblSucription reloadData]; //Table Reload
             }
             else
             {
                 _lblAlert.hidden=NO;
             }
             
         }
         else
         {
             
         }
     } failure:^(NSError *error)
     {
     }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrForResponse count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    SimpleTableCell *cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    NSString *strCal_name = [[[arrForResponse objectAtIndex:indexPath.row]valueForKey:@"cal_name"]uppercaseString];
    cell.lblSearchName.text =  strCal_name;
    cell.lblSearchDetail.text=[[arrForResponse objectAtIndex:indexPath.row]valueForKey:@"cal_creator"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    objeAppdelegate.Cal_name=[NSString stringWithFormat:@"%@",[[arrForResponse objectAtIndex:indexPath.row] objectForKey:@"cal_name"]];
    
    SubcriptionDetailVC *objSubcriptionDetailVC=[[SubcriptionDetailVC alloc]initWithNibName:@"SubcriptionDetailVC" bundle:Nil];
    objSubcriptionDetailVC.DicSubcriptionDetails=[arrForResponse objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:objSubcriptionDetailVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
