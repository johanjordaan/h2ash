//
//  TestServiceInterface.m
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/28.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import "TestConstants.h"
#import "TestServiceInterface.h"

static TestServiceInterface *testService = nil;

@implementation TestServiceInterface

+(TestServiceInterface *) constructService:(NSString *)URL
{
    testService = [[TestServiceInterface alloc] initWithUrl:URL];
    return testService;
}

+(TestServiceInterface *) getService
{
    return testService;
}

-(void) startTestingSessionAndContinueWith:(CB)cb onError:(ECB)ecb
{
    NSMutableDictionary *data = [self getData];
    
    JSONHandlerCB jsonHandler = ^(NSDictionary *jsonDictionary) {
        CallStatus *callStatus = [[CallStatus alloc] initWithDictionary:jsonDictionary];
        if([callStatus callWasSuccessfull]) {
            [self setData:jsonDictionary];
            // We have started a test sesion so the service state should be clean
            //
            [self clearData];
            cb();
        } else {
            if(callStatus.code == CS_NOT_AUTHED)
                [self clearData];
            ecb(callStatus);
        }
    };
    
    [URLCall postTo:[self getUrl:@"start_testing_session"] withData:data andContinueWith:jsonHandler];
}
-(void) endTestingSessionAndContinueWith:(CB)cb onError:(ECB)ecb
{
    NSMutableDictionary *data = [self getData];
    
    JSONHandlerCB jsonHandler = ^(NSDictionary *jsonDictionary) {
        CallStatus *callStatus = [[CallStatus alloc] initWithDictionary:jsonDictionary];
        if([callStatus callWasSuccessfull]) {
            [self setData:jsonDictionary];
            // We have ended a test sesion so the service state should be clean
            //
            [self clearData];
            cb();
        } else {
            if(callStatus.code == CS_NOT_AUTHED)
                [self clearData];
            ecb(callStatus);
        }
    };
    
    [URLCall postTo:[self getUrl:@"end_testing_session"] withData:data andContinueWith:jsonHandler];
}

-(void) validateToken:(NSString *)token andContinueWith:(CB)cb onError:(ECB)ecb
{
    NSString *validationURL = [NSString stringWithFormat:@"%@/%@",TEST_URL,@"validate/registration_token"];
    NSMutableDictionary *validationData = [[NSMutableDictionary alloc] init];
    // We use the email as the registration token when we are in test mode on the server
    //
    [validationData setValue:TEST_USER_A_EMAIL forKey:@"registration_token"];
    [URLCall getFrom:validationURL withData:validationData andContinueWith:^(NSDictionary *result){
        CallStatus *callStatus = [[CallStatus alloc] initWithDictionary:result];
        if([callStatus callWasSuccessfull]) {
            [self setData:result];
            cb();
        } else {
            if(callStatus.code == CS_NOT_AUTHED)
                [self clearData];
            ecb(callStatus);
        }
    } onError:^(NSError *error) {
    }];
}

@end
