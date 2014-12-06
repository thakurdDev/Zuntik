//
//  ConfirmationEmailVC.m
//  Zuntik
//
//  Created by Dev-Mac on 31/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "ConfirmationEmailVC.h"
#import "ZuntikServicesVC.h"
#import "MBProgressHUD.h"
#import "JSON.h"
#import "HomeVC.h"
#import "SWRevealViewController.h"
@interface ConfirmationEmailVC ()

@end

@implementation ConfirmationEmailVC

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
  /* Confirmation Email Send-http://www.zuntik.com/API/V1/newConfirmationEmailSend.php
    POST['user_email']
    POST['APIAccount']
    POST['APIPassword']*/
   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    strUserId=[userDefaults valueForKey:@"UserId"];
}
-(IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)SendMailAction:(id)sender
{
    [self MbProcessHud];
    NSDictionary *parameters = @{@"user_email":strUserId,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"newConfirmationEmailSend.php" Withparms:parameters WithSuccess:^(id response)
     {
         UIAlertView *alert;

         NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
         dicResponse=[response JSONValue];
         NSString *stractivate=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
          NSString *strmessage=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"message"]];
         if ([stractivate isEqualToString:@"1"])
         {
             alert = [[UIAlertView alloc] initWithTitle:@"Confirmation Email" message:strmessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
             alert.tag=101;

         }
         else
         {
                alert = [[UIAlertView alloc] initWithTitle:@"Confirmation Email" message:strmessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
             
         }
         [alert show];

         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

     } failure:^(NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alert show];
     }];
}
-(void)MbProcessHud  //MbHud Method(2)
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
   // int i=alertView.tag;
    if (alertView.tag==101)
    {
        SWRevealViewController *revealController = self.revealViewController;
        UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
        if ( ![frontNavigationController.topViewController isKindOfClass:[HomeVC class]] )
        {
            HomeVC *frontViewController = [[HomeVC alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
            [revealController setFrontViewController:navigationController animated:YES];
        }
        
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
