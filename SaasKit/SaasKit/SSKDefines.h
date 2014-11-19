//
//  SSKDefines.h
//  SaasKit
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

@class SSKUser;

#ifndef SaasKit_SSKDefines_h
#define SaasKit_SSKDefines_h

    #ifdef __OBJC__

    #define SSKErrorDomain @"com.netguru.saaskit.error.domain"

    typedef void (^SSKUserSuccessBlock)(SSKUser *user);
    typedef void (^SSKFailureBlock)(NSError *error);

    #endif

#endif