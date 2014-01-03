//
//  URLCallTests.m
//  h2ash
//
//  Created by Johan Jordaan on 2013/12/24.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TestConstants.h"
#import "TestUtils.h"

#import "URLCall.h"

@interface URLCallTests : XCTestCase

@end

@implementation URLCallTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

-(void) test_valid_postTo
{
    [TestUtils runAndWaitForTest:^(BOOL *done){

        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        
        JSONHandlerCB cb = ^(NSDictionary *jsonDictionary) {
            NSString *status = [jsonDictionary valueForKey:@"status"];
            XCTAssertEqualObjects(status,@"OK", "");
            *done = YES;
        };
        
        [URLCall postTo:[NSString stringWithFormat:@"%@/%@",TEST_URL,@"status"] withData:data andContinueWith:cb];

    }];
}

-(void) test_valid_getFrom
{
    [TestUtils runAndWaitForTest:^(BOOL *done){
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setValue:@"xxx" forKey:@"registration_token"];
        
        NSString *url  = [NSString stringWithFormat:@"%@/%@",TEST_URL,@"validate/registration_token"];
        [URLCall getFrom:url withData:data andContinueWith:^(NSDictionary *jsonDictionary){
            NSInteger error_code = [[jsonDictionary valueForKey:@"error_code"] integerValue];
            XCTAssertEqual(error_code,0, "");
            *done = YES;
        } onError:^(NSError *error){
            *done = YES;
        }];
        
    }];
}

-(void) test_invalid_url_getFrom
{
    [TestUtils runAndWaitForTest:^(BOOL *done){
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        [data setValue:@"xxx" forKey:@"registration_token"];
        
        NSString *url = [NSString stringWithFormat:@"%@/%@",@"xxx",@"validate/registration_token"];
        [URLCall getFrom:url withData:data andContinueWith:^(NSDictionary *jsonDictionary) {
            XCTAssert(false, @"This spot should not be reached");
            *done = YES;
        } onError:^(NSError *error){
            *done = YES;
        }];
        
    }];
}




@end
