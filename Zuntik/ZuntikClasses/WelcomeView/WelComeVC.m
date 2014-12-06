//
//  WelComeVC.m
//  Zuntik
//
//  Created by Dev-Mac on 04/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "WelComeVC.h"
#import "CreateAccount.h"
#import "LoginVC.h"
#import "ServicesCallVC.h"
#import "HomeVC.h"
#import "RearViewController.h"
#import "RightViewController.h"
#import "SWRevealViewController.h"
#import "SearchViewCalendarVC.h"
@interface WelComeVC ()<SWRevealViewControllerDelegate>
{
      NSInteger tapon;
}
@property (weak, nonatomic) IBOutlet UILabel *lblAlertTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTermsMessagfe;


@end

@implementation WelComeVC
@synthesize txtSearch;
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
    
    
      self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view from its nib.
    //SWRevealViewController *revealController = [self revealViewController];
    UIColor *color = [UIColor grayColor];
    self.txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Find Calendar Now..." attributes:@{NSForegroundColorAttributeName: color}];

  
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isLogedIn"])
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
    
    [self NotifationMethod];
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.txtSearch.text=@"";
}


-(void)NotifationMethod
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:@"UIKeyboardDidHideNotification"
                                               object:nil];
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
            SearchViewCalendarVC *objSearchViewCalendarVC=[[SearchViewCalendarVC alloc]initWithNibName:@"SearchViewCalendarVC" bundle:nil];
            objSearchViewCalendarVC.strSearchText=strsearchingText;
            [self.navigationController pushViewController:objSearchViewCalendarVC animated:YES];
            
        }
        else
        {

        }
    }
    
    return YES;
}


-(IBAction)serchAction:(id)sender
{
    [txtSearch resignFirstResponder];
    strsearchingText = [self.txtSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(strsearchingText.length>0)
    {
        strsearchingText=txtSearch.text;
        SearchViewCalendarVC *objSearchViewCalendarVC=[[SearchViewCalendarVC alloc]initWithNibName:@"SearchViewCalendarVC" bundle:nil];
        objSearchViewCalendarVC.strSearchText=strsearchingText;
        [self.navigationController pushViewController:objSearchViewCalendarVC animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"Enter Search Text" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

#pragma Buttons
-(IBAction)CreateAccAction:(id)sender
{
    CreateAccount *objCreateAccount=[[CreateAccount alloc]initWithNibName:@"CreateAccount" bundle:nil];
    [self.navigationController pushViewController:objCreateAccount animated:YES];
}
-(IBAction)LoginAction:(id)sender
{
    LoginVC *objLoginVC=[[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
    [self.navigationController pushViewController:objLoginVC animated:YES];
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
-(IBAction)Done_TerPriAction:(id)sender
{
    self.viewBlackTransperent.hidden = YES;
    
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

#pragma Keybord Method
- (void) keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // move the view up by 30 pts
    CGRect frame = ViewCollect.frame;
    frame.origin.y =frame.origin.y-163 ;
    
    [UIView animateWithDuration:0.3 animations:^{
        ViewCollect.frame = frame;
    }];
}
- (void) keyboardDidHide:(NSNotification *)note {
    
    // move the view back to the origin
    CGRect frame = ViewCollect.frame;
    frame.origin.y =frame.origin.y+163 ;
    
    [UIView animateWithDuration:0.3 animations:^{
        ViewCollect.frame = frame;
    }];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   // [self.objScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [txtSearch resignFirstResponder];
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
