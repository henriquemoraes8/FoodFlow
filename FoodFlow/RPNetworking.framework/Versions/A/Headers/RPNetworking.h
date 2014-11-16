//
//  RPNetworking.h
//
//  Created by Rodrigo Prestes Andrade on 7/3/14.
//  Copyright (c) 2014 RodPrestes All rights reserved.
//
//  www.rodrigoprestes.com
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef NS_ENUM (NSInteger, RPNetworkStatus)
{
	statusNoConnection = 0,
	statusWiFi,
	statusWWAN
};

typedef NS_ENUM (NSInteger, RPNetworkInstanceType)
{
    RPNetworkingTypeRequest,
    RPNetworkingTypeStatus
};

typedef NS_ENUM (NSInteger, RPHTTPMethod)
{
    httpMethodPOST = 0,
    httpMethodGET = 1,
    httpMethodOPTIONS = 2,
    httpMethodHEAD = 3,
    httpMethodPUT = 4,
    httpMethodDELETE = 5,
    httpMethodTRACE = 6,
    httpMethodCONNECT = 7,
    httpMethodPATCH = 8
};

@protocol RPNetworkingRequestDelegate <NSObject>

@optional

- (void)requestDidUpdatedUploadProgress:(float)percentage identifier:(NSString *)identifier;
- (void)requestDidUpdatedDownloadProgress:(float)percentage identifier:(NSString *)identifier;
- (void)requestDidFinishedRequest:(NSDictionary *)response identifier:(NSString *)identifier;
- (void)requestDidFailedRequest:(NSError *)error identifier:(NSString *)identifier;

@end

@protocol RPNetworkingStatusDelegate <NSObject>

@optional
- (void)networkStatusDidChange:(RPNetworkStatus)status;

@end

@interface RPNetworking : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

+ (RPNetworking *)requestFromURL:(NSString *)url
              withAuthentication:(NSDictionary *)auth
                      parameters:(NSDictionary *)param
                      identifier:(NSString *)ident
                          legacy:(BOOL)leg
                     andDelegate:(id<RPNetworkingRequestDelegate>)del;

+ (RPNetworking *)requestFromURL:(NSString *)url
              withAuthentication:(NSDictionary *)auth
                      parameters:(NSDictionary *)param
                      identifier:(NSString *)ident
                      httpMethod:(RPHTTPMethod)method
                          legacy:(BOOL)leg
                     andDelegate:(id<RPNetworkingRequestDelegate>)del;

+ (RPNetworking *)requestFromURL:(NSString *)url
              withAuthentication:(NSDictionary *)auth
                      parameters:(NSDictionary *)param
                      httpMethod:(RPHTTPMethod)method
                          legacy:(BOOL)leg
                         success:(void (^)(id response))successBlock
                            fail:(void (^)(NSError *error))failBlock;

+ (RPNetworking *)requestFromURL:(NSString *)url
              withAuthentication:(NSDictionary *)auth
                      parameters:(NSDictionary *)param
                      httpMethod:(RPHTTPMethod)method
                          legacy:(BOOL)leg
                         success:(void (^)(id response))successBlock
                            fail:(void (^)(NSError *error))failBlock
                        download:(void (^)(float percentage))downloadBlock
                          upload:(void (^)(float percentage))uploadBlock;

- (RPNetworkInstanceType)type;

- (void)returnRaw;
- (void)notExpectJsonResponse;

- (NSString *)identifier;
- (void)cancelConnection;

+ (NSArray *)openConnections;

+ (void)cancelAllRequestConnections;
+ (void)cancelAllConnections;
+ (void)cancelConnectionWithIdentifier:(NSString *)ident;

+ (BOOL)hasNetworkConnection;

+ (RPNetworking *)startNetworkStatusNotifierWithDelegate:(id<RPNetworkingStatusDelegate>)del;
+ (void)stopNetworkStatusNotifier;

- (void)triggerNetworkStatus;
- (void)setStatusDelegate:(id<RPNetworkingStatusDelegate>)del;

+ (NSDictionary *)parametersWithKeys:(NSArray *)keys andValues:(NSArray *)vals;

@end
