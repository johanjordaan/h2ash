//
//  URLUtils.h
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/26.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLUtil : NSObject

+(NSString *) urlEncode:(NSString *)input;

+(NSString *) mergeUrl:(NSString *)url  withDictionary:(NSDictionary *)dict;

@end
