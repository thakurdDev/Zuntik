//
//  ConfirmationEmailVC.h
//  Zuntik
//
//  Created by Dev-Mac on 31/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmationEmailVC : UIViewController
{
    NSString *strUserId;
}
-(IBAction)BackAction:(id)sender;
-(IBAction)SendMailAction:(id)sender;
@end
