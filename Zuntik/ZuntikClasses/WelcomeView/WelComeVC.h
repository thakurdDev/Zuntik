//
//  WelComeVC.h
//  Zuntik
//
//  Created by Dev-Mac on 04/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWRevealViewController;
@interface WelComeVC : UIViewController<UITextFieldDelegate>
{
     NSString *strsearchingText;
    IBOutlet UIView *ViewCollect;
}

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;
#pragma Buttons
-(IBAction)CreateAccAction:(id)sender;
-(IBAction)LoginAction:(id)sender;
-(IBAction)serchAction:(id)sender;
#pragma SWRevealViewController
@property (strong, nonatomic) SWRevealViewController *viewController;

#pragma terms conditions
@property(nonatomic,retain)IBOutlet UIView *viewAlert,*viewBlackTransperent;
-(IBAction)TermsAction:(id)sender;
-(IBAction)PrivacyAction:(id)sender;
-(IBAction)Done_TerPriAction:(id)sender;
@end
