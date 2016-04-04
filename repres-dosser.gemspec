$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'repres/dosser/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'repres-dosser'
  spec.version     = Repres::Dosser::VERSION
  spec.authors     = [ 'Topbit Du' ]
  spec.email       = [ 'topbit.du@gmail.com' ]
  spec.homepage    = 'https://github.com/topbitdu/repres-dosser'
  spec.summary     = 'Dosser Resource Presentation Engine 领域特定语意表现资源表现引擎'
  spec.description = 'Repres (REsource PRESentation) is a series of resource presentation engines. The Dosser (DOmain-Specific SEmantic Representation) resource presentation engine includes JSON and XML resource presentation templates. Repres (资源表现)是一系列的资源表现引擎。Dosser (领域特定语意表现) 资源表现引擎包括JSON和XML表现模版。'
  spec.license     = 'MIT'

  spec.files         = Dir[ '{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md' ]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = [ 'lib' ]

  spec.add_dependency 'rails', '~> 4.2'

end
