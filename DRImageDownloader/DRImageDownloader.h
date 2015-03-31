//
// Created by Dariusz Rybicki on 31/03/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSUInteger const DRImageDownloaderDefaultMemoryCacheSize;

@interface DRImageDownloader : NSObject

@property (nonatomic, assign, getter=isUsingSharedCache) BOOL useSharedCache;
@property (nonatomic, assign) NSUInteger memoryCacheSize;

+ (instancetype)sharedInstance;

- (void)getImageWithUrl:(NSURL *)url loadCompletion:(void (^)(UIImage *))completion;
- (void)getImageWithUrl:(NSURL *)url fromCacheCompletion:(void (^)(UIImage *))completion;
- (void)getImageWithUrl:(NSURL *)url fromCacheElseLoadCompletion:(void (^)(UIImage *))completion;
- (void)getImageWithUrl:(NSURL *)url fromCacheThenLoadCompletion:(void (^)(UIImage *))completion;

@end