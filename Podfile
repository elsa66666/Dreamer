
platform :ios, '9.0'

target 'dreamer1' do
  use_frameworks!

  # Pods for dreamer1

  pod 'IQKeyboardManagerSwift'
  pod 'TYAttributedLabel', '~> 2.6.2'
  
  pod 'YYText'
  pod 'YYImage'
  pod 'SwipeCellKit'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/wowansm/Chameleon.git', :branch => 'swift5'
  pod 'CLTypingLabel'
  pod 'Charts'
  pod 'SwiftDate'
  pod 'OHMySQL'
  pod 'AliyunOSSiOS'
  pod 'Alamofire'

post_install do |installer|
  installer.pods_project.targets.each do |target|
 target.build_configurations.each do |config|
  if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
     end
   end
  end
end
end
