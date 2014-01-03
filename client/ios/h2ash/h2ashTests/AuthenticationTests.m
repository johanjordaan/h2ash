//
//  AuthenticationTests.m
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/27.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TestConstants.h"
#import "TestUtils.h"

#import "ServiceInterface.h"

@interface AuthenticationTests : XCTestCase

@end

@implementation AuthenticationTests

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

- (void)test_valid_login
{
    [TestUtils runAndWaitForTest:^(BOOL *done){
        ServiceInterface *service = [ServiceInterface constructService:TEST_URL];
        
        [service loginWithEmail:TEST_ADMIN_EMAIL andPassword:TEST_ADMIN_PASSWORD andContinueWith:^(){
            XCTAssertEqual(service.authState.auth_email, TEST_ADMIN_EMAIL, @"");
            XCTAssert(service.authState.auth_token != nil, @"");
            *done = YES;
        } onError:^(CallStatus *callStatus){
            XCTAssert(false, @"This spot should not be reached");
            *done = YES;
        }];
    }];
}

- (void)test_invalid_email_login
{
    [TestUtils runAndWaitForTest:^(BOOL *done){
        ServiceInterface *service = [ServiceInterface constructService:TEST_URL];
        
        [service loginWithEmail:@"someemail@there.com" andPassword:TEST_ADMIN_PASSWORD andContinueWith:^(){
            XCTAssert(false, @"This spot should not be reached");
            *done = YES;
        } onError:^(CallStatus *callStatus){
            XCTAssert(callStatus.code == CS_INVALID_CREDENTIALS , @"");
            *done = YES;
        }];
    }];
}

- (void)test_invalid_password_login
{
    [TestUtils runAndWaitForTest:^(BOOL *done){
        ServiceInterface *service = [ServiceInterface constructService:TEST_URL];
        
        [service loginWithEmail:TEST_ADMIN_EMAIL andPassword:@"invalidpassword" andContinueWith:^(){
            XCTAssert(false, @"This spot should not be reached");
            *done = YES;
        } onError:^(CallStatus *callStatus){
            XCTAssert(callStatus.code == CS_INVALID_CREDENTIALS , @"");
            *done = YES;
        }];
    }];
}

- (void)test_valid_logout
{
    [TestUtils runAndWaitForTest:^(BOOL *done){
        ServiceInterface *service = [ServiceInterface constructService:TEST_URL];
        
        [service loginWithEmail:TEST_ADMIN_EMAIL andPassword:TEST_ADMIN_PASSWORD andContinueWith:^(){
            XCTAssertEqual(service.authState.auth_email, TEST_ADMIN_EMAIL, @"");
            XCTAssert(service.authState.auth_token != nil, @"");
            
            [service logoutAndContinueWith:^(){
                XCTAssert(service.authState.auth_email == nil, @"");
                XCTAssert(service.authState.auth_token == nil, @"");
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

- (void)test_unauthed_logout
{
    [TestUtils runAndWaitForTest:^(BOOL *done){
        ServiceInterface *service = [ServiceInterface constructService:TEST_URL];
        
            [service logoutAndContinueWith:^(){
                XCTAssert(false, @"This spot should not be reached");
                *done = YES;
            } onError:^(CallStatus *callStatus){
                XCTAssert(callStatus.code == CS_NOT_AUTHED , @"");
                XCTAssert(service.authState.auth_email == nil, @"");
                XCTAssert(service.authState.auth_token == nil, @"");
                *done = YES;
            }];
        
    }];
}

- (void)test_invalid_token_logout
{
    [TestUtils runAndWaitForTest:^(BOOL *done){
        ServiceInterface *service = [ServiceInterface constructService:TEST_URL];
        
        [service loginWithEmail:TEST_ADMIN_EMAIL andPassword:TEST_ADMIN_PASSWORD andContinueWith:^(){
            XCTAssertEqual(service.authState.auth_email, TEST_ADMIN_EMAIL, @"");
            XCTAssert(service.authState.auth_token != nil, @"");
            
            service.authState.auth_token = @"ThisIsAnInvalidToken";
            
            [service logoutAndContinueWith:^(){
                XCTAssert(false, @"This spot should not be reached");
                *done = YES;
            } onError:^(CallStatus *callStatus){
                XCTAssert(callStatus.code == CS_NOT_AUTHED , @"");
                XCTAssert(service.authState.auth_email == nil, @"");
                XCTAssert(service.authState.auth_token == nil, @"");
                *done = YES;
            }];
        } onError:^(CallStatus *callStatus){
            XCTAssert(false, @"This spot should not be reached");
            *done = YES;
        }];
    }];
}

- (void)test_empty_token_logout
{
    [TestUtils runAndWaitForTest:^(BOOL *done){
        ServiceInterface *service = [ServiceInterface constructService:TEST_URL];
        
        [service loginWithEmail:TEST_ADMIN_EMAIL andPassword:TEST_ADMIN_PASSWORD andContinueWith:^(){
            XCTAssertEqual(service.authState.auth_email, TEST_ADMIN_EMAIL, @"");
            XCTAssert(service.authState.auth_token != nil, @"");
            
            service.authState.auth_token = @"";
            
            [service logoutAndContinueWith:^(){
                XCTAssert(false, @"This spot should not be reached");
                *done = YES;
            } onError:^(CallStatus *callStatus){
                XCTAssert(callStatus.code == CS_NOT_AUTHED , @"");
                XCTAssert(service.authState.auth_email == nil, @"");
                XCTAssert(service.authState.auth_token == nil, @"");
                *done = YES;
            }];
        } onError:^(CallStatus *callStatus){
            XCTAssert(false, @"This spot should not be reached");
            *done = YES;
        }];
    }];
}



@end
