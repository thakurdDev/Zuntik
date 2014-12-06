//
//  CreateCalendarVC.m
//  Zuntik
//
//  Created by Dev-Mac on 07/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "CreateCalendarVC.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "MyCalendarVC.h"
@interface CreateCalendarVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblTopHeader;
@property (weak, nonatomic) IBOutlet UIButton *buttonCrateEdit;

@end

@implementation CreateCalendarVC
@synthesize objScrollView;
@synthesize viewAlert,viewBlackTransperent;
@synthesize viewAlertKey,viewBlackTransperentKey,lblPlaceHolderSet;
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
    
    txtDescription.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"EventDescriptionImgBox.png"]];
    self.navigationController.navigationBarHidden=YES;
    self.viewBlackTransperent.hidden = YES;
    self.viewBlackTransperentKey.hidden = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    strUserId=[userDefaults valueForKey:@"UserId"];
    // Do any additional setup after loading the view from its nib.
    if (_editCalDicDetails.count<2)
    {
        [_buttonCrateEdit setTitle:@"Create New Calendar" forState:UIControlStateNormal];
        _lblTopHeader.text=@"New Calendar";
         lblPlaceHolderSet.hidden=NO;
        [self setPlaceHoldarColor];
    }
    else
    {
        strPrivateKey=@"0";
        strConfirmPrivateKey=@"0";
        [_buttonCrateEdit setTitle:@"Edit Calendar" forState:UIControlStateNormal];
         _lblTopHeader.text=@"Edit Calendar";
         lblPlaceHolderSet.hidden=YES;
        txtCalendarName.text=[_editCalDicDetails objectForKey:@"cal_name"];
        txtDescription.text=[_editCalDicDetails objectForKey:@"cal_descrip"];
        txtCal_Tag.text=[_editCalDicDetails objectForKey:@"cal_identifier"];
    }
}
-(void)setPlaceHoldarColor
{
    UIColor *color = [UIColor whiteColor];
    txtCalendarName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name Of Calendar" attributes:@{NSForegroundColorAttributeName: color}];
    txtCal_Tag.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Calendar Tag" attributes:@{NSForegroundColorAttributeName: color}];
    txtPrivateKey.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"* Private Key" attributes:@{NSForegroundColorAttributeName: color}];
    txtConfirmPrivateKey.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"* Confirm Private Key" attributes:@{NSForegroundColorAttributeName: color}];
}
-(IBAction)CreateNewCalendarAction:(id)sender
{
    strC_Name = [txtCalendarName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strCal_Tag = [txtCal_Tag.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strCal_Desc = [txtDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!(strC_Name.length > 0) || (strC_Name.length > 100))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"Enter Name Of Calendar" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    
    else if(!(strCal_Tag.length>0) || (strCal_Tag.length>40))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"Enter Calendar Tags" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    else if(!(strCal_Desc.length>0) || (strCal_Desc.length>1500))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"Enter Calendar Description" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    if (_editCalDicDetails.count<2)
    {
         [self ShowAlertView];
    }
    else
    {
         [self WebservisecCall];
    }
   
  
}
-(void)ShowAlertView
{
    [self.objScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [txtCal_Tag resignFirstResponder];
    self.viewAlert.transform = CGAffineTransformMakeScale(0, 0);
    self.viewAlert.hidden= NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.viewAlert.transform = CGAffineTransformIdentity;
        self.viewBlackTransperent.hidden = NO;
        [self.view addSubview: self.viewBlackTransperent];

    } completion:^(BOOL finished) {
    }];
}
-(IBAction)CalendarPublicAction:(id)sender
{
    strPrivateKey=@"0";
    strConfirmPrivateKey=@"0";
    [self WebservisecCall];

}


-(IBAction)CalendarPrivateAction:(id)sender
{
    self.viewAlertKey.transform = CGAffineTransformMakeScale(0, 0);
    self.viewAlertKey.hidden= NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.viewAlertKey.transform = CGAffineTransformIdentity;
        self.viewBlackTransperent.hidden = YES;
         self.viewBlackTransperentKey.hidden = NO;
        [self.view addSubview:self.viewBlackTransperentKey];

        
    } completion:^(BOOL finished) {
    }];
}
-(IBAction)ContinuePrivateAction:(id)sender
{
    strPrivateKey = [txtPrivateKey.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strConfirmPrivateKey = [txtConfirmPrivateKey.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!(strPrivateKey.length > 3) || (strPrivateKey.length > 20))
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"Your public key is not longer than 4 characters" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    else if(![strConfirmPrivateKey isEqualToString:strPrivateKey])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"Your public keys do not match, please try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
       
        return;
    }
    [self WebservisecCall];
    
}
-(void)WebservisecCall
{
    [self MbProcessHud];
    NSString *AlertTitle;
    NSString *Web_url;
    NSDictionary *parameters;
    if ([objAppDelegate.type_cal isEqualToString:@"edit"])
    {
        AlertTitle=@"Edited Calendar";
        Web_url=@"editCalendar.php";
         parameters = @{@"user_email":strUserId,@"cal_key":[_editCalDicDetails objectForKey:@"cal_key"],@"cal_name":strC_Name,@"cal_identifier":strCal_Tag,@"cal_descrip":strCal_Desc,@"cal_type":@"0",@"private_key":strPrivateKey,@"cal_creator":strUserId,@"disc_num":@"0",@"class_num":@"0",@"prof_name":@"0",@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    }
    else
    {
        AlertTitle=@"Created Calendar";
        Web_url=@"createCalendar.php";
         parameters = @{@"cal_name":strC_Name,@"cal_identifier":strCal_Tag,@"cal_descrip":strCal_Desc,@"cal_type":@"0",@"private_key":strPrivateKey,@"cal_creator":strUserId,@"disc_num":@"0",@"class_num":@"0",@"prof_name":@"0",@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    }
    [ZuntikServicesVC PostMethodWithApiMethod:Web_url Withparms:parameters WithSuccess:^(id response)
     {
         UIAlertView *alert;
         NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
         dicResponse=[response JSONValue];
         NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         NSString *strMassage=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"message"]];
         if ([strSuccess isEqualToString:@"1"])
         {
              alert = [[UIAlertView alloc] initWithTitle:AlertTitle message:strMassage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
             alert.tag=102;
             
         }
         else
         {
             alert = [[UIAlertView alloc] initWithTitle:AlertTitle message:strMassage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        }
         [alert show];

         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     }
     failure:^(NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:AlertTitle message:@"The Internet connection appears to be offline." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     }];
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==102)
    {
        SWRevealViewController *revealController = self.revealViewController;
        UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
        if ( ![frontNavigationController.topViewController isKindOfClass:[MyCalendarVC class]] )
        {
            MyCalendarVC *frontViewController = [[MyCalendarVC alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
            [revealController setFrontViewController:navigationController animated:YES];
        }
        
        
    }
}

-(void)MbProcessHud  //MbHud Method
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
    
}
-(IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Textfiled Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.objScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [textField resignFirstResponder];
    
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   
	 if (textField == txtCal_Tag) {
         
        [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+20) animated:YES];

    }

}
#pragma mark TextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if(txtDescription.text.length==0)
    {
        self.lblPlaceHolderSet.hidden = NO;
    }
    else
    {
        self.lblPlaceHolderSet.hidden = YES;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        if(txtDescription.text.length == 0)
        {
            self.lblPlaceHolderSet.hidden = NO;
        }
        else
        {
            self.lblPlaceHolderSet.hidden = YES;
        }
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    lblPlaceHolderSet.hidden = YES;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.objScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] != viewAlert)
    {
        self.viewBlackTransperent.hidden=YES;
    }
    if ([touch view] != viewAlertKey)
    {
        self.viewBlackTransperentKey.hidden=YES;
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
