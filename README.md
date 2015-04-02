# DRImageDownloader (iOS)

Simple URL image downloader for iOS

## Features

- Compatible with iOS 7 & 8
- Provides easy image downloading from public URLs
- Uses independent memory caching with customizable size
- Memory cache can be shared between `DRImageDownloader` instances
- Uses `NSURLSession` under the hood, which provides native iOS caching, respecting `HTTPCache`
- Protects from performing multiple network requests simultaneously for the same image

## Usage

#### Load image from network

```obj-c
- (void)getImageWithUrl:(NSURL *)url loadCompletion:(void (^)(UIImage *))completion;
```

#### Load image from cache

```obj-c    
- (void)getImageWithUrl:(NSURL *)url fromCacheCompletion:(void (^)(UIImage *))completion;
```

#### Load image from cache else network

```obj-c
- (void)getImageWithUrl:(NSURL *)url fromCacheElseLoadCompletion:(void (^)(UIImage *))completion;
```

Image will be loaded from cache if possible, otherwise it will be loaded from network.

#### Load image from cache, then reload from network

```obj-c
- (void)getImageWithUrl:(NSURL *)url fromCacheThenLoadCompletion:(void (^)(UIImage *))completion;
```

Image will be loaded from cache if possible, then it will be reloaded from network. 

- if image is **not cached**, but **availabe** on the network - completion block will be called once, with image loaded from network
- if image **persists in cache**, but it's **not available** on the network - completion block will be called once, with image loaded from cache
- if image **persists in cache** and is **available** on the network - completion block will be called twice, first with image from cache, then with image loaded from network
- if image is **not cached** and it's **not available** on the network - completion block will be called once, will `nil` image

## Instalation

You can integrate `DRImageDownloader` with your project using Cocoapods. To do so, you will need to add one of the following lines to your Podfile:

For most recent or development version:

    pod 'DRImageDownloader', :git => 'https://github.com/darrarski/DRImageDownloader-iOS.git'

For specific version:

    pod 'DRImageDownloader', :git => 'https://github.com/darrarski/DRImageDownloader-iOS.git', :tag => 'VERSION_TAG'

Where `VERSION_TAG` you should put tag name for given version (ex. "v1.0.0"). It is recommended to set version explicity instead of using most recent version, as backward compatibility is not warranted.

You can also download zip archive of given release from [releases page](https://github.com/darrarski/DRImageDownloader-iOS/releases).

## Usage

Check out included example project.

## License

The MIT License (MIT) - check out included [LICENSE](LICENSE) file
