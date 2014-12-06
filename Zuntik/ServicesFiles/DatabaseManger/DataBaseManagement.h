
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AppDelegate.h"
@interface DataBaseManagement : NSObject<UIApplicationDelegate>
{
    AppDelegate *appobject;
    sqlite3 *_database;
    NSString *sqLiteDb;
    
}
@property(nonatomic,retain) NSMutableArray *returnArr;
+(DataBaseManagement*)Connetion;


-(BOOL)getUserLoginID:(NSString *)strloginId Password:(NSString *)strPassword;
#pragma mark -ADD VALUE on database
- (void)addUserInfo:(NSMutableDictionary *)dictContentData;
- (void)addUsersubscriptions:(NSMutableDictionary *)dictContentData;
- (void)addUsernewEvents:(NSMutableDictionary *)dictContentData;
- (void)addUsercreatedCals:(NSMutableDictionary *)dictContentData;
- (void)addHelpList:(NSMutableDictionary *)dictContentData;


#pragma mark-  get Value on Database
-(NSMutableDictionary *)getSubscriptionsData:(NSString *)strUserid;
//Get All QuestionAnsewer Data
-(NSMutableDictionary *)QuestionAnsewerList;
-(NSMutableDictionary *)eventInfoList:(NSString *)strUserid;
-(NSMutableDictionary *)getCreatedData:(NSString *)strUserid;
-(NSMutableDictionary *)getUserInfo:(NSString *)strUserid;


-(NSMutableDictionary *)eventInfoList_Calendar:(NSString *)strCal_Key;

#pragma mark-  deleteAllRecoredFromTbl on Database
-(void)deleteAllRecoredFromTbl:(NSString *)tblName;

#pragma mark- Check Value Yes or No
-(BOOL)getSubscriptionsDataCheck:(NSString *)strCal_Key userId:(NSString *)userId;
-(BOOL)getUsercreatedCalsData:(NSString *)strCal_Key userId:(NSString *)userId;
-(BOOL)UserInfo:(NSString *)strUserid;
-(BOOL)EventCalendar:(NSString *)strEvent_Key;

#pragma mark-  Delete data userid
-(void)deleteSubscriptionsData_Userid_id:(NSString *)userid;
-(void)deletecreatedCalsData_Userid_id:(NSString *)userid;
-(void)deleteEventsCalsData_Userid_id:(NSString *)userid;
-(void)deleteEventsCalsData_Userid_idAndstrEventKey:(NSString *)userid EventKey:(NSString *)strEventKey;

-(void)deleteEventsCalsData_Cal_id:(NSString *)strCalId;
-(void)deleteUserInfoData_id:(NSString *)struserId;
/*


//EventData
- (int)insertEventData:(NSString*)strEventId eventTitle:(NSString*)EventTitle eventManagerId:(NSString*)strEventManagerId description:(NSString*)strDescription startDate:(NSString*)strStartDate startTime:(NSString*)strStartTime finishDate:(NSString*)strFinishDate finishTime:(NSString*)strFinishTime city:(NSString*)strCity country:(NSString*)strCountry eventLogo:(NSString*)strEventLogo location:(NSString*)strLocation wifi:(NSString*)strWifi wifiPassword:(NSString*)strWifiPassword;
-(NSMutableDictionary *)getEventDataById:(NSString*)eventid;

//HotelData

- (int)insertHotelData:(NSString*)strHotelId hotelName:(NSString*)strHotelName description:(NSString*)strDescription address:(NSString*)strAddress telephone:(NSString*)strTelephone website:(NSString*)strWebsite hotelLogo:(NSString*)strHotelLogo eventId:(NSString*)strEventId phone_number:(NSString*)strphonenumber facebook:(NSString*)facebook twitter:(NSString*)twitter;
-(NSMutableDictionary *)getHotelDataByHotelId:(NSString*)hotelid;
-(NSMutableArray *)getAllHotelDataByEventId:(NSString*)eventid;


//SpeakerData

- (int)insertSpeakerData:(NSString*)speaker_id speaker_name:(NSString*)speaker_name job_title:(NSString*)job_title company_name:(NSString*)company_name bio:(NSString*)bio email:(NSString*)email facebook_account:(NSString*)facebook_account twitter_account:(NSString*)twitter_account  photo:(NSString*)photo event_id:(NSString*)event_id;
-(NSMutableArray *)getSpeakerSessionbyspeakerId:(NSString*)speakerid;
-(NSMutableArray *)getAllSpeakerDataByEventId:(NSString*)eventid;
-(NSMutableDictionary *)getSpeakerDataBySpeakerId:(NSString*)speakerid;


//Exhibitordata

-(int)insertExhibitorData:(NSString*)strExhibitorId company_name:(NSString*)company_name description:(NSString*)description category:(NSString*)category website:(NSString*)website featured_exhibitor:(NSString*)featured_exhibitor company_logo:(NSString*)company_logo max_booth_number:(NSString*)max_booth_number sponsor_exhibitors:(NSString*)sponsor_exhibitors sponsorship_category_id:(NSString*)sponsorship_category_id email_address:(NSString*)email_address password:(NSString*)password paid:(NSString*)paid event_id:(NSString*)event_id rep_name:(NSString*)rep_name rep_mobile:(NSString*)rep_mobile rep_email:(NSString*)rep_email address:(NSString*)address phone_number:(NSString*)phone_number facebook_id:(NSString*)facebook_id twitter_id:(NSString*)twitter_id;
- (int)insertExhibitorProductData:(NSString*)strEproduct_Id ProductName:(NSString*)strEProduct_Name description:(NSString*)strEDescription Exhibitor_Id:(NSString*)strExhibitor_Id Photo:(NSString*)strPhoto;
-(NSMutableArray *)getAllExhibitorsDataByEventId:(NSString*)eventid;
-(NSMutableDictionary *)getExhibitorsDataByExhibitorId:(NSString*)Exhibitorid;
-(NSMutableArray *)getExibitorProductDataById:(NSString*)strExhibitorId;


//AttendeeData

- (int)insertAttendeeData:(NSString*)strAttendeeId attendeeFirstName:(NSString*)strFirstname attendeeLastName:(NSString*)strLast_name Email:(NSString*)strEmailId Mobilenumber:(NSString*)strMobilenumber Jobtitle:(NSString*)strJobTitle Companyname:(NSString*)strCompanyname Photo:(NSString*)strPhoto Event_id:(NSString*)strEventId QrCode:(NSString*)strQrCode Jender:(NSString*)strGender bagdeId:(NSString*)strbadgeId;
- (int)insertINTOattendee_session:(NSString*)strattendee_session_id Attendee_id:(NSString*)strattendee_id Session_id:
(NSString*)strsession_id Alert_session_time:(NSString*)stralert_session_time;
-(NSMutableDictionary *)getAttendeeDataByMobileno:(NSString*)Mobileno;
-(void)deleteAttendee_sessionBy_session_id:(int)strSession_id;


//NotificationData:

- (int)insertNotificationData:(NSString*)strNotificationId notificationTitle:(NSString*)NotificationTitle notificationMessage:(NSString*)message event_id:(NSString*)event_id send_date:(NSString*)send_date AttandeeId:(NSString*)strAttandeeId;

//- (int)insertNotificationData:(NSString*)strNotificationId notificationTitle:(NSString*)NotificationTitle notificationMessage:(NSString*)message event_id:(NSString*)event_id send_date:(NSString*)send_date AttandeeId:(NSString*)strAttandeeId ReadDeatil:(NSString *)strReadData;
-(NSMutableArray *)getAllMessageDataByAttendee_id:(NSString*)strAttendee_id;
- (void)UpdateNotificationData:(NSString *)strMAttenddeId NotificationId:(NSString *)strMNotificationId;


//SponsorshipCategoryData

- (int)inserSponsorshipCategoryData:(NSString*)strScategoryId SponsorshipCategory:(NSString*)strSCategory SCategory_Descreption:(NSString*)strSCategory_Descreption strcompany_name:(NSString*)company_name strSponsorship_exhibitors:(NSString*)sponsorship_exhibitors;
- (int)insertSponsor:(NSString*)strSponsor_categary Logo:(NSString*)strSponsor_Logo;
-(NSMutableDictionary *)getSponserLogoBySponserId:(NSString*)sponsorship_category_id;
-(NSMutableArray *)getAllSponsorshipCategory;


//AdvertisementData

- (int)insertAdvertisementData:(NSString*)strAds_id Ads_Title:(NSString*)strAdsTitle description:(NSString*)strADescription Exhibitor_Id:(NSString*)strExhibitor_Id Photo1:(NSString*)strPhoto1 Photo2:(NSString*)strPhoto2 Photo3:(NSString*)strPhoto3 Photo4:(NSString*)strPhoto4 Photo5:(NSString*)strPhoto5;
-(NSMutableArray *)getAdvertisement;



//SessionData

- (int)insertSessionData:(NSString*)strSessionId sessionTitle:(NSString*)strSessionTitle description:(NSString*)strDescription room:(NSString*)strRoom sessionStartDate:(NSString*)strSessionStartDate sessionStartTime:(NSString*)strSessionStartTime sessionEndTime:(NSString*)strSessionEndTime sessionFinishDate:(NSString*)strSessionFinishDate  eventId:(NSString*)strEventId color:(NSString*)strHxColur;
- (int)insertSpeakerSession:(NSString*)strspeaker_session_id speaker_id:(NSString*)strspeaker_id session_id:(NSString*)strsession_id;
-(NSMutableDictionary *)getAllSessionDate:(NSString*)eventid;
-(NSMutableDictionary *)getSessionDataByDate:(NSString*)date;// .m & .h
-(NSMutableDictionary *)getSessionDateBysection:(NSString*)date timeFormate:(NSString*)strtimeFormate timeInterval1:(NSString*)strTimeInterval1 timeInterval2:(NSString*)strTimeInterval2;
-(NSMutableArray *)getSessionIDForSessionInfoBy:(NSString*)Sessionid;
-(NSMutableArray *)getAllSessionDataByEventId:(NSString*)eventid;// .m & .h
-(NSMutableArray *)getAllmyscheduleDataByAttendeeId:(NSString*)attendeeId;/////Use My Schedule
- (int)SelectMAX_Attendee_session_ID;
-(int)SessionExistInMySchedule:(NSString *)attendeeid Session:(NSString *)sessionid;
- (void)UpdateSessioneDataSessionId:(NSString *)SessionId updateEndtime:(NSString *)SessionEndtime updateIsvalue:(NSString *)SessionIsvaue;


//deleteAllRecoredFromTbl

-(void)deleteAllRecoredFromTbl:(NSString *)tblName;


- (int)insertHotelBannerData:(NSString*)strhotel_id HotelBanner1:(NSString*)HotelBanner1 HotelBanner2:(NSString*)HotelBanner2 HotelBanner3:(NSString*)HotelBanner3;
-(NSMutableArray *)getHotelBannerDataById:(NSString*)Hotel_id;
 */
@end





