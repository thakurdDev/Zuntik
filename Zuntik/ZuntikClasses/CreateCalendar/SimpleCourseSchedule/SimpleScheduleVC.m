//
//  SimpleScheduleVC.m
//  Zuntik
//
//  Created by Dev-Mac on 18/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "SimpleScheduleVC.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "SWRevealViewController.h"
#import "MyCalendarVC.h"
@interface SimpleScheduleVC ()
@property (weak, nonatomic) IBOutlet UILabel *lblTopHeader;
@property (weak, nonatomic) IBOutlet UIButton *buttonCreate_Edit;

@end

@implementation SimpleScheduleVC
@synthesize txtN_Class,txtN_Professor,txtClass_Number,txtDiscussion,txtCal_Tags;
@synthesize txtCal_Desc;
@synthesize objScrollView;
@synthesize lblPlaceHolderSet;
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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    strUserId=[userDefaults valueForKey:@"UserId"];
    self.viewBlackTransperent.hidden = YES;
    self.viewBlackTransperentKey.hidden = YES;
    txtCal_Desc.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"EventDescriptionImgBox.png"]];
    
    if (_editCalDicDetails.count<2)
    {
        [_buttonCreate_Edit setTitle:@"Create New Calendar" forState:UIControlStateNormal];
         _lblTopHeader.text=@"New Calendar";
         lblPlaceHolderSet.hidden=NO;
         [self setPlaceHoldarColor];
    }
    else
    {
        
        NSString *Classinfo=[NSString stringWithFormat:@"%@",[_editCalDicDetails objectForKey:@"class_info"]];
        if ([Classinfo isEqual:NULL])
        {
            
        }
        else
        {
            NSArray *temp= [Classinfo componentsSeparatedByString:@"-%-"];
            
            if (temp.count>0)
            {
                txtN_Professor.text=[temp objectAtIndex:0];
                txtClass_Number.text=[temp objectAtIndex:1];
                txtDiscussion.text=[temp objectAtIndex:2];
            }
        }
        
        strPrivateKey=@"0";
        strConfirmPrivateKey=@"0";
        [_buttonCreate_Edit setTitle:@"Edit Calendar" forState:UIControlStateNormal];
        [self setPlashholderWhenEdit];
         _lblTopHeader.text=@"Edit Calendar";
        lblPlaceHolderSet.hidden=YES;
        txtN_Class.text=[_editCalDicDetails objectForKey:@"cal_name"];
        txtCal_Desc.text=[_editCalDicDetails objectForKey:@"cal_descrip"];
        txtCal_Tags.text=[_editCalDicDetails objectForKey:@"cal_identifier"];
    }
    // Do any additional setup after loading the view from its nib.
 
   
}
-(void)setPlashholderWhenEdit
{
    UIColor *color = [UIColor whiteColor];
    txtN_Professor.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name of Professor" attributes:@{NSForegroundColorAttributeName: color}];
    txtClass_Number.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Class Number(If Available)" attributes:@{NSForegroundColorAttributeName: color}];
    txtDiscussion.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Discussion Number(If Available)" attributes:@{NSForegroundColorAttributeName: color}];
    txtPrivateKey.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" * Private Key" attributes:@{NSForegroundColorAttributeName: color}];
    txtConfirmPrivateKey.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" * Confirm Private Key" attributes:@{NSForegroundColorAttributeName: color}];
}
-(void)setPlaceHoldarColor
{
    UIColor *color = [UIColor whiteColor];
    txtN_Class.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name of Class" attributes:@{NSForegroundColorAttributeName: color}];
     txtN_Professor.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name of Professor" attributes:@{NSForegroundColorAttributeName: color}];
     txtClass_Number.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Class Number(If Available)" attributes:@{NSForegroundColorAttributeName: color}];
     txtDiscussion.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Discussion Number(If Available)" attributes:@{NSForegroundColorAttributeName: color}];
     txtCal_Tags.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Calendar Tags" attributes:@{NSForegroundColorAttributeName: color}];
    txtPrivateKey.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" * Private Key" attributes:@{NSForegroundColorAttributeName: color}];
    txtConfirmPrivateKey.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" * Confirm Private Key" attributes:@{NSForegroundColorAttributeName: color}];
    
}
-(IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)CreateNewCalendarAction:(id)sender
{
   strN_Class = [self.txtN_Class.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strN_Professor = [self.txtN_Professor.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strClass_Number =[self.txtClass_Number.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strDiscussion = [self.txtDiscussion.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
    strCal_Tags = [self.txtCal_Tags.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strCal_Desc = [self.txtCal_Desc.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (!(strN_Class.length > 0) || (strN_Class.length > 100))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"Enter Name Of Class" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else if(!(strN_Professor.length>0) || (strN_Professor.length>36))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"Enter Name Of Professor" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }

    else if(!(strCal_Tags.length>0) || (strCal_Tags.length>40))
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
    if((strClass_Number.length>5))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"Enter 5 digit length" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    if (strClass_Number.length <1)
    {
        strClass_Number=@"0";
        
    }else{
        strClass_Number =[self.txtClass_Number.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    if((strDiscussion.length>5))
    {
   
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"Enter 5 digit length" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
       
    }
    if (strDiscussion.length <1)
    {
        strDiscussion=@"0";
        
    }else
    {
        strDiscussion =[self.txtDiscussion.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    if (_editCalDicDetails.count<2)
    {
        [self ShowAlertView];
    }
    else
    {
        [self WebserVisecMethod];
    }

  
    
}
-(void)ShowAlertView
{
    [self.objScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [txtCal_Tags resignFirstResponder];
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
    [self WebserVisecMethod];
    
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your public key is not longer than 4 characters" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    else if(![strConfirmPrivateKey isEqualToString:strPrivateKey])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your public keys do not match, please try again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    [self WebserVisecMethod];
    
}
-(void)WebserVisecMethod
{
    [self MbProcessHud];
    NSString *Web_url;
    NSDictionary *parameters;
    if ([objAppDelegate.type_cal isEqualToString:@"edit"])
    {
        Web_url=@"editCalendar.php";
         parameters = @{@"user_email":strUserId,@"cal_key":[_editCalDicDetails objectForKey:@"cal_key"],@"cal_name":strN_Class,@"cal_identifier":strCal_Tags,@"cal_descrip":strCal_Desc,@"cal_type":@"1",@"private_key":strPrivateKey,@"cal_creator":strUserId,@"disc_num":strDiscussion,@"class_num":strClass_Number,@"prof_name":strN_Professor,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    }
    else
    {
        Web_url=@"createCalendar.php";
         parameters = @{@"cal_name":strN_Class,@"cal_identifier":strCal_Tags,@"cal_descrip":strCal_Desc,@"cal_type":@"1",@"private_key":strPrivateKey,@"cal_creator":strUserId,@"disc_num":strDiscussion,@"class_num":strClass_Number,@"prof_name":strN_Professor,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    }
   
    [ZuntikServicesVC PostMethodWithApiMethod:Web_url Withparms:parameters WithSuccess:^(id response)
     {
         UIAlertView *alert;
         NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
         dicResponse=[response JSONValue];
         NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         NSString *strMassage=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"message"]];
         
         if ([objAppDelegate.type_cal isEqualToString:@"edit"])
         {
             if ([strSuccess isEqualToString:@"1"])
             {
                 alert = [[UIAlertView alloc] initWithTitle:@"Edited Calendar" message:strMassage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 alert.tag=102;
                 
             }
             else
             {
                 alert = [[UIAlertView alloc] initWithTitle:@"Edited Calendar" message:strMassage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 
             }
             [alert show];
         }
         else
         {
             if ([strSuccess isEqualToString:@"1"])
             {
                 alert = [[UIAlertView alloc] initWithTitle:@"Created Calendar" message:strMassage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 alert.tag=102;
                 
             }
             else
             {
                 alert = [[UIAlertView alloc] initWithTitle:@"Created Calendar" message:strMassage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 
             }
             [alert show];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

     }
       failure:^(NSError *error)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"The Internet connection appears to be offline." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
#pragma Textfiled Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.objScrollView setContentOffset:CGPointMake(0,0) animated:YES];

    if (textField==txtPrivateKey)
    {
        [txtConfirmPrivateKey becomeFirstResponder];

    }else
    {
        [txtConfirmPrivateKey resignFirstResponder];

    }
    
     [textField resignFirstResponder];
    
    return YES;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == txtDiscussion) {
        
       // [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+50) animated:YES];
        
    }
   else if (textField == txtCal_Tags) {
        
        [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+50) animated:YES];
        
    }
  
}
#pragma mark TextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if(txtCal_Desc.text.length==0)
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
        if(txtCal_Desc.text.length == 0)
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
   [self.objScrollView setContentOffset:CGPointMake(0,textView.center.y+70) animated:YES];
    return YES;

}

- (void)keyboardWillShow:(NSNotification *)notification {
    // create custom buttom
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 163, 106, 53);
    doneButton.adjustsImageWhenHighlighted = NO;
    [doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
    [doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchUpInside];
    
    // locate keyboard view
    UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView *keyboard;
    for (int i = 0; i < [tempWindow.subviews count]; i++) {
        keyboard = [tempWindow.subviews objectAtIndex:i];
        // keyboard view found; add the custom button to it
        if ([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES) {
            [keyboard addSubview:doneButton];
        }
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] != _viewAlert)
    {
        self.viewBlackTransperent.hidden=YES;
    }
    if ([touch view] != _viewAlertKey)
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
