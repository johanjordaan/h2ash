//
//  URLUtils.m
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/26.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import "URLUtil.h"

@implementation URLUtil

+(NSString *) urlEncode:(NSString *)input
{
    NSString *encodedUrl = [input stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    return encodedUrl;
}
    
+(NSString *) mergeUrl:(NSString *)url  withDictionary:(NSDictionary *)dict
{
    NSString *mergedUrl = [[NSString alloc] initWithString:url];
    
    NSEnumerator *enumerator = [dict keyEnumerator];
    id key;
    NSString *value;
    
    while(key = [enumerator nextObject]) {
        value = [dict valueForKey:key];
        mergedUrl = [mergedUrl stringByReplacingOccurrencesOfString:key withString:value];
        
    }
    
    return [URLUtil urlEncode:mergedUrl];
}

@end
