//
//  MycalendarEventVC.h
//  Zuntik
//
//  Created by Dev-Mac on 28/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManagement.h"
#import "MyUtility.h"
#import "AppDelegate.h"
@interface MycalendarEventVC : UIViewController
{
    DataBaseManagement *objDatabase;
    AppDelegate *objAppDelegate;
     NSUserDefaults *userDefaults;
     NSMutableDictionary *DicForUserDetails;
     NSString *strUserId;
    IBOutlet UILabel *lblDateShow,*lblEventCount,*lblHeader;
    IBOutlet UIButton *btncheckValue;
}
@property(nonatomic,retain)  NSDictionary *strCal_key;
@property (nonatomic ,retain)NSMutableArray *arrForResponse;
@property (nonatomic ,retain)NSMutableArray *arrForListData;
//Details According
@property(nonatomic,retain)IBOutlet UITableView *tblCal_Events;
@property(nonatomic,retain)IBOutlet UIView *viewDetailShow;
@property(nonatomic,retain)NSString *strTblReload;

-(IBAction)EventAdd:(id)sender;
-(IBAction)BackAction:(id)sender;
@end
