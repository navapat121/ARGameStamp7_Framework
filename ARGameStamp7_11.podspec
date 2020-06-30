Pod::Spec.new do |spec|
  spec.name         = "ARGameStamp7_11"
  spec.version      = "1.0.0"
  spec.summary      = "ARGame stamp 7-11"
  spec.description  = <<-DESC 
ARStamp Game Framework for connect with Main 7-11 Application
DESC
  spec.homepage     = "https://appcoda.com"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Navapat_J" => "Navapat121@gmail.com" }
  spec.platform     = :ios, "10.0"
  spec.source       = { :http => 'file:' + __dir__ + "/" }
  # spec.source       = { :git => "https://github.com/navapat121/ARGameStamp7_Framework.git", :tag => "#{spec.version}" }
  spec.source_files = "AR_Game_Stamp/*.{swift}"
  spec.swift_version = "5.0"
end
