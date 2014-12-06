//
//  NewEventVC.m
//  Zuntik
//
//  Created by Dev-Mac on 25/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "NewEventVC.h"
#import "MBProgressHUD.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import <QuartzCore/QuartzCore.h>

@interface NewEventVC ()
{
    NSInteger Top_DownScroll;
    BOOL resetScroll;
    NSDate *holdStartTime;
    NSDate *HoldEndTime;
    NSDate *holdEndDate;
    NSDate *holdedStartDate;
    UITextField *holdTextField;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonEditCreate;
//
@property (weak, nonatomic) IBOutlet UILabel *lblTopHeader;

//
@end

@implementation NewEventVC
@synthesize Date_Picker,viewDatePicker,viewSimplePicker,pickerView;
@synthesize objScrollView;
@synthesize hoursArray,minsArray;
@synthesize txtEventName,txtEventDesc;
@synthesize strEventName,strEventDesc,strSelectedDate;
@synthesize lblPlaceHolderSet;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark-viewDidLoad method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDate *datenew=[NSDate date];
    
    self.Date_Picker.date=[self ConvertDate:datenew];
    
    // Do any additional setup after loading the view from its nib.
    objAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    strUserId=[userDefaults valueForKey:@"UserId"];
    
    self.txtEventDesc.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"EventDescriptionImgBox.png"]];
    
    objDatabase = [DataBaseManagement Connetion];//Database Connection
    
    objAppDelegate.AppDicUserInfo=[objDatabase getUserInfo:strUserId];
    NSMutableDictionary *DicForUserDetails=objAppDelegate.AppDicUserInfo;
    
    strUserPrivate=objAppDelegate.Cal_Key;
    strUserId=[DicForUserDetails valueForKey:@"user_email"];
    self.viewDatePicker.hidden=YES;
    self.viewSimplePicker.hidden=YES;
    
    ViewStartStop.hidden=YES;
    ViewSetRemind.hidden=YES;
    self.strCheckEvent=@"SelectLengthEvent";
    hoursArray = [[NSMutableArray alloc] initWithObjects:@"0 hours",@"1 hours",@"2 hours",@"3 hours",@"4 hours",@"5 hours",@"6 hours",@"7 hours",@"8 hours",@"9 hours",@"10 hours",@"11 hours",@"12 hours", nil];
    
    
    minsArray = [[NSMutableArray alloc] initWithObjects:@"0 minutes",@"5 minutes",@"10 minutes",@"15 minutes",@"20 minutes",@"25 minutes",@"30 minutes",@"35 minutes",@"40 minutes",@"45 minutes",@"50 minutes",@"55 minutes", nil];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [dateFormatter dateFromString:strSelectedDate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM-dd-yyyy"];
    _strshowselectDatre = [NSString stringWithFormat:@"%@",[df stringFromDate:date]];
    
    if ([_strshowselectDatre isEqualToString:@"(null)"])
    {
        NSDate *now = [NSDate date];
        NSString *strCurrentDate=[NSString stringWithFormat:@"%@",[df stringFromDate:now]];
        
        txtSelect_Date.text=strCurrentDate;
        txtStart_FDate.text=strCurrentDate;
        txtSetR_Date.text=strCurrentDate;
        
    }
    else
    {
        txtSelect_Date.text=_strshowselectDatre;
        txtStart_FDate.text=_strshowselectDatre;
        txtSetR_Date.text=_strshowselectDatre;
        
    }
    txtSelect_Hours.text=@"0 hours";
    txtSelect_Min.text=@"0 minutes";
    [self BtnSetText];
    [self setPlaceHoldarColor];
    [self.objScrollView setContentSize:CGSizeMake(0, 45)];
    
    
    if (_dicEventDetail.count>1)
    {
        NSString *EventDate=[NSString stringWithFormat:@"%@",[_dicEventDetail objectForKey:@"event_date"]];
        
        NSArray *array = [EventDate componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        lblPlaceHolderSet.hidden=YES;
        _lblTopHeader.text=@"Edit Event";
        [_buttonEditCreate setTitle:@"Edit Event" forState:UIControlStateNormal];
        
        txtEventName.text=[_dicEventDetail objectForKey:@"event_name"];
        txtEventDesc.text=[_dicEventDetail objectForKey:@"event_descrip"];
        
        txtStart_StartTime.text=[_dicEventDetail objectForKey:@"StartTime"];
        txtSetR_Time.text=[_dicEventDetail objectForKey:@"StartTime"];
        txtSelect_Time.text=[_dicEventDetail objectForKey:@"StartTime"];
        
        NSString *dateString=[array objectAtIndex:0];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:dateString];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"MM-dd-yyyy"];
        NSString *newDateString = [dateFormatter2 stringFromDate:date];
        
        txtSelect_Date.text=[NSString stringWithFormat:@"%@",newDateString];
        txtSetR_Date.text=[NSString stringWithFormat:@"%@",newDateString];
        txtStart_FDate.text=[NSString stringWithFormat:@"%@",newDateString];
        
        if ([[_dicEventDetail objectForKey:@"event_length"] integerValue]==5||[[_dicEventDetail objectForKey:@"event_length"] integerValue]<5)
        {
            // set as reminder
            [self SetasReminder];
        }
        else if (([[_dicEventDetail objectForKey:@"event_length"] integerValue]>5 && [[_dicEventDetail objectForKey:@"event_length"] integerValue]<775)||[[_dicEventDetail objectForKey:@"event_length"] integerValue]==775)
        {
            NSString *check= [MyUtility timeFormatted:[[_dicEventDetail objectForKey:@"event_length"] intValue]];
            
            NSArray *array1 = [check componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            txtSelect_Hours.text=[NSString stringWithFormat:@"%@ hours",[array1 objectAtIndex:0]];
            txtSelect_Min.text=[NSString stringWithFormat:@"%@ minutes",[array1 objectAtIndex:1]];
            
            // select lenth
            [self SetasLength];
        }
        else if ([[_dicEventDetail objectForKey:@"event_length"] integerValue]>775)
        {
            
            NSString *hours_minutes= [MyUtility timeFormatted:[[_dicEventDetail objectForKey:@"event_length"] intValue]];
            
            NSArray *temp = [hours_minutes componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSDateFormatter *dateFormat3= [[NSDateFormatter alloc] init];
            [dateFormat3 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormat3 dateFromString:EventDate];
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
            [components setHour:[[temp objectAtIndex:0] intValue]];
            [components setMinute:[[temp objectAtIndex:1] intValue]];
            
            NSDate *today10am = [calendar dateFromComponents:components];
            
            NSString *lastdate = [dateFormat3 stringFromDate:today10am];
            
            NSArray *temp2 = [lastdate componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            
            NSString *wait1=[temp2 objectAtIndex:0];
            
            NSDateFormatter *dateFormatter10 = [[NSDateFormatter alloc] init];
            [dateFormatter10 setDateFormat:@"yyyy-MM-dd"];
            NSDate *date10 = [dateFormatter dateFromString:wait1];
            NSDateFormatter *dateFormatter11 = [[NSDateFormatter alloc] init];
            [dateFormatter11 setDateFormat:@"MM-dd-yyyy"];
            NSString *lastdate1 = [dateFormatter11 stringFromDate:date10];
            
         
            txtStart_StopTime.text=[_dicEventDetail objectForKey:@"Time"];
            txtStart_SDate.text=[NSString stringWithFormat:@"%@",lastdate1];
            // start and stop
            [self StartAndStopAction];
        }
    }
    else
    {
        [_buttonEditCreate setTitle:@"Create New Event" forState:UIControlStateNormal];
        _lblTopHeader.text=@"New Event";
    }
    
}
-(void)BtnSetText
{
    /* R = 71
     G -= 180
     B = 180*/
    btnSelectLength.selected=YES;
    [btnSelectLength setBackgroundColor:[UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1]];
    
    [[btnSelectLength layer] setBorderWidth:1.0f];
    [[btnSelectLength layer] setBorderColor:[UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1].CGColor];
    
    [[btnStartStop layer] setBorderWidth:1.0f];
    [[btnStartStop layer] setBorderColor:[UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1].CGColor];
    [[btnSetRemind layer] setBorderWidth:1.0f];
    [[btnSetRemind layer] setBorderColor:[UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1].CGColor];
    
    btnSetRemind.titleLabel.textColor = [UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1];
    
    btnStartStop.titleLabel.textColor = [UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1];
    
    btnSelectLength.titleLabel.textColor = [UIColor whiteColor];
}
#pragma mark-setPlaceHoldarColor method

-(void)setPlaceHoldarColor
{
    UIColor *color = [UIColor whiteColor];
    self.txtEventName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name Of Event" attributes:@{NSForegroundColorAttributeName: color}];
}
#pragma mark-Events method
-(IBAction)SelectedLengthAction:(id)sender
{
    [self SetasLength];
}
-(IBAction)StartAndStopAction:(id)sender
{
    [self StartAndStopAction];
}
-(IBAction)SetRemindAction:(id)sender
{
    [self SetasReminder];
}
#pragma mark-BackAction method
-(IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSDate *)ConvertDate:(NSDate *)newDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"mm"];
    NSString *etst=[NSString stringWithFormat:@"%@",[df stringFromDate:newDate]];
    NSInteger minute=[etst integerValue];
    
    if (minute == 60)
        minute = 0;
    if (minute % 5 != 0) {
        NSInteger minuteFloor = minute - (minute % 5);
        minute = minuteFloor
        + (minute == minuteFloor + 1 ? 5 : 0);
        if (minute == 60)
            minute = 0;
    }
    minute=minute-[etst integerValue];
    
    NSDate *datePlusOneMinute = [NSDate dateWithTimeInterval:60*minute sinceDate:newDate];

    return datePlusOneMinute;
}
#pragma mark-Date picker method
-(IBAction)DatePick_AddAction:(id)sender
{
    if (resetScroll==YES)
    {
        [self.objScrollView setContentOffset:CGPointMake(0,holdTextField.center.y-Top_DownScroll) animated:YES];
    }
    
    NSDate *newDate= [self ConvertDate:self.Date_Picker.date];
    
    self.viewDatePicker.hidden=YES;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if ([strCheckMode isEqualToString:@"Select_UIDatePickerModeDate"])
    {
        [df setDateFormat:@"MM-dd-yyyy"];
        txtSelect_Date.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.Date_Picker.date]];
    }
    else if ([strCheckMode isEqualToString:@"Select_UIDatePickerModeTime"])
    {
        [df setDateFormat:@"hh:mm a"];
        
        txtSelect_Time.text = [NSString stringWithFormat:@"%@",[df stringFromDate:newDate]];
    }
    else if ([strCheckMode isEqualToString:@"Star_FDateUIDatePickerModeDate"])
    {
        [df setDateFormat:@"MM-dd-yyyy"];
        txtStart_FDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.Date_Picker.date]];
        holdedStartDate=[df dateFromString:txtStart_FDate.text];
        
    }
    else if ([strCheckMode isEqualToString:@"StartTime_UIDatePickerModeTime"])
    {
        [df setDateFormat:@"hh:mm a"];
        txtStart_StartTime.text = [NSString stringWithFormat:@"%@",[df stringFromDate:newDate]];
        holdStartTime=[df dateFromString:txtStart_StartTime.text];
        
    }
    else if ([strCheckMode isEqualToString:@"Start_SDateUIDatePickerModeDate"])
    {
        [df setDateFormat:@"MM-dd-yyyy"];
        txtStart_SDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.Date_Picker.date]];
        holdEndDate=[df dateFromString:txtStart_SDate.text];
    }
    else if ([strCheckMode isEqualToString:@"Start_StopTimeUIDatePickerModeTime"])
    {
        [df setDateFormat:@"hh:mm a"];
        txtStart_StopTime.text = [NSString stringWithFormat:@"%@",[df stringFromDate:newDate]];
        HoldEndTime=[NSDate dateWithTimeInterval:NSTimeIntervalSince1970 sinceDate:newDate];
        
    }
    else if ([strCheckMode isEqualToString:@"SetR_DateUIDatePickerModeDate"])
    {
        [df setDateFormat:@"MM-dd-yyyy"];
        txtSetR_Date.text = [NSString stringWithFormat:@"%@",[df stringFromDate:self.Date_Picker.date]];
        
    }
    else if ([strCheckMode isEqualToString:@"SetR_TimeUIDatePickerModeTime"])
    {
        [df setDateFormat:@"hh:mm a"];
        txtSetR_Time.text = [NSString stringWithFormat:@"%@",[df stringFromDate:newDate]];
    }
    
}
-(IBAction)DatePick_CancelAction:(id)sender
{
    if (resetScroll==YES)
    {
        [self.objScrollView setContentOffset:CGPointMake(0,holdTextField.center.y-Top_DownScroll) animated:YES];
    }
    self.viewDatePicker.hidden=YES;
    if ([strCheckMode isEqualToString:@"Select_UIDatePickerModeDate"])
    {
        txtSelect_Date.text=@"";
        
    }
    else if ([strCheckMode isEqualToString:@"Select_UIDatePickerModeTime"])
    {
        txtSelect_Time.text=@"";
        
    }
    else if ([strCheckMode isEqualToString:@"Star_FDateUIDatePickerModeDate"])
    {
        
        txtStart_FDate.text =@"";
        
    }
    else if ([strCheckMode isEqualToString:@"StartTime_UIDatePickerModeTime"])
    {
        
        txtStart_StartTime.text =@"";
        
    }
    else if ([strCheckMode isEqualToString:@"Start_SDateUIDatePickerModeDate"])
    {
        
        txtStart_SDate.text =@"";
    }
    else if ([strCheckMode isEqualToString:@"Start_StopTimeUIDatePickerModeTime"])
    {
        
        txtStart_StopTime.text =@"";
        
    }
    else if ([strCheckMode isEqualToString:@"SetR_DateUIDatePickerModeDate"])
    {
        
        txtSetR_Date.text =@"";
        
    }
    else if ([strCheckMode isEqualToString:@"SetR_TimeUIDatePickerModeTime"])
    {
        
        txtSetR_Time.text =@"";
        
    }
    
    
}
#pragma mark-Simple picker method

-(IBAction)Picker_AddAction:(id)sender
{
    if (resetScroll==YES)
    {
        [self.objScrollView setContentOffset:CGPointMake(0,holdTextField.center.y-Top_DownScroll) animated:YES];
    }
    self.viewDatePicker.hidden=YES;
    self.viewSimplePicker.hidden=YES;
    
    if ([strPickerMode isEqualToString:@"Select_Hours"])
    {
        txtSelect_Hours.text = strPickerHours;
        
    }
    else
    {
        txtSelect_Min.text = strPickerMin;
    }
}
-(IBAction)Picker_CancelAction:(id)sender
{
    if (resetScroll==YES)
    {
        [self.objScrollView setContentOffset:CGPointMake(0,holdTextField.center.y-Top_DownScroll) animated:YES];
    }
    self.viewDatePicker.hidden=YES;
    self.viewSimplePicker.hidden=YES;
    if ([strPickerMode isEqualToString:@"Select_Hours"])
    {
        txtSelect_Hours.text =@"0 hours";
        
    }
    else
    {
        txtSelect_Min.text =@"0 minutes";
    }
}
#pragma mark-Simple picker Delegate Method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component
{
    if ([strPickerMode isEqualToString:@"Select_Hours"])
    {
        return [hoursArray count];
        
    }
    else
    {
        return [minsArray count];
        
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if ([strPickerMode isEqualToString:@"Select_Hours"])
    {
        return  [hoursArray objectAtIndex:row];
        
    }
    else
    {
        return  [minsArray objectAtIndex:row];
        
    }
}

#pragma mark -PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if ([strPickerMode isEqualToString:@"Select_Hours"])
    {
        strPickerHours = [[NSString alloc] initWithFormat:@"%@",[hoursArray objectAtIndex:row]];
    }
    else
    {
        strPickerMin = [[NSString alloc] initWithFormat:@"%@",[minsArray objectAtIndex:row]];
    }
    
}
#pragma mark TextView Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    if(self.txtEventDesc.text.length==0)
    {
        self.lblPlaceHolderSet.hidden = NO;
    }
    else
    {
        self.lblPlaceHolderSet.hidden = YES;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        if(self.txtEventDesc.text.length == 0)
        {
            self.lblPlaceHolderSet.hidden = NO;
        }
        else
        {
            self.lblPlaceHolderSet.hidden = YES;
        }
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    lblPlaceHolderSet.hidden = YES;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
	return YES;
}
-(IBAction)ShowPickerAction:(id)sender
{
    //  int SenderTag=;
    UIButton *button = (UIButton *)sender;
    int bTag = button.tag;
    if (bTag==1)
    {
        self.viewSimplePicker.hidden=YES;
        self.viewDatePicker.hidden=NO;
        strCheckMode=@"Select_UIDatePickerModeDate";
        self.Date_Picker.datePickerMode = UIDatePickerModeDate;
        return;
    }
    else if (bTag==2)
    {
        self.viewSimplePicker.hidden=YES;
        self.viewDatePicker.hidden=NO;
        strCheckMode=@"Select_UIDatePickerModeTime";
        self.Date_Picker.datePickerMode = UIDatePickerModeTime;
        self.Date_Picker.minuteInterval=5;
        return;
    }
    else if (bTag==3)
    {
        self.viewDatePicker.hidden=YES;
        self.viewSimplePicker.hidden=NO;
        strPickerHours=@"0 hours";
        strPickerMode=@"Select_Hours";
        [pickerView reloadAllComponents];
        return;
    }
    else if (bTag==4)
    {
        self.viewDatePicker.hidden=YES;
        self.viewSimplePicker.hidden=NO;
        strPickerMin=@"0 minutes";
        strPickerMode=@"Select_Minutes";
        [pickerView reloadAllComponents];
        return;
    }
    else if (bTag==101)
    {
        self.viewDatePicker.hidden=NO;
        self.viewSimplePicker.hidden=YES;
        strCheckMode=@"Star_FDateUIDatePickerModeDate";
        self.Date_Picker.datePickerMode = UIDatePickerModeDate;
        
        return;
    }
    
    else if (bTag==102)
    {
        self.viewSimplePicker.hidden=YES;
        self.viewDatePicker.hidden=NO;
        strCheckMode=@"StartTime_UIDatePickerModeTime";
        self.Date_Picker.datePickerMode = UIDatePickerModeTime;
        self.Date_Picker.minuteInterval=5;
        // [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+80) animated:YES];
        //  [textField resignFirstResponder];
        return;
    }
    else if (bTag==103)
    {
        self.viewDatePicker.hidden=NO;
        self.viewSimplePicker.hidden=YES;
        strCheckMode=@"Start_SDateUIDatePickerModeDate";
        self.Date_Picker.datePickerMode = UIDatePickerModeDate;
        return;
    }
    else if (bTag==104)
    {
        self.viewSimplePicker.hidden=YES;
        self.viewDatePicker.hidden=NO;
        strCheckMode=@"Start_StopTimeUIDatePickerModeTime";
        self.Date_Picker.datePickerMode = UIDatePickerModeTime;
        self.Date_Picker.minuteInterval=5;
        return;
    }
    else if (bTag==201)
    {
        self.viewDatePicker.hidden=NO;
        self.viewSimplePicker.hidden=YES;
        
        strCheckMode=@"SetR_DateUIDatePickerModeDate";
        self.Date_Picker.datePickerMode = UIDatePickerModeDate;
        // [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+125) animated:YES];
        return;
        
    }
    else if (bTag==202)
    {
        self.viewSimplePicker.hidden=YES;
        self.viewDatePicker.hidden=NO;
        strCheckMode=@"SetR_TimeUIDatePickerModeTime";
        self.Date_Picker.datePickerMode = UIDatePickerModeTime;
        self.Date_Picker.minuteInterval=5;
        return;
        
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    resetScroll=NO;
    strCheckMode=nil;
    //activeField = textField;
    
    holdTextField=textField;
    if (textField==self.txtEventName)
    {
        [textField becomeFirstResponder];
        
    }
    else
    {
        [textField resignFirstResponder];
        
    }
    if (textField==txtSelect_Date)
    {
        self.viewSimplePicker.hidden=YES;
        self.viewDatePicker.hidden=NO;
        strCheckMode=@"Select_UIDatePickerModeDate";
        self.Date_Picker.datePickerMode = UIDatePickerModeDate;
        [textField resignFirstResponder];
    }
    else if (textField==txtSelect_Time)
    {
        Top_DownScroll=30;
        self.viewSimplePicker.hidden=YES;
        self.viewDatePicker.hidden=NO;
        
        strCheckMode=@"Select_UIDatePickerModeTime";
        self.Date_Picker.datePickerMode = UIDatePickerModeTime;
        self.Date_Picker.minuteInterval=5;
        [textField resignFirstResponder];
        
        resetScroll=YES;
        [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+Top_DownScroll) animated:YES];
        
    }
    else if (textField==txtSelect_Hours)
    {
        Top_DownScroll=45;
        self.viewDatePicker.hidden=YES;
        self.viewSimplePicker.hidden=NO;
        strPickerHours=@"0 hours";
        strPickerMode=@"Select_Hours";
        [pickerView reloadAllComponents];
        [textField resignFirstResponder];
        
        resetScroll=YES;
        [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+Top_DownScroll) animated:YES];
    }
    else if (textField==txtSelect_Min)
    {
        Top_DownScroll=45;
        self.viewDatePicker.hidden=YES;
        self.viewSimplePicker.hidden=NO;
        strPickerMin=@"0 minutes";
        strPickerMode=@"Select_Minutes";
        [pickerView reloadAllComponents];
        
        resetScroll=YES;
        [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+Top_DownScroll) animated:YES];
        
        [textField resignFirstResponder];
    }
    else if (textField==txtStart_FDate)
    {
        Top_DownScroll=30;
        resetScroll=YES;
        [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+Top_DownScroll) animated:YES];
        
        self.viewDatePicker.hidden=NO;
        self.viewSimplePicker.hidden=YES;
        
        strCheckMode=@"Star_FDateUIDatePickerModeDate";
        self.Date_Picker.datePickerMode = UIDatePickerModeDate;
        [textField resignFirstResponder];
    }
    else if (textField==txtStart_StartTime)
    {
        Top_DownScroll=30;
        resetScroll=YES;
        [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+Top_DownScroll) animated:YES];
        
        self.viewSimplePicker.hidden=YES;
        self.viewDatePicker.hidden=NO;
        strCheckMode=@"StartTime_UIDatePickerModeTime";
        self.Date_Picker.datePickerMode = UIDatePickerModeTime;
        self.Date_Picker.minuteInterval=5;
        [textField resignFirstResponder];
        
    }
    else if (textField==txtStart_SDate)
    {
        Top_DownScroll=40;
        resetScroll=YES;
        [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+Top_DownScroll) animated:YES];
        
        self.viewDatePicker.hidden=NO;
        self.viewSimplePicker.hidden=YES;
        strCheckMode=@"Start_SDateUIDatePickerModeDate";
        self.Date_Picker.datePickerMode = UIDatePickerModeDate;
        [textField resignFirstResponder];
    }
    else if (textField==txtStart_StopTime)
    {
        Top_DownScroll=45;
        resetScroll=YES;
        [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+Top_DownScroll) animated:YES];
        
        self.viewSimplePicker.hidden=YES;
        self.viewDatePicker.hidden=NO;
        strCheckMode=@"Start_StopTimeUIDatePickerModeTime";
        self.Date_Picker.datePickerMode = UIDatePickerModeTime;
        self.Date_Picker.minuteInterval=5;
        [textField resignFirstResponder];
        
    }
    else if (textField==txtSetR_Date)
    {
        
        Top_DownScroll=30;
        resetScroll=YES;
        [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+Top_DownScroll) animated:YES];
        self.viewDatePicker.hidden=NO;
        self.viewSimplePicker.hidden=YES;
        strCheckMode=@"SetR_DateUIDatePickerModeDate";
        self.Date_Picker.datePickerMode = UIDatePickerModeDate;
        [textField resignFirstResponder];
    }
    else if (textField==txtSetR_Time)
    {
        Top_DownScroll=30;
        resetScroll=YES;
        [self.objScrollView setContentOffset:CGPointMake(0,textField.center.y+Top_DownScroll) animated:YES];
        
        self.viewSimplePicker.hidden=YES;
        self.viewDatePicker.hidden=NO;
        strCheckMode=@"SetR_TimeUIDatePickerModeTime";
        self.Date_Picker.datePickerMode = UIDatePickerModeTime;
        self.Date_Picker.minuteInterval=5;
        [textField resignFirstResponder];
    }
}

#pragma mark-CreateNewEventAction method

-(IBAction)CreateNewEventAction:(id)sender
{
    strEventName = [self.txtEventName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strEventDesc = [self.txtEventDesc.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!(strEventName.length > 0) || (strEventName.length > 100))
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an Name Of Event" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else if(!(strEventDesc.length>0) || (strEventDesc.length>1500))
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an Event Description" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    if ([self.strCheckEvent isEqualToString:@"SelectLengthEvent"])
    {
        [self OnCreate_Select_EventAction];
    }
    else if ([self.strCheckEvent isEqualToString:@"StartAndStopEvent"])
    {
        [self OnCreate_StartAndStop_EventAction];
    }
    else if ([self.strCheckEvent isEqualToString:@"SetReminderEvent"])
    {
        [self OnCreate_SetReminder_EventAction];
    }
    
}
#pragma Mark-OnCreate_Select_EventAction
-(void)OnCreate_Select_EventAction
{
    NSString *strSelect_Date = [txtSelect_Date.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strSelect_Time = [txtSelect_Time.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strSelect_Hours = [txtSelect_Hours.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strSelect_Min = [txtSelect_Min.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(!(strSelect_Date.length>0))
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an Date" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    else if(!(strSelect_Time.length>0))
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an Time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    else if(!(strSelect_Hours.length>0))
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an Hours" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    else if( [strSelect_Hours isEqualToString:@"0 hours"]&& [strSelect_Min isEqualToString:@"0 minutes"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an event length longer than 0" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    else if(!(strSelect_Min.length>0))
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an Minutes" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    else if( [strSelect_Hours isEqualToString:@"0 hours"]&& [strSelect_Min isEqualToString:@"0 minutes"])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an event length longer than 0" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString *strSelectNewDate=[MyUtility dateFormateSet:strSelect_Date];
    NSString *strTime=[MyUtility TimeFormateSet:strSelect_Time];
    NSString * strEventUpdateDate=[NSString stringWithFormat:@"%@ %@",strSelectNewDate,strTime];
    strSelect_Hours=[MyUtility Replece_hours:strSelect_Hours];
    strSelect_Min=[MyUtility Replece_Minutes:strSelect_Min];
    NSString * strUpdateEventLength=[MyUtility OnStartTimeSet:strSelect_Hours Min:strSelect_Min];
    
    
    [self OnServiceCallCreateEvent_SETEventDate:strEventUpdateDate SETEventLength:strUpdateEventLength];
    
}
#pragma Mark-StartAndStop_EventAction
-(void)OnCreate_StartAndStop_EventAction
{
    NSString *strStart_FDate = [txtStart_FDate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strStart_Time = [txtStart_StartTime.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strStart_SDate = [txtStart_SDate.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strStart_StopTime = [txtStart_StopTime.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(!(strStart_FDate.length>0))
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an Date" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    else if(!(strStart_Time.length>0))
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an Time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    else if(!(strStart_SDate.length>0))
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an Date" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
        
    }
    
    else if(!(strStart_StopTime.length>0))
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an Time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"MM-dd-yyyy"];//--> this line first set type of formate to compare
    NSDate *date1 = [formate dateFromString:strStart_FDate];//-->first date
    NSDate *date2 = [formate dateFromString:strStart_SDate];//-->second date
    NSComparisonResult result = [date1 compare:date2];
    switch (result)
    {
        case NSOrderedAscending:
        {
        }
            break;
            
        case NSOrderedDescending:
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS " message:@"You forgot to enter an event after your event start date" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
        case NSOrderedSame:
        {
            
            NSDateFormatter *formate2 = [[NSDateFormatter alloc] init];
            [formate2 setDateFormat:@"HH:mm a"];//--> this line first set type of formate to compare
            NSDate *date11 = [formate2 dateFromString:strStart_Time];//-->first date
            NSDate *date21 = [formate2 dateFromString:strStart_StopTime];//-->second date
            NSComparisonResult result = [date11 compare:date21];
            
            switch (result) {
                case NSOrderedAscending:
                {
                    //end time is grater then start time
                }
                    
                    break;
                case NSOrderedSame:
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS " message:@"Please make sure start time should not equal to end time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                    return;
                    // end timew is same as start time
                }
                    break;
                case NSOrderedDescending:
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS " message:@"Please make sure start time should not greater then end time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                    [alert show];
                    return;
                    // end time is less then start itme
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default: NSLog(@"erorr dates %@, %@", date2, date1); break;
    }
    NSString *strSelectNewDate=[MyUtility dateFormateSet:strStart_FDate];
    NSString *strTime=[MyUtility TimeFormateSet:strStart_Time];
    NSString * strEventUpdateDate=[NSString stringWithFormat:@"%@ %@",strSelectNewDate,strTime];
    NSString *strSelectNewDate1=[MyUtility dateFormateSet:strStart_SDate];
    NSString *strTime1=[MyUtility TimeFormateSet:strStart_StopTime];
    NSString * strEventUpdateDate1=[NSString stringWithFormat:@"%@ %@",strSelectNewDate1,strTime1];
    NSString *str_length=[MyUtility FirstDate:strEventUpdateDate SecondDate:strEventUpdateDate1];
    [self OnServiceCallCreateEvent_SETEventDate:strEventUpdateDate SETEventLength:str_length];
    
}


#pragma Mark-OnCreate_SetReminder_EventAction
-(void)OnCreate_SetReminder_EventAction
{
    NSString *strSetR_Date = [txtSetR_Date.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strSetR_Time = [txtSetR_Time.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if(!(strSetR_Date.length>0))
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an Date" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    else if(!(strSetR_Time.length>0))
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS" message:@"You forgot to enter an Time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString *strNewSetR_Date=[MyUtility dateFormateSet:strSetR_Date];
    NSString *strTime=[MyUtility TimeFormateSet:strSetR_Time];
    NSString * strEventUpdateDate=[NSString stringWithFormat:@"%@ %@",strNewSetR_Date,strTime];
    NSString *strEventUpdateLength=@"5";
    [self OnServiceCallCreateEvent_SETEventDate:strEventUpdateDate SETEventLength:strEventUpdateLength];
    
}
-(void)OnServiceCallCreateEvent_SETEventDate:(NSString *)str_Date SETEventLength:(NSString *)strE_Length
{
    @try {
       
        NSString *webserviceType;
        NSDictionary *parameters=nil;
        NSString *AlertTitle;
        NSString *alertMessage;
        if ([objAppDelegate.type_cal isEqual:@"Edit"])
        {
            AlertTitle=@"Edited Event";
            alertMessage=@"Event updated successfully";
            parameters = @{@"event_key":[_dicEventDetail objectForKey:@"event_key"],@"user_email":strUserId,@"cal_key":strUserPrivate,@"event_name":strEventName,@"event_descrip":strEventDesc,@"event_date":str_Date,@"event_length":strE_Length,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
            
            webserviceType=@"editSimpleEvent.php";
        }
        else
        {
            AlertTitle=@"Created Event";
            alertMessage=@"Event created successfully";
            
            parameters = @{@"user_email":strUserId,@"cal_key":strUserPrivate,@"event_name":strEventName,@"event_descrip":strEventDesc,@"event_date":str_Date,@"event_length":strE_Length,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
            
            webserviceType=@"createSimpleEvent.php";
        }
        /*
         Edit Simple Event-http://www.zuntik.com/API/V1/editSimpleEvent.php
         Create Simple Event-http://www.zuntik.com/API/V1/createSimpleEvent.php
         POST['user_email']
         POST['cal_key']
         POST['event_name']
         POST['event_descrip']
         POST['event_date']
         POST['event_length']
         POST['APIAccount']
         POST['APIPassword']*/
        [self MbProcessHud];//ProcessHud
        
        [ZuntikServicesVC PostMethodWithApiMethod:webserviceType Withparms:parameters WithSuccess:^(id response)
         {
             NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
             dicResponse=[response JSONValue];
             
             NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
             NSString *strMassage=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"message"]];
             
             if ([strSuccess isEqualToString:@"1"])
             {
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AlertTitle message:alertMessage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 alert.tag=101;
                 [alert show];
             }
             else
             {
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AlertTitle message:strMassage delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                 [alert show];
                 
             }
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
         }
                                          failure:^(NSError *error)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
         }];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
    }
}
-(void)MbProcessHud
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==101)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// new work
-(void)SetasReminder
{
    self.objScrollView.scrollEnabled = YES;
    [btnSetRemind setSelected:YES];
    
    if ([btnSetRemind isSelected])
    {
        [btnSetRemind setBackgroundColor:[UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1]];
        [btnSelectLength setBackgroundColor:[UIColor clearColor]];
        [btnStartStop setBackgroundColor:[UIColor clearColor]];
        
        
        btnSelectLength.titleLabel.textColor = [UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1];
        
        btnStartStop.titleLabel.textColor = [UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1];
        
        btnSetRemind.titleLabel.textColor = [UIColor whiteColor];
        
        [btnSetRemind setSelected:NO];
        
    }
    else
    {
        
        [btnSetRemind setSelected:YES];
        
    }
    self.strCheckEvent=@"SetReminderEvent";
    viewSelectedLength.hidden=YES;
    ViewStartStop.hidden=YES;
    [self.view sendSubviewToBack:viewSelectedLength];
    [self.view sendSubviewToBack:ViewStartStop];
    
    ViewSetRemind.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.3 animations:^{
        ViewSetRemind.transform = CGAffineTransformIdentity;
        ViewSetRemind.hidden=NO;
        [self.view bringSubviewToFront:ViewSetRemind];
        
    } completion:^(BOOL finished) {
    }];
    
    // [self.objScrollView setContentSize:CGSizeMake(0, 10)];
}
-(void)StartAndStopAction
{
    self.objScrollView.scrollEnabled=TRUE;
    
    btnStartStop.selected=YES;
    
    if ([btnStartStop isSelected]) {
        
        [btnStartStop setBackgroundColor:[UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1]];
        [btnSelectLength setBackgroundColor:[UIColor clearColor]];
        [btnSetRemind setBackgroundColor:[UIColor clearColor]];
        
        btnSelectLength.titleLabel.textColor = [UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1];
        
        btnSetRemind.titleLabel.textColor = [UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1];
        
        btnStartStop.titleLabel.textColor = [UIColor whiteColor];
        
        btnStartStop.selected=NO;
        
    }
    else
    {
        btnStartStop.selected=YES;
    }
    
    
    self.strCheckEvent=@"StartAndStopEvent";
    viewSelectedLength.hidden=YES;
    ViewSetRemind.hidden=YES;
    
    [self.view sendSubviewToBack:viewSelectedLength];
    [self.view sendSubviewToBack:ViewSetRemind];
    
    ViewStartStop.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.3 animations:^{
        ViewStartStop.transform = CGAffineTransformIdentity;
        ViewStartStop.hidden=NO;
        [self.view bringSubviewToFront:ViewStartStop];
        
    } completion:^(BOOL finished) {
    }];
    
    [self.objScrollView setContentSize:CGSizeMake(0, 94)];
}
-(void)SetasLength
{
    btnSelectLength.selected=YES;
    self.objScrollView.scrollEnabled=YES;
    
    if ([btnSelectLength isSelected])
    {
        [btnSelectLength setBackgroundColor:[UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1]];
        [btnStartStop setBackgroundColor:[UIColor clearColor]];
        [btnSetRemind setBackgroundColor:[UIColor clearColor]];
        
        btnSetRemind.titleLabel.textColor = [UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1];
        
        btnStartStop.titleLabel.textColor = [UIColor colorWithRed:71/255.0 green:180/255.0 blue:136/255.0 alpha:1];
        
        btnSelectLength.titleLabel.textColor = [UIColor whiteColor];
        
        btnSelectLength.selected=NO;
    }
    else
    {
        btnSelectLength.selected=YES;
    }
    
    
    self.strCheckEvent=@"SelectLengthEvent";
    
    ViewStartStop.hidden=YES;
    ViewSetRemind.hidden=YES;
    
    [self.view sendSubviewToBack:ViewStartStop];
    [self.view sendSubviewToBack:ViewSetRemind];
    
    viewSelectedLength.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.3 animations:^{
        viewSelectedLength.transform = CGAffineTransformIdentity;
        viewSelectedLength.hidden=NO;
        [self.view bringSubviewToFront:viewSelectedLength];
    } completion:^(BOOL finished) {
    }];
    
    [self.objScrollView setContentSize:CGSizeMake(0, 45)];
}
@end
