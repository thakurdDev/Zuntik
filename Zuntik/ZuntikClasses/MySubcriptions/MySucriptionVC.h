//
//  MySucriptionVC.h
//  Zuntik
//
//  Created by Dev-Mac on 07/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManagement.h"
#import "AppDelegate.h"
@interface MySucriptionVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    AppDelegate *objeAppdelegate;
    NSMutableArray *arrForResponse;
    DataBaseManagement *objDatabase;
    NSString *strUserId;
    NSUserDefaults *userDefaults;
}
@property(nonatomic,retain)IBOutlet UITableView *tblSucription;
-(IBAction)AddSearchAction:(id)sender;
@end
