//
//  ZuntikServicesVC.h
//  Zuntik
//
//  Created by Dev-Mac on 05/07/14.
//  Copyright (c) 2014 Yogendra-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface ZuntikServicesVC : NSObject

+(void)PostMethodWithApiMethod:(NSString *)Strurl Withparms:(NSDictionary *)params WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

+(void)GetMethodWithApiMethod:(NSString *)Strurl WithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
@end
