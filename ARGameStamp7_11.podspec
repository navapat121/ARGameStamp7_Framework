Pod::Spec.new do |spec|
  spec.name         = "ARGameStamp7_11"
  spec.version      = "1.0.0"
  spec.summary      = "ARGame stamp 7-11"
  spec.description  = <<-DESC 
ARStamp Game Framework for connect with Main 7-11 Application
DESC
  spec.homepage     = "https://appcoda.com"
  spec.license      = "MIT"
  spec.author       = { "Navapat_J" => "Navapat121@gmail.com" }
  spec.platform     = :ios, "10.0"
  #spec.source       = { :http => 'file:' + __dir__ + "/" }
  spec.source       = { :git => "https://github.com/navapat121/ARGameStamp7_Framework.git", :tag => "1.0.0" }
  spec.source_files = "AR_Game_Stamp"
  spec.resource_bundles = {
    'ARGameStamp7_11' => ['AR_Game_Stamp']
  }
  spec.dependency 'lottie-ios', '~> 3.1.8'
  spec.dependency 'SwiftyJSON', '~> 4.0'
  spec.swift_version = "5.0"
end