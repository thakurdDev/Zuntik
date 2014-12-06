//
//  CalendarDetailVc.h
//  Zuntik
//
//  Created by Dev-Mac on 17/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface CalendarDetailVc : UIViewController
{
    AppDelegate *objAppDelegate;

    IBOutlet UILabel *lblCal_name,*lblCal_creator,*lblEvents,*lblTags;
     NSString *strCal_key,*strUserEmail;
    IBOutlet UITextView *txtDesc;
   IBOutlet UIButton *btnRemove;

}
@property(nonatomic,retain)NSMutableDictionary *DicCalendarDetails,*DicForUserDetails;

-(IBAction)BackAction:(id)sender;
-(IBAction)RemoveCalendarAction:(id)sender;
-(IBAction)ManageCalendarAction:(id)sender;
@end
