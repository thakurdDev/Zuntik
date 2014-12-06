//
//  ServicesCallVC.m
//  Zuntik
//
//  Created by Dev-Mac on 11/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "ServicesCallVC.h"
#import "SWRevealViewController.h"
#import "HomeVC.h"
#import "RearViewController.h"
#import "RightViewController.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "DataBaseManagement.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

@interface ServicesCallVC ()<SWRevealViewControllerDelegate>

@end

@implementation ServicesCallVC
@synthesize viewController;
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
    // Do any additional setup after loading the view from its nib.
    objDatabase = [DataBaseManagement Connetion];
    userDefaults = [NSUserDefaults standardUserDefaults];
    strUserId=[userDefaults valueForKey:@"UserId"];
    dicResponse=[[NSMutableDictionary alloc]init];
    dicData=[[NSMutableDictionary alloc]init];


    [self CheckNetwork];

}
-(void)CheckNetwork
{
    Reachability *reachTest = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachTest  currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)){
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"message:@"YourequireaninternetconnectionviaWiFiorcellular."  delegate:self
                                                cancelButtonTitle:@"Ok"  otherButtonTitles:nil];
        [myAlert show];
        [self HomeViewShow];

    }
    else{
        
//        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Yes Internet Connection"message:@"Connection Availabel"  delegate:self cancelButtonTitle:@"Ok"  otherButtonTitles:nil];
//        [myAlert show];
    //There are Table name
        /*  userInfo
         subscriptions’
         eventInfo
         created
         appHelp*/
        NSMutableArray *arryforTables=[[NSMutableArray alloc]initWithObjects:@"userInfo",@"subscriptions’",@"eventInfo",@"created",@"appHelp",nil];
       
        for (int Delete=0; Delete<[arryforTables count]; Delete++) {
            NSString *strTablename=[arryforTables objectAtIndex:Delete];
            [objDatabase deleteAllRecoredFromTbl:strTablename];

        }
        [self InsertDataonAllTable];
    }

}
-(void)InsertDataonAllTable
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
        [self UserInfo];

}
-(void)HomeViewShow
{
    
    HomeVC *frontViewController=[[HomeVC alloc]init];
     RearViewController *rearViewController = [[RearViewController alloc] init];
  
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
     revealController.delegate = self;
     
     RightViewController *rightViewController = rightViewController = [[RightViewController alloc] init];
     rightViewController.view.backgroundColor = [UIColor greenColor];
     revealController.rightViewController = nil;
     self.viewController = revealController;
     [self.navigationController pushViewController:self.viewController animated:YES];
    
}
-(void)UserInfo
{
    /*User Info-http://www.zuntik.com/API/V1/getUserInfo.php
    POST['user_email']
    POST['APIAccount']
    POST['APIPassword']
    */
    [dicResponse removeAllObjects];

    NSDictionary *parameters = @{@"user_email":strUserId,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"getUserInfo.php" Withparms:parameters WithSuccess:^(id response)
     {
         dicResponse=[response JSONValue];

         NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         if ([strSuccess isEqualToString:@"1"])
         {
             NSMutableDictionary *dicUserInfo=[[NSMutableDictionary alloc]init];
             dicUserInfo=[dicResponse valueForKey:@"user"];
             [objDatabase addUserInfo:dicUserInfo];
            // [DataBaseManagement database];
         }


     }
    failure:^(NSError *error)
     {
     }];
    [self userSubscribed];

}
-(void)userSubscribed
{
    [dicResponse removeAllObjects];
    [dicData removeAllObjects];
    NSDictionary *parameters = @{@"user_email":strUserId,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"returnAllUsersSubs.php" Withparms:parameters WithSuccess:^(id response)
     {
         dicResponse=[response JSONValue];
         
         NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         if ([strSuccess isEqualToString:@"1"])
         {
           //  NSMutableDictionary *dicUserInfo=[[NSMutableDictionary alloc]init];
             NSMutableArray *arrysubscriptions=[[NSMutableArray alloc]init];
             
             arrysubscriptions=[dicResponse valueForKey:@"subscriptions"];
             for (int i=0;i<[arrysubscriptions count] ; i++)
             {
                 dicData=[arrysubscriptions objectAtIndex:i];
                 [objDatabase addUsersubscriptions:dicData];
             }
          
         }
     }
    failure:^(NSError *error)
     {
     }];
    [self UserCreatedCalendarsList];

}

-(void)UserCreatedCalendarsList
{
    //returnCreatedAndCollab.php
    [dicResponse removeAllObjects];
    [dicData removeAllObjects];

    NSDictionary *parameters = @{@"user_email":strUserId,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"returnCreatedCals.php" Withparms:parameters WithSuccess:^(id response)
     {
         dicResponse=[response JSONValue];
         
         NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         if ([strSuccess isEqualToString:@"1"])
         {
             //  NSMutableDictionary *dicUserInfo=[[NSMutableDictionary alloc]init];
             NSMutableArray *arrycreatedCals=[[NSMutableArray alloc]init];
             
             arrycreatedCals=[dicResponse valueForKey:@"createdCals"];
             for (int i=0;i<[arrycreatedCals count] ; i++)
             {
                 dicData=[arrycreatedCals objectAtIndex:i];
               [objDatabase addUsercreatedCals:dicData];
             }
             
         }
     }
    failure:^(NSError *error)
     {
     }];
    [self UserHelpList];

}
-(void)UserHelpList
{
    [dicResponse removeAllObjects];
    [dicData removeAllObjects];

    NSDictionary *parameters = @{@"lastUpdate":@"2010/01/01 00:00:00",@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"returnAllQAndA.php" Withparms:parameters WithSuccess:^(id response)
     {
         dicResponse=[response JSONValue];
         
        // NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         if (dicResponse!=nil)
         {
             //  NSMutableDictionary *dicUserInfo=[[NSMutableDictionary alloc]init];
             NSMutableArray *arrynewHelp=[[NSMutableArray alloc]init];
             
             arrynewHelp=[dicResponse valueForKey:@"newHelp"];
             for (int i=0;i<[arrynewHelp count] ; i++)
             {
                 dicData=[arrynewHelp objectAtIndex:i];
                 [objDatabase addUsercreatedCals:dicData];
                 [objDatabase addHelpList:dicData];
             }
             
         }
     }
   
      failure:^(NSError *error)
     {
     }];
    [self UserCollaboratedCalendar];

}
-(void)UserCollaboratedCalendar
{
    [dicResponse removeAllObjects];
    [dicData removeAllObjects];
    
    NSDictionary *parameters = @{@"user_email":strUserId,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"fullCalendarUpdate2.php" Withparms:parameters WithSuccess:^(id response)
     {
         dicResponse=[response JSONValue];
         
         NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         if ([strSuccess isEqualToString:@"1"])
         {
             //  NSMutableDictionary *dicUserInfo=[[NSMutableDictionary alloc]init];
             NSMutableArray *arrynewEvents=[[NSMutableArray alloc]init];
             
             arrynewEvents=[dicResponse valueForKey:@"newEvents"];
             for (int i=0;i<[arrynewEvents count] ; i++)
             {
                 dicData=[arrynewEvents objectAtIndex:i];
                 [objDatabase addUsernewEvents:dicData];
             }
             
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
             [self HomeViewShow];
         }
     }
    failure:^(NSError *error)
     {
     }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
