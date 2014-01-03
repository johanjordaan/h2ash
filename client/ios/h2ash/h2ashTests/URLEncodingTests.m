//
//  URLEncodingTests.m
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/24.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "URLEncoding.h"

@interface URLEncodingTests : XCTestCase

@end

@implementation URLEncodingTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_URLEncodeString
{
    NSMutableDictionary *testDict = [[NSMutableDictionary alloc] init];
    
    [testDict setValue:@"first" forKey:@"one"];
    [testDict setValue:@"second" forKey:@"two"];
    [testDict setValue:@"space space" forKey:@"three"];
    
    
    NSString *result = [testDict URLEncodedString];
    
    XCTAssertEqualObjects(result, @"one=first&two=second&three=space%20space", "");
}

@end
