//
//  CreateAccount.m
//  Zuntik
//
//  Created by Dev-Mac on 05/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "CreateAccount.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "SimpleTableCell.h"
#import "HomeVC.h"
#import "RearViewController.h"
#import "RightViewController.h"
#import "SWRevealViewController.h"
@interface CreateAccount ()<SWRevealViewControllerDelegate>
{
    NSInteger tapon;
}
@property (weak, nonatomic) IBOutlet UILabel *lblAlertTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTermsMessagfe;

@end

@implementation CreateAccount

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
    /*http://www.zuntik.com/API/V1/getCities.php*/
    // Connect data
     self.viewBlackTransperent.hidden = YES;
    [self setPlaceHoldarColor];
    [self CallCityAPI];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    self.txtUserName.text=@"";
    self.txtLastName.text=@"";
    self.txtEmail.text=@"";
    self.txtPassWord.text=@"";
    self.txtConformPass.text=@"";
    self.txtCity.text=@"";
    
}
-(void)setPlaceHoldarColor
{
    UIColor *color = [UIColor whiteColor];
    self.txtUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtLastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    self.txtPassWord.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
     self.txtConformPass.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: color}];
     self.txtCity.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Select Your City" attributes:@{NSForegroundColorAttributeName: color}];
}
-(void)CallCityAPI
{
    NSDictionary *parameters = @{@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"getCities.php" Withparms:parameters WithSuccess:^(id response)
     {
         arrResponse=[[NSMutableArray alloc]init];
         arrResponse=[response JSONValue];
         
         NSMutableDictionary *dicExtraValue=[[NSMutableDictionary alloc]init];
         [dicExtraValue setObject:@"None of the above" forKey:@"city_name"];
         [dicExtraValue setObject:@"0" forKey:@"city_num"];
         [arrResponse addObject:dicExtraValue];
         [_objTbl reloadData];
         
     } failure:^(NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alert show];
     }];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [self.txtUserName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPassWord resignFirstResponder];
 
}
#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrResponse count];
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
    cell.lblSearchName.text=[[arrResponse objectAtIndex:indexPath.row]valueForKey:@"city_name"];
    cell.btnDetailShow.hidden=YES;
    cell.lblSearchDetail.hidden=YES;
    cell.lblcreate.hidden=YES;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.objScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    self.txtCity.text=[[arrResponse objectAtIndex:indexPath.row]valueForKey:@"city_name"];
    strcity_num=[[arrResponse objectAtIndex:indexPath.row]valueForKey:@"city_num"];
    self.viewBlackTransperent.hidden=YES;
}
#pragma Button Method
-(IBAction)CreateAccAction:(id)sender
{
    NSString *msg;
    NSString *UEmail = [self.txtEmail.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *UUsername=[self.txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     NSString *ULastName=[self.txtLastName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *UPassword = [self.txtPassWord.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(![self validateString:UUsername])
    {
        msg=@"You forgot to enter First Name";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else if (![self validateString:ULastName])
    {
        msg=@"You forgot to enter Last Name";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else if (!(UEmail.length>0))
    {
        msg=@"You forgot to enter Email";
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
        msg=@" The password sent was too short";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else if(!([UPassword isEqualToString:self.txtConformPass.text]))
    {
        msg=@"You forgot to enter confirm password";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else if(!(self.txtCity.text.length>5))
    {
        msg=@" You forgot to enter your City";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else
    {
        [self MbProcessHud];
        
        //Send data to server for Create Acc.
        NSDictionary *parameters = @{@"user_email":UEmail,@"first_name":UUsername,@"last_name":ULastName,@"password":UPassword,@"city_num":strcity_num,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
        [ZuntikServicesVC PostMethodWithApiMethod:@"createUser.php" Withparms:parameters WithSuccess:^(id response)
         {
             NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
             dicResponse=[response JSONValue];
             NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
             
             if ([strSuccess isEqualToString:@"0"])
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:[dicResponse valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 [alert show];
             }
             else
             {
                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                 [userDefaults setValue:UEmail forKey:@"UserId"];
                 [userDefaults setBool:YES forKey:@"isLogedIn"];
                 [userDefaults synchronize];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zuntik" message:@"Congratulations your Account has been created" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 alert.tag=101;
                 [alert show];
             }
             
         } failure:^(NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

         }];
        
    }

}
-(void)MbProcessHud
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
     if (alertView.tag==101)
    {
        [self HomeViewShow];
    }
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
    
    
    [self ShowAlertViewTermsAndPrivvacy];
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
    [self ShowAlertViewTermsAndPrivvacy];
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
    self.viewBlackTransperentTerm.hidden = YES;
    
}

-(void)ShowAlertViewTerm
{
    self.viewAlertTerm.transform = CGAffineTransformMakeScale(0, 0);
    self.viewAlertTerm.hidden= NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.viewAlertTerm.transform = CGAffineTransformIdentity;
        self.viewBlackTransperentTerm.hidden = NO;
        [self.view addSubview:self.viewBlackTransperentTerm];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

-(BOOL) validateString: (NSString *) string
{
    NSString *abnRegex = @"[A-Za-z]+"; // check for one or more occurrence of string you can also use * instead + for ignoring null value
    NSPredicate *abnTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", abnRegex];
    BOOL isValid = [abnTest evaluateWithObject:string];
    return isValid;
}



#pragma Textfiled Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.objScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
//	if (textField == self.txtUserName)
//		[self.txtLastName becomeFirstResponder];
//    else if (textField == self.txtLastName)
//		[self.txtEmail becomeFirstResponder];
//    else if (textField == self.txtEmail)
//		[self.txtPassWord becomeFirstResponder];
//    else if(textField == self.txtPassWord)
//    {
//        [self.txtConformPass becomeFirstResponder];
//    }
//    else if(textField == self.txtConformPass)
//    {
//        [self.txtConformPass resignFirstResponder];
//    }
//    else
//        [textField resignFirstResponder], _activeField = nil;
	
	return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==self.txtCity)
    { [textField resignFirstResponder];

        [self ShowAlertView];
    }
    if (textField==self.txtPassWord)
    {
        
        [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+50) animated:YES];
        return ;
    }
   else if (textField==self.txtConformPass)
   {
       
       [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+50) animated:YES];
       return ;
   }
  
}
-(void)ShowAlertViewTermsAndPrivvacy
{
    self.viewAlertTerm.transform = CGAffineTransformMakeScale(0, 0);
    self.viewAlertTerm.hidden= NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.viewAlertTerm.transform = CGAffineTransformIdentity;
        self.viewBlackTransperentTerm.hidden = NO;
        [self.view addSubview:self.viewBlackTransperentTerm];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)ShowAlertView
{
    [self.txtCity resignFirstResponder];
    self.viewList.transform = CGAffineTransformMakeScale(0, 0);
    self.viewList.hidden= NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.viewList.transform = CGAffineTransformIdentity;
        self.viewBlackTransperent.hidden = NO;
        [self.view addSubview:self.viewBlackTransperent];
        } completion:^(BOOL finished) {
            
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  //  [self.objScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] != self.viewList)
    {
        self.viewBlackTransperent.hidden=YES;
    }
    if ([touch view] != self.viewAlertTerm)
    {
        self.viewBlackTransperentTerm.hidden=YES;
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
