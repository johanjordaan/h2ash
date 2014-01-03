//
//  URLDelegate.h
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/24.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^URLDelegateCB)(NSString *status,NSDictionary *jsonDictionary);
typedef void (^URLDelegateECB)(NSError *);

@interface URLDelegate : NSObject<NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>

-(id)initWithTarget:(URLDelegateCB)target onError:(URLDelegateECB)ecb;

@end
