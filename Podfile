# Uncomment this line to define a global platform for your project
# platform :ios, ‘9.0’

 use_frameworks!





target 'BadmintonQ' do

pod 'IQKeyboardManagerSwift'

pod 'SwiftValidator', :git => 'https://github.com/jpotts18/SwiftValidator.git', :branch => 'master'

pod 'FacebookCore'
 pod 'FacebookLogin'
pod 'FacebookShare'
 


end

target 'BadmintonQTests' do
    

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

end

