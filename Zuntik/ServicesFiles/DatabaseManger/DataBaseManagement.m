
//

#import "DataBaseManagement.h"
static sqlite3 *database = nil;
@implementation DataBaseManagement
@synthesize returnArr;

//class method to open connection with iPad embedded sqlite database.
+ (DataBaseManagement *)Connetion {
	
	static DataBaseManagement *con = nil;
	
	if (con == NULL)
    {
		con = [[DataBaseManagement alloc] init];
		
		NSError *error = [[NSError alloc]init];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"appzuntik"];
		
		int success = [fileManager fileExistsAtPath:path];
		
		if (!success)
        {
			NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"appzuntik"];
			success = [fileManager copyItemAtPath:defaultDBPath toPath:path error:&error];
			if (!success)
            {
				NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
			}// if
		}// if
		
		if (success)
        {
			// Open the database. The database was prepared outside the application.
			if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
            {
				//
			} // Even though the open failed, call close to properly clean up resources.
			else
            {
				sqlite3_close(database);
				NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
				// Additional error handling, as appropriate...
				return NULL;
			}// else
		}// if
		[error release];
	}// if
	
	return con;
} //Connetion

-(NSString *)xmlDecodeString:(NSString *) str
{
	
	str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
	
	str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
	
	str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
	
	str = [str stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
	
	str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
	
	return str;
	
}// xmlDecodeString
-(BOOL)getUserLoginID:(NSString *)strloginId Password:(NSString *)strPassword
{
  
    return YES;
    
}

#pragma  mark-insert all table data addUserInfo

- (void)addUserInfo:(NSMutableDictionary *)dictContentData
{
    sqlite3_stmt *insertStatement; // statement created
    
    // Update Query
    const char *sql = "INSERT INTO userInfo (_user_email, _first_name,_last_name,_registration_date,_password,_salt,_confirmed,_private_cal,_city_num) values (?,?,?,?,?,?,?,?,?)";
    if (sqlite3_prepare_v2(database, sql, -1, &insertStatement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }// if
    
            sqlite3_bind_text(insertStatement, 1, [[dictContentData objectForKey:@"user_email"] UTF8String], -1, SQLITE_TRANSIENT);
    
            sqlite3_bind_text(insertStatement, 2, [[dictContentData objectForKey:@"first_name"] UTF8String], -1, SQLITE_TRANSIENT);
    
            sqlite3_bind_text(insertStatement, 3, [[dictContentData objectForKey:@"last_name"] UTF8String], -1, SQLITE_TRANSIENT);
    
            sqlite3_bind_text(insertStatement, 4, [[dictContentData objectForKey:@"registration_date"] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(insertStatement, 5, [[dictContentData objectForKey:@"password"] UTF8String], -1, SQLITE_TRANSIENT);
    
            sqlite3_bind_text(insertStatement, 6, [[dictContentData objectForKey:@"salt"] UTF8String], -1, SQLITE_TRANSIENT);
    
            sqlite3_bind_text(insertStatement, 7, [[dictContentData objectForKey:@"confirmed"] UTF8String], -1, SQLITE_TRANSIENT);
    
            sqlite3_bind_text(insertStatement, 8, [[dictContentData objectForKey:@"private_cal"] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(insertStatement, 9, [[dictContentData objectForKey:@"city_num"] UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(insertStatement);// executing query
    sqlite3_finalize(insertStatement); // finalizing statement
}//addContentData

//User SubCriptionInsert
#pragma  mark-insert all table data SubCriptionInsert

- (void)addUsersubscriptions:(NSMutableDictionary *)dictContentData
{
    sqlite3_stmt *insertStatement; // statement created
    
   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString * strUserId=[userDefaults valueForKey:@"UserId"];
    // Update Query
    const char *sql = "INSERT INTO subscriptions’ (_user_email, _last_update,_cal_creator,_cal_key,_cal_descrip,_cal_identifier,_cal_name,_registration_date,_private_key,_disc_num,_collab_pass,_class_num,_class_info,_class_code,_cal_update_num,_cal_type) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    if (sqlite3_prepare_v2(database, sql, -1, &insertStatement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }// if
    
  NSString  *strinCal_update_num =[dictContentData objectForKey:@"cal_update_num"];
    
    if ([strinCal_update_num isEqual:[NSNull null]])
    {
        strinCal_update_num=@" ";
        
    }
    else
    {
        strinCal_update_num =[dictContentData objectForKey:@"cal_update_num"];
    }
    
    
    NSString *strinCal_type =[dictContentData objectForKey:@"cal_type"];
    if ([strinCal_type isEqual:[NSNull null]])
    {
        strinCal_type=@" ";
        
    }
    else
    {
        strinCal_type =[dictContentData objectForKey:@"cal_type"];
    }
    
    NSString *strinCal_key =[dictContentData objectForKey:@"cal_key"];
    if ([strinCal_key isEqual:[NSNull null]])
    {
        strinCal_key=@" ";
        
    }
    else
    {
        strinCal_key =[dictContentData objectForKey:@"cal_key"];
    }
    
    NSString *strinCal_identifier =[dictContentData objectForKey:@"cal_identifier"];
    if ([strinCal_identifier isEqual:[NSNull null]])
    {
        strinCal_identifier=@" ";
        
    }
    else
    {
        strinCal_identifier =[dictContentData objectForKey:@"cal_identifier"];
    }
    
    NSString *strinCal_descrip =[dictContentData objectForKey:@"cal_descrip"];
    if ([strinCal_descrip isEqual:[NSNull null]])
    {
        strinCal_descrip=@" ";
        
    }
    else
    {
        strinCal_descrip =[dictContentData objectForKey:@"cal_descrip"];
    }
    
    NSString *strinCal_creator =[dictContentData objectForKey:@"cal_creator"];
    if ([strinCal_creator isEqual:[NSNull null]])
    {
        strinCal_creator=@" ";
        
    }
    else
    {
        strinCal_creator =[dictContentData objectForKey:@"cal_creator"];
    }
    NSString *strinClasscode =[dictContentData objectForKey:@"class_code"];
    if ([strinClasscode isEqual:[NSNull null]]) {
        strinClasscode=@" ";
        
    }
    else
    {
        strinClasscode =[dictContentData objectForKey:@"class_code"];
    }
    NSString *strinClassnum =[dictContentData objectForKey:@"class_num"];
    if ([strinClassnum isEqual:[NSNull null]]) {
        strinClassnum=@" ";
        
    }
    else
    {
        strinClassnum =[dictContentData objectForKey:@"class_num"];
    }
    
    NSString *strinClass_info =[dictContentData objectForKey:@"class_info"];
    if ([strinClass_info isEqual:[NSNull null]]) {
        strinClass_info=@" ";
        
    }
    else
    {
        strinClass_info =[dictContentData objectForKey:@"class_info"];
        
    }
    
    
    
    NSString *striCollabpass =[dictContentData objectForKey:@"collab_pass"];
    if ([striCollabpass isEqual:[NSNull null]]) {
        striCollabpass=@" ";
        
    }
    else
    {
        striCollabpass =[dictContentData objectForKey:@"collab_pass"];
        
    }
    NSString *strinDiscnum =[dictContentData objectForKey:@"disc_num"];
    if ([strinDiscnum isEqual:[NSNull null]]) {
        strinDiscnum=@" ";
        
    }
    else
    {
        strinDiscnum =[dictContentData objectForKey:@"disc_num"];
        
    }
    NSString *strinPrivate_key =[dictContentData objectForKey:@"private_key"];
    if ([strinPrivate_key isEqual:[NSNull null]]) {
        strinPrivate_key=@" ";
        
    }
    else
    {
        strinPrivate_key =[dictContentData objectForKey:@"private_key"];
    }
    NSString *strinlast_update =[dictContentData objectForKey:@"last_update"];
    if ([strinlast_update isEqual:[NSNull null]]) {
        strinlast_update=@" ";
        
    }
    else
    {
        strinlast_update =[dictContentData objectForKey:@"last_update"];
    }
    
    NSString *strinRegistration_date =[dictContentData objectForKey:@"registration_date"];
    if ([strinRegistration_date isEqual:[NSNull null]]) {
        strinRegistration_date=@" ";
        
    }
    else
    {
        strinRegistration_date =[dictContentData objectForKey:@"registration_date"];
    }
    
    NSString *strinCal_name =[dictContentData objectForKey:@"cal_name"];
    if ([strinCal_name isEqual:[NSNull null]]) {
        strinCal_name=@" ";
        
    }
    else
    {
        strinCal_name =[dictContentData objectForKey:@"cal_name"];
    }
    
    
    
    sqlite3_bind_text(insertStatement, 1,[strUserId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 2,[strinlast_update UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 3, [strinCal_creator UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 4, [strinCal_key UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 5, [strinCal_descrip UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 6, [strinCal_identifier UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 7, [strinCal_name UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 8, [strinRegistration_date UTF8String], -1, SQLITE_TRANSIENT);
    
    
    sqlite3_bind_text(insertStatement, 9, [strinPrivate_key UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 10, [strinDiscnum UTF8String], -1, SQLITE_TRANSIENT);

    
    sqlite3_bind_text(insertStatement, 11, [striCollabpass UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 12, [strinClassnum UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 13, [strinClass_info UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 14, [strinClasscode UTF8String], -1, SQLITE_TRANSIENT);
    
    
    sqlite3_bind_text(insertStatement, 15, [strinCal_update_num UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 16, [strinCal_type UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(insertStatement);// executing query
    sqlite3_finalize(insertStatement); // finalizing statement
}
#pragma  mark-insert all table data addUsernewEvents
- (void)addUsernewEvents:(NSMutableDictionary *)dictContentData
{
    sqlite3_stmt *insertStatement; // statement created
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * strUserId=[userDefaults valueForKey:@"UserId"];
    // Update Query
    const char *sql = "INSERT INTO eventInfo(_user_email, _event_key,_event_name,_event_descrip,_event_date,_event_length,_in_class_code,_last_update,_event_update_num,_cal_name,_cal_key) values (?,?,?,?,?,?,?,?,?,?,?)";
    if (sqlite3_prepare_v2(database, sql, -1, &insertStatement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }// if
    
    NSString *strincal_key =[dictContentData objectForKey:@"cal_key"];
    if ([strincal_key isEqual:[NSNull null]])
    {
        strincal_key=@" ";
        
    }
    else
    {
        strincal_key =[dictContentData objectForKey:@"cal_key"];
    }
    NSString *strincal_name =[dictContentData objectForKey:@"cal_name"];
    if ([strincal_name isEqual:[NSNull null]])
    {
        strincal_name=@" ";
        
    }
    else
    {
        strincal_name =[dictContentData objectForKey:@"cal_name"];
    }
    NSString *strinevent_date =[dictContentData objectForKey:@"event_date"];
    if ([strinevent_date isEqual:[NSNull null]])
    {
        strinevent_date=@" ";
        
    }
    else
    {
        strinevent_date =[dictContentData objectForKey:@"event_date"];
    }
    
    NSString *strinevent_descrip =[dictContentData objectForKey:@"event_descrip"];
    if ([strinevent_descrip isEqual:[NSNull null]])
    {
        strinevent_descrip=@" ";
        
    }
    else
    {
        strinevent_descrip =[dictContentData objectForKey:@"event_descrip"];
    }
    
    NSString *strinevent_key =[dictContentData objectForKey:@"event_key"];
    if ([strinevent_key isEqual:[NSNull null]])
    {
        strinevent_key=@" ";
        
    }
    else
    {
        strinevent_key =[dictContentData objectForKey:@"event_key"];
    }
    NSString *strinevent_length =[dictContentData objectForKey:@"event_length"];
    if ([strinevent_length isEqual:[NSNull null]])
    {
        strinevent_length=@" ";
        
    }
    else
    {
        if ( [strinevent_length isKindOfClass: [NSString class]] )
        {
            strinevent_length =[dictContentData objectForKey:@"event_length"];
        }
        else if ( [strinevent_length isKindOfClass: [NSNumber class]] )
        {
            strinevent_length= [[NSString alloc] initWithFormat:@"%d", [strinevent_length integerValue]];
        }
    }
    NSString *strinevent_name =[dictContentData objectForKey:@"event_name"];
    if ([strinevent_name isEqual:[NSNull null]])
    {
        strinevent_name=@" ";
        
    }
    else
    {
        strinevent_name =[dictContentData objectForKey:@"event_name"];
    }
    NSString *strinevent_update_num =[dictContentData objectForKey:@"event_update_num"];
    if ([strinevent_update_num isEqual:[NSNull null]])
    {
        strinevent_update_num=@" ";
        
    }
    else
    {
        strinevent_update_num =[dictContentData objectForKey:@"event_update_num"];
    }
    
    
    NSString *strinClasscode =[dictContentData objectForKey:@"in_class_code"];
    if ([strinClasscode isEqual:[NSNull null]])
    {
        strinClasscode=@" ";
        
    }
    else
    {
        if ( [strinClasscode isKindOfClass: [NSString class]] )
        {
            strinClasscode =[dictContentData objectForKey:@"in_class_code"];
        }
        else if ( [strinClasscode isKindOfClass: [NSNumber class]] )
        {
            strinClasscode =[dictContentData objectForKey:@"in_class_code"];
            strinClasscode= [[NSString alloc] initWithFormat:@"%d", [strinClasscode integerValue]];
        }
        
    }
    
    NSString *strinlast_update =[dictContentData objectForKey:@"last_update"];
    if ([strinlast_update isEqual:[NSNull null]])
    {
        strinlast_update=@" ";
        
    }
    else
    {
        strinlast_update =[dictContentData objectForKey:@"last_update"];
    }
    
    
    sqlite3_bind_text(insertStatement, 1,[strUserId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 2, [strinevent_key UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 3, [strinevent_name UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 4, [strinevent_descrip UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 5, [strinevent_date UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 6, [strinevent_length UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 7, [strinClasscode UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 8, [strinlast_update UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 9, [strinevent_update_num UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 10, [strincal_name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 11, [strincal_key UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(insertStatement);// executing query
    sqlite3_finalize(insertStatement);
}
/*
#pragma  mark-insert all table data addUsernewEvents
- (void)addUsernewEvents_Cal_ID:(NSMutableDictionary *)dictContentData
{
    sqlite3_stmt *insertStatement; // statement created
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * strUserId=[userDefaults valueForKey:@"UserId"];
    // Update Query
    const char *sql = "INSERT INTO eventInfo(_user_email, _event_key,_event_name,_event_descrip,_event_date,_event_length,_in_class_code,_last_update,_event_update_num,_cal_name,_cal_key) values (?,?,?,?,?,?,?,?,?,?,?)";
    if (sqlite3_prepare_v2(database, sql, -1, &insertStatement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }// if
    
    NSString *strincal_key =[dictContentData objectForKey:@"cal_key"];
    if ([strincal_key isEqual:[NSNull null]])
    {
        strincal_key=@" ";
        
    }
    else
    {
        strincal_key =[dictContentData objectForKey:@"cal_key"];
    }
    NSString *strincal_name =[dictContentData objectForKey:@"cal_name"];
    if ([strincal_name isEqual:[NSNull null]])
    {
        strincal_name=@" ";
        
    }
    else
    {
        strincal_name =[dictContentData objectForKey:@"cal_name"];
    }
    NSString *strinevent_date =[dictContentData objectForKey:@"event_date"];
    if ([strinevent_date isEqual:[NSNull null]])
    {
        strinevent_date=@" ";
        
    }
    else
    {
        strinevent_date =[dictContentData objectForKey:@"event_date"];
    }
    
    NSString *strinevent_descrip =[dictContentData objectForKey:@"event_descrip"];
    if ([strinevent_descrip isEqual:[NSNull null]])
    {
        strinevent_descrip=@" ";
        
    }
    else
    {
        strinevent_descrip =[dictContentData objectForKey:@"event_descrip"];
    }
    
    NSString *strinevent_key =[dictContentData objectForKey:@"event_key"];
    if ([strinevent_key isEqual:[NSNull null]])
    {
        strinevent_key=@" ";
        
    }
    else
    {
        strinevent_key =[dictContentData objectForKey:@"event_key"];
    }
    
    NSString *strinevent_length =[dictContentData objectForKey:@"event_length"];
    if ([strinevent_length isEqual:[NSNull null]])
    {
        strinevent_length=@" ";
        
    }
    else
    {
        strinevent_length =[dictContentData objectForKey:@"event_length"];
    }
    NSString *strinevent_name =[dictContentData objectForKey:@"event_name"];
    if ([strinevent_name isEqual:[NSNull null]])
    {
        strinevent_name=@" ";
        
    }
    else
    {
        strinevent_name =[dictContentData objectForKey:@"event_name"];
    }
    NSString *strinevent_update_num =[dictContentData objectForKey:@"event_update_num"];
    if ([strinevent_update_num isEqual:[NSNull null]])
    {
        strinevent_update_num=@" ";
        
    }
    else
    {
        strinevent_update_num =[dictContentData objectForKey:@"event_update_num"];
    }
    
    
    NSString *strinClasscode =[dictContentData objectForKey:@"in_class_code"];
    if ([strinClasscode isEqual:[NSNull null]])
    {
        strinClasscode=@" ";
        
    }
    else
    {
        strinClasscode =[dictContentData objectForKey:@"in_class_code"];
    }
    
    NSString *strinlast_update =[dictContentData objectForKey:@"last_update"];
    if ([strinlast_update isEqual:[NSNull null]])
    {
        strinlast_update=@" ";
        
    }
    else
    {
        strinlast_update =[dictContentData objectForKey:@"last_update"];
    }
    
    
    sqlite3_bind_text(insertStatement, 1,[strUserId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 2, [strinevent_key UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 3, [strinevent_name UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 4, [strinevent_descrip UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 5, [strinevent_date UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 6, [strinevent_length UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 7, [strinClasscode UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 8, [strinlast_update UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 9, [strinevent_update_num UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 10, [strincal_name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 11, [strincal_key UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(insertStatement);// executing query
    sqlite3_finalize(insertStatement);
}
*/
#pragma  mark-insert all table data addUsercreatedCals calendars
- (void)addUsercreatedCals:(NSMutableDictionary *)dictContentData
{
    sqlite3_stmt *insertStatement; // statement created
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * strUserId=[userDefaults valueForKey:@"UserId"];
    // Update Query
    const char *sql = "INSERT INTO created(_user_email, _cal_key,_cal_identifier,_cal_name,_cal_descrip,_cal_creator,_class_num,_disc_num,_last_update,_class_info,_cal_type,_class_code,_collab_pass,_private_key,_registration_date,_cal_update_num) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    if (sqlite3_prepare_v2(database, sql, -1, &insertStatement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }// if
    
   
    
    NSString *strinCal_type =[dictContentData objectForKey:@"cal_type"];
    if ([strinCal_type isEqual:[NSNull null]])
    {
        strinCal_type=@" ";
        
    }
    else
    {
        strinCal_type =[dictContentData objectForKey:@"cal_type"];
    }
    
    NSString *strinCal_key =[dictContentData objectForKey:@"cal_key"];
    if ([strinCal_key isEqual:[NSNull null]])
    {
        strinCal_key=@" ";
        
    }
    else
    {
        strinCal_key =[dictContentData objectForKey:@"cal_key"];
    }
    
    NSString *strinCal_identifier =[dictContentData objectForKey:@"cal_identifier"];
    if ([strinCal_identifier isEqual:[NSNull null]])
    {
        strinCal_identifier=@" ";
        
    }
    else
    {
        strinCal_identifier =[dictContentData objectForKey:@"cal_identifier"];
    }
    
    NSString *strinCal_descrip =[dictContentData objectForKey:@"cal_descrip"];
    if ([strinCal_descrip isEqual:[NSNull null]])
    {
        strinCal_descrip=@" ";
        
    }
    else
    {
        strinCal_descrip =[dictContentData objectForKey:@"cal_descrip"];
    }
    
    NSString *strinCal_creator =[dictContentData objectForKey:@"cal_creator"];
    if ([strinCal_creator isEqual:[NSNull null]])
    {
        strinCal_creator=@" ";
        
    }
    else
    {
        strinCal_creator =[dictContentData objectForKey:@"cal_creator"];
    }
    NSString *strinClasscode =[dictContentData objectForKey:@"class_code"];
    if ([strinClasscode isEqual:[NSNull null]]) {
        strinClasscode=@" ";

    }
    else
    {
        strinClasscode =[dictContentData objectForKey:@"class_code"];
    }
    NSString *strinClassnum =[dictContentData objectForKey:@"class_num"];
    if ([strinClassnum isEqual:[NSNull null]]) {
        strinClassnum=@" ";

    }
    else
    {
        strinClassnum =[dictContentData objectForKey:@"class_num"];
    }
    
    NSString *strinClass_info =[dictContentData objectForKey:@"class_info"];
    if ([strinClass_info isEqual:[NSNull null]]) {
        strinClass_info=@" ";
        
    }
    else
    {
        strinClass_info =[dictContentData objectForKey:@"class_info"];
        
    }
    
    
    
    NSString *strinCollabpass =[dictContentData objectForKey:@"collab_pass"];
    if ([strinCollabpass isEqual:[NSNull null]]) {
        strinCollabpass=@" ";

    }
    else
    {
        strinCollabpass =[dictContentData objectForKey:@"collab_pass"];

    }
    NSString *strinDiscnum =[dictContentData objectForKey:@"disc_num"];
    if ([strinDiscnum isEqual:[NSNull null]]) {
        strinDiscnum=@" ";

    }
    else
    {
        strinDiscnum =[dictContentData objectForKey:@"disc_num"];

    }
    NSString *strinPrivate_key =[dictContentData objectForKey:@"private_key"];
    if ([strinPrivate_key isEqual:[NSNull null]]) {
        strinPrivate_key=@" ";

    }
    else
    {
        strinPrivate_key =[dictContentData objectForKey:@"private_key"];
    }
    NSString *strinlast_update =[dictContentData objectForKey:@"last_update"];
    if ([strinlast_update isEqual:[NSNull null]]) {
        strinlast_update=@" ";
        
    }
    else
    {
        strinlast_update =[dictContentData objectForKey:@"last_update"];
    }
    
    NSString *strinRegistration_date =[dictContentData objectForKey:@"registration_date"];
    if ([strinRegistration_date isEqual:[NSNull null]]) {
        strinRegistration_date=@" ";
        
    }
    else
    {
        strinRegistration_date =[dictContentData objectForKey:@"registration_date"];
    }
    
    NSString *strinCal_name =[dictContentData objectForKey:@"cal_name"];
    if ([strinCal_name isEqual:[NSNull null]]) {
        strinCal_name=@" ";
        
    }
    else
    {
        strinCal_name =[dictContentData objectForKey:@"cal_name"];
    }
    
    NSString *strinCal_update_num =[dictContentData objectForKey:@"cal_update_num"];
    if ([strinCal_update_num isEqual:[NSNull null]])
    {
        strinCal_update_num=@" ";
        
    }
    else
    {
        strinCal_update_num =[dictContentData objectForKey:@"cal_update_num"];
    }

//    _user_email, _cal_key,_cal_identifier,_cal_name,_cal_descrip,_cal_creator,_class_num,_disc_num,_last_update,_class_info,cal_update_num) values (?,?,?,?,?,?,?,?,?,?,?)";

    sqlite3_bind_text(insertStatement, 1,[strUserId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 2, [strinCal_key UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 3, [strinCal_identifier UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 4, [strinCal_name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 5, [strinCal_descrip UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 6, [strinCal_creator UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 7, [strinClassnum UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 8, [strinDiscnum UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 9, [strinlast_update UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 10, [strinClass_info UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 11, [strinCal_type UTF8String], -1, SQLITE_TRANSIENT);
    
    
    sqlite3_bind_text(insertStatement, 12, [strinClasscode UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 13, [strinCollabpass UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 14, [strinPrivate_key UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 15, [strinRegistration_date UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertStatement, 16, [strinCal_update_num UTF8String], -1, SQLITE_TRANSIENT);
    
    
    
    sqlite3_step(insertStatement);// executing query
    sqlite3_finalize(insertStatement);
}
#pragma  mark-insert all table data HelpList
- (void)addHelpList:(NSMutableDictionary *)dictContentData
{
    sqlite3_stmt *insertStatement; // statement created
    // Update Query
    const char *sql = "INSERT INTO appHelp(_question_text,_answer,_question_code) values (?,?,?)";
    if (sqlite3_prepare_v2(database, sql, -1, &insertStatement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }// if
    
    sqlite3_bind_text(insertStatement, 1,[[dictContentData objectForKey:@"question_text"] UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 2, [[dictContentData objectForKey:@"question_code"] UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insertStatement, 3, [[dictContentData objectForKey:@"answer"] UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_step(insertStatement);// executing query
    sqlite3_finalize(insertStatement);
}
#pragma mark- Delete All Table
//Delete All

-(void)deleteAllRecoredFromTbl:(NSString *)tblName
{
    sqlite3_stmt *deleteStmt;
    const char *sql =[[NSString stringWithFormat:@"delete from %@",tblName] UTF8String];
    
    if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK){
        NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
        return;
	}
    
	if (SQLITE_DONE != sqlite3_step(deleteStmt))
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmt);
    
}
//Get All Subscriptions’ Data
#pragma mark- Get All  Table
-(NSMutableDictionary *)getSubscriptionsData:(NSString *)strUserid
{
    NSMutableDictionary *DicReturn=[[NSMutableDictionary alloc]init];
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM Subscriptions’ WHERE _user_email='%@'",strUserid];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *subId=(char *) sqlite3_column_text(statement, 0);
            char *UserEmail=(char *) sqlite3_column_text(statement, 1);
            char *LastUpadate=(char *) sqlite3_column_text(statement,2);
            char *CalCreator=(char *) sqlite3_column_text(statement,3);
            char *CalKey=(char *) sqlite3_column_text(statement,4);
            char *CalDesc=(char *) sqlite3_column_text(statement,5);
            char *CalIdent=(char *) sqlite3_column_text(statement,6);
            char *CalName=(char *) sqlite3_column_text(statement,7);
            char *RegistrationDate=(char *) sqlite3_column_text(statement,8);
            
            char *private_key=(char *) sqlite3_column_text(statement, 9);
            char *disc_num=(char *) sqlite3_column_text(statement,10);
            char *collab_pass=(char *) sqlite3_column_text(statement,11);
            char *class_num=(char *) sqlite3_column_text(statement,12);
            char *class_info=(char *) sqlite3_column_text(statement,13);
            char *class_code=(char *) sqlite3_column_text(statement,14);
            char *cal_update_num=(char *) sqlite3_column_text(statement,15);
            char *cal_type=(char *) sqlite3_column_text(statement,16);
            //creating refrence strings
            NSString* strsubId;
            NSString* strUserEmail;
            NSString* strLastUpadate;
            NSString* strCalCreator;
            NSString* strCalKey;
            NSString* strCalDesc;
            NSString* strCalIdent;
            NSString* strCalName;
            NSString* strRegistrationDate;
            
            NSString* strPrivate_key;
            NSString* strDisc_num;
            NSString* strCollab_pass;
            NSString* strClass_num;
            NSString* strClass_info;
            NSString* strClass_code;
            NSString* strCal_update_num;
            NSString* strCal_type;
            
            //test all columns value nil or not
            
            if(subId!=nil)
                strsubId=[[NSString alloc] initWithUTF8String:subId];
            else
                strsubId=[[NSString alloc] initWithString:@" "];
            
            if(UserEmail!=nil)
                strUserEmail=[[NSString alloc] initWithUTF8String:UserEmail];
            else
                strUserEmail=[[NSString alloc] initWithString:@" "];
            
            if(LastUpadate!=nil)
                strLastUpadate=[[NSString alloc] initWithUTF8String:LastUpadate];
            else
                strLastUpadate=[[NSString alloc] initWithString:@" "];
            
            if(CalCreator!=nil)
                strCalCreator=[[NSString alloc] initWithUTF8String:CalCreator];
            else
                strCalCreator=[[NSString alloc]  initWithString:@" "];
            
            if(CalKey!=nil)
                strCalKey=[[NSString alloc] initWithUTF8String:CalKey];
            else
                strCalKey=[[NSString alloc] initWithString:@" "];
            
            
            if(CalDesc!=nil)
                strCalDesc=[[NSString alloc] initWithUTF8String:CalDesc];
            else
                strCalDesc=[[NSString alloc] initWithString:@" "];
            
            if(CalIdent!=nil)
                strCalIdent=[[NSString alloc] initWithUTF8String:CalIdent];
            else
                strCalIdent=[[NSString alloc] initWithString:@" "];
            
            
            if(CalName!=nil)
                strCalName=[[NSString alloc] initWithUTF8String:CalName];
            else
                strCalName=[[NSString alloc] initWithString:@" "];
            
            if(RegistrationDate!=nil)
                strRegistrationDate=[[NSString alloc] initWithUTF8String:RegistrationDate];
            else
                strRegistrationDate=[[NSString alloc] initWithString:@" "];

           
            
            if(private_key!=nil)
                strPrivate_key=[[NSString alloc] initWithUTF8String:private_key];
            else
                strPrivate_key=[[NSString alloc] initWithString:@" "];
            
            if(disc_num!=nil)
                strDisc_num=[[NSString alloc] initWithUTF8String:disc_num];
            else
                strDisc_num=[[NSString alloc] initWithString:@" "];
            
            if(collab_pass!=nil)
                strCollab_pass=[[NSString alloc] initWithUTF8String:collab_pass];
            else
                strCollab_pass=[[NSString alloc] initWithString:@" "];
            
            if(class_num!=nil)
                strClass_num=[[NSString alloc] initWithUTF8String:class_num];
            else
                strClass_num=[[NSString alloc] initWithString:@" "];
            
            if(class_info!=nil)
                strClass_info=[[NSString alloc] initWithUTF8String:class_info];
            else
                strClass_info=[[NSString alloc] initWithString:@" "];
            
            if(class_code!=nil)
                strClass_code=[[NSString alloc] initWithUTF8String:class_code];
            else
                strClass_code=[[NSString alloc] initWithString:@" "];
            
            if(cal_update_num!=nil)
                strCal_update_num=[[NSString alloc] initWithUTF8String:cal_update_num];
            else
                strCal_update_num=[[NSString alloc] initWithString:@" "];
            
            if(cal_type!=nil)
                strCal_type=[[NSString alloc] initWithUTF8String:cal_type];
            else
                strCal_type=[[NSString alloc] initWithString:@" "];
            
            
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strsubId forKey:@"notification_id"];
            [eventInfo setValue:strUserEmail forKey:@"UserEmail"];
            [eventInfo setObject:strLastUpadate forKey:@"last_update"];
            [eventInfo setValue:strCalCreator forKey:@"cal_creator"];
            [eventInfo setValue:strCalKey forKey:@"cal_key"];
            [eventInfo setValue:strCalDesc forKey:@"cal_descrip"];
            [eventInfo setValue:strCalIdent forKey:@"cal_identifier"];
            [eventInfo setValue:strCalName forKey:@"cal_name"];
            [eventInfo setValue:strRegistrationDate forKey:@"registration_date"];
            
            [eventInfo setValue:strPrivate_key forKey:@"private_key"];
            [eventInfo setObject:strDisc_num forKey:@"disc_num"];
            [eventInfo setValue:strCollab_pass forKey:@"collab_pass"];
            [eventInfo setValue:strClass_num forKey:@"class_num"];
            [eventInfo setValue:strClass_info forKey:@"class_info"];
            [eventInfo setValue:strClass_code forKey:@"class_code"];
            [eventInfo setValue:strCal_update_num forKey:@"cal_update_num"];
            [eventInfo setValue:strCal_type forKey:@"cal_type"];
            
            [arrReturn addObject:eventInfo];
            
        }
        [DicReturn setValue:arrReturn forKey:@"subscriptions"];
        [DicReturn setValue:@"1" forKey:@"success"];
    }
    sqlite3_finalize(statement);
    
    return DicReturn;
}
-(NSMutableDictionary *)getCreatedData:(NSString *)strUserid
{
    NSMutableDictionary *DicReturn=[[NSMutableDictionary alloc]init];
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM created WHERE _user_email='%@'",strUserid];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *creId=(char *) sqlite3_column_text(statement, 0);
             char *email=(char *) sqlite3_column_text(statement, 1);
            char *cal_key=(char *) sqlite3_column_text(statement, 2);
            char *cal_identifier=(char *) sqlite3_column_text(statement,3);
            char *cal_name=(char *) sqlite3_column_text(statement,4);
            char *cal_descrip=(char *) sqlite3_column_text(statement,5);
            char *cal_creator=(char *) sqlite3_column_text(statement,6);
            char *class_num =(char *) sqlite3_column_text(statement,7);
            char *disc_num=(char *) sqlite3_column_text(statement,8);
            char *last_update=(char *) sqlite3_column_text(statement,9);
            char *class_info=(char *) sqlite3_column_text(statement,10);
            
            char *cal_type=(char *) sqlite3_column_text(statement,11);
            char *class_code =(char *) sqlite3_column_text(statement,12);
            char *collab_pass=(char *) sqlite3_column_text(statement,13);
            
            char *private_key=(char *) sqlite3_column_text(statement,14);
            char *registration_date=(char *) sqlite3_column_text(statement,15);
            
            char *cal_update_num =(char *) sqlite3_column_text(statement,16);
          
            //creating refrence strings
            NSString* strcreId;
             NSString* strEmail;
            NSString* strcal_key;
            NSString* strcal_identifier;
            NSString* strcal_name;
            NSString* strcal_descrip;
            NSString* strcal_creator;
            NSString* strclass_num;
            NSString* strdisc_num;
            
            NSString* strlast_update;
            NSString* strClass_info;
            
            NSString* strCal_type;
            NSString* strClass_code;
            
            NSString* strcollab_pass;
            NSString* strprivate_key;
            NSString* strregistration_date;
            
            NSString* strcal_update_num;
            
            //test all columns value nil or not
            
            if(creId!=nil)
                strcreId=[[NSString alloc] initWithUTF8String:creId];
            else
                strcreId=[[NSString alloc] initWithString:@" "];
            if(email!=nil)
                strEmail=[[NSString alloc] initWithUTF8String:email];
            else
                strEmail=[[NSString alloc] initWithString:@" "];
            
            if(cal_key!=nil)
                strcal_key=[[NSString alloc] initWithUTF8String:cal_key];
            else
                strcal_key=[[NSString alloc] initWithString:@" "];
            
            if(cal_identifier!=nil)
                strcal_identifier=[[NSString alloc] initWithUTF8String:cal_identifier];
            else
                strcal_identifier=[[NSString alloc] initWithString:@" "];
            
            if(cal_name!=nil)
                strcal_name=[[NSString alloc] initWithUTF8String:cal_name];
            else
                strcal_name=[[NSString alloc]  initWithString:@" "];
            
            if(cal_descrip!=nil)
                strcal_descrip=[[NSString alloc] initWithUTF8String:cal_descrip];
            else
                strcal_descrip=[[NSString alloc] initWithString:@" "];
            
            
            if(cal_creator!=nil)
                strcal_creator=[[NSString alloc] initWithUTF8String:cal_creator];
            else
                strcal_creator=[[NSString alloc] initWithString:@" "];
            
//            if(isSyllabi!=nil)
//                strisSyllabi=[[NSString alloc] initWithUTF8String:isSyllabi];
//            else
//                strisSyllabi=[[NSString alloc] initWithString:@" "];
            
            
            if(class_num!=nil)
                strclass_num=[[NSString alloc] initWithUTF8String:class_num];
            else
                strclass_num=[[NSString alloc] initWithString:@" "];
            
            if(disc_num!=nil)
                strdisc_num=[[NSString alloc] initWithUTF8String:disc_num];
            else
                strdisc_num=[[NSString alloc] initWithString:@" "];
            
            if(last_update!=nil)
                strlast_update=[[NSString alloc] initWithUTF8String:last_update];
            else
                strlast_update=[[NSString alloc] initWithString:@" "];
            
            
            if(class_info!=nil)
                strClass_info=[[NSString alloc] initWithUTF8String:class_info];
            else
                strClass_info=[[NSString alloc] initWithString:@" "];
            
            if(cal_type!=nil)
                strCal_type=[[NSString alloc] initWithUTF8String:cal_type];
            else
                strCal_type=[[NSString alloc] initWithString:@" "];
            
            if(class_code!=nil)
                strClass_code=[[NSString alloc] initWithUTF8String:class_code];
            else
                strClass_code=[[NSString alloc] initWithString:@" "];
            
            if(collab_pass!=nil)
                strcollab_pass=[[NSString alloc] initWithUTF8String:collab_pass];
            else
                strcollab_pass=[[NSString alloc] initWithString:@" "];
            
            if(private_key!=nil)
                strprivate_key=[[NSString alloc] initWithUTF8String:private_key];
            else
                strprivate_key=[[NSString alloc] initWithString:@" "];
            
            if(registration_date!=nil)
                strregistration_date=[[NSString alloc] initWithUTF8String:registration_date];
            else
                strregistration_date=[[NSString alloc] initWithString:@" "];
            
            
            if(cal_update_num!=nil)
                strcal_update_num=[[NSString alloc] initWithUTF8String:cal_update_num];
            else
                strcal_update_num=[[NSString alloc] initWithString:@" "];

            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strcreId forKey:@"CreIc"];
            [eventInfo setValue:strEmail forKey:@"UserEmail"];
            
            [eventInfo setValue:strcal_key forKey:@"cal_key"];
            [eventInfo setObject:strcal_identifier forKey:@"cal_identifier"];
            [eventInfo setValue:strcal_name forKey:@"cal_name"];
            [eventInfo setValue:strcal_descrip forKey:@"cal_descrip"];
            [eventInfo setValue:strcal_creator forKey:@"cal_creator"];
            [eventInfo setValue:strdisc_num forKey:@"disc_num"];
            [eventInfo setValue:strlast_update forKey:@"last_update"];
            [eventInfo setValue:strClass_info forKey:@"class_info"];
            [eventInfo setValue:strCal_type forKey:@"cal_type"];
            [eventInfo setValue:strClass_code forKey:@"class_code"];
            [eventInfo setValue:strcollab_pass forKey:@"collab_pass"];
            [eventInfo setValue:strprivate_key forKey:@"private_key"];
            [eventInfo setValue:strregistration_date forKey:@"registration_date"];
            [eventInfo setValue:strcal_update_num forKey:@"cal_update_num"];
            [arrReturn addObject:eventInfo];
            
        }
        [DicReturn setValue:arrReturn forKey:@"allCals"];
        [DicReturn setValue:@"1" forKey:@"success"];
    }
    sqlite3_finalize(statement);
    
    return DicReturn;
}


-(NSMutableDictionary *)QuestionAnsewerList
{
    NSMutableDictionary *DicReturn=[[NSMutableDictionary alloc]init];
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM appHelp"];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *HelpId=(char *) sqlite3_column_text(statement, 0);
            char *Question_text =(char *) sqlite3_column_text(statement, 1);
            char *Question_code=(char *) sqlite3_column_text(statement,2);
            char *Answer=(char *) sqlite3_column_text(statement,3);

            //creating refrence strings
            NSString* strHelpId;
            NSString* strQuestion_text;
            NSString* strAnswer;
            NSString* strQuestion_code;
           
            
            //test all columns value nil or not
            
            if(HelpId!=nil)
                strHelpId=[[NSString alloc] initWithUTF8String:HelpId];
            else
                strHelpId=[[NSString alloc] initWithString:@" "];
            
            if(Question_text!=nil)
                strQuestion_text=[[NSString alloc] initWithUTF8String:Question_text];
            else
                strQuestion_text=[[NSString alloc] initWithString:@" "];
            
            if(Answer!=nil)
                strAnswer=[[NSString alloc] initWithUTF8String:Answer];
            else
                strAnswer=[[NSString alloc] initWithString:@" "];
            
            if(Question_code!=nil)
                strQuestion_code=[[NSString alloc] initWithUTF8String:Question_code];
            else
                strQuestion_code=[[NSString alloc]  initWithString:@" "];
            
           
            
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strHelpId forKey:@"HelpId"];
            [eventInfo setValue:strQuestion_text forKey:@"question_text"];
            [eventInfo setObject:strAnswer forKey:@"answer"];
            [eventInfo setValue:strQuestion_code forKey:@"question_code"];
            [arrReturn addObject:eventInfo];
            
            
        }
        [DicReturn setValue:arrReturn forKey:@"newHelp"];
    }
    sqlite3_finalize(statement);
    
    return DicReturn;
}
-(NSMutableDictionary *)eventInfoList:(NSString *)strUserid
{
    NSMutableDictionary *DicReturn=[[NSMutableDictionary alloc]init];
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM eventInfo WHERE _user_email='%@'",strUserid];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *EventId=(char *) sqlite3_column_text(statement, 0);
            char *UserEmail =(char *) sqlite3_column_text(statement, 1);
            char *Event_key=(char *) sqlite3_column_text(statement,2);
            char *Event_name=(char *) sqlite3_column_text(statement,3);
            
            char *Event_descrip=(char *) sqlite3_column_text(statement,4);
            char *Event_date =(char *) sqlite3_column_text(statement, 5);
            char *Event_length=(char *) sqlite3_column_text(statement,6);
            char *InClassCode=(char *) sqlite3_column_text(statement,7);
            
            char *Cal_key=(char *) sqlite3_column_text(statement, 8);
            char *last_update =(char *) sqlite3_column_text(statement, 9);
            char *EventUpdate_num=(char *) sqlite3_column_text(statement,10);
            char *Cal_name=(char *) sqlite3_column_text(statement,11);
            
            //creating refrence strings
            NSString* strEventId;
            NSString* strUserEmail;
            NSString* strEvent_key;
            NSString* strEvent_name;
            
            NSString* strEvent_descrip;
            NSString* strEvent_date;
            NSString* strEvent_length;
            NSString* strInClassCode;
            
            NSString* strCal_key;
            NSString* strlast_update;
            NSString* strEventUpdate_num;
            NSString* strCal_name;
            //test all columns value nil or not
            
            if(EventId!=nil)
                strEventId=[[NSString alloc] initWithUTF8String:EventId];
            else
                strEventId=[[NSString alloc] initWithString:@" "];
            
            if(UserEmail!=nil)
                strUserEmail=[[NSString alloc] initWithUTF8String:UserEmail];
            else
                strUserEmail=[[NSString alloc] initWithString:@" "];
            
            if(Event_key!=nil)
                strEvent_key=[[NSString alloc] initWithUTF8String:Event_key];
            else
                strEvent_key=[[NSString alloc] initWithString:@" "];
            
            if(Event_name!=nil)
                strEvent_name=[[NSString alloc] initWithUTF8String:Event_name];
            else
                strEvent_name=[[NSString alloc]  initWithString:@" "];
            
           
            if(Event_descrip!=nil)
                strEvent_descrip=[[NSString alloc] initWithUTF8String:Event_descrip];
            else
                strEvent_descrip=[[NSString alloc] initWithString:@" "];
            
            if(Event_date!=nil)
                strEvent_date=[[NSString alloc] initWithUTF8String:Event_date];
            else
                strEvent_date=[[NSString alloc] initWithString:@" "];
            
            if(Event_length!=nil)
                strEvent_length=[[NSString alloc] initWithUTF8String:Event_length];
            else
                strEvent_length=[[NSString alloc] initWithString:@" "];
            
            if(InClassCode!=nil)
                strInClassCode=[[NSString alloc] initWithUTF8String:InClassCode];
            else
                strInClassCode=[[NSString alloc]  initWithString:@" "];
            
            if(Cal_key!=nil)
                strCal_key=[[NSString alloc] initWithUTF8String:Cal_key];
            else
                strCal_key=[[NSString alloc] initWithString:@" "];
            
            if(last_update!=nil)
                strlast_update=[[NSString alloc] initWithUTF8String:last_update];
            else
                strlast_update=[[NSString alloc] initWithString:@" "];
            
            if(EventUpdate_num!=nil)
                strEventUpdate_num=[[NSString alloc] initWithUTF8String:EventUpdate_num];
            else
                strEventUpdate_num=[[NSString alloc] initWithString:@" "];
            
            if(Cal_name!=nil)
                strCal_name=[[NSString alloc] initWithUTF8String:Cal_name];
            else
                strCal_name=[[NSString alloc]  initWithString:@" "];
            
           
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strEventId forKey:@"EventId"];
            [eventInfo setValue:strUserEmail forKey:@"UserEmail"];
            [eventInfo setObject:strEvent_key forKey:@"event_key"];
            [eventInfo setValue:strEvent_name forKey:@"event_name"];
            
            [eventInfo setValue:strEvent_descrip forKey:@"event_descrip"];
            [eventInfo setValue:strEvent_date forKey:@"event_date"];
            [eventInfo setObject:strEvent_length forKey:@"event_length"];
            [eventInfo setValue:strInClassCode forKey:@"in_class_code"];
            
            [eventInfo setValue:strCal_key forKey:@"cal_key"];
            [eventInfo setValue:strlast_update forKey:@"last_update"];
            [eventInfo setObject:strEventUpdate_num forKey:@"event_update_num"];
            [eventInfo setValue:strCal_name forKey:@"cal_name"];
            [arrReturn addObject:eventInfo];
            
            
        }
        [DicReturn setValue:arrReturn forKey:@"newEvents"];
         [DicReturn setValue:@"1" forKey:@"success"];
        
    }
    sqlite3_finalize(statement);
    
    return DicReturn;
}
-(NSMutableDictionary *)eventInfoList_Calendar:(NSString *)strCal_Key
{
    appobject=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *DicReturn=[[NSMutableDictionary alloc]init];
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM eventInfo WHERE _cal_key='%@'",strCal_Key];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *EventId=(char *) sqlite3_column_text(statement, 0);
            char *UserEmail =(char *) sqlite3_column_text(statement, 1);
            char *Event_key=(char *) sqlite3_column_text(statement,2);
            char *Event_name=(char *) sqlite3_column_text(statement,3);
            
            char *Event_descrip=(char *) sqlite3_column_text(statement,4);
            char *Event_date =(char *) sqlite3_column_text(statement, 5);
            char *Event_length=(char *) sqlite3_column_text(statement,6);
            char *InClassCode=(char *) sqlite3_column_text(statement,7);
            
            char *Cal_key=(char *) sqlite3_column_text(statement, 8);
            char *last_update =(char *) sqlite3_column_text(statement, 9);
            char *EventUpdate_num=(char *) sqlite3_column_text(statement,10);
            char *Cal_name=(char *) sqlite3_column_text(statement,11);
            
            //creating refrence strings
            NSString* strEventId;
            NSString* strUserEmail;
            NSString* strEvent_key;
            NSString* strEvent_name;
            
            NSString* strEvent_descrip;
            NSString* strEvent_date;
            NSString* strEvent_length;
            NSString* strInClassCode;
            
            NSString* strCal_key;
            NSString* strlast_update;
            NSString* strEventUpdate_num;
            NSString* strCal_name;
            //test all columns value nil or not
            
            if(EventId!=nil)
                strEventId=[[NSString alloc] initWithUTF8String:EventId];
            else
                strEventId=[[NSString alloc] initWithString:@" "];
            
            if(UserEmail!=nil)
                strUserEmail=[[NSString alloc] initWithUTF8String:UserEmail];
            else
                strUserEmail=[[NSString alloc] initWithString:@" "];
            
            if(Event_key!=nil)
                strEvent_key=[[NSString alloc] initWithUTF8String:Event_key];
            else
                strEvent_key=[[NSString alloc] initWithString:@" "];
            
            if(Event_name!=nil)
                strEvent_name=[[NSString alloc] initWithUTF8String:Event_name];
            else
                strEvent_name=[[NSString alloc]  initWithString:@" "];
            
            
            if(Event_descrip!=nil)
                strEvent_descrip=[[NSString alloc] initWithUTF8String:Event_descrip];
            else
                strEvent_descrip=[[NSString alloc] initWithString:@" "];
            
            if(Event_date!=nil)
                strEvent_date=[[NSString alloc] initWithUTF8String:Event_date];
            else
                strEvent_date=[[NSString alloc] initWithString:@" "];
            
            if(Event_length!=nil)
                strEvent_length=[[NSString alloc] initWithUTF8String:Event_length];
            else
                strEvent_length=[[NSString alloc] initWithString:@" "];
            
            if(InClassCode!=nil)
                strInClassCode=[[NSString alloc] initWithUTF8String:InClassCode];
            else
                strInClassCode=[[NSString alloc]  initWithString:@" "];
            
            if(Cal_key!=nil)
                strCal_key=[[NSString alloc] initWithUTF8String:Cal_key];
            else
                strCal_key=[[NSString alloc] initWithString:@" "];
            
            if(last_update!=nil)
                strlast_update=[[NSString alloc] initWithUTF8String:last_update];
            else
                strlast_update=[[NSString alloc] initWithString:@" "];
            
            if(EventUpdate_num!=nil)
                strEventUpdate_num=[[NSString alloc] initWithUTF8String:EventUpdate_num];
            else
                strEventUpdate_num=[[NSString alloc] initWithString:@" "];
            
            if(Cal_name!=nil ||Cal_name !=NULL)
                strCal_name=[[NSString alloc] initWithUTF8String:Cal_name];
            else
                NSLog(@"%@",appobject.Cal_name);
                strCal_name=[[NSString alloc]  initWithString:appobject.Cal_name];
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strEventId forKey:@"EventId"];
            [eventInfo setValue:strUserEmail forKey:@"UserEmail"];
            [eventInfo setObject:strEvent_key forKey:@"event_key"];
            [eventInfo setValue:strEvent_name forKey:@"event_name"];
            
            [eventInfo setValue:strEvent_descrip forKey:@"event_descrip"];
            [eventInfo setValue:strEvent_date forKey:@"event_date"];
            [eventInfo setObject:strEvent_length forKey:@"event_length"];
            [eventInfo setValue:strInClassCode forKey:@"in_class_code"];
            
            [eventInfo setValue:strCal_key forKey:@"cal_key"];
            [eventInfo setValue:strlast_update forKey:@"last_update"];
            [eventInfo setObject:strEventUpdate_num forKey:@"event_update_num"];
            [eventInfo setValue:strCal_name forKey:@"cal_name"];
            [arrReturn addObject:eventInfo];
            
            
        }
        [DicReturn setValue:arrReturn forKey:@"events"];
        [DicReturn setValue:@"1" forKey:@"success"];
        
    }
    sqlite3_finalize(statement);
    
    return DicReturn;
}
-(NSMutableDictionary *)getUserInfo:(NSString *)strUserid
{
    NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM userInfo WHERE _user_email='%@'",strUserid];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *Uid=(char *) sqlite3_column_text(statement, 0);
            char *UserEmail =(char *) sqlite3_column_text(statement, 1);
            char *first_name=(char *) sqlite3_column_text(statement,2);
            char *last_name=(char *) sqlite3_column_text(statement,3);
            
            char *registration_date=(char *) sqlite3_column_text(statement,4);
            char *password  =(char *) sqlite3_column_text(statement, 5);
            char *salt=(char *) sqlite3_column_text(statement,6);
            char *confirmed=(char *) sqlite3_column_text(statement,7);
            
            char *private_cal=(char *) sqlite3_column_text(statement, 8);
            char *_city_num =(char *) sqlite3_column_text(statement, 9);
            
            //creating refrence strings
            NSString* strUid;
            NSString* strUserEmail;
            NSString* strfirst_name;
            NSString* strlast_name;
            
            NSString* strRegistration_date;
            NSString* strpassword;
            NSString* strsalt;
            NSString* strconfirmed;
            
            NSString* strprivate_cal;
            NSString* str_city_num;
           
            //test all columns value nil or not
            
            if(Uid!=nil)
                strUid=[[NSString alloc] initWithUTF8String:Uid];
            else
                strUid=[[NSString alloc] initWithString:@" "];
            
            if(UserEmail!=nil)
                strUserEmail=[[NSString alloc] initWithUTF8String:UserEmail];
            else
                strUserEmail=[[NSString alloc] initWithString:@" "];
            
            if(first_name!=nil)
                strfirst_name=[[NSString alloc] initWithUTF8String:first_name];
            else
                strfirst_name=[[NSString alloc] initWithString:@" "];
            
            if(last_name!=nil)
                strlast_name=[[NSString alloc] initWithUTF8String:last_name];
            else
                strlast_name=[[NSString alloc]  initWithString:@" "];
            
            
            if(registration_date!=nil)
                strRegistration_date=[[NSString alloc] initWithUTF8String:registration_date];
            else
                strRegistration_date=[[NSString alloc] initWithString:@" "];
            
            if(password!=nil)
                strpassword=[[NSString alloc] initWithUTF8String:password];
            else
                strpassword=[[NSString alloc] initWithString:@" "];
            
            if(salt!=nil)
                strsalt=[[NSString alloc] initWithUTF8String:salt];
            else
                strsalt=[[NSString alloc] initWithString:@" "];
            
            if(confirmed!=nil)
                strconfirmed=[[NSString alloc] initWithUTF8String:confirmed];
            else
                strconfirmed=[[NSString alloc]  initWithString:@" "];
            
            if(private_cal!=nil)
                strprivate_cal=[[NSString alloc] initWithUTF8String:private_cal];
            else
                strprivate_cal=[[NSString alloc] initWithString:@" "];
            
            if(_city_num!=nil)
                str_city_num=[[NSString alloc] initWithUTF8String:_city_num];
            else
                str_city_num=[[NSString alloc] initWithString:@" "];
            
            //set values in the Dictonary
            [eventInfo setValue:strUid forKey:@"UId"];
            [eventInfo setValue:strUserEmail forKey:@"user_email"];
            [eventInfo setObject:strfirst_name forKey:@"first_name"];
            [eventInfo setValue:strlast_name forKey:@"last_name"];
            
            [eventInfo setValue:strRegistration_date forKey:@"registration_date"];
            [eventInfo setValue:strpassword forKey:@"password"];
            [eventInfo setObject:strsalt forKey:@"salt"];
            [eventInfo setValue:strconfirmed forKey:@"confirmed"];
            
            [eventInfo setValue:strprivate_cal forKey:@"private_cal"];
            [eventInfo setValue:str_city_num forKey:@"city_num"];
            
        }
    }
    sqlite3_finalize(statement);
    
    return eventInfo;
}
#pragma mark check yes or no
//Subcripton Wher CalKey
-(BOOL)getSubscriptionsDataCheck:(NSString *)strCal_Key userId:(NSString *)userId
{
       NSString *query = [NSString stringWithFormat:@"SELECT * FROM Subscriptions’ WHERE _cal_key='%@' AND _user_email='%@'",strCal_Key,userId];
    sqlite3_stmt *statement;
    int ValueCheck = 0;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        // ValueCheck=0;
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ValueCheck++;
                   }
    }
             else{
        }
    
    if (ValueCheck>0) {
        return YES;
    }else{
        return NO;
 
    }
       sqlite3_finalize(statement);
    
    return YES;
}

-(BOOL)getUsercreatedCalsData:(NSString *)strCal_Key userId:(NSString *)userId
{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM created WHERE _cal_key='%@' AND _user_email='%@'",strCal_Key,userId];
    sqlite3_stmt *statement;
    int ValueCheck = 0;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        // ValueCheck=0;
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ValueCheck++;
        }
    }
    else{
    }
    
    if (ValueCheck>0) {
        return YES;
    }else{
        return NO;
        
    }
    sqlite3_finalize(statement);
    
    return YES;

}

-(BOOL)UserInfo:(NSString *)strUserid
{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM userInfo WHERE _user_email='%@'",strUserid];
    sqlite3_stmt *statement;
    int ValueCheck = 0;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        // ValueCheck=0;
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ValueCheck++;
        }
    }
    else{
    }
    
    if (ValueCheck>0) {
        return YES;
    }else{
        return NO;
        
    }
    sqlite3_finalize(statement);
    
    return YES;
    
}
-(BOOL)EventCalendar:(NSString *)strEvent_Key
{
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM eventInfo WHERE _event_key='%@'",strEvent_Key];
    sqlite3_stmt *statement;
    int ValueCheck = 0;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        // ValueCheck=0;
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            ValueCheck++;
        }
    }
    else{
    }
    
    if (ValueCheck>0) {
        return YES;
    }else{
        return NO;
        
    }
    sqlite3_finalize(statement);
    
    return YES;
    
}


#pragma mark Delete data user id
-(void)deleteSubscriptionsData_Userid_id:(NSString *)userid
{
    sqlite3_stmt *deleteStmt;
  //  const char *sql = "delete from subscriptions’ where _user_email = ?";
     NSString *query = [NSString stringWithFormat:@"delete from subscriptions’ where _user_email ='%@'",userid];
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &deleteStmt, NULL) != SQLITE_OK){
        NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(_database));
        return;
	}
	
	//When binding parameters, index starts from 1 and not zero.
    
    
    while (sqlite3_step(deleteStmt) == SQLITE_ROW)
    {
         sqlite3_bind_text(deleteStmt, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        if (SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(_database));
        
        sqlite3_reset(deleteStmt);
    }
    
}

-(void)deletecreatedCalsData_Userid_id:(NSString *)userid
{
    sqlite3_stmt *deleteStmt;
    //  const char *sql = "delete from subscriptions’ where _user_email = ?";
    NSString *query = [NSString stringWithFormat:@"delete from created where _user_email ='%@'",userid];
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &deleteStmt, NULL) != SQLITE_OK){
        NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(_database));
        return;
	}
	
	//When binding parameters, index starts from 1 and not zero.
    
    
    while (sqlite3_step(deleteStmt) == SQLITE_ROW)
    {
        sqlite3_bind_text(deleteStmt, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        if (SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(_database));
        
        sqlite3_reset(deleteStmt);
    }
    
}

-(void)deleteEventsCalsData_Userid_id:(NSString *)userid
{
    sqlite3_stmt *deleteStmt;
    //  const char *sql = "delete from subscriptions’ where _user_email = ?";
    NSString *query = [NSString stringWithFormat:@"delete from eventInfo where _user_email ='%@'",userid];
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &deleteStmt, NULL) != SQLITE_OK){
        NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(_database));
        return;
	}
	
	//When binding parameters, index starts from 1 and not zero.
    
    
    while (sqlite3_step(deleteStmt) == SQLITE_ROW)
    {
        sqlite3_bind_text(deleteStmt, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        if (SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(_database));
        
        sqlite3_reset(deleteStmt);
    }
    
}
-(void)deleteEventsCalsData_Userid_idAndstrEventKey:(NSString *)userid EventKey:(NSString *)strEventKey
{
    sqlite3_stmt *deleteStmt;
    //  const char *sql = "delete from subscriptions’ where _user_email = ?";
    NSString *query = [NSString stringWithFormat:@"delete from eventInfo where _user_email ='%@' AND _event_key ='%@'",userid,strEventKey];
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &deleteStmt, NULL) != SQLITE_OK){
        NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(_database));
        return;
	}
	
	//When binding parameters, index starts from 1 and not zero.
    
    
    while (sqlite3_step(deleteStmt) == SQLITE_ROW)
    {
        sqlite3_bind_text(deleteStmt, 1, [userid UTF8String], -1, SQLITE_TRANSIENT);
        if (SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(_database));
        
        sqlite3_reset(deleteStmt);
    }
    
}

-(void)deleteEventsCalsData_Cal_id:(NSString *)strCalId
{
    sqlite3_stmt *deleteStmt;
    //  const char *sql = "delete from subscriptions’ where _user_email = ?";
    NSString *query = [NSString stringWithFormat:@"delete from eventInfo where _cal_key ='%@'",strCalId];
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &deleteStmt, NULL) != SQLITE_OK){
        NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(_database));
        return;
	}
	
	//When binding parameters, index starts from 1 and not zero.
    
    
    while (sqlite3_step(deleteStmt) == SQLITE_ROW)
    {
        sqlite3_bind_text(deleteStmt, 1, [strCalId UTF8String], -1, SQLITE_TRANSIENT);
        if (SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(_database));
        
        sqlite3_reset(deleteStmt);
    }
    
}


-(void)deleteUserInfoData_id:(NSString *)struserId
{
    sqlite3_stmt *deleteStmt;
    //  const char *sql = "delete from subscriptions’ where _user_email = ?";
    NSString *query = [NSString stringWithFormat:@"delete from userInfo where _user_email ='%@'",struserId];
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &deleteStmt, NULL) != SQLITE_OK){
        NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(_database));
        return;
	}
	
	//When binding parameters, index starts from 1 and not zero.
    
    
    while (sqlite3_step(deleteStmt) == SQLITE_ROW)
    {
        sqlite3_bind_text(deleteStmt, 1, [struserId UTF8String], -1, SQLITE_TRANSIENT);
        if (SQLITE_DONE != sqlite3_step(deleteStmt))
            NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(_database));
        
        sqlite3_reset(deleteStmt);
    }
    
}
#pragma mark- Extas



/*

//addContentData
//  Event Table
//-->New Table
//CREATE TABLE "event" ("event_id" VARCHAR PRIMARY KEY  NOT NULL , "event_title" VARCHAR, "description" VARCHAR, "start_date" VARCHAR, "finish_date" VARCHAR, "event_manager_id" VARCHAR, "city" VARCHAR, "country" VARCHAR, "event_logo" VARCHAR, "location" VARCHAR, "wi_fi" VARCHAR, "wi_fi_password" VARCHAR, "start_time" VARCHAR, "finish_time" VARCHAR)



- (int)insertEventData:(NSString*)strEventId eventTitle:(NSString*)EventTitle eventManagerId:(NSString*)strEventManagerId description:(NSString*)strDescription startDate:(NSString*)strStartDate startTime:(NSString*)strStartTime finishDate:(NSString*)strFinishDate finishTime:(NSString*)strFinishTime city:(NSString*)strCity country:(NSString*)strCountry eventLogo:(NSString*)strEventLogo location:(NSString*)strLocation wifi:(NSString*)strWifi wifiPassword:(NSString*)strWifiPassword
{
    
    int statement_result;
    const char * text2 = "INSERT INTO event (event_id,event_title,event_manager_id,description,start_date,start_time,finish_date,finish_time,city,country,event_logo,location,wi_fi,wi_fi_password) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strEventId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[EventTitle UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[strEventManagerId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,4,[strDescription UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,5,[strStartDate UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,6,[strStartTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,7,[strFinishDate UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,8,[strFinishTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,9,[strCity UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,10,[strCountry UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,11,[strEventLogo UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,12,[strLocation UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,13,[strWifi UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,14,[strWifiPassword UTF8String], -1, SQLITE_TRANSIENT);
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    
    return 1;
}

//Get EventDataById
-(NSMutableDictionary *)getEventDataById:(NSString*)eventid
{
    
    NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM event WHERE event_id='%@'",eventid];
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *eventId=(char *) sqlite3_column_text(statement, 0);
            char *title=(char *) sqlite3_column_text(statement, 1);
            char *managerId=(char *) sqlite3_column_text(statement,2);
            char *desc=(char *) sqlite3_column_text(statement,3);
            char *startDate=(char *) sqlite3_column_text(statement,4);
            char *startTime=(char *) sqlite3_column_text(statement,5);
            char *finishDate=(char *) sqlite3_column_text(statement,6);
            char *finishTime=(char *) sqlite3_column_text(statement,7);
            char *city=(char *) sqlite3_column_text(statement,8);
            char *country=(char *) sqlite3_column_text(statement,9);
            char *eventLogo=(char *) sqlite3_column_text(statement,10);
            char *location=(char *) sqlite3_column_text(statement,11);
            char *wifi=(char *) sqlite3_column_text(statement,12);
            char *wifiPass=(char *) sqlite3_column_text(statement,13);
            
            
            //creating refrence strings
            NSString* strEventId;
            NSString* strTitle;
            NSString* strManagerId;
            NSString* strDesc;
            NSString* strStartDate;
            NSString* strStartTime;
            NSString* strFinishDate;
            NSString* strFinishTime;
            NSString* strCity;
            NSString* strCountry;
            NSString* strEventLogo;
            NSString* strLocation;
            NSString* strWifi;
            NSString* strWifiPass;
            
            //test all columns value nil or not
            
            if(eventId!=nil)
                strEventId=[[NSString alloc] initWithUTF8String:eventId];
            else
                strEventId=[[NSString alloc] initWithString:@" "];
            
            if(title!=nil)
                strTitle=[[NSString alloc] initWithUTF8String:title];
            else
                strTitle=[[NSString alloc] initWithString:@" "];
            
            if(managerId!=nil)
                strManagerId=[[NSString alloc] initWithUTF8String:managerId];
            else
                strManagerId=[[NSString alloc] initWithString:@" "];
            
            if(desc!=nil)
                strDesc=[[NSString alloc] initWithUTF8String:desc];
            else
                strDesc=[[NSString alloc]  initWithString:@" "];
            
            if(startDate!=nil)
                strStartDate=[[NSString alloc] initWithUTF8String:startDate];
            else
                strStartDate=[[NSString alloc]  initWithString:@" "];
            
            if(startTime!=nil)
                strStartTime=[[NSString alloc] initWithUTF8String:startTime];
            else
                strStartTime=[[NSString alloc] initWithString:@" "];
            
            if(finishDate!=nil)
                strFinishDate=[[NSString alloc] initWithUTF8String:finishDate];
            else
                strFinishDate=[[NSString alloc] initWithString:@" "];
            
            if(finishTime!=nil)
                strFinishTime=[[NSString alloc] initWithUTF8String:finishTime];
            else
                strFinishTime=[[NSString alloc] initWithString:@" "];
            
            if(city!=nil)
                strCity=[[NSString alloc] initWithUTF8String:city];
            else
                strCity=[[NSString alloc] initWithString:@" "];
            
            if(country!=nil)
                strCountry=[[NSString alloc] initWithUTF8String:country];
            else
                strCountry=[[NSString alloc] initWithString:@" "];
            
            if(eventLogo!=nil)
                strEventLogo=[[NSString alloc] initWithUTF8String:eventLogo];
            else
                strEventLogo=[[NSString alloc]  initWithString:@" "];
            
            if(location!=nil)
                strLocation=[[NSString alloc] initWithUTF8String:location];
            else
                strLocation=[[NSString alloc] initWithString:@" "];
            
            if(wifi!=nil)
                strWifi=[[NSString alloc] initWithUTF8String:wifi];
            else
                strWifi=[[NSString alloc] initWithString:@" "];
            
            if(wifiPass!=nil)
                strWifiPass=[[NSString alloc] initWithUTF8String:wifiPass];
            else
                strWifiPass=[[NSString alloc] initWithString:@" "];
            
            //set values in the Dictonary
            [eventInfo setValue:strEventId forKey:@"event_id"];
            [eventInfo setValue:strTitle forKey:@"event_title"];
            [eventInfo setObject:strManagerId forKey:@"event_manager_id"];
            [eventInfo setValue:strDesc forKey:@"description"];
            [eventInfo setValue:strStartDate forKey:@"start_date"];
            [eventInfo setValue:strStartTime forKey:@"start_time"];
            [eventInfo setObject:strFinishDate forKey:@"finish_date"];
            [eventInfo setValue:strFinishTime forKey:@"finish_time"];
            [eventInfo setObject:strCity forKey:@"city"];
            [eventInfo setObject:strCountry forKey:@"country"];
            [eventInfo setObject:strEventLogo forKey:@"event_logo"];
            [eventInfo setObject:strLocation forKey:@"location"];
            [eventInfo setObject:strWifi forKey:@"wi_fi"];
            [eventInfo setObject:strWifiPass forKey:@"wi_fi_password"];
            
            //Releasing all string
            [strEventId release];
            [strTitle release];
            [strManagerId release];
            [strDesc release];
            [strStartDate release];
            [strStartTime release];
            [strFinishDate release];
            [strFinishTime release];
            [strCity release];
            [strCountry release];
            [strEventLogo release];
            [strLocation release];
            [strWifi release];
            [strWifiPass release];
            
        }
    }
    sqlite3_finalize(statement);
    
    return eventInfo;
}

//  Hotel Table


//-->New Table
//CREATE TABLE "hotel" ("hotel_id" VARCHAR PRIMARY KEY  NOT NULL , "hotel_name" VARCHAR, "description" VARCHAR, "address" VARCHAR, "telephone" VARCHAR, "website" VARCHAR, "hotel_logo" VARCHAR, "event_id" VARCHAR, "phone_number" VARCHAR, "facebook" VARCHAR, "twitter" VARCHAR)

- (int)insertHotelData:(NSString*)strHotelId hotelName:(NSString*)strHotelName description:(NSString*)strDescription address:(NSString*)strAddress telephone:(NSString*)strTelephone website:(NSString*)strWebsite hotelLogo:(NSString*)strHotelLogo eventId:(NSString*)strEventId phone_number:(NSString*)strphonenumber facebook:(NSString*)facebook twitter:(NSString*)twitter
{
    
    int statement_result;
    const char * text2 = "INSERT INTO hotel (hotel_id,hotel_name,description,address,telephone,website,hotel_logo,event_id,phone_number,facebook,twitter) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strHotelId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[strHotelName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[strDescription UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,4,[strAddress UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,5,[strTelephone UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,6,[strWebsite UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,7,[strHotelLogo UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,8,[strEventId UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insert_statement,9,[strphonenumber UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insert_statement,10,[facebook UTF8String], -1, SQLITE_TRANSIENT);
    
    sqlite3_bind_text(insert_statement,11,[twitter UTF8String], -1, SQLITE_TRANSIENT);
    
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    
    return 1;
}

//Get Hotel info By hotel_id
-(NSMutableDictionary *)getHotelDataByHotelId:(NSString*)hotelid
{
    NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
    
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM hotel WHERE hotel_id='%@'",hotelid];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *hoteId=(char *) sqlite3_column_text(statement, 0);
            char *hotalName=(char *) sqlite3_column_text(statement, 1);
            char *Description=(char *) sqlite3_column_text(statement,2);
            char *address=(char *) sqlite3_column_text(statement,3);
            char *telephone=(char *) sqlite3_column_text(statement,4);
            char *website=(char *) sqlite3_column_text(statement,5);
            char *hotel_logo=(char *) sqlite3_column_text(statement,6);
            char *event_id=(char *) sqlite3_column_text(statement,7);
            char *Phno=(char *) sqlite3_column_text(statement,8);
            char *facebook=(char *) sqlite3_column_text(statement,9);
            char *twitter=(char *) sqlite3_column_text(statement,10);
            
            //creating refrence strings
            NSString* strHotelId;
            NSString* strHotelName;
            NSString* strDescription;
            NSString* strAddress;
            NSString* strTelephone;
            NSString* strWebsite;
            NSString* strHotel_logo;
            NSString* strEvent_id;
            NSString* strPhno;
            NSString* strfacebook;
            NSString* strtwitter;
            
            
            //test all columns value nil or not
            
            if(hoteId!=nil)
                strHotelId=[[NSString alloc] initWithUTF8String:hoteId];
            else
                strHotelId=[[NSString alloc] initWithString:@" "];
            
            if(hotalName!=nil)
                strHotelName=[[NSString alloc] initWithUTF8String:hotalName];
            else
                strHotelName=[[NSString alloc] initWithString:@" "];
            
            if(Description!=nil)
                strDescription=[[NSString alloc] initWithUTF8String:Description];
            else
                strDescription=[[NSString alloc] initWithString:@" "];
            
            if(address!=nil)
                strAddress=[[NSString alloc] initWithUTF8String:address];
            else
                strAddress=[[NSString alloc]  initWithString:@" "];
            
            if(telephone!=nil)
                strTelephone=[[NSString alloc] initWithUTF8String:telephone];
            else
                strTelephone=[[NSString alloc]  initWithString:@" "];
            
            if(website!=nil)
                strWebsite=[[NSString alloc] initWithUTF8String:website];
            else
                strWebsite=[[NSString alloc] initWithString:@" "];
            
            if(hotel_logo!=nil)
                strHotel_logo=[[NSString alloc] initWithUTF8String:hotel_logo];
            else
                strHotel_logo=[[NSString alloc] initWithString:@" "];
            
            if(event_id!=nil)
                strEvent_id=[[NSString alloc] initWithUTF8String:event_id];
            else
                strEvent_id=[[NSString alloc] initWithString:@" "];
            
            if(Phno!=nil)
                strPhno=[[NSString alloc] initWithUTF8String:Phno];
            else
                strPhno=[[NSString alloc]  initWithString:@" "];
            
            if(facebook!=nil)
                strfacebook=[[NSString alloc] initWithUTF8String:facebook];
            else
                strfacebook=[[NSString alloc] initWithString:@" "];
            
            if(twitter!=nil)
                strtwitter=[[NSString alloc] initWithUTF8String:twitter];
            else
                strtwitter=[[NSString alloc] initWithString:@" "];
            
            
            //set values in the Dictonary
            [eventInfo setValue:strHotelId forKey:@"hotel_id"];
            [eventInfo setValue:strHotelName forKey:@"hotel_name"];
            [eventInfo setObject:strDescription forKey:@"description"];
            [eventInfo setValue:strAddress forKey:@"address"];
            [eventInfo setValue:strTelephone forKey:@"telephone"];
            [eventInfo setValue:strWebsite forKey:@"website"];
            [eventInfo setObject:strHotel_logo forKey:@"hotel_logo"];
            [eventInfo setValue:strEvent_id forKey:@"event_id"];
            [eventInfo setValue:strPhno forKey:@"phone"];
            [eventInfo setObject:strfacebook forKey:@"facebook"];
            [eventInfo setValue:strtwitter forKey:@"twitter"];
            
            //Releasing all string
            [strHotelId release];
            [strHotelName release];
            [strDescription release];
            [strAddress release];
            [strTelephone release];
            [strWebsite release];
            [strHotel_logo release];
            [strEvent_id release];
            [strPhno release];
            [strtwitter release];
            [strfacebook release];
            
            
        }
    }
    sqlite3_finalize(statement);
    
    return eventInfo;
}


//Get All Hotel Data By Event_id

-(NSMutableArray *)getAllHotelDataByEventId:(NSString*)eventid
{
    
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM hotel WHERE event_id='%@'",eventid];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *hoteId=(char *) sqlite3_column_text(statement, 0);
            char *hotalName=(char *) sqlite3_column_text(statement, 1);
            char *Description=(char *) sqlite3_column_text(statement,2);
            char *address=(char *) sqlite3_column_text(statement,3);
            char *telephone=(char *) sqlite3_column_text(statement,4);
            char *website=(char *) sqlite3_column_text(statement,5);
            char *hotel_logo=(char *) sqlite3_column_text(statement,6);
            char *event_id=(char *) sqlite3_column_text(statement,7);
            char *phone_number=(char *) sqlite3_column_text(statement,8);
            char *fb=(char *) sqlite3_column_text(statement,9);
            char *tw=(char *) sqlite3_column_text(statement,10);
            
            //creating refrence strings
            NSString* strHotelId;
            NSString* strHotelName;
            NSString* strDescription;
            NSString* strAddress;
            NSString* strTelephone;
            NSString* strWebsite;
            NSString* strHotel_logo;
            NSString* strEvent_id;
            NSString* strph;
            NSString* strfb;
            NSString* strtw;
            
            
            //test all columns value nil or not
            
            if(hoteId!=nil)
                strHotelId=[[NSString alloc] initWithUTF8String:hoteId];
            else
                strHotelId=[[NSString alloc] initWithString:@" "];
            
            if(hotalName!=nil)
                strHotelName=[[NSString alloc] initWithUTF8String:hotalName];
            else
                strHotelName=[[NSString alloc] initWithString:@" "];
            
            if(Description!=nil)
                strDescription=[[NSString alloc] initWithUTF8String:Description];
            else
                strDescription=[[NSString alloc] initWithString:@" "];
            
            if(address!=nil)
                strAddress=[[NSString alloc] initWithUTF8String:address];
            else
                strAddress=[[NSString alloc]  initWithString:@" "];
            
            if(telephone!=nil)
                strTelephone=[[NSString alloc] initWithUTF8String:telephone];
            else
                strTelephone=[[NSString alloc]  initWithString:@" "];
            
            if(website!=nil)
                strWebsite=[[NSString alloc] initWithUTF8String:website];
            else
                strWebsite=[[NSString alloc] initWithString:@" "];
            
            if(hotel_logo!=nil)
                strHotel_logo=[[NSString alloc] initWithUTF8String:hotel_logo];
            else
                strHotel_logo=[[NSString alloc] initWithString:@" "];
            
            if(event_id!=nil)
                strEvent_id=[[NSString alloc] initWithUTF8String:event_id];
            else
                strEvent_id=[[NSString alloc] initWithString:@" "];
            
            if(phone_number!=nil)
                strph=[[NSString alloc] initWithUTF8String:phone_number];
            else
                strph=[[NSString alloc] initWithString:@" "];
            
            if(fb!=nil)
                strfb=[[NSString alloc] initWithUTF8String:fb];
            else
                strfb=[[NSString alloc] initWithString:@" "];
            
            if(tw!=nil)
                strtw=[[NSString alloc] initWithUTF8String:tw];
            else
                strtw=[[NSString alloc] initWithString:@" "];
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strHotelId forKey:@"hotel_id"];
            [eventInfo setValue:strHotelName forKey:@"hotel_name"];
            [eventInfo setObject:strDescription forKey:@"description"];
            [eventInfo setValue:strAddress forKey:@"address"];
            [eventInfo setValue:strTelephone forKey:@"telephone"];
            [eventInfo setValue:strWebsite forKey:@"website"];
            [eventInfo setObject:strHotel_logo forKey:@"hotel_logo"];
            [eventInfo setValue:strEvent_id forKey:@"event_id"];
            [eventInfo setValue:strph forKey:@"phone_number"];
            [eventInfo setValue:strfb forKey:@"facebook"];
            [eventInfo setValue:strtw forKey:@"twitter"];
            
            [arrReturn addObject:eventInfo];
            
            //Releasing all string
            [eventInfo release];
            [strHotelId release];
            [strHotelName release];
            [strDescription release];
            [strAddress release];
            [strTelephone release];
            [strWebsite release];
            [strHotel_logo release];
            [strEvent_id release];
            
            
            
        }
    }
    sqlite3_finalize(statement);
    
    return arrReturn;
}



//SpeakerData Table

//CREATE TABLE "speaker" ("speaker_id" VARCHAR PRIMARY KEY  NOT NULL , "speaker_name" VARCHAR, "job_title" VARCHAR, "company_name" VARCHAR, "bio" VARCHAR, "email" VARCHAR, "facebook_account" VARCHAR, "twitter_account" VARCHAR, "photo" VARCHAR, "event_id" VARCHAR)

//CREATE TABLE "speaker" ("speaker_id" VARCHAR PRIMARY KEY  NOT NULL , "speaker_name" VARCHAR, "job_title" VARCHAR, "company_name" VARCHAR, "bio" VARCHAR, "email" VARCHAR, "facebook_account" VARCHAR, "twitter_account" VARCHAR, "photo" TEXT, "event_id" VARCHAR)

- (int)insertSpeakerData:(NSString*)speaker_id speaker_name:(NSString*)speaker_name job_title:(NSString*)job_title company_name:(NSString*)company_name bio:(NSString*)bio email:(NSString*)email facebook_account:(NSString*)facebook_account twitter_account:(NSString*)twitter_account  photo:(NSString*)photo event_id:(NSString*)event_id
{
    
    int statement_result;
    const char * text2 = "INSERT INTO speaker (speaker_id,speaker_name,job_title,company_name,bio,email,facebook_account,twitter_account,photo,event_id) VALUES (?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[speaker_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[speaker_name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[job_title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,4,[company_name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,5,[bio UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,6,[email UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,7,[facebook_account UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,8,[twitter_account UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,9,[photo UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,10,[event_id UTF8String], -1, SQLITE_TRANSIENT);
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    
    return 1;
}

// Speaker session

-(NSMutableArray *)getSpeakerSessionbyspeakerId:(NSString*)speakerid
{
    
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM session WHERE  session_id IN  (select session_id from speaker_session where speaker_id='%@')",speakerid];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *sessionId=(char *) sqlite3_column_text(statement, 0);
            char *sessionTitle=(char *) sqlite3_column_text(statement, 1);
            char *Description=(char *) sqlite3_column_text(statement,2);
            char *room=(char *) sqlite3_column_text(statement,3);
            char *sessionStartdate=(char *) sqlite3_column_text(statement,4);
            char *sessionFinishdate=(char *) sqlite3_column_text(statement,5);
            char *sessionStarttime=(char *) sqlite3_column_text(statement,6);
            char *sessionEndtime=(char *) sqlite3_column_text(statement,7);
            char *event_id=(char *) sqlite3_column_text(statement,8);
            char *color=(char *) sqlite3_column_text(statement,10);
            NSString* strColor;
            
            
            
            //creating refrence strings
            NSString* strsessionId;
            NSString* strsessionTitle;
            NSString* strDescription;
            NSString* strRoom;
            NSString* strSessionStartdate;
            NSString* strSessionFinishdate;
            NSString* strSessionStarttime;
            NSString* strSessionEndtime;
            NSString* strEventId;
            
            //test all columns value nil or not
            
            if(color!=nil)
                strColor=[[NSString alloc] initWithUTF8String:color];
            else
                strColor=[[NSString alloc] initWithString:@" "];
            
            
            if(sessionId!=nil)
                strsessionId=[[NSString alloc] initWithUTF8String:sessionId];
            else
                strsessionId=[[NSString alloc] initWithString:@" "];
            
            if(sessionTitle!=nil)
                strsessionTitle=[[NSString alloc] initWithUTF8String:sessionTitle];
            else
                strsessionTitle=[[NSString alloc] initWithString:@" "];
            
            if(Description!=nil)
                strDescription=[[NSString alloc] initWithUTF8String:Description];
            else
                strDescription=[[NSString alloc] initWithString:@" "];
            
            if(room!=nil)
                strRoom=[[NSString alloc] initWithUTF8String:room];
            else
                strRoom=[[NSString alloc]  initWithString:@" "];
            
            if(sessionStartdate!=nil)
                strSessionStartdate=[[NSString alloc] initWithUTF8String:sessionStartdate];
            else
                strSessionStartdate=[[NSString alloc]  initWithString:@" "];
            
            if(sessionFinishdate!=nil)
                strSessionFinishdate=[[NSString alloc] initWithUTF8String:sessionFinishdate];
            else
                strSessionFinishdate=[[NSString alloc] initWithString:@" "];
            
            if(sessionStarttime!=nil)
                strSessionStarttime=[[NSString alloc] initWithUTF8String:sessionStarttime];
            else
                strSessionStarttime=[[NSString alloc] initWithString:@" "];
            
            if(sessionEndtime!=nil)
                strSessionEndtime=[[NSString alloc] initWithUTF8String:sessionEndtime];
            else
                strSessionEndtime=[[NSString alloc] initWithString:@" "];
            
            if(event_id!=nil)
                strEventId=[[NSString alloc] initWithUTF8String:event_id];
            else
                strEventId=[[NSString alloc] initWithString:@" "];
            
            
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strsessionId forKey:@"session_id"];
            [eventInfo setValue:strsessionTitle forKey:@"session_title"];
            [eventInfo setObject:strDescription forKey:@"description"];
            [eventInfo setValue:strRoom forKey:@"room"];
            [eventInfo setValue:strSessionStartdate forKey:@"session_start_date"];
            [eventInfo setValue:strSessionFinishdate forKey:@"session_finish_date"];
            [eventInfo setObject:strSessionStarttime forKey:@"session_start_time"];
            [eventInfo setValue:strSessionEndtime forKey:@"session_end_time"];
            [eventInfo setValue:strEventId forKey:@"event_id"];
            [eventInfo setValue:strColor forKey:@"color"];
            [arrReturn addObject:eventInfo];
            
            
            //Releasing all string
            [eventInfo release];
            
            [strsessionId release];
            [strsessionTitle release];
            [strDescription release];
            [strRoom release];
            [strSessionStartdate release];
            [strSessionFinishdate release];
            [strSessionStarttime release];
            [strSessionEndtime release];
            [strEventId release];
            [strColor release];
            
        }
    }
    sqlite3_finalize(statement);
    
    return arrReturn;
}

//Get All Speaker Data By Event_id

-(NSMutableArray *)getAllSpeakerDataByEventId:(NSString*)eventid
{
    
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM speaker WHERE event_id='%@'",eventid];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *speakerId=(char *) sqlite3_column_text(statement, 0);
            char *speakerName=(char *) sqlite3_column_text(statement, 1);
            char *jobTitle=(char *) sqlite3_column_text(statement,2);
            char *companyName=(char *) sqlite3_column_text(statement,3);
            char *photo=(char *) sqlite3_column_text(statement,8);
            
            
            
            //creating refrence strings
            NSString* strSpeakerId;
            NSString* strSpeakerName;
            NSString* strJobTitle;
            NSString* strCompanyName;
            NSString* strPhoto;
            
            
            //test all columns value nil or not
            
            if(speakerId!=nil)
                strSpeakerId=[[NSString alloc] initWithUTF8String:speakerId];
            else
                strSpeakerId=[[NSString alloc] initWithString:@" "];
            
            if(speakerName!=nil)
                strSpeakerName=[[NSString alloc] initWithUTF8String:speakerName];
            else
                strSpeakerName=[[NSString alloc] initWithString:@" "];
            
            if(jobTitle!=nil)
                strJobTitle=[[NSString alloc] initWithUTF8String:jobTitle];
            else
                strJobTitle=[[NSString alloc] initWithString:@" "];
            
            if(companyName!=nil)
                strCompanyName=[[NSString alloc] initWithUTF8String:companyName];
            else
                strCompanyName=[[NSString alloc]  initWithString:@" "];
            
            if(photo!=nil)
                strPhoto=[[NSString alloc] initWithUTF8String:photo];
            else
                strPhoto=[[NSString alloc] initWithString:@" "];
            
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strSpeakerId forKey:@"speaker_id"];
            [eventInfo setValue:strSpeakerName forKey:@"speaker_name"];
            [eventInfo setObject:strJobTitle forKey:@"job_title"];
            [eventInfo setValue:strCompanyName forKey:@"company_name"];
            [eventInfo setValue:strPhoto forKey:@"photo"];
            [arrReturn addObject:eventInfo];
            
            //Releasing all string
            [eventInfo release];
            [strSpeakerId release];
            [strSpeakerName release];
            [strJobTitle release];
            [strCompanyName release];
            [strPhoto release];
            
        }
    }
    sqlite3_finalize(statement);
    
    return arrReturn;
}


//Get Speaker Data By speaker_id

-(NSMutableDictionary *)getSpeakerDataBySpeakerId:(NSString*)speakerid
{
    NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT speaker.* , session.session_id,session.session_title FROM speaker LEFT JOIN session ON speaker.speaker_id = session.session_id WHERE  speaker_id='%@'",speakerid];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            //featch values from tbl columns
            char *speakerId=(char *) sqlite3_column_text(statement, 0);
            char *speakerName=(char *) sqlite3_column_text(statement, 1);
            char *jobTitle=(char *) sqlite3_column_text(statement,2);
            char *companyName=(char *) sqlite3_column_text(statement,3);
            char *bio=(char *) sqlite3_column_text(statement,4);
            char *emailid=(char *) sqlite3_column_text(statement,5);
            
            char *facebookAccount=(char *) sqlite3_column_text(statement,6);
            char *twitterAccount=(char *) sqlite3_column_text(statement,7);
            char *photo=(char *) sqlite3_column_text(statement,8);
            char *eventId=(char *) sqlite3_column_text(statement,9);
            char *sessiontitle=(char *) sqlite3_column_text(statement,11);
            
            //creating refrence strings
            NSString* strSpeakerId;
            NSString* strSpeakerName;
            NSString* strJobTitle;
            NSString* strCompanyName;
            NSString* strBio;
            NSString* strFacebookAccount;
            NSString* strTwitterAccount;
            NSString* strPhoto;
            NSString* strEvent_id;
            NSString* stremailid;
            NSString* strSessiontitle;
            //test all columns value nil or not
            
            if(speakerId!=nil)
                strSpeakerId=[[NSString alloc] initWithUTF8String:speakerId];
            else
                strSpeakerId=[[NSString alloc] initWithString:@" "];
            
            if(sessiontitle!=nil)
                strSessiontitle=[[NSString alloc] initWithUTF8String:sessiontitle];
            else
                strSessiontitle=[[NSString alloc] initWithString:@" "];
            
            
            if(speakerName!=nil)
                strSpeakerName=[[NSString alloc] initWithUTF8String:speakerName];
            else
                strSpeakerName=[[NSString alloc] initWithString:@" "];
            
            if(jobTitle!=nil)
                strJobTitle=[[NSString alloc] initWithUTF8String:jobTitle];
            else
                strJobTitle=[[NSString alloc] initWithString:@" "];
            
            if(companyName!=nil)
                strCompanyName=[[NSString alloc] initWithUTF8String:companyName];
            else
                strCompanyName=[[NSString alloc]  initWithString:@" "];
            
            if(bio!=nil)
                strBio=[[NSString alloc] initWithUTF8String:bio];
            else
                strBio=[[NSString alloc]  initWithString:@" "];
            
            if(facebookAccount!=nil)
                strFacebookAccount=[[NSString alloc] initWithUTF8String:facebookAccount];
            else
                strFacebookAccount=[[NSString alloc] initWithString:@" "];
            
            if(twitterAccount!=nil)
                strTwitterAccount=[[NSString alloc] initWithUTF8String:twitterAccount];
            else
                strTwitterAccount=[[NSString alloc] initWithString:@" "];
            
            if(photo!=nil)
                strPhoto=[[NSString alloc] initWithUTF8String:photo];
            else
                strPhoto=[[NSString alloc] initWithString:@" "];
            
            if(eventId!=nil)
                strEvent_id=[[NSString alloc] initWithUTF8String:eventId];
            else
                strEvent_id=[[NSString alloc] initWithString:@" "];
            
            if(emailid!=nil)
                stremailid=[[NSString alloc] initWithUTF8String:emailid];
            else
                stremailid=[[NSString alloc] initWithString:@" "];
            
            
            //set values in the Dictonary
            [eventInfo setValue:strSpeakerId forKey:@"speaker_id"];
            [eventInfo setValue:strSpeakerName forKey:@"speaker_name"];
            [eventInfo setObject:strJobTitle forKey:@"job_title"];
            [eventInfo setValue:strCompanyName forKey:@"company_name"];
            [eventInfo setValue:strBio forKey:@"bio"];
            [eventInfo setValue:strFacebookAccount forKey:@"facebook_account"];
            [eventInfo setObject:strTwitterAccount forKey:@"twitter_account"];
            [eventInfo setObject:strPhoto forKey:@"photo"];
            [eventInfo setValue:strEvent_id forKey:@"event_id"];
            [eventInfo setValue:stremailid forKey:@"email"];
            [eventInfo setValue:strSessiontitle forKey:@"session_title"];
            //Releasing all string
            [strSpeakerId release];
            [strSpeakerName release];
            [strJobTitle release];
            [strCompanyName release];
            [strBio release];
            [strFacebookAccount release];
            [strTwitterAccount release];
            [strPhoto release];
            [strEvent_id release];
            [stremailid release];
            [strSessiontitle release];
        }
    }
    sqlite3_finalize(statement);
    
    return eventInfo;
}

//ExhibitorData Table

//-->New Table
//CREATE TABLE "exhibitor" ("exhibitor_id" VARCHAR PRIMARY KEY  NOT NULL , "company_name" VARCHAR, "description" VARCHAR, "category" VARCHAR, "website" VARCHAR, "company_logo" VARCHAR, "max_booth_number" VARCHAR, "sponsorship_category_id" VARCHAR, "email_address" VARCHAR, "password" VARCHAR, "event_id" VARCHAR, "rep_name" VARCHAR, "rep_mobile" VARCHAR, "rep_email" VARCHAR, "address" VARCHAR, "phone_number" VARCHAR, "featured_exhibitor" VARCHAR, "sponsor_exhibitors" VARCHAR, "paid" VARCHAR, "facebook_id" VARCHAR , "twitter_id" VARCHAR)

-(int)insertExhibitorData:(NSString*)strExhibitorId company_name:(NSString*)company_name description:(NSString*)description category:(NSString*)category website:(NSString*)website featured_exhibitor:(NSString*)featured_exhibitor company_logo:(NSString*)company_logo max_booth_number:(NSString*)max_booth_number sponsor_exhibitors:(NSString*)sponsor_exhibitors sponsorship_category_id:(NSString*)sponsorship_category_id email_address:(NSString*)email_address password:(NSString*)password paid:(NSString*)paid event_id:(NSString*)event_id rep_name:(NSString*)rep_name rep_mobile:(NSString*)rep_mobile rep_email:(NSString*)rep_email address:(NSString*)address phone_number:(NSString*)phone_number facebook_id:(NSString*)facebook_id twitter_id:(NSString*)twitter_id
{
    
    int statement_result;
    const char * text2 = "INSERT INTO exhibitor (exhibitor_id,company_name,description,category,website,featured_exhibitor,company_logo,max_booth_number,sponsor_exhibitors,sponsorship_category_id,email_address,password,paid,event_id,rep_name,rep_mobile,rep_email,address,phone_number,facebook_id,twitter_id) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strExhibitorId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[company_name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[description UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,4,[category UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,5,[website UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,6,[featured_exhibitor UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,7,[company_logo UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,8,[max_booth_number UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,9,[sponsor_exhibitors UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,10,[sponsorship_category_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,11,[email_address UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,12,[password UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,13,[paid UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,14,[event_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,15,[rep_name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,16,[rep_mobile UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,17,[rep_email UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,18,[address UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,19,[phone_number UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,20,[facebook_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,21,[twitter_id UTF8String], -1, SQLITE_TRANSIENT);
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    return 1;
}

//ExhibitorProductData


- (int)insertExhibitorProductData:(NSString*)strEproduct_Id ProductName:(NSString*)strEProduct_Name description:(NSString*)strEDescription Exhibitor_Id:(NSString*)strExhibitor_Id Photo:(NSString*)strPhoto
{
    
    int statement_result;
    const char * text2 = "INSERT INTO exhibitor_product (exhibitor_product_id,product_name,description,exhibitor_id,photo) VALUES (?,?,?,?,?)";
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strEproduct_Id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[strEProduct_Name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[strEDescription UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,4,[strExhibitor_Id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,5,[strPhoto UTF8String], -1, SQLITE_TRANSIENT);
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    
    return 1;
}

//CREATE TABLE "exhibitor" ("exhibitor_id" VARCHAR PRIMARY KEY  NOT NULL , "company_name" VARCHAR, "description" VARCHAR, "category" VARCHAR, "website" VARCHAR, "featured_exhibitor" VARCHAR, "company_logo" VARCHAR, "max_booth_number" VARCHAR, "sponsor_exhibitors" VARCHAR, "sponsorship_category_id" VARCHAR, "email_address" VARCHAR, "password" VARCHAR, "paid" VARCHAR, "event_id" VARCHAR)

//Get All Exhibitors Data By Event_id

-(NSMutableArray *)getAllExhibitorsDataByEventId:(NSString*)eventid
{
    
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM exhibitor WHERE event_id='%@' ORDER BY company_name   ",eventid];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *exhibitorId=(char *) sqlite3_column_text(statement, 0);
            char *companyName=(char *) sqlite3_column_text(statement, 1);
            char *description=(char *) sqlite3_column_text(statement,2);
            char *category=(char *) sqlite3_column_text(statement,3);
            char *website=(char *) sqlite3_column_text(statement,4);
            char *featuredExhibitor=(char *) sqlite3_column_text(statement,5);
            char *companyLogo=(char *) sqlite3_column_text(statement,6);
            char *maxBoothNumber=(char *) sqlite3_column_text(statement,7);
            char *sponsorExhibitors=(char *) sqlite3_column_text(statement,8);
            char *sponsorshipCategoryId=(char *) sqlite3_column_text(statement,9);
            char *emailAddress=(char *) sqlite3_column_text(statement,10);
            char *password=(char *) sqlite3_column_text(statement,11);
            char *paid=(char *) sqlite3_column_text(statement,12);
            char *event_id=(char *) sqlite3_column_text(statement,13);
            char *rep_name=(char *) sqlite3_column_text(statement,14);
            
            //creating refrence strings
            NSString* strExhibitorId;
            NSString* strCompanyName;
            NSString* strDescription;
            NSString* strCategory;
            NSString* strWebsite;
            NSString* strFeaturedExhibitor;
            NSString* strCompanyLogo;
            NSString* strMaxBoothNumber;
            NSString* strSponsorExhibitors;
            NSString* strSponsorshipCategoryId;
            NSString* strEmailAddress;
            NSString* strPassword;
            NSString* strPaid;
            NSString* strEvent_id;
            NSString* strRep_name;
            
            
            //test all columns value nil or not
            
            if(exhibitorId!=nil)
                strExhibitorId=[[NSString alloc] initWithUTF8String:exhibitorId];
            else
                strExhibitorId=[[NSString alloc] initWithString:@" "];
            
            if(companyName!=nil)
                strCompanyName=[[NSString alloc] initWithUTF8String:companyName];
            else
                strCompanyName=[[NSString alloc] initWithString:@" "];
            
            if(description!=nil)
                strDescription=[[NSString alloc] initWithUTF8String:description];
            else
                strDescription=[[NSString alloc] initWithString:@" "];
            
            if(category!=nil)
                strCategory=[[NSString alloc] initWithUTF8String:category];
            else
                strCategory=[[NSString alloc]  initWithString:@" "];
            
            if(website!=nil)
                strWebsite=[[NSString alloc] initWithUTF8String:website];
            else
                strWebsite=[[NSString alloc] initWithString:@" "];
            
            //
            if(featuredExhibitor!=nil)
                strFeaturedExhibitor=[[NSString alloc] initWithUTF8String:featuredExhibitor];
            else
                strFeaturedExhibitor=[[NSString alloc]  initWithString:@" "];
            
            if(companyLogo!=nil)
                strCompanyLogo=[[NSString alloc] initWithUTF8String:companyLogo];
            else
                strCompanyLogo=[[NSString alloc] initWithString:@" "];
            
            if(maxBoothNumber!=nil)
                strMaxBoothNumber=[[NSString alloc] initWithUTF8String:maxBoothNumber];
            else
                strMaxBoothNumber=[[NSString alloc]  initWithString:@" "];
            
            if(sponsorExhibitors!=nil)
                strSponsorExhibitors=[[NSString alloc] initWithUTF8String:sponsorExhibitors];
            else
                strSponsorExhibitors=[[NSString alloc] initWithString:@" "];
            
            
            //
            if(sponsorshipCategoryId!=nil)
                strSponsorshipCategoryId=[[NSString alloc] initWithUTF8String:sponsorshipCategoryId];
            else
                strSponsorshipCategoryId=[[NSString alloc]  initWithString:@" "];
            
            if(emailAddress!=nil)
                strEmailAddress=[[NSString alloc] initWithUTF8String:emailAddress];
            else
                strEmailAddress=[[NSString alloc] initWithString:@" "];
            
            if(password!=nil)
                strPassword=[[NSString alloc] initWithUTF8String:password];
            else
                strPassword=[[NSString alloc]  initWithString:@" "];
            
            if(paid!=nil)
                strPaid =[[NSString alloc] initWithUTF8String:paid];
            else
                strPaid=[[NSString alloc] initWithString:@" "];
            
            if(event_id!=nil)
                strEvent_id =[[NSString alloc] initWithUTF8String:event_id];
            else
                strEvent_id=[[NSString alloc] initWithString:@" "];
            
            
            if(rep_name!=nil)
                strRep_name =[[NSString alloc] initWithUTF8String:rep_name];
            else
                strRep_name=[[NSString alloc] initWithString:@" "];
            
            
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strExhibitorId forKey:@"exhibitor_id"];
            [eventInfo setValue:strCompanyName forKey:@"company_name"];
            [eventInfo setObject:strDescription forKey:@"description"];
            [eventInfo setValue:strCategory forKey:@"category"];
            [eventInfo setValue:strWebsite forKey:@"website"];
            [eventInfo setValue:strFeaturedExhibitor forKey:@"featured_exhibitor"];
            [eventInfo setValue:strCompanyLogo forKey:@"company_logo"];
            [eventInfo setObject:strMaxBoothNumber forKey:@"max_booth_number"];
            [eventInfo setValue:strSponsorExhibitors forKey:@"sponsor_exhibitors"];
            [eventInfo setValue:strSponsorshipCategoryId forKey:@"sponsorship_category_id"];
            [eventInfo setValue:strEmailAddress forKey:@"email_address"];
            [eventInfo setValue:strPassword forKey:@"password"];
            [eventInfo setObject:strPaid forKey:@"paid"];
            [eventInfo setValue:strEvent_id forKey:@"event_id"];
            [eventInfo setValue:strRep_name forKey:@"rep_name"];
            
            
            [arrReturn addObject:eventInfo];
            //Releasing all string
            [eventInfo release];
            [strCompanyName release];
            [strDescription release];
            [strCategory release];
            [strWebsite release];
            [strFeaturedExhibitor release];
            [strCompanyLogo release];
            [strMaxBoothNumber release];
            [strSponsorExhibitors release];
            [strSponsorshipCategoryId release];
            [strEmailAddress release];
            [strPassword release];
            [strPaid release];
            [strEvent_id release];
            [strRep_name release];
            
        }
    }
    sqlite3_finalize(statement);
    
    return arrReturn;
}



//Get All Exhibitors Data By ExhibitorId

-(NSMutableDictionary *)getExhibitorsDataByExhibitorId:(NSString*)Exhibitorid
{
    
    NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM exhibitor  WHERE exhibitor_id='%@' ",Exhibitorid];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *exhibitorId=(char *) sqlite3_column_text(statement, 0);
            char *companyName=(char *) sqlite3_column_text(statement, 1);
            char *description=(char *) sqlite3_column_text(statement,2);
            char *category=(char *) sqlite3_column_text(statement,3);
            char *website=(char *) sqlite3_column_text(statement,4);
            char *featuredExhibitor=(char *) sqlite3_column_text(statement,5);
            char *companyLogo=(char *) sqlite3_column_text(statement,6);
            char *maxBoothNumber=(char *) sqlite3_column_text(statement,7);
            char *sponsorExhibitors=(char *) sqlite3_column_text(statement,8);
            char *sponsorshipCategoryId=(char *) sqlite3_column_text(statement,9);
            char *emailAddress=(char *) sqlite3_column_text(statement,10);
            char *password=(char *) sqlite3_column_text(statement,11);
            char *paid=(char *) sqlite3_column_text(statement,12);
            char *event_id=(char *) sqlite3_column_text(statement,13);
            char *rep_name=(char *) sqlite3_column_text(statement,14);
            char *rep_mobile=(char *) sqlite3_column_text(statement,15);
            char *rep_email=(char *) sqlite3_column_text(statement,16);
            char *address=(char *) sqlite3_column_text(statement,17);
            char *phone_number=(char *) sqlite3_column_text(statement,18);
            char *facebook_id=(char *) sqlite3_column_text(statement,19);
            char *twitter_id=(char *) sqlite3_column_text(statement,20);
            
            
            //creating refrence strings
            NSString* strExhibitorId;
            NSString* strCompanyName;
            NSString* strDescription;
            NSString* strCategory;
            NSString* strWebsite;
            NSString* strFeaturedExhibitor;
            NSString* strCompanyLogo;
            NSString* strMaxBoothNumber;
            NSString* strSponsorExhibitors;
            NSString* strSponsorshipCategoryId;
            NSString* strEmailAddress;
            NSString* strPassword;
            NSString* strPaid;
            NSString* strEvent_id;
            NSString* strrep_name;
            NSString* strrep_mobile;
            NSString* strrep_email;
            NSString* straddress;
            NSString* strphone_number;
            NSString* strfacebook_id;
            NSString* strtwitter_id;
            
            //test all columns value nil or not
            
            if(exhibitorId!=nil)
                strExhibitorId=[[NSString alloc] initWithUTF8String:exhibitorId];
            else
                strExhibitorId=[[NSString alloc] initWithString:@" "];
            
            if(companyName!=nil)
                strCompanyName=[[NSString alloc] initWithUTF8String:companyName];
            else
                strCompanyName=[[NSString alloc] initWithString:@" "];
            
            if(description!=nil)
                strDescription=[[NSString alloc] initWithUTF8String:description];
            else
                strDescription=[[NSString alloc] initWithString:@" "];
            
            if(category!=nil)
                strCategory=[[NSString alloc] initWithUTF8String:category];
            else
                strCategory=[[NSString alloc]  initWithString:@" "];
            
            if(website!=nil)
                strWebsite=[[NSString alloc] initWithUTF8String:website];
            else
                strWebsite=[[NSString alloc] initWithString:@" "];
            
            //
            if(featuredExhibitor!=nil)
                strFeaturedExhibitor=[[NSString alloc] initWithUTF8String:featuredExhibitor];
            else
                strFeaturedExhibitor=[[NSString alloc]  initWithString:@" "];
            
            if(companyLogo!=nil)
                strCompanyLogo=[[NSString alloc] initWithUTF8String:companyLogo];
            else
                strCompanyLogo=[[NSString alloc] initWithString:@" "];
            
            if(maxBoothNumber!=nil)
                strMaxBoothNumber=[[NSString alloc] initWithUTF8String:maxBoothNumber];
            else
                strMaxBoothNumber=[[NSString alloc]  initWithString:@" "];
            
            if(sponsorExhibitors!=nil)
                strSponsorExhibitors=[[NSString alloc] initWithUTF8String:sponsorExhibitors];
            else
                strSponsorExhibitors=[[NSString alloc] initWithString:@" "];
            
            
            //
            if(sponsorshipCategoryId!=nil)
                strSponsorshipCategoryId=[[NSString alloc] initWithUTF8String:sponsorshipCategoryId];
            else
                strSponsorshipCategoryId=[[NSString alloc]  initWithString:@" "];
            
            if(emailAddress!=nil)
                strEmailAddress=[[NSString alloc] initWithUTF8String:emailAddress];
            else
                strEmailAddress=[[NSString alloc] initWithString:@" "];
            
            if(password!=nil)
                strPassword=[[NSString alloc] initWithUTF8String:password];
            else
                strPassword=[[NSString alloc]  initWithString:@" "];
            
            if(paid!=nil)
                strPaid =[[NSString alloc] initWithUTF8String:paid];
            else
                strPaid=[[NSString alloc] initWithString:@" "];
            
            if(event_id!=nil)
                strEvent_id =[[NSString alloc] initWithUTF8String:event_id];
            else
                strEvent_id=[[NSString alloc] initWithString:@" "];
            
            
            
            if(rep_name!=nil)
                strrep_name =[[NSString alloc] initWithUTF8String:rep_name];
            else
                strrep_name=[[NSString alloc] initWithString:@" "];
            
            
            if(rep_mobile!=nil)
                strrep_mobile =[[NSString alloc] initWithUTF8String:rep_mobile];
            else
                strrep_mobile=[[NSString alloc] initWithString:@" "];
            
            if(rep_email!=nil)
                strrep_email =[[NSString alloc] initWithUTF8String:rep_email];
            else
                strrep_email=[[NSString alloc] initWithString:@" "];
            
            if(address!=nil)
                straddress =[[NSString alloc] initWithUTF8String:address];
            else
                straddress=[[NSString alloc] initWithString:@" "];
            
            if(phone_number!=nil)
                strphone_number =[[NSString alloc] initWithUTF8String:phone_number];
            else
                strphone_number=[[NSString alloc] initWithString:@" "];
            
            
            if(facebook_id!=nil)
                strfacebook_id =[[NSString alloc] initWithUTF8String:facebook_id];
            else
                strfacebook_id=[[NSString alloc] initWithString:@" "];
            
            
            if(twitter_id!=nil)
                strtwitter_id =[[NSString alloc] initWithUTF8String:twitter_id];
            else
                strtwitter_id=[[NSString alloc] initWithString:@" "];
            
            
            //set values in the Dictonary
            [eventInfo setValue:strExhibitorId forKey:@"exhibitor_id"];
            [eventInfo setValue:strCompanyName forKey:@"company_name"];
            [eventInfo setObject:strDescription forKey:@"description"];
            [eventInfo setValue:strCategory forKey:@"category"];
            [eventInfo setValue:strWebsite forKey:@"website"];
            [eventInfo setValue:strFeaturedExhibitor forKey:@"featured_exhibitor"];
            [eventInfo setValue:strCompanyLogo forKey:@"company_logo"];
            [eventInfo setObject:strMaxBoothNumber forKey:@"max_booth_number"];
            [eventInfo setValue:strSponsorExhibitors forKey:@"sponsor_exhibitors"];
            [eventInfo setValue:strSponsorshipCategoryId forKey:@"sponsorship_category_id"];
            [eventInfo setValue:strEmailAddress forKey:@"email_address"];
            [eventInfo setValue:strPassword forKey:@"password"];
            [eventInfo setObject:strPaid forKey:@"paid"];
            [eventInfo setValue:strEvent_id forKey:@"event_id"];
            [eventInfo setValue:strrep_name forKey:@"rep_name"];
            [eventInfo setValue:strrep_mobile forKey:@"rep_mobile"];
            [eventInfo setValue:strrep_email forKey:@"rep_email"];
            [eventInfo setValue:straddress forKey:@"address"];
            [eventInfo setValue:strphone_number forKey:@"phone_number"];
            [eventInfo setValue:strfacebook_id forKey:@"facebook_id"];
            [eventInfo setValue:strtwitter_id forKey:@"twitter_id"];
            
            //Releasing all string
            
            [strCompanyName release];
            [strDescription release];
            [strCategory release];
            [strWebsite release];
            [strFeaturedExhibitor release];
            [strCompanyLogo release];
            [strMaxBoothNumber release];
            [strSponsorExhibitors release];
            [strSponsorshipCategoryId release];
            [strEmailAddress release];
            [strPassword release];
            [strPaid release];
            [strEvent_id release];
            [strrep_name release];
            [strrep_mobile release];
            [strrep_email release];
            [straddress release];
            [strphone_number release];
            [strfacebook_id release];
            [strtwitter_id release];
        }
    }
    sqlite3_finalize(statement);
    
    return eventInfo;
}



//getExibitorProductDataById
-(NSMutableArray *)getExibitorProductDataById:(NSString*)strExhibitorId
{
   
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM exhibitor_product where exhibitor_id ='%@'",strExhibitorId];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *eProductId=(char *) sqlite3_column_text(statement, 0);
            char *eProductName=(char *) sqlite3_column_text(statement, 1);
            char *description=(char *) sqlite3_column_text(statement,2);
            char *exhibitorId=(char *) sqlite3_column_text(statement,3);
            char *photo=(char *) sqlite3_column_text(statement,4);
            
            //creating refrence strings
            NSString* strEProductId;
            NSString* strEProductName;
            NSString* strDescription;
            NSString* strExhibitorId;
            NSString* strPhoto;
            
            //test all columns value nil or not
            
            if(eProductId!=nil)
                strEProductId=[[NSString alloc] initWithUTF8String:eProductId];
            else
                strEProductId=[[NSString alloc] initWithString:@" "];
            
            if(eProductName!=nil)
                strEProductName=[[NSString alloc] initWithUTF8String:eProductName];
            else
                strEProductName=[[NSString alloc] initWithString:@" "];
            
            if(description!=nil)
                strDescription=[[NSString alloc] initWithUTF8String:description];
            else
                strDescription=[[NSString alloc] initWithString:@" "];
            
            if(exhibitorId!=nil)
                strExhibitorId=[[NSString alloc] initWithUTF8String:exhibitorId];
            else
                strExhibitorId=[[NSString alloc]  initWithString:@" "];
            
            if(photo!=nil)
                strPhoto=[[NSString alloc] initWithUTF8String:photo];
            else
                strPhoto=[[NSString alloc]  initWithString:@" "];
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strEProductId forKey:@"exhibitor_product_id"];
            [eventInfo setValue:strEProductName forKey:@"product_name"];
            [eventInfo setObject:strDescription forKey:@"description"];
            [eventInfo setValue:strExhibitorId forKey:@"exhibitor_id"];
            [eventInfo setValue:strPhoto forKey:@"photo"];
            [arrReturn addObject:eventInfo];
            
            //Releasing all string
            [eventInfo release];
            
            
            //Releasing all string
            [strEProductId release];
            [strEProductName release];
            [strDescription release];
            [strExhibitorId release];
            [strPhoto release];
            
            
        }
    }
    sqlite3_finalize(statement);
    
    return arrReturn;
}


// Insert Attende.....
////-->new Table
//CREATE TABLE "attendee" ("attendee_id" VARCHAR PRIMARY KEY  NOT NULL , "first_name" VARCHAR, "last_name" VARCHAR, "email" VARCHAR, "mobile_number" VARCHAR, "job_title" VARCHAR, "company_name" VARCHAR, "photo" VARCHAR, "event_id" VARCHAR, "qr" VARCHAR, "gender" VARCHAR)

- (int)insertAttendeeData:(NSString*)strAttendeeId attendeeFirstName:(NSString*)strFirstname attendeeLastName:(NSString*)strLast_name Email:(NSString*)strEmailId Mobilenumber:(NSString*)strMobilenumber Jobtitle:(NSString*)strJobTitle Companyname:(NSString*)strCompanyname Photo:(NSString*)strPhoto Event_id:(NSString*)strEventId QrCode:(NSString*)strQrCode Jender:(NSString*)strGender bagdeId:(NSString*)strbadgeId;

{
    int statement_result;
    const char * text2 = "INSERT INTO attendee (attendee_id,first_name,last_name,email,mobile_number,job_title,company_name,photo,event_id,qr,gender,badgeId) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strAttendeeId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[strFirstname UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[strLast_name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,4,[strEmailId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,5,[strMobilenumber UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,6,[strJobTitle UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,7,[strCompanyname UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,8,[strPhoto UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,9,[strEventId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,10,[strQrCode UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,11,[strGender UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,12,[strbadgeId UTF8String], -1, SQLITE_TRANSIENT);
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    
    return 1;
    
    
}

//insertINTOattendee_session

//--<New Table
//CREATE TABLE "attendee_session" ("attendee_session_id" VARCHAR PRIMARY KEY  NOT NULL , "attendee_id" VARCHAR, "session_id" VARCHAR, "alert_time" VARCHAR)


- (int)insertINTOattendee_session:(NSString*)strattendee_session_id Attendee_id:(NSString*)strattendee_id Session_id:(NSString*)strsession_id Alert_session_time:(NSString*)stralert_session_time
{
    int statement_result;
    const char * text2 = "INSERT INTO attendee_session(attendee_session_id,attendee_id,session_id,alert_session_time) VALUES (?,?,?,?)";
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strattendee_session_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[strattendee_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[strsession_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,4,[stralert_session_time UTF8String], -1, SQLITE_TRANSIENT);
    
    
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    return 1;
    
}


///get all attendee by moblie no



-(NSMutableDictionary *)getAttendeeDataByMobileno:(NSString*)Mobileno
{
    
    NSMutableDictionary *DicReturn= [[NSMutableDictionary alloc]init];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM attendee WHERE mobile_number='%@'",Mobileno];
    
   
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *attendeeid=(char *) sqlite3_column_text(statement, 0);
            char *firstName=(char *) sqlite3_column_text(statement, 1);
            char *lastName=(char *) sqlite3_column_text(statement,2);
            char *email=(char *) sqlite3_column_text(statement,3);
            char *mobileNo=(char *) sqlite3_column_text(statement,4);
            char *jobTitle=(char *) sqlite3_column_text(statement,5);
            char *companyName=(char *) sqlite3_column_text(statement,6);
            char *photo=(char *) sqlite3_column_text(statement,7);
            char *event_id=(char *) sqlite3_column_text(statement,8);
            char *qr=(char *) sqlite3_column_text(statement,9);
            char *badgiID=(char *) sqlite3_column_text(statement,11);
            
            
            //creating refrence strings
            NSString* strAttendeeid;
            NSString* strFirstName;
            NSString* strLastName;
            NSString* strEmail;
            NSString* strMobileNo;
            //
            NSString* strJobTitle;
            NSString* strcompanyName;
            NSString* strPhoto;
            NSString* strEventId;
            NSString* strQr;
            NSString* strbadgeId;
            
            //test all columns value nil or not
            //
            
            
            if(attendeeid!=nil)
                strAttendeeid=[[NSString alloc] initWithUTF8String:attendeeid];
            else
                strAttendeeid=[[NSString alloc] initWithString:@" "];
            
            if(firstName!=nil)
                strFirstName=[[NSString alloc] initWithUTF8String:firstName];
            else
                strFirstName=[[NSString alloc] initWithString:@" "];
            
            if(lastName!=nil)
                strLastName=[[NSString alloc] initWithUTF8String:lastName];
            else
                strLastName=[[NSString alloc] initWithString:@" "];
            
            if(email!=nil)
                strEmail=[[NSString alloc] initWithUTF8String:email];
            else
                strEmail=[[NSString alloc] initWithString:@" "];
            
            
            if(mobileNo!=nil)
                strMobileNo=[[NSString alloc] initWithUTF8String:mobileNo];
            else
                strMobileNo=[[NSString alloc] initWithString:@" "];
            
            if(jobTitle!=nil)
                strJobTitle=[[NSString alloc] initWithUTF8String:jobTitle];
            else
                strJobTitle=[[NSString alloc] initWithString:@" "];
            
            if(companyName!=nil)
                strcompanyName=[[NSString alloc] initWithUTF8String:companyName];
            else
                strcompanyName=[[NSString alloc] initWithString:@" "];
            
            if(photo!=nil)
                strPhoto=[[NSString alloc] initWithUTF8String:photo];
            else
                strPhoto=[[NSString alloc] initWithString:@" "];
            
            if(event_id!=nil)
                strEventId=[[NSString alloc] initWithUTF8String:event_id];
            else
                strEventId=[[NSString alloc] initWithString:@" "];
            
            if(qr!=nil)
                strQr=[[NSString alloc] initWithUTF8String:qr];
            else
                strQr=[[NSString alloc] initWithString:@" "];
            
            if(badgiID!=nil)
                strbadgeId=[[NSString alloc] initWithUTF8String:badgiID];
            else
                strbadgeId=[[NSString alloc] initWithString:@" "];
            
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strAttendeeid forKey:@"attendee_id"];
            [eventInfo setValue:strFirstName forKey:@"first_name"];
            [eventInfo setObject:strLastName forKey:@"last_name"];
            [eventInfo setValue:strEmail forKey:@"email"];
            [eventInfo setValue:strMobileNo forKey:@"mobile_number"];
            [eventInfo setValue:strJobTitle forKey:@"job_title"];
            [eventInfo setObject:strcompanyName forKey:@"company_name"];
            [eventInfo setValue:strPhoto forKey:@"photo"];
            [eventInfo setValue:strEventId forKey:@"event_id"];
            [eventInfo setValue:strQr forKey:@"qr"];
            [eventInfo setValue:strbadgeId forKey:@"badgeId"];
            
            //   Releasing all string
            [strAttendeeid release];
            [strFirstName release];
            [strLastName release];
            [strEmail release];
            [strMobileNo release];
            [strJobTitle release];
            [strcompanyName release];
            [strPhoto release];
            [strEventId release];
            [strQr release];
            [strbadgeId release];
            [DicReturn setValue:@"true" forKey:@"success"];
            [DicReturn setValue:eventInfo forKey:@"result"];
            
        }
        
        
        
    }
    sqlite3_finalize(statement);
    
    return DicReturn;
}

//deleteAttendee_sessionBy_session_id

-(void)deleteAttendee_sessionBy_session_id:(int)strSession_id
{
    sqlite3_stmt *deleteStmt;
    const char *sql = "delete from attendee_session where session_id = ?";
    if(sqlite3_prepare_v2(_database, sql, -1, &deleteStmt, NULL) != SQLITE_OK){
        NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(_database));
        return;
	}
	
	//When binding parameters, index starts from 1 and not zero.
	sqlite3_bind_int(deleteStmt, 1, strSession_id);
    
	if (SQLITE_DONE != sqlite3_step(deleteStmt))
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(_database));
	
	sqlite3_reset(deleteStmt);
    
}

//insertNotificationData

- (int)insertNotificationData:(NSString*)strNotificationId notificationTitle:(NSString*)NotificationTitle notificationMessage:(NSString*)message event_id:(NSString*)event_id send_date:(NSString*)send_date AttandeeId:(NSString*)strAttandeeId
{
    
    int statement_result;
    
    const char * text2 = "INSERT INTO notifications (notification_id,title,message,event_id,send_date,attendee_id) VALUES (?,?,?,?,?,?)";
    
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strNotificationId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[NotificationTitle UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[message UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,4,[event_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,5,[send_date UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,6,[strAttandeeId UTF8String], -1, SQLITE_TRANSIENT);
    //sqlite3_bind_text(insert_statement,7,[strReadData UTF8String], -1, SQLITE_TRANSIENT);
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    
    return 1;
}




- (int)insertNotificationData:(NSString*)strNotificationId notificationTitle:(NSString*)NotificationTitle notificationMessage:(NSString*)message event_id:(NSString*)event_id send_date:(NSString*)send_date AttandeeId:(NSString*)strAttandeeId ReadDeatil:(NSString *)strReadData
{
    
    int statement_result;
    
    const char * text2 = "INSERT INTO notifications (notification_id,title,message,event_id,send_date,attendee_id,isread) VALUES (?,?,?,?,?,?,?)";
    
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strNotificationId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[NotificationTitle UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[message UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,4,[event_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,5,[send_date UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,6,[strAttandeeId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,7,[strReadData UTF8String], -1, SQLITE_TRANSIENT);
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    
    return 1;
}




//Get All Message Data By Attendee_id

-(NSMutableArray *)getAllMessageDataByAttendee_id:(NSString*)strAttendee_id
{
    
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM notifications WHERE attendee_id='%@' ORDER BY send_date DESC",strAttendee_id];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *notificationId=(char *) sqlite3_column_text(statement, 0);
            char *title=(char *) sqlite3_column_text(statement, 1);
            char *message=(char *) sqlite3_column_text(statement,2);
            char *eventId=(char *) sqlite3_column_text(statement,3);
            char *sendDate=(char *) sqlite3_column_text(statement,4);
            char *isRead=(char *) sqlite3_column_text(statement,5);
            char *userId=(char *) sqlite3_column_text(statement,6);
            char *attendee=(char *) sqlite3_column_text(statement,7);
            
            
            //creating refrence strings
            NSString* strNotificationId;
            NSString* strTitle;
            NSString* strMessage;
            NSString* strEventId;
            NSString* strSendDate;
            NSString* strIsRead;
            NSString* strUseId;
            NSString* strAttendeeId;
            
            
            
            //test all columns value nil or not
            
            if(notificationId!=nil)
                strNotificationId=[[NSString alloc] initWithUTF8String:notificationId];
            else
                strNotificationId=[[NSString alloc] initWithString:@" "];
            
            if(title!=nil)
                strTitle=[[NSString alloc] initWithUTF8String:title];
            else
                strTitle=[[NSString alloc] initWithString:@" "];
            
            if(message!=nil)
                strMessage=[[NSString alloc] initWithUTF8String:message];
            else
                strMessage=[[NSString alloc] initWithString:@" "];
            
            if(eventId!=nil)
                strEventId=[[NSString alloc] initWithUTF8String:eventId];
            else
                strEventId=[[NSString alloc]  initWithString:@" "];
            
            if(sendDate!=nil)
                strSendDate=[[NSString alloc] initWithUTF8String:sendDate];
            else
                strSendDate=[[NSString alloc] initWithString:@" "];
            
            
            if(isRead!=nil)
                strIsRead=[[NSString alloc] initWithUTF8String:isRead];
            else
                strIsRead=[[NSString alloc] initWithString:@" "];
            
            if(userId!=nil)
                strUseId=[[NSString alloc] initWithUTF8String:userId];
            else
                strUseId=[[NSString alloc] initWithString:@" "];
            
            
            if(attendee!=nil)
                strAttendeeId=[[NSString alloc] initWithUTF8String:attendee];
            else
                strAttendeeId=[[NSString alloc] initWithString:@" "];
            
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strNotificationId forKey:@"notification_id"];
            [eventInfo setValue:strTitle forKey:@"title"];
            [eventInfo setObject:strMessage forKey:@"message"];
            [eventInfo setValue:strEventId forKey:@"event_id"];
            [eventInfo setValue:strSendDate forKey:@"send_date"];
            [eventInfo setValue:strIsRead forKey:@"isread"];
            [eventInfo setValue:strUseId forKey:@"user_id"];
            [eventInfo setValue:strAttendeeId forKey:@"attendee_id"];
            
            [arrReturn addObject:eventInfo];
            
            //Releasing all string
            [eventInfo release];
            [strNotificationId release];
            [strTitle release];
            [strMessage release];
            [strEventId release];
            [strSendDate release];
            [strIsRead release];
            [strUseId release];
            [strAttendeeId release];
            
            
        }
    }
    sqlite3_finalize(statement);
    
    return arrReturn;
}

//Update NotificationData

- (void)UpdateNotificationData:(NSString *)strMAttenddeId NotificationId:(NSString *)strMNotificationId{
    
    // Setup the SQL Statement and compile it for faster access
    const char *sqlStatement = [[NSString stringWithFormat:@"UPDATE notifications Set isread =? where attendee_id ='%@' and notification_id='%@'",strMAttenddeId,strMNotificationId] UTF8String];
    sqlite3_stmt *compiledStatement;
    
    int prepare_result = sqlite3_prepare_v2(_database, sqlStatement, -1, &compiledStatement, NULL);
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK)) {
        // Error
        sqlite3_close(_database);
        return;
    }
    sqlite3_bind_text(compiledStatement, 1, [@"0" UTF8String], -1, SQLITE_TRANSIENT);
    
    int statement_result = sqlite3_step(compiledStatement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK)) {
        //Error
        sqlite3_close(_database);
        return;
    }
    sqlite3_finalize(compiledStatement);
}


//InserSponsorshipCategoryData



//CREATE TABLE "sponsorship_category" ("sponsorship_category_id" VARCHAR PRIMARY KEY  NOT NULL , "sponsorship_category" VARCHAR, "sponsorship_category_descreption" VARCHAR, "company_name" VARCHAR)

- (int)inserSponsorshipCategoryData:(NSString*)strScategoryId SponsorshipCategory:(NSString*)strSCategory SCategory_Descreption:(NSString*)strSCategory_Descreption strcompany_name:(NSString*)strcompany_name strSponsorship_exhibitors:(NSString*)strsponsorship_exhibitors
{
    
    int statement_result;
    const char * text2 = "INSERT INTO sponsorship_category (sponsorship_category_id,sponsorship_category,sponsorship_category_descreption,company_name,sponsorship_exhibitors) VALUES (?,?,?,?,?)";
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strScategoryId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[strSCategory UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[strSCategory_Descreption UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,4,[strcompany_name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,5,[strsponsorship_exhibitors UTF8String], -1, SQLITE_TRANSIENT);
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    
    return 1;
}


//InsertSponsor

//CREATE TABLE "sponsor" ("sponsorship_category_id" VARCHAR, "sponsor_logo" VARCHAR)
- (int)insertSponsor:(NSString*)strSponsor_categary Logo:(NSString*)strSponsor_Logo
{
    int statement_result;
    const char * text2 = "INSERT INTO sponsor (sponsorship_category_id,sponsor_logo) VALUES (?,?)";
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strSponsor_categary UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[strSponsor_Logo UTF8String], -1, SQLITE_TRANSIENT);
    
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    return 1;
    
}

//GetSponserLogoBySponserId:
-(NSMutableDictionary *)getSponserLogoBySponserId:(NSString*)sponsorship_category_id
{
    NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM sponsor where sponsorship_category_id ='%@'",sponsorship_category_id];
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            
            
            //featch values from tbl columns
            char *sponsorship_category_id=(char *) sqlite3_column_text(statement, 0);
            char *sponsorship_logo=(char *) sqlite3_column_text(statement, 1);
            
            //creating refrence strings
            NSString* strsponsorship_id;
            NSString* strsponsorship_logo;
            
            //test all columns value nil or not
            
            if(sponsorship_category_id!=nil)
                strsponsorship_id=[[NSString alloc] initWithUTF8String:sponsorship_category_id];
            else
                strsponsorship_id=[[NSString alloc] initWithString:@" "];
            
            if(sponsorship_logo!=nil)
                strsponsorship_logo=[[NSString alloc] initWithUTF8String:sponsorship_logo];
            else
                strsponsorship_logo=[[NSString alloc] initWithString:@" "];
            
            //set values in the Dictonary
            [eventInfo setValue:strsponsorship_id forKey:@"sponsorship_category_id"];
            [eventInfo setValue:strsponsorship_logo forKey:@"sponsorship_logo"];
            
            //Releasing all string
            [strsponsorship_id release];
            [strsponsorship_logo release];
        }
        sqlite3_finalize(statement);
        
        
    }
    return eventInfo;
}

// App Sponser
-(NSMutableArray *)getAllSponsorshipCategory
{
    
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM sponsorship_category where sponsorship_exhibitors='1'"];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *sCategoryId=(char *) sqlite3_column_text(statement, 0);
            char *sCategory=(char *) sqlite3_column_text(statement, 1);
            char *sDescreption=(char *) sqlite3_column_text(statement,2);
            char *sCompany=(char *) sqlite3_column_text(statement,3);
            char *isSExhibitors=(char *) sqlite3_column_text(statement,4);
            
            
            //creating refrence strings
            NSString* strSCategoryId;
            NSString* strSCategory;
            NSString* strSDescription;
            NSString* strCompany;
            NSString* strSponsorship_exhibitors;
            
            
            //test all columns value nil or not
            
            if(isSExhibitors!=nil)
                strSponsorship_exhibitors=[[NSString alloc] initWithUTF8String:isSExhibitors];
            else
                strSponsorship_exhibitors=[[NSString alloc] initWithString:@" "];
            
            if(sCategoryId!=nil)
                strSCategoryId=[[NSString alloc] initWithUTF8String:sCategoryId];
            else
                strSCategoryId=[[NSString alloc] initWithString:@" "];
            
            if(sCategory!=nil)
                strSCategory=[[NSString alloc] initWithUTF8String:sCategory];
            else
                strSCategory=[[NSString alloc] initWithString:@" "];
            
            if(sDescreption!=nil)
                strSDescription=[[NSString alloc] initWithUTF8String:sDescreption];
            else
                strSDescription=[[NSString alloc] initWithString:@" "];
            
            
            if(sCompany!=nil)
                strCompany=[[NSString alloc] initWithUTF8String:sCompany];
            else
                strCompany=[[NSString alloc] initWithString:@" "];
            
            
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strSCategoryId forKey:@"sponsorship_category_id"];
            [eventInfo setValue:strSCategory forKey:@"sponsorship_category"];
            [eventInfo setObject:strSDescription forKey:@"sponsorship_category_descreption"];
            [eventInfo setObject:strCompany forKey:@"company_name"];
              [eventInfo setObject:strSponsorship_exhibitors forKey:@"sponsorship_exhibitors"];
            [arrReturn addObject:eventInfo];
            
            //Releasing all string
            [eventInfo release];
            [strSCategoryId release];
            [strSCategory release];
            [strSDescription release];
            [strCompany release];
            [strSponsorship_exhibitors release];
            
        }
    }
    sqlite3_finalize(statement);
    
    return arrReturn;
}


//InsertAdvertisementData

//  CREATE TABLE "advertisement" ("ads_id" VARCHAR, "ads_title" VARCHAR, "description" VARCHAR, "exhibitor_id" VARCHAR, "photo1" VARCHAR, "photo2" VARCHAR, "photo3" VARCHAR, "photo4" VARCHAR, "photo5" VARCHAR)


- (int)insertAdvertisementData:(NSString*)strAds_id Ads_Title:(NSString*)strAdsTitle description:(NSString*)strADescription Exhibitor_Id:(NSString*)strExhibitor_Id Photo1:(NSString*)strPhoto1 Photo2:(NSString*)strPhoto2 Photo3:(NSString*)strPhoto3 Photo4:(NSString*)strPhoto4 Photo5:(NSString*)strPhoto5
{
    
    int statement_result;
    const char * text2 = "INSERT INTO advertisement (ads_id,ads_title,description,exhibitor_id,photo1,photo2,photo3,photo4,photo5) VALUES (?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strAds_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[strAdsTitle UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[strADescription UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,4,[strExhibitor_Id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,5,[strPhoto1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,6,[strPhoto2 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,7,[strPhoto3 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,8,[strPhoto4 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,9,[strPhoto5 UTF8String], -1, SQLITE_TRANSIENT);
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    
    return 1;
}

///get Advertisement
-(NSMutableArray *)getAdvertisement
{
    
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    NSString *query = [NSString stringWithFormat:@"SELECT  * FROM advertisement"];
    
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *adsid=(char *) sqlite3_column_text(statement, 0);
            char *adstitle=(char *) sqlite3_column_text(statement, 1);
            char *description=(char *) sqlite3_column_text(statement,2);
            char *exhibitorid=(char *) sqlite3_column_text(statement,3);
            char *photo1=(char *) sqlite3_column_text(statement,4);            //
            char *photo2=(char *) sqlite3_column_text(statement,5);
            char *photo3=(char *) sqlite3_column_text(statement,6);
            
            
            //creating refrence strings
            NSString* strAdsid;
            NSString* strAdstitle;
            NSString* strDescription;
            NSString* strExhibitorid;
            NSString* strPhoto1;
            //
            NSString* strPhoto2;
            NSString* strPhoto3;
            
            if(adsid!=nil)
                strAdsid=[[NSString alloc] initWithUTF8String:adsid];
            else
                strAdsid=[[NSString alloc] initWithString:@" "];
            
            if(adstitle!=nil)
                strAdstitle=[[NSString alloc] initWithUTF8String:adstitle];
            else
                strAdstitle=[[NSString alloc] initWithString:@" "];
            
            if(description!=nil)
                strDescription=[[NSString alloc] initWithUTF8String:description];
            else
                strDescription=[[NSString alloc] initWithString:@" "];
            
            if(exhibitorid!=nil)
                strExhibitorid=[[NSString alloc] initWithUTF8String:exhibitorid];
            else
                strExhibitorid=[[NSString alloc] initWithString:@" "];
            
            
            if(photo1!=nil)
                strPhoto1=[[NSString alloc] initWithUTF8String:photo1];
            else
                strPhoto1=[[NSString alloc] initWithString:@" "];
            
            if(photo2!=nil)
                strPhoto2=[[NSString alloc] initWithUTF8String:photo2];
            else
                strPhoto2=[[NSString alloc] initWithString:@" "];
            
            if(photo3!=nil)
                strPhoto3=[[NSString alloc] initWithUTF8String:photo3];
            else
                strPhoto3=[[NSString alloc] initWithString:@" "];
            
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            
            [eventInfo setValue:strExhibitorid forKey:@"exhibitor_id"];
            [eventInfo setValue:strPhoto1 forKey:@"photo1"];
            [eventInfo setValue:strPhoto2 forKey:@"photo2"];
            [eventInfo setObject:strPhoto3 forKey:@"photo3"];
            
            [strAdsid release];
            [strAdstitle release];
            [strDescription release];
            [strExhibitorid release];
            [strPhoto1 release];
            [strPhoto2 release];
            [strPhoto3 release];
            
            [arrReturn addObject:eventInfo];
            
            
        }
        
    }
    sqlite3_finalize(statement);
    
    return arrReturn;
}

//InsertSessionData

//CREATE TABLE "session" ("session_id" VARCHAR PRIMARY KEY  NOT NULL , "session_title" VARCHAR, "description" VARCHAR, "room" VARCHAR, "session_start_date" VARCHAR, "session_finish_date" VARCHAR, "session_start_time" VARCHAR, "session_end_time" VARCHAR, "event_id" VARCHAR, "session_type" VARCHAR, "color" VARCHAR)

- (int)insertSessionData:(NSString*)strSessionId sessionTitle:(NSString*)strSessionTitle description:(NSString*)strDescription room:(NSString*)strRoom sessionStartDate:(NSString*)strSessionStartDate sessionStartTime:(NSString*)strSessionStartTime sessionEndTime:(NSString*)strSessionEndTime sessionFinishDate:(NSString*)strSessionFinishDate  eventId:(NSString*)strEventId color:(NSString*)strHxColur
{
    
    int statement_result;
    
    const char * text2 = "INSERT INTO session (session_id,session_title,description,room,session_start_date,session_start_time,session_end_time,session_finish_date,event_id,color) VALUES (?,?,?,?,?,?,?,?,?,?)";
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strSessionId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[strSessionTitle UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[strDescription UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,4,[strRoom UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,5,[strSessionStartDate UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,6,[strSessionStartTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,7,[strSessionEndTime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,8,[strSessionFinishDate UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,9,[strEventId UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,10,[strHxColur UTF8String], -1, SQLITE_TRANSIENT);
    
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    
    return 1;
    
}

//IsertSpeakerSession

- (int)insertSpeakerSession:(NSString*)strspeaker_session_id speaker_id:(NSString*)strspeaker_id session_id:(NSString*)strsession_id
{
    
    
    int statement_result;
    const char * text2 = "INSERT INTO speaker_session (speaker_session_id,speaker_id,session_id) VALUES (?,?,?)";
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strspeaker_session_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[strspeaker_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[strsession_id UTF8String], -1, SQLITE_TRANSIENT);
    
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    
    return 1;
}



//GetAllSessionDate
-(NSMutableDictionary *)getAllSessionDate:(NSString*)eventid
{
    NSMutableDictionary *returnDate=[[NSMutableDictionary alloc]init];
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT distinct session_start_date FROM session WHERE event_id='%@' ORDER BY session_start_date",eventid];
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            
            char *sessionStartDate=(char *) sqlite3_column_text(statement,0);
            NSString* strSessionStartDate;
            
            if(sessionStartDate!=nil)
                strSessionStartDate=[[NSString alloc] initWithUTF8String:sessionStartDate];
            else
                strSessionStartDate=[[NSString alloc] initWithString:@" "];
            
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            [eventInfo setValue:strSessionStartDate forKey:@"date"];
            [eventInfo setValue:strSessionStartDate forKey:@"date_string"];
            [arrReturn addObject:eventInfo];
            //Releasing all string
            [eventInfo release];
            [strSessionStartDate release];
            
        }
        
        if (arrReturn.count!=0)
        {
            [returnDate setValue:@"true" forKey:@"success"];
            [returnDate setValue:arrReturn forKey:@"result"];
        }
        else
            [returnDate setValue:@"false" forKey:@"success"];
        
    }
    sqlite3_finalize(statement);
    
    return returnDate;
}


//Get  Session Data By sessionid

-(NSMutableDictionary *)getSessionDataByDate:(NSString*)date
{
    NSMutableDictionary *returnDate=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *dicReturn=[[NSMutableDictionary alloc]init];
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    
    NSString *query = [NSString stringWithFormat:@"SELECT *  FROM session  where session_start_date='%@'",date];
    
   // NSString *query = [NSString stringWithFormat:@"SELECT session.* , speaker.speaker_id, speaker.speaker_name ,speaker.photo  FROM session  LEFT JOIN  speaker ON speaker.speaker_id = session.session_id   WHERE session_start_date='%@'",date];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //featch values from tbl columns
            char *sessionId=(char *) sqlite3_column_text(statement, 0);
            char *sessionTitle=(char *) sqlite3_column_text(statement, 1);
            char *description=(char *) sqlite3_column_text(statement,2);
            char *room=(char *) sqlite3_column_text(statement,3);
            char *sessionStartDate=(char *) sqlite3_column_text(statement,4);
            char *sessionFinishDate=(char *) sqlite3_column_text(statement,5);
            char *sessionStartTime=(char *) sqlite3_column_text(statement,6);
            char *sessionEndTime=(char *) sqlite3_column_text(statement,7);
            char *event_id=(char *) sqlite3_column_text(statement,8);
            char *isValue=(char *) sqlite3_column_text(statement,9);
            char *color=(char *) sqlite3_column_text(statement,10);
//            char *speaker_name=(char *) sqlite3_column_text(statement,12);
//            char *speaker_photo=(char *) sqlite3_column_text(statement,13);
            
            //creating refrence strings
            NSString* strSessionId;
            NSString* strSessionTitle;
            NSString* strDescription;
            NSString* strRoom;
            NSString* strSessionStartDate;
            NSString* strSessionFinishDate;
            NSString* strSessionStartTime;
            NSString* strSessionEndTime;
            NSString* strEventId;
            NSString* strIsvalue;
            NSString* strColor;
//            NSString* strspeakername;
//            NSString* strspeakerphoto;
            
            
            //test all columns value nil or not
            
            if(sessionId!=nil)
                strSessionId=[[NSString alloc] initWithUTF8String:sessionId];
            else
                strSessionId=[[NSString alloc] initWithString:@" "];
            
            if(sessionTitle!=nil)
                strSessionTitle=[[NSString alloc] initWithUTF8String:sessionTitle];
            else
                strSessionTitle=[[NSString alloc] initWithString:@" "];
            
            if(description!=nil)
                strDescription=[[NSString alloc] initWithUTF8String:description];
            else
                strDescription=[[NSString alloc] initWithString:@" "];
            
            if(room!=nil)
                strRoom=[[NSString alloc] initWithUTF8String:room];
            else
                strRoom=[[NSString alloc]  initWithString:@" "];
            
            if(sessionStartDate!=nil)
                strSessionStartDate=[[NSString alloc] initWithUTF8String:sessionStartDate];
            else
                strSessionStartDate=[[NSString alloc] initWithString:@" "];
            
            
            if(sessionFinishDate!=nil)
                strSessionFinishDate=[[NSString alloc] initWithUTF8String:sessionFinishDate];
            else
                strSessionFinishDate=[[NSString alloc] initWithString:@" "];
            
            if(sessionStartTime!=nil)
                strSessionStartTime=[[NSString alloc] initWithUTF8String:sessionStartTime];
            else
                strSessionStartTime=[[NSString alloc] initWithString:@" "];
            
            if(sessionEndTime!=nil)
                strSessionEndTime=[[NSString alloc] initWithUTF8String:sessionEndTime];
            else
                strSessionEndTime=[[NSString alloc] initWithString:@" "];
            
            
            if(event_id!=nil)
                strEventId=[[NSString alloc] initWithUTF8String:event_id];
            else
                strEventId=[[NSString alloc] initWithString:@" "];
            
            
            if(isValue!=nil)
                strIsvalue=[[NSString alloc] initWithUTF8String:isValue];
            else
                strIsvalue=[[NSString alloc] initWithString:@" "];
            
            if(color!=nil)
                strColor=[[NSString alloc] initWithUTF8String:color];
            else
                strColor=[[NSString alloc] initWithString:@" "];
            
//            if(speaker_name!=nil)
//                strspeakername=[[NSString alloc] initWithUTF8String:speaker_name];
//            else
//                strspeakername=[[NSString alloc] initWithString:@" "];
//            
//            if(speaker_name!=nil)
//                strspeakerphoto=[[NSString alloc] initWithUTF8String:speaker_photo];
//            else
//                strspeakerphoto=[[NSString alloc] initWithString:@" "];
            
            //set values in the Dictonary
            [eventInfo setValue:strSessionId forKey:@"session_id"];
            [eventInfo setValue:strSessionTitle forKey:@"session_title"];
            [eventInfo setObject:strDescription forKey:@"description"];
            [eventInfo setValue:strRoom forKey:@"room"];
            [eventInfo setValue:strSessionStartDate forKey:@"session_start_date"];
            [eventInfo setValue:strSessionFinishDate forKey:@"session_finish_time"];
            [eventInfo setValue:strSessionStartTime forKey:@"session_start_time"];
            [eventInfo setValue:strSessionEndTime forKey:@"session_end_time"];
            [eventInfo setValue:strEventId forKey:@"event_id"];
            [eventInfo setValue:strIsvalue forKey:@"isvalue"];
            [eventInfo setValue:strColor forKey:@"color"];
//            [eventInfo setValue:strspeakername forKey:@"speaker_name"];
//            [eventInfo setValue:strspeakerphoto forKey:@"photo"];
            
            //
            [arrReturn addObject:eventInfo];
            
            //Releasing all string
            [strSessionId release];
            [strSessionTitle release];
            [strDescription release];
            [strRoom release];
            [strSessionStartDate release];
            [strSessionFinishDate release];
            [strSessionStartTime release];
            [strSessionEndTime release];
            [strEventId release];
            [strEventId release];
            [strIsvalue release];
//            [strColor release];
//            [strspeakerphoto release];
            
            [returnDate setValue:@"true" forKey:@"success"];
            [dicReturn setValue:arrReturn forKey:@"session_data"];
            
            
        }
        [returnDate setValue:dicReturn forKey:@"result"];
    }
    
    sqlite3_finalize(statement);
    
    return returnDate;
}

//GetSessionDateBysection

-(NSMutableDictionary *)getSessionDateBysection:(NSString*)date timeFormate:(NSString*)strtimeFormate timeInterval1:(NSString*)strTimeInterval1 timeInterval2:(NSString*)strTimeInterval2
{
    NSMutableDictionary *returnDate=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *dicReturn=[[NSMutableDictionary alloc]init];
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *strSessionID=[self getSessionIDFor:date timeFormate:strtimeFormate timeInterval1:strTimeInterval1 timeInterval2:strTimeInterval2];
    
    NSString *query=@"";
    
    if ([strSessionID isEqualToString:@"My"])
    {
        //speakernot availabel for this session
        query = [NSString stringWithFormat:@"SELECT session.*  FROM session where session_start_date='%@' and session_start_time LIKE  '%@' and   session_start_time  BETWEEN '%@'  and  '%@' ",date,strtimeFormate,strTimeInterval1,strTimeInterval2];
    }
    else
    {
        query = [NSString stringWithFormat:@"SELECT session.* , speaker.speaker_id, speaker.speaker_name ,speaker.photo ,    speaker.job_title ,speaker.company_name FROM session  LEFT JOIN  speaker ON speaker.speaker_id = %@  where session_start_date='%@' and session_start_time LIKE  '%@' and   session_start_time  BETWEEN '%@'  and  '%@' ",strSessionID,date,strtimeFormate,strTimeInterval1,strTimeInterval2];
    }
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //featch values from tbl columns
            char *sessionId=(char *) sqlite3_column_text(statement, 0);
            char *sessionTitle=(char *) sqlite3_column_text(statement, 1);
            char *description=(char *) sqlite3_column_text(statement,2);
            char *room=(char *) sqlite3_column_text(statement,3);
            char *sessionStartDate=(char *) sqlite3_column_text(statement,4);
            char *sessionFinishDate=(char *) sqlite3_column_text(statement,5);
            char *sessionStartTime=(char *) sqlite3_column_text(statement,6);
            char *sessionEndTime=(char *) sqlite3_column_text(statement,7);
            char *event_id=(char *) sqlite3_column_text(statement,8);
            char *isValue=(char *) sqlite3_column_text(statement,9);
            char *color=(char *) sqlite3_column_text(statement,10);
            char *speaker_name=(char *) sqlite3_column_text(statement,12);
            char *speaker_photo=(char *) sqlite3_column_text(statement,13);
            char *speaker_jobtilte=(char *) sqlite3_column_text(statement,14);
            char *speaker_cmpname=(char *) sqlite3_column_text(statement,15);
            
            
            //creating refrence strings
            NSString* strSessionId;
            NSString* strSessionTitle;
            NSString* strDescription;
            NSString* strRoom;
            NSString* strSessionStartDate;
            NSString* strSessionFinishDate;
            NSString* strSessionStartTime;
            NSString* strSessionEndTime;
            NSString* strEventId;
            NSString* strIsvalue;
            NSString* strColor;
            NSString* strspeakername;
            NSString* strspeakerphoto;
            NSString* strspeakerJobtitle;
            NSString* strspeakerCmpname;
            
            
            //test all columns value nil or not
            
            if(sessionId!=nil)
                strSessionId=[[NSString alloc] initWithUTF8String:sessionId];
            else
                strSessionId=[[NSString alloc] initWithString:@" "];
            
            if(sessionTitle!=nil)
                strSessionTitle=[[NSString alloc] initWithUTF8String:sessionTitle];
            else
                strSessionTitle=[[NSString alloc] initWithString:@" "];
            
            if(description!=nil)
                strDescription=[[NSString alloc] initWithUTF8String:description];
            else
                strDescription=[[NSString alloc] initWithString:@" "];
            
            if(room!=nil)
                strRoom=[[NSString alloc] initWithUTF8String:room];
            else
                strRoom=[[NSString alloc]  initWithString:@" "];
            
            if(sessionStartDate!=nil)
                strSessionStartDate=[[NSString alloc] initWithUTF8String:sessionStartDate];
            else
                strSessionStartDate=[[NSString alloc] initWithString:@" "];
            
            
            if(sessionFinishDate!=nil)
                strSessionFinishDate=[[NSString alloc] initWithUTF8String:sessionFinishDate];
            else
                strSessionFinishDate=[[NSString alloc] initWithString:@" "];
            
            if(sessionStartTime!=nil)
                strSessionStartTime=[[NSString alloc] initWithUTF8String:sessionStartTime];
            else
                strSessionStartTime=[[NSString alloc] initWithString:@" "];
            
            if(sessionEndTime!=nil)
                strSessionEndTime=[[NSString alloc] initWithUTF8String:sessionEndTime];
            else
                strSessionEndTime=[[NSString alloc] initWithString:@" "];
            
            
            if(event_id!=nil)
                strEventId=[[NSString alloc] initWithUTF8String:event_id];
            else
                strEventId=[[NSString alloc] initWithString:@" "];
            
            
            if(isValue!=nil)
                strIsvalue=[[NSString alloc] initWithUTF8String:isValue];
            else
                strIsvalue=[[NSString alloc] initWithString:@" "];
            
            if(color!=nil)
                strColor=[[NSString alloc] initWithUTF8String:color];
            else
                strColor=[[NSString alloc] initWithString:@" "];
            
            if(speaker_name!=nil)
                strspeakername=[[NSString alloc] initWithUTF8String:speaker_name];
            else
                strspeakername=[[NSString alloc] initWithString:@" "];
            
            if(speaker_name!=nil)
                strspeakerphoto=[[NSString alloc] initWithUTF8String:speaker_photo];
            else
                strspeakerphoto=[[NSString alloc] initWithString:@" "];
            
            
            if(speaker_jobtilte!=nil)
                strspeakerJobtitle=[[NSString alloc] initWithUTF8String:speaker_jobtilte];
            else
                strspeakerJobtitle=[[NSString alloc] initWithString:@" "];
            
            if(speaker_cmpname!=nil)
                strspeakerCmpname=[[NSString alloc] initWithUTF8String:speaker_cmpname];
            else
                strspeakerCmpname=[[NSString alloc] initWithString:@" "];
            
            
            //set values in the Dictonary
            [eventInfo setValue:strSessionId forKey:@"session_id"];
            [eventInfo setValue:strSessionTitle forKey:@"session_title"];
            [eventInfo setObject:strDescription forKey:@"description"];
            [eventInfo setValue:strRoom forKey:@"room"];
            [eventInfo setValue:strSessionStartDate forKey:@"session_start_date"];
            [eventInfo setValue:strSessionFinishDate forKey:@"session_finish_time"];
            [eventInfo setValue:strSessionStartTime forKey:@"session_start_time"];
            [eventInfo setValue:strSessionEndTime forKey:@"session_end_time"];
            [eventInfo setValue:strEventId forKey:@"event_id"];
            [eventInfo setValue:strIsvalue forKey:@"isvalue"];
            [eventInfo setValue:strColor forKey:@"color"];
            [eventInfo setValue:strspeakername forKey:@"speaker_name"];
            [eventInfo setValue:strspeakerphoto forKey:@"photo"];
            [eventInfo setValue:strspeakerJobtitle forKey:@"job_title"];
            [eventInfo setValue:strspeakerCmpname forKey:@"company_name"];
            
            //
            
            [arrReturn addObject:eventInfo];
            
            //Releasing all string
            [strSessionId release];
            [strSessionTitle release];
            [strDescription release];
            [strRoom release];
            [strSessionStartDate release];
            [strSessionFinishDate release];
            [strSessionStartTime release];
            [strSessionEndTime release];
            [strEventId release];
            [strEventId release];
            [strIsvalue release];
            [strColor release];
            [strspeakerphoto release];
            [returnDate setValue:@"true" forKey:@"success"];
            [dicReturn setValue:arrReturn forKey:@"session_data"];
            
            
        }
        [returnDate setValue:dicReturn forKey:@"result"];
    }
    
    sqlite3_finalize(statement);
    
    return returnDate;
}

-(NSString *)getSessionIDFor:(NSString*)date timeFormate:(NSString*)strtimeFormate timeInterval1:(NSString*)strTimeInterval1 timeInterval2:(NSString*)strTimeInterval2
{
    NSString* strSessionId=@"My";
    
    NSString *query = [NSString stringWithFormat:@"select speaker_id from speaker_session where session_id=(SELECT session_id FROM session where session_start_date='%@' and session_start_time LIKE  '%@' and   session_start_time  BETWEEN '%@'  and  '%@' )",date,strtimeFormate,strTimeInterval1,strTimeInterval2];
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char *sessionId=(char *) sqlite3_column_text(statement, 0);
            
            if(sessionId!=nil)
                strSessionId=[[NSString alloc] initWithUTF8String:sessionId];
            else
                strSessionId=[[NSString alloc] initWithString:@" "];
        }
    }
    sqlite3_finalize(statement);
    
    return strSessionId;
    
}



//GetSessionIDForSessionInfoBy

//-(NSMutableArray *)getSessionIDForSessionInfoBy:(NSString*)date timeFormate:(NSString*)strtimeFormate timeInterval1:(NSString*)strTimeInterval1 timeInterval2:(NSString*)strTimeInterval2
-(NSMutableArray *)getSessionIDForSessionInfoBy:(NSString*)Sessionid
{
    NSMutableArray *arrSpeaker_idS= [[NSMutableArray alloc]init];
    NSString* strSpeakerId=@"My";
    
    NSString *query = [NSString stringWithFormat:@"select speaker_id from speaker_session where session_id='%@'",Sessionid];
    
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            char *speaker_id=(char *) sqlite3_column_text(statement, 0);
            
            if(speaker_id!=nil)
            {
                strSpeakerId=[[NSString alloc] initWithUTF8String:speaker_id];
                [arrSpeaker_idS addObject:strSpeakerId];
            }
            else
                strSpeakerId=[[NSString alloc] initWithString:@" "];
        }
    }
    sqlite3_finalize(statement);
    
    return arrSpeaker_idS;
    
}



//Get All Session Data By Event_id
//CREATE TABLE "session" ("session_id" VARCHAR PRIMARY KEY  NOT NULL ,"session_title" VARCHAR,"description" VARCHAR,"room" VARCHAR,"session_start_date" VARCHAR,"session_finish_date" VARCHAR DEFAULT (null) ,"session_start_time" VARCHAR,"session_end_time" VARCHAR,"event_id" VARCHAR)

//Get All Session Data By Event_id

-(NSMutableArray *)getAllSessionDataByEventId:(NSString*)eventid
{
    
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM session WHERE event_id='%@'",eventid];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *sessionId=(char *) sqlite3_column_text(statement, 0);
            char *sessionTitle=(char *) sqlite3_column_text(statement, 1);
            char *description=(char *) sqlite3_column_text(statement,2);
            char *room=(char *) sqlite3_column_text(statement,3);
            char *sessionStartDate=(char *) sqlite3_column_text(statement,4);
            char *sessionFinishDate=(char *) sqlite3_column_text(statement,5);
            char *sessionStartTime=(char *) sqlite3_column_text(statement,6);
            char *sessionEndTime=(char *) sqlite3_column_text(statement,7);
            char *event_id=(char *) sqlite3_column_text(statement,8);
            
            //creating refrence strings
            NSString* strSessionId;
            NSString* strSessionTitle;
            NSString* strDescription;
            NSString* strRoom;
            NSString* strSessionStartDate;
            NSString* strSessionFinishDate;
            NSString* strSessionStartTime;
            NSString* strSessionEndTime;
            NSString* strEventId;
            
            
            //test all columns value nil or not
            
            if(sessionId!=nil)
                strSessionId=[[NSString alloc] initWithUTF8String:sessionId];
            else
                strSessionId=[[NSString alloc] initWithString:@" "];
            
            if(sessionTitle!=nil)
                strSessionTitle=[[NSString alloc] initWithUTF8String:sessionTitle];
            else
                strSessionTitle=[[NSString alloc] initWithString:@" "];
            
            if(description!=nil)
                strDescription=[[NSString alloc] initWithUTF8String:description];
            else
                strDescription=[[NSString alloc] initWithString:@" "];
            
            if(room!=nil)
                strRoom=[[NSString alloc] initWithUTF8String:room];
            else
                strRoom=[[NSString alloc]  initWithString:@" "];
            
            if(sessionStartDate!=nil)
                strSessionStartDate=[[NSString alloc] initWithUTF8String:sessionStartDate];
            else
                strSessionStartDate=[[NSString alloc] initWithString:@" "];
            
            
            if(sessionFinishDate!=nil)
                strSessionFinishDate=[[NSString alloc] initWithUTF8String:sessionFinishDate];
            else
                strSessionFinishDate=[[NSString alloc] initWithString:@" "];
            
            if(sessionStartTime!=nil)
                strSessionStartTime=[[NSString alloc] initWithUTF8String:sessionStartTime];
            else
                strSessionStartTime=[[NSString alloc] initWithString:@" "];
            
            if(sessionEndTime!=nil)
                strSessionEndTime=[[NSString alloc] initWithUTF8String:sessionEndTime];
            else
                strSessionEndTime=[[NSString alloc] initWithString:@" "];
            
            
            if(event_id!=nil)
                strEventId=[[NSString alloc] initWithUTF8String:event_id];
            else
                strEventId=[[NSString alloc] initWithString:@" "];
            
            
            NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
            //set values in the Dictonary
            [eventInfo setValue:strSessionId forKey:@"session_id"];
            [eventInfo setValue:strSessionTitle forKey:@"session_title"];
            [eventInfo setObject:strDescription forKey:@"description"];
            [eventInfo setValue:strRoom forKey:@"room"];
            [eventInfo setValue:strSessionStartDate forKey:@"session_start_date"];
            [eventInfo setValue:strSessionFinishDate forKey:@"session_finish_time"];
            [eventInfo setValue:strSessionStartTime forKey:@"session_start_time"];
            [eventInfo setValue:strSessionEndTime forKey:@"session_end_time"];
            [eventInfo setValue:strEventId forKey:@"event_id"];
            [arrReturn addObject:eventInfo];
            
            
            //Releasing all string
            [eventInfo release];
            [strSessionId release];
            [strSessionTitle release];
            [strDescription release];
            [strRoom release];
            [strSessionStartDate release];
            [strSessionFinishDate release];
            [strSessionStartTime release];
            [strSessionEndTime release];
            [strEventId release];
            
        }
    }
    sqlite3_finalize(statement);
    
    return arrReturn;
}


//GetAllmyscheduleDataByAttendeeId
-(NSMutableArray *)getAllmyscheduleDataByAttendeeId:(NSString*)attendeeId
{
    
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    
    NSMutableArray *arrSessionIDS=[self SessionIDSByAttendeeid:attendeeId];
    
    for (int i=0; i<arrSessionIDS.count;i++)
    {
        
        NSDictionary *dicSession=[arrSessionIDS objectAtIndex:i];
        
        
        int getspeacker=[self SpeakerExistInSpeaker_session:[dicSession valueForKey:@"session_id"]];
        NSString *query=@"";
        
        if(getspeacker==1)
        {
            
            
            query =[NSString stringWithFormat:@"select session.*,speaker.speaker_name, speaker.photo,speaker.job_title, speaker.company_name  from session LEFT JOIN  speaker ON  speaker.speaker_id=(select speaker_id from speaker_session where session_id='%@')  where session.session_id='%@'",[dicSession valueForKey:@"session_id"],[dicSession valueForKey:@"session_id"]];
            
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    //featch values from tbl columns
                    char *sessionId=(char *) sqlite3_column_text(statement, 0);
                    char *sessionTitle=(char *) sqlite3_column_text(statement, 1);
                    char *Description=(char *) sqlite3_column_text(statement,2);
                    char *room=(char *) sqlite3_column_text(statement,3);
                    char *sessionStartdate=(char *) sqlite3_column_text(statement,4);
                    char *sessionFinishdate=(char *) sqlite3_column_text(statement,5);
                    char *sessionStarttime=(char *) sqlite3_column_text(statement,6);
                    char *sessionEndtime=(char *) sqlite3_column_text(statement,7);
                    char *event_id=(char *) sqlite3_column_text(statement,8);
                    char *color=(char *) sqlite3_column_text(statement,10);
                    char *speaker_name=(char *) sqlite3_column_text(statement,11);
                    char *speaker_photo=(char *) sqlite3_column_text(statement,12);
                    char *speaker_job=(char *) sqlite3_column_text(statement,13);
                    char *speaker_Company=(char *) sqlite3_column_text(statement,14);
                    
                    
                    //creating refrence strings
                    NSString* strsessionId;
                    NSString* strsessionTitle;
                    NSString* strDescription;
                    NSString* strRoom;
                    NSString* strSessionStartdate;
                    NSString* strSessionFinishdate;
                    NSString* strSessionStarttime;
                    NSString* strSessionEndtime;
                    NSString* strEventId;
                    NSString* strColor;
                    NSString* strspeakername;
                    NSString* strspeakerphoto;
                    NSString* strspeakerJob;
                    NSString* strspeakerCompany;
                    
                    
                    //test all columns value nil or not
                    
                    if(sessionId!=nil)
                        strsessionId=[[NSString alloc] initWithUTF8String:sessionId];
                    else
                        strsessionId=[[NSString alloc] initWithString:@" "];
                    
                    if(sessionTitle!=nil)
                        strsessionTitle=[[NSString alloc] initWithUTF8String:sessionTitle];
                    else
                        strsessionTitle=[[NSString alloc] initWithString:@" "];
                    
                    if(Description!=nil)
                        strDescription=[[NSString alloc] initWithUTF8String:Description];
                    else
                        strDescription=[[NSString alloc] initWithString:@" "];
                    
                    if(room!=nil)
                        strRoom=[[NSString alloc] initWithUTF8String:room];
                    else
                        strRoom=[[NSString alloc]  initWithString:@" "];
                    
                    if(sessionStartdate!=nil)
                        strSessionStartdate=[[NSString alloc] initWithUTF8String:sessionStartdate];
                    else
                        strSessionStartdate=[[NSString alloc]  initWithString:@" "];
                    
                    if(sessionFinishdate!=nil)
                        strSessionFinishdate=[[NSString alloc] initWithUTF8String:sessionFinishdate];
                    else
                        strSessionFinishdate=[[NSString alloc] initWithString:@" "];
                    
                    if(sessionStarttime!=nil)
                        strSessionStarttime=[[NSString alloc] initWithUTF8String:sessionStarttime];
                    else
                        strSessionStarttime=[[NSString alloc] initWithString:@" "];
                    
                    if(sessionEndtime!=nil)
                        strSessionEndtime=[[NSString alloc] initWithUTF8String:sessionEndtime];
                    else
                        strSessionEndtime=[[NSString alloc] initWithString:@" "];
                    
                    if(event_id!=nil)
                        strEventId=[[NSString alloc] initWithUTF8String:event_id];
                    else
                        strEventId=[[NSString alloc] initWithString:@" "];
                    
                    if(color!=nil)
                        strColor=[[NSString alloc] initWithUTF8String:color];
                    else
                        strColor=[[NSString alloc] initWithString:@"fefefe"];
                    
                    if(speaker_name!=nil)
                        strspeakername=[[NSString alloc] initWithUTF8String:speaker_name];
                    else
                        strspeakername=[[NSString alloc] initWithString:@" "];
                    
                    if(speaker_name!=nil)
                        strspeakerphoto=[[NSString alloc] initWithUTF8String:speaker_photo];
                    else
                        strspeakerphoto=[[NSString alloc] initWithString:@" "];
                    
                    if(speaker_job!=nil)
                        strspeakerJob=[[NSString alloc] initWithUTF8String:speaker_job];
                    else
                        strspeakerJob=[[NSString alloc] initWithString:@" "];
                    
                    if(speaker_Company!=nil)
                        strspeakerCompany=[[NSString alloc] initWithUTF8String:speaker_Company];
                    else
                        strspeakerCompany=[[NSString alloc] initWithString:@" "];
                    
                    
                    NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
                    //set values in the Dictonary
                    [eventInfo setValue:strsessionId forKey:@"session_id"];
                    [eventInfo setValue:strsessionTitle forKey:@"session_title"];
                    [eventInfo setObject:strDescription forKey:@"description"];
                    [eventInfo setValue:strRoom forKey:@"room"];
                    [eventInfo setValue:strSessionStartdate forKey:@"session_start_date"];
                    [eventInfo setValue:strSessionFinishdate forKey:@"session_finish_date"];
                    [eventInfo setObject:strSessionStarttime forKey:@"session_start_time"];
                    [eventInfo setValue:strSessionEndtime forKey:@"session_end_time"];
                    [eventInfo setValue:strEventId forKey:@"event_id"];
                    [eventInfo setValue:strColor forKey:@"color"];
                    [eventInfo setValue:strspeakername forKey:@"speaker_name"];
                    [eventInfo setValue:strspeakerphoto forKey:@"photo"];
                    [eventInfo setValue:strspeakerJob forKey:@"speaker_Job"];
                    [eventInfo setValue:strspeakerCompany forKey:@"speaker_COMPANY"];
                    [eventInfo setValue:[dicSession valueForKey:@"Atime"] forKey:@"ATIME"];
                    [arrReturn addObject:eventInfo];
                    
                    //Releasing all string
                    [eventInfo release];
                    
                    [strsessionId release];
                    [strsessionTitle release];
                    [strDescription release];
                    [strRoom release];
                    [strSessionStartdate release];
                    [strSessionFinishdate release];
                    [strSessionStarttime release];
                    [strSessionEndtime release];
                    [strEventId release];
                    [strspeakername release];
                    [strspeakerphoto release];
                    
                }
            }
            sqlite3_finalize(statement);
        }
        else
        {
           
            query =[NSString stringWithFormat:@"select * from session where session_id='%@'",[dicSession valueForKey:@"session_id"]];
            
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    //featch values from tbl columns
                    char *sessionId=(char *) sqlite3_column_text(statement, 0);
                    char *sessionTitle=(char *) sqlite3_column_text(statement, 1);
                    char *Description=(char *) sqlite3_column_text(statement,2);
                    char *room=(char *) sqlite3_column_text(statement,3);
                    char *sessionStartdate=(char *) sqlite3_column_text(statement,4);
                    char *sessionFinishdate=(char *) sqlite3_column_text(statement,5);
                    char *sessionStarttime=(char *) sqlite3_column_text(statement,6);
                    char *sessionEndtime=(char *) sqlite3_column_text(statement,7);
                    char *event_id=(char *) sqlite3_column_text(statement,8);
                    char *color=(char *) sqlite3_column_text(statement,10);
                    
                    //creating refrence strings
                    NSString* strsessionId;
                    NSString* strsessionTitle;
                    NSString* strDescription;
                    NSString* strRoom;
                    NSString* strSessionStartdate;
                    NSString* strSessionFinishdate;
                    NSString* strSessionStarttime;
                    NSString* strSessionEndtime;
                    NSString* strEventId;
                    NSString* strspeakername;
                    NSString* strspeakerphoto;
                    NSString* strColor;
                    
                    //test all columns value nil or not
                    
                    
                    if(sessionId!=nil)
                        strsessionId=[[NSString alloc] initWithUTF8String:sessionId];
                    else
                        strsessionId=[[NSString alloc] initWithString:@" "];
                    
                    if(sessionTitle!=nil)
                        strsessionTitle=[[NSString alloc] initWithUTF8String:sessionTitle];
                    else
                        strsessionTitle=[[NSString alloc] initWithString:@" "];
                    
                    if(Description!=nil)
                        strDescription=[[NSString alloc] initWithUTF8String:Description];
                    else
                        strDescription=[[NSString alloc] initWithString:@" "];
                    
                    if(room!=nil)
                        strRoom=[[NSString alloc] initWithUTF8String:room];
                    else
                        strRoom=[[NSString alloc]  initWithString:@" "];
                    
                    if(sessionStartdate!=nil)
                        strSessionStartdate=[[NSString alloc] initWithUTF8String:sessionStartdate];
                    else
                        strSessionStartdate=[[NSString alloc]  initWithString:@" "];
                    
                    if(sessionFinishdate!=nil)
                        strSessionFinishdate=[[NSString alloc] initWithUTF8String:sessionFinishdate];
                    else
                        strSessionFinishdate=[[NSString alloc] initWithString:@" "];
                    
                    if(sessionStarttime!=nil)
                        strSessionStarttime=[[NSString alloc] initWithUTF8String:sessionStarttime];
                    else
                        strSessionStarttime=[[NSString alloc] initWithString:@" "];
                    
                    if(sessionEndtime!=nil)
                        strSessionEndtime=[[NSString alloc] initWithUTF8String:sessionEndtime];
                    else
                        strSessionEndtime=[[NSString alloc] initWithString:@" "];
                    
                    if(event_id!=nil)
                        strEventId=[[NSString alloc] initWithUTF8String:event_id];
                    else
                        strEventId=[[NSString alloc] initWithString:@" "];
                    
                    if(color!=nil)
                        strColor=[[NSString alloc] initWithUTF8String:color];
                    else
                        strColor=[[NSString alloc] initWithString:@"#fefefe"];
                    
                    NSMutableDictionary *eventInfo=[[NSMutableDictionary alloc]init];
                    //set values in the Dictonary
                    [eventInfo setValue:strsessionId forKey:@"session_id"];
                    [eventInfo setValue:strsessionTitle forKey:@"session_title"];
                    [eventInfo setObject:strDescription forKey:@"description"];
                    [eventInfo setValue:strRoom forKey:@"room"];
                    [eventInfo setValue:strSessionStartdate forKey:@"session_start_date"];
                    [eventInfo setValue:strSessionFinishdate forKey:@"session_finish_date"];
                    [eventInfo setObject:strSessionStarttime forKey:@"session_start_time"];
                    [eventInfo setValue:strSessionEndtime forKey:@"session_end_time"];
                    [eventInfo setValue:strEventId forKey:@"event_id"];
                    [eventInfo setValue:strColor forKey:@"color"];
                    strspeakername=[[NSString alloc] initWithString:@" "];
                    strspeakerphoto=[[NSString alloc] initWithString:@" "];
                    [eventInfo setValue:strspeakername forKey:@"speaker_name"];
                    [eventInfo setValue:strspeakerphoto forKey:@"photo"];
                    [eventInfo setValue:[dicSession valueForKey:@"Atime"] forKey:@"ATIME"];
                    
                    [arrReturn addObject:eventInfo];
                    //Releasing all string
                    [eventInfo release];
                    [strsessionId release];
                    [strsessionTitle release];
                    [strDescription release];
                    [strRoom release];
                    [strSessionStartdate release];
                    [strSessionFinishdate release];
                    [strSessionStarttime release];
                    [strSessionEndtime release];
                    [strEventId release];
                    [strColor release];
                    [strspeakername release];
                    [strspeakerphoto release];
                    
                }
            }
            sqlite3_finalize(statement);
        }
        
    }
    
    return arrReturn;
}

-(NSMutableArray *)SessionIDSByAttendeeid:(NSString *)attendeeid
{
    NSMutableArray *arrSessionIds= [[NSMutableArray alloc]init];
    NSString *selectSql = [NSString stringWithFormat:@"SELECT session_id,alert_session_time FROM attendee_session where attendee_id=\'%@\'",attendeeid];
    
    
    sqlite3_stmt * select;
    const char * text2=[selectSql UTF8String];
    int prepare = sqlite3_prepare_v2(_database,text2, -1, &select, NULL);
    if (prepare== SQLITE_OK) {
        while (sqlite3_step(select) == SQLITE_ROW) {
            
            char *sessionId=(char *) sqlite3_column_text(select, 0);
            char *alertSessionTime=(char *) sqlite3_column_text(select, 1);
            
            NSString* strsessionId;
            NSString* strAletTime;
            
            if(sessionId!=nil)
                strsessionId=[[NSString alloc] initWithUTF8String:sessionId];
            else
                strsessionId=[[NSString alloc] initWithString:@" "];
            
            if(alertSessionTime!=nil)
                strAletTime=[[NSString alloc] initWithUTF8String:alertSessionTime];
            else
                strAletTime=[[NSString alloc] initWithString:@" "];
            
            NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
            [Info setValue:strsessionId forKey:@"session_id"];
            [Info setValue:strAletTime forKey:@"Atime"];
            [arrSessionIds addObject:Info];
            [Info release];
            
            [strsessionId release];
            [strAletTime release];
            
        }
    }
    sqlite3_finalize(select);
    
    return arrSessionIds;
}




-(int)SpeakerExistInSpeaker_session:(NSString *)sessionid
{
    
    int uniqueIdAdd=0;
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT speaker_id FROM speaker_session where session_id=\'%@\'",sessionid];
    
    sqlite3_stmt * select;
    const char * text2=[selectSql UTF8String];
    int prepare = sqlite3_prepare_v2(_database,text2, -1, &select, NULL);
    if (prepare== SQLITE_OK) {
        while (sqlite3_step(select) == SQLITE_ROW) {
            uniqueIdAdd = sqlite3_column_int(select, 0);
            
        }
    }
    sqlite3_finalize(select);
    
    if (uniqueIdAdd==0) {
        return 0;
    }
    else
    {
        return 1;
    }
    
}



//SelectMAX_Attendee_session_ID

- (int)SelectMAX_Attendee_session_ID
{
    int uniqueIdAdd=0;
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT max(attendee_session_id) FROM attendee_session"];
    sqlite3_stmt * insert;
    const char * text2=[selectSql UTF8String];
    int prepare = sqlite3_prepare_v2(_database,text2, -1, &insert, NULL);
    if (prepare== SQLITE_OK) {
        while (sqlite3_step(insert) == SQLITE_ROW) {
            uniqueIdAdd = sqlite3_column_int(insert, 0);
            
        }
    }
    sqlite3_finalize(insert);
    
    return uniqueIdAdd;
    
}

//SessionExistInMySchedule

-(int)SessionExistInMySchedule:(NSString *)attendeeid Session:(NSString *)sessionid
{
    
    int uniqueIdAdd=0;
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT attendee_session_id FROM attendee_session where attendee_id=\'%@\' and session_id=\'%@\'",attendeeid,sessionid];
    
    
    sqlite3_stmt * select;
    const char * text2=[selectSql UTF8String];
    int prepare = sqlite3_prepare_v2(_database,text2, -1, &select, NULL);
    if (prepare== SQLITE_OK) {
        while (sqlite3_step(select) == SQLITE_ROW) {
            uniqueIdAdd = sqlite3_column_int(select, 0);
            
        }
    }
    sqlite3_finalize(select);
    
    if (uniqueIdAdd==0) {
        return 0;
    }
    else
    {
        return 1;
    }
    
}



//Update SessioneDataSessionId

- (void)UpdateSessioneDataSessionId:(NSString *)SessionId updateEndtime:(NSString *)SessionEndtime updateIsvalue:(NSString *)SessionIsvaue{
    
    // Setup the SQL Statement and compile it for faster access
    const char *sqlStatement = [[NSString stringWithFormat:@"UPDATE session Set session_end_time =?,isAdded =? where session_id ='%@'",SessionId] UTF8String];
    sqlite3_stmt *compiledStatement;
    
    int prepare_result = sqlite3_prepare_v2(_database, sqlStatement, -1, &compiledStatement, NULL);
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK)) {
        // Error
        sqlite3_close(_database);
        return;
    }
    sqlite3_bind_text(compiledStatement, 1, [SessionEndtime UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(compiledStatement, 2, [SessionIsvaue UTF8String], -1, SQLITE_TRANSIENT);
    
    
    int statement_result = sqlite3_step(compiledStatement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK)) {
        //Error
        sqlite3_close(_database);
        return;
    }
    sqlite3_finalize(compiledStatement);
}





- (int)insertHotelBannerData:(NSString*)strhotel_id HotelBanner1:(NSString*)HotelBanner1 HotelBanner2:(NSString*)HotelBanner2 HotelBanner3:(NSString*)HotelBanner3
{
    
    int statement_result;
    const char * text2 = "INSERT INTO HotelBanner (Hotel_id,H_Banner1,H_Banner2,H_Banner3) VALUES (?,?,?,?)";
    
    sqlite3_stmt * insert_statement;
    int prepare_result = sqlite3_prepare_v2(_database, text2, -1, &insert_statement, NULL);
    
    
    
    if ((prepare_result != SQLITE_DONE) && (prepare_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        return 0;
    }
    
    sqlite3_bind_text(insert_statement,1,[strhotel_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,2,[HotelBanner1 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,3,[HotelBanner2 UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement,4,[HotelBanner3 UTF8String], -1, SQLITE_TRANSIENT);
    
    statement_result = sqlite3_step(insert_statement);
    if ((statement_result != SQLITE_DONE) && (statement_result != SQLITE_OK))
    {
        sqlite3_close(_database);
        
    }
    sqlite3_finalize(insert_statement);
    
    return 1;
}

//Get EventDataById
-(NSMutableArray *)getHotelBannerDataById:(NSString*)Hotel_id
{
    NSMutableArray *arrReturn= [[NSMutableArray alloc]init];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM HotelBanner WHERE Hotel_id='%@'",Hotel_id];
    
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil)== SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            //featch values from tbl columns
            char *hotelid=(char *) sqlite3_column_text(statement, 0);
            char *h_banner1=(char *) sqlite3_column_text(statement, 1);
            char *h_banner2=(char *) sqlite3_column_text(statement,2);
            char *h_banner3=(char *) sqlite3_column_text(statement,3);
            
            
            //creating refrence strings
            NSString* strHotel_id;
            NSString* strHbanner1;
            NSString* strHbanner2;
            NSString* strHbanner3;
            
            
            //test all columns value nil or not
            
            if(hotelid!=nil)
                strHotel_id=[[NSString alloc] initWithUTF8String:hotelid];
            else
                strHotel_id=[[NSString alloc] initWithString:@" "];
            
            if(h_banner1!=nil)
                strHbanner1=[[NSString alloc] initWithUTF8String:h_banner1];
            else
                strHbanner1=[[NSString alloc] initWithString:@" "];
            
            if(h_banner2!=nil)
                strHbanner2=[[NSString alloc] initWithUTF8String:h_banner2];
            else
                strHbanner2=[[NSString alloc] initWithString:@" "];
            
            if(h_banner3!=nil)
                strHbanner3=[[NSString alloc] initWithUTF8String:h_banner3];
            else
                strHbanner3=[[NSString alloc]  initWithString:@" "];
            
            
            //set values in the Dictonary
            //            [eventInfo setValue:strHotel_id forKey:@"Hote_id"];
            //            [eventInfo setValue:strHbanner1 forKey:@"Baner_1"];
            //            [eventInfo setObject:strHbanner2 forKey:@"Baner_2"];
            //            [eventInfo setValue:strHbanner3 forKey:@"Baner_3"];
            
            
            // [arrReturn addObject:strHotel_id];
            [arrReturn addObject:strHbanner1];
            [arrReturn addObject:strHbanner2];
            [arrReturn addObject:strHbanner3];
            
            //Releasing all string
            [strHotel_id release];
            [strHbanner1 release];
            [strHbanner2 release];
            [strHbanner3 release];
            
            
        }
        
    }
    sqlite3_finalize(statement);
    
    return arrReturn;
}


*/


@end






