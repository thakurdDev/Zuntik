//
//  EventListVC.h
//  Zuntik
//
//  Created by Dev-Mac on 05/08/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManagement.h"
#import "AppDelegate.h"


@interface EventListVC : UIViewController
{
    AppDelegate *objectAppdelegate;
    NSString *strUserId,*strCityNum;
    DataBaseManagement *objDatabase;
}
@end
