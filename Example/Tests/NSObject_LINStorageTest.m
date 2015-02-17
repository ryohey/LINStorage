//
//  NSObject_LINStorageTest.m
//  LINStorage
//
//  Created by Ryohei Kameyama on 2015/02/17.
//  Copyright (c) 2015年 ryohey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import <NSObject+LINStorage.h>

@interface NSObject_LINStorageTest : XCTestCase

@end

@implementation NSObject_LINStorageTest

- (NSString *)savePath {
    return [NSString stringWithFormat:@"%@foo.txt", NSTemporaryDirectory()];
}

- (void)cleanUp {
    [NSFileManager.defaultManager removeItemAtPath:[self savePath] error:nil];
}

- (void)setUp {
    [self cleanUp];
}

- (void)tearDown {
    [self cleanUp];
}

- (void)testStoring {
    {
        NSError *error = nil;
        [@"test" lin_storeToFile:[self savePath] error:&error];
        XCTAssertNil(error);
    }
    
    {
        NSError *error = nil;
        NSString *restoredStr = [NSString lin_restoreFromFile:[self savePath] error:&error];
        XCTAssertNil(error);
        
        XCTAssertEqualObjects(restoredStr, @"test");
    }
}

- (void)testClassError {
    {
        NSError *error = nil;
        [@"test" lin_storeToFile:[self savePath] error:&error];
    }
    
    {
        NSError *error = nil;
        [NSDictionary lin_restoreFromFile:[self savePath] error:&error];
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, LINStorageErrorRestoreDifferentClass);
    }
}

- (void)testAsync {
    
    XCTestExpectation *storeExpectation = [self expectationWithDescription:@"storing"];
    XCTestExpectation *restoreExpectation = [self expectationWithDescription:@"restoring"];
    
    [@"test" lin_storeToFile:[self savePath] onComplete:^{
        [storeExpectation fulfill];
        
        [NSString lin_restoreFromFile:[self savePath] onComplete:^(NSString *str) {
            XCTAssertEqualObjects(str, @"test");
            [restoreExpectation fulfill];
        } onError:^(NSError *error) {
            XCTAssertNotNil(error);
        }];
        
    } onError:^(NSError *error) {
        XCTAssertNotNil(error);
    }];
    
    [self waitForExpectationsWithTimeout:1.0f handler:nil];
}

@end
