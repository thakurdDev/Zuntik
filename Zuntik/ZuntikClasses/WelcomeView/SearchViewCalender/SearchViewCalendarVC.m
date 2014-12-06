//
//  SearchViewCalendarVC.m
//  Zuntik
//
//  Created by Dev-Mac on 28/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "SearchViewCalendarVC.h"
#import "MBProgressHUD.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "SimpleTableCell.h"
#import "SearchCalendarDetailVC.h"

@interface SearchViewCalendarVC ()

@end

@implementation SearchViewCalendarVC
@synthesize strSearchText;
@synthesize arryResponce,tblViewCalendar;
@synthesize dicIndexValue,txtPrivateKey;
;@synthesize viewAlert,viewBlackTransperent;
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
    // Do any additional setup after loading the view from its nib.
    lblSearchText.text=[NSString stringWithFormat:@"'%@'",strSearchText];;
    self.arryResponce=[[NSMutableArray alloc]init];
    CheckTries=5;
    self.dicIndexValue=[[NSMutableDictionary alloc]init];
    UIColor *color = [UIColor whiteColor];
    self.txtPrivateKey.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"* Private Key" attributes:@{NSForegroundColorAttributeName: color}];
    [self ServicesCall];

}
-(IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)LoginAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)ServicesCall
{
    [self MbProcessHud];//ProcessHud
    
    NSDictionary *parameters = @{@"search":strSearchText,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"search.php" Withparms:parameters WithSuccess:^(id response)
     {
         NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
         dicResponse=[response JSONValue];
         if (dicResponse!=nil)
         {
             self.arryResponce=[dicResponse valueForKey:@"results"];
             [self.tblViewCalendar reloadData];
         }
         else
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Response" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
             [alert show];
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

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arryResponce count];
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
    NSString *strCal_name = [[[self.arryResponce objectAtIndex:indexPath.row]valueForKey:@"cal_name"]uppercaseString];
    cell.lblSearchName.text =  strCal_name;
    cell.lblSearchDetail.text=[[self.arryResponce objectAtIndex:indexPath.row]valueForKey:@"cal_creator"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.dicIndexValue=[self.arryResponce objectAtIndex:indexPath.row];
    strTbl_PrivateKey=  [[self.arryResponce objectAtIndex:indexPath.row]valueForKey:@"private_key"];
    if([strTbl_PrivateKey isEqual:[NSNull null]])
    {
        objAppDelegate.type_cal=[NSString stringWithFormat:@"%@",[[self.arryResponce objectAtIndex:indexPath.row] objectForKey:@"cal_type"]];
        SearchCalendarDetailVC *objSearchCalendarDetailVC = [[SearchCalendarDetailVC alloc] initWithNibName:@"SearchCalendarDetailVC" bundle:nil];
        objSearchCalendarDetailVC.DicSeachDetails = [self.arryResponce objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:objSearchCalendarDetailVC animated:YES];
    }
    else
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
}
-(IBAction)SubmitPrivateKeyAction:(id)sender
{
    CheckTries=CheckTries-1;
    NSString *strMsg=[NSString  stringWithFormat:@"Oops, The private key that you entered is incorrect, you have %d tries remaining. ",CheckTries];
    NSString *strPrivateKey = [self.txtPrivateKey.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([strPrivateKey isEqualToString:strTbl_PrivateKey])
    {
        self.txtPrivateKey.text=@"";
        self.viewBlackTransperent.hidden=YES;
        SearchCalendarDetailVC *objSearchCalendarDetailVC = [[SearchCalendarDetailVC alloc] initWithNibName:@"SearchCalendarDetailVC" bundle:nil];
        objSearchCalendarDetailVC.DicSeachDetails = self.dicIndexValue;
        [self.navigationController pushViewController:objSearchCalendarDetailVC animated:YES];
        CheckTries=5;
    }
    else
    {
        if (CheckTries ==0)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:strMsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
    }
    
    
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] != viewAlert)
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
