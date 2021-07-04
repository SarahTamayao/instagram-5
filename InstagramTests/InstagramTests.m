//
//  InstagramTests.m
//  InstagramTests
//
//  Created by Rigre Reinier Garciandia Larquin on 7/2/21.
//

#import <XCTest/XCTest.h>
#import <Parse/Parse.h>

@interface InstagramTests : XCTestCase

@end

@implementation InstagramTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void) testParseConnection {
    //Testing Parse
    PFObject *gameScore = [PFObject objectWithClassName:@"GameScore"];
    gameScore[@"score"] = @1337;
    gameScore[@"playerName"] = @"Sean Plott";
    gameScore[@"cheatMode"] = @NO;
    [gameScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Object saved!");
        }
        else {
            NSLog(@"Error: %@", error.description);
        }
        
        XCTAssert(succeeded);
    }];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
