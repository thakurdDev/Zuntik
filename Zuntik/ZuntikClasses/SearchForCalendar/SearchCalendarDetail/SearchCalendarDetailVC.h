//
//  SearchCalendarDetailVC.h
//  Zuntik
//
//  Created by Dev-Mac on 16/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface SearchCalendarDetailVC : UIViewController
{
    IBOutlet UILabel *lblCal_name,*lblCal_creator,*lblEvents,*lblTags;
    IBOutlet UITextView *txtDesc;
    NSString *strCal_key,*strUserEmail;
     AppDelegate *objAppDelegate;
}
-(IBAction)BackAction:(id)sender;
-(IBAction)UnSubcriptionAction:(id)sender;
-(IBAction)ManageCalendarAction:(id)sender;
@property(nonatomic,retain)NSMutableDictionary *DicSeachDetails;
@property(nonatomic,retain)NSString *strCheckView;

@end
