//
//  MyUtility.h
//  Zuntik
//
//  Created by Dev-Mac on 26/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "DataBaseManagement.h"
@interface MyUtility : NSObject
+(NSString *)TimeFormateSet:(NSString *)strDate;
+(NSString *)dateFormateSet:(NSString *)strDate;
+(NSString *)Ondate_YearFormateset:(NSString *)strDMD;

+(NSString *)OndateaFormateset:(NSString *)strDMD;
+(NSString *)OnTimeDuretionFormateset:(NSDate *)strdate Add:(NSString *)Length;
+(NSString *)OnHour_Min_Sec:(NSString *)Length AndDate:(NSString *)dateString;
+(NSString *)OnStartTime:(NSDate *)Date;

+(NSString *)OnStartTimeSet:(NSString *)Hours Min:(NSString *)Min;

+(NSString *)Replece_hours:(NSString *)strRepl;
+(NSString *)Replece_Minutes:(NSString *)strRepl;

+(NSString *)FirstDate:(NSString *)strfirst SecondDate:(NSString *)strSecond;
+(NSString *)CompairDateWithCurrentdateAndSort:(NSMutableArray *)dataArray;
+ (NSString *)timeFormatted:(int)totalSeconds;
+(NSMutableArray *)GetAllevent:(NSMutableArray *)responcearray;
+ (NSString *)scheduleNotification:(NSString *)title withDate:(NSDate *)setdate;


// new Work
+(NSString *)getoriginalCurrentDate:(BOOL)withDayname andDateString:(NSString *)event_datestring;


@end
