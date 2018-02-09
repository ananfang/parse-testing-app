# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'ParseTesting' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ParseTesting
  pod 'Parse'
  pod 'ParseLiveQuery'
  
  # Hooks  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if target.name == 'Bolts-Swift'
          config.build_settings['SWIFT_VERSION'] = 3.0
        end
      end
    end
  end

  target 'ParseTestingTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ParseTestingUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
