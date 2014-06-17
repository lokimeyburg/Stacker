Pod::Spec.new do |s|
  s.name             = "LMStacker"
  s.version          = "0.0.1"
  s.summary          = "Stacker is an iOS view-controller to kickstart development of hybrid native/web iOS apps"
  s.description      = <<-DESC
                        Stacker is an iOS view-controller to kickstart development of hybrid native/web iOS apps.
                        Stacker was built to keep your navigation native while the rest of your app is driven by webviews
                       DESC
  s.homepage         = "https://github.com/lokimeyburg/Stacker"
  s.license          = 'MIT'
  s.author           = { "lokimeyburg" => "loki@aristolabs.com" }
  s.source           = { :git => "https://github.com/lokimeyburg/Stacker.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lokimeyburg'

  s.requires_arc = true
  s.platform     = :ios
  s.source_files = 'Lib/**/*.{h,m}'
  s.resources    = 'Assets/*.html'
end
