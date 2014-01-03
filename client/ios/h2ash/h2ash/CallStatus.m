//
//  CallStatus.m
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/26.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import "CallStatus.h"

@implementation CallStatus

-(id) initWithDictionary:(NSDictionary *)dict
{
    _code = [[dict objectForKey:@"error_code"] integerValue];
    _server_message = [dict objectForKey:@"error_message"];
    
    return self;
}

-(BOOL) callWasSuccessfull
{
    return _code == CS_OK;
}
@end
