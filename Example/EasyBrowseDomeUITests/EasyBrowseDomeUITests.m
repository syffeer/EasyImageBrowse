//
//  EasyBrowseDomeUITests.m
//  EasyBrowseDomeUITests
//
//  Created by mofang2 on 17/2/16.
//  Copyright © 2017年 com.cfd.SaturnEasyTool. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface EasyBrowseDomeUITests : XCTestCase

@end

@implementation EasyBrowseDomeUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    XCUIApplication *app = [[XCUIApplication alloc] init];

    XCUIElement *element = [[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element;
    [element tap];
    [[[app.collectionViews childrenMatchingType:XCUIElementTypeCell] elementBoundByIndex:1].buttons[@"detail Commenticon selectphoto"] tap];
    [element tap];
    
    XCUIElement *button = app.navigationBars[@"EZPhotoBigBroese"].buttons[@"取消"];
    [button tap];
    [element tap];
    [element swipeLeft];
    [element swipeLeft];
    [button tap];
    [app.navigationBars[@"相机胶卷"].buttons[@"返回"] tap];
    
    
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
