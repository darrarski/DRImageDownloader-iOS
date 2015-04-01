//
// Created by Dariusz Rybicki on 01/04/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRImageDownloaderCompletionHandler : NSObject

@property (nonatomic, readonly) NSURL *url;

+ (instancetype)handlerForUrl:(NSURL *)url withBlock:(void (^)(UIImage *))block;
- (void)handle:(UIImage *)image;

@end