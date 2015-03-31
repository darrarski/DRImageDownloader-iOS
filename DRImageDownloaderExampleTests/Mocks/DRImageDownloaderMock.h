//
// Created by Dariusz Rybicki on 01/04/15.
// Copyright (c) 2015 Darrarski. All rights reserved.
//

#import "DRImageDownloader.h"

@interface DRImageDownloaderMock : DRImageDownloader

@property (nonatomic, strong) UIImage *mockedImageFromNetwork;
@property (nonatomic, strong) UIImage *mockedImageFromCache;

@end