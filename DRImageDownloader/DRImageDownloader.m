//
// Created by Dariusz Rybicki on 31/03/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import "DRImageDownloader.h"
#import "DRImageDownloaderLoadOperation.h"

NSUInteger const DRImageDownloaderDefaultMemoryCacheSize = 10 * 1024 * 1024;

@interface DRImageDownloader ()

@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) NSMutableArray *loadOperations;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _useSharedCache = YES;
        _loadOperations = [NSMutableArray new];
    }
    return self;
}

- (NSUInteger)memoryCacheSize
{
    return self.cache.totalCostLimit;
}

- (void)setMemoryCacheSize:(NSUInteger)memoryCacheSize
{
    self.cache.totalCostLimit = memoryCacheSize;
}

#pragma mark - Fetching image

- (void)getImageWithUrl:(NSURL *)url loadCompletion:(void (^)(UIImage *))completion
{
    @synchronized (self) {
        NSArray *loadOperations = self.loadOperations.copy;
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(DRImageDownloaderLoadOperation *operation, NSDictionary *bindings) {
            return ([operation.url isEqual:url] && operation.state != DRImageDownloaderLoadOperationCompleted);
        }];
        DRImageDownloaderLoadOperation *loadOperation = [[loadOperations filteredArrayUsingPredicate:predicate] firstObject];

        if (!loadOperation) {
            loadOperation = [[DRImageDownloaderLoadOperation alloc] initWithUrl:url];
            __weak typeof(self) welf = self;
            __weak typeof(loadOperation) weakLoadOperation = loadOperation;
            [loadOperation addCompletionBlock:^(UIImage *image, NSData *data, NSURLResponse *response, NSError *error) {
                if (image && data) {
                    [welf.cache setObject:image forKey:url.absoluteString cost:data.length];
                }
                [welf.loadOperations removeObject:weakLoadOperation];
            }];
            [self.loadOperations addObject:loadOperation];
        }

        [loadOperation addCompletionBlock:^(UIImage *image, NSData *data, NSURLResponse *response, NSError *error) {
            completion(image);
        }];

        if (loadOperation.state == DRImageDownloaderLoadOperationStandby) {
            [loadOperation start];
        }
    }
}

- (void)getImageWithUrl:(NSURL *)url fromCacheCompletion:(void (^)(UIImage *))completion
{
    completion([self.cache objectForKey:url.absoluteString]);
}

- (void)getImageWithUrl:(NSURL *)url fromCacheElseLoadCompletion:(void (^)(UIImage *))completion
{
    [self getImageWithUrl:url fromCacheCompletion:^(UIImage *cachedImage) {
        if (cachedImage) {
            completion(cachedImage);
        }
        else {
            [self getImageWithUrl:url loadCompletion:^(UIImage *loadedImage) {
                completion(loadedImage);
            }];
        }
    }];
}

- (void)getImageWithUrl:(NSURL *)url fromCacheThenLoadCompletion:(void (^)(UIImage *))completion
{
    [self getImageWithUrl:url fromCacheCompletion:^(UIImage *cachedImage) {
        if (cachedImage) {
            completion(cachedImage);
        }
        [self getImageWithUrl:url loadCompletion:^(UIImage *loadedImage) {
            if (loadedImage || !cachedImage) {
                completion(loadedImage);
            }
        }];
    }];
}

#pragma mark -

- (NSCache *)sharedCache
{
    static NSCache *sharedCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[NSCache alloc] init];
        sharedCache.totalCostLimit = DRImageDownloaderDefaultMemoryCacheSize;
    });
    return sharedCache;
}

- (NSCache *)cache
{
    if (self.isUsingSharedCache) {
        _cache = nil;
        return [self sharedCache];
    }
    if (!_cache) {
        _cache = [[NSCache alloc] init];
        _cache.totalCostLimit = DRImageDownloaderDefaultMemoryCacheSize;
    }
    return _cache;
}

@end