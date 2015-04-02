//
// Created by Dariusz Rybicki on 02/04/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import "DRImageDownloaderLoadOperation.h"

@interface DRImageDownloaderLoadOperation ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableArray *completionHandlers;

@end

@interface CompletionHandler : NSObject

@property (nonatomic, copy) DRImageDownloaderLoadOperationCompletion block;

- (instancetype)initWithBlock:(DRImageDownloaderLoadOperationCompletion)block;

@end

@implementation DRImageDownloaderLoadOperation

- (instancetype)initWithUrl:(NSURL *)url
{
    self = [super init];
    if (self) {
        _url = url;
        _completionHandlers = [NSMutableArray new];
    }
    return self;
}

- (void)addCompletionBlock:(DRImageDownloaderLoadOperationCompletion)block
{
    [self.completionHandlers addObject:[[CompletionHandler alloc] initWithBlock:block]];
}

- (void)start
{
    void (^taskCompletionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *image = data ? [UIImage imageWithData:data] : nil;
        [self.completionHandlers enumerateObjectsUsingBlock:^(CompletionHandler *completionHandler, NSUInteger idx, BOOL *stop) {
            completionHandler.block(image, data, response, error);
        }];
    };
    [[[NSURLSession sharedSession] dataTaskWithURL:self.url completionHandler:taskCompletionHandler] resume];
}

@end

@implementation CompletionHandler

- (instancetype)initWithBlock:(DRImageDownloaderLoadOperationCompletion)block
{
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}

@end