//
//  ServiceInterface.m
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/24.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import "ServiceInterface.h"

@interface ServiceInterface()

@end

static ServiceInterface *service = nil;

@implementation ServiceInterface

// The factory methods.
//
+(ServiceInterface *) constructService:(NSString *)URL
{
    service = [[ServiceInterface alloc] initWithUrl:URL];
    return service;
}

+(ServiceInterface *) getService
{
    return service;
}

// Private? constructors
//
-(id) initWithUrl:(NSString *) URL
{
    _baseURL = URL;
    _serviceStatus = [[ServiceStatus alloc] init];
    _authState = [[AuthState alloc] init];
    return self;
}

// Utility methods
//
-(NSString *) getUrl:(NSString *)URL
{
    return [NSString stringWithFormat:@"%@/%@",_baseURL,URL ];
}

-(void) clearData
{
    _authState.auth_email = nil;
    _authState.auth_token = nil;
}

-(NSMutableDictionary *) getData
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:_authState.auth_token forKey:@"auth_token"];
    [data setValue:_authState.auth_email forKey:@"auth_email"];
        
    return data;
}

-(void) setData:(NSDictionary *)jsonDictionary
{
    _authState.auth_token = [jsonDictionary objectForKey:@"auth_token"];
}

// Actual backend methods
//
-(void) getServiceStatusAndContinueWith:(CB)cb onError:(ECB)ecb
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    JSONHandlerCB jsonHandler = ^(NSDictionary *jsonDictionary) {
        //NSString *status = [jsonDictionary valueForKey:@"status"];
        
        CallStatus *callStatus = [[CallStatus alloc] initWithDictionary:jsonDictionary];
        if([callStatus callWasSuccessfull]) {
            cb();
        } else {
            if(callStatus.code == CS_NOT_AUTHED)
                [self clearData];
            ecb(callStatus);
        }
    };
    
    [URLCall postTo:[self getUrl:@"status"] withData:data andContinueWith:jsonHandler];
 }

-(void) loginWithEmail:(NSString *)email andPassword:(NSString *)password andContinueWith:(CB)cb onError:(ECB)ecb
{
    [self clearData];
    
    NSMutableDictionary *data = [self getData];
    [data setValue:email forKey:@"email"];
    [data setValue:password forKey:@"password"];
    
    JSONHandlerCB jsonHandler = ^(NSDictionary *jsonDictionary) {
        
        CallStatus *callStatus = [[CallStatus alloc] initWithDictionary:jsonDictionary];
        if([callStatus callWasSuccessfull]) {
            [self setData:jsonDictionary];
            _authState.auth_email = email;
            cb();
        } else {
            if(callStatus.code == CS_NOT_AUTHED)
                [self clearData];
            ecb(callStatus);
        }
    };
    
    [URLCall postTo:[self getUrl:@"login"] withData:data andContinueWith:jsonHandler];
}

-(void) logoutAndContinueWith:(CB)cb onError:(ECB)ecb
{
    NSMutableDictionary *data = [self getData];
    
    JSONHandlerCB jsonHandler = ^(NSDictionary *jsonDictionary) {
        
        CallStatus *callStatus = [[CallStatus alloc] initWithDictionary:jsonDictionary];
        if([callStatus callWasSuccessfull]) {
            [self setData:jsonDictionary];
            [self clearData];
            cb();
        } else {
            if(callStatus.code == CS_NOT_AUTHED)
                [self clearData];
            ecb(callStatus);
        }
    };
    
    [URLCall postTo:[self getUrl:@"logout"] withData:data andContinueWith:jsonHandler];
}

-(void) getOverviewAndContinueWith:(CB)cb onError:(ECB)ecb
{
    NSMutableDictionary *data = [self getData];
    

    JSONHandlerCB jsonHandler = ^(NSDictionary *jsonDictionary) {
        CallStatus *callStatus = [[CallStatus alloc] initWithDictionary:jsonDictionary];
        if([callStatus callWasSuccessfull]) {
            [self setData:jsonDictionary];
            cb();
        } else {
            if(callStatus.code == CS_NOT_AUTHED)
                [self clearData];
            ecb(callStatus);
        }
    };
    
    [URLCall postTo:[self getUrl:@"overview"] withData:data andContinueWith:jsonHandler];
}

-(void) registerWithEmail:(NSString *)email andPassword:(NSString *)password andContinueWith:(CB)cb onError:(ECB)ecb
{
    NSMutableDictionary *data = [self getData];
    [data setValue:email forKey:@"email"];
    [data setValue:password forKey:@"password"];
    
    JSONHandlerCB jsonHandler = ^(NSDictionary *jsonDictionary) {
        CallStatus *callStatus = [[CallStatus alloc] initWithDictionary:jsonDictionary];
        if([callStatus callWasSuccessfull]) {
            [self setData:jsonDictionary];
            cb();
        } else {
            if(callStatus.code == CS_NOT_AUTHED)
                [self clearData];
            ecb(callStatus);
        }
    };
  
    [URLCall postTo:[self getUrl:@"register"] withData:data andContinueWith:jsonHandler];
}



@end
