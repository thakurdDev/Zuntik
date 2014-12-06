//
//  SearchCalendarVC.h
//  Zuntik
//
//  Created by Dev-Mac on 05/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface SearchCalendarVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    AppDelegate *objAppDelegate;
    
    NSString *strsearchingText;
    NSString *strTbl_PrivateKey;
    int CheckTries;

}

@property (nonatomic,retain) IBOutlet UITableView *tblViewCalendar;
@property (nonatomic,retain) IBOutlet UITextField *txtSearch,*txtPrivateKey;
@property (nonatomic,retain)  NSMutableArray *arryResponce;
@property (nonatomic,retain)  NSMutableDictionary *dicIndexValue;
@property(nonatomic,retain)IBOutlet UIView *viewAlert,*viewBlackTransperent;
-(IBAction)serchAction:(id)sender;
-(IBAction)SubmitPrivateKeyAction:(id)sender;
@end
