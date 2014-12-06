//
//  LoginVC.h
//  Zuntik
//
//  Created by Dev-Mac on 05/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class SWRevealViewController;
@interface LoginVC : UIViewController
{
        UITextField *_activeField;
        MBProgressHUD *hud;
    NSString *UEmail, *UPassword;
}


@property(nonatomic,retain)IBOutlet UITextField *txtUserName;
@property(nonatomic,retain)IBOutlet UITextField *txtPassWord;
@property(nonatomic,retain)IBOutlet UIScrollView *objScrollView;
@property(nonatomic,retain)IBOutlet UIView *viewAlert,*viewBlackTransperent;
#pragma SWRevealViewController
@property (strong, nonatomic) SWRevealViewController *viewController;
#pragma Buttons
-(IBAction)CloseAction:(id)sender;
-(IBAction)LoginAction:(id)sender;
-(IBAction)ForgotPassAction:(id)sender;
-(IBAction)TermsAction:(id)sender;
-(IBAction)PrivacyAction:(id)sender;
-(IBAction)Done_TerPriAction:(id)sender;
@end

