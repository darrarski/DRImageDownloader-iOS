//
//  Created by Dariusz Rybicki on 01/04/15.
//  Copyright (c) 2015 Darrarski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DRImageDownloader.h"

@interface DRImageDownloaderTests : XCTestCase

@property (nonatomic, strong) DRImageDownloader *imageDownloader;

@end

@implementation DRImageDownloaderTests

- (void)setUp
{
    [super setUp];
    self.imageDownloader = [[DRImageDownloader alloc] init];
}

- (void)tearDown
{
    [super tearDown];
    self.imageDownloader = nil;
}

- (void)testSetMemoryCacheSize
{
    XCTAssertEqual(self.imageDownloader.memoryCacheSize, DRImageDownloaderDefaultMemoryCacheSize);
    self.imageDownloader.memoryCacheSize = 512;
    XCTAssertEqual(self.imageDownloader.memoryCacheSize, 512);
    self.imageDownloader.memoryCacheSize = 1024;
    XCTAssertEqual(self.imageDownloader.memoryCacheSize, 1024);
}

- (void)testSetUseSharedCache
{
    self.imageDownloader.useSharedCache = YES;
    XCTAssertEqual(self.imageDownloader.isUsingSharedCache, YES);
    self.imageDownloader.useSharedCache = NO;
    XCTAssertEqual(self.imageDownloader.isUsingSharedCache, NO);
}

@end
