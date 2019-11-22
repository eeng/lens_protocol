lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "vision_council/version"

Gem::Specification.new do |spec|
  spec.name          = "vision_council"
  spec.version       = VisionCouncil::VERSION
  spec.authors       = ["Emmanuel Nicolau"]
  spec.email         = ["emmanicolau@gmail.com"]

  spec.summary       = %q{VisionCouncil is a Ruby parser and builder for the OMA protocol.}
  spec.description   = %q{VisionCouncil is a Ruby parser and builder for the OMA protocol (A.K.A. Data Communication Standard) developed by the Lens Processing & Technology Division of The Vision Council}
  spec.homepage      = "https://github.com/eeng/vision_council"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard-rspec"
end
