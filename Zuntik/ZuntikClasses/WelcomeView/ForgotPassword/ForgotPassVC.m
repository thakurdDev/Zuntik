//
//  ForgotPassVC.m
//  Zuntik
//
//  Created by Dev-Mac on 16/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "ForgotPassVC.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
@interface ForgotPassVC ()

@end

@implementation ForgotPassVC
@synthesize txtUserEmail;
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
    UIColor *color = [UIColor whiteColor];
    self.txtUserEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Email" attributes:@{NSForegroundColorAttributeName: color}];
}
-(IBAction)CloseAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)SubmitAction:(id)sender
{
    NSString *UEmail = [self.txtUserEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!(UEmail.length>0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"You forgot to enter Email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
   else if (![self validateEmail:UEmail])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"Please enter an Email address" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else
    {
        [self MbProcessHud];
        NSDictionary *parameters = @{@"user_email":UEmail,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
        [ZuntikServicesVC PostMethodWithApiMethod:@"forgotPassword.php" Withparms:parameters WithSuccess:^(id response)
         {
             NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
             dicResponse=[response JSONValue];
             NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
              NSString *strMessage=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"message"]];
             
           //  An email has been sent to the account that you specified. Follow its instructions to change your account password
             if ([strSuccess isEqualToString:@"1"]) {
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zuntik" message:@"An email has been sent to the account that you specified. Follow its instructions to change your account password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 [alert show];
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:strMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 [alert show];
             }
         }
         failure:^(NSError *error)
         {
         }];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

        
    }
}
-(void)MbProcessHud
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGRect frame = self.viewSet.frame;
    frame.origin.y =frame.origin.y+150 ;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.viewSet.frame = frame;
    }];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField==self.txtUserEmail)
    {
        
        CGRect frame = self.viewSet.frame;
        frame.origin.y =frame.origin.y-150 ;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.viewSet.frame = frame;
        }];        return ;
    }
    
}
- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
