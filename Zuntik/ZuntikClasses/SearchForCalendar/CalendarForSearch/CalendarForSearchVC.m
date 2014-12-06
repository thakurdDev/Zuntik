//
//  CalendarForSearchVC.m
//  Zuntik
//
//  Created by Dev-Mac on 30/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "CalendarForSearchVC.h"
#import "DSLCalendarView.h"
#import "DSLCalendarDayView.h"
#import "DSLCalendarMonthView.h"
#import "Reachability.h"
#import "ZuntikServicesVC.h"
#import "JSON.h"
#import "MBProgressHUD.h"
#import "CustomCell.h"
#import "MycalendarEventDetailVC.h"

@interface CalendarForSearchVC ()<DSLCalendarViewDelegate>
{
     NSString *OldEventDateinSection;
    BOOL event_list_open;
}
@property (weak, nonatomic) IBOutlet UIButton *buttonEvent;

@property (strong, nonatomic) IBOutlet UILabel *lblEventReadonly;
@property (strong, nonatomic) IBOutlet UIView *viewForTable;

@property (strong, nonatomic) IBOutlet UIImageView *imageeventnumber;
@property (strong, nonatomic) IBOutlet UILabel *lblNodateselected;
@property (nonatomic, weak) IBOutlet DSLCalendarView *calendarView;
@end


NSDateFormatter *df;
int selectedMonth,selectedYear;

@implementation CalendarForSearchVC
@synthesize arrForResponse;
@synthesize strCal_key,strCal_Name;
@synthesize arrForListData,tblCal_Events;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark hide and show lbls according to event
-(void)hideAndShowEventobjects:(BOOL)check
{
    if (check==YES)
    {
        _viewForTable.hidden=YES;
        _imageeventnumber.hidden=YES;
        _lblNodateselected.hidden=NO;
        _lblEventReadonly.hidden=YES;
        lblEventCount.hidden=YES;
    }
    else
    {
        _viewForTable.hidden=NO;
        _imageeventnumber.hidden=NO;
        _lblNodateselected.hidden=YES;
        _lblEventReadonly.hidden=NO;
        lblEventCount.hidden=NO;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.tblCal_Events.contentInset =  UIEdgeInsetsMake(0.1f, 0.0f, 0.0f, 0.0);
    
    // Do any additional setup after loading the view from its nib.
    self.calendarView.delegate = self;
    btncheckValue.selected=NO;
    objAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    userDefaults = [NSUserDefaults standardUserDefaults];
    strUserId=[userDefaults valueForKey:@"UserId"];
    arrForResponse=[[NSMutableArray alloc]init];
    arrForListData=[[NSMutableArray alloc]init];
    self.viewDetailShow.frame=CGRectMake(0,  self.calendarView.frame.size.height+64, 320, 54);
    self.tblCal_Events.frame=CGRectMake(10, self.viewDetailShow.frame.size.height+self.viewDetailShow.frame.origin.y, 300, 143);
    lblHeader.text=[NSString stringWithFormat:@"Calendar: %@",strCal_key];
    objDatabase = [DataBaseManagement Connetion];//Database Connection

    [self DateFormateSet]; //DateFarmate Set(1)
      [self hideAndShowEventobjects:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self CheckNetwork];//DateFarmate Set(2)
}
-(void)MBProgressHUDMethod
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please wait...";
    hud.dimBackground = YES;
}
-(IBAction)BackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -DateFormateSet Add

-(void)DateFormateSet //Date Formate Set(2)
{
    df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"M/d/YYYY"];
}
#pragma mark CheckNetwork
-(void)CheckNetwork  //Network Check(1)
{
    Reachability *reachTest = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachTest  currentReachabilityStatus];
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        
        [self ONDataBaseEventsValue];
    }
    else
    {
        [self ONserverEventsValue];
        
    }
    
}

#pragma mark - OnDatabase Get Method

//OnDatabase Get Method
-(void)ONDataBaseEventsValue
{
    @try {
        [self.arrForResponse removeAllObjects];
        //Get All Subscriptions’ Data
        NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
        dicResponse= [objDatabase eventInfoList_Calendar:strCal_key]; //Database Method
        NSString *stractivate=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
        if ([stractivate isEqualToString:@"1"])
        {
            self.arrForResponse=[dicResponse valueForKey:@"events"];
        }
        [self showDataonCalender]; //Show Calender Method
        
        [MyUtility GetAllevent:self.arrForResponse];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
    }
    
}

#pragma mark -OnServer Get response Method

-(void)ONserverEventsValue
{ [self MBProgressHUDMethod];
    NSDictionary *parameters = @{@"cal_key":strCal_key,@"APIAccount":@"ZuntikAppAPIUser",@"APIPassword":@"n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1"};
    [ZuntikServicesVC PostMethodWithApiMethod:@"returnCalEvents.php" Withparms:parameters WithSuccess:^(id response)
     {
         NSMutableDictionary *dicResponse=[[NSMutableDictionary alloc]init];
         dicResponse=[response JSONValue];
         NSString *strSuccess=[NSString stringWithFormat:@"%@",[dicResponse valueForKey:@"success"]];
         if ([strSuccess isEqualToString:@"1"])
         {
             [objDatabase deleteEventsCalsData_Cal_id:strCal_key];  //delete data on database on userid
             self.arrForResponse=[dicResponse valueForKey:@"events"];
             for (int i=0;i<[self.arrForResponse count] ; i++)
             {
                 NSMutableDictionary *dicData=[self.arrForResponse objectAtIndex:i];
                 [objDatabase addUsernewEvents:dicData];
                 
             }
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [self ONDataBaseEventsValue]; //Show Calender Method
             
             
         }
     }
    failure:^(NSError *error)
     {
     }];
    
    
}
#pragma mark- Show Calender date Method

-(void)showDataonCalender
{
    NSArray *arrMonths = self.calendarView.subviews;
    arrMonths = [[arrMonths objectAtIndex:1] subviews];
    for (DSLCalendarMonthView *monthView in arrMonths)
    {
        NSArray *arrayDays = monthView.subviews;
        for (int i=0; i < [arrayDays count]; i++)
        {
            UIView *view = [arrayDays objectAtIndex:i];
            if (view == nil)
            {
                continue;
            }
            if ([view isKindOfClass:[DSLCalendarMonthView class]])
            {
                
                for (int j=0; j < [view.subviews count]; j++)
                {
                    UIView *viewDay = [view.subviews objectAtIndex:j];
                    if ([viewDay isKindOfClass:[DSLCalendarDayView class]] && ((DSLCalendarDayView*)viewDay).inCurrentMonth)
                    {
                        NSString *strAttendence = [self GetEventsStatus:((DSLCalendarDayView*)viewDay).dayAsDate];
                        ((DSLCalendarDayView*)viewDay).labelAttendence = strAttendence;
                        [((DSLCalendarDayView*)viewDay) setNeedsDisplay];
                        
                    }
                }
                
            }
        }
    }
    
}
#pragma mark- GetEventsStatus show point date Method

-(NSString*)GetEventsStatus:(NSDate*)CDate
{
    NSString *strAttendence = @"nil";
    NSString *calenderDate = [df stringFromDate:CDate];
    for (int i=0; i < [self.arrForResponse count]; i++)
    {
        NSMutableDictionary *mdictAttendence = [self.arrForResponse objectAtIndex:i];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:[mdictAttendence valueForKey:@"event_date"]];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"M/d/YYYY"];
        NSString *newDateString = [dateFormatter2 stringFromDate:date];
        
        if ([newDateString isEqualToString:calenderDate])
        {
            strAttendence = @"•";
        }
    }
    return strAttendence;
}
#pragma mark- GetEventsStatus show list
-(NSMutableArray*)GetDayStatus:(NSString*)CDate
{
    NSMutableDictionary *mdictDay=[[NSMutableDictionary alloc]init];
    NSMutableArray *arryList=[[NSMutableArray alloc]init];
    NSString *calenderDate =CDate ;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    DicForUserDetails=objAppDelegate.AppDicUserInfo;
    
    NSString *strUserPrivate=[DicForUserDetails valueForKey:@"private_cal"];
    
    for (int i=0; i < [self.arrForResponse count]; i++)
    {
        NSMutableDictionary *mdictAttendence = [self.arrForResponse objectAtIndex:i];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:[mdictAttendence valueForKey:@"event_date"]];
        NSString *newDateString = [df stringFromDate:date];
        if ([newDateString isEqual:[NSNull null]]) {
            
        }
        else
        {
        if ([newDateString isEqualToString:calenderDate])
        {
            
            NSString *EventDate_str=[NSString stringWithFormat:@"%@",[[self.arrForResponse objectAtIndex:i] objectForKey:@"event_date"]];
            mdictDay = [self.arrForResponse objectAtIndex:i];
            NSString *strCurrentDate=[MyUtility getoriginalCurrentDate:YES andDateString:EventDate_str]; //DateFormate Current full Date Add
            NSString *strdate_Year=[MyUtility getoriginalCurrentDate:NO andDateString:EventDate_str];//Date Formate Date And Year
            NSString *strTime=[MyUtility OnTimeDuretionFormateset:date Add:[mdictAttendence valueForKey:@"event_length"]]; //time durection Add
            NSString *strDuretionValue=[MyUtility OnHour_Min_Sec:[mdictAttendence valueForKey:@"event_length"] AndDate:[mdictAttendence valueForKey:@"event_date"]];
            if ([strDuretionValue isEqualToString:@"5 mins"]||[strDuretionValue isEqualToString:@"-5 mins"])
            {
                strDuretionValue=@"Reminder";
            }
            NSString *strStartTime=[MyUtility OnStartTime:date];
            NSString *strcal_key=[mdictDay valueForKey:@"cal_key"];
            BOOL setSubscription= [objDatabase getSubscriptionsDataCheck:strcal_key userId:strUserId];
            BOOL setCreated=[objDatabase getUsercreatedCalsData:strcal_key userId:strUserId];
            
            if (setSubscription==YES)
            {
                [mdictDay setObject:strCal_Name forKey:@"cal_name"];
                [mdictDay setObject:strStartTime forKey:@"StartTime"];
                [mdictDay setObject:strDuretionValue forKey:@"Duretionlength"];
                [mdictDay setObject:strTime forKey:@"Time"];
                [mdictDay setObject:strdate_Year forKey:@"date_Year"];
                [mdictDay setObject:strCurrentDate forKey:@"CurrentDate"];
                [mdictDay setObject:@"Subscribed" forKey:@"Type"];
                [arryList addObject:mdictDay];
            }
            else if (setCreated==YES)
            {
                [mdictDay setObject:strCal_Name forKey:@"cal_name"];
                [mdictDay setObject:strStartTime forKey:@"StartTime"];
                [mdictDay setObject:strDuretionValue forKey:@"Duretionlength"];
                [mdictDay setObject:strTime forKey:@"Time"];
                [mdictDay setObject:strdate_Year forKey:@"date_Year"];
                [mdictDay setObject:strCurrentDate forKey:@"CurrentDate"];
                [mdictDay setObject:@"MyCalendar" forKey:@"Type"];
                [arryList addObject:mdictDay];
                
            }
            else if ([strCal_key isEqualToString:strUserPrivate])
            {
                [mdictDay setObject:strCal_Name forKey:@"cal_name"];
                [mdictDay setObject:strStartTime forKey:@"StartTime"];
                [mdictDay setObject:strDuretionValue forKey:@"Duretionlength"];
                [mdictDay setObject:strTime forKey:@"Time"];
                [mdictDay setObject:strdate_Year forKey:@"date_Year"];
                [mdictDay setObject:strCurrentDate forKey:@"CurrentDate"];
                [mdictDay setObject:@"Private" forKey:@"Type"];
                [arryList addObject:mdictDay];
                
            }
            else
            {
                [mdictDay setObject:strCal_Name forKey:@"cal_name"];
                [mdictDay setObject:strStartTime forKey:@"StartTime"];
                [mdictDay setObject:strDuretionValue forKey:@"Duretionlength"];
                [mdictDay setObject:strTime forKey:@"Time"];
                [mdictDay setObject:strdate_Year forKey:@"date_Year"];
                [mdictDay setObject:strCurrentDate forKey:@"CurrentDate"];
                [mdictDay setObject:@"Subscribed" forKey:@"Type"];
                [arryList addObject:mdictDay];
            }
            
        }
        }
    }
    return arryList;
}

#pragma mark - DSLCalendarViewDelegate methods

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range
{
    if (range != nil)
    {
        [self.arrForListData removeAllObjects];
        NSString *strDMD=[NSString stringWithFormat:@"%ld/%ld/%ld",(long)range.startDay.month,(long)range.startDay.day,(long)range.startDay.year];
        
        self.arrForListData= [self GetDayStatus:strDMD];
        lblEventCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)[self.arrForListData count]];
        lblDateShow.text=[MyUtility OndateaFormateset:strDMD];
        if (self.arrForListData.count>0)
        {
            [self hideAndShowEventobjects:NO];
            [self.tblCal_Events reloadData];
        }
        else
        {
            _lblNodateselected.text=@"No Event";
            [self hideAndShowEventobjects:YES];
        }
        tblCal_Events.frame=CGRectMake(10,0, 300, 143);
        tblCal_Events.backgroundColor=[UIColor clearColor];
        _viewForTable.frame=CGRectMake(0, self.viewDetailShow.frame.size.height+self.viewDetailShow.frame.origin.y, 320, 143);
        [self.tblCal_Events reloadData];
    }
}

- (DSLCalendarRange*)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range
{
    
    if (NO) { // Only select a single day
        return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
    }
    else if (NO)
    { // Don't allow selections before today
        NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
        NSDateComponents *startDate = range.startDay;
        NSDateComponents *endDate = range.endDay;
        
        if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
            return nil;
        }
        else
        {
            if ([self day:startDate isBeforeDay:today])
            {
                startDate = [today copy];
            }
            if ([self day:endDate isBeforeDay:today])
            {
                endDate = [today copy];
            }
            
            return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
        }
    }
    
    return range;
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration
{
    self.viewDetailShow.frame=CGRectMake(0, calendarView.frame.size.height+64, 320, 54);
    _viewForTable.frame=CGRectMake(0, self.viewDetailShow.frame.size.height+self.viewDetailShow.frame.origin.y, 320, 143);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month
{
    [self showDataonCalender];
}

- (BOOL)day:(NSDateComponents*)day1 isBeforeDay:(NSDateComponents*)day2
{
    return ([day1.date compare:day2.date] == NSOrderedAscending);
}
-(IBAction)AllCal_EventsAction:(id)sender
{
    
    if (event_list_open==NO)
    {
        
        [MyUtility GetAllevent:self.arrForResponse];

        event_list_open=YES;
        
        [self.arrForListData removeAllObjects];
        [self.arrForListData addObjectsFromArray:objAppDelegate.HoldEventArry];
        
        
        NSString *holdedStr;
        NSMutableArray *mainArray=[[NSMutableArray alloc]init];
        
        for (int i=0; i<objAppDelegate.HoldEventArry.count; i++)
        {
            NSMutableDictionary *SectionDictina=[[NSMutableDictionary alloc]init];
            
            NSString *current_str=[NSString stringWithFormat:@"%@",[[self.arrForListData objectAtIndex:i] objectForKey:@"section_name"]];
            
            if ([holdedStr isEqualToString:[NSString stringWithFormat:@"%@",current_str]])
            {
                
                
                NSMutableArray *readd=[[NSMutableArray alloc]initWithArray:[[mainArray lastObject] objectForKey:@"content"]];
                [readd addObject:[objAppDelegate.HoldEventArry objectAtIndex:i]];
                
                [SectionDictina setObject:current_str forKey:@"title"];
                [SectionDictina setObject:readd forKey:@"content"];
                
                [mainArray removeLastObject];
                holdedStr =[NSString stringWithFormat:@"%@",current_str];
                
            }
            else
            {
                NSMutableArray *RowArray=[[NSMutableArray alloc]init];
                [RowArray addObject:[objAppDelegate.HoldEventArry objectAtIndex:i]];
                
                [SectionDictina setObject:current_str forKey:@"title"];
                [SectionDictina setObject:RowArray forKey:@"content"];
                holdedStr =[NSString stringWithFormat:@"%@",current_str];
            }
            [mainArray addObject:SectionDictina];
        }
        
        
        [self.arrForListData removeAllObjects];
        [self.arrForListData addObjectsFromArray:mainArray];
        
        tblCal_Events.frame=CGRectMake(10,0,tblCal_Events.frame.size.width, 500);
        tblCal_Events.backgroundColor=[UIColor clearColor];
        _viewForTable.frame=CGRectMake(0,64,320, 500);
        
        [tblCal_Events reloadData];
        _viewForTable.hidden=NO;
        [_buttonEvent setBackgroundImage:[UIImage  imageNamed:@"list_switch.png"] forState:UIControlStateNormal];
        
        for (int i=0; i<self.arrForListData.count; i++)
        {
            NSString *str=[NSString stringWithFormat:@"%@",[[self.arrForListData objectAtIndex:i]objectForKey:@"title"]];
            
            if ([str hasPrefix:@"Today"])
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
                [tblCal_Events scrollToRowAtIndexPath:indexPath
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:YES];
            }
        }
        
        
        
    }
    else
    {
        
        [self.arrForListData removeAllObjects];
        [self.arrForListData addObjectsFromArray:objAppDelegate.HoldEventArry];
        event_list_open=NO;
        
        [_buttonEvent setBackgroundImage:[UIImage  imageNamed:@"cal_switch.png"] forState:UIControlStateNormal];
        _viewForTable.hidden=YES;
        [tblCal_Events reloadData];
        
    }
}
-(IBAction)EventAdd:(id)sender
{
    //    NewEventVC *objNewEventVC = [[NewEventVC alloc]initWithNibName:@"NewEventVC" bundle:nil];
    //    [self.navigationController pushViewController:objNewEventVC animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableData Source and delegate
#pragma mark table section
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    if (event_list_open==YES)
    {
        return self.arrForListData.count;
    }
    else
    {
        return 1;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (event_list_open==YES)
    {
        return 40.0f;
    }
    else
    {
        return 0.1f;
    }
}
- (NSString*) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
    if (event_list_open==YES)
    {
        return [[self.arrForListData objectAtIndex:section] objectForKey:@"title"];
    }
    else
    {
        return nil;
        
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (event_list_open==NO)
    {
        return nil;
    }
    else
    {
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        view1.backgroundColor=[UIColor colorWithRed:34.0/255.0 green:47.0/255.0 blue:58.0/255.0 alpha:1.0];
        
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, tableView.frame.size.width, 20)];
        [label setFont:[UIFont boldSystemFontOfSize:14]];
        [label setText:[[self.arrForListData objectAtIndex:section] objectForKey:@"title"]];
        OldEventDateinSection=[NSString stringWithFormat:@"%@",[[self.arrForListData objectAtIndex:section] objectForKey:@"section_name"]];
        label.textColor=[UIColor colorWithRed:59.0/255.0 green:186.0/255.0 blue:139.0/255.0 alpha:1.0];
        [view1 addSubview:label];
        
        return view1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (event_list_open==YES)
    {
        return [NSArray arrayWithArray:[[self.arrForListData objectAtIndex:section] objectForKey:@"content"]].count;
    }
    else
    {
        return self.arrForListData.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HomeTable";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil )
    {
        NSArray *nibCell = [[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nibCell objectAtIndex:2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 60, 295, 1)];
        imageView1.image=[UIImage imageNamed:@"Menu_ListBorder.png"];
        [cell.contentView addSubview:imageView1];
    }
    if (event_list_open==YES)
    {
        NSDictionary *temp=[NSDictionary dictionaryWithDictionary:[self.arrForListData objectAtIndex:indexPath.section]];
        NSArray *tempArray=[temp objectForKey:@"content"];
        
        NSString *strCal_name = [[[tempArray objectAtIndex:indexPath.row]valueForKey:@"event_name"]uppercaseString];
        cell.lblH_EventName.text =  strCal_name;
        cell.lblH_EventDetail.text=[[tempArray objectAtIndex:indexPath.row]valueForKey:@"cal_name"];
        cell.lblH_TimeAdd.text=[[tempArray objectAtIndex:indexPath.row]valueForKey:@"Time"];
        cell.lblH_Duretion.text=[[tempArray objectAtIndex:indexPath.row]valueForKey:@"Duretionlength"];
        cell.lblH_StartTime.text=[[tempArray objectAtIndex:indexPath.row]valueForKey:@"StartTime"];
        
        NSString *cal_key=[[tempArray objectAtIndex:indexPath.row]valueForKey:@"cal_key"];
        NSString *strType=[[tempArray objectAtIndex:indexPath.row]valueForKey:@"Type"];
        
        if ([cal_key isEqualToString:[objAppDelegate.AppDicUserInfo objectForKey:@"private_cal"]])
        {
            cell.lblH_EventType.textColor=[UIColor colorWithRed:223.0/255.0 green:70.0/255.0 blue:83.0/255.0 alpha:1.0];
            cell.lblH_EventType.text=@"Private";
            cell.imgH_Color.backgroundColor=[UIColor colorWithRed:223.0/255.0 green:70.0/255.0 blue:83.0/255.0 alpha:1.0];
            cell.img_HDot.image=[UIImage imageNamed:@"dot_red.png"];
        }
        else if ([strType isEqualToString:@"Subscribed"])
        {
            cell.lblH_EventType.textColor=[UIColor colorWithRed:71.0/255.0 green:187.0/255.0 blue:105.0/255.0 alpha:1.0];
            if ([objAppDelegate.TypeForSubscribed isEqualToString:@"yes"])
            {
                cell.lblH_EventType.text=@"Subscribed";
            }
            else
            {
                cell.lblH_EventType.text=@"Subscribe";
            }
            cell.imgH_Color.backgroundColor=[UIColor colorWithRed:71.0/255.0 green:187.0/255.0 blue:105.0/255.0 alpha:1.0];
            cell.img_HDot.image=[UIImage imageNamed:@"dot_green.png"];
        }
        else
        {
            cell.lblH_EventType.textColor = [UIColor colorWithRed:81.0/255.0 green:184.0/255.0 blue:221.0/255.0 alpha:1.0];
            cell.lblH_EventType.text = @"My Calendar";
            cell.imgH_Color.backgroundColor = [UIColor colorWithRed:81.0/255.0 green:184.0/255.0 blue:221.0/255.0 alpha:1.0];
            cell.img_HDot.image = [UIImage imageNamed:@"dot_blue.png"];
        }
    }
    else
    {
        NSString *strCal_name = [[[self.arrForListData objectAtIndex:indexPath.row]valueForKey:@"event_name"]uppercaseString];
        cell.lblH_EventName.text =  strCal_name;
        cell.lblH_EventDetail.text=[[self.arrForListData objectAtIndex:indexPath.row]valueForKey:@"cal_name"];
        cell.lblH_TimeAdd.text=[[self.arrForListData objectAtIndex:indexPath.row]valueForKey:@"Time"];
        cell.lblH_Duretion.text=[[self.arrForListData objectAtIndex:indexPath.row]valueForKey:@"Duretionlength"];
        cell.lblH_StartTime.text=[[self.arrForListData objectAtIndex:indexPath.row]valueForKey:@"StartTime"];
        
        NSString *cal_key=[[self.arrForListData objectAtIndex:indexPath.row]valueForKey:@"cal_key"];
        NSString *strType=[[self.arrForListData objectAtIndex:indexPath.row]valueForKey:@"Type"];
        
        if ([cal_key isEqualToString:[objAppDelegate.AppDicUserInfo objectForKey:@"private_cal"]])
        {
            cell.lblH_EventType.textColor=[UIColor colorWithRed:223.0/255.0 green:70.0/255.0 blue:83.0/255.0 alpha:1.0];
            cell.lblH_EventType.text=@"Private";
            cell.imgH_Color.backgroundColor=[UIColor colorWithRed:223.0/255.0 green:70.0/255.0 blue:83.0/255.0 alpha:1.0];
            cell.img_HDot.image=[UIImage imageNamed:@"dot_red.png"];
        }
        else if ([strType isEqualToString:@"Subscribed"])
        {
            cell.lblH_EventType.textColor=[UIColor colorWithRed:71.0/255.0 green:187.0/255.0 blue:105.0/255.0 alpha:1.0];
            if ([objAppDelegate.TypeForSubscribed isEqualToString:@"yes"])
            {
                cell.lblH_EventType.text=@"Subscribed";
            }
            else
            {
                cell.lblH_EventType.text=@"Subscribe";
            }
            cell.imgH_Color.backgroundColor=[UIColor colorWithRed:71.0/255.0 green:187.0/255.0 blue:105.0/255.0 alpha:1.0];
            cell.img_HDot.image=[UIImage imageNamed:@"dot_green.png"];
        }
        else
        {
            cell.lblH_EventType.textColor = [UIColor colorWithRed:81.0/255.0 green:184.0/255.0 blue:221.0/255.0 alpha:1.0];
            cell.lblH_EventType.text = @"My Calendar";
            cell.imgH_Color.backgroundColor = [UIColor colorWithRed:81.0/255.0 green:184.0/255.0 blue:221.0/255.0 alpha:1.0];
            cell.img_HDot.image = [UIImage imageNamed:@"dot_blue.png"];
        }
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MycalendarEventDetailVC *obj=[[MycalendarEventDetailVC alloc]initWithNibName:@"MycalendarEventDetailVC" bundle:Nil];
    if (event_list_open==YES)
    {
        NSDictionary *temp=[NSDictionary dictionaryWithDictionary:[self.arrForListData objectAtIndex:indexPath.section]];
        NSArray *tempArray=[temp objectForKey:@"content"];
        obj.dicCal_Event=[tempArray  objectAtIndex:indexPath.row];
    }
    else
    {
        obj.dicCal_Event=[self.arrForListData  objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:obj animated:YES];
}
@end
