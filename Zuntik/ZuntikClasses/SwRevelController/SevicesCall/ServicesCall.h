//
//  ServicesCall.h
//  Zuntik
//
//  Created by Dev-Mac on 16/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseManagement.h"
#import "AppDelegate.h"

@interface ServicesCall : NSObject
{
    NSString *strUserId;
    NSUserDefaults *userDefaults;
    DataBaseManagement *objDatabase;

    NSMutableDictionary *dicResponse;
    NSMutableDictionary *dicData;
    AppDelegate *objAppDelegate;
}
-(void)InitilizeMethod;
-(void)UserInfoHomePage;
@end
