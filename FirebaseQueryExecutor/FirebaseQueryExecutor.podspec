#
# Be sure to run `pod lib lint FirebaseQueryExecutor.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'FirebaseQueryExecutor'
    s.version          = '0.1.0'
    s.summary          = 'A short description of FirebaseQueryExecutor.'
    
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    
    s.homepage         = 'https://github.com/Pavel Mosunov/FirebaseQueryExecutor'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Pavel Mosunov' => 'pavel.mosunov@anoda.mobi' }
    s.source           = { :git => 'https://github.com/Pavel Mosunov/FirebaseQueryExecutor.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '10.0'
    s.static_framework = true
    
    s.source_files = 'FirebaseQueryExecutor/Classes/*', 'FirebaseQueryExecutor/Classes/**/*'
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'Firebase/Firestore', '4.9.0'
    s.dependency 'Firebase', '4.9.0'
    s.dependency 'RxSwift', '4.0'
    s.dependency 'SwiftyJSON', '4.0'
end
