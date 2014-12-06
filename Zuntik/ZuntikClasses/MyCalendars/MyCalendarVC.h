//
//  MyCalendarVC.h
//  Zuntik
//
//  Created by Dev-Mac on 07/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManagement.h"
#import "AppDelegate.h"
@interface MyCalendarVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrForResponse;
    DataBaseManagement *objDatabase;
    NSString *strUserId;
    NSUserDefaults *userDefaults;
    AppDelegate *objAppDelegate;

}
@property(nonatomic,retain)IBOutlet UITableView *tblMyCalendar;
-(IBAction)CreateCalendar:(id)sender;
@end
