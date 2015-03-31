//
//  Created by Dariusz Rybicki on 01/04/15.
//  Copyright (c) 2015 Darrarski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DRImageDownloaderMock.h"

@interface DRImageDownloaderTests : XCTestCase

@property (nonatomic, strong) DRImageDownloaderMock *imageDownloader;

@end

@implementation DRImageDownloaderTests

- (void)setUp
{
    [super setUp];
    self.imageDownloader = [[DRImageDownloaderMock alloc] init];
}

- (void)tearDown
{
    [super tearDown];
    self.imageDownloader = nil;
}

- (void)test_setMemoryCacheSize
{
    XCTAssertEqual(self.imageDownloader.memoryCacheSize, DRImageDownloaderDefaultMemoryCacheSize);
    self.imageDownloader.memoryCacheSize = 512;
    XCTAssertEqual(self.imageDownloader.memoryCacheSize, 512);
    self.imageDownloader.memoryCacheSize = 1024;
    XCTAssertEqual(self.imageDownloader.memoryCacheSize, 1024);
}

- (void)test_setUseSharedCache
{
    self.imageDownloader.useSharedCache = YES;
    XCTAssertEqual(self.imageDownloader.isUsingSharedCache, YES);
    self.imageDownloader.useSharedCache = NO;
    XCTAssertEqual(self.imageDownloader.isUsingSharedCache, NO);
}

- (void)test_getImageFromNetwork
{
    UIImage *imageMock = [UIImage new];
    self.imageDownloader.mockedImageFromNetwork = imageMock;
    [self.imageDownloader getImageWithUrl:[NSURL new] loadCompletion:^(UIImage *image) {
        XCTAssertEqualObjects(image, imageMock);
    }];
}

- (void)test_getImageFromCache
{
    UIImage *imageMock = [UIImage new];
    self.imageDownloader.mockedImageFromCache = imageMock;
    [self.imageDownloader getImageWithUrl:[NSURL new] fromCacheCompletion:^(UIImage *image) {
        XCTAssertEqualObjects(image, imageMock);
    }];
}

- (void)test_getImageFromCacheThenLoad
{
    UIImage *cachedImageMock = [UIImage new];
    UIImage *loadedImageMock = [UIImage new];
    self.imageDownloader.mockedImageFromCache = cachedImageMock;
    self.imageDownloader.mockedImageFromNetwork = loadedImageMock;
    __block NSUInteger completionBlockRunCount = 0;
    [self.imageDownloader getImageWithUrl:[NSURL new] fromCacheThenLoadCompletion:^(UIImage *image) {
        completionBlockRunCount++;
        if (completionBlockRunCount == 1) {
            XCTAssertEqual(image, cachedImageMock);
        }
        else if (completionBlockRunCount == 2) {
            XCTAssertEqual(image, loadedImageMock);
        }
    }];
    XCTAssertEqual(completionBlockRunCount, 2);
}

- (void)test_getImageFromCacheElseLoad_withEmptyCache
{
    UIImage *loadedImageMock = [UIImage new];
    self.imageDownloader.mockedImageFromNetwork = loadedImageMock;
    __block NSUInteger completionBlockRunCount = 0;
    [self.imageDownloader getImageWithUrl:[NSURL new] fromCacheElseLoadCompletion:^(UIImage *image) {
        completionBlockRunCount++;
        XCTAssertEqual(image, loadedImageMock);
    }];
    XCTAssertEqual(completionBlockRunCount, 1);
}

- (void)test_getImageFromCacheElseLoad_withNonEmptyCache
{
    UIImage *cachedImageMock = [UIImage new];
    self.imageDownloader.mockedImageFromCache = cachedImageMock;
    __block NSUInteger completionBlockRunCount = 0;
    [self.imageDownloader getImageWithUrl:[NSURL new] fromCacheElseLoadCompletion:^(UIImage *image) {
        completionBlockRunCount++;
        XCTAssertEqual(image, cachedImageMock);
    }];
    XCTAssertEqual(completionBlockRunCount, 1);
}

@end
