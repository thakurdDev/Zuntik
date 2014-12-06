//
//  CreateAccount.h
//  Zuntik
//
//  Created by Dev-Mac on 05/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class SWRevealViewController;
@interface CreateAccount : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
     UITextField *_activeField;
    NSMutableArray *arrResponse;
    NSString *strcity_num;
    MBProgressHUD *hud;
}

@property(nonatomic,retain)IBOutlet UIView *viewList,*viewBlackTransperent;
@property(nonatomic,retain)IBOutlet UITextField *txtUserName,*txtLastName;
@property(nonatomic,retain)IBOutlet UITextField *txtEmail;
@property(nonatomic,retain)IBOutlet UITextField *txtPassWord,*txtConformPass;
@property(nonatomic,retain)IBOutlet UITextField *txtCity;
@property(nonatomic,retain)IBOutlet UIScrollView *objScrollView;
@property(nonatomic,retain)IBOutlet UITableView *objTbl;
-(IBAction)CloseAction:(id)sender;
-(IBAction)CreateAccAction:(id)sender;

#pragma SWRevealViewController
@property (strong, nonatomic) SWRevealViewController *viewController;
#pragma terms conditions
@property(nonatomic,retain)IBOutlet UIView *viewAlertTerm,*viewBlackTransperentTerm;
-(IBAction)TermsAction:(id)sender;
-(IBAction)PrivacyAction:(id)sender;
-(IBAction)Done_TerPriAction:(id)sender;
@end
