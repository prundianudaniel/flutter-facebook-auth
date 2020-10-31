#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_facebook_auth'
  s.version          = '0.3.1'
  s.summary          = 'Plugin to Facebook authentication for iOS in your Flutter app'
  s.description      = <<-DESC
Plugin to Facebook authentication for iOS in your Flutter app.
                       DESC
  s.homepage         = 'https://github.com/the-meedu-app/flutter-facebook-auth'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Darwin Morocho' => 'darwin.morocho@icloud.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.dependency 'FBSDKCoreKit', '~> 8.1.0'
  s.dependency 'FBSDKLoginKit', '~> 8.1.0'
  s.platform = :ios, '9.0'
  s.ios.deployment_target = '9.0'
end

