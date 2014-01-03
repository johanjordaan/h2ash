//
//  TestServiceInterface.h
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/28.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import "ServiceInterface.h"

// This extends the serviceinterface with the methods that should only be in the test interface. This way the
// server will have the code (but protected by admin and settings) but the User intercae will not have access
// to these methods
//

@interface TestServiceInterface : ServiceInterface

+(TestServiceInterface *) constructService:(NSString *)URL;
+(TestServiceInterface *) getService;

-(void) startTestingSessionAndContinueWith:(CB)cb onError:(ECB)ecb;
-(void) endTestingSessionAndContinueWith:(CB)cb onError:(ECB)ecb;

-(void) validateToken:(NSString *)token andContinueWith:(CB)cb onError:(ECB)ecb;

@end
