//
//  HomeVC.h
//  Zuntik
//
//  Created by Dev-Mac on 07/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManagement.h"
#import "AppDelegate.h"
#import "MyUtility.h"
@interface HomeVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    DataBaseManagement *objDatabase;
    NSString *strUserId;
    NSUserDefaults *userDefaults;
    AppDelegate *objAppDelegate;
    NSMutableDictionary *DicForUserDetails;
    //Details According
    IBOutlet UILabel *lblDateShow,*lblEventCount;
    NSString *strSelectedDate;
    
    
}
@property (nonatomic ,retain)NSMutableArray *arrForResponse;
@property (nonatomic ,retain)NSMutableArray *arrForListData;
@property(nonatomic,retain)NSString *strCheckView;
//Details According
@property(nonatomic,retain)IBOutlet UITableView *tblCal_Events;
@property(nonatomic,retain)IBOutlet UIView *viewDetailShow;

-(IBAction)EventAdd:(id)sender;

@end
