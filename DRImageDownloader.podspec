Pod::Spec.new do |s|
  s.name         = 'DRImageDownloader'
  s.version      = '1.0.1'
  s.summary      = 'Simple URL image downloader for iOS'
  s.homepage     = 'https://github.com/darrarski/DRImageDownloader-iOS'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Dariusz Rybicki' => 'darrarski@gmail.com' }
  s.source       = { :git => 'https://github.com/darrarski/DRImageDownloader-iOS', :tag => 'v1.0.1' }
  s.platform     = :ios
  s.ios.deployment_target = "7.0"
  s.source_files = 'DRImageDownloader'
  s.requires_arc = true
end
