//
//  CalendarDetailVc.m
//  Zuntik
//
//  Created by Dev-Mac on 17/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "CalendarDetailVc.h"
#import "Reachability.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "MycalendarEventVC.h"
#import "CreateCalendarVC.h"
#import "SimpleScheduleVC.h"
@interface CalendarDetailVc ()
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;
@property (strong, nonatomic) IBOutlet UIView *viewTrans;
@property (weak, nonatomic) IBOutlet UIView *viewAdvanceError;
@property (weak, nonatomic) IBOutlet UIView *viewDeleteCal;
- (IBAction)OkAction:(id)sender;
- (IBAction)YesAction:(id)sender;
- (IBAction)EditAction:(id)sender;
@end

@implementation CalendarDetailVc
@synthesize DicCalendarDetails;
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
    
    _viewDeleteCal.hidden=YES;
    _viewAdvanceError.hidden=YES;

    _DicForUserDetails=[[NSMutableDictionary alloc]init];
     objAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    _DicForUserDetails=objAppDelegate.AppDicUserInfo;
    
    NSString *strUserPrivate=[_DicForUserDetails valueForKey:@"private_cal"];
   // NSString *strPrivate_key=[DicCalendarDetails valueForKey:@"private_key"];
     strCal_key=[DicCalendarDetails valueForKey:@"cal_key"];
    if ([strUserPrivate isEqualToString:strCal_key])
    {
        btnRemove.hidden=YES;
        _buttonEdit.hidden=YES;
    }
    else
    {
        btnRemove.hidden=NO;
        _buttonEdit.hidden=NO;
    }
    [self OnSererTotalEvents];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    strUserEmail=[userDefaults valueForKey:@"UserId"];
    lblCal_name.text=[DicCalendarDetails valueForKey:@"cal_name"];
    txtDesc.text=[DicCalendarDetails valueForKey:@"cal_descrip"];
   
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    CGSize expectedLabelSize = [[DicCalendarDetails valueForKey:@"cal_identifier"] sizeWithFont:lblTags.font constrainedToSize:maximumLabelSize lineBreakMode:lblTags.lineBreakMode];
        CGRect newFrame = lblTags.frame;
    newFrame.size.height = expectedLabelSize.height+15;
    lblTags.frame = newFrame;
    lblTags.text=[DicCalendarDetails valueForKey:@"cal_identifier"];

    NSString *strUID=[DicCalendarDetails valueForKey:@"cal_creator"];
    NSString *strUserId=[_DicForUserDetails valueForKey:@"user_email"];
    if ([strUID isEqualToString:strUserId]) {
        
        lblCal_creator.text=@"Me";
    }
    else
    {
        lblCal_creator.text=[DicCalendarDetails valueForKey:@"cal_creator"];
        
    }
    
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
    MycalendarEventVC *objMycalendarEventVC= [[MycalendarEventVC alloc]initWithNibName:@"MycalendarEventVC" bundle:nil];
    objMycalendarEventVC.strCal_key=[NSDictionary dictionaryWithDictionary:DicCalendarDetails];
    [self.navigationController pushViewController:objMycalendarEventVC animated:YES];
}

-(IBAction)RemoveCalendarAction:(id)sender
{
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
        
        self.viewDeleteCal.transform = CGAffineTransformMakeScale(0, 0);
        self.viewDeleteCal.hidden= NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.viewDeleteCal.transform = CGAffineTransformIdentity;
            self.viewTrans.hidden = NO;
            [self.view addSubview:self.viewTrans];
        } completion:^(BOOL finished) {
        }];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==102)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)OnSererCalendar
{
    [self MbProcessHud];
    
    NSDictionary *parameters = @{@"user_email":strUserEmail,@"cal_key":strCal_key,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"deleteCal.php" Withparms:parameters WithSuccess:^(id response)
     {
         
         NSMutableDictionary *  dicResponse=[response JSONValue];
         NSString *strsuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         if ([strsuccess isEqualToString:@"1"]) {
             //NSString *strmsgSuccess=@"This calendar has been succesfully deleted from your account. It will no longer be available for any new user to either search for or download.";
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Calendar Delete" message:@"Calendar deleted successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
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
- (IBAction)OkAction:(id)sender
{
    self.viewDeleteCal.hidden=YES;
    self.viewAdvanceError.hidden=YES;
    _viewTrans.hidden=YES;
}

- (IBAction)YesAction:(id)sender
{
    [self OnSererCalendar];
}

- (IBAction)EditAction:(id)sender
{
    objAppDelegate.type_cal=@"edit";
    if ([[DicCalendarDetails objectForKey:@"cal_type"] isEqualToString:@"2"])
    {
        self.viewAdvanceError.transform = CGAffineTransformMakeScale(0, 0);
        self.viewAdvanceError.hidden= NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.viewAdvanceError.transform = CGAffineTransformIdentity;
            self.viewTrans.hidden = NO;
            [self.view addSubview:self.viewTrans];
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        if ([[DicCalendarDetails objectForKey:@"cal_type"]isEqualToString:@"0"])
        {
            // can edit basic calendar
            
             CreateCalendarVC *objCreateCalendarVC=[[CreateCalendarVC alloc]initWithNibName:@"CreateCalendarVC" bundle:Nil];
            objCreateCalendarVC.editCalDicDetails=[[NSMutableDictionary alloc]initWithDictionary:DicCalendarDetails];
             [self.navigationController pushViewController:objCreateCalendarVC animated:YES];
            
        }
        else  if ([[DicCalendarDetails objectForKey:@"cal_type"]isEqualToString:@"1"])
        {
            // can edit simple calendar
            
              SimpleScheduleVC *objSimpleScheduleVC=[[SimpleScheduleVC alloc]initWithNibName:@"SimpleScheduleVC" bundle:Nil];
              objSimpleScheduleVC.editCalDicDetails=[[NSMutableDictionary alloc]initWithDictionary:DicCalendarDetails];
             [self.navigationController pushViewController:objSimpleScheduleVC animated:YES];
        }
        else  if ([[DicCalendarDetails objectForKey:@"cal_type"]isEqualToString:@"2"])
        {
            //show error advanced calendar
        }
        else  if ([[DicCalendarDetails objectForKey:@"cal_type"]isEqualToString:@"3"])
        {
            // option not showing
        }
    }
}
@end
