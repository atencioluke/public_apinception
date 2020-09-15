require_relative 'lib/public_apinception/version'

Gem::Specification.new do |spec|
  spec.name          = "public_apinception"
  spec.version       = PublicApinception::VERSION
  spec.authors       = ["Luke Atencio"]
  spec.email         = ["atencioluke@gmail.com"]

  spec.summary       = %q{This gem allows you to search through Public APIs for project ideas!}
  spec.description   = %q{Sometimes you want to start a project involving an API, but you don't want to mess around with getting a key. This is where Public APInception saves the day! Using the Public APIs API, you can search for exactly what kind of free, public API you need!}
  spec.homepage      = "https://github.com/atencioluke/public_apinception"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/atencioluke/public_apinception"
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = ["public_apinception"]
  # spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "tty-prompt"
end