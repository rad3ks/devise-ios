//
//  SSKUser.m
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "SSKUser.h"
#import "SSKAPIManager.h"
#import "SSKUser+Validation.h"

@implementation SSKUser

- (instancetype)init {
    self = [super init];
    if (self) {
        self.loginMethod = SSKLoginUsingEmail;
    }
    return self;
}

- (instancetype)user {
    return [[[self class] alloc] init];
}

- (void)loginWithSuccessBlock:(SSKUserSuccessBlock)success failureBlock:(SSKFailureBlock)failure {
    
    NSError *error;
    if ([self validateWithError:&error]) {
        failure(error);
        return;
    }
    
    [SSKAPIManager loginUser:self withSuccess:success failure:failure];
}

@end