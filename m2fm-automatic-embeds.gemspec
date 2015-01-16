# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'm2fm-automatic-embed'
  spec.version       = '0.0.3'
  spec.authors       = ['Kunal Shah']
  spec.email         = ['me@kunalashah.com']
  spec.summary       = %q{mail2frontmatter plugin to transform links into embed code automatically}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/whistlerbrk/m2fm-automatic-embeds'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'mail2frontmatter', '>= 0.0.5'
  spec.add_dependency 'auto_html-whistlerbrk', '2.0.0.pre'

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
end
