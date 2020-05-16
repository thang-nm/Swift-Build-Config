#
#  SwiftBuildConfig
#

Pod::Spec.new do |s|
  s.name           = 'SwiftBuildConfig'
  s.version        = '0.0.1'
  s.summary        = 'Auto-generated build config for Swift.'
  s.homepage       = 'https://github.com/thang-nm/Swift-Build-Config'
  s.license        = { type: 'MIT', file: 'LICENSE' }
  s.author         = { "Thang Nguyen" => "nm.thang@outlook.com" }
  s.source         = { http: "#{s.homepage}/releases/download/#{s.version}/SwiftBuildConfig-#{s.version}.zip" }
  s.preserve_paths = '*'
  s.exclude_files  = '**/file.zip'
end
