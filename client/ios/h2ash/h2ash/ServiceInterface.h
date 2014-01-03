//
//  ServiceInterface.h
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/24.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "URLCall.h"

#import "ServiceStatus.h"
#import "AuthState.h"
#import "CallStatus.h"


@interface ServiceInterface : NSObject

@property NSString *baseURL;

@property ServiceStatus *serviceStatus;
@property AuthState *authState;

#define CB void(^)()
#define ECB void(^)(CallStatus *)

// Internal utility methods
//
-(NSString *) getUrl:(NSString *)URL;
-(void) clearData;
-(NSMutableDictionary *) getData;
-(void) setData:(NSDictionary *)jsonDictionary;

// Factory construction methods
//
+(ServiceInterface *) constructService:(NSString *)URL;
+(ServiceInterface *) getService;
-(id) initWithUrl:(NSString *) URL;


-(void) getServiceStatusAndContinueWith:(CB)cb onError:(ECB)ecb;

-(void) loginWithEmail:(NSString *)email andPassword:(NSString *)password andContinueWith:(CB)cb onError:(ECB)ecb;
-(void) logoutAndContinueWith:(CB)cb onError:(ECB)ecb;

-(void) getOverviewAndContinueWith:(CB)cb onError:(ECB)ecb;

-(void) registerWithEmail:(NSString *)email andPassword:(NSString *)password andContinueWith:(CB)cb onError:(ECB)ecb;

@end
