#
# Be sure to run `pod lib lint MHPhotoUploader.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MHPhotoUploader'
  s.version          = '1.1.4'
  s.summary          = '图片选择后自动上传并生成id'
  s.homepage         = 'https://github.com/leehyoley/MHPhotoUploader'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'leehyoley' => 'leehyoley@163.com' }
  s.source           = { :git => 'https://github.com/leehyoley/MHPhotoUploader.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'

  s.source_files = 'MHPhotoUploader/Classes/**/*.{m,h}'
  s.resource     = 'MHPhotoUploader/Assets/**/*.png'
  s.dependency 'SDWebImage', '~> 4.4.6'
  s.dependency 'Masonry'
  s.dependency 'MBProgressHUD'
  s.dependency 'ZLPhotoBrowser', '~> 3.0.1'
  s.dependency 'KSPhotoBrowser'
  s.dependency 'MHBase'
  s.dependency 'VMNetworking'
end
