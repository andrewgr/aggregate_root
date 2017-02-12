Gem::Specification.new do |gem|
  gem.authors       = ['Andrei Gridnev']
  gem.email         = ['andrew.gridnev@gmail.com']
  gem.description   = 'Minimal implementation of aggregate root pattern'
  gem.summary       = 'Minimal aggregate root implementation'
  gem.homepage      = 'https://github.com/andrewgr/potoroo/'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($ORS)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.name          = 'potoroo'
  gem.require_paths = ['lib']
  gem.version       = '0.1'

  gem.add_development_dependency 'rspec'
end
