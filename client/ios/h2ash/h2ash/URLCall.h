//
//  URLCalls.h
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/24.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JSONHandlerCB)(NSDictionary *jsonDictionary) ;

@interface URLCall: NSObject

+(void) postTo:(NSString *)URL withData:(NSDictionary *)data andContinueWith:(JSONHandlerCB)cb;
+(void) getFrom:(NSString *)URL
        withData:(NSDictionary *)data
        andContinueWith:(JSONHandlerCB)cb
        onError:(void(^)(NSError *))ecb;

@end
