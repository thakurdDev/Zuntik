//
//  RearViewController.h
//  Zuntik
//
//  Created by Dev-Mac on 07/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DataBaseManagement.h"
@interface RearViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UILabel *lblUName,*lblUId;
    AppDelegate *objAppDelegate;
    DataBaseManagement *objDatabase;

}
@property (nonatomic, retain) IBOutlet UITableView *rearTableView;
@end
