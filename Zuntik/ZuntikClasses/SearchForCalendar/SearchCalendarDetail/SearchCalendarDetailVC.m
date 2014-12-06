//
//  SearchCalendarDetailVC.m
//  Zuntik
//
//  Created by Dev-Mac on 16/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "SearchCalendarDetailVC.h"
#import "Reachability.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "MySucriptionVC.h"
#import "SWRevealViewController.h"
#import "CalendarForSearchVC.h"
#import "CheckLoginView.h"
@interface SearchCalendarDetailVC ()
@property (strong, nonatomic) IBOutlet UIView *viewTransParant;
@property (strong, nonatomic) IBOutlet UIView *viewAlert;
@property (weak, nonatomic) IBOutlet UIView *viewSubscribe;
@property (weak, nonatomic) IBOutlet UIView *viewForAdvancedError;
@property (weak, nonatomic) IBOutlet UILabel *lblAdvanceAlertmessage;
- (IBAction)subscribeAction:(id)sender;
- (IBAction)cancelAction:(id)sender;

- (IBAction)loginAction:(id)sender;

@end

@implementation SearchCalendarDetailVC
@synthesize DicSeachDetails,strCheckView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//http://www.zuntik.com/API/V1/returnNumEvents.php
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    objAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    objAppDelegate.Cal_name=[NSString stringWithFormat:@"%@",[DicSeachDetails objectForKey:@"cal_name"]];
    
    objAppDelegate.TypeForSubscribed=@"no";
    
    self.viewSubscribe.hidden=YES;
    self.viewAlert.hidden=YES;
    self.viewTransParant.hidden=YES;
    self.viewForAdvancedError.hidden=YES;
    [self.view addSubview:self.viewTransParant];
    
    
    // Do any additional setup after loading the view from its nib.

    strCal_key=[DicSeachDetails valueForKey:@"cal_key"];

    [self OnSererTotalEvents];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    strUserEmail=[userDefaults valueForKey:@"UserId"];
    lblCal_creator.text=[DicSeachDetails valueForKey:@"cal_creator"];
    lblCal_name.text=[DicSeachDetails valueForKey:@"cal_name"];
    txtDesc.text=[DicSeachDetails valueForKey:@"cal_descrip"];
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    CGSize expectedLabelSize = [[DicSeachDetails valueForKey:@"cal_identifier"] sizeWithFont:lblTags.font constrainedToSize:maximumLabelSize lineBreakMode:lblTags.lineBreakMode];
    CGRect newFrame = lblTags.frame;
    newFrame.size.height = expectedLabelSize.height+15;
    lblTags.frame = newFrame;
    lblTags.text=[DicSeachDetails valueForKey:@"cal_identifier"];

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
-(IBAction)UnSubcriptionAction:(id)sender;
{
    if ([strCheckView isEqualToString:@"LoginSearchView"])
    {
        CheckLoginView *objCheckLoginView=[[CheckLoginView alloc]initWithNibName:@"CheckLoginView" bundle:nil];
        [self.navigationController pushViewController:objCheckLoginView animated:YES];
    }
    else
    {
         [self CheckNetwork];
    }
    
   
    
}
-(IBAction)ManageCalendarAction:(id)sender
{
    if ([objAppDelegate.type_cal isEqualToString:@"2"])
    {
        _lblAdvanceAlertmessage.text=@"You can only view advanced course calendar events after you have subscribed to them from the web platform.";
        self.viewForAdvancedError.transform = CGAffineTransformMakeScale(0, 0);
        self.viewForAdvancedError.hidden= NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.viewForAdvancedError.transform = CGAffineTransformIdentity;
            self.viewForAdvancedError.hidden = NO;
            self.viewTransParant.hidden=NO;
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        CalendarForSearchVC *objMycalendarEventVC= [[CalendarForSearchVC alloc]initWithNibName:@"CalendarForSearchVC" bundle:nil];
        objMycalendarEventVC.strCal_key=strCal_key;
        objMycalendarEventVC.strCal_Name=[DicSeachDetails valueForKey:@"cal_name"];
        [self.navigationController pushViewController:objMycalendarEventVC animated:YES];
    }
}
-(void)CheckNetwork
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
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if ([defaults boolForKey:@"isLogedIn"]==YES)
        {
            if ([objAppDelegate.type_cal isEqualToString:@"2"])
            {
                _lblAdvanceAlertmessage.text=@"Advanced Course Calendars can only be subscribed to from the Zuntik web app. After you have subscribed to this calendar from the Zuntik website the events from your new subscription will appear on the homepage of the app.";
                self.viewForAdvancedError.transform = CGAffineTransformMakeScale(0, 0);
                self.viewForAdvancedError.hidden= NO;
                [UIView animateWithDuration:0.5 animations:^{
                    self.viewForAdvancedError.transform = CGAffineTransformIdentity;
                    self.viewForAdvancedError.hidden = NO;
                    self.viewTransParant.hidden=NO;
                } completion:^(BOOL finished) {
                }];
            }
            else
            {
                self.viewSubscribe.transform = CGAffineTransformMakeScale(0, 0);
                self.viewSubscribe.hidden= NO;
                [UIView animateWithDuration:0.5 animations:^{
                    self.viewSubscribe.transform = CGAffineTransformIdentity;
                    self.viewTransParant.hidden = NO;
                    self.viewTransParant.hidden=NO;
                } completion:^(BOOL finished) {
                }];
            }
        }
        else
        {
            self.viewAlert.transform = CGAffineTransformMakeScale(0, 0);
            self.viewAlert.hidden= NO;
            [UIView animateWithDuration:0.5 animations:^{
                self.viewAlert.transform = CGAffineTransformIdentity;
                self.viewTransParant.hidden = NO;
                self.viewTransParant.hidden=NO;
            } completion:^(BOOL finished) {
            }];
            
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==102)
    {
       // MySucriptionVC *objMySucriptionVC=[[MySucriptionVC alloc]initWithNibName:@"MySucriptionVC" bundle:nil];
      //  [self.navigationController popToViewController:objMySucriptionVC animated:YES];
       // [self.navigationController popViewControllerAnimated:YES];
        
        SWRevealViewController *revealController = self.revealViewController;
        
        UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
       
        
        
        if ( ![frontNavigationController.topViewController isKindOfClass:[MySucriptionVC class]] )
        {
            MySucriptionVC *frontViewController = [[MySucriptionVC alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
            [revealController setFrontViewController:navigationController animated:YES];
        }


    }

}

-(void)OnSererSubcription
{
    [self MbProcessHud];
    NSDictionary *parameters = @{@"user_email":strUserEmail,@"cal_key":strCal_key,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"subscribeUser.php" Withparms:parameters WithSuccess:^(id response)
     {
         
         NSMutableDictionary *  dicResponse=[response JSONValue];
         NSString *strsuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         if ([strsuccess isEqualToString:@"1"])
         {
             id strmessage = [NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"message"]];
             UIAlertView *alert;
             if (![strmessage isEqualToString:@"(null)"])
             {
       
             alert = [[UIAlertView alloc] initWithTitle:@"Subscibe Calendar" message:strmessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
             
             }
             else
             {
                 NSString *strmsgSuccess=[NSString stringWithFormat:@"You have successfully been subscribed to calendar %@",strCal_key ];
                 alert = [[UIAlertView alloc] initWithTitle:@"Success" message:strmsgSuccess delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 alert.tag=102;

             }
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
- (IBAction)subscribeAction:(id)sender
{
    
    [self OnSererSubcription];
}

- (IBAction)cancelAction:(id)sender
{
    _viewTransParant.hidden=YES;
}

- (IBAction)loginAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
