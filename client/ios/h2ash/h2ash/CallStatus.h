//
//  CallStatus.h
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/26.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CS_OK                           0
#define CS_INVALID_CREDENTIALS          1
#define CS_NOT_AUTHED                   2
#define CS_DUPLICATE_USER               3
#define CS_USER_NOT_VALIDATED           4
#define CS_INVALID_REGISTRATION_TOKEN   5       /* This should never come to the client its here for competeness*/

@interface CallStatus : NSObject

@property NSInteger code;
@property NSString *server_message;


-(id) initWithDictionary:(NSDictionary *)dict;
-(BOOL) callWasSuccessfull;

@end
