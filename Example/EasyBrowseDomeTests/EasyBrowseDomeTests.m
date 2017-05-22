//
//  EasyBrowseDomeTests.m
//  EasyBrowseDomeTests
//
//  Created by mofang2 on 17/2/16.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EYPhotoManger.h"
@interface EasyBrowseDomeTests : XCTestCase

@end

@implementation EasyBrowseDomeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSArray *arr = [[EYPhotoManger share] getAllPhotoList];
    XCTAssertNotNil(arr);
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
