//
//  MycalendarEventDetailVC.h
//  Zuntik
//
//  Created by Dev-Mac on 29/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface MycalendarEventDetailVC : UIViewController
{
    AppDelegate *objectAppdelgate;
    IBOutlet UILabel *lblH_Name,*lblH_Date,*lblCal_Name,*lblStart_Time,*lblDate,*lblDuretion;
    IBOutlet UITextView *txtDesc;
    NSString *strEventKey,*strUserID;
}
@property(nonatomic,retain)NSMutableDictionary *dicCal_Event;
@property(nonatomic,retain)IBOutlet UIView *viewRemove,*viewSubcribe;

-(IBAction)BackAction:(id)sender;
-(IBAction)RemoveAction:(id)sender;

@end
