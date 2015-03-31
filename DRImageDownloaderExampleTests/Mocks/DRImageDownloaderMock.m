//
// Created by Dariusz Rybicki on 01/04/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import "DRImageDownloaderMock.h"

@implementation DRImageDownloaderMock

- (void)getImageWithUrl:(NSURL *)url loadCompletion:(void (^)(UIImage *))completion
{
    completion(self.mockedImageFromNetwork);
}

- (void)getImageWithUrl:(NSURL *)url fromCacheCompletion:(void (^)(UIImage *))completion
{
    completion(self.mockedImageFromCache);
}

@end