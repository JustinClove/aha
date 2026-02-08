# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'

#plugin 'cocoapods-art', :sources => ['cocoapods']
#plugin 'cocoapods-rome'


platform :ios, '15.0'

target 'MarsVPN' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MarsVPN
#  pod 'FirebaseAnalytics', '~> 10.0.0'
  # pod 'FirebaseFirestore', '~> 10.0.0'
  pod 'Kingfisher'
  pod 'SnapKit'
  pod 'HandyJSON', '~> 5.0.4-beta'
  pod 'Moya'
  pod 'KeychainAccess', '~> 3.2.0'
  pod 'SwifterSwift', '~>5.2.0'
  pod 'Result', '~> 5.0.0'
  pod 'AFDateHelper'
  pod 'DeviceKit'
  pod 'SwiftyJSON'
  pod 'Closures'
  pod 'ProgressWebViewController', '~> 1.11.0'
  pod 'SwiftyStoreKit', '~> 0.16.1'
  pod 'TYCyclePagerView'
#  pod 'PKHUD'
  pod 'ActiveLabel'
  pod 'KMNavigationBarTransition'
  pod 'ReachabilitySwift', '~> 5.0.0'
  pod 'Flurry-iOS-SDK/FlurrySDK'
#  pod 'HDPingTools', '~> 2.0.0'
  pod 'Google-Mobile-Ads-SDK', '~> 9.11.0.1'
  
  post_install do |installer|
    
    swift4 = []
    swift42 = ['CountdownLabel']
    installer.pods_project.targets.each do |target|
       target.build_configurations.each do |config|
         config.build_settings['SWIFT_VERSION'] = '5.0'
#         if swift4.include?(target.name)
#           config.build_settings['SWIFT_VERSION'] = '4.0'
#         end
#         if swift42.include?(target.name)
#           config.build_settings['SWIFT_VERSION'] = '4.2'
#         end
       end
    end
    
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
#                config.build_settings['SWIFT_VERSION'] = '5.0'
                config.build_settings['SWIFT_COMPILATION_MODE'] = 'wholemodule'
#                config.build_settings['COMPILER_INDEX_STORE_ENABLE'] = 'NO'

##                # DeadArg
#                config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)']
#                config.build_settings['OTHER_SWIFT_FLAGS'] << '-Xfrontend -disable-dead-argument-elimination'
#
#                # Release
#                if config.name == 'Release'
                  config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
                  config.build_settings['GCC_OPTIMIZATION_LEVEL'] = '0'
#                end

            end
        end
    end
  end
  

end

#target 'NetworkExtension' do
#  # Comment the next line if you don't want to use dynamic frameworks
#  use_frameworks!
#
#  # Pods for NetworkExtension
#
#end
