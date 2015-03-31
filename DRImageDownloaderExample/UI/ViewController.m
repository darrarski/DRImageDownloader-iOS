//
//  Created by Dariusz Rybicki on 31/03/15.
//  Copyright (c) 2015 Darrarski. All rights reserved.
//

#import "ViewController.h"
#import "DRImageDownloader.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) DRImageDownloader *imageDownloader;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView:)]];
}

- (DRImageDownloader *)imageDownloader
{
    if (!_imageDownloader) {
        _imageDownloader = [DRImageDownloader sharedInstance];
    }
    return _imageDownloader;
}

- (void)didTapOnView:(id)sender
{
    [self reloadImage];
}

- (void)reloadImage
{
    __weak typeof(self) welf = self;
    [self.imageDownloader getImageWithUrl:[self getRandomImageUrlWithSize:[self getImageSizeForImageView]]
              fromCacheThenLoadCompletion:^(UIImage *image) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      welf.imageView.image = image;
                  });
              }];
}

- (NSURL *)getRandomImageUrlWithSize:(CGSize)imageSize
{
    return [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://lorempixel.com/%ld/%ld", (long)imageSize.width, (long)imageSize.height]];
}

- (CGSize)getImageSizeForImageView
{
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize imageSize = CGSizeApplyAffineTransform(
        self.imageView.frame.size,
        CGAffineTransformMakeScale(screenScale, screenScale)
    );
    return imageSize;
}

@end
