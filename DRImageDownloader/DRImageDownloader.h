//
// Created by Dariusz Rybicki on 31/03/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRImageDownloader : NSObject

@property (nonatomic, assign) NSUInteger memoryCacheSize;

+ (instancetype)sharedInstance;
- (void)downloadImageWithUrl:(NSURL *)url completion:(void (^)(UIImage *))completion;
- (UIImage *)cachedImageForUrl:(NSURL *)url;

- (void)getImageWithUrl:(NSURL *)url completion:(void (^)(UIImage *))completion;
@end