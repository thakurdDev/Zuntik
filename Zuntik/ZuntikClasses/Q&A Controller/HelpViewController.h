//
//  HelpViewController.h
//  Zuntik
//
//  Created by Dev-Mac on 14/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManagement.h"

@interface HelpViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    int selecetedIndex;
    BOOL isSelected;
    DataBaseManagement *objDatabase;

}

@property(nonatomic,retain)IBOutlet UITableView *tableViewHelp;
@property(nonatomic,retain)NSMutableArray *mArrayResponse;
@end
