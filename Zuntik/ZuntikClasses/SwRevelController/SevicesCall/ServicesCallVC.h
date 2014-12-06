//
//  ServicesCallVC.h
//  Zuntik
//
//  Created by Dev-Mac on 11/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManagement.h"
@class SWRevealViewController;

@interface ServicesCallVC : UIViewController
{
    NSString *strUserId;
    NSUserDefaults *userDefaults;
    DataBaseManagement *objDatabase;
    
    NSMutableDictionary *dicResponse;
    NSMutableDictionary *dicData;
}
#pragma SWRevealViewController
@property (strong, nonatomic) SWRevealViewController *viewController;
@end
