Gem::Specification.new do |s|
  s.name = "pry-debundle"
  s.version = "0.3"
  s.platform = Gem::Platform::RUBY
  s.author = "Conrad Irwin"
  s.email = "conrad.irwin@gmail.com"
  s.license = "MIT"
  s.homepage = "http://github.com/ConradIrwin/pry-debundle"
  s.summary = "Allows you to use gems not in your Gemfile from Pry."
  s.description = "Hooks into Pry and removes the restrictions on loading gems imposed by Bundler only when you're running in interactive mode."
  s.files = `git ls-files`.split("\n")
  s.require_path = "lib"
  s.add_dependency 'pry'
end
