lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lens_protocol/version"

Gem::Specification.new do |spec|
  spec.name          = "lens_protocol"
  spec.version       = LensProtocol::VERSION
  spec.authors       = ["Emmanuel Nicolau"]
  spec.email         = ["emmanicolau@gmail.com"]

  spec.summary       = %q{LensProtocol is a Ruby parser and builder for the OMA protocol.}
  spec.description   = %q{A Ruby parser and builder for the OMA protocol (a.k.a. Data Communication Standard) that was developed by the Lens Processing & Technology Division of The Vision Council for interconnection of optical laboratory equipment.}
  spec.homepage      = "https://github.com/eeng/lens_protocol"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '>= 4.0'
  spec.add_dependency 'nokogiri'
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'sinatra'
  spec.add_development_dependency 'rubocop', '~> 0.80.0'
end
