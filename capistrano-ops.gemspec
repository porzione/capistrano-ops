lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/ops/version'

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-ops'
  spec.version       = '1.4.0'
  spec.authors       = ['Oleg Kravchenko']
  spec.email         = ['okravc@gmail.com']

  spec.description   = 'Ops for Capistrano 3.x'
  spec.summary       = 'Ops for Capistrano 3.x'
  spec.homepage      = 'https://github.com/porzione/capistrano-ops'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section
  # to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'TODO: Put your gem public repo URL here'
    spec.metadata['changelog_uri'] = 'TODO: Put your gem CHANGELOG.md URL here'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '~> 3.1'
  spec.add_dependency 'sshkit', '~> 1.2'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  # spec.add_development_dependency 'minitest', '~> 5.0'
end