//
//  LoginVC.m
//  Zuntik
//
//  Created by Dev-Mac on 05/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "LoginVC.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "ServicesCallVC.h"
#import "ForgotPassVC.h"
#import "HomeVC.h"
#import "RearViewController.h"
#import "RightViewController.h"
#import "SWRevealViewController.h"
#import "Reachability.h"
#import "DataBaseManagement.h"
@interface LoginVC ()<SWRevealViewControllerDelegate>
{
    NSInteger tapon;
}
@property (strong, nonatomic) IBOutlet UILabel *lblTermsMessagfe;
@property (strong, nonatomic) IBOutlet UILabel *lblAlertTitle;
@end

@implementation LoginVC

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
    
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(ontaplbl:)];
    singleTap.numberOfTapsRequired = 1;
    self.lblTermsMessagfe.userInteractionEnabled=YES;
    [self.lblTermsMessagfe addGestureRecognizer:singleTap];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
    UIColor *color = [UIColor whiteColor];
    self.txtUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
     self.txtPassWord.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
 

}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.txtUserName resignFirstResponder];
    [self.txtPassWord resignFirstResponder];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    self.txtUserName.text=@"";
    self.txtPassWord .text=@"";
}

#pragma Textfiled Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.objScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
	if (textField == self.txtUserName)
		[self.txtPassWord becomeFirstResponder];
  	else
		[textField resignFirstResponder], _activeField = nil;
	
	return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+80) animated:YES];
}
#pragma Button Method
-(IBAction)ForgotPassAction:(id)sender
{
    ForgotPassVC *objForgotPassVC=[[ForgotPassVC  alloc]initWithNibName:@"ForgotPassVC" bundle:nil];
    [self.navigationController pushViewController:objForgotPassVC animated:YES];
}

-(IBAction)CloseAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)TermsAction:(id)sender
{
    tapon=1;
    _lblAlertTitle.text=@"Terms and Use";
    
    NSString * htmlString = @"When using the Zuntik mobile application users agree to all of the agreements found within the official Zuntik Terms And Use Agreement which can be found <a href=\"http://www.zuntik.com/page-TermsAndUse.php\">here</a>";
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _lblTermsMessagfe.attributedText = attrStr;
    _lblTermsMessagfe.attributedText = attrStr;
    _lblTermsMessagfe.textAlignment=NSTextAlignmentCenter;
    _lblTermsMessagfe.textColor=[UIColor whiteColor];
    _lblTermsMessagfe.font=[UIFont systemFontOfSize:13.0];
    
    
    [self ShowAlertView];
}
-(IBAction)PrivacyAction:(id)sender
{
    tapon=2;
    NSString * htmlString = @"When using the Zuntik mobile application users agree to and accept all of the Zuntik policies found within the official Zuntik Privacy Policy Agreement which can be found <a href=\"http://www.zuntik.com/page-PrivacyPolicy.php\">here</a>";
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _lblTermsMessagfe.attributedText = attrStr;
    _lblTermsMessagfe.textColor=[UIColor whiteColor];
    _lblTermsMessagfe.textAlignment=NSTextAlignmentCenter;
    _lblTermsMessagfe.font=[UIFont systemFontOfSize:13.0];
    
    _lblAlertTitle.text=@"Privacy Policy";
    [self ShowAlertView];
}
-(void)ontaplbl:(UITapGestureRecognizer *)gesture
{
    
    if (tapon==1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.zuntik.com/page-TermsAndUse.php"]];
        
    }
    else if (tapon==2)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.zuntik.com/page-PrivacyPolicy.php"]];
        
    }
}
-(IBAction)Done_TerPriAction:(id)sender
{
    self.viewBlackTransperent.hidden = YES;

}

-(void)ShowAlertView
{
    self.viewAlert.transform = CGAffineTransformMakeScale(0, 0);
    self.viewAlert.hidden= NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.viewAlert.transform = CGAffineTransformIdentity;
        self.viewBlackTransperent.hidden = NO;
        [self.view addSubview:self.viewBlackTransperent];
        
    } completion:^(BOOL finished) {
    }];
}
-(IBAction)LoginAction:(id)sender
{

     NSString *msg;
     UEmail = [self.txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    UPassword = [self.txtPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (UEmail.length<1)
    {
        msg=@"You forgot to enter your email address ";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else if (![self validateEmail:UEmail] )
    {
          msg=@"Please enter an Email address";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else if(!(UPassword.length>5))
    {
        msg=@"The password sent was too short";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    [self CheckNetwork];
    
}

-(void)CheckNetwork
{
    Reachability *reachTest = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachTest  currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
     
        [self OnDatabaseLogin];//CallLocalDatabase Value
        
    }
    else
    {
        [self OnServerLogin];
        //Call Server Value */ //Api call
    }
    
}
#pragma CallLocalDatabase Value
-(void)OnDatabaseLogin
{
    DataBaseManagement *objDatabase = [DataBaseManagement Connetion];//Database Connection
    BOOL UserAvailabel= [objDatabase getUserLoginID:UEmail Password:UPassword];
}
#pragma Call Server Value */ //Api call
-(void)OnServerLogin
{
     [self MbProcessHud];//ProcessHud
    NSDictionary *parameters = @{@"user_email":UEmail,@"password":UPassword,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"verifyLogin.php" Withparms:parameters WithSuccess:^(id response)
     {
         NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
         dicResponse=[response JSONValue];
         NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         
         if ([strSuccess isEqualToString:@"0"]) {
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:[dicResponse valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
             [alert show];
         }
         else
         {
             
             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
             [userDefaults setValue:UEmail forKey:@"UserId"];
             [userDefaults setBool:YES forKey:@"isLogedIn"];
             [userDefaults synchronize];
             [self HomeViewShow];
             
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

         
     } failure:^(NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alert show];
     }];

}
-(void)HomeViewShow
{
    HomeVC *frontViewController=[[HomeVC alloc]init];
    RearViewController *rearViewController = [[RearViewController alloc] init];
    frontViewController.strCheckView=@"LoginView";
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
-(void)MbProcessHud
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
}
- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.objScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] != self.viewAlert)
    {
        self.viewBlackTransperent.hidden=YES;
    }
    [super touchesBegan:touches withEvent:event];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
