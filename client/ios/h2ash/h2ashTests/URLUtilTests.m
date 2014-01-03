//
//  URLUtils.m
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/26.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "URLUtil.h"

@interface URLUtilTests : XCTestCase

@end

@implementation URLUtilTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

-(void) test_urlEncode
{
    NSString *input = @"http://hallo world?this=10&that=not this";
    NSString *result = [URLUtil urlEncode:input];
    XCTAssertEqualObjects(result, @"http://hallo%20world?this=10&that=not%20this", "");
    
}

-(void) test_mergeUrl
{
    NSString *url = @"http://user/user_id/loan/loan_id";
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"johan" forKey:@"user_id"];
    [dict setObject:@"xxx" forKey:@"not_used"];
    [dict setObject:@"home loan" forKey:@"loan_id"];
    
    NSString *mergedUrl = [URLUtil mergeUrl:url withDictionary:dict];
    
    XCTAssertEqualObjects(mergedUrl, @"http://user/johan/loan/home%20loan","");
}

@end
