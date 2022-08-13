# frozen_string_literal: true

require_relative "lib/dpm/version"

Gem::Specification.new do |spec|
  spec.name = "dpmrb"
  spec.version = Dpm::VERSION
  spec.authors = ["Song Huang"]
  spec.email = ["songhuangcn@gmail.com"]

  spec.summary = "Docker Package Manager."
  spec.description = "Makes using your containers as easy as package managers (`apt`, `yml`, `brew`)."
  spec.homepage = "https://github.com/songhuangcn/dpm"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = ["dpm"]
  spec.require_paths = ["lib"]

  spec.post_install_message = "Please start with `dpm help`"

  spec.add_dependency "activesupport", "~> 7.x"

end
