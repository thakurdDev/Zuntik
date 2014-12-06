//
//  AppDelegate.h
//  Zuntik
//
//  Created by Dev-Mac on 04/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WelComeVC;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) WelComeVC *objWelComeVC;
@property (nonatomic, retain) UINavigationController *navigationController;
@property(nonatomic,retain)NSMutableDictionary *AppDicUserInfo;

// get calendar type value in string;
@property (nonatomic,strong) NSString *type_cal;
@property (nonatomic,strong) NSMutableArray *HoldEventArry;
// array for left menu event list
@property (nonatomic,strong) NSMutableArray *EventListArray;
@property (nonatomic,strong) NSString *TypeForSubscribed;
@property  (nonatomic, strong) NSString *Cal_Key;
@property (nonatomic,strong) NSString *Cal_name;
@end
