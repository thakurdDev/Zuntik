//
//  SearchViewCalendarVC.h
//  Zuntik
//
//  Created by Dev-Mac on 28/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface SearchViewCalendarVC : UIViewController
{
    IBOutlet UILabel *lblSearchText;
    NSString *strsearchingText;
    NSString *strTbl_PrivateKey;
    int CheckTries;
    AppDelegate *objAppDelegate;
}
@property (nonatomic,retain) IBOutlet UITableView *tblViewCalendar;
@property(nonatomic,retain)NSString *strSearchText;
@property (nonatomic,retain)  NSMutableArray *arryResponce;
@property(nonatomic,retain)IBOutlet UIView *viewAlert,*viewBlackTransperent;
@property(nonatomic,retain)IBOutlet UIView *viewAlertKey,*viewBlackTransperentKey;
@property (nonatomic,retain) IBOutlet UITextField *txtPrivateKey;
@property (nonatomic,retain)  NSMutableDictionary *dicIndexValue;
-(IBAction)BackAction:(id)sender;
-(IBAction)LoginAction:(id)sender;
-(IBAction)SubmitPrivateKeyAction:(id)sender;
@end
