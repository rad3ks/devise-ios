//
//  DVSHTTPReqeustOperationManager.m
//  Devise
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "DVSHTTPReqeustOperationManager.h"
#import "DVSConfiguration.h"
#import "DVSMacros.h"
#import "NSError+Devise.h"

inline static NSUInteger operationsCode(AFHTTPRequestOperation *operation) {
    return operation.response.statusCode;
}

@implementation DVSHTTPReqeustOperationManager

+ (instancetype)sharedInstance {
    static DVSHTTPReqeustOperationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        DVSWorkInProgress("Configuration needed");
        
        DVSHTTPReqeustOperationManager *manager = [DVSHTTPReqeustOperationManager manager];
    
        //request serializer:
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager setRequestSerializer:requestSerializer];

        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        [manager setResponseSerializer:responseSerializer];
        
        sharedInstance = manager;
    });
    return sharedInstance;
}

- (void)requestWithPOST:(NSDictionary *)parameters path:(NSString *)path success:(DVSResponseBlock)success failure:(DVSErrorBlock)failure {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self POST:[self urlWithPath:path query:nil] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success(responseObject, operationsCode(operation));
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (operation.responseObject) {
            error = [NSError dvs_errorWithErrorResponse:operation.responseObject];
        }
        failure(error);
    }];
}

- (void)requestWithGET:(NSString *)query path:(NSString *)path success:(DVSResponseBlock)success failure:(DVSErrorBlock)failure {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self GET:[self urlWithPath:path query:query] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success(responseObject, operationsCode(operation));
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (operation.responseObject) {
            error = [NSError dvs_errorWithErrorResponse:operation.responseObject];
        }
        failure(error);
    }];
}

- (void)setAuthorizationToken:(NSString *)token {
    [self.requestSerializer setValue:token forHTTPHeaderField:@"X-Authentication-Token"];
}

#pragma Private Methods

- (NSString *)urlWithPath:(NSString *)path query:(NSString *)query {
    
    BOOL hasInvalidSyntax = (query && !path);
    NSAssert2(!hasInvalidSyntax, @"Query (%@) cannot exists without specified path(%@)", query, path);
    NSAssert([DVSConfiguration sharedConfiguration].serverURL, @"Server URL path missing. Use DVSCongiuration class to configure connection.");
    
    NSMutableString *url = [[DVSConfiguration sharedConfiguration].serverURL.absoluteString mutableCopy];
    if (path) {
        [url appendFormat:@"/%@", path];
    }
    if (query) {
        [url appendFormat:@"?%@", query];
    }
    return [url copy]; //make it immutable
}

@end