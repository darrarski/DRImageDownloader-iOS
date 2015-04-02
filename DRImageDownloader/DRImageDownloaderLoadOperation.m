//
// Created by Dariusz Rybicki on 02/04/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import "DRImageDownloaderLoadOperation.h"

@interface DRImageDownloaderLoadOperation ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableArray *completionHandlers;
@property (nonatomic, assign) DRImageDownloaderLoadOperationState state;
@property (nonatomic, strong) NSURLSessionDataTask *task;

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
        _state = DRImageDownloaderLoadOperationStandby;
    }
    return self;
}

- (void)addCompletionBlock:(DRImageDownloaderLoadOperationCompletion)block
{
    [self.completionHandlers addObject:[[CompletionHandler alloc] initWithBlock:block]];
}

- (void)start
{
    self.state = DRImageDownloaderLoadOperationRunning;
    [self.task resume];
}

#pragma mark -

- (NSURLSessionDataTask *)task
{
    if (!_task) {
        __weak typeof(self) welf = self;
        void (^taskCompletionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
            welf.state = DRImageDownloaderLoadOperationCompleted;
            UIImage *image = data ? [UIImage imageWithData:data] : nil;
            [welf.completionHandlers enumerateObjectsUsingBlock:^(CompletionHandler *completionHandler, NSUInteger idx, BOOL *stop) {
                completionHandler.block(image, data, response, error);
            }];
        };
        _task = [[NSURLSession sharedSession] dataTaskWithURL:self.url completionHandler:taskCompletionHandler];
    }
    return _task;
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