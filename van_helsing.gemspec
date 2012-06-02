require './lib/van_helsing/version'

Gem::Specification.new do |s|
  s.name = "van_helsing"
  s.version = VanHelsing.version
  s.summary = %{Really fast deployer and server automation tool.}
  s.description = %Q{Builds scripts."}
  s.authors = ["Rico Sta. Cruz", "Michael Galero"]
  s.email = ["rico@nadarei.co", "mikong@nadarei.co"]
  s.homepage = "http://github.com/nadarei/van_helsing"
  s.files = `git ls-files`.strip.split("\n")
  s.executables = Dir["bin/*"].map { |f| File.basename(f) }

  s.add_dependency "rake"
  s.add_development_dependency "rspec"
end
