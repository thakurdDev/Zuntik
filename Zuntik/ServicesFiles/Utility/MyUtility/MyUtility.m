//
//  MyUtility.m
//  Zuntik
//
//  Created by Dev-Mac on 26/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "MyUtility.h"

@implementation MyUtility

// get month name by index
+(NSString *)monthNameForKey:(NSString *)keyInt
{
    NSDictionary *month_names=[NSDictionary dictionaryWithObjectsAndKeys:@"January",@"01",@"Fabruary",@"02",@"March",@"03",@"April",@"04",@"May",@"05",@"June",@"06",@"July",@"07",@"August",@"08",@"September",@"09",@"October",@"10",@"November",@"11",@"December",@"12", nil];
    
    NSString *name_of_month=[month_names objectForKey:keyInt];
    
    return name_of_month;
    
}
// get index by monthname
+(NSString *)monthindexForKey:(NSString *)monthname
{
    
    NSDictionary *MonthNames = [NSDictionary dictionaryWithObjectsAndKeys:@"01",@"January",@"02",@"Fabruary",@"03",@"March",@"04",@"April",@"05",@"May",@"06",@"June",@"07",@"July",@"08",@"August",@"09",@"September",@"10",@"October",@"11",@"November",@"12",@"December",nil];
    
    NSString *name_of_month=[MonthNames objectForKey:monthname];
    
    return name_of_month;
    
}

+(NSString *)getoriginalCurrentDate:(BOOL)withDayname andDateString:(NSString *)event_datestring
{
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *sourceDate = [dateFormatter1 dateFromString:event_datestring];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"EEEE"];
    NSString *dayname=[dateFormatter2 stringFromDate:sourceDate];
    
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *Date_string=[dateFormatter2 stringFromDate:sourceDate];
    
    NSArray *seprator=[Date_string componentsSeparatedByString:@"-"];
    
    NSString *month_name=[self monthNameForKey:[seprator objectAtIndex:1]];
    
    NSString *finalString;
    
    if (withDayname ==YES)
    {
        finalString=[NSString stringWithFormat:@"%@ %@th %@ %@",dayname,[seprator objectAtIndex:2],month_name,[seprator objectAtIndex:0]];
    }
    else
    {
        finalString=[NSString stringWithFormat:@"%@th %@ %@",[seprator objectAtIndex:2],month_name,[seprator objectAtIndex:0]];
    }
    
    return finalString;
}


+(NSString *)CompairDateWithCurrentdateAndSort:(NSMutableArray *)dataArray
{
    for (int i=0; i<dataArray.count; i++)
    {
        
        NSString *event_date=[NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:i] objectForKey:@"event_date"]];
        
        NSDate *date1 = [NSDate date];
        
        NSDateFormatter *dateFormatte11 = [[NSDateFormatter alloc] init];
        [dateFormatte11 setDateFormat:@"yyyy-MM-dd HH:ss:zzz"];
        NSDate *dateB = [[NSDate alloc] init];
        dateB = [dateFormatte11 dateFromString:event_date];
        
        unsigned int unitFlags = NSDayCalendarUnit;
        
        NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:date1  toDate:dateB  options:0];
        
        int days = [comps day];
    }
    return 0;
}
+ (NSString *)timeFormatted:(int)totalSeconds
{
    int minutes = totalSeconds % 60;
    int hours = totalSeconds / 60;
    
    return [NSString stringWithFormat:@"%02d %02d",hours, minutes];
}
#pragma  maek-TimeFormateSet
+(NSString *)TimeFormateSet:(NSString *)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm:ss"];
    NSString *newDateString = [dateFormatter2 stringFromDate:date];
    return newDateString;
}
#pragma  maek-dateFormateSet
+(NSString *)dateFormateSet:(NSString *)strDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString = [dateFormatter2 stringFromDate:date];
    return newDateString;
}
#pragma mark- method for dateformate set (28th September 2014)
+(NSString *)Ondate_YearFormateset:(NSString *)strDMD
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:strDMD];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"EEEE"];
    
    NSArray *suffixes = [[NSArray alloc]initWithObjects: @"th", @"st", @"nd", @"rd",@"th", @"th",@"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th",@"th", @"st", @"nd", @"rd", @"th", @"th", @"th", @"th", @"th",@"th", @"th", @"st",nil];
    
    NSDate *dateDay = [dateFormatter dateFromString:strDMD];
    NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
    [df1 setDateFormat:@"d"];
    int index = [[df1 stringFromDate:dateDay] intValue];
    NSString *strSuffix = [suffixes objectAtIndex:index];
    NSString *strDayWithSuffix = [[df1 stringFromDate:dateDay] stringByAppendingFormat:@"%@",strSuffix];
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc]init];
    //[df2 setDateFormat:@"MMMM yyyy"];
    df2.dateFormat=@"MMMM";
    NSString * monthString = [[df2 stringFromDate:date] capitalizedString];
    df2.dateFormat=@"yyyy";
    NSString * yearString = [[df2 stringFromDate:date] capitalizedString];
    
    strDayWithSuffix = [strDayWithSuffix stringByAppendingFormat:@" %@ %@",monthString,yearString];
    
    return strDayWithSuffix;
}

#pragma mark- method for dateformate set (Tuesday 28th September 2014)
+(NSString *)OndateaFormateset:(NSString *)strDMD
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:strDMD];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"EEEE"];
    
    NSString* myNiceLookingDate = [df stringFromDate:date];
    NSArray *suffixes = [[NSArray alloc]initWithObjects: @"th", @"st", @"nd", @"rd",@"th", @"th",@"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th", @"th",@"th", @"st", @"nd", @"rd", @"th", @"th", @"th", @"th", @"th",@"th", @"th", @"st",nil];
    
    NSDate *dateDay = [dateFormatter dateFromString:strDMD];
    NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
    [df1 setDateFormat:@"d"];
    int index = [[df1 stringFromDate:dateDay] intValue];
    NSString *strSuffix = [suffixes objectAtIndex:index];
    NSString *strDayWithSuffix = [[df1 stringFromDate:dateDay] stringByAppendingFormat:@"%@",strSuffix];
    
    myNiceLookingDate = [myNiceLookingDate stringByAppendingFormat:@" %@",strDayWithSuffix];
    NSDateFormatter *df2 = [[NSDateFormatter alloc]init];
    //[df2 setDateFormat:@"MMMM yyyy"];
    df2.dateFormat=@"MMMM";
    NSString * monthString = [[df2 stringFromDate:date] capitalizedString];
    df2.dateFormat=@"yyyy";
    NSString * yearString = [[df2 stringFromDate:date] capitalizedString];
    
    myNiceLookingDate = [myNiceLookingDate stringByAppendingFormat:@" %@ %@",monthString,yearString];
    
    return myNiceLookingDate;
}



#pragma mark- method for OnTimeDuretionFormateset set
+(NSString *)OnTimeDuretionFormateset:(NSDate *)strdate Add:(NSString *)Length
{
    NSString *strCurrentDate;
    NSString *strNewDate;
    NSDateFormatter *df =[[NSDateFormatter alloc]init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    strCurrentDate = [df stringFromDate:strdate];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    //[components setHour:hoursToAdd];
    [components setMinute:[Length intValue]];
    NSDate *newDate= [calendar dateByAddingComponents:components toDate:strdate options:0];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    strNewDate = [df stringFromDate:newDate];
    
   // int Lengthset=[Length intValue];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"hh:mm a";
    NSString *dateString = [timeFormatter stringFromDate: newDate];
    return dateString;
}
+ (NSDictionary *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    NSInteger days=0;
    
    if (hours==24||hours>24)
    {
        days=(hours /24);
        hours=hours-24*days;
    }
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:[NSString stringWithFormat:@"%02ld",(long)seconds] forKey:@"s"];
    [dict setObject:[NSString stringWithFormat:@"%02ld",(long)minutes] forKey:@"m"];
    [dict setObject:[NSString stringWithFormat:@"%02ld",(long)hours] forKey:@"h"];
    [dict setObject:[NSString stringWithFormat:@"%02ld",(long)days] forKey:@"d"];
    return  dict;
}
#pragma mark- method for OnTimeDuretionFormateset set
+(NSString *)OnHour_Min_Sec:(NSString *)Length AndDate:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [dateFormatter dateFromString:dateString];
    
    NSDateComponents *dayComponentEvent = [[NSDateComponents alloc] init];
    dayComponentEvent.minute = [Length integerValue];
    
    NSCalendar *theCalendarEvent = [NSCalendar currentCalendar];
    NSDate *nextDate = [theCalendarEvent dateByAddingComponents:dayComponentEvent toDate:date1 options:0];
    NSTimeInterval diff = [nextDate timeIntervalSinceDate:date1];
  
    NSDictionary *tempFormat= [self stringFromTimeInterval:diff];
    
    NSString *strDuretion;
    
    
    long noofdays=[[tempFormat objectForKey:@"d"] longLongValue];
    long hrs=[[tempFormat objectForKey:@"h"] longLongValue];
    long min=[[tempFormat objectForKey:@"m"] longLongValue];
    
    if (noofdays == 0)
    {
        if (hrs == 0)
        {
            strDuretion=[NSString stringWithFormat:@"%d mins",(int)min];
        }
        else {
            if (hrs == 1)
            {
                strDuretion=[NSString stringWithFormat:@"%d hour %d mins",(int)hrs,(int)min];
                
            } else {
                
                strDuretion=[NSString stringWithFormat:@"%d hours %d mins",(int)hrs,(int)min];
               
                
            }
        }
        if (min == 0) {
            if (hrs == 1)
            {
               strDuretion=[NSString stringWithFormat:@"%d hour",(int)hrs];
              
            } else {
                 strDuretion=[NSString stringWithFormat:@"%d hours",(int)hrs];
              
            }
        }
        
    } else {
        if (hrs == 0 && min == 0) {
            if (noofdays == 1)
            {
                 strDuretion=[NSString stringWithFormat:@"%d day",(int)noofdays];
            } else
            {
                 strDuretion=[NSString stringWithFormat:@"%d days",(int)noofdays];
            }
            
        } else if (hrs == 0 && min != 0) {
            if (noofdays == 1)
            {
                 strDuretion=[NSString stringWithFormat:@"%d day %d mins",(int)noofdays,(int)min];
                
            } else
            {
                 strDuretion=[NSString stringWithFormat:@"%d days %d mins",(int)noofdays,(int)min];
                
            }
        } else if (min == 0 && hrs != 0) {
            if (noofdays == 1) {
                if (hrs == 1)
                {
                     strDuretion=[NSString stringWithFormat:@"%d day %d hour",(int)noofdays,(int)hrs];
                   
                } else
                {
                     strDuretion=[NSString stringWithFormat:@"%d day %d hours",(int)noofdays,(int)hrs];
                   
                }
            } else {
                if (hrs == 1)
                {
                     strDuretion=[NSString stringWithFormat:@"%d days %d hour",(int)noofdays,(int)hrs];
                    
                } else
                {
                     strDuretion=[NSString stringWithFormat:@"%d days %d hours",(int)noofdays,(int)hrs];
                    
                }
            }
        } else if (hrs != 0 && min != 0) {
            if (noofdays == 1) {
                if (hrs == 1)
                {
                     strDuretion=[NSString stringWithFormat:@"%d hour %d mins",(int)hrs,(int)min];
                   
                } else
                {
                     strDuretion=[NSString stringWithFormat:@"%d day %d hours %d mins",(int)noofdays,(int)hrs,(int)min];
                  
                }
            } else {
                if (hrs == 1) {
                     strDuretion=[NSString stringWithFormat:@"%d day %d hour %d mins",(int)noofdays,(int)hrs,(int)min];
                    
                } else {
                     strDuretion=[NSString stringWithFormat:@"%d days %d hours %d mins",(int)noofdays,(int)hrs,(int)min];
                }
            }
        }
    }
    return strDuretion;
}
#pragma mark- method for OnStartTime set
+(NSString *)OnStartTime:(NSDate *)Date
{
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"hh:mm a";
    NSString *TimeString = [timeFormatter stringFromDate: Date];
    return TimeString;
}
#pragma mark- method for Hours to minutes
+(NSString *)OnStartTimeSet:(NSString *)Hours Min:(NSString *)Min
{
    int hour=[Hours intValue];
    int minut=[Min intValue];
    hour=hour*60;
    int totalMin=hour+minut;
    NSString *strTotal=[NSString stringWithFormat:@"%d",totalMin];
    return strTotal;
}

#pragma mark- method for OnStartTime set
+(NSString *)Replece_hours:(NSString *)strRepl
{
    NSString *result;
    NSScanner *scanner = [NSScanner scannerWithString:strRepl];
    NSCharacterSet *cs1 = [NSCharacterSet characterSetWithCharactersInString:@"hours"];
    [scanner scanUpToCharactersFromSet:cs1 intoString:&result];
    return result;
}
#pragma mark- method for OnStartTime set
+(NSString *)Replece_Minutes:(NSString *)strRepl
{
    NSString *result;
    NSScanner *scanner = [NSScanner scannerWithString:strRepl];
    NSCharacterSet *cs1 = [NSCharacterSet characterSetWithCharactersInString:@"minutes"];
    [scanner scanUpToCharactersFromSet:cs1 intoString:&result];
    return result;
}
#pragma mark- method for OnStartTime set
+(NSString *)FirstDate:(NSString *)strfirst SecondDate:(NSString *)strSecond
{
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:strfirst];
    
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [dateFormatter1 dateFromString:strSecond];
    
    NSTimeInterval timeInterval  = [date1 timeIntervalSinceDate:date];
    int minutes = floor(timeInterval/60);
   // int seconds = trunc(timeInterval - minutes * 60);
   // int hours = minutes / 60;
    NSString *strmin=[NSString stringWithFormat:@"%d",minutes];
    return strmin;
}
+(NSString *)GetDiffrenceBetwwenOlddateis:(NSString *)oldate
{
    //2014-08-31
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [f dateFromString:oldate];
    
    NSTimeInterval secondsBetween = [endDate timeIntervalSinceDate:startDate];
    
    int numberOfDays = secondsBetween / 86400;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekOfYearCalendarUnit|NSWeekOfMonthCalendarUnit
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    
    NSInteger Diff_day=(long)components.day;
    NSInteger Diff_Hours=(long)components.hour;
    
    NSMutableArray *dates = [[NSMutableArray alloc] init];
    NSUInteger dayOffset = 0;
    NSDate *nextDate = endDate;
    do {
        [dates addObject:nextDate];
        
        [components setDay:dayOffset++];
        NSDate *d = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:startDate options:0];
        nextDate = d;
    } while([nextDate compare:endDate] == NSOrderedAscending);
    
    [f setDateStyle:NSDateFormatterFullStyle];
    NSString *final;
    for (NSDate *date in dates)
    {
        
        NSArray *array = [[f stringFromDate:date] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString *DayName=[NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
        DayName =[DayName stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSString *monthname=[array objectAtIndex:1];
      //  monthname =[monthname stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        monthname=[self monthindexForKey:monthname];
        NSString * monthDate=[NSString stringWithFormat:@"%@",[array objectAtIndex:2]];
        monthDate=[monthDate stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        NSString *yearName=[NSString stringWithFormat:@"%@",[array objectAtIndex:3]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        NSString *yearString = [formatter stringFromDate:[NSDate date]];
         [formatter setDateFormat:@"MM"];
        if ([yearString integerValue]==[yearName integerValue])
        {
            
                if (numberOfDays>-8 &&numberOfDays <0)
                {
                    final=[NSString stringWithFormat:@"Last %@,%@/%@",DayName,monthname,monthDate];
                }
                else if (numberOfDays==0)
                {
                    if (Diff_Hours>12||Diff_Hours==12)
                    {
                        final=[NSString stringWithFormat:@"Tomorrow %@,%@/%@",DayName,monthname,monthDate];
                    }
                    else if (Diff_Hours<-12||Diff_Hours==-12)
                    {
                        final=[NSString stringWithFormat:@"Yesterday %@,%@/%@",DayName,monthname,monthDate];
                    }
                    else
                    {
                        final=[NSString stringWithFormat:@"Today %@,%@/%@",DayName,monthname,monthDate];
                    }
                }
                else if (numberOfDays>0&& numberOfDays <8)
                {
                    final=[NSString stringWithFormat:@"Upcoming %@,%@/%@",DayName,monthname,monthDate];
                }
                else if (numberOfDays>7 &&numberOfDays <15)
                {
                    final=[NSString stringWithFormat:@"Next %@,%@/%@",DayName,monthname,monthDate];
                }
                else
                {
                    final=[NSString stringWithFormat:@"%@, %@/%@",DayName,monthname,monthDate];
                }
            
        }
        else
        {
            final=[NSString stringWithFormat:@"%@, %@/%@/%@",DayName,monthname,monthDate,yearName];
        }
    }
    
    return final;
    
}
+(NSString *)Monthname
{
   
    return nil;
}
+(NSMutableArray *)GetAllevent:(NSMutableArray *)responcearray;
{
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    NSString * strUserId=[userdefault valueForKey:@"UserId"];
    
     DataBaseManagement *objDatabase = [DataBaseManagement Connetion];//Database Connection
    NSMutableDictionary * DicForUserDetails =[[NSMutableDictionary alloc]init];
    AppDelegate *objAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    {
        objAppDelegate.HoldEventArry=[[NSMutableArray alloc]init];
        
        for (int i=0; i<responcearray.count; i++)
        {
            
            NSString *EventDate_str=[NSString stringWithFormat:@"%@",[[responcearray objectAtIndex:i] objectForKey:@"event_date"]];
            
            if ([EventDate_str isEqual:@"0000-00-00 00:00:00"]||EventDate_str.length<10)
            {
            }
            else
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss "];
                
                NSDate *eventDate_date=[dateFormatter dateFromString:EventDate_str];
                
                NSString *Event_dateName= [self GetDiffrenceBetwwenOlddateis:EventDate_str];
                
                NSMutableDictionary *mdictDay=[[NSMutableDictionary alloc]init];
                NSMutableArray *arryList=[[NSMutableArray alloc]init];
                
                DicForUserDetails=objAppDelegate.AppDicUserInfo;
                
                NSString *strUserPrivate=[DicForUserDetails valueForKey:@"private_cal"];
                
                NSMutableDictionary *mdictAttendence = [responcearray objectAtIndex:i];
                
                mdictDay = [responcearray objectAtIndex:i];
                NSString *strCurrentDate=[self getoriginalCurrentDate:YES andDateString:EventDate_str]; //DateFormate Current full Date Add
                NSString *strdate_Year=[self getoriginalCurrentDate:NO andDateString:EventDate_str];//Date Formate Date And Year
                NSString *strTime=[self OnTimeDuretionFormateset:eventDate_date Add:[mdictAttendence valueForKey:@"event_length"]]; //time durection Add
                NSString *strDuretionValue=[self OnHour_Min_Sec:[mdictAttendence valueForKey:@"event_length"] AndDate:[mdictAttendence valueForKey:@"event_date"]];
                if ([strDuretionValue isEqualToString:@"5 mins"]||[strDuretionValue isEqualToString:@"-5 mins"])
                {
                    strDuretionValue=@"Reminder";
                }
                NSString *strStartTime=[self OnStartTime:eventDate_date];
                NSString *strCal_key=[mdictDay valueForKey:@"cal_key"];
                
                BOOL setSubscription= [objDatabase getSubscriptionsDataCheck:strCal_key userId:strUserId];
                BOOL setCreated=[objDatabase getUsercreatedCalsData:strCal_key userId:strUserId];
                
                if (setSubscription==YES)
                {
                    //Event_dateName
                    [mdictDay setObject:Event_dateName forKey:@"section_name"];
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
                    [mdictDay setObject:Event_dateName forKey:@"section_name"];
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
                    [mdictDay setObject:Event_dateName forKey:@"section_name"];
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
                    [mdictDay setObject:Event_dateName forKey:@"section_name"];
                    [mdictDay setObject:strStartTime forKey:@"StartTime"];
                    [mdictDay setObject:strDuretionValue forKey:@"Duretionlength"];
                    [mdictDay setObject:strTime forKey:@"Time"];
                    [mdictDay setObject:strdate_Year forKey:@"date_Year"];
                    [mdictDay setObject:strCurrentDate forKey:@"CurrentDate"];
                    [mdictDay setObject:@"Subscribed" forKey:@"Type"];
                    [arryList addObject:mdictDay];
                }
                [objAppDelegate.HoldEventArry addObject:mdictDay];
                
            }
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"event_date"
                                                                         ascending:YES];
            [objAppDelegate.HoldEventArry sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            [self CompairDateWithCurrentdateAndSort:objAppDelegate.HoldEventArry];
            
       }
           
    }
    return objAppDelegate.HoldEventArry;
}
#pragma mark -
#pragma mark === Public Methods ===
#pragma mark -
+ (NSString *)scheduleNotification:(NSString *)title withDate:(NSDate *)setdate
{
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = setdate;
    localNotification.alertAction = @"Show me the Event";
    localNotification.alertBody=[NSString stringWithFormat:@"%@",title];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
        
    return nil;
}
@end
/*
 UnUsed method
 Remove Methods
 
 +(NSString *)dateFormateSetOther:(NSString *)strDate;
 
 #pragma  maek-dateFormateSetOther
 +(NSString *)dateFormateSetOther:(NSString *)strDate
 {
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"d'th' MMMM  yyyy"];
 NSDate *date = [dateFormatter dateFromString:strDate];
 NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
 [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
 NSString *newDateString = [dateFormatter2 stringFromDate:date];
 return newDateString;
 }
 
 ————————————————————————————————————————————————————————————————————————————————————————————————————————

 
 
 
*/