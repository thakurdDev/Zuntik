//
//  ForgotPassVC.h
//  Zuntik
//
//  Created by Dev-Mac on 16/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ForgotPassVC : UIViewController
{
    MBProgressHUD *hud;

}
@property(nonatomic,retain)IBOutlet UIView *viewSet;
@property(nonatomic,retain)IBOutlet UITextField *txtUserEmail;
#pragma Buttons
-(IBAction)CloseAction:(id)sender;
-(IBAction)SubmitAction:(id)sender;
@end
