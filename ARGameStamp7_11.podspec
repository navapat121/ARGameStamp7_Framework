Pod::Spec.new do |spec|
  spec.name         = "ARGameStamp7_11"
  spec.version      = "36.0.0"
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
  spec.source_files = ['AR_Game_Stamp/*.swift', 'AR_Game_Stamp/*.h']
  spec.resource = ['AR_Game_Stamp/**/ARgame.storyboard' , 
    'AR_Game_Stamp/**/Assets.xcassets', 
    'AR_Game_Stamp/Asset', 
    'AR_Game_Stamp/art.scnassets',
    #'AR_Game_Stamp/Content',
    'AR_Game_Stamp/Content/SoundEffect/**/*.{mp3,wav}',
    'AR_Game_Stamp/Asset/AR STAMP ASSET/**/*.{ttf}',
    'AR_Game_Stamp/*.xib',
    #'AR_Game_Stamp'
    ]
  #spec.resource_bundles = {
  #  'Resource' => ['AR_Game_Stamp']
  #}
  spec.dependency 'lottie-ios', '~> 3.1.8'
  spec.swift_version = "5.0"
end
