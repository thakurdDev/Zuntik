//
//  ZuntikServicesVC.m
//  Zuntik
//
//  Created by Dev-Mac on 05/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import "ZuntikServicesVC.h"
#import "JSON.h"

@implementation ZuntikServicesVC
//("APIAccount", "ZuntikAppAPIUser")
//("APIPassword","n4kfoqjgfxjsmujelznss7il6n9d9w4nrfs5w2b1")
//server URL
#define serviceURL @"http://www.zuntik.com/API/V1/"
#define BASEURL @"http://www.zuntik.com/"

//#define serviceURL @"http://lampdemos.com/ontoday/"
//#define BASEURL @"http://lampdemos.com/"


//local URL
//#define serviceURL @"http://192.168.88.97/ontoday/"
//#define BASEURL @"http://192.168.88.97/"



+(void)PostMethodWithApiMethod:(NSString *)Strurl Withparms:(NSDictionary *)params WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    NSString *path= [@"" stringByAppendingFormat:@"%@%@",serviceURL,Strurl];
    AFHTTPClient *httpclient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
    [httpclient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpclient requestWithMethod:@"POST" path:path parameters:params];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpclient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *strResponse = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         success (strResponse);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         failure(error);
     }];
    [operation start];
}

// Class method for call service For (GetType)
+(void)GetMethodWithApiMethod:(NSString *)Strurl WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    NSString *strPath = [@"" stringByAppendingFormat: @"%@%@",serviceURL ,Strurl];
    AFHTTPClient * httpClient = [[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:BASEURL]];
    [httpClient setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:strPath parameters:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *strResponse = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        success (strResponse);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [operation start];
}

@end
