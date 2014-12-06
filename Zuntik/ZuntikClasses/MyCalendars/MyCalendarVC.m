//
//  MyCalendarVC.m
//  Zuntik
//
//  Created by Dev-Mac on 07/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "MyCalendarVC.h"
#import "SimpleTableCell.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "CalendarDetailVc.h"
#import "CalendarMenuVC.h"
#import "ConfirmationEmailVC.h"
@interface MyCalendarVC ()

@end

@implementation MyCalendarVC
@synthesize tblMyCalendar;
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
    
    objAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
    [self SwrevelViewButton];//Add Button Header
   

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self MbProcessHud];
    userDefaults = [NSUserDefaults standardUserDefaults];
    strUserId=[userDefaults valueForKey:@"UserId"];
    objDatabase = [DataBaseManagement Connetion];//Database Connection
    [self CheckNetwork];  //Network Check(3)
}
-(void)SwrevelViewButton
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
-(void)MbProcessHud  //MbHud Method(2)
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    
}
-(void)CheckNetwork
{
    Reachability *reachTest = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachTest  currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        [self ONDataBaseCalendarValue];//CallLocalDatabase Value
        
    }
    else
    {
        [self ONServerCalendarValue];//Call Server Value */ //Api call
    }
    
}
#pragma ONDataBaseCalendarValue Method
//Locale Databse Subscriptions
-(void)ONDataBaseCalendarValue
{
    //Get All Subscriptions’ Data
    NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
    dicResponse= [objDatabase getCreatedData:strUserId];
    NSString *stractivate=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
    if ([stractivate isEqualToString:@"1"])
    {
        arrForResponse=[dicResponse valueForKey:@"allCals"];
        NSArray *temp=[NSArray arrayWithArray:arrForResponse];
        temp = [[temp reverseObjectEnumerator] allObjects];
        [arrForResponse removeAllObjects];
        arrForResponse=[NSMutableArray arrayWithArray:temp];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [tblMyCalendar reloadData]; //TABLE RELOAD DATA
    }
    
}
#pragma ONServerCalendarValue Method
-(void)ONServerCalendarValue
{
    ////returnCreatedAndCollab.php
    NSDictionary *parameters = @{@"user_email":strUserId,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"returnCreatedAndCollab.php" Withparms:parameters WithSuccess:^(id response)
     {
         [objDatabase deletecreatedCalsData_Userid_id:strUserId];  //delete data on database on userid

         NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
         dicResponse=[response JSONValue];
         NSString *stractivate=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         if ([stractivate isEqualToString:@"1"])
         {
            arrForResponse=[dicResponse valueForKey:@"allCals"];
             
             NSArray *temp=[NSArray arrayWithArray:arrForResponse];
             temp = [[temp reverseObjectEnumerator] allObjects];
             [arrForResponse removeAllObjects];
             arrForResponse=[NSMutableArray arrayWithArray:temp];
             
             for (int i=0;i<[arrForResponse count] ; i++)
             {
               NSMutableDictionary * dicData=[arrForResponse objectAtIndex:i];
                [objDatabase addUsercreatedCals:dicData];            //on database 
                 
             }
             [tblMyCalendar reloadData];  //TABLE RELOAD DATA
         }
         else{
             
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

     } failure:^(NSError *error)
     {
     }];
    
}
#pragma TableDelegate Method
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
    
    
    NSString *strUID=[[arrForResponse objectAtIndex:indexPath.row]valueForKey:@"cal_creator"];
    if ([strUID isEqualToString:strUserId]) {
        
        cell.lblSearchDetail.text=@"Me";
    }
    else
    {
        cell.lblSearchDetail.text=[[arrForResponse objectAtIndex:indexPath.row]valueForKey:@"cal_creator"];

    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    objAppDelegate.Cal_Key=[NSString stringWithFormat:@"%@",[[arrForResponse objectAtIndex:indexPath.row] objectForKey:@"cal_key"]];
    objAppDelegate.Cal_name=[NSString stringWithFormat:@"%@",[[arrForResponse objectAtIndex:indexPath.row] objectForKey:@"cal_name"]];
    
    CalendarDetailVc *objCalendarDetailVc=[[CalendarDetailVc alloc]initWithNibName:@"CalendarDetailVc" bundle:Nil];
    objCalendarDetailVc.DicCalendarDetails=[arrForResponse objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:objCalendarDetailVc animated:YES];
}
-(IBAction)CreateCalendar:(id)sender
{
   // objAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
   NSMutableDictionary *DicForUserDetails=[objDatabase getUserInfo:strUserId];
    
    NSString *strUserConfirmed=[DicForUserDetails valueForKey:@"confirmed"];
    
    UIViewController *objVIew;
    if ([strUserConfirmed isEqualToString:@"1"])
    {
     objVIew = [[CalendarMenuVC alloc]initWithNibName:@"CalendarMenuVC" bundle:nil];
    }
    else
    {
        objVIew=[[ConfirmationEmailVC alloc]initWithNibName:@"ConfirmationEmailVC" bundle:nil];
        
    }
    
    [self.navigationController pushViewController:objVIew animated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
