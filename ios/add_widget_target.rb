#!/usr/bin/env ruby

require 'xcodeproj'

project_path = File.join(__dir__, 'Runner.xcodeproj')
project = Xcodeproj::Project.open(project_path)

main_target = project.targets.find { |t| t.name == 'Runner' }
raise 'Runner target not found' unless main_target

widget_target_name = 'WeatherWidget'
existing = project.targets.find { |t| t.name == widget_target_name }
if existing
  puts "Target #{widget_target_name} already exists. Skipping."
  exit 0
end

# Create the widget extension target
widget_target = project.new_target(:application_extension, widget_target_name, :ios, 'com.apple.product-type.app-extension', nil)

# Set build settings
widget_target.build_configurations.each do |config|
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.wc.weatherCast.WeatherWidget'
  config.build_settings['INFOPLIST_FILE'] = 'WeatherWidget/Info.plist'
  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
  config.build_settings['SWIFT_VERSION'] = '5.0'
  config.build_settings['DEVELOPMENT_TEAM'] = main_target.build_configurations.first.build_settings['DEVELOPMENT_TEAM'] || ''
  config.build_settings['CODE_SIGN_STYLE'] = 'Automatic'
  config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'YES'
  config.build_settings['PRODUCT_NAME'] = '$(TARGET_NAME)'
  config.build_settings['INFOPLIST_KEY_CFBundleDisplayName'] = 'Weather Cast'
  config.build_settings['INFOPLIST_KEY_CFBundleName'] = 'WeatherWidget'
  config.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'WeatherWidget/WeatherWidgetExtension.entitlements'
end

# Add Swift source file to the widget target
group = project.main_group.find_subpath(File.join('WeatherWidget'), true)
group.set_source_tree('SOURCE_ROOT')

source_ref = group.new_file('WeatherWidget.swift')
widget_target.source_build_phase.add_file_reference(source_ref)

group.new_file('Info.plist')
group.new_file('WeatherWidgetExtension.entitlements')

# Add target dependency — Xcode auto-embeds the extension
main_target.add_dependency(widget_target)

# Ensure main target entitlements include App Groups
main_entitlements_path = File.join(__dir__, 'Runner', 'Runner.entitlements')
unless File.exist?(main_entitlements_path)
  File.write(main_entitlements_path, <<~PLIST)
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>com.apple.security.application-groups</key>
        <array>
            <string>group.com.wc.weatherCast</string>
        </array>
    </dict>
    </plist>
  PLIST
end

main_target.build_configurations.each do |config|
  config.build_settings['CODE_SIGN_ENTITLEMENTS'] ||= 'Runner/Runner.entitlements'
end

project.save

puts "Widget extension target '#{widget_target_name}' added and embedded."
puts "Open Runner.xcworkspace in Xcode, then:"
puts "  1. Select WeatherWidget target > Signing & Capabilities > set your Team"
puts "  2. Ensure both targets have App Groups capability with group.com.wc.weatherCast"
