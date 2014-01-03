//
//  URLDelegate.m
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/24.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import "URLDelegate.h"

@interface URLDelegate()

@property (copy) URLDelegateCB target;
@property (copy) URLDelegateECB errorHandler;
@property SEL action;
@property NSString *status;

@end


@implementation URLDelegate

-(id)initWithTarget:(URLDelegateCB)target onError:(URLDelegateECB)ecb
{
    _target = target;
    _errorHandler = ecb;
    return self;
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *e = nil;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&e];
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if([_status  isEqual: @"200"])
        _target(_status,jsonDictionary);
    else
        _errorHandler([[NSError alloc] initWithDomain:@"" code:0 userInfo:nil]);
    #pragma clang diagnostic pop
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    _errorHandler(error);
    #pragma clang diagnostic pop
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)(response);
    
    _status = [NSString stringWithFormat:@"%ld",(long)[res statusCode]];
}




@end
