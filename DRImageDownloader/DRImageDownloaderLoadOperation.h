//
// Created by Dariusz Rybicki on 02/04/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DRImageDownloaderLoadOperationCompletion)(UIImage *, NSData *, NSURLResponse *, NSError *);

typedef NS_ENUM(NSUInteger, DRImageDownloaderLoadOperationState) {
    DRImageDownloaderLoadOperationStandby,
    DRImageDownloaderLoadOperationRunning,
    DRImageDownloaderLoadOperationCompleted
};

@interface DRImageDownloaderLoadOperation : NSObject

@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) DRImageDownloaderLoadOperationState state;

- (instancetype)initWithUrl:(NSURL *)url;
- (void)addCompletionBlock:(DRImageDownloaderLoadOperationCompletion)block;
- (void)start;

@end