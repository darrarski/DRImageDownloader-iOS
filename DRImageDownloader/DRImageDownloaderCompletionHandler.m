//
// Created by Dariusz Rybicki on 01/04/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import "DRImageDownloaderCompletionHandler.h"

@interface DRImageDownloaderCompletionHandler ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) void (^block)(UIImage *);

@end

@implementation DRImageDownloaderCompletionHandler

+ (instancetype)handlerForUrl:(NSURL *)url withBlock:(void (^)(UIImage *))block
{
    return [[self alloc] initForUrl:url withBlock:block];
}

- (instancetype)initForUrl:(NSURL *)url withBlock:(void (^)(UIImage *))block
{
    self = [super init];
    if (self) {
        _url = url;
        _block = block;
    }
    return self;
}

- (void)handle:(UIImage *)image
{
    self.block(image);
}

@end