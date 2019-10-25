
Pod::Spec.new do |s|
    s.name             = 'RxFirestoreExecutor'
    s.version          = '0.1.7'
    s.summary          = 'RxFirestoreExecutor is a simplified way to work Firebase/Firestore Queries.'
    
    s.description      = <<-DESC
    RxFirestoreExecutor uses "MOYA-like" structure to simplify query workflow. It's also handle response from Firestore via RxSwift.
    It's replace a lot of boilerplate code for creating queries and handle them with Firebase/Firestore Library.
    DESC
    
    s.swift_version = '4.2'
    s.homepage         = 'https://github.com/anodamobi/RxFirestoreExecutor/'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Pavel Mosunov' => 'pavel.mosunov@anoda.mobi' }
    s.source           = { :git => 'https://github.com/anodamobi/RxFirestoreExecutor.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '9.0'
    s.static_framework = true
    
    s.source_files = 'FirebaseQueryExecutor/Classes/*', 'FirebaseQueryExecutor/Classes/**/*'
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'Firebase/Firestore' #, '5.5.0'
    s.dependency 'Firebase' #, '5.5.0'
    s.dependency 'RxSwift', '~> 4.0'
    s.dependency 'SwiftyJSON', '~> 4.0'
end
