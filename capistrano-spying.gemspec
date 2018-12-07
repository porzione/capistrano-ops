# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-spying'
  spec.version       = '1.4.0'
  spec.authors       = ['Oleg Kravchenko']
  spec.email         = ['okravc@gmail.com']
  spec.description   = %q{Spying for Capistrano 3.x}
  spec.summary       = %q{Spying for Capistrano 3.x}
  spec.homepage      = 'https://github.com/porzione/capistrano-spying'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '~> 3.1'
  spec.add_dependency 'sshkit', '~> 1.2'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
