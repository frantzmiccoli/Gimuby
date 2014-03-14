Gem::Specification.new do |spec|
  spec.name = 'gimuby'
  spec.version = '0.7.1'

  spec.authors = ['Fräntz Miccoli']
  spec.summary = 'Gimuby: genetic algorithm and island model for Ruby'
  spec.description = 'Implemented for academic purpose, Gimuby is also suitable ' +
      'for teaching purpose. As far as we know this implementation of ' +
      'genetic algorithms is the most advanced available in Ruby for it' +
      'integrates an implementation of the island model, reusable ' +
      'patterns for user problem composition and optimal configuration ' +
      'genetic algorithm' + "\n" +
      'Gimuby contains the implementation of standard genetic ' +
      'algorithm (named population) and distributed genetic algorithm or ' +
      'island model (named archipelago).' + "\n" +
      'The presented archipelago are NOT distributed (nor with threads, ' +
      'process, or physical machine). However they let the user benefits of' +
      'the leverage they represent to obtain a better solution with the same ' +
      'amount of resources spent.' + "\n" +
      'Similar to: AI4R, gga4r and darwinning'
  spec.homepage = 'https://frantzmiccoli.github.io/Gimuby'

  spec.files = Dir['{lib}/**/*', '[A-Z]*', 'LICENSE.md']
  spec.require_paths = ['lib']
  spec.test_files = Dir.glob('test/**/test_*.rb')

  spec.required_ruby_version = '~> 1.8'
  spec.license = 'MIT'

end