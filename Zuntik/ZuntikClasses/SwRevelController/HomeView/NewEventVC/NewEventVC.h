//
//  NewEventVC.h
//  Zuntik
//
//  Created by Dev-Mac on 25/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyUtility.h"
#import "AppDelegate.h"
#import "DataBaseManagement.h"
@interface NewEventVC : UIViewController
{
    DataBaseManagement *objDatabase;
    AppDelegate *objAppDelegate;
    NSString *strUserPrivate,*strUserId;
    IBOutlet UITextField *txtSelect_Date,*txtSelect_Time,*txtSelect_Hours,*txtSelect_Min,*activeField;
    IBOutlet UITextField *txtStart_FDate,*txtStart_StartTime,*txtStart_SDate,*txt,*txtStart_StopTime;
    IBOutlet UITextField *txtSetR_Date,*txtSetR_Time;
    NSString *strCheckMode,*strPickerMode;
    NSString *strPickerHours,*strPickerMin;
    IBOutlet UIButton *btnSelectLength,*btnStartStop,*btnSetRemind;
    IBOutlet UIView *viewSelectedLength,*ViewStartStop,*ViewSetRemind,*viewCreateEvent;
    
}
// 19-08-14
@property (nonatomic,strong) NSMutableDictionary *dicEventDetail;

@property(nonatomic,retain)IBOutlet UITextField *txtEventName;
@property(nonatomic,retain)IBOutlet UILabel *lblPlaceHolderSet;
@property(nonatomic,retain)IBOutlet UITextView *txtEventDesc;
@property(nonatomic,retain)IBOutlet UIDatePicker *Date_Picker;
@property(nonatomic,retain)IBOutlet UIView *viewDatePicker,*viewSimplePicker;
@property(nonatomic,retain)IBOutlet UIScrollView *objScrollView;
@property(retain, nonatomic)IBOutlet UIPickerView *pickerView;
@property(retain, nonatomic) NSMutableArray *hoursArray,*minsArray;
@property(retain, nonatomic) NSString *strCheckEvent,*strEventName,*strEventDesc;
@property(retain, nonatomic) NSString *strSelectedDate,*strshowselectDatre;
;
-(IBAction)BackAction:(id)sender;
#pragma mark-Date picker method
-(IBAction)DatePick_AddAction:(id)sender;
-(IBAction)DatePick_CancelAction:(id)sender;

#pragma mark-Simple picker method
-(IBAction)Picker_AddAction:(id)sender;
-(IBAction)Picker_CancelAction:(id)sender;
#pragma mark-CreateNewEventAction method
-(IBAction)CreateNewEventAction:(id)sender;
#pragma mark-Events method
-(IBAction)SelectedLengthAction:(id)sender;
-(IBAction)StartAndStopAction:(id)sender;
-(IBAction)SetRemindAction:(id)sender;
#pragma mark-Show Picker method
-(IBAction)ShowPickerAction:(id)sender;
@end
