//
//  SubcriptionDetailVC.m
//  Zuntik
//
//  Created by Dev-Mac on 17/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "SubcriptionDetailVC.h"
#import "Reachability.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "CalendarForSearchVC.h"
@interface SubcriptionDetailVC ()

@end

@implementation SubcriptionDetailVC
@synthesize DicSubcriptionDetails;
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
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    app.TypeForSubscribed=@"yes";
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    strUserEmail=[userDefaults valueForKey:@"UserId"];
    strCal_key=[DicSubcriptionDetails valueForKey:@"cal_key"];
    
    [self OnSererTotalEvents];
   
    strCal_key=[DicSubcriptionDetails valueForKey:@"cal_key"];
    lblCal_creator.text=[DicSubcriptionDetails valueForKey:@"cal_creator"];
    lblCal_name.text=[DicSubcriptionDetails valueForKey:@"cal_name"];
    txtDesc.text=[DicSubcriptionDetails valueForKey:@"cal_descrip"];
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    CGSize expectedLabelSize = [[DicSubcriptionDetails valueForKey:@"cal_identifier"] sizeWithFont:lblTags.font constrainedToSize:maximumLabelSize lineBreakMode:lblTags.lineBreakMode];
    CGRect newFrame = lblTags.frame;
    newFrame.size.height = expectedLabelSize.height+15;
    lblTags.frame = newFrame;
    lblTags.text=[DicSubcriptionDetails valueForKey:@"cal_identifier"];
}

-(void)OnSererTotalEvents
{
    [self MbProcessHud];
    NSDictionary *parameters = @{@"cal_key":strCal_key,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"returnNumEvents.php" Withparms:parameters WithSuccess:^(id response)
     {
         
         NSMutableDictionary *  dicResponse=[response JSONValue];
         NSString *strsuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         if ([strsuccess isEqualToString:@"1"])
         {
             
             NSString *strNumEvents = [NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"numEvents"]];
             
             lblEvents.text=strNumEvents;
             
         }
         else
         {
             
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         
     }
    failure:^(NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     }];
    
    
    
}


-(IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)ManageCalendarAction:(id)sender
{
    CalendarForSearchVC *objMycalendarEventVC= [[CalendarForSearchVC alloc]initWithNibName:@"CalendarForSearchVC" bundle:nil];
    objMycalendarEventVC.strCal_key=strCal_key;
    objMycalendarEventVC.strCal_Name=[DicSubcriptionDetails valueForKey:@"cal_name"];
    [self.navigationController pushViewController:objMycalendarEventVC animated:YES];
}
-(IBAction)UnSubcriptionAction:(id)sender;
{
    /* Delete Subscribed Calendars-http://www.zuntik.com/API/V1/deleteUserSub.php
  POST['user_email']
  POST['cal_key']
  POST['APIAccount']
  POST['APIPassword'] */
    [self CheckNetwork];
    
}
-(void)CheckNetwork  //Network Check(3)
{
    Reachability *reachTest = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachTest  currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else
    {
        NSString *strmsg=[NSString stringWithFormat:@"Are you sure that you want to UnSubscibe from Calendar %@",strCal_key ];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UnSubscibe Calendar" message:strmsg delegate:self cancelButtonTitle:@"UnSubscibe" otherButtonTitles:@"Cancel", nil];
         alert.tag = 101;
        [alert show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
   
    if (alertView.tag==101)
    {
    if([title isEqualToString:@"Cancel"])
    {
    }
    else if([title isEqualToString:@"UnSubscibe"])
    {
        [self OnSererUnSubcription];
        
    }
    }
    else if (alertView.tag==102)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)OnSererUnSubcription
{
    [self MbProcessHud];
        NSDictionary *parameters = @{@"user_email":strUserEmail,@"cal_key":strCal_key,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
        [ZuntikServicesVC PostMethodWithApiMethod:@"deleteUserSub.php" Withparms:parameters WithSuccess:^(id response)
         {
             
          NSMutableDictionary *  dicResponse=[response JSONValue];
            NSString *strsuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
             if ([strsuccess isEqualToString:@"1"])
             {
                  NSString *strmsgSuccess=[NSString stringWithFormat:@"You have succesfully been unsubscribed from calendar %@",strCal_key ];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UnSubscibe Calendar" message:strmsgSuccess delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                  alert.tag=102;
                 [alert show];
                 
             }
             else
             {
                 
                 
                 
             }
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

             
         }
           failure:^(NSError *error)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

         }];
        


}
-(void)MbProcessHud
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
