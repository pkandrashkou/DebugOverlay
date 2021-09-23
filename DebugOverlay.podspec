Pod::Spec.new do |s|
  s.name                    = 'DebugOverlay'
  s.version                 = '0.0.1'
  s.homepage                = 'https://github.com/pkondrashkov/DebugOverlay'
  s.summary                 = 'Debug menu overlay. Just double tap the status bar.'
  s.license                 = { type: 'MIT', file: 'LICENSE.md' }
  s.author                  = { 'Pavel Kondrashkov' => 'pkondrashkov@gmail.com' }
  s.source                  = { git: 'https://github.com/pkondrashkov/DebugOverlay.git' }
  s.platform                = :ios
  s.swift_version           = '5.0'
  s.source_files            = 'DebugOverlay/**/*.{swift,h,m}'
  s.resources               = 'DebugOverlay/*.{xcassets}'
  s.ios.framework           = 'UIKit'
  s.ios.deployment_target   = '9.0.0'
end
