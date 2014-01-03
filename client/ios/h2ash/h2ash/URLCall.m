//
//  URLCalls.m
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/24.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import "URLCall.h"
#import "URLDelegate.h"
#import "URLEncoding.h"
#import "URLUtil.h"

@implementation URLCall

+(void) postTo:(NSString *)URL withData:(NSDictionary *)data andContinueWith:(JSONHandlerCB)cb;
{
    NSURL *url = [NSURL URLWithString:URL];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSString *postData = [data URLEncodedString];
    
    [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[NSData dataWithBytes:[postData UTF8String] length:strlen([postData UTF8String] )]];

    URLDelegateCB jsonHandler;
    jsonHandler = ^(NSString *status,NSDictionary *jsonDictionary) {
        cb(jsonDictionary);
    };
    URLDelegate *d = [[URLDelegate alloc] initWithTarget:jsonHandler onError:nil];

    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:req delegate:d];
    
    if(!con) {
        //    _results.text = @"Connection failed.";
    }
}

+(void) getFrom:(NSString *)URL
        withData:(NSDictionary *)data
        andContinueWith:(JSONHandlerCB)cb
        onError:(void(^)(NSError *))ecb
{
    NSURL *url = [NSURL URLWithString:[URLUtil mergeUrl:URL withDictionary:data]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    [req setHTTPMethod:@"GET"];
    
    URLDelegateCB jsonHandler;
    jsonHandler = ^(NSString *status,NSDictionary *jsonDictionary) {
        cb(jsonDictionary);
    };
    URLDelegate *d = [[URLDelegate alloc] initWithTarget:jsonHandler onError:ecb];
    
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:req delegate:d];
    
    if(!con) {
        ecb([[NSError alloc] initWithDomain:@"" code:0 userInfo:nil]);
    }
}

@end
