Pod::Spec.new do |s|
  s.name     = 'SCRefreshControl'
  s.version  = '1.0.0'
  s.platform = :ios, '5.0'
  s.summary  = 'Pull to refresh control for iOS 5 and above.'
  s.homepage = 'https://github.com/sebastiencouture/SCRefreshControl'
  s.license  = 'MIT License (http://opensource.org/licenses/MIT)'
  s.author   = { 'sebastiencouture' => 'unknown@email.com' }
  s.source   = { :git => 'https://github.com/sebastiencouture/SCRefreshControl.git', :tag => '1.0.0' }
  s.requires_arc = true
  s.source_files = 'SCRefreshControl'
  s.framework    = 'QuartzCore'
end
