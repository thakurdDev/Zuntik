//
//  ServicesCall.m
//  Zuntik
//
//  Created by Dev-Mac on 16/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "ServicesCall.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"


#define kNotificationGetEvents @"GetEvents"
#define kNotificationGetEvents1 @"GetEvents1"


@implementation ServicesCall
#pragma mark- InitilizeMethod
-(void)InitilizeMethod
{
    objAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    objDatabase = [DataBaseManagement Connetion];
    userDefaults = [NSUserDefaults standardUserDefaults];
    strUserId=[userDefaults valueForKey:@"UserId"];
    dicResponse=[[NSMutableDictionary alloc]init];
    dicData=[[NSMutableDictionary alloc]init];
    NSMutableArray *arryforTables=[[NSMutableArray alloc]initWithObjects:@"appHelp",nil];
    
    for (int Delete=0; Delete<[arryforTables count]; Delete++) {
        NSString *strTablename=[arryforTables objectAtIndex:Delete];
        [objDatabase deleteAllRecoredFromTbl:strTablename];
        
    }
 [self userIsActivated];
}
#pragma mark- userIsActivated
-(void)userIsActivated
{
    NSDictionary *parameters = @{@"user_email":strUserId,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"verifyUserActivation.php" Withparms:parameters WithSuccess:^(id response)
     {
         
         dicResponse=[response JSONValue];
         NSString *stractivate=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"activated"]];
         if ([stractivate isEqualToString:@"1"])
         {
             
             
         }
         else
         {
             
             
             
         }
         [self UserInfo];

     }
    failure:^(NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alert show];
     }];

}

#pragma mark- UserInfo

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
             BOOL setUser_email= [objDatabase UserInfo:[dicUserInfo valueForKey:@"user_email"]];

             if (setUser_email==YES)
             {
                 [objDatabase deleteUserInfoData_id:strUserId];
                 [objDatabase addUserInfo:dicUserInfo];
             }
             else{
                 [objDatabase addUserInfo:dicUserInfo];

             }
             [self userSubscribed];

         }
         
         
     }
    failure:^(NSError *error)
     {
     }];
    
}
#pragma mark- userSubscribed
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
             
             [objDatabase deleteSubscriptionsData_Userid_id:strUserId];  //delete data on database on userid
             //  NSMutableDictionary *dicUserInfo=[[NSMutableDictionary alloc]init];
             NSMutableArray *arrysubscriptions=[[NSMutableArray alloc]init];
             
             arrysubscriptions=[dicResponse valueForKey:@"subscriptions"];
             for (int i=0;i<[arrysubscriptions count] ; i++)
             {
                 dicData=[arrysubscriptions objectAtIndex:i];
                [objDatabase addUsersubscriptions:dicData];

             }
             [self UserCreatedCalendarsList];

         }
     }
   failure:^(NSError *error)
     {
     }];
    
}
#pragma mark- UserCreatedCalendarsList
-(void)UserCreatedCalendarsList
{
    //returnCreatedAndCollab.php
    [dicResponse removeAllObjects];
    [dicData removeAllObjects];
    
    NSDictionary *parameters = @{@"user_email":strUserId,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"returnCreatedAndCollab.php" Withparms:parameters WithSuccess:^(id response)
     {
         dicResponse=[response JSONValue];
         
         NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         if ([strSuccess isEqualToString:@"1"])
         {
             [objDatabase deletecreatedCalsData_Userid_id:strUserId];  //delete data on database on userid

             //  NSMutableDictionary *dicUserInfo=[[NSMutableDictionary alloc]init];
             NSMutableArray *arrycreatedCals=[[NSMutableArray alloc]init];
             
             arrycreatedCals=[dicResponse valueForKey:@"allCals"];
             
             for (int i=0;i<[arrycreatedCals count] ; i++)
             {
                 dicData=[arrycreatedCals objectAtIndex:i];
                [objDatabase addUsercreatedCals:dicData];//on database on 
                 
             }
             [self UserHelpList];

         }
     }
       failure:^(NSError *error)
     {
     }];
    
}
#pragma mark- UserHelpList

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
                 [objDatabase addHelpList:dicData];
             }
             [self UserCollaboratedCalendar];

         }
     }
     
    failure:^(NSError *error)
     {
     }];
    
}

#pragma mark- Events calendat
-(void)UserCollaboratedCalendar
{
    [dicResponse removeAllObjects];
    [dicData removeAllObjects];
    
    NSDictionary *parameters = @{@"user_email":strUserId,@"lastUpdate":@"2010/01/01 00:00:00",@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"fullCalendarUpdate2.php" Withparms:parameters WithSuccess:^(id response)
     {
         dicResponse=[response JSONValue];
         NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         if ([strSuccess isEqualToString:@"1"])
         {
             [objDatabase deleteEventsCalsData_Userid_id:strUserId];  //delete data on database on userid

             //  NSMutableDictionary *dicUserInfo=[[NSMutableDictionary alloc]init];
             NSMutableArray *arrynewEvents=[[NSMutableArray alloc]init];
             
             arrynewEvents=[dicResponse valueForKey:@"newEvents"];
             for (int i=0;i<[arrynewEvents count] ; i++)
             {
                 dicData=[arrynewEvents objectAtIndex:i];
                 [objDatabase addUsernewEvents:dicData];
             }
             
             [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationGetEvents object:nil];
             
         }
     }
    failure:^(NSError *error)
     {
     }];
    
}


#pragma mark- UserInfo

-(void)UserInfoHomePage
{
    /*User Info-http://www.zuntik.com/API/V1/getUserInfo.php
     POST['user_email']
     POST['APIAccount']
     POST['APIPassword']
     */
   // [dicResponse removeAllObjects];
    userDefaults = [NSUserDefaults standardUserDefaults];
    strUserId=[userDefaults valueForKey:@"UserId"];

    NSDictionary *parameters = @{@"user_email":strUserId,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"getUserInfo.php" Withparms:parameters WithSuccess:^(id response)
     {
       NSMutableDictionary * dicResponse1=[response JSONValue];
         
         NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse1 valueForKey:@"success"]];
         if ([strSuccess isEqualToString:@"1"])
         {
             NSMutableDictionary *dicUserInfo=[[NSMutableDictionary alloc]init];
             dicUserInfo=[dicResponse1 valueForKey:@"user"];
               objDatabase = [DataBaseManagement Connetion];
             //  objAppDelegate.AppDicUserInfo=dicUserInfo;
             BOOL setUser_email= [objDatabase UserInfo:[dicUserInfo valueForKey:@"user_email"]];
             
             if (setUser_email==YES)
             {
                 [objDatabase deleteUserInfoData_id:strUserId];
                 [objDatabase addUserInfo:dicUserInfo];

             }
             else
             {
                 [objDatabase addUserInfo:dicUserInfo];
                 
             }
                          
        }
           [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationGetEvents1 object:nil];
         
     }
      failure:^(NSError *error)
     {
     }];
    
}


@end
