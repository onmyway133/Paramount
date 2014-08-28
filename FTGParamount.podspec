Pod::Spec.new do |spec|
  spec.name         = 'FTGParamount'
  spec.version      = '1.0'
  spec.license      =  { :type => 'MIT', :file => 'LICENSE.md' }
  spec.homepage     = 'https://github.com/onmyway133/FTGParamount'
  spec.authors      = { 'Khoa Pham' => 'onmyway133@gmail.com' }
  spec.summary      = 'Like Flipboard FLEX, but allows custom action.'
  spec.source       = { :git => 'https://github.com/onmyway133/FTGParamount.git', :tag => '1.0' }
  spec.source_files = 'FTGParamount/*.{h,m}'
  s.resources       = 'FTGParamount/FTGParamount.bundle'
  spec.requires_arc = true
  spec.ios.deployment_target = '6.0'
  spec.osx.deployment_target = '10.7'
  spec.social_media_url   = "https://twitter.com/onmyway133"
end