//
//  SettingNotificationVC.m
//  Zuntik
//
//  Created by Dev-Mac on 29/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "SettingNotificationVC.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
@interface SettingNotificationVC ()

@end

@implementation SettingNotificationVC
@synthesize arrForResponse,minsArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    [self swrevelButton];
    self.navigationController.navigationBarHidden=YES;
    self.viewSimplePicker.hidden=YES;

    self.arrForResponse=[[NSMutableArray alloc]init];
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    strUserId=[userDefaults valueForKey:@"UserId"];
     minsArray = [[NSMutableArray alloc] initWithObjects:@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"35 ",@"40 ",@"45 ",@"50",@"55",@"60", nil];
    objDatabase = [DataBaseManagement Connetion];//Database Connection
    [self ONDataBaseEventsValue];

}
#pragma mark -swrevelButton Add
-(void)swrevelButton
{
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    UIButton *btnLeft=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44 , 44)];
    [btnLeft setImage:[UIImage imageNamed:@"reveal-icon.png"]forState:UIControlStateNormal];
    [btnLeft addTarget:revealController action:@selector(revealToggle:)
      forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnLeft];
}
#pragma mark - OnDatabase Get Method

//OnDatabase Get Method
-(void)ONDataBaseEventsValue
{
    //Get All Subscriptions’ Data
    NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
    dicResponse= [objDatabase eventInfoList:strUserId]; //Database Method
    NSString *stractivate=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
    if ([stractivate isEqualToString:@"1"])
    {
        self.arrForResponse=[dicResponse valueForKey:@"newEvents"];
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
   
        return [minsArray count];
   
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
   
        return  [minsArray objectAtIndex:row];
        
   
}

#pragma mark -PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
   
       strPickerMin = [[NSString alloc] initWithFormat:@"%@",[minsArray objectAtIndex:row]];
  
    
}
-(IBAction)DoneAction:(id)sender
{
    lblMin.text=strPickerMin;
    self.viewSimplePicker.hidden=YES;
   
    
    
}
-(IBAction)CancelAction:(id)sender
{
    strPickerMin=@"0";
     lblMin.text=strPickerMin;
    self.viewSimplePicker.hidden=YES;

    
}
-(IBAction)SetTime:(id)sender
{
    
    self.viewSimplePicker.hidden=NO;

}
-(IBAction)SetNotification:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for (int i=0;i<[arrForResponse count] ; i++)
    {
        NSMutableDictionary * dicData=[arrForResponse objectAtIndex:i];
        NSDate *date = [dateFormatter dateFromString:[dicData valueForKey:@"event_date"]];
        int time=[strPickerMin intValue];
        
       datePlusOneMinute = [NSDate dateWithTimeInterval:-60*time sinceDate:date];
        
        NSDate * today = [NSDate date];
        NSComparisonResult result = [today compare:datePlusOneMinute];
        
        if(result == NSOrderedAscending  || result == NSOrderedSame)
        {
            [MyUtility scheduleNotification:[dicData valueForKey:@"event_name"] withDate:datePlusOneMinute];
        }
        switch (result)
        {
            case NSOrderedAscending:
                NSLog(@"Future Date");
                break;
            case NSOrderedDescending:
                NSLog(@"Earlier Date");
                break;
            case NSOrderedSame:
                NSLog(@"Today/Null Date Passed"); //Not sure why This is case when null/wrong date is passed
                break;
            default:
                NSLog(@"Error Comparing Dates");
                break;
        }
    }
}
- (void)clearNotification {
	
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
