//
//  SettingNotificationVC.h
//  Zuntik
//
//  Created by Dev-Mac on 29/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBaseManagement.h"
#import "MyUtility.h"
@interface SettingNotificationVC : UIViewController
{
      DataBaseManagement *objDatabase;
    NSString *strUserId,*strPickerMin;
    IBOutlet UILabel *lblMin;
    NSString *strdate;
    NSDate *datePlusOneMinute;
}
@property (nonatomic ,retain)NSMutableArray *arrForResponse;
@property(nonatomic,retain)IBOutlet UITextField *txtTime;
@property(retain, nonatomic) NSMutableArray *minsArray;
@property(nonatomic,retain)IBOutlet UIView *viewSimplePicker;
@property(retain, nonatomic)IBOutlet UIPickerView *pickerView;
-(IBAction)SetNotification:(id)sender;
-(IBAction)DoneAction:(id)sender;
-(IBAction)CancelAction:(id)sender;



@end
