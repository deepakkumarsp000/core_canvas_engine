#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint core_canvas_engine.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'core_canvas_engine'
  s.version          = '1.0.0'
  s.summary          = 'High-performance native C++20 document and media rendering engine for Flutter FFI.'
  s.description      = <<-DESC
A high-performance native C++20 rendering engine for Flutter FFI to export PDF, PNG, JPG, WebP, HTML5, and Animated GIF from one declarative Flexbox DSL.
                       DESC
  s.homepage         = 'https://github.com/deepakkumarsp000/core_canvas_engine'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Deepak Kumar' => 'deepakkumarsp000@users.noreply.github.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '13.0'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++20',
    'CLANG_CXX_LIBRARY' => 'libc++'
  }
  s.swift_version = '5.0'
end