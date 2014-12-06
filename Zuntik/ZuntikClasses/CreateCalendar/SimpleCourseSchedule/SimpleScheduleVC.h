//
//  SimpleScheduleVC.h
//  Zuntik
//
//  Created by Dev-Mac on 18/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface SimpleScheduleVC : UIViewController
{
    NSString *strUserId;
    IBOutlet UITextField *txtPrivateKey,*txtConfirmPrivateKey;
    NSString *strCal_Desc,*strCal_Tags,*strDiscussion,*strClass_Number,*strN_Professor,*strN_Class,*strConfirmPrivateKey,*strPrivateKey;
    AppDelegate *objAppDelegate;
}
@property (nonatomic,strong) NSMutableDictionary *editCalDicDetails;

@property(nonatomic,retain)IBOutlet UITextField *txtN_Class,*txtN_Professor,*txtClass_Number,*txtDiscussion,*txtCal_Tags;
@property(nonatomic,retain)IBOutlet UILabel *lblPlaceHolderSet;
@property(nonatomic,retain)IBOutlet UITextView *txtCal_Desc;
@property(nonatomic,retain)IBOutlet UIScrollView *objScrollView;
@property(nonatomic,retain)IBOutlet UIView *viewAlert,*viewBlackTransperent;
@property(nonatomic,retain)IBOutlet UIView *viewAlertKey,*viewBlackTransperentKey;

-(IBAction)BackAction:(id)sender;
-(IBAction)CreateNewCalendarAction:(id)sender;
-(IBAction)CalendarPrivateAction:(id)sender;
-(IBAction)CalendarPublicAction:(id)sender;
-(IBAction)ContinuePrivateAction:(id)sender;
@end
