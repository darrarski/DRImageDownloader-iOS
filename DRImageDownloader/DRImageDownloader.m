//
// Created by Dariusz Rybicki on 31/03/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import "DRImageDownloader.h"

static NSUInteger const DefaultMemoryCacheSize = 10 * 1024 * 1024;

@interface DRImageDownloader ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation DRImageDownloader

+ (instancetype)sharedInstance
{
    static DRImageDownloader *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSUInteger)memoryCacheSize
{
    return self.cache.totalCostLimit;
}

- (void)setMemoryCacheSize:(NSUInteger)memoryCacheSize
{
    self.cache.totalCostLimit = memoryCacheSize;
}

- (void)downloadImageWithUrl:(NSURL *)url completion:(void (^)(UIImage *))completion
{
    __weak typeof(self) welf = self;
    void (^taskCompletionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage *image = data ? [UIImage imageWithData:data] : nil;
        completion(image);
        if (image) {
            [welf.cache setObject:image forKey:url.absoluteString cost:data.length];
        }
    };
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:taskCompletionHandler] resume];
}

- (UIImage *)cachedImageForUrl:(NSURL *)url
{
    return [self.cache objectForKey:url.absoluteString];
}

- (void)getImageWithUrl:(NSURL *)url completion:(void (^)(UIImage *))completion
{
    UIImage *cachedImage = [self cachedImageForUrl:url];
    if (cachedImage) {
        completion(cachedImage);
    }
    [self downloadImageWithUrl:url completion:^(UIImage *image) {
        if (image || !cachedImage) {
            completion(image);
        }
    }];
}

#pragma mark -

- (NSCache *)cache
{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.totalCostLimit = DefaultMemoryCacheSize;
    }
    return _cache;
}

@end