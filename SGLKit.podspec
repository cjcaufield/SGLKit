Pod::Spec.new do |spec|

spec.name = "SGLKit"
spec.summary = "Simple OpenGL Framework for iOS and OSX that supports Swift, Objective-C, and Objective-C++."

spec.version = "4.0.0"

spec.ios.deployment_target = '9.0'
spec.osx.deployment_target = '10.9'

spec.requires_arc = true

spec.license = { :type => "MIT", :file => "LICENSE" }

spec.author = { "Colin Caufield" => "cjcaufield@gmail.com" }

spec.homepage = "https://github.com/cjcaufield/SGLKit"

spec.source = { :git => "https://github.com/cjcaufield/SGLKit.git", :tag => "#{spec.version}" }

spec.ios.frameworks = "UIKit", "CoreGraphics", "OpenGL", "CoreMotion", "GLKit"
spec.osx.framework = "Cocoa", "CoreGraphics", "OpenGL", "CoreVideo", "CoreServices", "GLUT", "GLKit"

spec.ios.exclude_files = "**/osx/**/*.*"
spec.osx.exclude_files = "**/ios/**/*.*"

spec.source_files = "SGLKit/**/*.{h,m,mm,swift}"

spec.public_header_files = "SGLKit/**/*.h"

spec.ios.resources = "SGLKit/**/*.{png,jpeg,jpg,storyboard,xib,glsl,vert,frag}"
spec.osx.resources = "SGLKit/**/*.{png,jpeg,jpg,xib,glsl,vert,frag}"

end
