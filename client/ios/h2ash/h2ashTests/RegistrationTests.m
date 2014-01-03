//
//  RegistrationTests.m
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/28.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TestConstants.h"
#import "TestUtils.h"

#import "ServiceInterface.h"
#import "TestServiceInterface.h"

@interface RegistrationTests : XCTestCase

@end

@implementation RegistrationTests

- (void)setUp
{
    [super setUp];
    
    BOOL setUpSuccess = [TestUtils setUp];
    XCTAssert(setUpSuccess, @"Setup did not complete successfully");
}

- (void)tearDown
{
    BOOL tearDownSuccess = [TestUtils tearDown];
    XCTAssert(tearDownSuccess, @"Teardown did not complete successfully");
    
    [super tearDown];
}

// The registration workflow:
// 1) register with email and password - This will send the registration token by email to the user
// 2) browse to the link /register/:rgistrationtoken this will activet the account
// 3) user should now be able to log in
//

- (void) test_valid_registration
{
    [TestUtils runAndWaitForTest:^(BOOL *done){
        ServiceInterface *service = [ServiceInterface constructService:TEST_URL];
        TestServiceInterface *testService = [TestServiceInterface constructService:TEST_URL];
        
        [service registerWithEmail:TEST_USER_A_EMAIL andPassword:TEST_USER_A_PASSWORD andContinueWith:^(){
            XCTAssert(service.authState.auth_email == nil, @"The user has not logged in yet");
            XCTAssert(service.authState.auth_token == nil, @"The user has not logged in and thus should not have a token");
            
            [testService validateToken:service.authState.auth_token andContinueWith:^(){

                [service loginWithEmail:TEST_USER_A_EMAIL andPassword:TEST_USER_A_PASSWORD andContinueWith:^(){
                    XCTAssertEqual(service.authState.auth_email, TEST_USER_A_EMAIL, @"");
                    XCTAssert(service.authState.auth_token != nil, @"");
                    *done = YES;
                } onError:^(CallStatus *callStatus){
                    XCTAssert(false, @"This spot should not be reached");
                    *done = YES;
                }];

            } onError:^(CallStatus *callStatus){
                XCTAssert(false, @"This spot should not be reached");
                *done = YES;
            }];
            
        } onError:^(CallStatus *callStatus){
            XCTAssert(false, @"This spot should not be reached");
            *done = YES;
        }];
    }];
}

// The rules for duplicate emails are
// 1) If you register with an amil that already exist AND is validated the an error is returned
// 2) If the email exists and is NOT validated then generate a new registration token and send the email
//

-(void) test_duplicate_unvalidated_email_registration
{
    [TestUtils runAndWaitForTest:^(BOOL *done){
        ServiceInterface *service = [ServiceInterface constructService:TEST_URL];
        
        [service registerWithEmail:TEST_USER_A_EMAIL andPassword:TEST_USER_A_PASSWORD andContinueWith:^(){
            XCTAssert(service.authState.auth_email == nil, @"The user has not logged in yet");
            XCTAssert(service.authState.auth_token == nil, @"The user has not logged in an d thus should not have a token");

            [service registerWithEmail:TEST_USER_A_EMAIL andPassword:TEST_USER_A_PASSWORD andContinueWith:^(){
                XCTAssert(service.authState.auth_email == nil, @"The user has not logged in yet");
                XCTAssert(service.authState.auth_token == nil, @"The user has not logged in an d thus should not have a token");
                
                *done = YES;
            } onError:^(CallStatus *callStatus){
                XCTAssert(false, @"This spot should not be reached");
                *done = YES;
            }];

        } onError:^(CallStatus *callStatus){
            XCTAssert(false, @"This spot should not be reached");
            *done = YES;
        }];
    }];
}

-(void) test_duplicate_validated_email_registration
{
    [TestUtils runAndWaitForTest:^(BOOL *done){
        ServiceInterface *service = [ServiceInterface constructService:TEST_URL];
        TestServiceInterface *testService = [TestServiceInterface constructService:TEST_URL];

        
        // 1) Register the user
        //
        [service registerWithEmail:TEST_USER_A_EMAIL andPassword:TEST_USER_A_PASSWORD andContinueWith:^(){
            XCTAssert(service.authState.auth_email == nil, @"The user has not logged in yet");
            XCTAssert(service.authState.auth_token == nil, @"The user has not logged in an d thus should not have a token");
            
            // 2) Validate the user using the test service
            //
            [testService validateToken:service.authState.auth_token andContinueWith:^(){
                
                // 3) Then try and register the user again
                //
                [service registerWithEmail:TEST_USER_A_EMAIL andPassword:TEST_USER_A_PASSWORD andContinueWith:^(){
                    XCTAssert(false, @"This spot should not be reached");
                    *done = YES;
                } onError:^(CallStatus *callStatus){
                    XCTAssert(callStatus.code == CS_DUPLICATE_USER , @"");
                    *done = YES;
                }];
                
            } onError:^(CallStatus *callStatus){
                XCTAssert(false, @"This spot should not be reached");
                *done = YES;
            }];
            
        } onError:^(CallStatus *callStatus){
            XCTAssert(false, @"This spot should not be reached");
            *done = YES;
        }];
    }];
}


-(void) test_unvalidated_login_after_registration
{
    [TestUtils runAndWaitForTest:^(BOOL *done){
        ServiceInterface *service = [ServiceInterface constructService:TEST_URL];
        
        // 1) Register the user
        //
        [service registerWithEmail:TEST_USER_A_EMAIL andPassword:TEST_USER_A_PASSWORD andContinueWith:^(){
            XCTAssert(service.authState.auth_email == nil, @"The user has not logged in yet");
            XCTAssert(service.authState.auth_token == nil, @"The user has not logged in an d thus should not have a token");
            
                // 2) Logion with unvalidated credentials
                //
                [service loginWithEmail:TEST_USER_A_EMAIL andPassword:TEST_USER_A_PASSWORD andContinueWith:^(){
                    XCTAssert(false, @"This spot should not be reached");
                    *done = YES;
                } onError:^(CallStatus *callStatus){
                    XCTAssert(callStatus.code == CS_USER_NOT_VALIDATED , @"");
                    *done = YES;
                }];

        } onError:^(CallStatus *callStatus){
            XCTAssert(false, @"This spot should not be reached");
            *done = YES;
        }];
    }];

}




@end
