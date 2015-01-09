//
//  DVSLogInViewSpec.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

SPEC_BEGIN(DVSLogInViewSpec)

describe(@"log in screen", ^{
    
    beforeEach(^{
        [tester dvs_moveToLogIn];
    });
    
    afterEach(^{
        [tester dvs_moveBackToWelcome];
    });
    
    describe(@"error message", ^{
        
        __block id<OHHTTPStubsDescriptor> stub = nil;
        
        beforeAll(^{
            stub = [OHHTTPStubs dvs_stubUserLogInRequestsWithOptions:nil];
        });
        
        afterAll(^{
            [OHHTTPStubs removeStub:stub];
        });
        
        describe(@"for e-mail field", ^{
            
            beforeEach(^{
                [tester dvs_enterValidPassword];
                [tester dvs_closeSoftwareKeyboard];
            });
            
            context(@"should be shown", ^{
                
                afterEach(^{
                    [tester dvs_closeErrorPopup];
                });
                
                it(@"when empty", ^{
                    [tester dvs_tapConfirmLoginButton];
                    [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
                });
                
                it(@"when has wrong syntax", ^{
                    [tester enterText:@"john.appleseed.example.com" intoViewWithAccessibilityLabel:DVSAccessibilityLabel(DVSAccessibilityLabelEmailTextField)];
                    [tester dvs_tapConfirmLoginButton];
                    [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
                });
                
            });
            
            context(@"should not be shown", ^{
                
                afterEach(^{
                    [tester dvs_tapLogOutButton];
                });
                
                it(@"should not be shown when valid", ^{
                    [tester dvs_enterValidEmail];
                    [tester dvs_tapConfirmLoginButton];
                    [tester waitForAbsenceOfViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
                });
            });
            
        });
        
        describe(@"for password field", ^{
           
            beforeEach(^{
                [tester dvs_enterValidEmail];
                [tester dvs_closeSoftwareKeyboard];
            });
            
            context(@"should be shown", ^{
                
                afterEach(^{
                    [tester dvs_closeErrorPopup];
                });
                
                it(@"when empty", ^{
                    [tester dvs_tapConfirmLoginButton];
                    [tester waitForViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
                });
            });
            
            context(@"should not be shown", ^{
                
                afterEach(^{
                    [tester dvs_tapLogOutButton];
                });
                
                it(@"when valid", ^{
                    [tester dvs_enterValidPassword];
                    [tester dvs_tapConfirmLoginButton];
                    [tester waitForAbsenceOfViewWithAccessibilityLabel:DVSAccessibilityLabel(@"Error")];
                });
            });
        });
    });
    
});

SPEC_END