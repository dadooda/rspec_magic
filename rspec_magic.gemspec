
require_relative "lib/rspec_magic/version"

Gem::Specification.new do |s|
  s.name = "rspec_magic"
  s.summary = "A set of extensions for writing compact and expressive tests"
  s.version = RSpecMagic::VERSION

  s.authors = ["Alex Fortuna"]
  s.email = ["fortunadze@gmail.com"]
  s.homepage = "https://github.com/dadooda/rspec_magic"
  s.license = "MIT"

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.test_files = `git ls-files -- {spec}/*`.split("\n")
end
