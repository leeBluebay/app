//
//  TestsDataController.m
//  Clinical
//
//  Created by brian macbride on 26/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestsDataController.h"

@implementation TestsDataController

@synthesize testsArray = _testsArray;

- (id)init {
    if (self = [super init]) {
        [self initialiseTestsArray];
    }
    return self;
}

- (void)initialiseTestsArray {
    NSMutableArray *testsArray = [[NSMutableArray alloc] init];
    self.testsArray = testsArray;
}

- (void) addTest:(NSString *)name withStatus:(NSString*)status onDate:(NSString*)testDate
{
    TestData *testData = [[TestData alloc] init];
    testData.name = name;
    testData.status = status;
    testData.testDate = testDate;
    
    [self.testsArray addObject:testData];
}

- (void) clearTests
{
    [self.testsArray removeAllObjects];
}

@end
