//
//  MycalendarEventDetailVC.m
//  Zuntik
//
//  Created by Dev-Mac on 29/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "MycalendarEventDetailVC.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "NewEventVC.h"
@interface MycalendarEventDetailVC ()
@property (weak, nonatomic) IBOutlet UIButton *buttonEdit;
@property (weak, nonatomic) IBOutlet UIView *viewDelete;
@property (strong, nonatomic) IBOutlet UIView *viewTranse;
@property (weak, nonatomic) IBOutlet UIView *viewAdvanceError;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;

- (IBAction)EditEventAction:(id)sender;

@end

@implementation MycalendarEventDetailVC
@synthesize dicCal_Event;
@synthesize viewSubcribe;
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
    
    _viewDelete.hidden=YES;
    _viewTranse.hidden=YES;
    _viewAdvanceError.hidden=YES;
    
    objectAppdelgate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Do any additional setup after loading the view from its nib.
    NSString *StrCheckType=[dicCal_Event valueForKey:@"Type"];
    strEventKey=[dicCal_Event valueForKey:@"event_key"];
    strUserID=[dicCal_Event valueForKey:@"UserEmail"];
    if ([StrCheckType isEqualToString:@"Subscribed"])
    {
        _buttonEdit.hidden=YES;
        _removeButton.hidden=YES;
    }
    else
    {
        _buttonEdit.hidden=NO;
        _removeButton.hidden=NO;
        
    }
    
    lblCal_Name.text=[dicCal_Event valueForKey:@"cal_name"];
    lblH_Name.text=[dicCal_Event valueForKey:@"event_name"];
    lblH_Date.text=[dicCal_Event valueForKey:@"CurrentDate"];
    txtDesc.text=[dicCal_Event valueForKey:@"event_descrip"];
    lblDate.text=[dicCal_Event valueForKey:@"date_Year"];
    lblStart_Time.text=[dicCal_Event valueForKey:@"StartTime"];
    lblDuretion.text=[dicCal_Event valueForKey:@"Duretionlength"];
}
-(IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)RemoveAction:(id)sender
{
    self.viewDelete.transform = CGAffineTransformMakeScale(0, 0);
    self.viewDelete.hidden= NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.viewDelete.transform = CGAffineTransformIdentity;
        self.viewTranse.hidden = NO;
        [self.view addSubview:_viewTranse];
    } completion:^(BOOL finished) {
    }];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==102)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)RemoveEventOnServer
{
    [self MbProcessHud];
    NSDictionary *parameters = @{@"user_email":strUserID,@"event_key":strEventKey,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"removeEvent.php" Withparms:parameters WithSuccess:^(id response)
     {
         UIAlertView *alert;
         
         NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
         dicResponse=[response JSONValue];
         NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         NSString *strmessage = [NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"message"]];
         if ([strSuccess isEqualToString:@"1"])
         {
             alert = [[UIAlertView alloc] initWithTitle:@"" message:@"event Deleted successfully" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
             alert.tag=102;
         }
         else
         {
             alert = [[UIAlertView alloc] initWithTitle:@"Delete Event" message:strmessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         [alert show];
         
     }
     
                                      failure:^(NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
         [alert show];
     }];
}
-(void)MbProcessHud  //MbHud Method
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
- (IBAction)yesAction:(id)sender
{
    [self RemoveEventOnServer];
}

- (IBAction)noAction:(id)sender
{
    self.viewTranse.hidden=YES;
}

- (IBAction)EditEventAction:(id)sender
{
    if ([[dicCal_Event objectForKey:@"in_class_code"]isEqualToString:@" "]||[dicCal_Event objectForKey:@"in_class_code"]==NULL)
    {
        
        objectAppdelgate.type_cal=@"Edit";
        NewEventVC *objNewEventVC = [[NewEventVC alloc]initWithNibName:@"NewEventVC" bundle:nil];
        objNewEventVC.dicEventDetail=[[NSMutableDictionary alloc]initWithDictionary:dicCal_Event];
        [self.navigationController pushViewController:objNewEventVC animated:YES];
    }
    else
    {
        self.viewAdvanceError.transform = CGAffineTransformMakeScale(0, 0);
        self.viewAdvanceError.hidden= NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.viewAdvanceError.transform = CGAffineTransformIdentity;
            self.viewTranse.hidden = NO;
        } completion:^(BOOL finished) {
        }];
    }
}
@end
