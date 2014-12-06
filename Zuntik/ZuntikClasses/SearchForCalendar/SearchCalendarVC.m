//
//  SearchCalendarVC.m
//  Zuntik
//
//  Created by Dev-Mac on 05/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "SearchCalendarVC.h"
#import "SimpleTableCell.h"
#import "SWRevealViewController.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "SearchCalendarDetailVC.h"
#import "HomeVC.h"
#import "SWRevealViewController.h"
@interface SearchCalendarVC ()

@end

@implementation SearchCalendarVC
@synthesize txtSearch,txtPrivateKey;
@synthesize arryResponce,dicIndexValue;
@synthesize viewAlert,viewBlackTransperent;

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
    CheckTries=5;
    self.navigationController.navigationBarHidden=YES;
    self.viewBlackTransperent.hidden = YES;
    self.dicIndexValue=[[NSMutableDictionary alloc]init];
    self.arryResponce=[[NSMutableArray alloc]init];
    UIColor *color = [UIColor whiteColor];
    txtPrivateKey.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"* Private Key" attributes:@{NSForegroundColorAttributeName: color}];
    [self SwrevelViewButton];
}
-(void)SwrevelViewButton
{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIButton *btnLeft=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44 , 44)];
    [btnLeft setImage:[UIImage imageNamed:@"reveal-icon.png"]forState:UIControlStateNormal];
    [btnLeft addTarget:revealController action:@selector(revealToggle:)
      forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnLeft];
    UIColor *color = [UIColor grayColor];
    self.txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" Search For a Calendar..." attributes:@{NSForegroundColorAttributeName: color}];
}

#pragma Textfiled Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField==self.txtSearch) {
        strsearchingText = [self.txtSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if(strsearchingText.length>0)
        {
            strsearchingText=txtSearch.text;
            [self ServicesCall];
            
        }
        else
        {

        }
    }
   
    return YES;
}

-(void)ServicesCall
{
    [self MbProcessHud];//ProcessHud

    NSDictionary *parameters = @{@"search":strsearchingText,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
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

-(IBAction)serchAction:(id)sender
{
    [txtSearch resignFirstResponder];
    strsearchingText = [self.txtSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(strsearchingText.length>0)
    {
        strsearchingText=txtSearch.text;
        [self ServicesCall];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter Search Text" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
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
        objAppDelegate.Cal_name=[NSString stringWithFormat:@"%@",[[self.arryResponce objectAtIndex:indexPath.row] objectForKey:@"cal_name"]];
        
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
            SWRevealViewController *revealController = self.revealViewController;
            UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
            if ( ![frontNavigationController.topViewController isKindOfClass:[HomeVC class]] )
            {
                HomeVC *frontViewController = [[HomeVC alloc] init];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
                [revealController setFrontViewController:navigationController animated:YES];
            }
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
        //txtSearch.text=]
    }
    [super touchesBegan:touches withEvent:event];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
