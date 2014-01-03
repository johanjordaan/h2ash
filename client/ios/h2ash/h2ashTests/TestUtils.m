//
//  TestUtils.m
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/27.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import "TestUtils.h"

#import "TestConstants.h"
#import "TestServiceInterface.h"

@implementation TestUtils

+(BOOL) setUp
{
    __block BOOL success = YES;
    
    [TestUtils runAndWaitForTest:^(BOOL *done){
        TestServiceInterface *service = [TestServiceInterface constructService:TEST_URL];
        
        [service loginWithEmail:TEST_ADMIN_EMAIL andPassword:TEST_ADMIN_PASSWORD andContinueWith:^(){
            [service startTestingSessionAndContinueWith:^(){
                *done = YES;
            } onError:^(CallStatus *callStatus){
                success = NO;
                *done = YES;
            }];
        } onError:^(CallStatus *callStatus){
            success = NO;
            *done = YES;
        }];
    }];
    
    return success;
}

+(BOOL) tearDown
{
    __block BOOL success = YES;
    
    [TestUtils runAndWaitForTest:^(BOOL *done){
        TestServiceInterface *service = [TestServiceInterface constructService:TEST_URL];
        
        [service endTestingSessionAndContinueWith:^(){
            *done = YES;
        } onError:^(CallStatus *callStatus){
            success = NO;
            *done = YES;
        }];
    }];
    
    return success;
}

+(void) runAndWaitForTest:(void(^)(BOOL *))test
{
    BOOL done = NO;
    
    test(&done);
    
    NSDate *untilDate;
    while(!done) {
        untilDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
        [[NSRunLoop currentRunLoop] runUntilDate:untilDate];
    }
}

@end
