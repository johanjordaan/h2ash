//
//  h2ashTests.m
//  h2ashTests
//
//  Created by Johan Jordaan on 2013/12/24.
//  Copyright (c) 2013 whoatemydomain. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TestConstants.h"
#import "TestUtils.h"

#import "ServiceInterface.h"
#import "URLCall.h"

@interface h2ashTests : XCTestCase

@end

@implementation h2ashTests

- (void)setUp
{
    [super setUp];
    
    BOOL setUpSuccess = [TestUtils setUp];
    XCTAssert(setUpSuccess, @"Setup did not complete successfully");
}

- (void)tearDown
{
    BOOL tearDownSuccess = [TestUtils tearDown];
    XCTAssert(tearDownSuccess, @"Teardown did not complete successfully");
    
    [super tearDown];
}

@end
