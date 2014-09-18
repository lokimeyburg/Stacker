Pod::Spec.new do |s|
  s.name             = "LMStacker"
  s.version          = "0.0.1"
  s.summary          = "Stacker is an iOS view-controller to kickstart development of hybrid native/web iOS apps"
  s.description      = <<-DESC
                        Stacker is an iOS view-controller to kickstart development of hybrid native/web iOS apps.
                        Stacker was built to keep your navigation native while the rest of your app is driven by webviews
                       DESC
  s.homepage         = "http://www.lokimeyburg.com/Stacker/"
  s.license          = 'MIT'
  s.author           = { "lokimeyburg" => "loki@lokimeyburg.com" }
  s.source           = { :git => "https://github.com/lokimeyburg/Stacker.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lokimeyburg'

  s.requires_arc = true
  s.platform     = :ios, "6.0"
  s.source_files = 'Lib/*.{h,m}'
  s.resources    = 'Assets/*.{html}'

  s.dependency "UIDevice-Hardware", "~> 0.1.3"
  s.dependency "HexColors", "~> 2.2.1"
  s.dependency "WebViewJavascriptBridge", "~> 4.1.4"  
end
