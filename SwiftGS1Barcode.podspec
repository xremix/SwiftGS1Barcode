Pod::Spec.new do |s|
  s.name             = 'SwiftGS1Barcode'
  s.version          = '0.5.6'
  s.summary          = 'A GS1 Barcode Library and Parser for Swift'

  s.description      = <<-DESC
A GS1 Barcode Library and Parser for Swift. It allows to pass strings and validate these as well as get the GS1 tags.
                       DESC

  s.homepage         = 'https://github.com/xremix/SwiftGS1Barcode'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Toni Hoffmann' => 'toni-hoffmann@xremix.de' }
  s.source           = { :git => 'https://github.com/xremix/SwiftGS1Barcode.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.4'
  s.source_files = 'SwiftGS1Barcode/*.swift'

end
