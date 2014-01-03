//
//  TestUtils.h
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/27.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestUtils : NSObject

+(BOOL) setUp;
+(BOOL) tearDown;
+(void) runAndWaitForTest:(void(^)(BOOL *))test;

@end
