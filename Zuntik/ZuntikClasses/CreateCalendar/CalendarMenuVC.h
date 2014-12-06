//
//  CalendarMenuVC.h
//  Zuntik
//
//  Created by Dev-Mac on 18/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface CalendarMenuVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
     AppDelegate *objAppDelegate;
}
@property(nonatomic,retain)NSMutableArray *arryCalendarName;
@property(nonatomic,retain)NSMutableArray *arryCalendarDesc;
@property(nonatomic,retain)IBOutlet UITableView *tblCalendar;

-(IBAction)BackAction:(id)sender;
@end
