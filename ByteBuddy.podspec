Pod::Spec.new do |spec|
  spec.name                  = "ByteBuddy"
  spec.version               = "0.0.2"
  spec.summary               = "Automate Testing for Swift Memory Issues."

  spec.homepage              = "https://github.com/dzhamall/ByteBuddy"
  spec.license               = { :type => "MIT", :file => "LICENSE" }
  spec.author                = { "Dzhamall" => "dzhamall@icloud.com" }

  spec.ios.deployment_target = "15.0"
  spec.swift_version         = "5.0"

  spec.source                = { :git => "https://github.com/dzhamall/ByteBuddy.git", :tag => "#{spec.version}" }
  spec.vendored_frameworks   = "ByteBuddy.xcframework"
  spec.preserve_paths        = "bin/CLTExecutor"

end
