//
//  CreateCalendarVC.h
//  Zuntik
//
//  Created by Dev-Mac on 07/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface CreateCalendarVC : UIViewController<UITextViewDelegate>
{
    IBOutlet UITextField *txtCalendarName,*txtCal_Tag;
    IBOutlet UITextView *txtDescription;
    IBOutlet UITextField *txtPrivateKey,*txtConfirmPrivateKey;
    
    NSString *strC_Name,*strCal_Tag,*strCal_Desc,*strConfirmPrivateKey,*strPrivateKey;
    NSString *strUserId;
    AppDelegate *objAppDelegate;
}
@property (nonatomic,strong) NSMutableDictionary *editCalDicDetails;

@property(nonatomic,retain)IBOutlet UILabel *lblPlaceHolderSet;
@property(nonatomic,retain)IBOutlet UIView *viewAlert,*viewBlackTransperent;
@property(nonatomic,retain)IBOutlet UIView *viewAlertKey,*viewBlackTransperentKey;
@property(nonatomic,retain)IBOutlet UIScrollView *objScrollView;

-(IBAction)BackAction:(id)sender;
-(IBAction)CreateNewCalendarAction:(id)sender;
-(IBAction)CalendarPrivateAction:(id)sender;
-(IBAction)CalendarPublicAction:(id)sender;
-(IBAction)ContinuePrivateAction:(id)sender;
@end
