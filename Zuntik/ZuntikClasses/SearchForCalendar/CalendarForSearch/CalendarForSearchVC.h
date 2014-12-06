//
//  CalendarForSearchVC.h
//  Zuntik
//
//  Created by Dev-Mac on 30/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManagement.h"
#import "MyUtility.h"
#import "AppDelegate.h"
@interface CalendarForSearchVC : UIViewController
{
    DataBaseManagement *objDatabase;
    AppDelegate *objAppDelegate;
    NSUserDefaults *userDefaults;
    NSMutableDictionary *DicForUserDetails;
    NSString *strUserId;
    IBOutlet UILabel *lblDateShow,*lblEventCount,*lblHeader;
    IBOutlet UIButton *btncheckValue;
  
}
@property(nonatomic,retain)NSString *strCal_key,*strCal_Name;
@property (nonatomic ,retain)NSMutableArray *arrForResponse;
@property (nonatomic ,retain)NSMutableArray *arrForListData;
//Details According
@property(nonatomic,retain)IBOutlet UITableView *tblCal_Events;
@property(nonatomic,retain)IBOutlet UIView *viewDetailShow;
@property(nonatomic,retain)NSString *strTblReload;
-(IBAction)AllCal_EventsAction:(id)sender;

-(IBAction)EventAdd:(id)sender;

@end